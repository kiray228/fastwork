import 'l10n/core_strings.dart';

/// Категории работ.
///
/// Раньше о том, что за работа, говорило только название смены — строка,
/// которую заказчик пишет как хочет: «Услуги грузчика», «грузчик»,
/// «Погрузка-разгрузка». Человеку понятно, программе — нет: по такой
/// строке не построить фильтр «покажи всё про склад».
///
/// Категория — это выбор из готового списка. Название по-прежнему
/// уточняет подробности, а категория отвечает на вопрос «какого рода
/// работа» одинаково для всех смен.
///
/// Почему список в коде, а не в таблице базы. Он меняется вместе с
/// приложением: у новой категории появляется значок, место в фильтре,
/// порой и свои правила. Такое правят программисты и выпускают новой
/// версией. А в базе лежит только `id` — короткая латинская строка,
/// которая не меняется, даже если переименовать саму категорию.
class ShiftCategory {
  /// Постоянный ключ: он хранится в базе и ходит по сети.
  final String id;

  /// Ключ раздела — чтобы в списке из сорока пунктов было за что
  /// зацепиться глазом.
  final String group;

  const ShiftCategory(this.id, this.group);

  /// Как называть на экране — на языке человека. Названия живут в
  /// словарях (`l10n/`), а здесь только ключи: так одна и та же категория
  /// зовётся «Грузчик», «Жүк тиеуші» и «Loader», оставаясь `loader`.
  String get name => coreTr.category(id);

  /// Название раздела на языке человека.
  String get groupName => coreTr.categoryGroup(group);

  @override
  String toString() => name;
}

/// Разделы, в том порядке, в каком их показываем.
const kCategoryGroups = [
  'trade',
  'warehouse',
  'food',
  'cleaning',
  'repair',
  'production',
  'events',
  'other',
];

/// Ключ категории «Другое». Её получают смены, созданные до появления
/// категорий, и те, что ни под одну не подходят.
const kOtherCategory = 'other';

/// Все категории. Сорок — примерно столько держат похожие сервисы:
/// меньше — и «сантехник» с «электриком» слипаются в «ремонт», больше —
/// и заказчик тонет в списке.
const kShiftCategories = [
  // Торговля
  ShiftCategory('seller', 'trade'),
  ShiftCategory('cashier', 'trade'),
  ShiftCategory('sales_floor', 'trade'),
  ShiftCategory('merchandiser', 'trade'),
  ShiftCategory('promoter', 'trade'),
  ShiftCategory('inventory', 'trade'),

  // Склад и доставка
  ShiftCategory('loader', 'warehouse'),
  ShiftCategory('warehouse', 'warehouse'),
  ShiftCategory('picker', 'warehouse'),
  ShiftCategory('packer', 'warehouse'),
  ShiftCategory('forklift', 'warehouse'),
  ShiftCategory('courier', 'warehouse'),
  ShiftCategory('driver', 'warehouse'),

  // Общепит
  ShiftCategory('cook', 'food'),
  ShiftCategory('cook_helper', 'food'),
  ShiftCategory('waiter', 'food'),
  ShiftCategory('barista', 'food'),
  ShiftCategory('bartender', 'food'),
  ShiftCategory('dishwasher', 'food'),
  ShiftCategory('baker', 'food'),

  // Уборка
  ShiftCategory('cleaner', 'cleaning'),
  ShiftCategory('housekeeper', 'cleaning'),
  ShiftCategory('janitor', 'cleaning'),
  ShiftCategory('car_wash', 'cleaning'),

  // Ремонт и стройка
  ShiftCategory('plumber', 'repair'),
  ShiftCategory('electrician', 'repair'),
  ShiftCategory('handyman', 'repair'),
  ShiftCategory('builder', 'repair'),
  ShiftCategory('painter', 'repair'),
  ShiftCategory('welder', 'repair'),
  ShiftCategory('furniture', 'repair'),

  // Производство
  ShiftCategory('production', 'production'),

  // Мероприятия и охрана
  ShiftCategory('event_staff', 'events'),
  ShiftCategory('hostess', 'events'),
  ShiftCategory('security', 'events'),
  ShiftCategory('animator', 'events'),

  // Другое
  ShiftCategory('call_center', 'other'),
  ShiftCategory('reception', 'other'),
  ShiftCategory('nanny', 'other'),
  ShiftCategory(kOtherCategory, 'other'),
];

/// Категория по ключу.
///
/// Незнакомый ключ — не ошибка, а «Другое». Так бывает, когда сервер уже
/// знает новую категорию, а приложение на телефоне ещё старое: смена
/// должна показаться, пусть и без точной подписи.
ShiftCategory categoryById(String id) => kShiftCategories.firstWhere(
      (c) => c.id == id,
      orElse: () => kShiftCategories.last,
    );

/// Проверка ключа, пришедшего снаружи — с экрана или по сети.
bool isKnownCategory(String id) => kShiftCategories.any((c) => c.id == id);
