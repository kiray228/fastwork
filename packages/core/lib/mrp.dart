// МРП — месячный расчётный показатель.
//
// Это не зарплата и не курс, а «единица измерения», которой государство
// меряет штрафы, пособия и лимиты. Каждый год закон о бюджете задаёт её
// заново: 3 692 ₸ в 2024-м, 3 932 ₸ в 2025-м, 4 325 ₸ в 2026-м.
//
// Нам он нужен ради одного правила. Исполнитель на платформе работает
// в режиме платформенной занятости, и доход в этом режиме не должен
// превышать 300 МРП в месяц. Сумма в тенге при этом меняется каждый год,
// а правило — нет. Поэтому в коде записано правило («300 МРП»), а сколько
// стоит один МРП — это данные, и живут они отдельно.

/// Значение МРП, действующее с определённой даты.
class MrpRate {
  /// С какого дня действует.
  final DateTime validFrom;

  /// Сколько стоит один МРП, в тиынах — как и все деньги в проекте.
  final int amount;

  const MrpRate({required this.validFrom, required this.amount});

  Map<String, dynamic> toJson() => {
        'validFrom': validFrom.toIso8601String(),
        'amount': amount,
      };

  static MrpRate fromJson(Map<String, dynamic> json) => MrpRate(
        validFrom: DateTime.parse(json['validFrom'] as String),
        amount: json['amount'] as int,
      );
}

/// Значения, которые известны на момент выпуска приложения.
///
/// Это запас на случай, когда спросить не у кого: приложение работает без
/// сервера или сервер ещё не знает новое значение. Настоящий источник —
/// таблица `mrp_rate_rows`: туда новое значение добавляют, когда примут
/// бюджет, и приложение пересобирать не нужно.
final kMrpHistory = [
  MrpRate(validFrom: DateTime(2024, 1, 1), amount: 369200),
  MrpRate(validFrom: DateTime(2025, 1, 1), amount: 393200),
  MrpRate(validFrom: DateTime(2026, 1, 1), amount: 432500),
];

/// Сколько МРП в месяц можно заработать через платформу.
const kEarningsLimitMrp = 300;

/// Какой МРП действовал в этот день.
///
/// Берём последнее значение, начавшее действовать не позже этой даты.
/// Если вдруг даты раньше всех известных — самое раннее: это честнее,
/// чем ноль, при котором лимит закрыл бы любую запись.
int mrpOn(DateTime date, List<MrpRate> rates) {
  final sorted = [...rates]..sort((a, b) => a.validFrom.compareTo(b.validFrom));
  var result = sorted.first.amount;
  for (final r in sorted) {
    if (!r.validFrom.isAfter(date)) result = r.amount;
  }
  return result;
}

/// Лимит дохода за месяц, в тиынах.
///
/// МРП берётся не «сегодняшний», а действовавший на 1 января этого года:
/// так считает закон. Бывало, что МРП меняли посреди года, — лимит от
/// этого не менялся до следующего января.
int monthlyEarningsLimit(DateTime month, List<MrpRate> rates) =>
    kEarningsLimitMrp * mrpOn(DateTime(month.year, 1, 1), rates);

/// Первый день месяца — им обозначаем месяц целиком.
DateTime monthOf(DateTime date) => DateTime(date.year, date.month);

/// Сколько человек уже набрал за месяц и сколько ему можно.
///
/// «Набрал» — это и отработанные смены, и те, на которые он записан.
/// Запись — обязательство выйти, и деньги за неё почти наверняка придут
/// в тот же месяц. Считай мы только отработанное, можно было бы записаться
/// на двадцать смен вперёд и перешагнуть лимит, узнав об этом слишком
/// поздно.
class EarningsLimit {
  final DateTime month;

  /// Уже отработано и подтверждено заказчиком.
  final int earned;

  /// Записан, но ещё не отработал.
  final int booked;

  /// Сколько можно за месяц.
  final int limit;

  /// Значение МРП, по которому считали лимит.
  final int mrp;

  const EarningsLimit({
    required this.month,
    required this.earned,
    required this.booked,
    required this.limit,
    required this.mrp,
  });

  int get used => earned + booked;

  int get remaining => limit - used < 0 ? 0 : limit - used;

  /// Доля лимита, от 0 до 1 — для полоски на экране.
  double get fraction => limit == 0 ? 1 : (used / limit).clamp(0, 1).toDouble();

  /// Поместится ли ещё такая сумма.
  bool allows(int amount) => used + amount <= limit;

  Map<String, dynamic> toJson() => {
        'month': month.toIso8601String(),
        'earned': earned,
        'booked': booked,
        'limit': limit,
        'mrp': mrp,
      };

  static EarningsLimit fromJson(Map<String, dynamic> json) => EarningsLimit(
        month: DateTime.parse(json['month'] as String),
        earned: json['earned'] as int,
        booked: json['booked'] as int,
        limit: json['limit'] as int,
        mrp: json['mrp'] as int,
      );
}

/// Месяц словами — «сентябрь 2026».
String formatMonth(DateTime month) {
  const names = [
    'январь', 'февраль', 'март', 'апрель', 'май', 'июнь',
    'июль', 'август', 'сентябрь', 'октябрь', 'ноябрь', 'декабрь',
  ];
  return '${names[month.month - 1]} ${month.year}';
}
