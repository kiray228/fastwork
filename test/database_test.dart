import 'package:drift/drift.dart' show Migrator;
import 'package:drift/native.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork/data/session.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/notification.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/user.dart';
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

  /// Смена на сегодня, на которую исполнитель записан и **ещё не**
  /// отработал. Отличается от `workedShift` тем, что выход не подтверждён:
  /// именно такую смену заказчик и может отменить.
  var seq = 0;
  Future<(int shiftId, AppUser worker, AppUser manager)> upcomingShift() async {
    seq++;
    final manager = await auth.register(
      phone: '7701000000$seq',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      role: UserRole.manager,
      company: 'Magnum',
    );
    final worker = await auth.register(
      phone: '7702000000$seq',
      fullName: 'Азамат Серик',
      city: 'Алматы',
    );

    session.setUser(manager);
    final shiftId = await shifts.createShift(
      workDate: daysAgo(0),
      title: 'Услуги грузчика',
      company: 'Magnum',
      address: 'г. Алматы, ул. Абая, 1',
      startMinutes: 600,
      endMinutes: 1200,
      hourlyRate: 100000,
      workersNeeded: 2,
      createdBy: manager.id,
      city: 'Алматы',
    );

    session.setUser(worker);
    expect(await shifts.apply(shiftId), BookingResult.ok);

    return (shiftId, worker, manager);
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

    // Подтверждает заказчик, а не исполнитель: раньше эта строка стояла
    // без смены пользователя, и тест проходил — потому что права никто
    // не проверял. Теперь проверяет.
    session.setUser(manager);
    expect(
      await shifts.confirmAttendance(shiftId: shiftId, workerId: worker.id),
      BookingResult.ok,
    );
    final after = await shifts.applicantsFor(shiftId);
    expect(after.first.isConfirmed, isTrue);
  });

  test('счётчик смен считает только подтверждённые', () async {
    final (_, workerId, _) = await workedShift();

    // В helper выход подтверждён — смена засчитана.
    expect((await auth.refresh(workerId))!.completedShifts, 1);
  });

  // ---------------------------------------------------------------------
  // ОБНОВЛЕНИЕ СХЕМЫ
  // ---------------------------------------------------------------------

  test('повторное добавление колонки не роняет обновление схемы', () async {
    final m = Migrator(db);

    // Так выглядит наполовину выполненное обновление: колонка уже есть,
    // а отметка «схема обновлена» не записана. Живой сервер застрял ровно
    // на этом и падал при каждом запуске.
    await db.addColumnIfMissing(m, db.shiftRows, db.shiftRows.cancelledAt);

    // А без защиты та же команда падает — вот та самая ошибка.
    expect(
      () => m.addColumn(db.shiftRows, db.shiftRows.cancelledAt),
      throwsA(anything),
      reason: 'иначе тест ничего не проверяет',
    );
  });

  // ---------------------------------------------------------------------
  // ОТМЕНА СМЕНЫ ЗАКАЗЧИКОМ
  // ---------------------------------------------------------------------

  test('отменённая смена пропадает из ленты, но остаётся в архиве',
      () async {
    final (shiftId, worker, manager) = await upcomingShift();

    session.setUser(worker);
    expect(await shifts.shiftsOn(daysAgo(0)), hasLength(1));

    session.setUser(manager);
    expect(await shifts.cancelShift(shiftId), BookingResult.ok);

    session.setUser(worker);
    expect(await shifts.shiftsOn(daysAgo(0)), isEmpty);

    // Но след остался: человек должен понять, почему выходить не нужно.
    final archive = await shifts.myShifts(archived: true);
    expect(archive.map((s) => s.id), contains(shiftId));
    expect(archive.firstWhere((s) => s.id == shiftId).isCancelled, isTrue);
  });

  test('записавшихся предупреждают об отмене', () async {
    final (shiftId, worker, manager) = await upcomingShift();

    session.setUser(manager);
    await shifts.cancelShift(shiftId);

    session.setUser(worker);
    final cancelled = (await shifts.notifications())
        .where((n) => n.kind == NotificationKind.shiftCancelled);
    expect(cancelled, hasLength(1));
  });

  test('чужую смену отменить нельзя', () async {
    final (shiftId, worker, _) = await upcomingShift();

    // Исполнитель подставляет номер чужой смены — правило не на экране,
    // а в хранилище, поэтому подстановка не поможет.
    session.setUser(worker);
    expect(await shifts.cancelShift(shiftId), BookingResult.notMine);

    final shift = await shifts.shiftById(shiftId);
    expect(shift!.isCancelled, isFalse);
  });

  test('на отменённую смену записаться нельзя', () async {
    final (shiftId, _, manager) = await upcomingShift();

    session.setUser(manager);
    await shifts.cancelShift(shiftId);

    final other = await auth.register(
      phone: '77039990001',
      fullName: 'Данияр Ким',
      city: 'Алматы',
    );
    session.setUser(other);
    expect(await shifts.apply(shiftId), BookingResult.alreadyCancelled);
  });

  test('дважды отменить одну смену нельзя', () async {
    final (shiftId, _, manager) = await upcomingShift();
    session.setUser(manager);

    expect(await shifts.cancelShift(shiftId), BookingResult.ok);
    expect(await shifts.cancelShift(shiftId), BookingResult.alreadyCancelled);
  });

  // ---------------------------------------------------------------------
  // НЕВЫХОД
  // ---------------------------------------------------------------------

  test('невыход не идёт ни в заработок, ни в число смен', () async {
    final (shiftId, worker, manager) = await upcomingShift();

    session.setUser(manager);
    expect(
      await shifts.markNoShow(shiftId: shiftId, workerId: worker.id),
      BookingResult.ok,
    );

    final after = (await auth.refresh(worker.id))!;
    expect(after.completedShifts, 0);
    expect(after.noShows, 1);

    session.setUser(after);
    expect(await shifts.completedShifts(), isEmpty);
  });

  test('надёжность — это доля выходов, а не оценка', () async {
    final (firstShift, worker, manager) = await upcomingShift();

    // Одна смена отработана, вторая — нет.
    session.setUser(manager);
    await shifts.confirmAttendance(shiftId: firstShift, workerId: worker.id);

    final secondShift = await shifts.createShift(
      workDate: daysAgo(0),
      title: 'Ещё смена',
      company: 'Magnum',
      address: 'г. Алматы, ул. Абая, 2',
      startMinutes: 600,
      endMinutes: 1200,
      hourlyRate: 100000,
      workersNeeded: 1,
      createdBy: manager.id,
      city: 'Алматы',
    );
    session.setUser(worker);
    await shifts.apply(secondShift);
    session.setUser(manager);
    await shifts.markNoShow(shiftId: secondShift, workerId: worker.id);

    final after = (await auth.refresh(worker.id))!;
    expect(after.completedShifts, 1);
    expect(after.noShows, 1);
    expect(after.reliabilityPercent, 50);

    // А рейтинг невыход не трогает: это разные вопросы.
    expect(after.ratingCount, 0, reason: 'оценок никто не ставил');
  });

  test('о невыходе сообщают самому человеку', () async {
    final (shiftId, worker, manager) = await upcomingShift();
    session.setUser(manager);
    await shifts.markNoShow(shiftId: shiftId, workerId: worker.id);

    session.setUser(worker);
    final notes = (await shifts.notifications())
        .where((n) => n.kind == NotificationKind.noShow)
        .toList();
    expect(notes, hasLength(1));
    // Куда идти, если заказчик ошибся.
    expect(notes.first.body, contains('поддержку'));
  });

  test('чужому человеку невыход не поставишь', () async {
    final (shiftId, worker, _) = await upcomingShift();

    // Заказчик с другой смены — не хозяин этой.
    final stranger = await auth.register(
      phone: '77045550001',
      fullName: 'Чужой Заказчик',
      city: 'Алматы',
      role: UserRole.manager,
      company: 'Small',
    );
    session.setUser(stranger);
    expect(
      await shifts.markNoShow(shiftId: shiftId, workerId: worker.id),
      BookingResult.notMine,
    );

    expect((await auth.refresh(worker.id))!.noShows, 0);
  });

  test('чужую смену нельзя и засчитать', () async {
    final (shiftId, worker, _) = await upcomingShift();

    final stranger = await auth.register(
      phone: '77045550002',
      fullName: 'Чужой Заказчик',
      city: 'Алматы',
      role: UserRole.manager,
      company: 'Small',
    );
    session.setUser(stranger);
    expect(
      await shifts.confirmAttendance(shiftId: shiftId, workerId: worker.id),
      BookingResult.notMine,
    );

    expect((await auth.refresh(worker.id))!.completedShifts, 0);
  });

  test('заказчик видит надёжность записавшегося', () async {
    final (shiftId, worker, manager) = await upcomingShift();
    session.setUser(manager);
    await shifts.markNoShow(shiftId: shiftId, workerId: worker.id);

    final people = await shifts.applicantsFor(shiftId);
    expect(people, hasLength(1));
    expect(people.first.isNoShow, isTrue);
    expect(people.first.user.noShows, 1);
  });

  test('без истории надёжность равна ста процентам', () async {
    final (_, worker, _) = await upcomingShift();
    final fresh = (await auth.refresh(worker.id))!;

    expect(fresh.hasAttendanceRecord, isFalse);
    expect(fresh.reliabilityPercent, 100);
  });

  // ---------------------------------------------------------------------
  // ПРАВКА СМЕНЫ
  // ---------------------------------------------------------------------

  Future<BookingResult> editTo(
    int shiftId,
    Shift base, {
    int? hourlyRate,
    int? workersNeeded,
    int? startMinutes,
    String? address,
  }) =>
      shifts.updateShift(
        shiftId: shiftId,
        workDate: base.workDate,
        title: base.title,
        address: address ?? base.address,
        startMinutes: startMinutes ?? base.startMinutes,
        endMinutes: base.endMinutes,
        hourlyRate: hourlyRate ?? base.hourlyRate,
        workersNeeded: workersNeeded ?? base.workersNeeded,
      );

  test('заказчик правит свою смену', () async {
    final (shiftId, _, manager) = await upcomingShift();
    session.setUser(manager);

    final before = (await shifts.shiftById(shiftId))!;
    expect(await editTo(shiftId, before, hourlyRate: 150000), BookingResult.ok);

    final after = (await shifts.shiftById(shiftId))!;
    expect(after.hourlyRate, 150000);
    // Набранных правка не трогает.
    expect(after.workersHired, before.workersHired);
  });

  test('записавшихся предупреждают о важных изменениях', () async {
    final (shiftId, worker, manager) = await upcomingShift();
    session.setUser(manager);
    final before = (await shifts.shiftById(shiftId))!;

    await editTo(shiftId, before, startMinutes: 480);

    session.setUser(worker);
    final changed = (await shifts.notifications())
        .where((n) => n.kind == NotificationKind.shiftChanged)
        .toList();
    expect(changed, hasLength(1));
    expect(changed.first.body, contains('08:00'));
  });

  test('о мелкой правке не пишут', () async {
    final (shiftId, worker, manager) = await upcomingShift();
    session.setUser(manager);
    final before = (await shifts.shiftById(shiftId))!;

    // Ничего важного не поменялось — только название.
    await shifts.updateShift(
      shiftId: shiftId,
      workDate: before.workDate,
      title: 'Услуги грузчика (склад)',
      address: before.address,
      startMinutes: before.startMinutes,
      endMinutes: before.endMinutes,
      hourlyRate: before.hourlyRate,
      workersNeeded: before.workersNeeded,
    );

    session.setUser(worker);
    expect(
      (await shifts.notifications())
          .where((n) => n.kind == NotificationKind.shiftChanged),
      isEmpty,
      reason: 'уведомление о незаметном изменении учит их не читать',
    );
  });

  test('мест не может стать меньше, чем уже набрано', () async {
    final (shiftId, _, manager) = await upcomingShift();
    session.setUser(manager);

    final before = (await shifts.shiftById(shiftId))!;
    expect(before.workersHired, 1);

    expect(
      await editTo(shiftId, before, workersNeeded: 0),
      BookingResult.fewerThanHired,
    );
    // Смена осталась как была.
    expect((await shifts.shiftById(shiftId))!.workersNeeded, 2);
  });

  test('чужую смену править нельзя', () async {
    final (shiftId, worker, manager) = await upcomingShift();
    session.setUser(manager);
    final before = (await shifts.shiftById(shiftId))!;

    session.setUser(worker);
    expect(
      await editTo(shiftId, before, hourlyRate: 1),
      BookingResult.notMine,
    );
  });

  test('отменённую смену править нельзя', () async {
    final (shiftId, _, manager) = await upcomingShift();
    session.setUser(manager);
    final before = (await shifts.shiftById(shiftId))!;

    await shifts.cancelShift(shiftId);
    expect(
      await editTo(shiftId, before, hourlyRate: 150000),
      BookingResult.alreadyCancelled,
    );
  });

  // ---------------------------------------------------------------------
  // УВЕДОМЛЕНИЯ
  //
  // Проверяем не тексты, а главное: уведомление уходит **тому, кому надо**,
  // и не уходит тому, кто сам это действие и совершил.
  // ---------------------------------------------------------------------

  test('запись на смену уведомляет заказчика, а не исполнителя', () async {
    final (_, workerId, managerId) = await workedShift();

    session.setUser(await auth.refresh(managerId));
    final forManager = await shifts.notifications();
    expect(
      forManager.where((n) => n.kind == NotificationKind.applied),
      hasLength(1),
      reason: 'заказчик должен узнать о новой записи',
    );

    session.setUser(await auth.refresh(workerId));
    final forWorker = await shifts.notifications();
    expect(
      forWorker.where((n) => n.kind == NotificationKind.applied),
      isEmpty,
      reason: 'самому себе уведомление о своём же действии не нужно',
    );
  });

  test('подтверждение выхода уведомляет исполнителя', () async {
    final (_, workerId, _) = await workedShift();

    session.setUser(await auth.refresh(workerId));
    final mine = await shifts.notifications();
    final confirmed =
        mine.where((n) => n.kind == NotificationKind.confirmed).toList();

    expect(confirmed, hasLength(1));
    // Сумма попадает в текст: уведомление должно читаться само по себе,
    // без перехода на смену.
    expect(confirmed.first.body, contains('₸'));
  });

  test('оценка уведомляет исполнителя', () async {
    final (shiftId, workerId, managerId) = await workedShift();

    session.setUser(await auth.refresh(managerId));
    await shifts.rateWorker(shiftId: shiftId, workerId: workerId, rating: 5);

    session.setUser(await auth.refresh(workerId));
    final rated = (await shifts.notifications())
        .where((n) => n.kind == NotificationKind.rated);
    expect(rated, hasLength(1));
    expect(rated.first.title, contains('5'));
  });

  test('прочитанные уведомления перестают считаться непрочитанными',
      () async {
    final (_, workerId, _) = await workedShift();
    session.setUser(await auth.refresh(workerId));

    expect(await shifts.unreadNotifications(), greaterThan(0));

    await shifts.markNotificationsRead();
    expect(await shifts.unreadNotifications(), 0);

    // Сами уведомления никуда не делись — их просто прочитали.
    expect(await shifts.notifications(), isNotEmpty);
  });

  test('уведомления одного человека не видны другому', () async {
    final (_, workerId, managerId) = await workedShift();

    session.setUser(await auth.refresh(workerId));
    final mine = await shifts.notifications();

    session.setUser(await auth.refresh(managerId));
    final theirs = await shifts.notifications();

    final myIds = mine.map((n) => n.id).toSet();
    final theirIds = theirs.map((n) => n.id).toSet();
    expect(myIds.intersection(theirIds), isEmpty);
  });
}
