// Здесь живут данные: что такое смена и как считается оплата.
// Экранов в этом файле нет — только «суть».

import 'category.dart';

class Shift {
  final int id;
  final DateTime workDate; // в какой день смена
  final String title; // «Услуги грузчика»

  /// Категория работ — ключ из `kShiftCategories`: `loader`, `cook`...
  /// Название уточняет подробности, категория отвечает, что это за работа.
  final String category;
  final String company; // «Заммлер Казахстан»
  final String address; // адрес точки
  final String city; // город смены
  final int startMinutes; // начало смены, минут от полуночи. 10:00 = 600
  final int endMinutes; // конец смены
  final int breakMinutes; // неоплачиваемый перерыв
  final int hourlyRate; // ставка за час, в тиынах (1100 ₸ = 110000)
  final int workersNeeded; // сколько человек нужно
  final int workersHired; // сколько уже набрано
  final List<String> duties; // обязанности
  final String? dressCode; // требования к одежде
  final String? employerComment; // свободный текст заказчика
  final int payoutDelayDays; // через сколько дней придёт вознаграждение
  final int cancelDeadlineHours; // за сколько часов до смены можно отменить
  final double? minRating; // порог допуска; null — ограничений нет
  final int? createdBy; // какой заказчик создал смену

  /// Статус моего отклика на эту смену: `active`, `cancelled`,
  /// `completed` или null, если я на неё не откликался.
  final String? myStatus;

  /// Когда я отметился на этой смене. null — ещё не отмечался.
  final DateTime? myCheckedInAt;

  /// Когда смену отменил заказчик. null — смена в силе.
  final DateTime? cancelledAt;

  /// Заказчик уже внёс деньги, и сервис их держит — оплата гарантирована.
  final bool isFunded;

  /// Смена создана, но ещё не оплачена. Такую видит только заказчик —
  /// в ленту она попадёт, когда провайдер подтвердит оплату.
  final bool awaitingPayment;

  const Shift({
    required this.id,
    required this.workDate,
    required this.title,
    required this.company,
    required this.address,
    required this.startMinutes,
    required this.endMinutes,
    required this.hourlyRate,
    required this.workersNeeded,
    required this.workersHired,
    this.breakMinutes = 60,
    this.duties = const [],
    this.dressCode,
    this.employerComment,
    this.payoutDelayDays = 1,
    this.cancelDeadlineHours = 10,
    this.minRating,
    this.createdBy,
    this.myStatus,
    this.myCheckedInAt,
    this.cancelledAt,
    this.city = 'Алматы',
    this.category = kOtherCategory,
    this.isFunded = false,
    this.awaitingPayment = false,
  });

  /// Категория целиком — с названием и разделом.
  ShiftCategory get categoryInfo => categoryById(category);

  /// Смену отменил заказчик.
  bool get isCancelled => cancelledAt != null;

  /// Копия смены с изменёнными полями. Сам объект менять нельзя —
  /// все его поля `final`. Это защищает от случайных правок «издалека»:
  /// если что-то поменялось, значит кто-то явно создал новый объект.
  Shift copyWith({
    int? workersHired,
    String? myStatus,
    bool clearMyStatus = false,
    DateTime? myCheckedInAt,
    DateTime? cancelledAt,
    bool? isFunded,
    bool? awaitingPayment,
  }) =>
      Shift(
        id: id,
        workDate: workDate,
        title: title,
        category: category,
        company: company,
        address: address,
        city: city,
        startMinutes: startMinutes,
        endMinutes: endMinutes,
        breakMinutes: breakMinutes,
        hourlyRate: hourlyRate,
        workersNeeded: workersNeeded,
        workersHired: workersHired ?? this.workersHired,
        duties: duties,
        dressCode: dressCode,
        employerComment: employerComment,
        payoutDelayDays: payoutDelayDays,
        cancelDeadlineHours: cancelDeadlineHours,
        minRating: minRating,
        createdBy: createdBy,
        myStatus: clearMyStatus ? null : (myStatus ?? this.myStatus),
        myCheckedInAt: myCheckedInAt ?? this.myCheckedInAt,
        cancelledAt: cancelledAt ?? this.cancelledAt,
        isFunded: isFunded ?? this.isFunded,
        awaitingPayment: awaitingPayment ?? this.awaitingPayment,
      );

  /// Сколько всего длится смена.
  /// Если конец «меньше» начала — значит смена ночная и переходит через
  /// полночь (18:00–06:00). Тогда считаем остаток суток плюс утро.
  int get durationMinutes => endMinutes > startMinutes
      ? endMinutes - startMinutes
      : (1440 - startMinutes) + endMinutes;

  /// Перерыв вычитается только если смена длится больше 5 часов.
  int get paidMinutes =>
      durationMinutes > 300 ? durationMinutes - breakMinutes : durationMinutes;

  /// Итоговая сумма за смену, в тиынах.
  int get totalPay => paidMinutes * hourlyRate ~/ 60;

  /// Сколько мест ещё свободно.
  int get freeSlots => workersNeeded - workersHired;

  /// Есть ли ещё свободные места.
  bool get hasFreeSlots => freeSlots > 0;

  /// Я уже записан на эту смену.
  bool get isApplied => myStatus == 'active';

  /// Смена подтверждена заказчиком — я на ней действительно работал.
  bool get isCompleted => myStatus == 'completed';

  /// Заказчик отметил, что я не вышел на эту смену.
  bool get isNoShow => myStatus == 'no_show';

  /// Место занято мной: и запись, и подтверждённая работа считаются.
  bool get isMine => isApplied || isCompleted;

  /// Я отметился, что пришёл.
  bool get isCheckedIn => myCheckedInAt != null;

  /// Момент, с которого можно отметиться: за час до начала.
  /// Раньше смысла нет, а опоздавшим на час запирать кнопку жестоко —
  /// поэтому верхняя граница не начало смены, а конец дня.
  DateTime get checkInOpensAt => startsAt.subtract(const Duration(hours: 1));

  /// Можно ли отметиться прямо сейчас.
  ///
  /// Время снова передаём параметром, а не берём внутри: только так
  /// правило можно проверить тестом на любую дату.
  bool canCheckInAt(DateTime now) =>
      isApplied &&
      !isCheckedIn &&
      isSameDay(now, workDate) &&
      !now.isBefore(checkInOpensAt);

  /// Смена уже прошла — по календарю, а не по подтверждению.
  bool isPastOn(DateTime now) =>
      workDate.isBefore(DateTime(now.year, now.month, now.day));

  /// Прошла, я был записан, но заказчик так и не подтвердил выход.
  bool isUnconfirmedOn(DateTime now) => isPastOn(now) && isApplied;

  /// Можно ли записаться: места есть и я ещё не записан.
  bool get canApply => hasFreeSlots && !isMine;

  /// Проходит ли исполнитель по рейтингу.
  /// Рейтинг здесь не украшение профиля, а **допуск**: часть заказчиков
  /// не берёт людей ниже определённой оценки.
  bool ratingAllows(double rating) =>
      minRating == null || rating >= minRating!;

  /// Момент начала смены — дата и время вместе.
  DateTime get startsAt => DateTime(
        workDate.year,
        workDate.month,
        workDate.day,
      ).add(Duration(minutes: startMinutes));

  /// Момент конца смены. У ночной смены он приходится на следующий день.
  DateTime get endsAt => startsAt.add(Duration(minutes: durationMinutes));

  /// Смена ещё впереди или идёт прямо сейчас.
  bool isAheadAt(DateTime now) => now.isBefore(endsAt);

  /// Крайний срок отмены: за `cancelDeadlineHours` до начала смены.
  DateTime get cancelDeadline =>
      startsAt.subtract(Duration(hours: cancelDeadlineHours));

  /// Можно ли ещё отменить запись.
  ///
  /// Время передаём параметром, а не берём из `DateTime.now()` внутри.
  /// Так это правило можно проверить тестом на любую дату — иначе тест
  /// зависел бы от того, когда его запустили.
  bool canCancelAt(DateTime now) => now.isBefore(cancelDeadline);

  /// Вычитается ли обед на этой смене.
  bool get hasUnpaidBreak => durationMinutes > 300;

  /// Заканчивается ли смена на следующий день.
  bool get crossesMidnight => endMinutes <= startMinutes;

  /// Короткие ярлыки для карточки: «Ночная», «Выплата завтра» и подобные.
  ///
  /// Мы их не храним — они вычисляются из уже имеющихся полей. Добавится
  /// новое условие, и ярлык появится сам, без правки данных.
  List<String> get tags {
    final result = <String>[];
    if (crossesMidnight) result.add('Ночная');
    if (!hasUnpaidBreak) result.add('Без вычета обеда');
    if (payoutDelayDays == 1) result.add('Выплата завтра');
    if (hasFreeSlots && freeSlots <= 2) result.add('Мало мест');
    return result;
  }
}

/// Один ли это день? Время суток нас не интересует, только дата.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

// ---------------------------------------------------------------------------
// ФОРМАТИРОВАНИЕ — превращаем числа в текст для экрана
// ---------------------------------------------------------------------------

/// 1210000 тиын -> «12 100 ₸»
String formatMoney(int tiyn) {
  final tenge = tiyn ~/ 100;
  final digits = tenge.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(digits[i]);
  }
  return '$buffer ₸';
}

/// 600 -> «10:00»
String formatTime(int minutes) {
  final h = (minutes ~/ 60).toString().padLeft(2, '0');
  final m = (minutes % 60).toString().padLeft(2, '0');
  return '$h:$m';
}

/// 660 -> «11 ч», 690 -> «11 ч 30 мин»
String formatDuration(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? '$h ч' : '$h ч $m мин';
}

const monthsShort = [
  'янв', 'фев', 'мар', 'апр', 'мая', 'июн',
  'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
];

const weekdaysShort = ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'];

/// 2027-03-12 -> «12.03.2027» — так даты пишут в документах.
String formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}.'
    '${date.month.toString().padLeft(2, '0')}.${date.year}';

/// 1 -> «1 день», 3 -> «3 дня», 11 -> «11 дней».
String daysLabel(int days) {
  final last = days % 10;
  final lastTwo = days % 100;
  if (lastTwo >= 11 && lastTwo <= 14) return '$days дней';
  if (last == 1) return '$days день';
  if (last >= 2 && last <= 4) return '$days дня';
  return '$days дней';
}

/// Смена одним сообщением — чтобы переслать другу в мессенджер.
///
/// Кнопка «Поделиться» раньше ничего не делала. Теперь она кладёт в буфер
/// обмена вот это: всё, что нужно, чтобы решить «пойду или нет», без
/// ссылок и без необходимости ставить приложение.
String shiftShareText(Shift shift) {
  final date = shift.workDate;
  return [
    '${shift.title} — ${shift.company}',
    '${date.day} ${monthsShort[date.month - 1]}, '
        '${weekdaysShort[date.weekday - 1]}, '
        '${formatTime(shift.startMinutes)}–${formatTime(shift.endMinutes)}',
    shift.address,
    '${formatMoney(shift.totalPay)} за смену'
        '${shift.isFunded ? ', оплата гарантирована' : ''}',
    'Смена в fastwork',
  ].join('\n');
}

/// «сегодня», «завтра», «послезавтра» или «12 мар, пт».
///
/// Про ближайшие дни люди говорят словами, а не числами: «смена завтра»
/// понятнее, чем «смена 25 сен». Дальше трёх дней слова кончаются.
String relativeDay(DateTime date, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(date.year, date.month, date.day);
  // Разницу считаем по календарю, а не делением часов на 24: в день
  // перевода часов в сутках 23 или 25 часов.
  final diff = DateTime.utc(day.year, day.month, day.day)
      .difference(DateTime.utc(today.year, today.month, today.day))
      .inDays;
  return switch (diff) {
    0 => 'сегодня',
    1 => 'завтра',
    2 => 'послезавтра',
    _ => '${date.day} ${monthsShort[date.month - 1]}, '
        '${weekdaysShort[date.weekday - 1]}',
  };
}

// ---------------------------------------------------------------------------
// ДЕМО-ДАННЫЕ
// Настоящей базы данных пока нет — список прописан руками.
// ---------------------------------------------------------------------------

/// Даты считаем от сегодняшнего дня, чтобы список всегда был актуальным.
/// Поэтому это функция, а не константа: `DateTime.now()` нельзя вычислить
/// заранее, на этапе компиляции.
List<Shift> buildDemoShifts() {
  final today = DateTime.now();
  DateTime day(int plus) => DateTime(today.year, today.month, today.day + plus);

  return [
    Shift(
      id: 1,
      workDate: day(0),
      title: 'Услуги сотрудника склада',
      category: 'warehouse',
      company: 'Золотое яблоко',
      address: 'г. Алматы, ул. Султана Бейбарыса, 1',
      startMinutes: 600, // 10:00
      endMinutes: 1320, // 22:00
      hourlyRate: 110000, // 1100 ₸
      workersNeeded: 5,
      workersHired: 2,
      duties: const [
        'Сортировать и упаковывать товары',
        'Принимать и проверять товар на складе',
        'Готовить товары к транспортировке',
        'Разгружать и загружать автомобили',
      ],
      dressCode: 'Закрытая обувь, удобная сменная одежда. '
          'Шорты и сланцы не допускаются.',
      employerComment: 'Оплачивается только время, проведённое в рабочей зоне. '
          'Вход и выход — через турникет.',
    ),
    Shift(
      id: 2,
      workDate: day(0),
      title: 'Услуги работника торгового зала',
      category: 'sales_floor',
      company: 'Zara',
      address: 'г. Алматы, ул. Розыбакиева, 247А',
      startMinutes: 600,
      endMinutes: 1320,
      hourlyRate: 70000, // 700 ₸
      workersNeeded: 3,
      workersHired: 3, // мест нет
      duties: const [
        'Раскладывать товар в зале',
        'Помогать покупателям',
        'Поддерживать порядок на витринах',
      ],
      dressCode: 'Чёрный верх, чёрный низ, закрытая обувь.',
    ),
    Shift(
      id: 3,
      workDate: day(1),
      title: 'Услуги грузчика (ночная смена)',
      category: 'loader',
      company: 'Заммлер Казахстан',
      address: 'г. Шымкент, Орманшы ж/м, Енбекшинский район',
      startMinutes: 1080, // 18:00
      endMinutes: 360, // 06:00 следующего дня
      hourlyRate: 110000,
      workersNeeded: 10,
      workersHired: 4,
      duties: const [
        'Разгружать и загружать автомобили',
        'Сканировать и передавать грузы курьерским службам',
        'Готовить товары к транспортировке',
      ],
      dressCode: 'Закрытая обувь, тёплая одежда — склад не отапливается.',
      employerComment: 'Ночная смена. Перерыв на отдых — 1 час, не оплачивается.',
    ),
    Shift(
      id: 4,
      workDate: day(1),
      title: 'Услуги курьера',
      category: 'courier',
      company: 'Magnum',
      address: 'г. Алматы, пр. Абая, 109',
      startMinutes: 540, // 09:00
      endMinutes: 780, // 13:00 — короткая, без обеда
      hourlyRate: 90000, // 900 ₸
      workersNeeded: 4,
      workersHired: 1,
      duties: const [
        'Доставлять заказы по адресам рядом с магазином',
        'Принимать оплату',
      ],
    ),
    Shift(
      id: 5,
      workDate: day(3),
      title: 'Услуги промоутера',
      category: 'promoter',
      company: 'Sinsay',
      address: 'г. Шымкент, ТРЦ Mega Planet',
      startMinutes: 660, // 11:00
      endMinutes: 1140, // 19:00
      hourlyRate: 80000, // 800 ₸
      workersNeeded: 2,
      workersHired: 0,
      duties: const [
        'Раздавать листовки у входа в магазин',
        'Рассказывать об акции',
      ],
      dressCode: 'Опрятный внешний вид. Форму выдадим на месте.',
      payoutDelayDays: 2,
      // Этот заказчик берёт только проверенных исполнителей.
      minRating: 4.5,
    ),
    // Уже прошедшая смена — чтобы было что показать в архиве,
    // в кошельке и в отзывах.
    Shift(
      id: 6,
      workDate: day(-3),
      title: 'Услуги сотрудника склада',
      category: 'warehouse',
      company: 'Золотое яблоко',
      address: 'г. Алматы, ул. Султана Бейбарыса, 1',
      startMinutes: 600,
      endMinutes: 1320,
      hourlyRate: 110000,
      workersNeeded: 1,
      workersHired: 0,
    ),
  ];
}

/// «17 сен, 08:00» — для крайнего срока отмены.
String formatDateTime(DateTime dt) =>
    '${dt.day} ${monthsShort[dt.month - 1]}, '
    '${dt.hour.toString().padLeft(2, '0')}:'
    '${dt.minute.toString().padLeft(2, '0')}';

// ---------------------------------------------------------------------------
// JSON — язык, на котором приложение и сервер разговаривают
//
// Программы не могут передать друг другу объект Dart: по сети идёт текст.
// JSON — общепринятый способ записать объект текстом.
//
// Важно, что это описано **здесь**, в одном файле с самой сменой. Значит,
// приложение и сервер понимают смену одинаково не потому, что кто-то
// следил за этим, а потому что читают один и тот же код.
// ---------------------------------------------------------------------------

extension ShiftJson on Shift {
  Map<String, dynamic> toJson() => {
        'id': id,
        // Даты по сети передают строкой по стандарту ISO 8601.
        // '2026-09-17T00:00:00.000' — так её поймёт любой язык, не только Dart.
        'workDate': workDate.toIso8601String(),
        'title': title,
        'category': category,
        'company': company,
        'address': address,
        'city': city,
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
        'breakMinutes': breakMinutes,
        'hourlyRate': hourlyRate,
        'workersNeeded': workersNeeded,
        'workersHired': workersHired,
        'duties': duties,
        'dressCode': dressCode,
        'employerComment': employerComment,
        'payoutDelayDays': payoutDelayDays,
        'cancelDeadlineHours': cancelDeadlineHours,
        'minRating': minRating,
        'createdBy': createdBy,
        'myStatus': myStatus,
        'myCheckedInAt': myCheckedInAt?.toIso8601String(),
        'cancelledAt': cancelledAt?.toIso8601String(),
        'isFunded': isFunded,
        'awaitingPayment': awaitingPayment,
      };
}

Shift shiftFromJson(Map<String, dynamic> json) => Shift(
      id: json['id'] as int,
      workDate: DateTime.parse(json['workDate'] as String),
      title: json['title'] as String,
      // Старый сервер категорию не присылает — значит, «Другое».
      category: json['category'] as String? ?? kOtherCategory,
      company: json['company'] as String,
      address: json['address'] as String,
      city: json['city'] as String? ?? 'Алматы',
      startMinutes: json['startMinutes'] as int,
      endMinutes: json['endMinutes'] as int,
      breakMinutes: json['breakMinutes'] as int,
      hourlyRate: json['hourlyRate'] as int,
      workersNeeded: json['workersNeeded'] as int,
      workersHired: json['workersHired'] as int,
      // Списки из JSON приходят как List<dynamic> — нужно привести к типу.
      duties: (json['duties'] as List<dynamic>).cast<String>(),
      dressCode: json['dressCode'] as String?,
      employerComment: json['employerComment'] as String?,
      payoutDelayDays: json['payoutDelayDays'] as int,
      cancelDeadlineHours: json['cancelDeadlineHours'] as int,
      minRating: (json['minRating'] as num?)?.toDouble(),
      createdBy: json['createdBy'] as int?,
      myStatus: json['myStatus'] as String?,
      myCheckedInAt: json['myCheckedInAt'] == null
          ? null
          : DateTime.parse(json['myCheckedInAt'] as String),
      cancelledAt: json['cancelledAt'] == null
          ? null
          : DateTime.parse(json['cancelledAt'] as String),
      isFunded: json['isFunded'] as bool? ?? false,
      awaitingPayment: json['awaitingPayment'] as bool? ?? false,
    );
