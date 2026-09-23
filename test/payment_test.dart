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

    /// Смена сегодня на двоих, по 12 100 ₸ каждому.
    Future<int> publish({PaymentCard? paidWith}) {
      session.setUser(manager);
      final now = DateTime.now();
      return shifts.createShift(
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
        card: paidWith ?? card,
      );
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

    test('отказ банка — смены нет и ничего не списано', () async {
      await expectLater(
        publish(paidWith: declined),
        throwsA(isA<PaymentDeclined>()),
      );

      expect(gateway.operations, isEmpty);
      session.setUser(manager);
      expect(await shifts.shiftsCreatedBy(manager.id), isEmpty);
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

    test('подорожавшая правка без карты не проходит', () async {
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

      expect(result, BookingResult.paymentRequired);
      expect((await shifts.shiftById(id))!.hourlyRate, 110000);
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

      expect(result, BookingResult.ok);
      expect(gateway.operations.last, 'refund:1258400');
    });

    test('вывести можно не больше баланса и не меньше минимума', () async {
      final id = await publish();
      await book(id);
      session.setUser(manager);
      await shifts.confirmAttendance(shiftId: id, workerId: worker.id);

      session.setUser(worker);
      await expectLater(
        wallet.withdraw(amount: 1210001, card: card),
        throwsA(isA<WithdrawRejected>()),
      );
      await expectLater(
        wallet.withdraw(amount: 100, card: card),
        throwsA(isA<WithdrawRejected>()),
      );

      await wallet.withdraw(amount: 1210000, card: card);
      expect(gateway.operations.last, 'payout:1210000');
      expect((await wallet.summary()).balance, 0);
    });

    test('непрошедший перевод возвращает деньги на баланс', () async {
      final id = await publish();
      await book(id);
      session.setUser(manager);
      await shifts.confirmAttendance(shiftId: id, workerId: worker.id);

      session.setUser(worker);
      await expectLater(
        wallet.withdraw(amount: 1210000, card: declined),
        throwsA(isA<PaymentDeclined>()),
      );
      expect((await wallet.summary()).balance, 1210000);
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
