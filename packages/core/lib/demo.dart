// Учебные смены «на эту неделю».
//
// Настоящих заказчиков у учебного проекта мало, а пустая лента выглядит
// как сломанное приложение. Раньше демо-смены заводились один раз — в
// день первого запуска, датами «сегодня, завтра, через три дня». Через
// неделю все они оказывались в прошлом, и лента пустела навсегда: и на
// телефоне, и на живом сервере. А в Астане, Караганде, Актобе и Таразе
// их не было вовсе — человек из этих городов не видел ни одной смены.
//
// Теперь демо-смены пересчитываются от сегодняшнего дня на неделю вперёд,
// в каждом городе из списка. Генерация без случайных чисел: для одного и
// того же дня и города всегда получаются одни и те же смены. Так их
// можно дозаводить хоть каждый час — дубликатов не будет, потому что
// хранилище заводит только дни, где демо-смен ещё нет.

import 'shift.dart';
import 'user.dart';

/// На сколько дней вперёд держать демо-смены.
const kDemoDays = 7;

/// Сколько смен в день в одном городе.
const kDemoShiftsPerDay = 3;

/// Заготовка смены — всё, кроме дня, города и адреса.
class _Template {
  final String title;
  final String category;
  final String company;
  final int start;
  final int end;
  final int rate; // тиыны в час
  final int workers;
  final int hired;
  final List<String> duties;
  final String? dressCode;
  final double? minRating;

  const _Template({
    required this.title,
    required this.category,
    required this.company,
    required this.start,
    required this.end,
    required this.rate,
    required this.workers,
    this.hired = 0,
    this.duties = const [],
    this.dressCode,
    this.minRating,
  });
}

const _templates = [
  _Template(
    title: 'Услуги сотрудника склада',
    category: 'warehouse',
    company: 'Золотое яблоко',
    start: 600,
    end: 1320,
    rate: 110000,
    workers: 5,
    hired: 2,
    duties: [
      'Сортировать и упаковывать товары',
      'Принимать и проверять товар на складе',
      'Готовить товары к транспортировке',
    ],
    dressCode: 'Закрытая обувь, удобная сменная одежда.',
  ),
  _Template(
    title: 'Услуги работника торгового зала',
    category: 'sales_floor',
    company: 'Magnum',
    start: 540,
    end: 1080,
    rate: 90000,
    workers: 3,
    hired: 1,
    duties: [
      'Раскладывать товар в зале',
      'Следить за ценниками и сроками годности',
      'Помогать покупателям найти товар',
    ],
    dressCode: 'Тёмный низ, закрытая обувь. Жилет выдадут.',
  ),
  _Template(
    title: 'Услуги грузчика',
    category: 'loader',
    company: 'Заммлер Казахстан',
    start: 1080,
    end: 360, // ночная, до 06:00
    rate: 120000,
    workers: 8,
    hired: 3,
    duties: [
      'Разгружать и загружать автомобили',
      'Сканировать и передавать грузы курьерским службам',
    ],
    dressCode: 'Тёплая одежда — склад не отапливается.',
  ),
  _Template(
    title: 'Услуги курьера',
    category: 'courier',
    company: 'Magnum',
    start: 720,
    end: 960,
    rate: 95000,
    workers: 4,
    duties: [
      'Доставлять заказы по адресам рядом с магазином',
      'Сверять заказ с чеком при выдаче',
    ],
  ),
  _Template(
    title: 'Услуги промоутера',
    category: 'promoter',
    company: 'Sinsay',
    start: 660,
    end: 1140,
    rate: 80000,
    workers: 2,
    duties: ['Раздавать листовки у входа в магазин', 'Рассказывать об акции'],
    dressCode: 'Опрятный внешний вид. Форму выдадут на месте.',
    minRating: 4.5,
  ),
  _Template(
    title: 'Услуги помощника повара',
    category: 'cook_helper',
    company: 'Ресторан «Дастархан»',
    start: 900,
    end: 1380,
    rate: 100000,
    workers: 2,
    duties: [
      'Нарезать овощи и готовить заготовки',
      'Поддерживать чистоту на рабочем месте',
    ],
    dressCode: 'Нужна действующая медкнижка.',
  ),
  _Template(
    title: 'Услуги кассира',
    category: 'cashier',
    company: 'Small',
    start: 480,
    end: 1200,
    rate: 100000,
    workers: 2,
    hired: 1,
    duties: [
      'Обслуживать покупателей на кассе',
      'Принимать оплату наличными и картой',
    ],
  ),
  _Template(
    title: 'Услуги уборщика',
    category: 'cleaner',
    company: 'Бизнес-центр «Нурлы»',
    start: 1200,
    end: 1440 - 60, // 20:00–23:00
    rate: 85000,
    workers: 3,
    duties: [
      'Убирать офисы после рабочего дня',
      'Выносить мусор и протирать поверхности',
    ],
  ),
];

/// Улицы, где «стоят» демо-точки, — своя пара в каждом городе.
const _streets = {
  'Алматы': ['пр. Абая, 109', 'ул. Розыбакиева, 247А'],
  'Астана': ['пр. Мангилик Ел, 55', 'ул. Кенесары, 40'],
  'Шымкент': ['пр. Тауке хана, 12', 'ул. Байтурсынова, 21'],
  'Караганда': ['пр. Бухар-Жырау, 59', 'ул. Ерубаева, 33'],
  'Актобе': ['пр. Абилкайыр хана, 44', 'ул. Маресьева, 7'],
  'Тараз': ['ул. Толе би, 93', 'пр. Жамбыла, 15'],
};

/// Демо-смены одного города на один день.
///
/// Для сегодняшнего дня — только те, что начнутся не раньше чем через
/// час: на начавшуюся смену всё равно не записаться.
List<Shift> demoShiftsFor(String city, DateTime day, DateTime now) {
  final date = DateTime(day.year, day.month, day.day);
  final streets = _streets[city] ?? const ['ул. Абая, 1'];
  final cityIndex = kCities.indexOf(city).clamp(0, kCities.length);
  // Сдвиг по дню и городу: в разные дни и в разных городах — разный
  // набор, но для одной пары «день, город» — всегда один и тот же.
  final seed = date.difference(DateTime(2026)).inDays + cityIndex * 3;

  // Шаг 3 при восьми заготовках обходит их все, ни одну не повторив.
  // Берём первые несколько, что ещё впереди: к вечеру сегодняшний день
  // наполняют вечерние и ночные смены, а не пустота.
  final result = <Shift>[];
  for (var k = 0;
      k < _templates.length && result.length < kDemoShiftsPerDay;
      k++) {
    final t = _templates[(seed + k * 3) % _templates.length];
    final shift = Shift(
      id: 0,
      workDate: date,
      title: t.title,
      category: t.category,
      company: t.company,
      address: 'г. $city, ${streets[result.length % streets.length]}',
      city: city,
      startMinutes: t.start,
      endMinutes: t.end,
      hourlyRate: t.rate,
      workersNeeded: t.workers,
      workersHired: t.hired,
      duties: t.duties,
      dressCode: t.dressCode,
      minRating: t.minRating,
      payoutDelayDays: 1,
    );
    if (shift.startsAt.isBefore(now.add(const Duration(hours: 1)))) continue;
    result.add(shift);
  }
  return result;
}
