import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:fastwork_core/data/database.dart';

import 'code_sender.dart';

/// Ошибка, которую можно показать человеку.
class AuthError implements Exception {
  final String message;
  final int status;

  AuthError(this.message, {this.status = 400});

  @override
  String toString() => message;
}

/// Вход по коду с почты и выдача токенов.
class AuthService {
  final AppDatabase db;
  final CodeSender sender;
  final _random = Random.secure();

  AuthService(this.db, this.sender);

  /// Сколько живёт код. Пять минут — компромисс: успеть открыть почту,
  /// но не оставлять подобранный код работать до завтра.
  static const codeLifetime = Duration(minutes: 5);

  /// Сколько раз можно ошибиться, прежде чем код сгорит.
  /// Без этого шестизначный код перебирается за вечер.
  static const maxAttempts = 3;

  /// Сколько кодов можно запросить на одну почту за час.
  /// Без этого чужой почтовый ящик можно завалить письмами, а на платной
  /// рассылке — ещё и разорить владельца сервера.
  static const maxCodesPerHour = 5;

  // ---------------------------------------------------------------------
  // Коды
  // ---------------------------------------------------------------------

  /// Отпечаток кода.
  ///
  /// В базу кладём именно его. Почта подмешана в исходную строку, чтобы
  /// одинаковые коды у разных людей давали разные отпечатки — иначе по
  /// совпадению отпечатков можно было бы догадаться о коде.
  static String _hash(String email, String code) =>
      sha256.convert(utf8.encode('$email:$code')).toString();

  String _generateCode() =>
      List.generate(6, (_) => _random.nextInt(10)).join();

  /// Простейшая проверка, что это вообще похоже на адрес почты.
  static bool looksLikeEmail(String value) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);

  static String normalize(String email) => email.trim().toLowerCase();

  /// Выслать код на почту.
  Future<String> requestCode(String rawEmail) async {
    final email = normalize(rawEmail);
    if (!looksLikeEmail(email)) {
      throw AuthError('Проверьте адрес почты');
    }

    final now = DateTime.now();
    final hourAgo = now.subtract(const Duration(hours: 1));

    // Убираем совсем старые записи — они уже ни на что не влияют.
    await (db.delete(db.authCodeRows)
          ..where((c) => c.createdAt.isSmallerThanValue(hourAgo)))
        .go();

    final recent = await db.customSelect(
      '''
      SELECT COUNT(*) AS c FROM auth_code_rows
      WHERE email = ? AND created_at > ?
      ''',
      variables: [
        Variable.withString(email),
        Variable.withDateTime(hourAgo),
      ],
      readsFrom: {db.authCodeRows},
    ).getSingle();

    if (recent.read<int>('c') >= maxCodesPerHour) {
      throw AuthError(
        'Слишком много запросов. Попробуйте через час.',
        status: 429,
      );
    }

    // Прежние коды этой почты гасим, но **не удаляем**.
    //
    // Сначала я их удалял — и ограничение на частоту перестало работать:
    // оно считает записи за последний час, а считать было нечего.
    // Погашенный код не подойдёт (у него истёк срок), зато остаётся
    // следом в истории запросов.
    await (db.update(db.authCodeRows)..where((c) => c.email.equals(email)))
        .write(AuthCodeRowsCompanion(expiresAt: Value(now)));

    final code = _generateCode();
    await db.into(db.authCodeRows).insert(
          AuthCodeRowsCompanion.insert(
            email: email,
            codeHash: _hash(email, code),
            createdAt: now,
            expiresAt: now.add(codeLifetime),
          ),
        );

    await sender.send(email, code);
    return sender.name;
  }

  /// Проверить код. Возвращает подтверждённую почту.
  Future<String> verifyCode(String rawEmail, String code) async {
    final email = normalize(rawEmail);

    final row = await (db.select(db.authCodeRows)
          ..where((c) => c.email.equals(email))
          ..orderBy([(c) => OrderingTerm.desc(c.createdAt)])
          ..limit(1))
        .getSingleOrNull();

    if (row == null) {
      throw AuthError('Сначала запросите код');
    }
    if (DateTime.now().isAfter(row.expiresAt)) {
      throw AuthError('Код устарел, запросите новый');
    }

    if (row.codeHash != _hash(email, code)) {
      final used = row.attempts + 1;
      if (used >= maxAttempts) {
        // Гасим срок вместо удаления — по той же причине, что и выше:
        // иначе сжиганием кодов можно было бы обнулять счётчик запросов.
        await (db.update(db.authCodeRows)..where((c) => c.id.equals(row.id)))
            .write(AuthCodeRowsCompanion(
          attempts: Value(used),
          expiresAt: Value(DateTime.now()),
        ));
        throw AuthError('Код неверный. Попытки кончились, запросите новый');
      }
      await (db.update(db.authCodeRows)..where((c) => c.id.equals(row.id)))
          .write(AuthCodeRowsCompanion(attempts: Value(used)));
      throw AuthError('Код неверный. Осталось попыток: ${maxAttempts - used}');
    }

    // Код одноразовый: подошёл — и больше не действует.
    await (db.update(db.authCodeRows)..where((c) => c.id.equals(row.id)))
        .write(AuthCodeRowsCompanion(expiresAt: Value(DateTime.now())));
    return email;
  }

  // ---------------------------------------------------------------------
  // Токены
  // ---------------------------------------------------------------------

  /// Случайная строка из 32 символов.
  ///
  /// `Random.secure()` — генератор, который нельзя предсказать. Для
  /// токенов и паролей нужен именно он, обычный `Random` не годится.
  String _generateToken() {
    const alphabet =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      32,
      (_) => alphabet[_random.nextInt(alphabet.length)],
    ).join();
  }

  /// Выдать токен. `userId` пустой — почта подтверждена, аккаунта ещё нет.
  Future<String> issue({required String email, int? userId}) async {
    final token = _generateToken();
    await db.into(db.authTokenRows).insert(
          AuthTokenRowsCompanion.insert(
            token: token,
            email: email,
            userId: Value(userId),
            createdAt: DateTime.now(),
          ),
        );
    return token;
  }

  /// Что стоит за токеном.
  Future<AuthTokenRow?> lookup(String token) =>
      (db.select(db.authTokenRows)..where((t) => t.token.equals(token)))
          .getSingleOrNull();

  /// Привязать токен к созданному аккаунту.
  Future<void> bind(String token, int userId) async {
    await (db.update(db.authTokenRows)..where((t) => t.token.equals(token)))
        .write(AuthTokenRowsCompanion(userId: Value(userId)));
  }

  Future<void> revoke(String token) async {
    await (db.delete(db.authTokenRows)..where((t) => t.token.equals(token)))
        .go();
  }
}
