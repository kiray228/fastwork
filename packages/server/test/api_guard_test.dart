import 'dart:async';
import 'dart:convert';

import 'package:drift/native.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_server/api.dart';
import 'package:fastwork_server/auth_service.dart';
import 'package:fastwork_server/code_sender.dart';
import 'package:fastwork_server/cors.dart';
import 'package:fastwork_server/rate_limit.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

/// Письма, которые «ушли»: тест считает их, а не читает почту.
class _CountingSender implements CodeSender {
  final sent = <String>[];

  /// Сколько ждать «почтовый сервис» — как настоящий, который отвечает
  /// не сразу. Пока письмо в пути, успевают прийти соседние запросы.
  final Duration delay;

  _CountingSender({this.delay = Duration.zero});

  @override
  String get name => 'test';

  @override
  Future<void> send(String email, String code) async {
    await Future<void>.delayed(delay);
    sent.add(email);
  }
}

/// Общие проверки сервера — те, что стоят перед всеми адресами сразу:
/// размер запроса, кривой JSON там, куда пускают без входа, частота писем
/// с кодом, допустимые роль и город при регистрации.
void main() {
  late AppDatabase db;
  late _CountingSender sender;
  late Api api;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    sender = _CountingSender(delay: const Duration(milliseconds: 20));
    api = Api(db, sender);
  });

  tearDown(() => db.close());

  Future<(int, dynamic)> call(
    String method,
    String path, {
    String? token,
    Object? body,
  }) async {
    final response = await api.router.call(Request(
      method,
      Uri.parse('http://localhost$path'),
      body: body == null ? null : (body is String ? body : jsonEncode(body)),
      headers: {if (token != null) 'authorization': 'Bearer $token'},
    ));
    final text = await response.readAsString();
    return (
      response.statusCode,
      text.startsWith('{') ? jsonDecode(text) : text,
    );
  }

  test('слишком большой запрос отклоняется, не дочитываясь', () async {
    final (status, json) = await call('POST', '/api/auth/request-code',
        body: {'email': 'a@b.kz', 'junk': 'x' * (Api.maxBodyBytes + 1)});
    expect(status, 413);
    expect(json['error'], isNotEmpty);
    expect(sender.sent, isEmpty);
  });

  test('кривой JSON без входа — ошибка запроса, а не падение сервера',
      () async {
    final (broken, _) =
        await call('POST', '/api/auth/request-code', body: '{"email": ');
    expect(broken, 400);
    final (array, _) = await call('POST', '/api/auth/verify', body: '[1, 2]');
    expect(array, 400);
    final (wrongType, _) =
        await call('POST', '/api/auth/request-code', body: {'email': 42});
    expect(wrongType, 400);
  });

  test('новый код — не чаще раза в минуту', () async {
    final (first, _) = await call('POST', '/api/auth/request-code',
        body: {'email': 'worker@example.kz'});
    expect(first, 200);
    final (second, json) = await call('POST', '/api/auth/request-code',
        body: {'email': 'worker@example.kz'});
    expect(second, 429);
    expect(json['error'], isNotEmpty);
    expect(sender.sent, hasLength(1));
  });

  test('сто запросов кода разом — одно письмо', () async {
    // Раньше счётчик читали до отправки, а записывали после: все сто
    // видели «меньше пяти», и на чужую почту уходило сто писем.
    final statuses = await Future.wait([
      for (var i = 0; i < 100; i++)
        call('POST', '/api/auth/request-code',
                body: {'email': 'victim@example.kz'})
            .then((r) => r.$1),
    ]);
    expect(sender.sent, hasLength(1));
    expect(statuses.where((s) => s == 200), hasLength(1));
    expect(statuses.where((s) => s == 429), hasLength(99));
  });

  test('не ушедшее письмо не занимает место в счётчике', () async {
    final failing = Api(db, _FailingSender());
    final response = await failing.router.call(Request(
      'POST',
      Uri.parse('http://localhost/api/auth/request-code'),
      body: jsonEncode({'email': 'worker@example.kz'}),
    ));
    expect(response.statusCode, 502);
    expect(await db.select(db.authCodeRows).get(), isEmpty);

    // Почта заработала — код можно запросить сразу, без минуты ожидания.
    final (status, _) = await call('POST', '/api/auth/request-code',
        body: {'email': 'worker@example.kz'});
    expect(status, 200);
  });

  group('удаление аккаунта', () {
    test('аккаунт удаляется, и его вход сразу перестаёт работать', () async {
      final token =
          await AuthService(db, sender).issue(email: 'new@example.kz');
      final (_, reg) = await call('POST', '/api/auth/register',
          token: token,
          body: {
            'phone': '+7 700 123 45 67',
            'fullName': 'Ернар Калдыбеков',
            'acceptedTermsVersion': kTermsVersion,
          });
      expect(reg['user']['id'], isNotNull);

      final (deleted, _) =
          await call('POST', '/api/me/delete', token: token, body: {});
      expect(deleted, 200);
      final (me, _) = await call('GET', '/api/me', token: token);
      expect(me, 401);
    });

    test('без входа удалить нечего', () async {
      final (status, _) = await call('POST', '/api/me/delete', body: {});
      expect(status, 401);
    });
  });

  group('переписка по смене', () {
    test('без входа не прочитать', () async {
      final (status, _) = await call('GET', '/api/shifts/1/chat');
      expect(status, 401);
    });

    test('о несуществующей смене — отказ, а не падение', () async {
      final token =
          await AuthService(db, sender).issue(email: 'chat@example.kz');
      await call('POST', '/api/auth/register', token: token, body: {
        'phone': '+7 700 555 44 33',
        'fullName': 'Ернар Калдыбеков',
        'acceptedTermsVersion': kTermsVersion,
      });
      final (read, _) = await call('GET', '/api/shifts/999/chat', token: token);
      expect(read, 400);
      final (send, _) = await call('POST', '/api/shifts/999/chat',
          token: token, body: {'text': 'привет'});
      expect(send, 400);
    });
  });

  test('незнакомая причина отмены не роняет запрос', () {
    expect(CancelReason.fromName('sick'), CancelReason.sick);
    expect(CancelReason.fromName('teleported'), isNull);
    expect(CancelReason.fromName(null), isNull);
  });

  group('предел на вход с одного адреса', () {
    test('считает окно и отпускает по его истечении', () {
      var now = DateTime(2026, 10, 16, 12);
      final limiter = RateLimiter(
          limit: 2, window: const Duration(minutes: 10), clock: () => now);
      expect(limiter.allow('1.2.3.4'), isTrue);
      expect(limiter.allow('1.2.3.4'), isTrue);
      expect(limiter.allow('1.2.3.4'), isFalse);
      expect(limiter.allow('5.6.7.8'), isTrue, reason: 'другой адрес');
      now = now.add(const Duration(minutes: 11));
      expect(limiter.allow('1.2.3.4'), isTrue, reason: 'окно прошло');
    });

    test('адрес — последний в X-Forwarded-For: первые подделываются', () {
      final request = Request('GET', Uri.parse('http://localhost/'),
          headers: {'x-forwarded-for': '6.6.6.6, 10.0.0.1'});
      expect(clientAddress(request), '10.0.0.1');
    });

    test('после предела вход отвечает 429, другим адресам — как обычно',
        () async {
      final limited = Api(db, sender,
          loginLimit:
              RateLimiter(limit: 3, window: const Duration(minutes: 10)));
      Future<int> ask(String ip) async => (await limited.router.call(Request(
            'POST',
            Uri.parse('http://localhost/api/auth/verify'),
            body: jsonEncode({'email': 'a@b.kz', 'code': '000000'}),
            headers: {'x-forwarded-for': ip},
          )))
              .statusCode;
      for (var i = 0; i < 3; i++) {
        expect(await ask('1.1.1.1'), isNot(429));
      }
      expect(await ask('1.1.1.1'), 429);
      expect(await ask('2.2.2.2'), isNot(429));
    });
  });

  test('«выйти везде» гасит все входы человека', () async {
    final service = AuthService(db, sender);
    final first = await service.issue(email: 'w@example.kz');
    await call('POST', '/api/auth/register', token: first, body: {
      'phone': '+7 700 999 88 77',
      'fullName': 'Ернар Калдыбеков',
      'acceptedTermsVersion': kTermsVersion,
    });
    final userId = (await db.select(db.userRows).getSingle()).id;
    final second = await service.issue(email: 'w@example.kz', userId: userId);

    final (ok, _) = await call('POST', '/api/me/logout-all', token: first);
    expect(ok, 200);
    expect((await call('GET', '/api/me', token: first)).$1, 401);
    expect((await call('GET', '/api/me', token: second)).$1, 401,
        reason: 'и на другом устройстве');
  });

  group('CORS', () {
    Future<Response> ask(List<String> allowed, String? origin) async =>
        corsFor(allowed)((_) => Response.ok('ok'))(Request(
          'GET',
          Uri.parse('http://localhost/api/health'),
          headers: {if (origin != null) 'origin': origin},
        ));

    test('без списка пускают всех', () async {
      final response = await ask(const [], 'https://evil.example');
      expect(response.headers['access-control-allow-origin'], '*');
    });

    test('со списком — только свои сайты', () async {
      const allowed = ['https://kiray228.github.io'];
      final own = await ask(allowed, 'https://kiray228.github.io');
      expect(own.headers['access-control-allow-origin'],
          'https://kiray228.github.io');
      // Своему сайту можно слать ключ оператора — для его экрана.
      expect(own.headers['access-control-allow-headers'],
          contains('X-Admin-Key'));
      final evil = await ask(allowed, 'https://evil.example');
      expect(evil.headers['access-control-allow-origin'], isNull);
      expect(evil.headers['access-control-allow-headers'],
          isNot(contains('X-Admin-Key')));
    });

    test('список читается из переменной окружения', () {
      expect(parseOrigins(' https://a.kz/, https://b.kz ,,'),
          ['https://a.kz', 'https://b.kz']);
      expect(parseOrigins(null), isEmpty);
    });
  });

  test('служебный ключ сравнивается целиком', () {
    expect(sameSecret('secret', 'secret'), isTrue);
    expect(sameSecret('secreT', 'secret'), isFalse);
    expect(sameSecret('secret1', 'secret'), isFalse);
    expect(sameSecret('', 'secret'), isFalse);
  });

  group('регистрация', () {
    late String token;

    setUp(() async {
      token = await AuthService(db, sender).issue(email: 'new@example.kz');
    });

    Future<(int, dynamic)> register(Map<String, dynamic> body) =>
        call('POST', '/api/auth/register', token: token, body: {
          'phone': '+7 700 123 45 67',
          'fullName': 'Ернар Калдыбеков',
          'acceptedTermsVersion': kTermsVersion,
          ...body,
        });

    test('роль — только исполнитель или заказчик', () async {
      final (status, _) = await register({'role': 'admin'});
      expect(status, 400);
      expect(await db.select(db.userRows).get(), isEmpty);
    });

    test('город — только из списка', () async {
      final (status, json) = await register({'city': 'Париж'});
      expect(status, 400);
      expect(json['error'], isNotEmpty);
    });

    test('заказчику нужна компания', () async {
      final (status, _) = await register({'role': 'manager', 'company': '  '});
      expect(status, 400);
      final (ok, json) =
          await register({'role': 'manager', 'company': ' Magnum '});
      expect(ok, 200);
      expect(json['user']['company'], 'Magnum');
    });

    test('исполнителю компания не записывается', () async {
      final (ok, json) = await register({'company': 'Magnum'});
      expect(ok, 200);
      expect(json['user']['company'], isNull);
      expect(json['user']['city'], 'Алматы');
    });

    test('имя исправляется, пустое — нет', () async {
      await register({});
      final (bad, _) = await call('POST', '/api/me/name',
          token: token, body: {'fullName': ' '});
      expect(bad, 400);
      final (ok, me) = await call('POST', '/api/me/name',
          token: token, body: {'fullName': 'Азамат Серик'});
      expect(ok, 200);
      expect(me['fullName'], 'Азамат Серик');
    });

    test('сменить город можно только на город из списка', () async {
      final (_, json) = await register({});
      expect(json['user']['id'], isNotNull);
      final (bad, _) =
          await call('POST', '/api/me/city', token: token, body: {'city': 'x'});
      expect(bad, 400);
      final (ok, me) = await call('POST', '/api/me/city',
          token: token, body: {'city': 'Астана'});
      expect(ok, 200);
      expect(me['city'], 'Астана');
    });
  });
}

class _FailingSender implements CodeSender {
  @override
  String get name => 'test';

  @override
  Future<void> send(String email, String code) =>
      Future.error(StateError('почта недоступна'));
}
