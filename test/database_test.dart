import 'package:drift/drift.dart' show Migrator, Value;
import 'package:drift/native.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/mrp_store.dart';
import 'package:fastwork/data/session.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/data/user_language.dart';
import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/errors.dart';
import 'package:fastwork_core/l10n/core_strings.dart';
import 'package:fastwork_core/lang.dart';
import 'package:fastwork_core/mrp.dart';
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

  test('поздняя отмена: записавшимся компенсация, заказчику — остаток',
      () async {
    // Смена сегодня в 10:00, на часах 6:00 — срок отмены (10 ч) прошёл.
    final (shiftId, worker, manager) = await upcomingShift();
    final shift = (await shifts.shiftById(shiftId))!;
    expect(shift.isLateCancelAt(clock.now), isTrue);
    final compensation = shift.lateCancelCompensation;
    expect(compensation, shift.totalPay * 30 ~/ 100 ~/ 100 * 100);

    session.setUser(manager);
    final wallet = DbWalletRepository(db, session);
    final paid = -(await wallet.summary())
        .entries
        .where((e) => e.kind == WalletEntryKind.charge)
        .fold<int>(0, (sum, e) => sum + e.amount);
    expect(await shifts.cancelShift(shiftId), BookingResult.ok);
    final refunded = (await wallet.summary())
        .entries
        .where((e) => e.kind == WalletEntryKind.refund)
        .fold<int>(0, (sum, e) => sum + e.amount);
    // Возвращается всё, кроме компенсации с комиссией за неё.
    expect(refunded,
        paid - ShiftCost(slotPay: compensation, slots: 1).total);

    session.setUser(worker);
    final mine = await wallet.summary();
    expect(mine.balance, compensation);
    final note = (await shifts.notifications())
        .singleWhere((n) => n.kind == NotificationKind.shiftCancelled);
    expect(note.title, contains('компенсация'));
  });

  test('ранняя отмена — без компенсации, заказчику всё', () async {
    final (shiftId, worker, manager) = await upcomingShift();
    // За сутки до смены: срок отмены ещё не прошёл.
    clock.now = clock.now.subtract(const Duration(days: 1));
    session.setUser(manager);
    expect(await shifts.cancelShift(shiftId), BookingResult.ok);

    session.setUser(worker);
    expect((await DbWalletRepository(db, session).summary()).balance, 0);
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

  test('правка, налезшая на другую смену человека, снимает его запись',
      () async {
    final (shiftId, worker, manager) = await upcomingShift(); // сегодня 10–20
    final tomorrow =
        DateTime(clock.now.year, clock.now.month, clock.now.day + 1);
    session.setUser(manager);
    final other = await shifts.publishShift(
      workDate: tomorrow,
      title: 'Услуги официанта',
      company: 'Magnum',
      address: 'г. Алматы, ул. Абая, 1',
      startMinutes: 480,
      endMinutes: 720,
      hourlyRate: 100000,
      workersNeeded: 1,
      createdBy: manager.id,
      city: 'Алматы',
      card: testCard,
    );
    session.setUser(worker);
    expect(await shifts.apply(other), BookingResult.ok);

    // Заказчик переносит первую смену на завтра — на то же утро, где
    // человек уже стоит официантом.
    session.setUser(manager);
    final before = (await shifts.shiftById(shiftId))!;
    final edit = await shifts.updateShift(
      shiftId: shiftId,
      workDate: tomorrow,
      title: before.title,
      address: before.address,
      startMinutes: before.startMinutes,
      endMinutes: before.endMinutes,
      hourlyRate: before.hourlyRate,
      workersNeeded: before.workersNeeded,
    );
    expect(edit.result, BookingResult.ok);
    expect((await shifts.shiftById(shiftId))!.workersHired, 0);

    final told = (await shifts.notifications())
        .where((n) => n.kind == NotificationKind.withdrew)
        .single;
    expect(told.body, contains('Азамат Серик'));
    expect(told.body, contains('другая смена'));

    session.setUser(worker);
    expect((await shifts.shiftById(shiftId))!.isApplied, isFalse);
    expect((await shifts.shiftById(other))!.isApplied, isTrue,
        reason: 'вторую запись правка чужой смены не трогает');
    final note = (await shifts.notifications())
        .where((n) => n.kind == NotificationKind.shiftChanged)
        .single;
    expect(note.title, 'Запись снята');
    expect(note.body, contains('совпадает с другой вашей сменой'));
  });

  test('правка, переваливающая доход за 300 МРП, снимает запись после доплаты',
      () async {
    final (shiftId, worker, manager) = await upcomingShift();
    // МРП в 50 ₸ на все годы — лимит 15 000 ₸, смена в него влезает.
    for (final r in kMrpHistory) {
      await MrpStore(db).setRate(r.validFrom, 5000);
    }
    session.setUser(manager);
    final before = (await shifts.shiftById(shiftId))!;

    // Ставка вдвое — уже за 15 000 ₸. Правка ждёт доплаты, и запись
    // снимается, когда доплата пришла и новые условия вступили в силу.
    expect(await editTo(shiftId, before, hourlyRate: 200000), BookingResult.ok);
    expect((await shifts.shiftById(shiftId))!.hourlyRate, 200000);
    expect((await shifts.shiftById(shiftId))!.workersHired, 0);

    session.setUser(worker);
    final note = (await shifts.notifications())
        .where((n) => n.kind == NotificationKind.shiftChanged)
        .single;
    expect(note.body, contains('300 МРП'));
  });

  test('правка, которая человеку по силам, запись не трогает', () async {
    final (shiftId, worker, manager) = await upcomingShift();
    session.setUser(manager);
    final before = (await shifts.shiftById(shiftId))!;
    expect(await editTo(shiftId, before, startMinutes: 480), BookingResult.ok);

    session.setUser(worker);
    expect((await shifts.shiftById(shiftId))!.isApplied, isTrue);
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

  test('смена, перенесённая после напоминания, напоминает о новом дне',
      () async {
    final (shiftId, worker, manager) = await upcomingShift(); // сегодня 10:00
    final today = DateTime(clock.now.year, clock.now.month, clock.now.day);

    clock.now = today.subtract(const Duration(hours: 13)); // вчера, 11:00
    expect(await shifts.sendReminders(), 1);

    // Заказчик переносит смену на завтра. О сегодняшнем дне уже
    // напомнили, но напоминание было о другом дне.
    session.setUser(manager);
    final before = (await shifts.shiftById(shiftId))!;
    final edit = await shifts.updateShift(
      shiftId: shiftId,
      workDate: today.add(const Duration(days: 1)),
      title: before.title,
      address: before.address,
      startMinutes: before.startMinutes,
      endMinutes: before.endMinutes,
      hourlyRate: before.hourlyRate,
      workersNeeded: before.workersNeeded,
    );
    expect(edit.result, BookingResult.ok);

    expect(await shifts.sendReminders(), 0, reason: 'до нового дня больше суток');
    clock.now = today.add(const Duration(hours: 11)); // сегодня, 11:00
    expect(await shifts.sendReminders(), 1);
    expect(await shifts.sendReminders(), 0, reason: 'о новом дне — один раз');

    session.setUser(worker);
    final reminders = (await shifts.notifications())
        .where((n) => n.kind == NotificationKind.reminder);
    expect(reminders, hasLength(2));
  });

  test('напоминание из прошлой версии тоже не повторяется', () async {
    final (shiftId, worker, _) = await upcomingShift(); // сегодня 10:00
    final today = DateTime(clock.now.year, clock.now.month, clock.now.day);

    // Такую строку записала версия до схемы 23 — без начала смены.
    await db.into(db.notificationRows).insert(NotificationRowsCompanion.insert(
          userId: worker.id,
          kind: NotificationKind.reminder.name,
          title: 'Смена завтра в 10:00',
          body: '',
          shiftId: Value(shiftId),
          createdAt: today.subtract(const Duration(hours: 14)),
        ));

    clock.now = today.subtract(const Duration(hours: 13));
    expect(await shifts.sendReminders(), 0);
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

  test('отметившемуся по коду невыход не поставить', () async {
    final (shiftId, worker, manager) = await upcomingShift(); // сегодня 10:00
    session.setUser(manager);
    final code = (await shifts.checkInCode(shiftId))!;

    clock.setHour(10);
    session.setUser(worker);
    expect(await shifts.checkIn(shiftId, code: code), BookingResult.ok);

    // Код видно только на точке — значит, человек был на месте. Невыход
    // забрал бы его заработок заказчику.
    session.setUser(manager);
    expect(
      await shifts.markNoShow(shiftId: shiftId, workerId: worker.id),
      BookingResult.checkedIn,
    );
    expect(
      await shifts.confirmAttendance(shiftId: shiftId, workerId: worker.id),
      BookingResult.ok,
    );
  });

  test('код отметки не перебрать: после пяти ошибок он не принимается',
      () async {
    final (shiftId, worker, manager) = await upcomingShift();
    session.setUser(manager);
    final code = (await shifts.checkInCode(shiftId))!;
    final wrong = code == '0000' ? '1111' : '0000';

    clock.setHour(10);
    session.setUser(worker);
    for (var i = 0; i < kMaxCheckInAttempts; i++) {
      expect(await shifts.checkIn(shiftId, code: wrong),
          BookingResult.wrongCode);
    }
    expect(await shifts.checkIn(shiftId, code: code),
        BookingResult.tooManyAttempts,
        reason: 'даже верный код — попытки кончились');
    expect((await shifts.shiftById(shiftId))!.isCheckedIn, isFalse);
  });

  test('одновременный перебор кода тоже упирается в предел', () async {
    final (shiftId, worker, manager) = await upcomingShift();
    session.setUser(manager);
    final code = (await shifts.checkInCode(shiftId))!;

    clock.setHour(10);
    session.setUser(worker);
    final guesses = [
      for (var i = 0; i < 100; i++) i.toString().padLeft(4, '0'),
    ]..remove(code);
    await Future.wait(guesses.map((g) => shifts.checkIn(shiftId, code: g)));
    expect(await shifts.checkIn(shiftId, code: code),
        BookingResult.tooManyAttempts);
  });

  test('ночная смена после полуночи — ещё в работе, и отметиться можно',
      () async {
    final manager = await auth.register(
      phone: '77000000901',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Magnum',
    );
    final worker = await auth.register(
      phone: '77000000902',
      fullName: 'Ернар Калдыбеков',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    session.setUser(manager);
    final shiftId = await shifts.publishShift(
      workDate: daysAgo(0),
      title: 'Ночная выкладка товара',
      company: 'Magnum',
      address: 'г. Алматы, ул. Абая, 1',
      startMinutes: 22 * 60,
      endMinutes: 6 * 60,
      hourlyRate: 100000,
      workersNeeded: 1,
      createdBy: manager.id,
      city: 'Алматы',
      card: testCard,
    );
    session.setUser(worker);
    expect(await shifts.apply(shiftId), BookingResult.ok);

    // Десять минут первого: день смены уже вчерашний, а сама смена идёт.
    final today = DateTime(clock.now.year, clock.now.month, clock.now.day);
    clock.now = today.add(const Duration(days: 1, minutes: 10));
    final active = await shifts.myShifts(archived: false);
    expect(active.map((s) => s.id), contains(shiftId));
    expect(
      (await shifts.myShifts(archived: true)).map((s) => s.id),
      isNot(contains(shiftId)),
    );
    expect(await shifts.checkIn(shiftId), BookingResult.ok);

    // Утром смена кончилась — и уходит в архив.
    clock.now = today.add(const Duration(days: 1, hours: 7));
    expect(
      (await shifts.myShifts(archived: true)).map((s) => s.id),
      contains(shiftId),
    );
  });

  test('повторная запись — с чистого листа: «точно выйду» не переносится',
      () async {
    final (shiftId, worker, manager) = await upcomingShift(); // сегодня 10:00
    session.setUser(worker);
    // Вчера в 23:00: подтвердить уже можно, а отменить ещё не поздно.
    clock.now = DateTime(clock.now.year, clock.now.month, clock.now.day - 1, 23);
    expect(await shifts.confirmComing(shiftId), BookingResult.ok);
    expect(await shifts.cancelApplication(shiftId), BookingResult.ok);
    expect(await shifts.apply(shiftId), BookingResult.ok);

    expect((await shifts.shiftById(shiftId))!.isComingConfirmed, isFalse);
    session.setUser(manager);
    expect((await shifts.applicantsFor(shiftId)).single.comingConfirmedAt,
        isNull);
  });

  test('на свою смену записаться нельзя', () async {
    final (shiftId, _, manager) = await upcomingShift();
    session.setUser(manager);
    expect(await shifts.apply(shiftId), BookingResult.ownShift);
  });

  // ---------------------------------------------------------------------
  // УДАЛЕНИЕ АККАУНТА И ФИЛЬТР ЛЕНТЫ
  // ---------------------------------------------------------------------

  test('аккаунт не удалить, пока у человека живая запись', () async {
    final (shiftId, worker, manager) = await upcomingShift(); // сегодня 10:00
    await expectLater(
      deleteAccountIn(db, worker.id, now: clock.now),
      throwsA(isA<UserError>()),
    );
    // И заказчику со своей предстоящей сменой — тоже.
    await expectLater(
      deleteAccountIn(db, manager.id, now: clock.now),
      throwsA(isA<UserError>()),
    );

    // Смена прошла — запись больше не держит. Но заказчик подтвердил
    // выход, и на балансе появились деньги: их сначала нужно вывести.
    clock.setHour(23);
    session.setUser(manager);
    await shifts.confirmAttendance(shiftId: shiftId, workerId: worker.id);
    await expectLater(
      deleteAccountIn(db, worker.id, now: clock.now),
      throwsA(isA<UserError>()),
    );
  });

  test('удалённый аккаунт обезличен, а история смен осталась', () async {
    final (shiftId, workerId, managerId) = await workedShift();
    // Заработанное выведено — баланс пустой.
    final balance = await db.customSelect(
      "SELECT COALESCE(SUM(amount), 0) AS b FROM wallet_entry_rows "
      "WHERE user_id = $workerId AND kind IN ('earning', 'withdrawal')",
    ).getSingle();
    await db.into(db.walletEntryRows).insert(WalletEntryRowsCompanion.insert(
          userId: workerId,
          kind: WalletEntryKind.withdrawal,
          amount: -balance.read<int>('b'),
          title: 'вывод',
          createdAt: DateTime.now(),
        ));
    await db.into(db.documentRows).insert(DocumentRowsCompanion.insert(
          userId: workerId,
          type: 'id_card',
          number: '012345678',
          status: 'approved',
          createdAt: DateTime.now(),
        ));
    await db.into(db.authTokenRows).insert(AuthTokenRowsCompanion.insert(
          token: 't',
          userId: Value(workerId),
          email: 'worker@example.kz',
          createdAt: DateTime.now(),
        ));

    await deleteAccountIn(db, workerId);

    final row = await (db.select(db.userRows)
          ..where((u) => u.id.equals(workerId)))
        .getSingle();
    expect(row.phone, 'deleted-$workerId');
    expect(row.email, isNull);
    expect(row.fullName, isNot('Ернар Калдыбеков'));
    expect(await db.select(db.documentRows).get(), isEmpty);
    expect(await db.select(db.authTokenRows).get(), isEmpty);
    // Отработанная смена и отзывы о ней никуда не делись.
    session.setUser((await auth.refresh(managerId))!);
    expect((await shifts.applicantsFor(shiftId)).single.isConfirmed, isTrue);
    // А телефон освободился — по нему можно зарегистрироваться заново.
    expect(await auth.findByPhone('77000000022'), isNull);
  });

  test('фильтр ленты не предлагает компании и виды работ из прошлого',
      () async {
    await workedShift(); // смена Magnum два дня назад
    final (_, worker, _) = await upcomingShift(); // и Magnum сегодня
    session.setUser(worker);
    expect(await shifts.companies(), ['Magnum']);

    // Сегодняшнюю отменили — в будущем у Magnum ничего нет.
    final today = (await shifts.myShifts(archived: false)).single;
    session.setUser((await auth.refresh(today.createdBy!))!);
    await shifts.cancelShift(today.id);
    session.setUser(worker);
    expect(await shifts.companies(), isEmpty,
        reason: 'прошлые смены в фильтр не попадают');
    expect(await shifts.categories(), isEmpty);
  });

  test('имя можно исправить, но не на пустое', () async {
    final (_, worker, _) = await upcomingShift();
    final fixed = await auth.changeName(worker.id, '  Азамат   Серикбаев ');
    expect(fixed!.fullName, 'Азамат Серикбаев', reason: 'лишние пробелы убраны');
    await expectLater(
        auth.changeName(worker.id, ' я '), throwsA(isA<UserError>()));
    await expectLater(
        auth.changeName(worker.id, 'а' * 81), throwsA(isA<UserError>()));
  });

  test('подписчики на разных языках — по одному уведомлению на своём языке',
      () async {
    final manager = await auth.register(
      phone: '77060000001',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Magnum',
    );
    final followers = <AppUser, Lang?>{};
    for (final (i, lang) in [Lang.kk, Lang.en, null].indexed) {
      final user = await auth.register(
        phone: '7706000001$i',
        fullName: 'Подписчик $i',
        city: 'Алматы',
        acceptedTermsVersion: kTermsVersion,
      );
      if (lang != null) await rememberLanguage(db, user.id, lang);
      session.setUser(user);
      await shifts.followCompany('Magnum', follow: true);
      // И на вид работ — уведомление всё равно одно.
      await shifts.followCategory('cashier', follow: true);
      followers[user] = lang;
    }

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
      category: 'cashier',
      card: testCard,
    );

    for (final MapEntry(key: user, value: lang) in followers.entries) {
      session.setUser(user);
      final mine = (await shifts.notifications())
          .where((n) => n.kind == NotificationKind.newShift)
          .toList();
      expect(mine, hasLength(1), reason: 'одно уведомление на смену');
      // Без своего языка — на языке того, кто публиковал (здесь русский).
      final shift = (await shifts.shiftById(shiftId))!;
      final expected = CoreStrings.of(lang ?? Lang.ru).newShift(
          'Magnum',
          shift.title,
          shift.workDate,
          '10:00–20:00',
          formatMoney(shift.totalPay));
      expect(mine.single.title, expected.title);
    }
  });

  // ---------------------------------------------------------------------
  // ПЕРЕПИСКА ПО СМЕНЕ
  // ---------------------------------------------------------------------

  test('исполнитель и заказчик переписываются, собеседник узнаёт об этом',
      () async {
    final (shiftId, worker, manager) = await upcomingShift();

    session.setUser(worker);
    await shifts.sendChatMessage(shiftId, '  Опаздываю на 15 минут  ');

    session.setUser(manager);
    final note = (await shifts.notifications())
        .firstWhere((n) => n.kind == NotificationKind.message);
    expect(note.peerId, worker.id, reason: 'по нему откроется разговор');
    expect(note.body, contains('Опаздываю на 15 минут'));

    final thread = await shifts.chatMessages(shiftId, workerId: worker.id);
    expect(thread.single.text, 'Опаздываю на 15 минут');
    expect(thread.single.mine, isFalse);
    await shifts.sendChatMessage(shiftId, 'Хорошо, ждём', workerId: worker.id);

    session.setUser(worker);
    final mine = await shifts.chatMessages(shiftId);
    expect(mine.map((m) => (m.text, m.mine)), [
      ('Опаздываю на 15 минут', true),
      ('Хорошо, ждём', false),
    ]);
  });

  test('чужую переписку не прочитать и в неё не написать', () async {
    final (shiftId, worker, _) = await upcomingShift();
    final stranger = await auth.register(
      phone: '77070000001',
      fullName: 'Посторонний',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    session.setUser(worker);
    await shifts.sendChatMessage(shiftId, 'Где вход?');

    // Не записан на смену — ни читать, ни писать.
    session.setUser(stranger);
    await expectLater(
        shifts.chatMessages(shiftId), throwsA(isA<UserError>()));
    await expectLater(shifts.chatMessages(shiftId, workerId: worker.id),
        throwsA(isA<UserError>()),
        reason: 'чужой номер в запросе не помогает');
    await expectLater(shifts.sendChatMessage(shiftId, 'привет'),
        throwsA(isA<UserError>()));
    // Пустое не отправляется.
    session.setUser(worker);
    await expectLater(
        shifts.sendChatMessage(shiftId, '   '), throwsA(isA<UserError>()));
  });

  test('подходящее человеку — из подписок и отработанных смен', () async {
    final (_, workerId, _) = await workedShift(); // Magnum, отработана
    session.setUser((await auth.refresh(workerId))!);
    await shifts.followCategory('loader', follow: true);
    await shifts.followCompany('Zara', follow: true);

    final taste = await shifts.workerTaste();
    expect(taste.workedCompanies, {'Magnum'});
    expect(taste.followedCompanies, {'Zara'});
    expect(taste.followedCategories, {'loader'});
    expect(taste.workedCategories, isNotEmpty);
  });

  test('отзывы об исполнителе видит его заказчик, но не посторонний',
      () async {
    final (shiftId, workerId, managerId) = await workedShift();
    session.setUser((await auth.refresh(managerId))!);
    await shifts.rateWorker(
        shiftId: shiftId, workerId: workerId, rating: 5, comment: 'Молодец');

    // Заказчик, у которого человек отработал, — видит.
    expect((await shifts.reviewsAbout(workerId)).single.comment, 'Молодец');
    // Сам человек — тоже.
    session.setUser((await auth.refresh(workerId))!);
    expect(await shifts.reviewsAbout(workerId), hasLength(1));
    // Посторонний заказчик — нет.
    final other = await auth.register(
      phone: '77080000001',
      fullName: 'Другой заказчик',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Zara',
    );
    session.setUser(other);
    await expectLater(
        shifts.reviewsAbout(workerId), throwsA(isA<UserError>()));
  });

  test('причина отмены доходит до заказчика на его языке', () async {
    final (shiftId, worker, manager) = await upcomingShift(); // сегодня 10:00
    await rememberLanguage(db, manager.id, Lang.en);
    session.setUser(worker);
    clock.now = DateTime(clock.now.year, clock.now.month, clock.now.day - 1, 20);
    expect(await shifts.cancelApplication(shiftId, reason: CancelReason.sick),
        BookingResult.ok);

    session.setUser(manager);
    final note = (await shifts.notifications())
        .firstWhere((n) => n.kind == NotificationKind.withdrew);
    expect(note.body, contains('Reason: sick'));
  });

  test('любимого можно позвать на свою смену — один раз', () async {
    final (_, workerId, managerId) = await workedShift();
    final manager = (await auth.refresh(managerId))!;
    session.setUser(manager);
    expect(await shifts.setFavorite(workerId: workerId, favorite: true),
        BookingResult.ok);
    final shiftId = await shifts.publishShift(
      workDate: daysAgo(-1),
      title: 'Услуги грузчика',
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

    Future<int> invites() async {
      session.setUser((await auth.refresh(workerId))!);
      final n = (await shifts.notifications())
          .where((n) =>
              n.kind == NotificationKind.invited && n.shiftId == shiftId)
          .length;
      session.setUser(manager);
      return n;
    }

    final before = await invites(); // приглашение при публикации
    expect(await shifts.inviteToShift(shiftId: shiftId, workerId: workerId),
        BookingResult.ok);
    expect(await invites(), before,
        reason: 'второе приглашение на ту же смену не шлём');
    expect(before, 1, reason: 'любимым приглашение уходит уже при публикации');

    // Уведомление удалили (например, позже приглашали заново) — приходит.
    await db.delete(db.notificationRows).go();
    expect(await shifts.inviteToShift(shiftId: shiftId, workerId: workerId),
        BookingResult.ok);
    expect(await invites(), 1);

    // Не любимого — нельзя: приглашение не рассылка всем подряд.
    final stranger = await auth.register(
      phone: '77090000001',
      fullName: 'Незнакомец',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    expect(await shifts.inviteToShift(shiftId: shiftId, workerId: stranger.id),
        BookingResult.notMine);

    // Записался — звать уже некуда.
    session.setUser((await auth.refresh(workerId))!);
    expect(await shifts.apply(shiftId), BookingResult.ok);
    session.setUser(manager);
    expect(await shifts.inviteToShift(shiftId: shiftId, workerId: workerId),
        BookingResult.alreadyBooked);

    // Чужую смену — нельзя.
    session.setUser(stranger);
    expect(await shifts.inviteToShift(shiftId: shiftId, workerId: workerId),
        BookingResult.notMine);
  });
  test('«свободен»: только ближайшие две недели, снять можно', () async {
    final worker = await auth.register(
      phone: '77070000001',
      fullName: 'Азамат Серик',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    session.setUser(worker);
    final today = daysAgo(0);
    final tomorrow = daysAgo(-1);
    await shifts.setAvailable(tomorrow, available: true);
    await shifts.setAvailable(tomorrow, available: true); // второй раз — не ошибка
    await shifts.setAvailable(today, available: true);
    expect(await shifts.availability(), {today, tomorrow});
    await shifts.setAvailable(today, available: false);
    expect(await shifts.availability(), {tomorrow});

    expect(() => shifts.setAvailable(daysAgo(1), available: true),
        throwsA(isA<UserError>()));
    expect(() => shifts.setAvailable(daysAgo(-14), available: true),
        throwsA(isA<UserError>()));
  });

  test('заказчик видит свободных в день смены своего города и может позвать',
      () async {
    final manager = await auth.register(
      phone: '77070000010',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Magnum',
    );
    Future<AppUser> worker(String phone, String name, String city) =>
        auth.register(
          phone: phone,
          fullName: name,
          city: city,
          acceptedTermsVersion: kTermsVersion,
        );
    final free = await worker('77070000011', 'Свободный Алматы', 'Алматы');
    final booked = await worker('77070000012', 'Уже Записан', 'Алматы');
    final astana = await worker('77070000013', 'Свободный Астана', 'Астана');
    final busy = await worker('77070000014', 'Не Отмечал', 'Алматы');

    final day = daysAgo(-2);
    session.setUser(manager);
    final shiftId = await shifts.publishShift(
      workDate: day,
      title: 'Услуги грузчика',
      company: 'Magnum',
      address: 'г. Алматы, ул. Абая, 1',
      startMinutes: 600,
      endMinutes: 1200,
      hourlyRate: 100000,
      workersNeeded: 3,
      createdBy: manager.id,
      city: 'Алматы',
      card: testCard,
    );

    for (final w in [free, booked, astana]) {
      session.setUser(w);
      await shifts.setAvailable(day, available: true);
    }
    session.setUser(booked);
    expect(await shifts.apply(shiftId), BookingResult.ok);

    session.setUser(manager);
    final list = await shifts.availableWorkers(shiftId);
    expect(list.map((k) => k.user.fullName), ['Свободный Алматы']);
    expect(list.single.user.phone, isEmpty,
        reason: 'согласие на приглашение — не на звонки');

    // Позвать свободного можно, хотя вместе не работали.
    expect(await shifts.inviteToShift(shiftId: shiftId, workerId: free.id),
        BookingResult.ok);
    // А того, кто день не отмечал, — по-прежнему нельзя.
    expect(await shifts.inviteToShift(shiftId: shiftId, workerId: busy.id),
        BookingResult.notMine);

    // Чужая смена — пустой список.
    final other = await auth.register(
      phone: '77070000019',
      fullName: 'Другой Заказчик',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Small',
    );
    session.setUser(other);
    expect(await shifts.availableWorkers(shiftId), isEmpty);
  });

  test('о новой смене в свободный день сообщают — не больше трёх за день',
      () async {
    final manager = await auth.register(
      phone: '77080000010',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Magnum',
    );
    final free = await auth.register(
      phone: '77080000011',
      fullName: 'Свободный',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    final astana = await auth.register(
      phone: '77080000012',
      fullName: 'Из Астаны',
      city: 'Астана',
      acceptedTermsVersion: kTermsVersion,
    );
    final day = daysAgo(-2);
    for (final w in [free, astana]) {
      session.setUser(w);
      await shifts.setAvailable(day, available: true);
    }

    session.setUser(manager);
    for (var i = 0; i < 4; i++) {
      await shifts.publishShift(
        workDate: day,
        title: 'Смена $i',
        company: 'Magnum',
        address: 'г. Алматы, ул. Абая, 1',
        startMinutes: 360 + i * 60,
        endMinutes: 420 + i * 60,
        hourlyRate: 100000,
        workersNeeded: 2,
        createdBy: manager.id,
        city: 'Алматы',
        card: testCard,
      );
    }

    Future<List<String>> titles(AppUser user) async {
      session.setUser(user);
      return [
        for (final n in await shifts.notifications())
          if (n.kind == NotificationKind.newShift) n.title,
      ];
    }

    final mine = await titles(free);
    expect(mine, hasLength(3));
    expect(mine.first, 'Смена в ваш свободный день');
    expect(await titles(astana), isEmpty);
  });

  test('приглашённые считаются, выдуманный пригласивший — не ошибка',
      () async {
    final inviter = await auth.register(
      phone: '77030000001',
      fullName: 'Ернар Калдыбеков',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    final friend = await auth.register(
      phone: '77030000002',
      fullName: 'Друг Первый',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      referredBy: inviter.id,
    );
    await auth.register(
      phone: '77030000003',
      fullName: 'Друг Второй',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      referredBy: inviter.id,
    );
    // Номер из ссылки мог быть выдуман — регистрация всё равно проходит.
    final lost = await auth.register(
      phone: '77030000004',
      fullName: 'Без Пригласившего',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      referredBy: 999999,
    );
    expect(lost.id, isPositive);

    session.setUser(inviter);
    var stats = await shifts.referralStats();
    expect((stats.joined, stats.worked), (2, 0));

    // Первый друг отработал смену — теперь он «вышел на смену».
    final (shiftId, _, _) = await workedShift();
    await db.into(db.applicationRows).insert(ApplicationRowsCompanion.insert(
          shiftId: shiftId,
          workerId: friend.id,
          status: 'completed',
          createdAt: DateTime.now(),
        ));
    session.setUser(inviter);
    stats = await shifts.referralStats();
    expect((stats.joined, stats.worked), (2, 1));
  });

  Future<(AppUser manager, AppUser worker)> foodPeople(String tag) async {
    final manager = await auth.register(
      phone: '7704000000$tag',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Magnum',
    );
    final worker = await auth.register(
      phone: '7705000000$tag',
      fullName: 'Азамат Серик',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    return (manager, worker);
  }

  Future<int> foodShift(AppUser manager, DateTime day,
          {int start = 600, int end = 1200}) =>
      shifts.publishShift(
        workDate: day,
        title: 'Услуги повара',
        company: 'Magnum',
        address: 'г. Алматы, ул. Абая, 1',
        startMinutes: start,
        endMinutes: end,
        hourlyRate: 100000,
        workersNeeded: 2,
        createdBy: manager.id,
        city: 'Алматы',
        card: testCard,
        category: 'cook',
        needsMedicalBook: true,
      );

  Future<void> approvedBook(DateTime until) async {
    final documents = DbDocumentRepository(db, session);
    await documents.upload(
        type: 'medical_book', number: 'МК', expiresAt: until);
    await documents.review((await documents.documents()).single.id,
        approved: true);
  }

  test('ночная смена: санкнижка должна действовать и утром', () async {
    final (manager, worker) = await foodPeople('1');
    final day = daysAgo(-3);
    session.setUser(manager);
    final night = await foodShift(manager, day, start: 1320, end: 360);

    session.setUser(worker);
    await approvedBook(day); // истекает в день начала — к утру уже нет
    expect(await shifts.apply(night), BookingResult.needsMedicalBook);
    await approvedBook(DateTime(day.year, day.month, day.day + 1));
    expect(await shifts.apply(night), BookingResult.ok);
  });

  test('смену передвинули за срок санкнижки — запись снимается', () async {
    final (manager, worker) = await foodPeople('2');
    final day = daysAgo(-3);
    session.setUser(manager);
    final shiftId = await foodShift(manager, day);
    session.setUser(worker);
    await approvedBook(day);
    expect(await shifts.apply(shiftId), BookingResult.ok);

    session.setUser(manager);
    final later = DateTime(day.year, day.month, day.day + 2);
    final edit = await shifts.updateShift(
      shiftId: shiftId,
      workDate: later,
      title: 'Услуги повара',
      address: 'г. Алматы, ул. Абая, 1',
      startMinutes: 600,
      endMinutes: 1200,
      hourlyRate: 100000,
      workersNeeded: 2,
    );
    expect(edit.result, BookingResult.ok);

    session.setUser(worker);
    expect((await shifts.shiftById(shiftId))!.isApplied, isFalse);
    final note = (await shifts.notifications())
        .firstWhere((n) => n.kind == NotificationKind.shiftChanged);
    expect(note.body, contains('санитарная книжка'));
  });

  test('удалённый аккаунт не в «знакомых», позвать и пригласить его нельзя',
      () async {
    final (_, workerId, managerId) = await workedShift();
    // Так помечает удалённый аккаунт `deleteAccountIn` (настоящее удаление
    // не пустит: на балансе заработок за смену).
    await (db.update(db.userRows)..where((u) => u.id.equals(workerId)))
        .write(UserRowsCompanion(phone: Value('deleted-$workerId')));
    final manager = (await auth.refresh(managerId))!;
    session.setUser(manager);
    expect(await shifts.knownWorkers(), isEmpty);
    final next = await shifts.publishShift(
      workDate: daysAgo(-1),
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
    expect(await shifts.inviteToShift(shiftId: next, workerId: workerId),
        BookingResult.notFound);

    // По ссылке удалённого приглашение не засчитывается.
    final friend = await auth.register(
      phone: '77060000001',
      fullName: 'Друг',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      referredBy: workerId,
    );
    final row = await (db.select(db.userRows)
          ..where((u) => u.id.equals(friend.id)))
        .getSingle();
    expect(row.referredBy, isNull);
  });

  test('на смену с санкнижкой — только с проверенной и действующей',
      () async {
    final manager = await auth.register(
      phone: '77010000099',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Magnum',
    );
    final worker = await auth.register(
      phone: '77020000099',
      fullName: 'Азамат Серик',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    session.setUser(manager);
    final shiftDay = daysAgo(-3);
    final shiftId = await shifts.publishShift(
      workDate: shiftDay,
      title: 'Услуги повара',
      company: 'Magnum',
      address: 'г. Алматы, ул. Абая, 1',
      startMinutes: 600,
      endMinutes: 1200,
      hourlyRate: 100000,
      workersNeeded: 2,
      createdBy: manager.id,
      city: 'Алматы',
      card: testCard,
      category: 'cook',
      needsMedicalBook: true,
    );
    expect((await shifts.shiftById(shiftId))!.needsMedicalBook, isTrue);

    session.setUser(worker);
    final documents = DbDocumentRepository(db, session);
    // Без книжки — нельзя.
    expect(await shifts.apply(shiftId), BookingResult.needsMedicalBook);

    // На проверке — тоже нельзя: обещание ещё не книжка.
    await documents.upload(
      type: 'medical_book',
      number: 'МК-1',
      expiresAt: DateTime(shiftDay.year, shiftDay.month, shiftDay.day - 1),
    );
    expect(await shifts.apply(shiftId), BookingResult.needsMedicalBook);

    // Проверена, но истекает накануне смены — нельзя.
    final id = (await documents.documents()).single.id;
    await documents.review(id, approved: true);
    expect(await shifts.apply(shiftId), BookingResult.needsMedicalBook);

    // Действует в день смены — можно.
    await documents.upload(
      type: 'medical_book',
      number: 'МК-2',
      expiresAt: shiftDay,
    );
    await documents.review((await documents.documents()).single.id,
        approved: true);
    expect(await shifts.apply(shiftId), BookingResult.ok);
  });

  test('отработавшего у заказчика можно позвать и не делая любимым',
      () async {
    final (_, workerId, managerId) = await workedShift();
    final manager = (await auth.refresh(managerId))!;
    session.setUser(manager);

    // Знакомые: с общей историей, но пока не в любимых.
    final known = await shifts.knownWorkers();
    expect(known.map((k) => k.user.id), [workerId]);
    expect(known.single.isFavorite, isFalse);
    expect(known.single.user.completedShifts, 1);
    expect(known.single.user.noShows, 0);

    final shiftId = await shifts.publishShift(
      workDate: daysAgo(-1),
      title: 'Услуги грузчика',
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
    expect(await shifts.inviteToShift(shiftId: shiftId, workerId: workerId),
        BookingResult.ok);
    session.setUser((await auth.refresh(workerId))!);
    expect(
        (await shifts.notifications())
            .where((n) =>
                n.kind == NotificationKind.invited && n.shiftId == shiftId)
            .length,
        1);

    // Незнакомого — по-прежнему нельзя.
    final stranger = await auth.register(
      phone: '77090000002',
      fullName: 'Незнакомец',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    session.setUser(manager);
    expect(await shifts.inviteToShift(shiftId: shiftId, workerId: stranger.id),
        BookingResult.notMine);

    // Любимый — в списке первым и со звёздочкой.
    await shifts.setFavorite(workerId: workerId, favorite: true);
    expect((await shifts.knownWorkers()).single.isFavorite, isTrue);

    // У другого заказчика своих знакомых нет.
    final other = await auth.register(
      phone: '77090000003',
      fullName: 'Другой Заказчик',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: UserRole.manager,
      company: 'Small',
    );
    session.setUser(other);
    expect(await shifts.knownWorkers(), isEmpty);
  });

  test('непрочитанные сообщения считаются и гаснут после прочтения', () async {
    final (shiftId, worker, manager) = await upcomingShift();
    session.setUser(worker);
    await shifts.sendChatMessage(shiftId, 'Опаздываю на 15 минут');
    await shifts.sendChatMessage(shiftId, 'Уже подъезжаю');

    session.setUser(manager);
    expect((await shifts.applicantsFor(shiftId)).single.unreadMessages, 2);
    await shifts.chatMessages(shiftId, workerId: worker.id);
    expect((await shifts.applicantsFor(shiftId)).single.unreadMessages, 0);
    await shifts.sendChatMessage(shiftId, 'Ждём', workerId: worker.id);

    session.setUser(worker);
    expect(await shifts.unreadChat(shiftId), 1,
        reason: 'свои сообщения непрочитанными не считаются');
    await shifts.chatMessages(shiftId);
    expect(await shifts.unreadChat(shiftId), 0);
  });
  test('скрытая компания пропадает из ленты, своя смена — нет', () async {
    final (shiftId, worker, _) = await upcomingShift(); // Magnum, записан
    final (otherId, _, _) = await upcomingShift(); // ещё Magnum, не записан
    session.setUser(worker);
    await shifts.followCompany('Magnum', follow: true);

    await shifts.hideCompany('Magnum', hide: true);
    final today = (await shifts.shiftsOn(DateTime.now())).map((s) => s.id);
    expect(today, contains(shiftId), reason: 'на свою смену записан');
    expect(today, isNot(contains(otherId)));
    expect(await shifts.companies(), isNot(contains('Magnum')));
    final info = await shifts.companyInfo('Magnum');
    expect(info.isHidden, isTrue);
    expect(info.isFollowed, isFalse, reason: 'скрыл — значит и не следит');

    await shifts.hideCompany('Magnum', hide: false);
    expect((await shifts.shiftsOn(DateTime.now())).map((s) => s.id),
        contains(otherId));
  });
}
