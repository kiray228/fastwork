import 'package:drift/native.dart';
import 'package:fastwork/data/session.dart';
import 'package:fastwork_core/category.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/fake_shift_repository.dart';
import 'package:fastwork_core/data/shift_filter.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_core/payment.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/publish.dart';

/// Тестовая карта: проходит всегда.
final testCard = tokenizeSandboxCard(kSandboxCardNumber);

/// Категории работ: справочник, фильтр, поиск и хранение в базе.
void main() {
  group('справочник', () {
    test('в нём сорок категорий', () {
      expect(kShiftCategories, hasLength(40));
    });

    test('ключи не повторяются', () {
      final ids = kShiftCategories.map((c) => c.id).toSet();
      expect(ids, hasLength(kShiftCategories.length));
    });

    test('у каждой категории есть раздел из списка разделов', () {
      for (final c in kShiftCategories) {
        expect(kCategoryGroups, contains(c.group), reason: c.id);
      }
    });

    test('незнакомый ключ — это «Другое», а не падение', () {
      expect(categoryById('space_pilot').id, kOtherCategory);
      expect(isKnownCategory('space_pilot'), isFalse);
      expect(isKnownCategory('plumber'), isTrue);
    });

    test('смена без категории попадает в «Другое»', () {
      final json = buildDemoShifts().first.toJson()..remove('category');
      expect(shiftFromJson(json).category, kOtherCategory);
    });
  });

  group('лента', () {
    late FakeShiftRepository repo;
    final today = DateTime.now();

    setUp(() => repo = FakeShiftRepository(userRating: 5.0));

    test('фильтр по категории оставляет только её смены', () async {
      final all = await repo.shiftsOn(today);
      final warehouse = await repo.shiftsOn(
        today,
        filter: const ShiftFilter(categories: {'warehouse'}),
      );

      expect(all.length, greaterThan(warehouse.length));
      expect(warehouse, isNotEmpty);
      expect(warehouse.every((s) => s.category == 'warehouse'), isTrue);
    });

    test('поиск находит смену по названию категории', () async {
      // В названии смены слова «сантехник» нет — оно только в категории.
      repo = FakeShiftRepository(shifts: [
        Shift(
          id: 1,
          workDate: today,
          title: 'Замена смесителя',
          category: 'plumber',
          company: 'Magnum',
          address: 'ул. Абая, 1',
          startMinutes: 600,
          endMinutes: 900,
          hourlyRate: 150000,
          workersNeeded: 1,
          workersHired: 0,
        ),
      ]);
      final found = await repo.shiftsOn(
        today,
        filter: const ShiftFilter(query: 'сантехник'),
      );
      expect(found.single.title, 'Замена смесителя');
    });

    test('выбранные категории считаются в числе условий фильтра', () {
      const filter = ShiftFilter(categories: {'cook', 'waiter'});
      expect(filter.activeCount, 2);
      expect(filter.isEmpty, isFalse);
    });

    test('список категорий для фильтра — в порядке справочника', () {
      expect(
        sortCategories(['courier', 'seller', 'loader']),
        ['seller', 'loader', 'courier'],
      );
    });
  });

  group('база', () {
    late AppDatabase db;
    late AppSession session;
    late DbShiftRepository shifts;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      session = AppSession();
      shifts = DbShiftRepository(db, session);
      final manager = await DbAuthRepository(db).register(
        phone: '77000000001',
        fullName: 'Айгуль Досова',
        city: 'Алматы',
        acceptedTermsVersion: kTermsVersion,
        role: UserRole.manager,
        company: 'Magnum',
      );
      session.setUser(manager);
    });

    tearDown(() => db.close());

    test('категория сохраняется и меняется правкой', () async {
      final id = await shifts.publishShift(
        workDate: DateTime.now(),
        title: 'Замена смесителя',
        company: 'Magnum',
        address: 'ул. Абая, 1',
        startMinutes: 600,
        endMinutes: 900,
        hourlyRate: 150000,
        workersNeeded: 1,
        createdBy: session.workerId,
        city: 'Алматы',
        card: testCard,
        category: 'plumber',
      );
      expect((await shifts.shiftById(id))!.category, 'plumber');
      expect(await shifts.categories(), ['plumber']);

      final before = (await shifts.shiftById(id))!;
      await shifts.updateShift(
        shiftId: id,
        workDate: before.workDate,
        title: before.title,
        address: before.address,
        startMinutes: before.startMinutes,
        endMinutes: before.endMinutes,
        hourlyRate: before.hourlyRate,
        workersNeeded: before.workersNeeded,
        category: 'electrician',
      );
      expect((await shifts.shiftById(id))!.category, 'electrician');
    });

    test('демо-смены получают свои категории', () async {
      await shifts.seedIfEmpty();
      expect(await shifts.categories(), contains('loader'));
    });
  });
}
