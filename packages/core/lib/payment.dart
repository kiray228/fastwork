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

  /// Комиссия за одно место. Итог за место округляем вверх до целого
  /// тенге: Kaspi выставляет счёт только в целых тенге, а тиыны сверху
  /// пусть лучше достанутся комиссии, чем потеряются между системами.
  int get slotFee => ((slotPay + platformFee(slotPay) + 99) ~/ 100) * 100 -
      slotPay;

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
// СПОСОБЫ ОПЛАТЫ
// ---------------------------------------------------------------------------

/// Чем платит заказчик.
///
/// Два способа, и оба обязательны: карту принимает любой банк, а Kaspi —
/// это то, чем в Казахстане платит большинство людей. Устроены они по-разному:
/// карту вводят на странице провайдера, а за Kaspi приходит счёт прямо в
/// приложение Kaspi.kz, и человек подтверждает его там.
enum PaymentMethod {
  card('card', 'Банковская карта'),
  kaspi('kaspi', 'Kaspi.kz');

  /// Ключ — хранится в базе и ходит по сети.
  final String id;
  final String title;

  const PaymentMethod(this.id, this.title);

  /// Незнакомый ключ — карта: старые записи сделаны до появления Kaspi.
  static PaymentMethod fromId(String? id) =>
      values.firstWhere((m) => m.id == id, orElse: () => card);
}

/// Номер телефона для счёта в Kaspi: 11 цифр, начинается с 7.
///
/// Люди пишут номер как привыкли: «+7 701 …», «8 701 …», «701 …». Kaspi
/// нужен один вид. null — номер не похож на казахстанский мобильный.
String? normalizeKzPhone(String input) {
  var digits = input.replaceAll(RegExp(r'\D'), '');
  if (digits.length == 10) digits = '7$digits';
  if (digits.length == 11 && digits.startsWith('8')) {
    digits = '7${digits.substring(1)}';
  }
  if (digits.length != 11 || !digits.startsWith('77')) return null;
  return digits;
}

/// 77011234567 -> «+7 701 123 45 67».
String formatKzPhone(String digits) => digits.length != 11
    ? '+$digits'
    : '+${digits[0]} ${digits.substring(1, 4)} ${digits.substring(4, 7)} '
        '${digits.substring(7, 9)} ${digits.substring(9)}';

// ---------------------------------------------------------------------------
// ПРОВАЙДЕРЫ
// ---------------------------------------------------------------------------

/// Отказ в оплате — его текст можно показать человеку.
class PaymentDeclined extends UserError {
  const PaymentDeclined(super.message);
}

/// Провайдер начал оплату: вот номер операции и куда отправить человека.
class ProviderCheckout {
  /// Номер операции у провайдера. По нему спрашивают, заплатили ли, и
  /// по нему же потом возвращают деньги.
  final String operation;

  /// Страница провайдера, где человек платит. null — никуда идти не
  /// нужно: счёт уже пришёл в Kaspi.kz или это тестовый режим.
  final String? url;

  const ProviderCheckout({required this.operation, this.url});
}

/// Чем закончилась операция у провайдера.
enum ProviderState { pending, paid, failed }

class ProviderResult {
  final ProviderState state;

  /// Почему не прошло — «банк отклонил», «счёт отменён».
  final String? message;

  /// Чем заплатили — чтобы написать в истории «Visa •• 4242».
  final String? paidWith;

  const ProviderResult(this.state, {this.message, this.paidWith});

  static const pending = ProviderResult(ProviderState.pending);
}

/// Приём денег одним способом.
///
/// Оплата устроена одинаково у всех провайдеров, и у карт, и у Kaspi:
///
///   1. «Начать» — провайдер заводит операцию и говорит, куда отправить
///      человека (или сам шлёт ему счёт).
///   2. Человек платит — у провайдера, не у нас.
///   3. «Как дела» — спрашиваем, прошла ли оплата. Провайдер ещё и сам
///      сообщает об этом (вебхук), но верим мы только ответу на свой
///      вопрос: вебхук может подделать кто угодно, а ответ на наш запрос
///      по защищённому соединению — нет.
///
/// Номер карты и деньги до нас не доходят вообще: их принимает провайдер.
/// Поэтому не нужен сертификат PCI DSS.
abstract class PaymentProvider {
  /// Короткое имя: `sandbox`, `ioka`, `apipay`.
  String get name;

  /// Тестовый ли режим — деньги ненастоящие.
  bool get isSandbox;

  Future<ProviderCheckout> startCheckout({
    required int amount,
    required String reference,
    required String description,
    String? phone,
  });

  Future<ProviderResult> checkStatus(String operation);

  /// Вернуть часть или всё по операции.
  Future<void> refund({required String operation, required int amount});
}

/// Вывод денег исполнителю на карту.
///
/// Тоже через страницу провайдера: карту человек вводит там, а не у нас.
/// Карта Kaspi Gold — обычная карта Visa, на неё вывод идёт так же.
abstract class PayoutProvider {
  String get name;
  bool get isSandbox;

  Future<ProviderCheckout> startPayout({
    required int amount,
    required String reference,
    required String description,
  });

  Future<ProviderResult> checkPayout(String operation);
}

/// Все деньги сервиса: чем принимаем и чем выплачиваем.
///
/// Правила удержания и возврата в хранилищах знают только этот класс.
/// Какие за ним провайдеры — настоящие или тестовые — решает тот, кто его
/// собирает: сервер по переменным окружения, приложение без сервера —
/// всегда тестовые.
class PaymentGateway {
  final PaymentProvider card;
  final PaymentProvider kaspi;
  final PayoutProvider payouts;

  PaymentGateway({
    required this.card,
    required this.kaspi,
    required this.payouts,
  });

  PaymentProvider provider(PaymentMethod method) =>
      method == PaymentMethod.kaspi ? kaspi : card;

  /// Хоть где-то деньги ненастоящие — экран честно об этом скажет.
  bool get isSandbox => card.isSandbox || kaspi.isSandbox;

  /// Тестовый провайдер этого способа — чтобы «заплатить» без провайдера.
  SandboxProvider? sandboxFor(PaymentMethod method) {
    final p = provider(method);
    return p is SandboxProvider ? p : null;
  }

  SandboxProvider? get sandboxPayouts {
    final p = payouts;
    return p is SandboxProvider ? p : null;
  }
}

/// Тестовая карта: проходит всегда.
const kSandboxCardNumber = '4242 4242 4242 4242';

/// Тестовая карта: банк отказывает.
const kSandboxDeclinedCardNumber = '4000 0000 0000 0002';

/// Тестовый номер Kaspi, по которому счёт отклоняют.
const kSandboxDeclinedKaspiPhone = '77000000002';

/// Тестовый провайдер: деньги ненастоящие, но путь — настоящий.
///
/// Операция так же начинается, ждёт оплаты и заканчивается — только
/// вместо страницы провайдера человек «платит» в самом приложении:
/// вводит тестовую карту или нажимает «Оплатить в Kaspi». Все движения
/// записываются в `log` — тесты по нему проверяют, что и сколько прошло.
class SandboxProvider implements PaymentProvider, PayoutProvider {
  final PaymentMethod method;
  final List<String> log;
  final _ops = <String, _SandboxOp>{};
  static var _next = 1;

  SandboxProvider(this.method, {List<String>? log}) : log = log ?? [];

  @override
  String get name => 'sandbox';

  @override
  bool get isSandbox => true;

  String _open(String kind, int amount, {String? phone}) {
    final id = 'sandbox-$kind-${_next++}';
    _ops[id] = _SandboxOp(kind, amount, phone);
    return id;
  }

  @override
  Future<ProviderCheckout> startCheckout({
    required int amount,
    required String reference,
    required String description,
    String? phone,
  }) async =>
      ProviderCheckout(operation: _open('pay', amount, phone: phone));

  @override
  Future<ProviderResult> checkStatus(String operation) async =>
      _ops[operation]?.result ?? ProviderResult.pending;

  @override
  Future<void> refund({required String operation, required int amount}) async {
    log.add('refund:$amount');
  }

  @override
  Future<ProviderCheckout> startPayout({
    required int amount,
    required String reference,
    required String description,
  }) async =>
      ProviderCheckout(operation: _open('payout', amount));

  @override
  Future<ProviderResult> checkPayout(String operation) =>
      checkStatus(operation);

  /// «Заплатить» по тестовой операции — то, что у настоящего провайдера
  /// человек делает на его странице или в Kaspi.kz.
  ///
  /// Карта нужна для карточной оплаты и для вывода; по карте на …0002 и
  /// по номеру Kaspi на …0002 приходит отказ — как от банка.
  ProviderResult complete(String operation, {PaymentCard? card}) {
    final op = _ops[operation];
    if (op == null) {
      return const ProviderResult(ProviderState.failed,
          message: 'Операция не найдена');
    }
    if (op.result.state != ProviderState.pending) return op.result;

    final String paidWith;
    if (method == PaymentMethod.kaspi && op.kind == 'pay') {
      if (op.phone == kSandboxDeclinedKaspiPhone) {
        return op.result = const ProviderResult(ProviderState.failed,
            message: 'Счёт отклонён в Kaspi.kz');
      }
      paidWith = 'Kaspi.kz';
    } else {
      if (card == null || !card.token.startsWith('sandbox_')) {
        return op.result = const ProviderResult(ProviderState.failed,
            message: 'Карта не принята тестовым шлюзом');
      }
      if (card.last4 == '0002') {
        return op.result = const ProviderResult(ProviderState.failed,
            message: 'Банк отклонил операцию. Попробуйте другую карту');
      }
      paidWith = card.masked;
    }

    log.add('${op.kind == 'pay' ? 'charge' : 'payout'}:${op.amount}');
    return op.result = ProviderResult(ProviderState.paid, paidWith: paidWith);
  }
}

class _SandboxOp {
  final String kind;
  final int amount;
  final String? phone;
  ProviderResult result = ProviderResult.pending;

  _SandboxOp(this.kind, this.amount, this.phone);
}

/// Всё тестовое: и карта, и Kaspi, и выплаты. Так работает приложение
/// без сервера и так работают тесты.
class SandboxPaymentGateway extends PaymentGateway {
  /// Общий журнал всех тестовых операций.
  final List<String> operations;

  SandboxPaymentGateway._(this.operations, SandboxProvider card)
      : super(
          card: card,
          kaspi: SandboxProvider(PaymentMethod.kaspi, log: operations),
          payouts: card,
        );

  factory SandboxPaymentGateway() {
    final log = <String>[];
    return SandboxPaymentGateway._(
      log,
      SandboxProvider(PaymentMethod.card, log: log),
    );
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
// ОПЛАТА ГЛАЗАМИ ЭКРАНА
// ---------------------------------------------------------------------------

/// Состояние одной оплаты: ждём, прошла, не прошла.
class CheckoutStatus {
  CheckoutStatus._();

  static const pending = 'pending';
  static const paid = 'paid';
  static const failed = 'failed';
}

/// Начатая оплата — то, что экран показывает, пока человек платит.
///
/// Одна и та же для оплаты смены, доплаты при правке и вывода денег:
/// номер, сумма, способ, куда идти и чем всё кончилось.
class PaymentCheckout {
  /// Номер оплаты у нас — по нему экран спрашивает, как дела.
  final int id;

  /// Смена, за которую платят. null — это вывод денег.
  final int? shiftId;
  final PaymentMethod method;
  final int amount;
  final String status;

  /// Страница провайдера. null — открывать нечего.
  final String? url;

  /// Телефон, на который ушёл счёт Kaspi.
  final String? phone;

  /// Тестовый режим: платить в самом приложении.
  final bool sandbox;

  /// Почему не прошло.
  final String? message;

  const PaymentCheckout({
    required this.id,
    required this.method,
    required this.amount,
    required this.status,
    this.shiftId,
    this.url,
    this.phone,
    this.sandbox = false,
    this.message,
  });

  bool get isPaid => status == CheckoutStatus.paid;
  bool get isPending => status == CheckoutStatus.pending;
  bool get isFailed => status == CheckoutStatus.failed;

  Map<String, dynamic> toJson() => {
        'id': id,
        'shiftId': shiftId,
        'method': method.id,
        'amount': amount,
        'status': status,
        'url': url,
        'phone': phone,
        'sandbox': sandbox,
        'message': message,
      };

  static PaymentCheckout fromJson(Map<String, dynamic> json) =>
      PaymentCheckout(
        id: json['id'] as int,
        shiftId: json['shiftId'] as int?,
        method: PaymentMethod.fromId(json['method'] as String?),
        amount: json['amount'] as int,
        status: json['status'] as String,
        url: json['url'] as String?,
        phone: json['phone'] as String?,
        sandbox: json['sandbox'] as bool? ?? false,
        message: json['message'] as String?,
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

  /// Провайдер сообщил, что перевод дошёл. Сумма ноль: деньги ушли с
  /// баланса ещё при заявке на вывод, эта строка только о том, куда.
  static const payoutDone = 'payout_done';
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
