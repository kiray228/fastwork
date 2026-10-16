import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork_core/data/fake_shift_repository.dart';
import 'package:fastwork_core/data/shift_filter.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/shift.dart';

import 'support/clock.dart';

/// Проверяем правила записи на смены — без экранов, только логика.
/// Такие тесты самые быстрые и самые полезные: они про суть, а не про вид.
void main() {
  late FakeShiftRepository repo;
  late TestClock clock;

  // Рейтинг 5.0 — чтобы пройти по всем сменам. Допуск по рейтингу
  // проверяем отдельным тестом ниже.
  //
  // Часы стоят на шести утра: сегодняшние смены ещё не начались, и на
  // них можно записаться в любое время запуска тестов.
  setUp(() {
    clock = TestClock.today();
    repo = FakeShiftRepository(userRating: 5.0, clock: clock.call);
  });

  /// Записаться на прошедшую смену №6 — «в прошлом», за день до неё, —
  /// и вернуть часы в сегодня. Так получается смена, которая уже прошла
  /// и ждёт подтверждения заказчика.
  Future<void> bookPastShift() async {
    final saved = clock.now;
    clock.now = saved.subtract(const Duration(days: 4));
    expect(await repo.apply(6), BookingResult.ok);
    clock.now = saved;
  }

  // Смена №1 — сегодня в 10:00, №5 — через три дня в 11:00.
  // Отменить можно за 10 часов до начала, поэтому сегодняшнюю смену
  // отменить уже нельзя, а дальнюю — можно.

  test('запись занимает место', () async {
    final before = (await repo.shiftById(1))!;
    expect(before.freeSlots, 3);
    expect(before.isApplied, isFalse);

    expect(await repo.apply(1), BookingResult.ok);

    final after = (await repo.shiftById(1))!;
    expect(after.freeSlots, 2);
    expect(after.isApplied, isTrue);
  });

  test('повторная запись не занимает второе место', () async {
    await repo.apply(1);
    expect(await repo.apply(1), BookingResult.alreadyBooked);

    final shift = (await repo.shiftById(1))!;
    expect(shift.freeSlots, 2); // а не 1
  });

  test('нельзя записаться, когда мест нет', () async {
    final zara = (await repo.shiftById(2))!;
    expect(zara.hasFreeSlots, isFalse);

    expect(await repo.apply(2), BookingResult.noSlots);
    expect((await repo.shiftById(2))!.isApplied, isFalse);
  });

  test('отмена до крайнего срока освобождает место', () async {
    await repo.apply(5); // смена через три дня — срок отмены не прошёл
    expect((await repo.shiftById(5))!.freeSlots, 1);

    expect(await repo.cancelApplication(5), BookingResult.ok);
    expect((await repo.shiftById(5))!.freeSlots, 2);
  });

  test('после крайнего срока отменить нельзя', () async {
    await repo.apply(1); // смена сегодня — 10 часов до начала уже прошли

    expect(await repo.cancelApplication(1), BookingResult.tooLateToCancel);
    expect((await repo.shiftById(1))!.isApplied, isTrue); // запись осталась
  });

  test('крайний срок отмены — за 10 часов до начала', () async {
    final shift = (await repo.shiftById(5))!;
    final diff = shift.startsAt.difference(shift.cancelDeadline);

    expect(diff.inHours, 10);
    expect(shift.canCancelAt(shift.cancelDeadline.subtract(
      const Duration(minutes: 1),
    )), isTrue);
    expect(shift.canCancelAt(shift.cancelDeadline.add(
      const Duration(minutes: 1),
    )), isFalse);
  });

  test('«В работе» и «Архив» — один список, разные условия', () async {
    expect(await repo.myShifts(archived: false), isEmpty);

    await repo.apply(5);
    expect((await repo.myShifts(archived: false)).map((s) => s.id), [5]);
    expect(await repo.myShifts(archived: true), isEmpty);

    // Отменили — смена перешла в архив, оставшись той же строкой данных.
    await repo.cancelApplication(5);
    expect(await repo.myShifts(archived: false), isEmpty);
    expect((await repo.myShifts(archived: true)).map((s) => s.id), [5]);
  });

  test('смена с порогом рейтинга закрыта для новичка', () async {
    final novice = FakeShiftRepository(userRating: 4.0, clock: clock.call);

    // Смена №5 доступна только с рейтингом 4.5.
    expect(await novice.apply(5), BookingResult.ratingTooLow);
    expect((await novice.shiftById(5))!.isApplied, isFalse);

    // С рейтингом 4.5 та же смена открыта.
    final senior = FakeShiftRepository(userRating: 4.5, clock: clock.call);
    expect(await senior.apply(5), BookingResult.ok);
  });

  test('фильтр по компании оставляет только её смены', () async {
    final all = await repo.shiftsOn(DateTime.now());
    expect(all.length, 2);

    final onlyZara = await repo.shiftsOn(
      DateTime.now(),
      filter: const ShiftFilter(companies: {'Zara'}),
    );
    expect(onlyZara.map((s) => s.company), ['Zara']);
  });

  test('«только свободные» убирает заполненные смены', () async {
    final open = await repo.shiftsOn(
      DateTime.now(),
      filter: const ShiftFilter(onlyOpen: true),
    );

    // У Zara мест нет — она не должна попасть в выдачу.
    expect(open.every((s) => s.hasFreeSlots), isTrue);
    expect(open.map((s) => s.company), isNot(contains('Zara')));
  });

  test('сортировка по оплате меняет порядок', () async {
    final desc = await repo.shiftsOn(
      DateTime.now(),
      filter: const ShiftFilter(sort: ShiftSort.payDesc),
    );
    final asc = await repo.shiftsOn(
      DateTime.now(),
      filter: const ShiftFilter(sort: ShiftSort.payAsc),
    );

    expect(desc.first.totalPay, greaterThan(desc.last.totalPay));
    expect(asc.first.totalPay, lessThan(asc.last.totalPay));
  });

  test('в заработок идёт только подтверждённая смена', () async {
    expect(await repo.completedShifts(), isEmpty);

    await bookPastShift(); // смена три дня назад
    // Дата прошла, но заказчик выход не подтвердил — значит, не работал.
    expect(await repo.completedShifts(), isEmpty);

    await repo.confirmAttendance(shiftId: 6, workerId: 1);
    final done = await repo.completedShifts();

    expect(done.map((s) => s.id), [6]);
    // 10:00–22:00 минус час обеда по 1100 ₸ = 12 100 ₸
    expect(done.first.totalPay, 1210000);
  });

  test('отметиться можно только в день смены', () async {
    // Смена №5 — через три дня.
    await repo.apply(5);
    expect(await repo.checkIn(5), BookingResult.tooEarlyToCheckIn);

    final shift = (await repo.shiftById(5))!;
    expect(shift.isCheckedIn, isFalse);
  });

  test('на чужую смену отметиться нельзя', () async {
    // Записи нет — значит, и отмечаться не на чем.
    expect(await repo.checkIn(1), BookingResult.tooEarlyToCheckIn);
  });

  test('подтверждение заказчика закрывает смену', () async {
    await bookPastShift();

    final before = (await repo.shiftById(6))!;
    expect(before.isApplied, isTrue);
    expect(before.isCompleted, isFalse);

    await repo.confirmAttendance(shiftId: 6, workerId: 1);

    final after = (await repo.shiftById(6))!;
    expect(after.isCompleted, isTrue);
    // Место всё ещё занято: человек не освободил его, а отработал.
    expect(after.freeSlots, before.freeSlots);
  });

  test('отзыв формирует оценку компании', () async {
    final before = await repo.companyInfo('Золотое яблоко');
    expect(before.rating, isNull);
    expect(before.reviewCount, 0);

    await repo.addReview(shiftId: 6, rating: 5, comment: 'Всё чётко');

    final after = await repo.companyInfo('Золотое яблоко');
    expect(after.rating, 5);
    expect(after.reviewCount, 1);
    expect(after.reviews.first.comment, 'Всё чётко');
  });

  test('оценка компании — это среднее по отзывам', () async {
    await repo.addReview(shiftId: 1, rating: 5);
    await repo.addReview(shiftId: 6, rating: 3);

    final info = await repo.companyInfo('Золотое яблоко');
    expect(info.reviewCount, 2);
    expect(info.rating, 4); // (5 + 3) / 2
  });

  test('второй отзыв о той же смене не создаёт дубликат', () async {
    await repo.addReview(shiftId: 6, rating: 2);
    await repo.addReview(shiftId: 6, rating: 5);

    final info = await repo.companyInfo('Золотое яблоко');
    expect(info.reviewCount, 1);
    expect(info.rating, 5); // осталась последняя оценка
  });

  test('hasReviewed отличает оценённую смену', () async {
    expect(await repo.hasReviewed(6), isFalse);
    await repo.addReview(shiftId: 6, rating: 4);
    expect(await repo.hasReviewed(6), isTrue);
  });

  test('дни со сменами определяются по данным', () async {
    final days = await repo.daysWithShifts();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    expect(days.contains(today), isTrue);
    expect(days.contains(today.add(const Duration(days: 2))), isFalse);
  });

  test('на начавшуюся смену записаться нельзя', () async {
    clock.setHour(11); // смена №1 идёт с 10:00
    expect(await repo.apply(1), BookingResult.alreadyStarted);
    expect((await repo.shiftById(1))!.isApplied, isFalse);
  });

  test('на две смены в одно время записаться нельзя', () async {
    // Смена №1 — склад 10:00–22:00. Добавим вторую сегодня с 12:00.
    final repo = FakeShiftRepository(
      userRating: 5.0,
      clock: clock.call,
      shifts: [
        ...buildDemoShifts(),
        Shift(
          id: 70,
          workDate: clock.now,
          title: 'Услуги официанта',
          company: 'Del Papa',
          address: 'г. Алматы, ул. Кабанбай батыра, 83',
          startMinutes: 720,
          endMinutes: 1080,
          hourlyRate: 100000,
          workersNeeded: 2,
          workersHired: 0,
        ),
      ],
    );

    expect(await repo.apply(1), BookingResult.ok);
    expect(await repo.apply(70), BookingResult.timeConflict);

    // Сняли первую запись — вторая смена снова доступна.
    clock.now = clock.now.subtract(const Duration(days: 1));
    expect(await repo.cancelApplication(1), BookingResult.ok);
    expect(await repo.apply(70), BookingResult.ok);
  });

  test('перенос смены на время другой записи снимает запись', () async {
    final tomorrow =
        DateTime(clock.now.year, clock.now.month, clock.now.day + 1);
    final repo = FakeShiftRepository(
      userRating: 5.0,
      clock: clock.call,
      shifts: [
        ...buildDemoShifts(),
        Shift(
          id: 70,
          workDate: tomorrow,
          title: 'Услуги официанта',
          company: 'Del Papa',
          address: 'г. Алматы, ул. Кабанбай батыра, 83',
          startMinutes: 720,
          endMinutes: 1080,
          hourlyRate: 100000,
          workersNeeded: 2,
          workersHired: 0,
        ),
      ],
    );
    expect(await repo.apply(1), BookingResult.ok);
    expect(await repo.apply(70), BookingResult.ok);

    // Смену №1 (10:00–22:00) переносят на завтра — поверх официанта.
    final first = (await repo.shiftById(1))!;
    final edit = await repo.updateShift(
      shiftId: 1,
      workDate: tomorrow,
      title: first.title,
      address: first.address,
      startMinutes: first.startMinutes,
      endMinutes: first.endMinutes,
      hourlyRate: first.hourlyRate,
      workersNeeded: first.workersNeeded,
    );
    expect(edit.result, BookingResult.ok);
    expect((await repo.shiftById(1))!.isApplied, isFalse);
    expect((await repo.shiftById(70))!.isApplied, isTrue);
    expect((await repo.notifications()).single.title, 'Запись снята');
  });

  test('подтверждённую смену не «перезаписать» ради второй выплаты',
      () async {
    await bookPastShift();
    await repo.confirmAttendance(shiftId: 6, workerId: 1);

    // Раньше повторная запись возвращала отклик в `active`, и выход
    // можно было подтвердить — и оплатить — ещё раз.
    clock.now = clock.now.subtract(const Duration(days: 4));
    expect(await repo.apply(6), BookingResult.alreadyFinished);
    expect((await repo.shiftById(6))!.isCompleted, isTrue);
  });

  test('выход до начала смены не подтвердить', () async {
    expect(await repo.apply(1), BookingResult.ok);
    expect(
      await repo.confirmAttendance(shiftId: 1, workerId: 1),
      BookingResult.notStarted,
    );
    expect(
      await repo.markNoShow(shiftId: 1, workerId: 1),
      BookingResult.notStarted,
    );

    clock.setHour(23);
    expect(
      await repo.confirmAttendance(shiftId: 1, workerId: 1),
      BookingResult.ok,
    );
  });

  test('снять можно только свою живую запись', () async {
    // Не записывался — снимать нечего.
    expect(await repo.cancelApplication(5), BookingResult.notMine);
  });

  group('время суток и оплата за смену', () {
    Shift at(int id, int start, int end, {int rate = 110000}) => Shift(
          id: id,
          workDate: DateTime(2026, 9, 17),
          title: 'смена',
          company: 'Magnum',
          address: 'ул. Абая, 1',
          startMinutes: start,
          endMinutes: end,
          hourlyRate: rate,
          workersNeeded: 1,
          workersHired: 0,
        );

    test('границы частей дня — по началу смены', () {
      expect(DayPart.of(5 * 60), DayPart.morning);
      expect(DayPart.of(11 * 60 + 59), DayPart.morning);
      expect(DayPart.of(12 * 60), DayPart.day);
      expect(DayPart.of(17 * 60), DayPart.evening);
      expect(DayPart.of(22 * 60), DayPart.night);
      expect(DayPart.of(4 * 60 + 59), DayPart.night,
          reason: 'смена в 4 утра — ночная, а не утренняя');
    });

    test('фильтр оставляет только выбранное время и не дешевле порога', () {
      final shifts = [
        at(1, 600, 1260), // утро, 11 ч — 11 000 ₸
        at(2, 1080, 1320), // вечер, 4 ч — 4 400 ₸
        at(3, 1320, 360), // ночь, 8 ч — 8 800 ₸
        at(4, 1140, 1380, rate: 300000), // вечер, 4 ч — 12 000 ₸
      ];
      final evenings = applyFilter(
          shifts, const ShiftFilter(dayParts: {DayPart.evening}));
      expect(evenings.map((s) => s.id), [2, 4]);

      final rich = applyFilter(shifts, const ShiftFilter(minPay: 1000000));
      expect(rich.map((s) => s.id), [1, 4]);

      const both = ShiftFilter(
          dayParts: {DayPart.evening, DayPart.night}, minPay: 500000);
      expect(applyFilter(shifts, both).map((s) => s.id), [4, 3]);
      expect(both.activeCount, 3, reason: 'две части дня и порог оплаты');
      expect(both.isEmpty, isFalse);
    });
  });
}
