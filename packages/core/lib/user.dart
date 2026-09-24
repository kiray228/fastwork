import 'terms.dart';

/// Пользователь приложения.
class AppUser {
  final int id;
  final String phone;

  /// Почта — на неё приходит код входа. Пустая у аккаунтов, заведённых
  /// до появления кодов.
  final String? email;
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

  /// Сколько раз записался и не вышел.
  ///
  /// Тоже считается запросом, а не хранится: это просто число откликов
  /// в состоянии «не вышел».
  final int noShows;

  /// Какую версию правил сервиса человек принял. 0 — никакую.
  final int termsVersion;

  const AppUser({
    required this.id,
    required this.phone,
    this.email,
    required this.fullName,
    required this.city,
    required this.rating,
    required this.isVerified,
    this.role = 'worker',
    this.company,
    this.completedShifts = 0,
    this.ratingCount = 0,
    this.noShows = 0,
    this.termsVersion = 0,
  });

  /// Принял ли человек **действующие** правила. Согласие со старой версией
  /// не считается: условия могли поменяться.
  bool get hasAcceptedTerms => termsVersion >= kTermsVersion;

  bool get isManager => role == 'manager';

  /// Сколько смен человек вообще довёл до отметки — вышел или не вышел.
  /// Пока их нет, говорить о надёжности нечего.
  int get attendanceRecord => completedShifts + noShows;

  bool get hasAttendanceRecord => attendanceRecord > 0;

  /// Надёжность в процентах: из скольких смен человек вышел.
  ///
  /// Почему это **отдельное** число, а не поправка к рейтингу.
  ///
  /// Рейтинг отвечает на вопрос «как человек работает», надёжность —
  /// «выходит ли он вообще». Это разные вопросы, и свернув их в одно
  /// число, мы потеряли бы оба: четвёрка перестала бы значить «работает
  /// хорошо», а «не вышел дважды» растворилось бы в среднем.
  ///
  /// К тому же оценку ставит человек и может передумать, а выход —
  /// это факт: вышел или нет.
  int get reliabilityPercent =>
      hasAttendanceRecord ? (completedShifts * 100 / attendanceRecord).round() : 100;

  /// Есть ли у рейтинга основание. Пока оценок нет, показывать «4.0»
  /// как заслуженный рейтинг нечестно — это просто стартовое число.
  bool get hasRatedShifts => ratingCount > 0;

  /// Уровень выводится из числа смен — отдельного поля для него нет.
  String get level => workerLevelFor(completedShifts).name;

  /// Следующий уровень. null — выше уже некуда.
  WorkerLevel? get nextLevel {
    for (final l in kWorkerLevels) {
      if (l.minShifts > completedShifts) return l;
    }
    return null;
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
    int? termsVersion,
  }) =>
      AppUser(
        id: id,
        phone: phone,
        email: email,
        fullName: fullName,
        city: city,
        rating: rating ?? this.rating,
        isVerified: isVerified ?? this.isVerified,
        role: role,
        company: company,
        completedShifts: completedShifts ?? this.completedShifts,
        ratingCount: ratingCount ?? this.ratingCount,
        noShows: noShows,
        termsVersion: termsVersion ?? this.termsVersion,
      );
}

/// Уровень исполнителя: название и сколько смен нужно отработать.
class WorkerLevel {
  final String name;
  final int minShifts;

  const WorkerLevel(this.name, this.minShifts);
}

/// Уровни по возрастанию.
///
/// Раньше пороги жили только внутри `AppUser.level`. Теперь их показывает
/// ещё и история «Рейтинг» — и держать пороги в двух местах значило бы
/// однажды поменять в одном и забыть про другое.
const kWorkerLevels = [
  WorkerLevel('Новичок', 0),
  WorkerLevel('Уверенный', 5),
  WorkerLevel('Опытный', 20),
  WorkerLevel('Профи', 50),
];

/// Уровень для такого числа смен.
WorkerLevel workerLevelFor(int completedShifts) =>
    kWorkerLevels.lastWhere((l) => completedShifts >= l.minShifts);

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
  bool get isNoShow => status == 'no_show';

  /// Заказчик ещё не сказал, вышел человек или нет.
  bool get isUnmarked => !isConfirmed && !isNoShow;
}

extension AppUserJson on AppUser {
  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'email': email,
        'fullName': fullName,
        'city': city,
        'rating': rating,
        'isVerified': isVerified,
        'role': role,
        'company': company,
        'completedShifts': completedShifts,
        'ratingCount': ratingCount,
        'noShows': noShows,
        'termsVersion': termsVersion,
      };
}

AppUser userFromJson(Map<String, dynamic> json) => AppUser(
      id: json['id'] as int,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      fullName: json['fullName'] as String,
      city: json['city'] as String,
      rating: (json['rating'] as num).toDouble(),
      isVerified: json['isVerified'] as bool,
      role: json['role'] as String? ?? 'worker',
      company: json['company'] as String?,
      completedShifts: json['completedShifts'] as int? ?? 0,
      ratingCount: json['ratingCount'] as int? ?? 0,
      noShows: json['noShows'] as int? ?? 0,
      termsVersion: json['termsVersion'] as int? ?? 0,
    );

extension ShiftApplicantJson on ShiftApplicant {
  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'status': status,
        'checkedInAt': checkedInAt?.toIso8601String(),
      };
}

ShiftApplicant applicantFromJson(Map<String, dynamic> json) => ShiftApplicant(
      user: userFromJson(json['user'] as Map<String, dynamic>),
      status: json['status'] as String,
      checkedInAt: json['checkedInAt'] == null
          ? null
          : DateTime.parse(json['checkedInAt'] as String),
    );
