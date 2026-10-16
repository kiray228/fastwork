import 'package:drift/drift.dart';

import '../errors.dart';
import '../shift.dart' show formatMoney;
import '../terms.dart';
import '../user.dart';
import 'database.dart';
import '../l10n/core_strings.dart';

/// Что умеет хранилище пользователей. Экраны знают только это описание.
abstract class AuthRepository {
  /// Нужен ли код с почты, чтобы войти.
  ///
  /// На сервере — да: он не знает, кто к нему обращается, и должен
  /// убедиться, что почта действительно твоя.
  ///
  /// На своём устройстве — нет: база и так лежит в твоём телефоне, и
  /// проверять некого. Отправлять письма оттуда всё равно нечем.
  ///
  /// Экран входа спрашивает это и показывает либо один шаг, либо три.
  bool get requiresEmailCode;

  /// Отправить код на почту. Только когда `requiresEmailCode` истинно.
  Future<void> requestCode(String email);

  /// Проверить код.
  ///
  /// Вернёт пользователя, если аккаунт с такой почтой уже есть.
  /// Вернёт `null`, если почта подтверждена, но аккаунта ещё нет —
  /// значит, дальше анкета.
  Future<AppUser?> verifyCode(String email, String code);

  /// Кто вошёл в прошлый раз. null — никто, надо показать вход.
  Future<AppUser?> restoreSession();

  /// Найти пользователя по телефону — вход без кода, для работы
  /// на своём устройстве.
  Future<AppUser?> findByPhone(String phone);

  /// Создать нового пользователя и сразу войти под ним.
  ///
  /// `acceptedTermsVersion` — какую версию правил человек принял на экране
  /// регистрации. Без действующей версии аккаунт не создаётся: согласие
  /// с правилами — условие работы, а не галочка для вида.
  Future<AppUser> register({
    required String phone,
    required String fullName,
    required String city,
    required int acceptedTermsVersion,
    String? email,
    String role = UserRole.worker,
    String? company,
  });

  /// Принять действующие правила — для тех, кто зарегистрировался раньше,
  /// чем они появились или поменялись.
  Future<AppUser?> acceptTerms(int userId);

  /// Запомнить, что вошёл этот пользователь.
  Future<void> signIn(AppUser user);

  /// Выйти.
  Future<void> signOut();

  /// Выйти на всех устройствах: погасить все входы этого человека.
  /// На своём устройстве других входов нет — это обычный выход.
  Future<void> signOutEverywhere();

  /// Перечитать пользователя из базы — например, после новой смены.
  Future<AppUser?> refresh(int userId);

  /// Сменить город. От него зависит, какие смены человек видит.
  Future<AppUser?> changeCity(int userId, String city);

  /// Исправить имя. Опечатка при регистрации иначе оставалась бы навсегда:
  /// имя видит заказчик в списке записавшихся и в отзывах.
  Future<AppUser?> changeName(int userId, String fullName);

  /// Удалить аккаунт.
  ///
  /// Магазины приложений требуют, чтобы аккаунт можно было удалить из
  /// самого приложения. Но у нас за аккаунтом деньги и обязательства,
  /// поэтому сначала их нужно закрыть: живые записи на смены, свои
  /// предстоящие смены, остаток на балансе. Иначе — отказ с причиной.
  ///
  /// Удаление — обезличивание, а не стирание строки: история денег и
  /// отработанных смен нужна для учёта, отзывы — другим людям. Имя,
  /// телефон, почта, документы, подписки и входы исчезают.
  Future<void> deleteAccount(int userId);
}

/// Ключ, под которым в настройках лежит номер вошедшего пользователя.
const _sessionKey = 'current_user_id';

class DbAuthRepository implements AuthRepository {
  final AppDatabase db;

  DbAuthRepository(this.db);

  /// На своём устройстве кодов нет: проверять некого и отправлять нечем.
  @override
  bool get requiresEmailCode => false;

  @override
  Future<void> requestCode(String email) async {
    throw UnsupportedError(coreTr.emailCodesNeedServer);
  }

  @override
  Future<AppUser?> verifyCode(String email, String code) async {
    throw UnsupportedError(coreTr.emailCodesNeedServer);
  }

  Future<AppUser> _toUser(UserRow row) async {
    // Сколько смен отработано — считаем запросом, а не храним в колонке.
    //
    // Считаем только подтверждённые заказчиком. Раньше здесь было
    // «запись жива и дата прошла», и это завышало счётчик: записался,
    // не пришёл — а смена всё равно засчитывалась.
    // Одним запросом считаем и выходы, и невыходы: две пробежки по той же
    // таблице ради двух чисел — лишняя работа.
    //
    // CAST и COALESCE не для красоты: SUM по пустому набору строк даёт
    // NULL, а не ноль, и у новичка счётчик был бы «ничего», а не «ноль».
    final rows = await db.query(
      '''
      SELECT
        CAST(COALESCE(SUM(CASE WHEN a.status = 'completed'
                               THEN 1 ELSE 0 END), 0) AS INTEGER) AS c,
        CAST(COALESCE(SUM(CASE WHEN a.status = 'no_show'
                               THEN 1 ELSE 0 END), 0) AS INTEGER) AS missed
      FROM application_rows a
      WHERE a.worker_id = ?
      ''',
      variables: [Variable.withInt(row.id)],
      readsFrom: {db.applicationRows},
    ).get();

    // А вот и главное изменение: рейтинг больше не берётся из колонки.
    //
    // Колонка `rating` осталась, но теперь она значит «стартовый рейтинг»:
    // им пользуемся, пока о человеке нет ни одного отзыва. Как только
    // заказчики начали ставить оценки — рейтинг считается по ним.
    //
    // Так рейтинг физически не может разойтись с отзывами: он и есть
    // отзывы, свёрнутые в одно число.
    // CAST здесь не украшение. SQLite вернёт среднее обычным числом,
    // а PostgreSQL — «точным» типом, который драйвер отдаёт строкой,
    // и чтение как числа падает. Приведение делает ответ одинаковым
    // в обеих базах.
    final rating = await db.query(
      '''
      SELECT CAST(AVG(rating) AS DOUBLE PRECISION) AS avg_rating,
             COUNT(*) AS cnt
      FROM worker_review_rows
      WHERE worker_id = ?
      ''',
      variables: [Variable.withInt(row.id)],
      readsFrom: {db.workerReviewRows},
    ).getSingle();

    return AppUser(
      id: row.id,
      phone: row.phone,
      email: row.email,
      fullName: row.fullName,
      city: row.city,
      rating: rating.readNullable<double>('avg_rating') ?? row.rating,
      ratingCount: rating.read<int>('cnt'),
      isVerified: row.isVerified,
      role: row.role,
      company: row.company,
      completedShifts: rows.first.read<int>('c'),
      noShows: rows.first.read<int>('missed'),
      termsVersion: row.termsVersion,
    );
  }

  @override
  Future<AppUser?> restoreSession() async {
    final setting = await (db.select(db.appSettings)
          ..where((s) => s.key.equals(_sessionKey)))
        .getSingleOrNull();
    if (setting == null) return null;

    final id = int.tryParse(setting.value);
    if (id == null) return null;
    return refresh(id);
  }

  @override
  Future<AppUser?> refresh(int userId) async {
    final row = await (db.select(db.userRows)
          ..where((u) => u.id.equals(userId)))
        .getSingleOrNull();
    return row == null ? null : _toUser(row);
  }

  @override
  Future<AppUser?> findByPhone(String phone) async {
    final row = await (db.select(db.userRows)
          ..where((u) => u.phone.equals(phone)))
        .getSingleOrNull();
    return row == null ? null : _toUser(row);
  }

  @override
  Future<AppUser> register({
    required String phone,
    required String fullName,
    required String city,
    required int acceptedTermsVersion,
    String? email,
    String role = UserRole.worker,
    String? company,
  }) async {
    requireCurrentTerms(acceptedTermsVersion);
    final now = DateTime.now();
    final id = await db.into(db.userRows).insert(
          UserRowsCompanion.insert(
            phone: phone,
            email: Value(email),
            fullName: fullName,
            city: city,
            role: Value(role),
            company: Value(company),
            createdAt: now,
            termsVersion: Value(acceptedTermsVersion),
            termsAcceptedAt: Value(now),
          ),
        );

    final user = (await refresh(id))!;
    await signIn(user);
    return user;
  }

  @override
  Future<AppUser?> acceptTerms(int userId) async {
    await (db.update(db.userRows)..where((u) => u.id.equals(userId)))
        .write(UserRowsCompanion(
      termsVersion: const Value(kTermsVersion),
      termsAcceptedAt: Value(DateTime.now()),
    ));
    return refresh(userId);
  }

  @override
  Future<AppUser?> changeCity(int userId, String city) async {
    await (db.update(db.userRows)..where((u) => u.id.equals(userId)))
        .write(UserRowsCompanion(city: Value(city)));
    return refresh(userId);
  }

  @override
  Future<AppUser?> changeName(int userId, String fullName) async {
    final name = checkedFullName(fullName);
    await (db.update(db.userRows)..where((u) => u.id.equals(userId)))
        .write(UserRowsCompanion(fullName: Value(name)));
    return refresh(userId);
  }

  @override
  Future<void> deleteAccount(int userId) async {
    await deleteAccountIn(db, userId);
    await signOut();
  }

  @override
  Future<void> signIn(AppUser user) async {
    await db.into(db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: _sessionKey,
            value: '${user.id}',
          ),
        );
  }

  @override
  Future<void> signOutEverywhere() => signOut();

  @override
  Future<void> signOut() async {
    await (db.delete(db.appSettings)
          ..where((s) => s.key.equals(_sessionKey)))
        .go();
  }
}

/// Пользователи в памяти — для тестов.
class FakeAuthRepository implements AuthRepository {
  final List<AppUser> _users = [];
  AppUser? _current;
  int _nextId = 1;

  /// Тестам код не нужен — но при желании можно включить и проверить
  /// трёхшаговый вход, не поднимая сервер.
  @override
  final bool requiresEmailCode;

  /// Какой код считать верным. Настоящий приходит письмом, в тестах
  /// договариваемся заранее.
  final String expectedCode;

  String? lastRequestedEmail;

  @override
  Future<void> requestCode(String email) async {
    lastRequestedEmail = email;
  }

  @override
  Future<AppUser?> verifyCode(String email, String code) async {
    if (code != expectedCode) {
      throw StateError(coreTr.wrongLoginCode);
    }
    for (final u in _users) {
      if (u.email == email) {
        _current = u;
        return u;
      }
    }
    return null;
  }

  FakeAuthRepository({
    AppUser? signedIn,
    this.requiresEmailCode = false,
    this.expectedCode = '111111',
  }) {
    if (signedIn != null) {
      _users.add(signedIn);
      _current = signedIn;
      _nextId = signedIn.id + 1;
    }
  }

  @override
  Future<AppUser?> restoreSession() async => _current;

  @override
  Future<AppUser?> refresh(int userId) async {
    for (final u in _users) {
      if (u.id == userId) return u;
    }
    return null;
  }

  @override
  Future<AppUser?> findByPhone(String phone) async {
    for (final u in _users) {
      if (u.phone == phone) return u;
    }
    return null;
  }

  @override
  Future<AppUser> register({
    required String phone,
    required String fullName,
    required String city,
    required int acceptedTermsVersion,
    String? email,
    String role = UserRole.worker,
    String? company,
  }) async {
    requireCurrentTerms(acceptedTermsVersion);
    final user = AppUser(
      id: _nextId++,
      phone: phone,
      email: email,
      fullName: fullName,
      city: city,
      rating: 4.0,
      isVerified: false,
      role: role,
      company: company,
      termsVersion: acceptedTermsVersion,
    );
    _users.add(user);
    _current = user;
    return user;
  }

  @override
  Future<AppUser?> changeCity(int userId, String city) async {
    for (var i = 0; i < _users.length; i++) {
      if (_users[i].id != userId) continue;
      final old = _users[i];
      final updated = AppUser(
        id: old.id,
        phone: old.phone,
        email: old.email,
        fullName: old.fullName,
        city: city,
        rating: old.rating,
        isVerified: old.isVerified,
        role: old.role,
        company: old.company,
        completedShifts: old.completedShifts,
        ratingCount: old.ratingCount,
        noShows: old.noShows,
        termsVersion: old.termsVersion,
      );
      _users[i] = updated;
      if (_current?.id == userId) _current = updated;
      return updated;
    }
    return null;
  }

  @override
  Future<AppUser?> acceptTerms(int userId) async {
    for (var i = 0; i < _users.length; i++) {
      if (_users[i].id != userId) continue;
      _users[i] = _users[i].copyWith(termsVersion: kTermsVersion);
      if (_current?.id == userId) _current = _users[i];
      return _users[i];
    }
    return null;
  }

  @override
  Future<void> signIn(AppUser user) async => _current = user;

  @override
  Future<void> signOut() async => _current = null;

  @override
  Future<void> signOutEverywhere() => signOut();

  @override
  Future<AppUser?> changeName(int userId, String fullName) async {
    final name = checkedFullName(fullName);
    final i = _users.indexWhere((u) => u.id == userId);
    if (i < 0) return null;
    _users[i] = _users[i].copyWith(fullName: name);
    if (_current?.id == userId) _current = _users[i];
    return _users[i];
  }

  @override
  Future<void> deleteAccount(int userId) async {
    _users.removeWhere((u) => u.id == userId);
    if (_current?.id == userId) _current = null;
  }
}

/// Отказ создать аккаунт без согласия с действующими правилами.
///
/// Проверка стоит в хранилище, а не только на экране: галочку на экране
/// можно обойти, отправив запрос напрямую, а хранилище обойти нельзя.
void requireCurrentTerms(int acceptedVersion) {
  if (acceptedVersion < kTermsVersion) {
    throw TermsNotAccepted();
  }
}

class TermsNotAccepted extends UserError {
  TermsNotAccepted() : super(coreTr.termsNotAccepted);
}

/// Удалить аккаунт в базе — общее для телефона и сервера.
///
/// Отдельной функцией, а не только методом хранилища: сервер вызывает её
/// от имени того, кто прислал запрос, а входы, которые нужно погасить,
/// лежат в той же базе.
Future<void> deleteAccountIn(
  AppDatabase db,
  int userId, {
  DateTime? now,
  CoreStrings? strings,
}) async {
  final t = strings ?? coreTr;
  final at = now ?? DateTime.now();

  // Смена ещё не кончилась — у неё есть конец; у ночной он завтра. Берём
  // со вчерашнего дня и досчитываем в Dart, как в «Моих сменах».
  final yesterday =
      Variable.withDateTime(DateTime(at.year, at.month, at.day - 1));
  bool running(QueryRow r) {
    final d = r.read<DateTime>('work_date');
    final start = r.read<int>('start_minutes');
    final end = r.read<int>('end_minutes');
    final length = end > start ? end - start : 1440 - start + end;
    final ends = DateTime(d.year, d.month, d.day)
        .add(Duration(minutes: start + length));
    return at.isBefore(ends);
  }

  final booked = await db.query(
    'SELECT s.work_date, s.start_minutes, s.end_minutes '
    'FROM application_rows a JOIN shift_rows s ON s.id = a.shift_id '
    "WHERE a.worker_id = ? AND a.status = 'active' "
    'AND s.cancelled_at IS NULL AND s.work_date >= ?',
    variables: [Variable.withInt(userId), yesterday],
    readsFrom: {db.applicationRows, db.shiftRows},
  ).get();
  if (booked.any(running)) throw UserError(t.accountHasBookings);

  final own = await db.query(
    'SELECT s.work_date, s.start_minutes, s.end_minutes FROM shift_rows s '
    'WHERE s.created_by = ? AND s.cancelled_at IS NULL AND s.work_date >= ?',
    variables: [Variable.withInt(userId), yesterday],
    readsFrom: {db.shiftRows},
  ).get();
  if (own.any(running)) throw UserError(t.accountHasShifts);

  // Остаток — заработанное минус выведенное, как в кошельке.
  final money = await db.query(
    'SELECT COALESCE(SUM(amount), 0) AS balance FROM wallet_entry_rows '
    "WHERE user_id = ? AND kind IN ('earning', 'withdrawal')",
    variables: [Variable.withInt(userId)],
    readsFrom: {db.walletEntryRows},
  ).getSingle();
  final balance = money.read<int>('balance');
  if (balance > 0) throw UserError(t.accountHasBalance(formatMoney(balance)));

  final user = await (db.select(db.userRows)
        ..where((u) => u.id.equals(userId)))
      .getSingleOrNull();
  if (user == null) return;

  await db.transaction(() async {
    // Входы гасим первыми: удалённый аккаунт не должен работать ни
    // минуты, даже на другом телефоне.
    await (db.delete(db.authTokenRows)..where((x) => x.userId.equals(userId)))
        .go();
    if (user.email != null) {
      await (db.delete(db.authCodeRows)
            ..where((x) => x.email.equals(user.email!)))
          .go();
    }
    // Номера удостоверений и медкнижек — самое чувствительное.
    await (db.delete(db.documentRows)..where((x) => x.userId.equals(userId)))
        .go();
    final tickets = db.selectOnly(db.supportTicketRows)
      ..addColumns([db.supportTicketRows.id])
      ..where(db.supportTicketRows.userId.equals(userId));
    await (db.delete(db.supportMessageRows)
          ..where((x) => x.ticketId.isInQuery(tickets)))
        .go();
    await (db.delete(db.supportTicketRows)
          ..where((x) => x.userId.equals(userId)))
        .go();
    await (db.delete(db.favoriteRows)
          ..where((x) =>
              x.employerId.equals(userId) | x.workerId.equals(userId)))
        .go();
    await (db.delete(db.waitlistRows)..where((x) => x.workerId.equals(userId)))
        .go();
    await (db.delete(db.companyFollowRows)
          ..where((x) => x.userId.equals(userId)))
        .go();
    await (db.delete(db.categoryFollowRows)
          ..where((x) => x.userId.equals(userId)))
        .go();
    await (db.delete(db.notificationRows)
          ..where((x) => x.userId.equals(userId)))
        .go();

    // Сама строка остаётся: на неё ссылаются отклики, отзывы и движения
    // денег. Телефон уникален, поэтому вместо него — метка с номером.
    await (db.update(db.userRows)..where((u) => u.id.equals(userId)))
        .write(UserRowsCompanion(
      fullName: Value(t.deletedUserName),
      phone: Value('deleted-$userId'),
      email: const Value(null),
      company: const Value(null),
      isVerified: const Value(false),
    ));
  });
}

/// Имя без лишних пробелов — или отказ, если оно короче двух букв или
/// длиннее восьмидесяти. Правило одно для телефона и сервера.
String checkedFullName(String raw, {CoreStrings? strings}) {
  final name = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (name.length < 2 || name.length > 80) {
    throw UserError((strings ?? coreTr).badFullName);
  }
  return name;
}
