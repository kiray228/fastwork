import 'package:drift/drift.dart';

import '../user.dart';
import 'database.dart';

/// Что умеет хранилище пользователей. Экраны знают только это описание.
abstract class AuthRepository {
  /// Кто вошёл в прошлый раз. null — никто, надо показать регистрацию.
  Future<AppUser?> restoreSession();

  /// Найти пользователя по телефону — это наш «вход».
  Future<AppUser?> findByPhone(String phone);

  /// Создать нового пользователя и сразу войти под ним.
  Future<AppUser> register({
    required String phone,
    required String fullName,
    required String city,
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

  Future<AppUser> _toUser(UserRow row) async {
    // Сколько смен отработано — считаем запросом, а не храним в колонке.
    //
    // Считаем только подтверждённые заказчиком. Раньше здесь было
    // «запись жива и дата прошла», и это завышало счётчик: записался,
    // не пришёл — а смена всё равно засчитывалась.
    final rows = await db.customSelect(
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
    final rating = await db.customSelect(
      '''
      SELECT AVG(rating) AS avg_rating, COUNT(*) AS cnt
      FROM worker_review_rows
      WHERE worker_id = ?
      ''',
      variables: [Variable.withInt(row.id)],
      readsFrom: {db.workerReviewRows},
    ).getSingle();

    return AppUser(
      id: row.id,
      phone: row.phone,
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
    String role = UserRole.worker,
    String? company,
  }) async {
    final id = await db.into(db.userRows).insert(
          UserRowsCompanion.insert(
            phone: phone,
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

  FakeAuthRepository({AppUser? signedIn}) {
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
    String role = UserRole.worker,
    String? company,
  }) async {
    final user = AppUser(
      id: _nextId++,
      phone: phone,
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
