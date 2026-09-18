import 'package:drift/drift.dart';

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
  Future<AppUser> register({
    required String phone,
    required String fullName,
    required String city,
    String? email,
    String role = UserRole.worker,
    String? company,
  });

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
    final rows = await db.query(
      '''
      SELECT COUNT(*) AS c
      FROM application_rows a
      WHERE a.worker_id = ? AND a.status = 'completed'
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
    String? email,
    String role = UserRole.worker,
    String? company,
  }) async {
    final id = await db.into(db.userRows).insert(
          UserRowsCompanion.insert(
            phone: phone,
            email: Value(email),
            fullName: fullName,
            city: city,
            role: Value(role),
            company: Value(company),
            createdAt: DateTime.now(),
          ),
        );

    final user = (await refresh(id))!;
    await signIn(user);
    return user;
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
    String? email,
    String role = UserRole.worker,
    String? company,
  }) async {
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
        fullName: old.fullName,
        city: city,
        rating: old.rating,
        isVerified: old.isVerified,
        role: old.role,
        company: old.company,
        completedShifts: old.completedShifts,
        ratingCount: old.ratingCount,
      );
      _users[i] = updated;
      if (_current?.id == userId) _current = updated;
      return updated;
    }
    return null;
  }

  @override
  Future<void> signIn(AppUser user) async => _current = user;

  @override
  Future<void> signOut() async => _current = null;
}
