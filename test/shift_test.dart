import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork/main.dart';

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
}
