import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork/data/fake_shift_repository.dart';

/// Проверяем правила работы с откликами — без экранов, только логика.
/// Такие тесты самые быстрые и самые полезные: они про суть, а не про вид.
void main() {
  late FakeShiftRepository repo;

  setUp(() => repo = FakeShiftRepository());

  test('отклик занимает место', () async {
    final before = (await repo.shiftById(1))!;
    expect(before.freeSlots, 3);
    expect(before.isApplied, isFalse);

    await repo.apply(1);

    final after = (await repo.shiftById(1))!;
    expect(after.freeSlots, 2);
    expect(after.isApplied, isTrue);
  });

  test('отмена отклика освобождает место', () async {
    await repo.apply(1);
    await repo.cancelApplication(1);

    final shift = (await repo.shiftById(1))!;
    expect(shift.freeSlots, 3);
    expect(shift.isApplied, isFalse);
  });

  test('нельзя откликнуться дважды — место занимается один раз', () async {
    await repo.apply(1);
    await repo.apply(1);
    await repo.apply(1);

    final shift = (await repo.shiftById(1))!;
    expect(shift.freeSlots, 2); // а не 0
  });

  test('нельзя откликнуться, когда мест нет', () async {
    final zara = (await repo.shiftById(2))!;
    expect(zara.hasFreeSlots, isFalse);

    await repo.apply(2);

    final after = (await repo.shiftById(2))!;
    expect(after.isApplied, isFalse);
  });

  test('«В работе» и «Архив» — один список, разные условия', () async {
    expect(await repo.myShifts(archived: false), isEmpty);

    await repo.apply(1);

    final active = await repo.myShifts(archived: false);
    final archive = await repo.myShifts(archived: true);
    expect(active.map((s) => s.id), [1]);
    expect(archive, isEmpty);

    // Отменили — смена перешла в архив, оставшись той же строкой данных.
    await repo.cancelApplication(1);
    expect(await repo.myShifts(archived: false), isEmpty);
    expect((await repo.myShifts(archived: true)).map((s) => s.id), [1]);
  });

  test('дни со сменами определяются по данным', () async {
    final days = await repo.daysWithShifts();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    expect(days.contains(today), isTrue);
    expect(days.contains(today.add(const Duration(days: 2))), isFalse);
  });
}
