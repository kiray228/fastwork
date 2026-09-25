import 'package:fastwork_core/payment.dart';
import 'package:http/http.dart' as http;

import 'http_json.dart';

/// Оплата через Kaspi.kz: счёт по номеру телефона.
///
/// Так в Kaspi платят чаще всего: магазин выставляет счёт на номер, у
/// человека в приложении Kaspi.kz появляется уведомление «Оплатить
/// ... ₸», он подтверждает — и деньги сразу на счёте Kaspi Pay магазина.
/// Ни карты, ни ссылки не нужно.
///
/// Прямой доступ к API Kaspi банк даёт только по договору партнёра. Пока
/// его нет, счета выставляет ApiPay.kz: его подключают к своему Kaspi Pay
/// как ещё одного кассира, и он выставляет счета от имени магазина.
/// Деньги при этом идут не через ApiPay, а сразу на счёт Kaspi Pay.
///
/// Когда появится договор с Kaspi, рядом встанет класс для их API, а
/// этот можно будет убрать — правила в хранилищах знают только
/// `PaymentProvider`.
///
///   * счёт — `POST /invoices` с номером телефона и суммой;
///   * оплачен ли — `GET /invoices/{id}`, поле `status`;
///   * возврат — `POST /invoices/{id}/refund`;
///   * о каждой оплате ApiPay шлёт вебхук с подписью HMAC-SHA256 в
///     заголовке `X-Webhook-Signature`.
///
/// Kaspi считает в целых тенге, а мы — в тиынах. Поэтому суммы делим на
/// сто; цена смены для этого заранее округлена до тенге (`ShiftCost`).
class KaspiInvoiceProvider implements PaymentProvider {
  /// По умолчанию — https://bpapi.bazarbay.site/api/v1.
  final Uri baseUrl;
  final String apiKey;
  final http.Client client;

  KaspiInvoiceProvider({
    required this.baseUrl,
    required this.apiKey,
    http.Client? client,
  }) : client = client ?? http.Client();

  @override
  String get name => 'apipay';

  /// Тестового режима у Kaspi нет: счёт — это настоящие деньги. Проверять
  /// удобно на счёте в 100 ₸ и возвращать его.
  @override
  bool get isSandbox => false;

  Future<Map<String, dynamic>> _send(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]) =>
      sendJson(
        client,
        provider: name,
        method: method,
        url: Uri.parse('$baseUrl$path'),
        headers: {'X-API-Key': apiKey},
        body: body,
      );

  /// Тиыны в тенге. Меньше тенге Kaspi не принимает — округляем вверх,
  /// чтобы не взять меньше, чем должны.
  static int _tenge(int tiyn) => (tiyn + 99) ~/ 100;

  /// Номер в том виде, в каком его ждёт ApiPay: 8 7XX XXX XX XX.
  static String _phone(String digits) => '8${digits.substring(1)}';

  @override
  Future<ProviderCheckout> startCheckout({
    required int amount,
    required String reference,
    required String description,
    String? phone,
  }) async {
    if (phone == null) {
      throw const PaymentDeclined('Для оплаты в Kaspi нужен номер телефона');
    }
    final json = await _send('POST', '/invoices', {
      'amount': _tenge(amount),
      'phone_number': _phone(phone),
      'description': description,
      'external_order_id': reference,
    });
    final id = findString(json, ['id', 'invoice_id']);
    if (id == null) throw ProviderException(name, 200, 'нет id в ответе');
    return ProviderCheckout(
      operation: id,
      // Ссылку на оплату ApiPay присылает не всегда: главное — push в
      // Kaspi.kz. Если ссылка есть, человек откроет её одним нажатием.
      url: findString(json, ['payment_url', 'pay_url', 'link', 'url']),
    );
  }

  @override
  Future<ProviderResult> checkStatus(String operation) async {
    final json = await _send('GET', '/invoices/$operation');
    final status = (findString(json, ['status']) ?? '').toLowerCase();
    // «Возвращён» — значит, до этого был оплачен.
    if (status == 'paid' || status == 'success' || status == 'refunded') {
      return const ProviderResult(ProviderState.paid, paidWith: 'Kaspi.kz');
    }
    const failed = {
      'cancelled',
      'canceled',
      'expired',
      'failed',
      'rejected',
      'declined',
    };
    if (failed.contains(status)) {
      return ProviderResult(
        ProviderState.failed,
        message: status == 'expired'
            ? 'Счёт в Kaspi.kz истёк — выставьте новый'
            : 'Счёт в Kaspi.kz отклонён',
      );
    }
    return ProviderResult.pending;
  }

  @override
  Future<void> refund({required String operation, required int amount}) =>
      _send('POST', '/invoices/$operation/refund', {'amount': _tenge(amount)});

  /// Номер счёта из вебхука ApiPay.
  static String? operationFromWebhook(Map<String, dynamic> json) =>
      findString(json['invoice'] ?? json['data'] ?? json, ['id', 'invoice_id']);
}
