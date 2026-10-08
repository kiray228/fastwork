import 'dart:convert';

import 'package:drift/native.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_server/api.dart';
import 'package:fastwork_server/auth_service.dart';
import 'package:fastwork_server/code_sender.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

/// Сервер говорит с каждым на его языке.
///
/// Язык приходит в заголовке запроса, а уведомления, которые пишутся без
/// человека, — на языке, который сервер запомнил у получателя.
void main() {
  late AppDatabase db;
  late Api api;
  late String managerToken;
  late String workerToken;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    api = Api(db, ConsoleCodeSender());
    final auth = DbAuthRepository(db);
    final manager = await auth.register(
      phone: '77000000001',
      email: 'boss@example.kz',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: 'manager',
      company: 'Magnum',
    );
    final worker = await auth.register(
      phone: '77000000002',
      email: 'worker@example.kz',
      fullName: 'Ернар Калдыбеков',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    final tokens = AuthService(db, ConsoleCodeSender());
    managerToken =
        await tokens.issue(email: 'boss@example.kz', userId: manager.id);
    workerToken =
        await tokens.issue(email: 'worker@example.kz', userId: worker.id);
  });

  tearDown(() => db.close());

  Future<(int, dynamic)> call(
    String method,
    String path, {
    String? token,
    String? lang,
    Object? body,
  }) async {
    final response = await api.router.call(Request(
      method,
      Uri.parse('http://localhost$path'),
      body: body == null ? null : jsonEncode(body),
      headers: {
        if (token != null) 'authorization': 'Bearer $token',
        if (lang != null) 'accept-language': lang,
      },
    ));
    final text = await response.readAsString();
    return (
      response.statusCode,
      text.startsWith('{') || text.startsWith('[') ? jsonDecode(text) : text,
    );
  }

  test('ошибка — на языке запроса', () async {
    Future<String> error(String? lang) async {
      final (_, json) = await call('POST', '/api/auth/request-code',
          lang: lang, body: {'email': 'не почта'});
      return json['error'] as String;
    }

    expect(await error(null), 'Проверьте адрес почты');
    expect(await error('kk-KZ,kk;q=0.9'), 'Пошта мекенжайын тексеріңіз');
    expect(await error('en-US,en;q=0.9'), 'Please check the email address');
    // Незнакомый язык — по-русски.
    expect(await error('de-DE'), 'Проверьте адрес почты');
  });

  test('ошибка правил из ядра — тоже на языке запроса', () async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final (code, json) = await call('POST', '/api/shifts',
        token: managerToken,
        lang: 'en',
        body: {
          'method': 'card',
          'workDate':
              DateTime(tomorrow.year, tomorrow.month, tomorrow.day)
                  .toIso8601String(),
          'title': 'Loader',
          'company': 'Magnum',
          'address': 'Abay ave, 1',
          'startMinutes': 600,
          'endMinutes': 1320,
          'hourlyRate': -100000,
          'workersNeeded': 2,
          'category': 'loader',
        });
    expect(code, 400);
    expect(json['error'], startsWith('The rate must be at least'));
  });

  test('уведомление — на языке получателя, а не того, кто действует',
      () async {
    // Заказчик пользуется приложением по-английски.
    await call('GET', '/api/me', token: managerToken, lang: 'en');

    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final (_, checkout) = await call('POST', '/api/shifts',
        token: managerToken,
        lang: 'en',
        body: {
          'method': 'kaspi',
          'phone': '87011234567',
          'workDate':
              DateTime(tomorrow.year, tomorrow.month, tomorrow.day)
                  .toIso8601String(),
          'title': 'Loader',
          'company': 'Magnum',
          'address': 'Abay ave, 1',
          'startMinutes': 600,
          'endMinutes': 1320,
          'hourlyRate': 110000,
          'workersNeeded': 2,
          'category': 'loader',
        });
    await call('POST', '/api/payments/${checkout['id']}/sandbox',
        token: managerToken, lang: 'en', body: {});

    // Исполнитель записывается по-казахски.
    final (_, applied) = await call(
        'POST', '/api/shifts/${checkout['shiftId']}/apply',
        token: workerToken, lang: 'kk');
    expect(applied['result'], 'ok');

    final (_, notes) =
        await call('GET', '/api/notifications', token: managerToken);
    final titles = [for (final n in notes as List) n['title']];
    expect(titles, contains('New booking for your shift'));
  });
}
