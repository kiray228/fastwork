/// Как отсортировать ленту смен.
enum ShiftSort {
  byTime('Сначала ранние'),
  payDesc('Сначала дорогие'),
  payAsc('Сначала дешёвые');

  final String label;
  const ShiftSort(this.label);
}

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

  const ShiftFilter({
    this.companies = const {},
    this.categories = const {},
    this.onlyOpen = false,
    this.sort = ShiftSort.byTime,
    this.query = '',
  });

  bool get isEmpty =>
      companies.isEmpty &&
      categories.isEmpty &&
      !onlyOpen &&
      sort == ShiftSort.byTime &&
      query.isEmpty;

  /// Сколько условий выбрано — показываем числом на кнопке «Фильтр».
  int get activeCount =>
      companies.length + categories.length + (onlyOpen ? 1 : 0);

  ShiftFilter copyWith({
    Set<String>? companies,
    Set<String>? categories,
    bool? onlyOpen,
    ShiftSort? sort,
    String? query,
  }) =>
      ShiftFilter(
        companies: companies ?? this.companies,
        categories: categories ?? this.categories,
        onlyOpen: onlyOpen ?? this.onlyOpen,
        sort: sort ?? this.sort,
        query: query ?? this.query,
      );
}
