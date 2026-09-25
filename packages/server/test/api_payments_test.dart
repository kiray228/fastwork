import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_server/api.dart';
import 'package:fastwork_server/auth_service.dart';
import 'package:fastwork_server/code_sender.dart';
import 'package:fastwork_server/payments/ioka.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

/// Сервер целиком: смену оплачивают картой через ioka (подставной, без
/// сети), ioka присылает вебхук — и смена появляется в ленте.
void main() {
  late AppDatabase db;
  late Api api;
  late String managerToken;
  late String workerToken;
  var iokaStatus = 'UNPAID';
  final iokaCalls = <String>[];

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    iokaStatus = 'UNPAID';
    iokaCalls.clear();

    final ioka = IokaProvider(
      baseUrl: Uri.parse('https://stage-api.ioka.kz'),
      apiKey: 'k',
      returnUrl: 'https://fastwork.example/api/payments/return',
      client: MockClient((request) async {
        iokaCalls.add('${request.method} ${request.url.path}');
        return http.Response(
          jsonEncode({
            'id': 'ord_1',
            'status': iokaStatus,
            'checkout_url': 'https://stage-checkout.ioka.kz/ord_1',
          }),
          200,
        );
      }),
    );
    final sandbox = SandboxPaymentGateway();
    api = Api(
      db,
      ConsoleCodeSender(),
      payments: PaymentGateway(
        card: ioka,
        kaspi: sandbox.kaspi,
        payouts: sandbox.payouts,
      ),
      webhookSecrets: {'ioka': 'whsec'},
    );

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
    Object? body,
    Map<String, String> headers = const {},
  }) async {
    final response = await api.router.call(Request(
      method,
      Uri.parse('http://localhost$path'),
      body: body == null ? null : (body is String ? body : jsonEncode(body)),
      headers: {
        if (token != null) 'authorization': 'Bearer $token',
        ...headers,
      },
    ));
    final text = await response.readAsString();
    return (
      response.statusCode,
      text.startsWith('{') || text.startsWith('[') ? jsonDecode(text) : text,
    );
  }

  final tomorrow = DateTime.now().add(const Duration(days: 1));
  final day = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

  Future<List<dynamic>> feed() async =>
      (await call('GET', '/api/shifts?date=${day.toIso8601String()}',
          token: workerToken))
          .$2 as List<dynamic>;

  Future<Map<String, dynamic>> createShift() async {
    final (status, json) = await call('POST', '/api/shifts',
        token: managerToken,
        body: {
          'method': 'card',
          'workDate': day.toIso8601String(),
          'title': 'Услуги грузчика',
          'company': 'Magnum',
          'address': 'ул. Абая, 1',
          'startMinutes': 600,
          'endMinutes': 1320,
          'hourlyRate': 110000,
          'workersNeeded': 2,
          'category': 'loader',
        });
    expect(status, 200, reason: '$json');
    return json as Map<String, dynamic>;
  }

  test('смена ждёт оплаты, вебхук ioka её публикует', () async {
    final checkout = await createShift();
    expect(checkout['status'], 'pending');
    expect(checkout['url'], 'https://stage-checkout.ioka.kz/ord_1');
    expect(checkout['sandbox'], isFalse);
    expect(iokaCalls, ['POST /v2/orders']);
    expect(await feed(), isEmpty, reason: 'не оплачена — в ленте её нет');

    // Вебхук с неверной подписью не проходит.
    const payload = '{"order":{"id":"ord_1","status":"PAID"}}';
    final (bad, _) = await call('POST', '/api/payments/webhook/ioka',
        body: payload, headers: {'x-signature': 'nope'});
    expect(bad, 401);

    // Провайдер подтвердил оплату и прислал вебхук с верной подписью.
    iokaStatus = 'PAID';
    final signature =
        Hmac(sha256, utf8.encode('whsec')).convert(utf8.encode(payload));
    final (ok, _) = await call('POST', '/api/payments/webhook/ioka',
        body: payload, headers: {'x-signature': '$signature'});
    expect(ok, 200);
    // Сервер не поверил вебхуку на слово — спросил ioka сам.
    expect(iokaCalls.last, 'GET /v2/orders/ord_1');

    final published = await feed();
    expect(published, hasLength(1));
    expect(published.single['isFunded'], isTrue);

    final (_, status) = await call('GET', '/api/payments/${checkout['id']}',
        token: managerToken);
    expect(status['status'], 'paid');
  });

  test('без вебхука смену публикует опрос из приложения', () async {
    final checkout = await createShift();
    iokaStatus = 'PAID';
    final (_, status) = await call('GET', '/api/payments/${checkout['id']}',
        token: managerToken);
    expect(status['status'], 'paid');
    expect(await feed(), hasLength(1));
  });

  test('отказ банка — смена так и ждёт, оплатить можно заново', () async {
    final checkout = await createShift();
    iokaStatus = 'DECLINED';
    final (_, status) = await call('GET', '/api/payments/${checkout['id']}',
        token: managerToken);
    expect(status['status'], 'failed');
    expect(await feed(), isEmpty);

    iokaStatus = 'UNPAID';
    final (code, retry) = await call(
        'POST', '/api/shifts/${checkout['shiftId']}/pay',
        token: managerToken, body: {'method': 'kaspi', 'phone': '87011234567'});
    expect(code, 200);
    expect(retry['method'], 'kaspi');
    expect(retry['sandbox'], isTrue, reason: 'Kaspi здесь тестовый');

    await call('POST', '/api/payments/${retry['id']}/sandbox',
        token: managerToken, body: {});
    expect(await feed(), hasLength(1));
  });

  test('чужую оплату не посмотреть', () async {
    final checkout = await createShift();
    final (code, _) = await call('GET', '/api/payments/${checkout['id']}',
        token: workerToken);
    expect(code, 402);
  });

  test('старое приложение с картой в запросе просят обновиться', () async {
    final (code, json) = await call('POST', '/api/shifts',
        token: managerToken,
        body: {
          'card': {'token': 'sandbox_4242', 'last4': '4242', 'brand': 'Visa'},
          'workDate': day.toIso8601String(),
          'title': 'x',
          'company': 'Magnum',
          'address': 'a',
          'startMinutes': 600,
          'endMinutes': 1320,
          'hourlyRate': 110000,
          'workersNeeded': 1,
        });
    expect(code, 426);
    expect(json['error'], contains('Обновите'));
  });

  test('страница возврата после оплаты', () async {
    final (code, html) = await call('GET', '/api/payments/return?ref=x');
    expect(code, 200);
    expect(html, contains('Оплата принята'));
  });
}
