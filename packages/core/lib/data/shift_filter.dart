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
  final bool onlyOpen; // только смены со свободными местами
  final ShiftSort sort;

  const ShiftFilter({
    this.companies = const {},
    this.onlyOpen = false,
    this.sort = ShiftSort.byTime,
  });

  bool get isEmpty =>
      companies.isEmpty && !onlyOpen && sort == ShiftSort.byTime;

  /// Сколько условий выбрано — показываем числом на кнопке «Фильтр».
  int get activeCount => companies.length + (onlyOpen ? 1 : 0);

  ShiftFilter copyWith({
    Set<String>? companies,
    bool? onlyOpen,
    ShiftSort? sort,
  }) =>
      ShiftFilter(
        companies: companies ?? this.companies,
        onlyOpen: onlyOpen ?? this.onlyOpen,
        sort: sort ?? this.sort,
      );
}
