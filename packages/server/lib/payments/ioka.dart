import 'package:fastwork_core/payment.dart';
import 'package:http/http.dart' as http;

import 'http_json.dart';

/// Оплата картой и вывод на карту через ioka.
///
/// ioka — казахстанский процессинг: принимает Visa, Mastercard, Apple Pay
/// и Google Pay, умеет возвраты и выплаты на карту. Карту человек вводит
/// на странице ioka — к нам её номер не попадает.
///
/// Как устроено:
///
///   * оплата — «заказ» (`POST /v2/orders`); в ответ ссылка
///     `checkout_url`, куда отправляем человека;
///   * заплатил ли — `GET /v2/orders/{id}`, поле `status`;
///   * возврат — по заказу;
///   * вывод — «заказ на перевод» (`POST /v2/transfer-orders`, тип
///     TOPUP): человек вводит свою карту на странице ioka, и деньги
///     уходят на неё.
///
/// Суммы у ioka в тиынах — как и у нас, переводить не нужно.
///
/// Адреса ниже взяты из документации ioka (ioka.kz/docs). Возврат и
/// статус перевода стоит сверить с ней ещё раз в тестовом режиме, когда
/// будут ключи: у провайдеров такие адреса иногда меняются между
/// версиями API. Всё, что может понадобиться поправить, — константы в
/// начале класса.
class IokaProvider implements PaymentProvider, PayoutProvider {
  /// Тестовый контур — stage-api.ioka.kz, боевой — api.ioka.kz.
  final Uri baseUrl;
  final String apiKey;

  /// Куда вернуть человека после оплаты. Сервер отдаёт по этому адресу
  /// страницу «Оплата принята, вернитесь в приложение».
  final String returnUrl;
  final http.Client client;

  IokaProvider({
    required this.baseUrl,
    required this.apiKey,
    required this.returnUrl,
    http.Client? client,
  }) : client = client ?? http.Client();

  static const _orders = '/v2/orders';
  static const _transfers = '/v2/transfer-orders';

  @override
  String get name => 'ioka';

  /// Ключ тестового контура — деньги ненастоящие, хоть и через ioka.
  @override
  bool get isSandbox => baseUrl.host.startsWith('stage');

  Map<String, String> get _headers => {'API-KEY': apiKey};

  Future<Map<String, dynamic>> _send(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]) =>
      sendJson(
        client,
        provider: name,
        method: method,
        url: baseUrl.resolve(path),
        headers: _headers,
        body: body,
      );

  Map<String, dynamic> _urls(String reference) => {
        'back_url': '$returnUrl?ref=$reference',
        'success_url': '$returnUrl?ref=$reference&result=success',
        'failure_url': '$returnUrl?ref=$reference&result=failure',
      };

  ProviderCheckout _checkout(Map<String, dynamic> json) {
    final id = findString(json, ['id', 'order_id']);
    if (id == null) throw ProviderException(name, 200, 'нет id в ответе');
    return ProviderCheckout(
      operation: id,
      url: findString(json, ['checkout_url', 'payment_url']),
    );
  }

  @override
  Future<ProviderCheckout> startCheckout({
    required int amount,
    required String reference,
    required String description,
    String? phone,
  }) async =>
      _checkout(await _send('POST', _orders, {
        'amount': amount,
        'currency': 'KZT',
        // Сразу списываем, а не «замораживаем»: держать деньги до смены
        // будет сервис, а заморозка на карте живёт всего несколько дней.
        'capture_method': 'AUTO',
        'external_id': reference,
        'description': description,
        ..._urls(reference),
      }));

  @override
  Future<ProviderResult> checkStatus(String operation) async {
    final json = await _send('GET', '$_orders/$operation');
    return _result(json);
  }

  @override
  Future<void> refund({required String operation, required int amount}) =>
      _send('POST', '$_orders/$operation/refunds', {'amount': amount});

  @override
  Future<ProviderCheckout> startPayout({
    required int amount,
    required String reference,
    required String description,
  }) async =>
      _checkout(await _send('POST', _transfers, {
        'amount': amount,
        'currency': 'KZT',
        'type': 'TOPUP',
        'external_id': reference,
        'description': description,
        ..._urls(reference),
      }));

  @override
  Future<ProviderResult> checkPayout(String operation) async =>
      _result(await _send('GET', '$_transfers/$operation'));

  /// Состояние заказа по его `status`.
  ///
  /// Неизвестное состояние считаем «ещё ждём»: лучше спросить ещё раз,
  /// чем по ошибке опубликовать неоплаченную смену или объявить отказ.
  ProviderResult _result(Map<String, dynamic> json) {
    final status = (findString(json, ['status']) ?? '').toUpperCase();
    const paid = {'PAID', 'CHARGED', 'CAPTURED', 'SUCCEEDED', 'SUCCESS'};
    const failed = {
      'DECLINED',
      'FAILED',
      'CANCELLED',
      'CANCELED',
      'EXPIRED',
      'REJECTED',
    };
    if (paid.contains(status)) {
      final pan = findString(json, ['pan_masked', 'masked_pan', 'card_mask']);
      return ProviderResult(
        ProviderState.paid,
        paidWith: pan == null ? 'картой' : 'картой $pan',
      );
    }
    if (failed.contains(status)) {
      return ProviderResult(
        ProviderState.failed,
        message: findString(json, ['error_message', 'decline_reason']) ??
            'Банк не провёл оплату',
      );
    }
    return ProviderResult.pending;
  }

  /// Номер заказа из вебхука ioka — чтобы найти, о какой оплате речь.
  ///
  /// Сначала ищем прямое «order_id»: в событии о платеже верхний `id` —
  /// это номер платежа, а не заказа.
  static String? operationFromWebhook(Map<String, dynamic> json) =>
      findString(json, ['order_id', 'transfer_order_id']) ??
      findString(json['order'] ?? json['transfer_order'], ['id']) ??
      findString(json, ['id']);
}
