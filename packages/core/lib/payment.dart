// Деньги: комиссия, карта, кошелёк и платёжный шлюз.
//
// Главная мысль всего раздела — **сервис гарант**. Заказчик платит не
// исполнителю напрямую и не «потом», а сервису и заранее, в момент
// публикации смены. Деньги лежат у сервиса, пока смена не состоится:
//
//   публикация ──► заказчик платит картой, деньги удержаны
//       │
//       ├── заказчик подтвердил выход ──► деньги уходят исполнителю
//       ├── исполнитель не вышел     ──► деньги за место — заказчику
//       └── смену отменили           ──► остаток — заказчику
//
// Исполнитель видит на смене «оплата гарантирована» и знает: деньги уже
// есть, их не придётся выпрашивать. Заказчик знает: заплатит только за
// тех, кто действительно вышел.

import 'errors.dart';
import 'shift.dart';

/// Комиссия сервиса в процентах.
///
/// Платит заказчик — сверху суммы вознаграждения. Исполнитель получает
/// ровно то, что написано в смене: иначе «12 100 ₸» на карточке была бы
/// неправдой.
const kPlatformFeePercent = 4;

/// Комиссия с суммы, в тиынах, с округлением до тиына.
int platformFee(int amount) => (amount * kPlatformFeePercent / 100).round();

/// Сколько стоит смена заказчику.
///
/// Комиссию считаем с одного места и умножаем на число мест, а не берём
/// четыре процента со всей суммы. Разница — доли тиына на округлении, но
/// так возврат за одно место всегда равен ровно тому, что за это место
/// заплатили, и копейки не теряются и не появляются из ниоткуда.
class ShiftCost {
  final int slotPay;
  final int slots;

  const ShiftCost({required this.slotPay, required this.slots});

  factory ShiftCost.of(Shift shift) =>
      ShiftCost(slotPay: shift.totalPay, slots: shift.workersNeeded);

  int get slotFee => platformFee(slotPay);

  /// Вознаграждение всем исполнителям.
  int get pay => slotPay * slots;

  /// Комиссия сервиса.
  int get fee => slotFee * slots;

  /// Итого к оплате.
  int get total => pay + fee;
}

// ---------------------------------------------------------------------------
// КАРТА
// ---------------------------------------------------------------------------

/// Карта, как её видит сервис: токен и последние четыре цифры.
///
/// Номера карты здесь **нет** и быть не должно. Хранить и даже пропускать
/// через свой сервер номера карт можно только с сертификатом PCI DSS —
/// это аудит, деньги и месяцы работы. Поэтому номер принимает платёжный
/// провайдер: своей формой или своей библиотекой прямо на телефоне, — а
/// нам отдаёт токен, по которому может списать деньги. Украдут токен —
/// им можно заплатить только нам же.
class PaymentCard {
  /// Токен от провайдера.
  final String token;
  final String last4;

  /// Платёжная система: Visa, Mastercard...
  final String brand;

  const PaymentCard({
    required this.token,
    required this.last4,
    required this.brand,
  });

  /// «Visa •• 4242» — так карту показываем на экране.
  String get masked => '$brand •• $last4';

  Map<String, dynamic> toJson() => {
        'token': token,
        'last4': last4,
        'brand': brand,
      };

  static PaymentCard fromJson(Map<String, dynamic> json) => PaymentCard(
        token: json['token'] as String,
        last4: json['last4'] as String,
        brand: json['brand'] as String,
      );
}

/// Только цифры из того, что человек ввёл: «4242 4242…» -> «42424242…».
String cardDigits(String input) => input.replaceAll(RegExp(r'\D'), '');

/// Проверка номера по алгоритму Луна.
///
/// Последняя цифра номера — контрольная: она вычисляется из остальных.
/// Опечатка в одной цифре или перестановка соседних почти всегда ломает
/// сумму. Так опечатку ловят ещё на телефоне, не спрашивая банк.
bool luhnValid(String digits) {
  if (digits.length < 13 || digits.length > 19) return false;
  var sum = 0;
  var doubleIt = false;
  for (var i = digits.length - 1; i >= 0; i--) {
    var d = digits.codeUnitAt(i) - 48;
    if (d < 0 || d > 9) return false;
    if (doubleIt) {
      d *= 2;
      if (d > 9) d -= 9;
    }
    sum += d;
    doubleIt = !doubleIt;
  }
  return sum % 10 == 0;
}

/// Платёжная система по первым цифрам номера.
String cardBrand(String digits) {
  if (digits.startsWith('4')) return 'Visa';
  // МИР проверяем раньше Mastercard: его 2200–2204 иначе попали бы под
  // «начинается на 22», а это уже диапазон Mastercard.
  if (RegExp(r'^220[0-4]').hasMatch(digits)) return 'МИР';
  if (RegExp(r'^(5[1-5]|2[2-7])').hasMatch(digits)) return 'Mastercard';
  if (digits.startsWith('62')) return 'UnionPay';
  if (RegExp(r'^3[47]').hasMatch(digits)) return 'Amex';
  return 'Карта';
}

/// Срок действия «ММ/ГГ» ещё не истёк.
///
/// Карта действует до конца указанного месяца включительно: «09/26»
/// работает весь сентябрь 2026-го.
bool expiryValid(String input, DateTime now) {
  final match = RegExp(r'^(\d{2})\s*/?\s*(\d{2})$').firstMatch(input.trim());
  if (match == null) return false;
  final month = int.parse(match.group(1)!);
  final year = 2000 + int.parse(match.group(2)!);
  if (month < 1 || month > 12) return false;
  return !DateTime(year, month + 1).isBefore(DateTime(now.year, now.month, 2));
}

// ---------------------------------------------------------------------------
// ПЛАТЁЖНЫЙ ШЛЮЗ
// ---------------------------------------------------------------------------

/// Отказ в оплате — его текст можно показать человеку.
class PaymentDeclined extends UserError {
  const PaymentDeclined(super.message);
}

/// Что сервису нужно от платёжного провайдера.
///
/// Тот же приём, что с хранилищами: экраны и правила знают только это
/// описание. Сегодня под ним тестовый шлюз, завтра — настоящий провайдер,
/// и ни одно правило про удержание и возврат переписывать не придётся.
abstract class PaymentGateway {
  /// Тестовый ли это шлюз. Экран честно предупреждает, что деньги
  /// ненастоящие.
  bool get isSandbox;

  /// Списать деньги с карты. Возвращает номер операции у провайдера —
  /// по нему потом делают возврат.
  Future<String> charge({
    required int amount,
    required PaymentCard card,
    required String description,
  });

  /// Вернуть часть или всё списанное по операции.
  Future<void> refund({required String operation, required int amount});

  /// Перевести деньги на карту — вывод заработанного.
  Future<String> payout({required int amount, required PaymentCard card});
}

/// Тестовая карта: проходит всегда.
const kSandboxCardNumber = '4242 4242 4242 4242';

/// Тестовая карта: банк отказывает.
const kSandboxDeclinedCardNumber = '4000 0000 0000 0002';

/// Тестовый шлюз: деньги не настоящие, но правила — настоящие.
///
/// Ведёт себя как провайдер в тестовом режиме: принимает только свои
/// тестовые токены, по карте на …0002 отвечает отказом. Все операции
/// записывает в список — тесты по нему проверяют, что и сколько списали.
class SandboxPaymentGateway implements PaymentGateway {
  final operations = <String>[];
  var _next = 1;

  @override
  bool get isSandbox => true;

  String _op(String kind, int amount) {
    final id = 'sandbox-$kind-${_next++}';
    operations.add('$kind:$amount');
    return id;
  }

  void _check(PaymentCard card) {
    if (!card.token.startsWith('sandbox_')) {
      throw const PaymentDeclined('Карта не принята тестовым шлюзом');
    }
    if (card.last4 == '0002') {
      throw const PaymentDeclined('Банк отклонил операцию. Попробуйте '
          'другую карту');
    }
  }

  @override
  Future<String> charge({
    required int amount,
    required PaymentCard card,
    required String description,
  }) async {
    _check(card);
    return _op('charge', amount);
  }

  @override
  Future<void> refund({required String operation, required int amount}) async {
    _op('refund', amount);
  }

  @override
  Future<String> payout({required int amount, required PaymentCard card}) async {
    _check(card);
    return _op('payout', amount);
  }
}

/// «Токенизация» в тестовом режиме.
///
/// Настоящий провайдер делает это у себя: принимает номер и отдаёт токен.
/// Здесь мы только изображаем его — из номера на устройстве остаются
/// последние четыре цифры, и дальше номер не идёт.
PaymentCard tokenizeSandboxCard(String number) {
  final digits = cardDigits(number);
  final last4 = digits.substring(digits.length - 4);
  return PaymentCard(
    token: 'sandbox_$last4',
    last4: last4,
    brand: cardBrand(digits),
  );
}

// ---------------------------------------------------------------------------
// КОШЕЛЁК
// ---------------------------------------------------------------------------

/// Виды движений денег.
class WalletEntryKind {
  WalletEntryKind._();

  /// Исполнителю начислено за смену (+).
  static const earning = 'earning';

  /// Исполнитель вывел деньги на карту (−).
  static const withdrawal = 'withdrawal';

  /// Заказчик оплатил смену картой (−).
  static const charge = 'charge';

  /// Заказчику вернули деньги на карту (+).
  static const refund = 'refund';
}

/// Одна строка истории денег.
class WalletEntry {
  final int id;
  final String kind;

  /// Сумма со знаком: пришло — плюс, ушло — минус. В тиынах.
  final int amount;
  final int? shiftId;
  final String title;
  final DateTime createdAt;

  const WalletEntry({
    required this.id,
    required this.kind,
    required this.amount,
    required this.title,
    required this.createdAt,
    this.shiftId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind,
        'amount': amount,
        'shiftId': shiftId,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
      };

  static WalletEntry fromJson(Map<String, dynamic> json) => WalletEntry(
        id: json['id'] as int,
        kind: json['kind'] as String,
        amount: json['amount'] as int,
        shiftId: json['shiftId'] as int?,
        title: json['title'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Кошелёк целиком: сколько можно вывести и откуда это взялось.
class WalletSummary {
  /// Доступно к выводу — начисления минус выводы.
  ///
  /// Не хранится, а считается по истории. Правило то же, что с числом
  /// записавшихся: вычисляемое не хранят. Баланс, записанный в отдельную
  /// колонку, рано или поздно разошёлся бы с историей, и было бы неясно,
  /// кому верить.
  final int balance;

  /// Заработано за всё время — сумма начислений.
  final int earnedTotal;

  final List<WalletEntry> entries;

  /// Деньги ненастоящие — тестовый шлюз.
  final bool sandbox;

  const WalletSummary({
    required this.balance,
    required this.earnedTotal,
    required this.entries,
    required this.sandbox,
  });

  /// Свести историю в итог.
  factory WalletSummary.from(List<WalletEntry> entries, {required bool sandbox}) {
    var balance = 0;
    var earned = 0;
    for (final e in entries) {
      if (e.kind == WalletEntryKind.earning) {
        balance += e.amount;
        earned += e.amount;
      } else if (e.kind == WalletEntryKind.withdrawal) {
        balance += e.amount; // сумма уже с минусом
      }
    }
    return WalletSummary(
      balance: balance,
      earnedTotal: earned,
      entries: entries,
      sandbox: sandbox,
    );
  }

  Map<String, dynamic> toJson() => {
        'balance': balance,
        'earnedTotal': earnedTotal,
        'entries': entries.map((e) => e.toJson()).toList(),
        'sandbox': sandbox,
      };

  static WalletSummary fromJson(Map<String, dynamic> json) => WalletSummary(
        balance: json['balance'] as int,
        earnedTotal: json['earnedTotal'] as int,
        entries: (json['entries'] as List<dynamic>)
            .map((e) => WalletEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        sandbox: json['sandbox'] as bool,
      );
}
