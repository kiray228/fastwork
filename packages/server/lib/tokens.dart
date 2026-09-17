import 'dart:math';


import 'package:fastwork_core/data/database.dart';

/// Кто есть кто: выдача и проверка токенов.
///
/// Токен — это длинная случайная строка, которую сервер выдаёт при входе.
/// Дальше приложение прикладывает её к каждому запросу, и сервер по ней
/// понимает, кто спрашивает.
///
/// Почему не присылать просто номер пользователя? Потому что его легко
/// подделать: написал чужой номер — и ты уже кто-то другой. Токен угадать
/// нельзя: он случайный и длинный.
///
/// Честно скажу, чего здесь НЕТ по сравнению с настоящим приложением:
/// токен не протухает, его нельзя отозвать по одному, и вход не защищён
/// SMS-кодом — назвал номер, и ты внутри. Для учебного проекта это
/// осознанное упрощение, для боевого — нет.
class Tokens {
  final AppDatabase db;
  final _random = Random.secure();

  Tokens(this.db);

  /// Ключ в таблице настроек. Токены лежат в базе, а не в памяти сервера:
  /// иначе при каждой перезагрузке все бы «вылетали» из аккаунта.
  static String _key(String token) => 'token:$token';

  /// Случайная строка из 32 символов.
  ///
  /// `Random.secure()` — это не обычный генератор случайных чисел, а тот,
  /// который нельзя предсказать. Для паролей и токенов нужен именно он.
  String _generate() {
    const alphabet =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      32,
      (_) => alphabet[_random.nextInt(alphabet.length)],
    ).join();
  }

  /// Выдать токен пользователю.
  Future<String> issue(int userId) async {
    final token = _generate();
    await db.into(db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: _key(token), value: '$userId'),
        );
    return token;
  }

  /// Чей это токен. null — такого токена нет.
  Future<int?> userIdFor(String token) async {
    final row = await (db.select(db.appSettings)
          ..where((s) => s.key.equals(_key(token))))
        .getSingleOrNull();
    return row == null ? null : int.tryParse(row.value);
  }

  /// Забыть токен — это и есть выход из аккаунта.
  Future<void> revoke(String token) async {
    await (db.delete(db.appSettings)..where((s) => s.key.equals(_key(token))))
        .go();
  }
}
