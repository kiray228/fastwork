import 'package:fastwork_core/support.dart';
import 'package:fastwork_core/user.dart';
import '../l10n/strings.dart';
import 'api_client.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/support_repository.dart';

/// Пользователи на сервере.
///
/// Главное отличие от локальной версии: «кто вошёл» решает не приложение,
/// а сервер. Приложение лишь хранит выданный токен.
class ApiAuthRepository implements AuthRepository {
  final ApiClient client;

  /// Куда сохранить токен между запусками. На вебе это хранилище браузера,
  /// его передают снаружи — чтобы этот файл не зависел от платформы.
  final Future<String?> Function() readToken;
  final Future<void> Function(String?) writeToken;

  ApiAuthRepository(
    this.client, {
    required this.readToken,
    required this.writeToken,
  });

  /// Через сервер — только по коду с почты. Сервер не может знать, что
  /// почта твоя, пока ты не покажешь письмо.
  @override
  bool get requiresEmailCode => true;

  @override
  Future<void> requestCode(String email) async {
    await client.post('/api/auth/request-code', {'email': email});
  }

  @override
  Future<AppUser?> verifyCode(String email, String code) async {
    final data = await client.post('/api/auth/verify', {
      'email': email,
      'code': code,
    }) as Map<String, dynamic>;

    // Токен выдают в обоих случаях. Если аккаунта ещё нет, он пускает
    // только в регистрацию — этим распоряжается сервер, не мы.
    client.token = data['token'] as String;
    await writeToken(client.token);

    final user = data['user'];
    return user == null ? null : userFromJson(user as Map<String, dynamic>);
  }

  @override
  Future<AppUser?> restoreSession() async {
    final saved = await readToken();
    if (saved == null) return null;

    client.token = saved;
    try {
      return userFromJson(await client.get('/api/me') as Map<String, dynamic>);
    } on ApiException {
      // Токен устарел, или сервер его не знает, или аккаунт по нему ещё
      // не создан — во всех случаях начинаем вход заново.
      client.token = null;
      await writeToken(null);
      return null;
    }
  }

  @override
  Future<AppUser?> refresh(int userId) async =>
      userFromJson(await client.get('/api/me') as Map<String, dynamic>);

  @override
  Future<AppUser?> findByPhone(String phone) async {
    // Через сервер по телефону не входят: код приходит на почту.
    throw UnsupportedError(tr.common.serverPhoneSignInUnsupported);
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
    int? referredBy,
  }) async {
    // Почту не передаём: сервер знает её из токена, выданного при
    // подтверждении кода. Так её нельзя подменить по дороге.
    final data = await client.post('/api/auth/register', {
      'phone': phone,
      'fullName': fullName,
      'city': city,
      'role': role,
      'company': company,
      'acceptedTermsVersion': acceptedTermsVersion,
      'referredBy': referredBy,
    }) as Map<String, dynamic>;

    client.token = data['token'] as String;
    await writeToken(client.token);
    return userFromJson(data['user'] as Map<String, dynamic>);
  }

  @override
  Future<void> signIn(AppUser user) async {
    // Вход уже произошёл: токен выдан при проверке кода.
  }

  @override
  Future<void> signOut() async {
    // Выйти можно всегда — и без связи, и с просроченным токеном, на
    // который сервер ответит 401. Раньше сбой запроса обрывал выход:
    // токен оставался на телефоне, и человек застревал в сломанной
    // сессии. Сервер — лишь вежливость: забыть токен там. Здесь — главное.
    try {
      await client.post('/api/auth/logout');
    } catch (_) {
      // Не дошло — токен сам истечёт на сервере через 90 дней.
    } finally {
      client.token = null;
      await writeToken(null);
    }
  }

  @override
  Future<AppUser?> changeName(int userId, String fullName) async =>
      userFromJson(
        await client.post('/api/me/name', {'fullName': fullName})
            as Map<String, dynamic>,
      );

  @override
  Future<AppUser?> setEmailNotices(int userId, {required bool on}) async =>
      userFromJson(
        await client.post('/api/me/email-notices', {'on': on})
            as Map<String, dynamic>,
      );

  @override
  Future<void> signOutEverywhere() async {
    // Сервер гасит все входы; если не дошло — выйти здесь всё равно
    // нужно, а остальные входы истекут сами. Ошибку показываем: человек
    // должен знать, что на других устройствах вход ещё жив.
    try {
      await client.post('/api/me/logout-all');
    } finally {
      client.token = null;
      await writeToken(null);
    }
  }

  @override
  Future<void> deleteAccount(int userId) async {
    // Отказ сервера («сначала выведите деньги») летит дальше, на экран, —
    // и токен тогда остаётся: аккаунт-то не удалён.
    await client.post('/api/me/delete');
    client.token = null;
    await writeToken(null);
  }

  @override
  Future<AppUser?> acceptTerms(int userId) async => userFromJson(
        await client.post('/api/me/accept-terms') as Map<String, dynamic>,
      );

  @override
  Future<AppUser?> changeCity(int userId, String city) async => userFromJson(
        await client.post('/api/me/city', {'city': city})
            as Map<String, dynamic>,
      );
}

/// Документы на сервере.
class ApiDocumentRepository implements DocumentRepository {
  final ApiClient client;

  ApiDocumentRepository(this.client);

  @override
  Future<List<UserDocument>> documents() async {
    final data = await client.get('/api/documents') as List<dynamic>;
    return data
        .map((e) => documentFromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> upload({
    required String type,
    required String number,
    DateTime? expiresAt,
  }) async {
    await client.post('/api/documents', {
      'type': type,
      'number': number,
      'expiresAt': expiresAt?.toIso8601String(),
    });
  }

  // С сервером документы проверяет оператор, а не приложение.
  @override
  bool get selfReview => false;

  @override
  Future<void> review(int documentId, {required bool approved}) async =>
      throw UnsupportedError('documents are reviewed by an operator');
}

/// Поддержка на сервере.
class ApiSupportRepository implements SupportRepository {
  final ApiClient client;

  ApiSupportRepository(this.client);

  @override
  Future<List<SupportTicket>> tickets() async {
    final data = await client.get('/api/support/tickets') as List<dynamic>;
    return data.map((e) => ticketFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<int> createTicket(String subject, String firstMessage) async {
    final data = await client.post('/api/support/tickets', {
      'subject': subject,
      'message': firstMessage,
    }) as Map<String, dynamic>;
    return data['id'] as int;
  }

  @override
  Future<List<SupportMessage>> messages(int ticketId) async {
    final data = await client.get('/api/support/tickets/$ticketId/messages')
        as List<dynamic>;
    return data
        .map((e) => messageFromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> sendMessage(int ticketId, String text) async {
    await client.post(
      '/api/support/tickets/$ticketId/messages',
      {'text': text},
    );
  }
}
