import 'package:drift/native.dart';
import 'package:fastwork/data/session.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_core/user.dart';
import 'package:flutter_test/flutter_test.dart';

/// Деньги: карта, комиссия и гарантия оплаты на настоящей SQLite.
void main() {
  final card = tokenizeSandboxCard(kSandboxCardNumber);
  final declined = tokenizeSandboxCard(kSandboxDeclinedCardNumber);

  group('карта', () {
    test('алгоритм Луна пропускает верный номер и ловит опечатку', () {
      expect(luhnValid(cardDigits(kSandboxCardNumber)), isTrue);
      expect(luhnValid('4242424242424241'), isFalse);
      expect(luhnValid('42'), isFalse);
    });

    test('платёжная система — по первым цифрам', () {
      expect(cardBrand('4242424242424242'), 'Visa');
      expect(cardBrand('5555555555554444'), 'Mastercard');
      expect(cardBrand('2200123412341234'), 'МИР');
    });

    test('карта действует до конца указанного месяца', () {
      final now = DateTime(2026, 9, 23);
      expect(expiryValid('09/26', now), isTrue);
      expect(expiryValid('08/26', now), isFalse);
      expect(expiryValid('13/30', now), isFalse);
      expect(expiryValid('1230', now), isTrue);
    });

    test('в токене остаются только последние четыре цифры', () {
      expect(card.last4, '4242');
      expect(card.token, isNot(contains('4242 4242')));
      expect(card.masked, 'Visa •• 4242');
    });
  });

  group('комиссия', () {
    test('4% сверху: за смену в 12 100 ₸ заказчик платит 12 584 ₸', () {
      const cost = ShiftCost(slotPay: 1210000, slots: 1);
      expect(cost.fee, 48400);
      expect(formatMoney(cost.total), '12 584 ₸');
    });

    test('итог за место — целые тенге: Kaspi считает без тиынов', () {
      const odd = ShiftCost(slotPay: 861667, slots: 3);
      expect((odd.slotPay + odd.slotFee) % 100, 0);
      expect(odd.slotFee, greaterThanOrEqualTo(platformFee(odd.slotPay)));
    });

    test('номер для Kaspi — в любом привычном виде', () {
      expect(normalizeKzPhone('+7 701 123 45 67'), '77011234567');
      expect(normalizeKzPhone('87011234567'), '77011234567');
      expect(normalizeKzPhone('7011234567'), '77011234567');
      expect(normalizeKzPhone('+7 495 123 45 67'), isNull,
          reason: 'не казахстанский мобильный');
      expect(formatKzPhone('77011234567'), '+7 701 123 45 67');
    });

    test('комиссия считается с места, чтобы возврат за место был точным', () {
      const cost = ShiftCost(slotPay: 1210033, slots: 3);
      expect(cost.fee, cost.slotFee * 3);
      expect(cost.total, (cost.slotPay + cost.slotFee) * 3);
    });
  });

  group('гарантия оплаты', () {
    late AppDatabase db;
    late AppSession session;
    late SandboxPaymentGateway gateway;
    late DbShiftRepository shifts;
    late DbWalletRepository wallet;
    late DbAuthRepository auth;
    late AppUser manager;
    late AppUser worker;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      session = AppSession();
      gateway = SandboxPaymentGateway();
      shifts = DbShiftRepository(db, session, payments: gateway);
      wallet = DbWalletRepository(db, session, payments: gateway);
      auth = DbAuthRepository(db);
      manager = await auth.register(
        phone: '77000000001',
        fullName: 'Айгуль Досова',
        city: 'Алматы',
        acceptedTermsVersion: kTermsVersion,
        role: UserRole.manager,
        company: 'Magnum',
      );
      worker = await auth.register(
        phone: '77000000002',
        fullName: 'Ернар Калдыбеков',
        city: 'Алматы',
        acceptedTermsVersion: kTermsVersion,
      );
    });

    tearDown(() => db.close());

    /// Завести смену сегодня на двоих, по 12 100 ₸ каждому, и начать оплату.
    Future<PaymentCheckout> order({
      PaymentMethod method = PaymentMethod.card,
      String? phone,
    }) {
      session.setUser(manager);
      final now = DateTime.now();
      return shifts.createShift(
        method: method,
        phone: phone,
        workDate: DateTime(now.year, now.month, now.day),
        title: 'Услуги грузчика',
        company: 'Magnum',
        address: 'ул. Абая, 1',
        startMinutes: 600,
        endMinutes: 1320,
        hourlyRate: 110000,
        workersNeeded: 2,
        createdBy: manager.id,
        city: 'Алматы',
      );
    }

    /// Смена, созданная и оплаченная тестовой картой.
    Future<int> publish({PaymentCard? paidWith}) async {
      final checkout = await order();
      final paid =
          await shifts.completeSandboxPayment(checkout.id, card: paidWith ?? card);
      if (!paid.isPaid) throw PaymentDeclined(paid.message!);
      return checkout.shiftId!;
    }

    Future<List<Shift>> feed() async {
      session.setUser(worker);
      return shifts.shiftsOn(DateTime.now());
    }

    Future<void> book(int shiftId) async {
      session.setUser(worker);
      expect(await shifts.apply(shiftId), BookingResult.ok);
    }

    Future<WalletSummary> summaryOf(AppUser user) async {
      session.setUser(user);
      return wallet.summary();
    }

    test('публикация списывает вознаграждение и 4% комиссии', () async {
      final id = await publish();

      expect(gateway.operations, ['charge:${2 * 1258400}']);
      expect((await shifts.shiftById(id))!.isFunded, isTrue);

      final history = await summaryOf(manager);
      expect(history.entries.single.kind, WalletEntryKind.charge);
      expect(history.entries.single.amount, -2 * 1258400);
    });

    test('отказ банка — смена ждёт оплаты, в ленте её нет', () async {
      await expectLater(
        publish(paidWith: declined),
        throwsA(isA<PaymentDeclined>()),
      );

      expect(gateway.operations, isEmpty);
      expect(await feed(), isEmpty);
      session.setUser(manager);
      final mine = await shifts.shiftsCreatedBy(manager.id);
      expect(mine.single.awaitingPayment, isTrue);
      expect(mine.single.isFunded, isFalse);
    });

    test('пока провайдер не подтвердил, смены нет в ленте', () async {
      final checkout = await order();
      expect(checkout.isPending, isTrue);
      expect(checkout.sandbox, isTrue);
      expect(await feed(), isEmpty);
      // Исполнитель не откроет её и по номеру.
      expect(await shifts.shiftById(checkout.shiftId!), isNull);

      session.setUser(manager);
      await shifts.completeSandboxPayment(checkout.id, card: card);
      expect((await feed()).single.isFunded, isTrue);
    });

    test('Kaspi: счёт на номер, подтверждение — и смена в ленте', () async {
      final checkout = await order(
        method: PaymentMethod.kaspi,
        phone: '+7 (701) 123-45-67',
      );
      expect(checkout.method, PaymentMethod.kaspi);
      expect(checkout.phone, '77011234567');
      expect(checkout.url, isNull, reason: 'счёт приходит в Kaspi.kz');

      session.setUser(manager);
      final paid = await shifts.completeSandboxPayment(checkout.id);
      expect(paid.isPaid, isTrue);
      expect(await feed(), hasLength(1));

      final history = await summaryOf(manager);
      expect(history.entries.single.title, contains('Kaspi.kz'));
    });

    test('Kaspi без номера телефона не начать', () async {
      await expectLater(
        order(method: PaymentMethod.kaspi, phone: '12'),
        throwsA(isA<PaymentDeclined>()),
      );
    });

    test('после отказа можно оплатить ту же смену другим способом', () async {
      final first = await order();
      session.setUser(manager);
      final failed =
          await shifts.completeSandboxPayment(first.id, card: declined);
      expect(failed.isFailed, isTrue);
      expect(failed.message, contains('Банк'));

      final second = await shifts.retryPayment(
        first.shiftId!,
        method: PaymentMethod.kaspi,
        phone: '87011234567',
      );
      expect(second.shiftId, first.shiftId);
      await shifts.completeSandboxPayment(second.id);
      expect(await feed(), hasLength(1));
      session.setUser(manager);
      expect(await shifts.shiftsCreatedBy(manager.id), hasLength(1),
          reason: 'повтор не заводит вторую смену');
    });

    test('оплатили дважды — лишнее возвращается само', () async {
      final first = await order();
      session.setUser(manager);
      final second = await shifts.retryPayment(first.shiftId!,
          method: PaymentMethod.card);

      await shifts.completeSandboxPayment(second.id, card: card);
      await shifts.completeSandboxPayment(first.id, card: card);

      expect(gateway.operations,
          ['charge:${2 * 1258400}', 'charge:${2 * 1258400}',
           'refund:${2 * 1258400}']);
      final history = await summaryOf(manager);
      final net = history.entries.fold<int>(0, (sum, e) => sum + e.amount);
      expect(net, -2 * 1258400, reason: 'заплачено ровно один раз');
    });

    test('отменённую, пока платили, оплату возвращаем', () async {
      final checkout = await order();
      session.setUser(manager);
      await shifts.cancelShift(checkout.shiftId!);
      await shifts.completeSandboxPayment(checkout.id, card: card);

      expect(gateway.operations.last, 'refund:${2 * 1258400}');
      expect(await feed(), isEmpty);
    });

    test('чужую оплату не посмотреть', () async {
      final checkout = await order();
      session.setUser(worker);
      await expectLater(
        shifts.paymentStatus(checkout.id),
        throwsA(isA<PaymentDeclined>()),
      );
    });

    test(
      'подтверждённый выход переводит деньги исполнителю — один раз',
      () async {
        final id = await publish();
        await book(id);

        session.setUser(manager);
        await shifts.confirmAttendance(shiftId: id, workerId: worker.id);
        await shifts.confirmAttendance(shiftId: id, workerId: worker.id);

        final mine = await summaryOf(worker);
        expect(mine.balance, 1210000);
        expect(mine.earnedTotal, 1210000);
      },
    );

    test('за невыход деньги за место возвращаются заказчику', () async {
      final id = await publish();
      await book(id);

      session.setUser(manager);
      await shifts.markNoShow(shiftId: id, workerId: worker.id);

      expect(gateway.operations.last, 'refund:1258400');
      expect((await summaryOf(worker)).balance, 0);

      // Передумать кнопкой нельзя: деньги уже вернулись.
      session.setUser(manager);
      expect(
        await shifts.confirmAttendance(shiftId: id, workerId: worker.id),
        BookingResult.alreadyBooked,
      );
    });

    test('при отмене заказчику возвращается всё, что не ушло людям', () async {
      final id = await publish();
      await book(id);

      session.setUser(manager);
      await shifts.confirmAttendance(shiftId: id, workerId: worker.id);
      await shifts.cancelShift(id);

      // Внесено за двоих, один отработал — вернули второе место.
      expect(gateway.operations.last, 'refund:1258400');
      expect((await shifts.shiftById(id))!.isFunded, isFalse);
      // Отработавший своё получил.
      expect((await summaryOf(worker)).balance, 1210000);
    });

    test('подорожавшая правка ждёт доплаты и применяется после неё',
        () async {
      final id = await publish();
      session.setUser(manager);
      final before = (await shifts.shiftById(id))!;

      final result = await shifts.updateShift(
        shiftId: id,
        workDate: before.workDate,
        title: before.title,
        address: before.address,
        startMinutes: before.startMinutes,
        endMinutes: before.endMinutes,
        hourlyRate: 150000,
        workersNeeded: before.workersNeeded,
      );

      expect(result.result, BookingResult.paymentRequired);
      final topup = result.checkout!;
      final after = ShiftCost.of(Shift(
        id: 0,
        workDate: before.workDate,
        title: '',
        company: '',
        address: '',
        startMinutes: 600,
        endMinutes: 1320,
        hourlyRate: 150000,
        workersNeeded: 2,
        workersHired: 0,
      ));
      expect(topup.amount, after.total - 2 * 1258400);
      // Пока доплаты нет — в ленте прежняя ставка.
      expect((await shifts.shiftById(id))!.hourlyRate, 110000);

      await shifts.completeSandboxPayment(topup.id, card: card);
      expect((await shifts.shiftById(id))!.hourlyRate, 150000);

      // Отменили — вернули всё, разложив по двум операциям.
      await shifts.cancelShift(id);
      expect(gateway.operations.sublist(gateway.operations.length - 2), [
        'refund:${topup.amount}',
        'refund:${2 * 1258400}',
      ]);
    });

    test('неоплаченную смену не правят', () async {
      final checkout = await order();
      session.setUser(manager);
      final before = (await shifts.shiftById(checkout.shiftId!))!;
      final result = await shifts.updateShift(
        shiftId: before.id,
        workDate: before.workDate,
        title: 'Другое название',
        address: before.address,
        startMinutes: before.startMinutes,
        endMinutes: before.endMinutes,
        hourlyRate: before.hourlyRate,
        workersNeeded: before.workersNeeded,
      );
      expect(result.result, BookingResult.awaitingPayment);
    });

    test('подешевевшая правка сама возвращает разницу', () async {
      final id = await publish();
      session.setUser(manager);
      final before = (await shifts.shiftById(id))!;

      final result = await shifts.updateShift(
        shiftId: id,
        workDate: before.workDate,
        title: before.title,
        address: before.address,
        startMinutes: before.startMinutes,
        endMinutes: before.endMinutes,
        hourlyRate: before.hourlyRate,
        workersNeeded: 1, // вместо двух
      );

      expect(result.result, BookingResult.ok);
      expect(gateway.operations.last, 'refund:1258400');

      // И при отмене вернётся только то, что осталось, — без двойного
      // счёта разницы, которую уже вернули.
      await shifts.cancelShift(id);
      expect(gateway.operations.last, 'refund:1258400');
      final history = await summaryOf(manager);
      final net = history.entries.fold<int>(0, (sum, e) => sum + e.amount);
      expect(net, 0);
    });

    test('вывести можно не больше баланса и не меньше минимума', () async {
      final id = await publish();
      await book(id);
      session.setUser(manager);
      await shifts.confirmAttendance(shiftId: id, workerId: worker.id);

      session.setUser(worker);
      await expectLater(
        wallet.startWithdrawal(1210001),
        throwsA(isA<WithdrawRejected>()),
      );
      await expectLater(
        wallet.startWithdrawal(100),
        throwsA(isA<WithdrawRejected>()),
      );

      final payout = await wallet.startWithdrawal(1210000);
      // Сумма ушла с баланса сразу — второй раз её не вывести.
      expect((await wallet.summary()).balance, 0);
      await expectLater(
        wallet.startWithdrawal(1210000),
        throwsA(isA<WithdrawRejected>()),
      );

      final done = await wallet.completeSandboxWithdrawal(payout.id, card);
      expect(done.isPaid, isTrue);
      expect(gateway.operations.last, 'payout:1210000');
      expect((await wallet.summary()).balance, 0);
    });

    test('непрошедший перевод возвращает деньги на баланс', () async {
      final id = await publish();
      await book(id);
      session.setUser(manager);
      await shifts.confirmAttendance(shiftId: id, workerId: worker.id);

      session.setUser(worker);
      final payout = await wallet.startWithdrawal(1210000);
      final failed = await wallet.completeSandboxWithdrawal(payout.id, declined);
      expect(failed.isFailed, isTrue);
      expect((await wallet.summary()).balance, 1210000);
      // В истории — и вывод, и его возврат: журнал только дописывается.
      final kinds = (await wallet.summary())
          .entries
          .where((e) => e.kind == WalletEntryKind.withdrawal)
          .map((e) => e.amount);
      expect(kinds, containsAll([-1210000, 1210000]));
    });

    test('учебные смены оплачены сервисом', () async {
      session.setUser(worker);
      await shifts.seedIfEmpty();
      await shifts.prepareDemoHistory(worker.id);

      final today = await shifts.shiftsOn(DateTime.now());
      expect(today.every((s) => s.isFunded), isTrue);
      // История отработанного — это уже начисленные деньги.
      expect((await wallet.summary()).balance, greaterThan(0));
    });
  });
}
