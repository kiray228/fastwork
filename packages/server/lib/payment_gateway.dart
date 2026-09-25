import 'dart:io';

import 'package:fastwork_core/payment.dart';

import 'payments/ioka.dart';
import 'payments/kaspi.dart';

/// Как сервер принимает и выплачивает деньги — всё из переменных
/// окружения, ключи в код не попадают.
///
/// | Переменная             | Что включает                                  |
/// |------------------------|-----------------------------------------------|
/// | `IOKA_API_KEY`         | карты и вывод на карту через ioka             |
/// | `IOKA_API_URL`         | https://api.ioka.kz — боевой контур; по       |
/// |                        | умолчанию тестовый, https://stage-api.ioka.kz |
/// | `IOKA_WEBHOOK_SECRET`  | проверка подписи вебхуков ioka                |
/// | `APIPAY_API_KEY`       | Kaspi: счёт по номеру телефона через ApiPay   |
/// | `APIPAY_API_URL`       | адрес API, если ApiPay его поменяет           |
/// | `APIPAY_WEBHOOK_SECRET`| проверка подписи вебхуков ApiPay              |
/// | `PUBLIC_URL`           | адрес сервера для возврата после оплаты;      |
/// |                        | на Render подставляется сам                   |
///
/// Ключа нет — этот способ работает в тестовом режиме: человек «платит»
/// прямо в приложении тестовой картой или кнопкой «Оплатить в Kaspi».
/// Так сервер можно запустить и показать без договоров с банками.
class PaymentSetup {
  final PaymentGateway gateway;

  /// Секреты подписи вебхуков по имени провайдера.
  final Map<String, String> webhookSecrets;

  const PaymentSetup(this.gateway, this.webhookSecrets);
}

PaymentSetup resolvePayments([Map<String, String>? environment]) {
  final env = environment ?? Platform.environment;
  String get(String key) => (env[key] ?? '').trim();

  final publicUrl = [get('PUBLIC_URL'), get('RENDER_EXTERNAL_URL')]
      .firstWhere((u) => u.isNotEmpty, orElse: () => 'http://localhost:8080');
  final returnUrl = '$publicUrl/api/payments/return';

  final sandbox = SandboxPaymentGateway();

  final PaymentProvider card;
  final PayoutProvider payouts;
  if (get('IOKA_API_KEY').isNotEmpty) {
    final ioka = IokaProvider(
      baseUrl: Uri.parse(get('IOKA_API_URL').isEmpty
          ? 'https://stage-api.ioka.kz'
          : get('IOKA_API_URL')),
      apiKey: get('IOKA_API_KEY'),
      returnUrl: returnUrl,
    );
    card = ioka;
    payouts = ioka;
  } else {
    card = sandbox.card;
    payouts = sandbox.payouts;
  }

  final PaymentProvider kaspi = get('APIPAY_API_KEY').isNotEmpty
      ? KaspiInvoiceProvider(
          baseUrl: Uri.parse(get('APIPAY_API_URL').isEmpty
              ? 'https://bpapi.bazarbay.site/api/v1'
              : get('APIPAY_API_URL')),
          apiKey: get('APIPAY_API_KEY'),
        )
      : sandbox.kaspi;

  return PaymentSetup(
    PaymentGateway(card: card, kaspi: kaspi, payouts: payouts),
    {
      'ioka': get('IOKA_WEBHOOK_SECRET'),
      'apipay': get('APIPAY_WEBHOOK_SECRET'),
    },
  );
}

/// Одной строкой для журнала запуска: кто сейчас принимает деньги.
String describePayments(PaymentGateway gateway) {
  String of(String name, bool sandbox) => sandbox
      ? '$name — тестовый режим'
      : name;
  return 'карты: ${of(gateway.card.name, gateway.card.isSandbox)}; '
      'Kaspi: ${of(gateway.kaspi.name, gateway.kaspi.isSandbox)}; '
      'выплаты: ${of(gateway.payouts.name, gateway.payouts.isSandbox)}';
}
