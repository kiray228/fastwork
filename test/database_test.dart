import 'package:drift/drift.dart' show Migrator;
import 'package:drift/native.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork/data/session.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/data/user_language.dart';
import 'package:fastwork_core/lang.dart';
import 'package:fastwork_core/notification.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_core/user.dart';
import 'package:fastwork_core/payment.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/clock.dart';
import 'support/publish.dart';

/// Тестовая карта: проходит всегда.
final testCard = tokenizeSandboxCard(kSandboxCardNumber);

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
  late TestClock clock;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    session = AppSession();
    // Шесть утра: сегодняшние смены (10:00) ещё впереди. Тест, которому
    // нужно «после смены», переводит часы сам.
    clock = TestClock.today();
    shifts = DbShiftRepository(db, session, clock: clock.call);
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
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Magnum',
    );
    final worker = await auth.register(
      phone: '7700000000${daysBack}2',
      fullName: 'Ернар Калдыбеков',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );

    session.setUser(manager); // смену создаёт и оплачивает заказчик
    final shiftId = await shifts.publishShift(
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
      card: testCard,
    );

    // Записывается исполнитель — значит, в сессии должен быть он.
    // Записывался он, конечно, до смены — за день до неё.
    session.setUser(worker);
    clock.now = daysAgo(daysBack + 1);
    expect(await shifts.apply(shiftId), BookingResult.ok);
    clock.now = DateTime(clock.now.year, clock.now.month,
        clock.now.day + daysBack + 1, 6);

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
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Magnum',
    );
    final worker = await auth.register(
      phone: '7702000000$seq',
      fullName: 'Азамат Серик',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );

    session.setUser(manager);
    final shiftId = await shifts.publishShift(
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
      card: testCard,
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
    final secondShift = await shifts.publishShift(
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
      card: testCard,
    );

    session.setUser(await auth.refresh(workerId));
    final today = clock.now;
    clock.now = daysAgo(2);
    expect(await shifts.apply(secondShift), BookingResult.ok);
    clock.now = today;

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
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Magnum',
    );
    final worker = await auth.register(
      phone: '77000000502',
      fullName: 'Ернар Калдыбеков',
      city: 'Астана',
      acceptedTermsVersion: kTermsVersion,
    );

    final today = daysAgo(0);
    for (final (title, city) in [
      ('Смена в Алматы', 'Алматы'),
      ('Смена в Астане', 'Астана'),
    ]) {
      session.setUser(manager); // смену создаёт и оплачивает заказчик
      await shifts.publishShift(
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
        card: testCard,
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
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Magnum',
    );
    final worker = await auth.register(
      phone: '77000000602',
      fullName: 'Ернар Калдыбеков',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );

    // Смена идёт прямо сейчас — иначе отметка была бы закрыта по времени.
    final now = DateTime.now();
    session.setUser(manager); // смену создаёт и оплачивает заказчик
    final shiftId = await shifts.publishShift(
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
      card: testCard,
    );

    // Записался за час до начала. Не «в шесть утра», как остальные
    // тесты: смена здесь начинается по настоящим часам, и ночью шесть
    // утра — уже после её начала (так этот тест и упал в CI в 04:56).
    session.setUser(worker);
    clock.now = now.subtract(const Duration(hours: 1));
    expect(await shifts.apply(shiftId), BookingResult.ok);
    clock.reset(); // смена началась — пора отмечаться
    expect(await shifts.checkIn(shiftId), BookingResult.ok);

    final shift = (await shifts.shiftById(shiftId))!;
    expect(shift.isCheckedIn, isTrue);

    // Дважды отметиться нельзя.
    expect(await shifts.checkIn(shiftId), BookingResult.alreadyBooked);

    // Список записавшихся — с телефонами — исполнителю не показывают.
    expect(await shifts.applicantsFor(shiftId), isEmpty);

    // Заказчик видит отметку в списке записавшихся.
    session.setUser(manager);
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
      acceptedTermsVersion: kTermsVersion,
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
    // До начала смены невыход не отметить — человек ещё не опоздал.
    expect(
      await shifts.markNoShow(shiftId: shiftId, workerId: worker.id),
      BookingResult.notStarted,
    );
    clock.setHour(23);
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
    clock.setHour(21);
    await shifts.confirmAttendance(shiftId: firstShift, workerId: worker.id);

    // Вечером, после первой: две смены в одно время не взять.
    final secondShift = await shifts.publishShift(
      workDate: daysAgo(0),
      title: 'Ещё смена',
      company: 'Magnum',
      address: 'г. Алматы, ул. Абая, 2',
      startMinutes: 1320,
      endMinutes: 1410,
      hourlyRate: 100000,
      workersNeeded: 1,
      createdBy: manager.id,
      city: 'Алматы',
      card: testCard,
    );
    session.setUser(worker);
    expect(await shifts.apply(secondShift), BookingResult.ok);
    session.setUser(manager);
    clock.setHour(23);
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
    clock.setHour(23);
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
      acceptedTermsVersion: kTermsVersion,
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
      acceptedTermsVersion: kTermsVersion,
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
    clock.setHour(23);
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
      ).then((edit) async {
        // Правка удорожила смену — доплачиваем тестовой картой, и тогда
        // она вступает в силу.
        final topup = edit.checkout;
        if (topup == null) return edit.result;
        final paid = await shifts.completeSandboxPayment(topup.id, card: testCard);
        return paid.isPaid ? BookingResult.ok : edit.result;
      });

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

  // ---------------------------------------------------------------------
  // ДЕМО-СМЕНЫ
  // ---------------------------------------------------------------------

  test('демо-смены есть на неделю вперёд в каждом городе', () async {
    clock.setHour(13);
    final added = await shifts.keepDemoFresh();
    expect(added, greaterThan(0));

    final tomorrow = daysAgo(-1);
    for (final city in kCities) {
      session.setUser(AppUser(
        id: 1,
        phone: '77000000000',
        fullName: 'Гость',
        city: city,
        rating: 5,
        isVerified: false,
      ));
      expect(await shifts.shiftsOn(tomorrow), isNotEmpty, reason: city);
      expect(await shifts.shiftsOn(daysAgo(-6)), isNotEmpty, reason: city);
    }

    // Повторный вызов ничего не дублирует — можно звать хоть каждый час.
    expect(await shifts.keepDemoFresh(), 0);
  });

  test('сегодняшние демо-смены — только те, что ещё впереди', () async {
    clock.setHour(13);
    await shifts.keepDemoFresh();
    session.setUser(AppUser(
      id: 1,
      phone: '77000000000',
      fullName: 'Гость',
      city: 'Алматы',
      rating: 5,
      isVerified: false,
    ));
    for (final s in await shifts.shiftsOn(daysAgo(0))) {
      expect(s.startsAt.isAfter(clock.now), isTrue, reason: s.title);
      // Чужие места заняты «никем»: настоящий человек себя там не найдёт.
      expect(s.isApplied, isFalse);
    }
  });

  test('точка под днём — только если на что-то ещё можно записаться',
      () async {
    final (shiftId, _, _) = await upcomingShift(); // сегодня в 10:00
    expect(shiftId, isPositive);
    expect(await shifts.daysWithShifts(), contains(daysAgo(0)));

    clock.setHour(11); // смена началась
    expect(await shifts.daysWithShifts(), isNot(contains(daysAgo(0))));
  });

  // ---------------------------------------------------------------------
  // ЛЮБИМЫЕ ИСПОЛНИТЕЛИ
  // ---------------------------------------------------------------------

  test('в любимые — только того, кто у заказчика отработал', () async {
    final (shiftId, worker, manager) = await upcomingShift();
    session.setUser(manager);

    // Записан, но выход не подтверждён — рано.
    expect(
      await shifts.setFavorite(workerId: worker.id, favorite: true),
      BookingResult.notMine,
    );

    clock.setHour(21);
    await shifts.confirmAttendance(shiftId: shiftId, workerId: worker.id);
    expect(
      await shifts.setFavorite(workerId: worker.id, favorite: true),
      BookingResult.ok,
    );
    // Второе нажатие не ломает ничего.
    expect(
      await shifts.setFavorite(workerId: worker.id, favorite: true),
      BookingResult.ok,
    );

    final people = await shifts.applicantsFor(shiftId);
    expect(people.single.isFavorite, isTrue);
    final favorites = await shifts.favoriteWorkers();
    expect(favorites.single.id, worker.id);
    expect(favorites.single.completedShifts, 1, reason: 'смен у этого заказчика');

    await shifts.setFavorite(workerId: worker.id, favorite: false);
    expect(await shifts.favoriteWorkers(), isEmpty);
  });

  test('новая смена приходит приглашением любимым из того же города',
      () async {
    final (_, workerId, managerId) = await workedShift();
    final manager = (await auth.refresh(managerId))!;
    session.setUser(manager);
    expect(
      await shifts.setFavorite(workerId: workerId, favorite: true),
      BookingResult.ok,
    );

    final shiftId = await shifts.publishShift(
      workDate: daysAgo(-2),
      title: 'Услуги фасовщика',
      company: 'Magnum',
      address: 'г. Алматы, ул. Абая, 1',
      startMinutes: 600,
      endMinutes: 1200,
      hourlyRate: 100000,
      workersNeeded: 2,
      createdBy: managerId,
      city: 'Алматы',
      card: testCard,
    );

    session.setUser((await auth.refresh(workerId))!);
    final invites = (await shifts.notifications())
        .where((n) => n.kind == NotificationKind.invited)
        .toList();
    expect(invites, hasLength(1));
    expect(invites.single.shiftId, shiftId);
    expect(invites.single.title, contains('Magnum'));

    // Смена в другом городе — приглашения нет.
    session.setUser(manager);
    await shifts.publishShift(
      workDate: daysAgo(-2),
      title: 'Услуги фасовщика',
      company: 'Magnum',
      address: 'г. Астана, ул. Кенесары, 1',
      startMinutes: 600,
      endMinutes: 1200,
      hourlyRate: 100000,
      workersNeeded: 2,
      createdBy: managerId,
      city: 'Астана',
      card: testCard,
    );
    session.setUser((await auth.refresh(workerId))!);
    expect(
      (await shifts.notifications())
          .where((n) => n.kind == NotificationKind.invited),
      hasLength(1),
    );
  });

  // ---------------------------------------------------------------------
  // ЛИСТ ОЖИДАНИЯ
  // ---------------------------------------------------------------------

  test('освободилось место — ждущим приходит уведомление', () async {
    final manager = await auth.register(
      phone: '77030000001',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Magnum',
    );
    final first = await auth.register(
      phone: '77030000002',
      fullName: 'Первый Исполнитель',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    final second = await auth.register(
      phone: '77030000003',
      fullName: 'Второй Исполнитель',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    session.setUser(manager);
    // Через три дня: отменить запись ещё можно.
    final shiftId = await shifts.publishShift(
      workDate: daysAgo(-3),
      title: 'Услуги бариста',
      company: 'Magnum',
      address: 'г. Алматы, ул. Абая, 1',
      startMinutes: 600,
      endMinutes: 1200,
      hourlyRate: 100000,
      workersNeeded: 1,
      createdBy: manager.id,
      city: 'Алматы',
      card: testCard,
    );

    session.setUser(first);
    expect(await shifts.apply(shiftId), BookingResult.ok);

    session.setUser(second);
    expect(await shifts.apply(shiftId), BookingResult.noSlots);
    expect(await shifts.setWaitlist(shiftId, join: true), BookingResult.ok);
    expect((await shifts.shiftById(shiftId))!.onWaitlist, isTrue);

    session.setUser(first);
    expect(await shifts.cancelApplication(shiftId), BookingResult.ok);

    session.setUser(second);
    final freed = (await shifts.notifications())
        .where((n) => n.kind == NotificationKind.slotFreed);
    expect(freed, hasLength(1));
    expect(freed.single.shiftId, shiftId);

    // Записался — из листа ожидания ушёл сам.
    expect(await shifts.apply(shiftId), BookingResult.ok);
    expect((await shifts.shiftById(shiftId))!.onWaitlist, isFalse);
  });

  test('больше мест после правки — ждущим тоже скажут', () async {
    final (shiftId, _, manager) = await upcomingShift(); // 2 места
    final other = await auth.register(
      phone: '77030000010',
      fullName: 'Третий Исполнитель',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    // Занимаем второе место.
    session.setUser(other);
    expect(await shifts.apply(shiftId), BookingResult.ok);
    final late = await auth.register(
      phone: '77030000011',
      fullName: 'Опоздавший',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    session.setUser(late);
    await shifts.setWaitlist(shiftId, join: true);

    session.setUser(manager);
    final before = (await shifts.shiftById(shiftId))!;
    final edit = await shifts.updateShift(
      shiftId: shiftId,
      workDate: before.workDate,
      title: before.title,
      address: before.address,
      startMinutes: before.startMinutes,
      endMinutes: before.endMinutes,
      hourlyRate: before.hourlyRate,
      workersNeeded: 3,
      method: PaymentMethod.card,
    );
    // Мест больше — смена дороже: новые условия вступят после доплаты.
    expect(edit.result, BookingResult.paymentRequired);

    Future<int> freedFor(AppUser user) async {
      session.setUser(user);
      return (await shifts.notifications())
          .where((n) => n.kind == NotificationKind.slotFreed)
          .length;
    }

    // До доплаты мест не прибавилось — и уведомления пока нет.
    expect(await freedFor(late), 0);

    session.setUser(manager);
    await shifts.completeSandboxPayment(edit.checkout!.id, card: testCard);
    expect(await freedFor(late), 1);
  });

  // ---------------------------------------------------------------------
  // НАПОМИНАНИЯ
  // ---------------------------------------------------------------------

  test('о смене напоминают за сутки — и только один раз', () async {
    final (shiftId, worker, _) = await upcomingShift(); // сегодня в 10:00

    // Вчера в девять утра: до смены больше суток — рано.
    clock.now = DateTime(clock.now.year, clock.now.month, clock.now.day - 1, 9);
    expect(await shifts.sendReminders(), 0);

    clock.now = clock.now.add(const Duration(hours: 2)); // вчера, 11:00
    expect(await shifts.sendReminders(), 1);
    expect(await shifts.sendReminders(), 0, reason: 'второй раз не пишем');

    session.setUser(worker);
    final notes = (await shifts.notifications())
        .where((n) => n.kind == NotificationKind.reminder)
        .toList();
    expect(notes.single.shiftId, shiftId);
    expect(notes.single.title, 'Смена завтра в 10:00');
  });

  // ---------------------------------------------------------------------
  // ПОДПИСКИ НА КОМПАНИИ
  // ---------------------------------------------------------------------

  test('подписчик узнаёт о новой смене компании в своём городе', () async {
    final manager = await auth.register(
      phone: '77050000001',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Magnum',
    );
    final here = await auth.register(
      phone: '77050000002',
      fullName: 'Алматинец',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    final there = await auth.register(
      phone: '77050000003',
      fullName: 'Астанчанин',
      city: 'Астана',
      acceptedTermsVersion: kTermsVersion,
    );
    for (final user in [here, there]) {
      session.setUser(user);
      await shifts.followCompany('Magnum', follow: true);
      await shifts.followCompany('Magnum', follow: true); // второй раз — ничего
    }
    session.setUser(here);
    expect((await shifts.companyInfo('Magnum')).isFollowed, isTrue);

    session.setUser(manager);
    final shiftId = await shifts.publishShift(
      workDate: daysAgo(-2),
      title: 'Услуги кассира',
      company: 'Magnum',
      address: 'г. Алматы, пр. Абая, 1',
      startMinutes: 600,
      endMinutes: 1200,
      hourlyRate: 100000,
      workersNeeded: 2,
      createdBy: manager.id,
      city: 'Алматы',
      card: testCard,
    );

    Future<List<AppNotification>> newShifts(AppUser user) async {
      session.setUser(user);
      return (await shifts.notifications())
          .where((n) => n.kind == NotificationKind.newShift)
          .toList();
    }

    expect((await newShifts(here)).single.shiftId, shiftId);
    expect(await newShifts(there), isEmpty, reason: 'другой город');

    // На странице компании — её ближайшая смена.
    session.setUser(here);
    final info = await shifts.companyInfo('Magnum');
    expect(info.upcoming.map((s) => s.id), contains(shiftId));

    // Отписался — больше не пишут.
    await shifts.followCompany('Magnum', follow: false);
    expect((await shifts.companyInfo('Magnum')).isFollowed, isFalse);
  });

  test('любимому исполнителю не пишут дважды об одной смене', () async {
    final (_, workerId, managerId) = await workedShift();
    final manager = (await auth.refresh(managerId))!;
    session.setUser(manager);
    await shifts.setFavorite(workerId: workerId, favorite: true);
    session.setUser((await auth.refresh(workerId))!);
    await shifts.followCompany('Magnum', follow: true);

    session.setUser(manager);
    await shifts.publishShift(
      workDate: daysAgo(-2),
      title: 'Услуги фасовщика',
      company: 'Magnum',
      address: 'г. Алматы, ул. Абая, 1',
      startMinutes: 600,
      endMinutes: 1200,
      hourlyRate: 100000,
      workersNeeded: 2,
      createdBy: managerId,
      city: 'Алматы',
      card: testCard,
    );

    session.setUser((await auth.refresh(workerId))!);
    final kinds = (await shifts.notifications())
        .map((n) => n.kind)
        .where((k) =>
            k == NotificationKind.invited || k == NotificationKind.newShift)
        .toList();
    expect(kinds, [NotificationKind.invited]);
  });

  test('«точно выйду» — за сутки до начала, и заказчик это видит', () async {
    final (shiftId, worker, manager) = await upcomingShift(); // сегодня 10:00
    final today = DateTime(clock.now.year, clock.now.month, clock.now.day);
    session.setUser(worker);

    clock.now = today.add(const Duration(hours: 10, minutes: 30));
    expect(await shifts.confirmComing(shiftId), BookingResult.alreadyStarted);

    clock.now = today.subtract(const Duration(hours: 15)); // вчера, 9:00
    expect(
        await shifts.confirmComing(shiftId), BookingResult.tooEarlyToConfirm);
    expect((await shifts.shiftById(shiftId))!.isComingConfirmed, isFalse);

    clock.now = today.subtract(const Duration(hours: 13)); // вчера, 11:00
    expect((await shifts.shiftById(shiftId))!.canConfirmComingAt(clock.now),
        isTrue);
    expect(await shifts.confirmComing(shiftId), BookingResult.ok);
    expect(await shifts.confirmComing(shiftId), BookingResult.ok,
        reason: 'второй раз — ничего не меняется');
    final mine = (await shifts.shiftById(shiftId))!;
    expect(mine.isComingConfirmed, isTrue);
    expect(mine.canConfirmComingAt(clock.now), isFalse);

    session.setUser(manager);
    final applicant = (await shifts.applicantsFor(shiftId)).single;
    expect(applicant.comingConfirmedAt, clock.now);

    // Чужую запись не подтвердить.
    expect(await shifts.confirmComing(shiftId), BookingResult.notFound);
  });

  // ---------------------------------------------------------------------
  // ПОДПИСКИ НА ВИДЫ РАБОТ
  // ---------------------------------------------------------------------

  test('подписчик на вид работ узнаёт о новой смене — один раз', () async {
    final manager = await auth.register(
      phone: '77060000001',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Magnum',
    );
    final loader = await auth.register(
      phone: '77060000002',
      fullName: 'Грузчик',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    final both = await auth.register(
      phone: '77060000003',
      fullName: 'Подписан на всё',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    final cashier = await auth.register(
      phone: '77060000004',
      fullName: 'Кассир',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );

    session.setUser(loader);
    await shifts.followCategory('loader', follow: true);
    await shifts.followCategory('loader', follow: true); // второй раз — ничего
    expect(await shifts.followedCategories(), {'loader'});
    // Уведомление придёт по-английски: на этом языке человек пользуется
    // приложением, а не на языке заказчика.
    await rememberLanguage(db, loader.id, Lang.en);

    session.setUser(both);
    await shifts.followCategory('loader', follow: true);
    await shifts.followCompany('Magnum', follow: true);

    session.setUser(cashier);
    await shifts.followCategory('cashier', follow: true);

    session.setUser(manager);
    final shiftId = await shifts.publishShift(
      workDate: daysAgo(-2),
      title: 'Разгрузка фуры',
      company: 'Magnum',
      address: 'г. Алматы, пр. Абая, 1',
      startMinutes: 600,
      endMinutes: 1200,
      hourlyRate: 100000,
      workersNeeded: 2,
      createdBy: manager.id,
      city: 'Алматы',
      card: testCard,
      category: 'loader',
    );

    Future<List<AppNotification>> newShifts(AppUser user) async {
      session.setUser(user);
      return (await shifts.notifications())
          .where((n) => n.kind == NotificationKind.newShift)
          .toList();
    }

    final note = (await newShifts(loader)).single;
    expect(note.shiftId, shiftId);
    expect(note.title, 'New shift: Loader');

    // Подписан и на компанию, и на вид работ — одно уведомление, про
    // компанию.
    expect((await newShifts(both)).single.title, 'Новая смена: Magnum');
    expect(await newShifts(cashier), isEmpty, reason: 'другой вид работ');

    session.setUser(loader);
    await shifts.followCategory('loader', follow: false);
    expect(await shifts.followedCategories(), isEmpty);
  });

  // ---------------------------------------------------------------------
  // КОД ОТМЕТКИ
  // ---------------------------------------------------------------------

  test('код отметки видит только заказчик, и он подтверждает отметку',
      () async {
    final (shiftId, worker, manager) = await upcomingShift(); // сегодня 10:00

    session.setUser(worker);
    expect(await shifts.checkInCode(shiftId), isNull, reason: 'не его смена');

    session.setUser(manager);
    final code = (await shifts.checkInCode(shiftId))!;
    expect(code, matches(RegExp(r'^\d{4}$')));
    expect(await shifts.checkInCode(shiftId), code, reason: 'код не меняется');

    clock.setHour(10);
    session.setUser(worker);
    final wrong = code == '0000' ? '1111' : '0000';
    expect(await shifts.checkIn(shiftId, code: wrong), BookingResult.wrongCode);
    expect((await shifts.shiftById(shiftId))!.isCheckedIn, isFalse);
    expect(await shifts.checkIn(shiftId, code: code), BookingResult.ok);

    session.setUser(manager);
    expect((await shifts.applicantsFor(shiftId)).single.checkInVerified, isTrue);
  });
}
