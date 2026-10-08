import 'package:fastwork_core/data/fake_shift_repository.dart';
import 'package:fastwork_core/data/shift_repository.dart';

/// Часы, которые тест переводит сам.
///
/// Правила записи зависят от времени: записаться можно до начала смены,
/// подтвердить выход — только после. Тест на настоящих часах проходил бы
/// утром и падал вечером. С этими часами тест сам решает, который час:
/// «сейчас утро, записываемся» — а потом «смена прошла, подтверждаем».
class TestClock {
  DateTime now;

  TestClock(this.now);

  /// Сегодня в заданное время — удобно, если смены в тесте сегодняшние.
  TestClock.today({int hour = 6}) : now = _todayAt(hour);

  static DateTime _todayAt(int hour) {
    final real = DateTime.now();
    return DateTime(real.year, real.month, real.day, hour);
  }

  /// Сегодня, но в другой час.
  void setHour(int hour) => now = DateTime(now.year, now.month, now.day, hour);

  /// Перевести часы на настоящее время.
  void reset() => now = DateTime.now();

  DateTime call() => now;
}

/// Записаться на смену «за час до её начала» — а потом вернуть хранилищу
/// его часы.
///
/// Нужно тестам, которым нужна запись на смену, что уже идёт или прошла:
/// сегодня на неё не записаться, а вчера было можно.
Future<BookingResult> applyBeforeStart(
  FakeShiftRepository repo,
  int shiftId,
) async {
  final saved = repo.clock;
  final shift = (await repo.shiftById(shiftId))!;
  final moment = shift.startsAt.subtract(const Duration(hours: 1));
  repo.clock = () => moment;
  try {
    return await repo.apply(shiftId);
  } finally {
    repo.clock = saved;
  }
}
