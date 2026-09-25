import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fastwork_core/payment.dart';
import 'package:fastwork_server/payment_gateway.dart';
import 'package:fastwork_server/payments/http_json.dart';
import 'package:fastwork_server/payments/ioka.dart';
import 'package:fastwork_server/payments/kaspi.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

/// Адаптеры провайдеров без сети: запросы уходят в подставной клиент, и
/// видно, что именно сервер отправил бы в ioka и Kaspi.
void main() {
  late List<http.Request> sent;

  MockClient reply(Map<String, dynamic> Function(http.Request r) answer,
          {int status = 200}) =>
      MockClient((request) async {
        sent.add(request);
        return http.Response(jsonEncode(answer(request)), status,
            headers: {'content-type': 'application/json'});
      });

  setUp(() => sent = []);

  group('ioka — карты', () {
    IokaProvider ioka(MockClient client) => IokaProvider(
          baseUrl: Uri.parse('https://stage-api.ioka.kz'),
          apiKey: 'test-key',
          returnUrl: 'https://fastwork.example/api/payments/return',
          client: client,
        );

    test('заказ создаётся в тиынах, с ключом и адресом возврата', () async {
      final provider = ioka(reply((_) => {
            'id': 'ord_1',
            'status': 'UNPAID',
            'checkout_url': 'https://stage-checkout.ioka.kz/orders/ord_1',
          }));

      final checkout = await provider.startCheckout(
        amount: 1258400,
        reference: 'charge-7',
        description: 'Смена «Грузчик»',
      );

      expect(checkout.operation, 'ord_1');
      expect(checkout.url, 'https://stage-checkout.ioka.kz/orders/ord_1');
      final request = sent.single;
      expect(request.method, 'POST');
      expect(request.url.toString(), 'https://stage-api.ioka.kz/v2/orders');
      expect(request.headers['API-KEY'], 'test-key');
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['amount'], 1258400);
      expect(body['currency'], 'KZT');
      expect(body['capture_method'], 'AUTO');
      expect(body['external_id'], 'charge-7');
      expect(body['success_url'], contains('ref=charge-7'));
      expect(provider.isSandbox, isTrue, reason: 'stage — тестовый контур');
    });

    test('статус заказа переводится в «оплачено / ждём / отказ»', () async {
      var status = 'UNPAID';
      final provider = ioka(reply((_) => {
            'id': 'ord_1',
            'status': status,
            'payments': [
              {
                'card': {'pan_masked': '440043******0000'}
              }
            ],
          }));

      expect((await provider.checkStatus('ord_1')).state,
          ProviderState.pending);
      status = 'PAID';
      final paid = await provider.checkStatus('ord_1');
      expect(paid.state, ProviderState.paid);
      expect(paid.paidWith, contains('0000'));
      status = 'DECLINED';
      expect((await provider.checkStatus('ord_1')).state,
          ProviderState.failed);
      expect(sent.last.url.path, '/v2/orders/ord_1');
    });

    test('непонятный статус — ждём, а не публикуем', () async {
      final provider = ioka(reply((_) => {'status': 'SOMETHING_NEW'}));
      expect((await provider.checkStatus('x')).state, ProviderState.pending);
    });

    test('отказ провайдера с текстом доходит до человека', () async {
      final provider = ioka(reply(
        (_) => {'message': 'Неверная сумма'},
        status: 400,
      ));
      expect(
        () => provider.startCheckout(
            amount: 1, reference: 'r', description: 'd'),
        throwsA(isA<PaymentDeclined>()
            .having((e) => e.message, 'message', 'Неверная сумма')),
      );
    });

    test('вывод — заказ на перевод с типом TOPUP', () async {
      final provider = ioka(reply((_) => {
            'id': 'tr_1',
            'checkout_url': 'https://stage-checkout.ioka.kz/transfer/tr_1',
          }));
      final checkout = await provider.startPayout(
        amount: 1210000,
        reference: 'payout-3',
        description: 'Вывод',
      );
      expect(checkout.operation, 'tr_1');
      expect(sent.single.url.path, '/v2/transfer-orders');
      expect(jsonDecode(sent.single.body)['type'], 'TOPUP');
    });

    test('номер заказа из вебхука — не номер платежа', () {
      expect(
        IokaProvider.operationFromWebhook({
          'event': 'PAYMENT_CAPTURED',
          'payment': {'id': 'pay_9', 'order_id': 'ord_1'},
        }),
        'ord_1',
      );
      expect(
        IokaProvider.operationFromWebhook({
          'order': {'id': 'ord_2', 'status': 'PAID'},
        }),
        'ord_2',
      );
    });
  });

  group('Kaspi — счёт по номеру телефона', () {
    KaspiInvoiceProvider kaspi(MockClient client) => KaspiInvoiceProvider(
          baseUrl: Uri.parse('https://bpapi.bazarbay.site/api/v1'),
          apiKey: 'kaspi-key',
          client: client,
        );

    test('счёт выставляется в тенге на номер в виде 8 7XX…', () async {
      final provider = kaspi(reply((_) => {'id': 42, 'status': 'pending'}));

      final checkout = await provider.startCheckout(
        amount: 1258400,
        reference: 'charge-7',
        description: 'Смена',
        phone: '77011234567',
      );

      expect(checkout.operation, '42');
      expect(checkout.url, isNull, reason: 'счёт приходит push-ом в Kaspi');
      final request = sent.single;
      expect(request.url.toString(),
          'https://bpapi.bazarbay.site/api/v1/invoices');
      expect(request.headers['X-API-Key'], 'kaspi-key');
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['amount'], 12584);
      expect(body['phone_number'], '87011234567');
      expect(body['external_order_id'], 'charge-7');
    });

    test('без номера счёт не выставить', () {
      final provider = kaspi(reply((_) => {}));
      expect(
        () => provider.startCheckout(
            amount: 100, reference: 'r', description: 'd'),
        throwsA(isA<PaymentDeclined>()),
      );
    });

    test('оплачен, ждёт, истёк', () async {
      var status = 'pending';
      final provider = kaspi(reply((_) => {'id': 42, 'status': status}));

      expect((await provider.checkStatus('42')).state, ProviderState.pending);
      status = 'paid';
      expect((await provider.checkStatus('42')).state, ProviderState.paid);
      status = 'expired';
      final expired = await provider.checkStatus('42');
      expect(expired.state, ProviderState.failed);
      expect(expired.message, contains('истёк'));
      expect(sent.last.url.path, '/api/v1/invoices/42');
    });

    test('возврат — по счёту, в тенге', () async {
      final provider = kaspi(reply((_) => {'ok': true}));
      await provider.refund(operation: '42', amount: 629200);
      expect(sent.single.url.path, '/api/v1/invoices/42/refund');
      expect(jsonDecode(sent.single.body)['amount'], 6292);
    });
  });

  group('подпись вебхука', () {
    final body = utf8.encode('{"invoice":{"id":42,"status":"paid"}}');
    final digest = Hmac(sha256, utf8.encode('secret')).convert(body);

    test('шестнадцатеричная, base64 и с приставкой sha256= — годятся', () {
      for (final signature in [
        digest.toString(),
        base64.encode(digest.bytes),
        'sha256=$digest',
      ]) {
        expect(
          verifyHmac(secret: 'secret', body: body, signature: signature),
          isTrue,
          reason: signature,
        );
      }
    });

    test('чужая подпись или без неё — нет', () {
      expect(verifyHmac(secret: 'secret', body: body, signature: 'abc'),
          isFalse);
      expect(verifyHmac(secret: 'secret', body: body, signature: null),
          isFalse);
      expect(verifyHmac(secret: 'other', body: body, signature: '$digest'),
          isFalse);
    });
  });

  group('выбор провайдеров', () {
    test('без ключей — всё в тестовом режиме', () {
      final setup = resolvePayments({});
      expect(setup.gateway.card.isSandbox, isTrue);
      expect(setup.gateway.kaspi.isSandbox, isTrue);
      expect(setup.gateway.payouts.isSandbox, isTrue);
    });

    test('ключи ioka и ApiPay включают настоящие способы', () {
      final setup = resolvePayments({
        'IOKA_API_KEY': 'k',
        'IOKA_API_URL': 'https://api.ioka.kz',
        'APIPAY_API_KEY': 'a',
        'APIPAY_WEBHOOK_SECRET': 's',
        'RENDER_EXTERNAL_URL': 'https://fastwork-server.onrender.com',
      });
      expect(setup.gateway.card, isA<IokaProvider>());
      expect(setup.gateway.card.isSandbox, isFalse);
      expect((setup.gateway.card as IokaProvider).returnUrl,
          'https://fastwork-server.onrender.com/api/payments/return');
      expect(setup.gateway.kaspi, isA<KaspiInvoiceProvider>());
      expect(setup.gateway.payouts, same(setup.gateway.card));
      expect(setup.webhookSecrets['apipay'], 's');
    });

    test('можно включить только Kaspi — карта останется тестовой', () {
      final setup = resolvePayments({'APIPAY_API_KEY': 'a'});
      expect(setup.gateway.kaspi.isSandbox, isFalse);
      expect(setup.gateway.card.isSandbox, isTrue);
    });
  });
}
