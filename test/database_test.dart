import 'package:drift/native.dart';
import 'package:fastwork/data/auth_repository.dart';
import 'package:fastwork/data/database.dart';
import 'package:fastwork/data/session.dart';
import 'package:fastwork/data/shift_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Тесты против **настоящей** SQLite, только в памяти.
///
/// Все остальные тесты работают на выдуманном хранилище — они быстрые и
/// проверяют правила. Но SQL-запросы они не проверяют никак: там, где в
/// боевом коде JOIN и NOT EXISTS, в выдуманном хранилище обычный цикл.
///
/// Поэтому здесь база настоящая. `NativeDatabase.memory()` — тот же SQLite,
/// что и на телефоне, только живёт в оперативной памяти и исчезает после
/// теста. Заодно это проверяет, что схема вообще создаётся.
void main() {
  late AppDatabase db;
  late AppSession session;
  late DbShiftRepository shifts;
  late DbAuthRepository auth;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    session = AppSession();
    shifts = DbShiftRepository(db, session);
    auth = DbAuthRepository(db);
  });

  tearDown(() => db.close());

  DateTime daysAgo(int n) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - n);
  }

  /// Готовим пару «заказчик и исполнитель» и одну уже прошедшую смену,
  /// на которой исполнитель отработал.
  Future<(int shiftId, int workerId, int managerId)> workedShift({
    int daysBack = 2,
  }) async {
    final manager = await auth.register(
      phone: '7700000000${daysBack}1',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      role: UserRole.manager,
      company: 'Magnum',
    );
    final worker = await auth.register(
      phone: '7700000000${daysBack}2',
      fullName: 'Ернар Калдыбеков',
      city: 'Алматы',
    );

    final shiftId = await shifts.createShift(
      workDate: daysAgo(daysBack),
      title: 'Услуги фасовщика',
      company: 'Magnum',
      address: 'г. Алматы, ул. Абая, 1',
      startMinutes: 600,
      endMinutes: 1200,
      hourlyRate: 100000,
      workersNeeded: 2,
      createdBy: manager.id,
      city: 'Алматы',
    );

    // Записывается исполнитель — значит, в сессии должен быть он.
    session.setUser(worker);
    expect(await shifts.apply(shiftId), BookingResult.ok);

    // Смена уже прошла, и заказчик подтвердил выход. Без подтверждения
    // она не считается отработанной — ни для оценки, ни для заработка.
    session.setUser(manager);
    await shifts.confirmAttendance(shiftId: shiftId, workerId: worker.id);

    return (shiftId, worker.id, manager.id);
  }

  test('схема создаётся и смена сохраняется', () async {
    final (shiftId, _, _) = await workedShift();

    final shift = await shifts.shiftById(shiftId);
    expect(shift, isNotNull);
    expect(shift!.workersNeeded, 2);
    // «Набрано» не колонка, а COUNT по откликам — проверяем, что считается.
    expect(shift.workersHired, 1);
    expect(shift.freeSlots, 1);
  });

  test('заказчику видно, кого он ещё не оценил', () async {
    final (shiftId, workerId, managerId) = await workedShift();

    session.setUser(await auth.refresh(managerId));

    final pending = await shifts.workersToRate(managerId);
    expect(pending, hasLength(1));
    expect(pending.first.workerId, workerId);
    expect(pending.first.shiftId, shiftId);
  });

  test('после оценки исполнитель уходит из списка', () async {
    final (shiftId, workerId, managerId) = await workedShift();
    session.setUser(await auth.refresh(managerId));

    await shifts.rateWorker(
      shiftId: shiftId,
      workerId: workerId,
      rating: 5,
      comment: 'Пришёл вовремя',
    );

    // Это и проверяет NOT EXISTS в запросе: оценённых он отсекает.
    expect(await shifts.workersToRate(managerId), isEmpty);
  });

  test('рейтинг исполнителя считается по оценкам, а не по колонке', () async {
    final (shiftId, workerId, managerId) = await workedShift();
    session.setUser(await auth.refresh(managerId));

    // До первой оценки рейтинг стартовый — тот, что стоит в колонке.
    final before = (await auth.refresh(workerId))!;
    expect(before.rating, 4.0);
    expect(before.ratingCount, 0);
    expect(before.hasRatedShifts, isFalse);

    await shifts.rateWorker(shiftId: shiftId, workerId: workerId, rating: 5);

    final after = (await auth.refresh(workerId))!;
    expect(after.rating, 5.0);
    expect(after.ratingCount, 1);
    expect(after.hasRatedShifts, isTrue);
  });

  test('вторая оценка усредняется с первой', () async {
    final (firstShift, workerId, managerId) = await workedShift(daysBack: 2);
    session.setUser(await auth.refresh(managerId));
    await shifts.rateWorker(
      shiftId: firstShift,
      workerId: workerId,
      rating: 5,
    );

    // Ещё одна смена того же заказчика, на ней тот же исполнитель.
    final secondShift = await shifts.createShift(
      workDate: daysAgo(1),
      title: 'Услуги фасовщика',
      company: 'Magnum',
      address: 'г. Алматы, ул. Абая, 1',
      startMinutes: 600,
      endMinutes: 1200,
      hourlyRate: 100000,
      workersNeeded: 1,
      createdBy: managerId,
      city: 'Алматы',
    );

    session.setUser(await auth.refresh(workerId));
    expect(await shifts.apply(secondShift), BookingResult.ok);

    session.setUser(await auth.refresh(managerId));
    await shifts.confirmAttendance(shiftId: secondShift, workerId: workerId);
    await shifts.rateWorker(
      shiftId: secondShift,
      workerId: workerId,
      rating: 3,
    );

    // (5 + 3) / 2 = 4.0 — это AVG в запросе, а не наш подсчёт в коде.
    final user = (await auth.refresh(workerId))!;
    expect(user.rating, 4.0);
    expect(user.ratingCount, 2);
  });

  test('повторная оценка за ту же смену заменяет прежнюю', () async {
    final (shiftId, workerId, managerId) = await workedShift();
    session.setUser(await auth.refresh(managerId));

    await shifts.rateWorker(shiftId: shiftId, workerId: workerId, rating: 2);
    await shifts.rateWorker(shiftId: shiftId, workerId: workerId, rating: 5);

    // Уникальный ключ (смена, исполнитель, автор) не даёт завести две
    // оценки. Вторая переписывает первую — накрутить рейтинг нельзя.
    final user = (await auth.refresh(workerId))!;
    expect(user.ratingCount, 1);
    expect(user.rating, 5.0);
  });

  test('исполнителю видны полученные отзывы', () async {
    final (shiftId, workerId, managerId) = await workedShift();
    session.setUser(await auth.refresh(managerId));

    await shifts.rateWorker(
      shiftId: shiftId,
      workerId: workerId,
      rating: 4,
      comment: 'Хорошо работал',
    );

    final received = await shifts.reviewsAbout(workerId);
    expect(received, hasLength(1));
    expect(received.first.rating, 4);
    expect(received.first.comment, 'Хорошо работал');
    // Название смены приезжает из JOIN со сменами.
    expect(received.first.shiftTitle, 'Услуги фасовщика');
    expect(received.first.company, 'Magnum');
  });

  test('заказчик видит записавшихся с их настоящим рейтингом', () async {
    final (shiftId, workerId, managerId) = await workedShift();
    session.setUser(await auth.refresh(managerId));

    await shifts.rateWorker(shiftId: shiftId, workerId: workerId, rating: 5);

    final people = await shifts.applicantsFor(shiftId);
    expect(people, hasLength(1));
    expect(people.first.user.fullName, 'Ернар Калдыбеков');
    expect(people.first.user.rating, 5.0);
  });

  test('лента показывает только смены города, который выбрал человек',
      () async {
    final manager = await auth.register(
      phone: '77000000501',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      role: UserRole.manager,
      company: 'Magnum',
    );
    final worker = await auth.register(
      phone: '77000000502',
      fullName: 'Ернар Калдыбеков',
      city: 'Астана',
    );

    final today = daysAgo(0);
    for (final (title, city) in [
      ('Смена в Алматы', 'Алматы'),
      ('Смена в Астане', 'Астана'),
    ]) {
      await shifts.createShift(
        workDate: today,
        title: title,
        company: 'Magnum',
        address: 'адрес',
        startMinutes: 600,
        endMinutes: 1200,
        hourlyRate: 100000,
        workersNeeded: 1,
        createdBy: manager.id,
        city: city,
      );
    }

    // Человек из Астаны видит только свой город.
    session.setUser(worker);
    final feed = await shifts.shiftsOn(today);
    expect(feed.map((s) => s.title), ['Смена в Астане']);

    // И компании для фильтра тоже считаются по его городу.
    expect(await shifts.companies(), ['Magnum']);

    // А человек из Алматы — свой.
    session.setUser(await auth.refresh(manager.id));
    final other = await shifts.shiftsOn(today);
    expect(other.map((s) => s.title), ['Смена в Алматы']);
  });

  test('отметка о выходе сохраняется в базе', () async {
    final manager = await auth.register(
      phone: '77000000601',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      role: UserRole.manager,
      company: 'Magnum',
    );
    final worker = await auth.register(
      phone: '77000000602',
      fullName: 'Ернар Калдыбеков',
      city: 'Алматы',
    );

    // Смена идёт прямо сейчас — иначе отметка была бы закрыта по времени.
    final now = DateTime.now();
    final shiftId = await shifts.createShift(
      workDate: daysAgo(0),
      title: 'Услуги фасовщика',
      company: 'Magnum',
      address: 'адрес',
      startMinutes: now.hour * 60 + now.minute,
      endMinutes: 1439,
      hourlyRate: 100000,
      workersNeeded: 1,
      createdBy: manager.id,
      city: 'Алматы',
    );

    session.setUser(worker);
    await shifts.apply(shiftId);
    expect(await shifts.checkIn(shiftId), BookingResult.ok);

    final shift = (await shifts.shiftById(shiftId))!;
    expect(shift.isCheckedIn, isTrue);

    // Дважды отметиться нельзя.
    expect(await shifts.checkIn(shiftId), BookingResult.alreadyBooked);

    // Заказчик видит отметку в списке записавшихся.
    final people = await shifts.applicantsFor(shiftId);
    expect(people.first.isCheckedIn, isTrue);
    expect(people.first.isConfirmed, isFalse);

    await shifts.confirmAttendance(shiftId: shiftId, workerId: worker.id);
    final after = await shifts.applicantsFor(shiftId);
    expect(after.first.isConfirmed, isTrue);
  });

  test('счётчик смен считает только подтверждённые', () async {
    final (_, workerId, _) = await workedShift();

    // В helper выход подтверждён — смена засчитана.
    expect((await auth.refresh(workerId))!.completedShifts, 1);
  });
}
