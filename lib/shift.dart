// Здесь живут данные: что такое смена и как считается оплата.
// Экранов в этом файле нет — только «суть».

class Shift {
  final int id;
  final DateTime workDate; // в какой день смена
  final String title; // «Услуги грузчика»
  final String company; // «Заммлер Казахстан»
  final String address; // адрес точки
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

  /// Статус моего отклика на эту смену: `active`, `cancelled` или null,
  /// если я на неё не откликался. Приходит из базы вместе со сменой.
  final String? myStatus;

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
    this.myStatus,
  });

  /// Копия смены с изменёнными полями. Сам объект менять нельзя —
  /// все его поля `final`. Это защищает от случайных правок «издалека»:
  /// если что-то поменялось, значит кто-то явно создал новый объект.
  Shift copyWith({int? workersHired, String? myStatus, bool clearMyStatus = false}) =>
      Shift(
        id: id,
        workDate: workDate,
        title: title,
        company: company,
        address: address,
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
        myStatus: clearMyStatus ? null : (myStatus ?? this.myStatus),
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

  /// Можно ли записаться: места есть и я ещё не записан.
  bool get canApply => hasFreeSlots && !isApplied;

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
  ];
}

/// «17 сен, 08:00» — для крайнего срока отмены.
String formatDateTime(DateTime dt) =>
    '${dt.day} ${monthsShort[dt.month - 1]}, '
    '${dt.hour.toString().padLeft(2, '0')}:'
    '${dt.minute.toString().padLeft(2, '0')}';
