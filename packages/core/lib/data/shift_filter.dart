import '../l10n/core_strings.dart';

/// Как отсортировать ленту смен.
enum ShiftSort {
  byTime,
  payDesc,
  payAsc;

  /// Подпись в окне фильтра — на языке приложения.
  String get label => coreTr.sort(this);
}

/// Когда начинается смена — так люди и ищут работу: «что-нибудь
/// вечером после учёбы», «ночную, днём я занят».
///
/// Делим по началу смены, а не по всей её длине: человеку важно, во
/// сколько выходить. Ночь — с 22:00 до 05:00, она и переходит через
/// полночь.
enum DayPart {
  morning,
  day,
  evening,
  night;

  static DayPart of(int startMinutes) {
    final hour = startMinutes ~/ 60;
    if (hour >= 5 && hour < 12) return morning;
    if (hour >= 12 && hour < 17) return day;
    if (hour >= 17 && hour < 22) return evening;
    return night;
  }

  /// Подпись в окне фильтра — на языке приложения.
  String get label => coreTr.dayPart(this);
}

/// Пороги «оплата за смену от…» в окне фильтра, в тиынах.
const kMinPaySteps = [500000, 1000000, 1500000];

/// Настройки ленты: что показывать и в каком порядке.
///
/// Отдельный класс, а не пять переменных в состоянии экрана: так фильтр
/// легко передать, сравнить и проверить тестом целиком.
class ShiftFilter {
  final Set<String> companies; // пустое множество — все компании

  /// Ключи категорий работ. Пустое множество — любые.
  final Set<String> categories;
  final bool onlyOpen; // только смены со свободными местами
  final ShiftSort sort;

  /// Что человек ищет словами. Пустая строка — не ищет ничего.
  final String query;

  /// Во сколько начинать. Пустое множество — в любое время.
  final Set<DayPart> dayParts;

  /// Сколько минимум заплатят за смену, в тиынах. 0 — сколько угодно.
  final int minPay;

  const ShiftFilter({
    this.companies = const {},
    this.categories = const {},
    this.onlyOpen = false,
    this.sort = ShiftSort.byTime,
    this.query = '',
    this.dayParts = const {},
    this.minPay = 0,
  });

  bool get isEmpty =>
      companies.isEmpty &&
      categories.isEmpty &&
      !onlyOpen &&
      sort == ShiftSort.byTime &&
      query.isEmpty &&
      dayParts.isEmpty &&
      minPay == 0;

  /// Сколько условий выбрано — показываем числом на кнопке «Фильтр».
  int get activeCount =>
      companies.length +
      categories.length +
      dayParts.length +
      (onlyOpen ? 1 : 0) +
      (minPay > 0 ? 1 : 0);

  ShiftFilter copyWith({
    Set<String>? companies,
    Set<String>? categories,
    bool? onlyOpen,
    ShiftSort? sort,
    String? query,
    Set<DayPart>? dayParts,
    int? minPay,
  }) =>
      ShiftFilter(
        companies: companies ?? this.companies,
        categories: categories ?? this.categories,
        onlyOpen: onlyOpen ?? this.onlyOpen,
        sort: sort ?? this.sort,
        query: query ?? this.query,
        dayParts: dayParts ?? this.dayParts,
        minPay: minPay ?? this.minPay,
      );
}
