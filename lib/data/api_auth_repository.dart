import 'package:fastwork_core/support.dart';
import 'package:fastwork_core/user.dart';
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

  @override
  Future<AppUser?> restoreSession() async {
    final saved = await readToken();
    if (saved == null) return null;

    client.token = saved;
    try {
      return userFromJson(await client.get('/api/me') as Map<String, dynamic>);
    } on ApiException {
      // Токен устарел или сервер его не знает — выходим начисто.
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
    try {
      final data = await client.post('/api/auth/login', {'phone': phone})
          as Map<String, dynamic>;
      client.token = data['token'] as String;
      await writeToken(client.token);
      return userFromJson(data['user'] as Map<String, dynamic>);
    } on ApiException catch (e) {
      // 404 — такого номера нет, значит будем регистрировать.
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<AppUser> register({
    required String phone,
    required String fullName,
    required String city,
    String role = UserRole.worker,
    String? company,
  }) async {
    final data = await client.post('/api/auth/register', {
      'phone': phone,
      'fullName': fullName,
      'city': city,
      'role': role,
      'company': company,
    }) as Map<String, dynamic>;

    client.token = data['token'] as String;
    await writeToken(client.token);
    return userFromJson(data['user'] as Map<String, dynamic>);
  }

  @override
  Future<void> signIn(AppUser user) async {
    // Вход уже произошёл: токен выдан в findByPhone или register.
  }

  @override
  Future<void> signOut() async {
    await client.post('/api/auth/logout');
    client.token = null;
    await writeToken(null);
  }

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

  @override
  Future<void> review(int documentId, {required bool approved}) async {
    await client.post(
      '/api/documents/$documentId/review',
      {'approved': approved},
    );
  }
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
