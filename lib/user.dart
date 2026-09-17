/// Пользователь приложения.
class AppUser {
  final int id;
  final String phone;
  final String fullName;
  final String city;
  final double rating;
  final bool isVerified;
  final String role;
  final String? company;

  /// Сколько смен уже отработано. Не хранится в таблице пользователей —
  /// считается запросом по откликам. Вычисляемое не хранят.
  final int completedShifts;

  /// Сколько оценок получил исполнитель. Ноль означает, что `rating` —
  /// это стартовое значение из колонки, а не настоящая средняя оценка.
  final int ratingCount;

  const AppUser({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.city,
    required this.rating,
    required this.isVerified,
    this.role = 'worker',
    this.company,
    this.completedShifts = 0,
    this.ratingCount = 0,
  });

  bool get isManager => role == 'manager';

  /// Есть ли у рейтинга основание. Пока оценок нет, показывать «4.0»
  /// как заслуженный рейтинг нечестно — это просто стартовое число.
  bool get hasRatedShifts => ratingCount > 0;

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

  AppUser copyWith({
    int? completedShifts,
    double? rating,
    bool? isVerified,
    int? ratingCount,
  }) =>
      AppUser(
        id: id,
        phone: phone,
        fullName: fullName,
        city: city,
        rating: rating ?? this.rating,
        isVerified: isVerified ?? this.isVerified,
        role: role,
        company: company,
        completedShifts: completedShifts ?? this.completedShifts,
        ratingCount: ratingCount ?? this.ratingCount,
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

/// Записавшийся на смену — глазами заказчика.
///
/// Это не строка таблицы, а склейка двух: человек из `user_rows` плюс его
/// отклик из `application_rows`. Заказчику нужно и то, и другое сразу:
/// кто пришёл и в каком состоянии его запись.
class ShiftApplicant {
  final AppUser user;
  final String status;
  final DateTime? checkedInAt;

  const ShiftApplicant({
    required this.user,
    required this.status,
    required this.checkedInAt,
  });

  bool get isCheckedIn => checkedInAt != null;
  bool get isConfirmed => status == 'completed';
}
