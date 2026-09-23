import 'package:drift/drift.dart';

import '../errors.dart';
import '../terms.dart';
import '../user.dart';
import 'database.dart';

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

  /// Перечитать пользователя из базы — например, после новой смены.
  Future<AppUser?> refresh(int userId);

  /// Сменить город. От него зависит, какие смены человек видит.
  Future<AppUser?> changeCity(int userId, String city);
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
    throw UnsupportedError('Коды на почту работают только через сервер');
  }

  @override
  Future<AppUser?> verifyCode(String email, String code) async {
    throw UnsupportedError('Коды на почту работают только через сервер');
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
  Future<void> signIn(AppUser user) async {
    await db.into(db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: _sessionKey,
            value: '${user.id}',
          ),
        );
  }

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
      throw StateError('Неверный код');
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
  TermsNotAccepted() : super('Чтобы продолжить, примите правила сервиса');
}
