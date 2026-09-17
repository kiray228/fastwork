/// Пользователь приложения.
class AppUser {
  final int id;
  final String phone;
  final String fullName;
  final String city;
  final double rating;
  final bool isVerified;

  /// Сколько смен уже отработано. Не хранится в таблице пользователей —
  /// считается запросом по откликам. Вычисляемое не хранят.
  final int completedShifts;

  const AppUser({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.city,
    required this.rating,
    required this.isVerified,
    this.completedShifts = 0,
  });

  /// Уровень выводится из числа смен — отдельного поля для него нет.
  String get level {
    if (completedShifts >= 50) return 'Профи';
    if (completedShifts >= 20) return 'Опытный';
    if (completedShifts >= 5) return 'Уверенный';
    return 'Новичок';
  }

  /// Первые буквы имени и фамилии для аватарки.
  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  AppUser copyWith({int? completedShifts, double? rating}) => AppUser(
        id: id,
        phone: phone,
        fullName: fullName,
        city: city,
        rating: rating ?? this.rating,
        isVerified: isVerified,
        completedShifts: completedShifts ?? this.completedShifts,
      );
}

/// Города, в которых работает fastwork.
const kCities = [
  'Алматы',
  'Астана',
  'Шымкент',
  'Караганда',
  'Актобе',
  'Тараз',
];
