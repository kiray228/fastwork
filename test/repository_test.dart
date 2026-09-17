import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork/data/fake_shift_repository.dart';
import 'package:fastwork/data/shift_repository.dart';

/// Проверяем правила записи на смены — без экранов, только логика.
/// Такие тесты самые быстрые и самые полезные: они про суть, а не про вид.
void main() {
  late FakeShiftRepository repo;

  setUp(() => repo = FakeShiftRepository());

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

  test('дни со сменами определяются по данным', () async {
    final days = await repo.daysWithShifts();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    expect(days.contains(today), isTrue);
    expect(days.contains(today.add(const Duration(days: 2))), isFalse);
  });
}
