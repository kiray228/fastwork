import 'dart:io';

import 'package:fastwork_core/payment.dart';

/// Через кого сервер двигает деньги.
///
/// Сейчас выбор один — тестовый шлюз: карты тестовые, деньги ненастоящие,
/// зато все правила удержания и возврата работают по-настоящему.
///
/// Как подключить настоящего провайдера (ioka, CloudPayments, Freedom Pay,
/// Kaspi Pay — у всех казахстанских схема похожая):
///
///   1. Заключить договор, получить ключи тестового и боевого режима.
///   2. Написать класс `class IokaGateway implements PaymentGateway`:
///      `charge` — списание по токену карты, `refund` — возврат по номеру
///      операции, `payout` — перевод на карту.
///   3. Ключ положить в переменную окружения на хостинге, не в код.
///   4. Выбрать его здесь по `PAYMENT_PROVIDER=ioka`.
///   5. В приложении заменить тестовую «токенизацию» формой провайдера —
///      тогда номер карты вообще не попадёт в наше приложение.
///
/// Ни одно правило в хранилищах менять не придётся: они знают только
/// описание `PaymentGateway`.
PaymentGateway resolvePaymentGateway() {
  final provider = Platform.environment['PAYMENT_PROVIDER'] ?? 'sandbox';
  return switch (provider) {
    'sandbox' => SandboxPaymentGateway(),
    _ => throw StateError(
        'Платёжный провайдер «$provider» не подключён. '
        'Уберите PAYMENT_PROVIDER или напишите для него класс '
        'в lib/payment_gateway.dart',
      ),
  };
}
