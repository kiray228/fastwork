import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork_core/shift.dart';

/// Проверяем расчёт оплаты на настоящих цифрах из прототипа.
/// Если наши формулы верны — суммы должны сойтись с теми, что показывает
/// реальное приложение.
void main() {
  Shift shift({
    required int start,
    required int end,
    required int rate,
  }) =>
      Shift(
        id: 1,
        workDate: DateTime(2026, 9, 17),
        title: 'тест',
        company: 'тест',
        address: 'тест',
        startMinutes: start,
        endMinutes: end,
        hourlyRate: rate,
        workersNeeded: 1,
        workersHired: 0,
      );

  test('дневная смена 10:00-22:00 по 1100 ₸ даёт 12 100 ₸', () {
    final s = shift(start: 600, end: 1320, rate: 110000);
    expect(s.durationMinutes, 720); // 12 часов
    expect(s.paidMinutes, 660); // минус час обеда
    expect(formatMoney(s.totalPay), '12 100 ₸');
  });

  test('дневная смена 10:00-22:00 по 700 ₸ даёт 7 700 ₸', () {
    final s = shift(start: 600, end: 1320, rate: 70000);
    expect(formatMoney(s.totalPay), '7 700 ₸');
  });

  test('смена 10:00-21:00 по 1100 ₸ даёт 11 000 ₸', () {
    final s = shift(start: 600, end: 1260, rate: 110000);
    expect(s.durationMinutes, 660); // 11 часов
    expect(formatMoney(s.totalPay), '11 000 ₸');
  });

  test('ночная смена 18:00-06:00 не даёт отрицательное время', () {
    final s = shift(start: 1080, end: 360, rate: 110000);
    expect(s.durationMinutes, 720); // 12 часов, а не минус 720
    expect(formatMoney(s.totalPay), '12 100 ₸');
  });

  test('короткая смена до 5 часов идёт без вычета обеда', () {
    final s = shift(start: 600, end: 840, rate: 110000); // 10:00-14:00
    expect(s.durationMinutes, 240);
    expect(s.paidMinutes, 240); // перерыв не вычитается
    expect(formatMoney(s.totalPay), '4 400 ₸');
  });

  test('isSameDay сравнивает только дату, без времени', () {
    final utro = DateTime(2026, 9, 17, 8, 30);
    final vecher = DateTime(2026, 9, 17, 23, 59);
    final zavtra = DateTime(2026, 9, 18, 0, 1);

    expect(isSameDay(utro, vecher), isTrue);
    expect(isSameDay(vecher, zavtra), isFalse);
  });

  test('среди демо-смен есть смены на сегодня', () {
    final now = DateTime.now();
    final segodnya =
        buildDemoShifts().where((s) => isSameDay(s.workDate, now)).toList();

    expect(segodnya, isNotEmpty);
  });

  test('мест нет, когда набрано столько же, сколько нужно', () {
    final s = Shift(
      id: 1,
      workDate: DateTime(2026, 9, 17),
      title: 'тест',
      company: 'тест',
      address: 'тест',
      startMinutes: 600,
      endMinutes: 1320,
      hourlyRate: 110000,
      workersNeeded: 3,
      workersHired: 3,
    );
    expect(s.hasFreeSlots, isFalse);
  });

  test('окончание согласуется с числом', () {
    expect(shiftsLabel(1), '1 смена');
    expect(shiftsLabel(2), '2 смены');
    expect(shiftsLabel(5), '5 смен');
    expect(shiftsLabel(11), '11 смен');
    expect(shiftsLabel(21), '21 смена');
    expect(shiftsLabel(112), '112 смен');
    expect(daysLabel(3), '3 дня');
  });

  test('смены пересекаются по времени, края — нет', () {
    Shift at(int day, int start, int end) => Shift(
          id: day * 10000 + start,
          workDate: DateTime(2026, 10, day),
          title: 'Смена',
          company: 'Magnum',
          address: 'ул. Абая, 1',
          startMinutes: start,
          endMinutes: end,
          hourlyRate: 100000,
          workersNeeded: 1,
          workersHired: 0,
        );
    final night = at(12, 1320, 360); // 22:00–06:00
    expect(night.overlaps(at(13, 300, 600)), isTrue, reason: 'утро после ночи');
    expect(night.overlaps(at(13, 360, 600)), isFalse, reason: 'стык');
    expect(at(12, 600, 840).overlaps(at(12, 840, 1200)), isFalse);
    expect(at(12, 600, 900).overlaps(at(12, 840, 1200)), isTrue);
  });

  test('10:00–10:00 — опечатка, а не смена на сутки', () {
    String? problem(int start, int end) => shiftFormError(
          title: 'Услуги грузчика',
          address: 'ул. Абая, 1',
          workDate: DateTime(2026, 9, 18),
          startMinutes: start,
          endMinutes: end,
          hourlyRate: 110000,
          workersNeeded: 1,
          now: DateTime(2026, 9, 17, 12),
        );
    expect(problem(600, 600), isNotNull);
    expect(problem(600, 1260), isNull);
    expect(problem(1320, 360), isNull, reason: 'ночная смена — не ошибка');
  });

  test('на ночную смену отмечаются и после полуночи, до её конца', () {
    final night = shift(start: 1320, end: 360, rate: 110000)
        .copyWith(myStatus: 'active');
    final day = DateTime(2026, 9, 17);
    expect(night.canCheckInAt(day.add(const Duration(hours: 21))), isTrue);
    expect(night.canCheckInAt(day.add(const Duration(hours: 24, minutes: 10))),
        isTrue);
    expect(night.canCheckInAt(day.add(const Duration(hours: 30))), isFalse,
        reason: 'смена кончилась в 06:00');

    // Смена в 00:30 открывает отметку в 23:30 накануне.
    final early = shift(start: 30, end: 480, rate: 110000)
        .copyWith(myStatus: 'active');
    expect(early.canCheckInAt(day.subtract(const Duration(minutes: 30))),
        isTrue);
    // Дневная — до конца своего дня, как и раньше.
    final daily = shift(start: 600, end: 1260, rate: 110000)
        .copyWith(myStatus: 'active');
    expect(daily.canCheckInAt(day.add(const Duration(hours: 23))), isTrue);
    expect(daily.canCheckInAt(day.add(const Duration(hours: 25))), isFalse);
  });

  test('у заказчика впереди — ближайшая первой, прошедшие — свежие первыми',
      () {
    Shift on(int id, int day, {bool cancelled = false}) => Shift(
          id: id,
          workDate: DateTime(2026, 9, day),
          title: 'тест',
          company: 'тест',
          address: 'тест',
          startMinutes: 600,
          endMinutes: 1260,
          hourlyRate: 110000,
          workersNeeded: 1,
          workersHired: 0,
          cancelledAt: cancelled ? DateTime(2026, 9, 1) : null,
        );
    final now = DateTime(2026, 9, 17, 12); // 17-я идёт прямо сейчас
    final split = splitByTime([
      on(1, 20),
      on(2, 17),
      on(3, 10),
      on(4, 18, cancelled: true),
      on(5, 15),
    ], now);
    expect(split.ahead.map((s) => s.id), [2, 1],
        reason: 'сегодняшняя — первой, отменённая — не впереди');
    expect(split.past.map((s) => s.id), [4, 5, 3]);
  });
}
