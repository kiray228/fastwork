import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:fastwork/data/session.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/mrp_store.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/mrp.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_core/payment.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/publish.dart';

/// Тестовая карта: проходит всегда.
final testCard = tokenizeSandboxCard(kSandboxCardNumber);

/// МРП, лимит в 300 МРП и согласие с правилами.
void main() {
  group('МРП', () {
    test('в 2026 году МРП — 4 325 ₸, лимит — 1 297 500 ₸ в месяц', () {
      final sept = DateTime(2026, 9, 1);
      expect(mrpOn(sept, kMrpHistory), 432500);
      expect(monthlyEarningsLimit(sept, kMrpHistory), 129750000);
    });

    test('лимит считается по МРП на 1 января, а не на сегодня', () {
      // МРП поменяли посреди года — как было в 2022-м.
      final rates = [
        MrpRate(validFrom: DateTime(2022, 1, 1), amount: 306300),
        MrpRate(validFrom: DateTime(2022, 4, 1), amount: 318000),
      ];
      final june = DateTime(2022, 6, 1);

      expect(mrpOn(june, rates), 318000);
      expect(monthlyEarningsLimit(june, rates), 300 * 306300);
    });

    test('дата раньше всех известных берёт самое раннее значение', () {
      expect(mrpOn(DateTime(1999), kMrpHistory), kMrpHistory.first.amount);
    });

    test('в лимит идут и отработанные, и записанные смены', () {
      final limit = EarningsLimit(
        month: DateTime(2026, 9),
        earned: 1000000,
        booked: 500000,
        limit: 2000000,
        mrp: 432500,
      );
      expect(limit.used, 1500000);
      expect(limit.remaining, 500000);
      expect(limit.allows(500000), isTrue);
      expect(limit.allows(500001), isFalse);
    });

    test('лимит переживает дорогу через JSON', () {
      final limit = EarningsLimit(
        month: DateTime(2026, 9),
        earned: 1,
        booked: 2,
        limit: 3,
        mrp: 4,
      );
      final back = EarningsLimit.fromJson(limit.toJson());
      expect(back.month, limit.month);
      expect(back.used, 3);
      expect(back.mrp, 4);
    });
  });

  group('база', () {
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

    test('новое значение МРП из базы дополняет список из кода', () async {
      final store = MrpStore(db);
      await store.setRate(DateTime(2027, 1, 1), 470000);

      final rates = await store.rates();
      expect(rates.last.amount, 470000);
      expect(mrpOn(DateTime(2027, 3, 1), rates), 470000);
      // Прошлые годы на месте.
      expect(mrpOn(DateTime(2026, 3, 1), rates), 432500);
    });

    test('значение из базы важнее значения из кода на ту же дату', () async {
      final store = MrpStore(db);
      await store.setRate(DateTime(2026, 1, 1), 440000);
      await store.setRate(DateTime(2026, 1, 1), 450000); // передумали

      expect(mrpOn(DateTime(2026, 5, 1), await store.rates()), 450000);
    });

    test('запись сверх лимита отклоняется', () async {
      final manager = await auth.register(
        phone: '77000000001',
        fullName: 'Айгуль Досова',
        city: 'Алматы',
        acceptedTermsVersion: kTermsVersion,
        role: UserRole.manager,
        company: 'Magnum',
      );
      final worker = await auth.register(
        phone: '77000000002',
        fullName: 'Ернар Калдыбеков',
        city: 'Алматы',
        acceptedTermsVersion: kTermsVersion,
      );

      // МРП в 50 ₸ на все годы — лимит 15 000 ₸.
      await MrpStore(db).setRate(DateTime(2000, 1, 1), 5000);
      for (final r in kMrpHistory) {
        await MrpStore(db).setRate(r.validFrom, 5000);
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      Future<int> create(String title) => shifts.publishShift(
            workDate: today,
            title: title,
            company: 'Magnum',
            address: 'ул. Абая, 1',
            startMinutes: 600,
            endMinutes: 1320,
            hourlyRate: 110000, // 12 100 ₸ за смену
            workersNeeded: 3,
            createdBy: manager.id,
            city: 'Алматы',
            card: testCard,
          );
      session.setUser(manager);
      final first = await create('Первая');
      final second = await create('Вторая');

      session.setUser(worker);
      expect(await shifts.apply(first), BookingResult.ok);
      expect(await shifts.apply(second), BookingResult.earningsLimit);

      final limit = await shifts.earningsLimit(today);
      expect(limit.booked, 1210000);
      expect(limit.limit, 1500000);
    });

    test('без согласия с правилами аккаунт не создаётся', () async {
      expect(
        () => auth.register(
          phone: '77000000003',
          fullName: 'Без Согласия',
          city: 'Алматы',
          acceptedTermsVersion: 0,
        ),
        throwsA(isA<TermsNotAccepted>()),
      );
    });

    test('согласие запоминается и его можно дать позже', () async {
      final user = await auth.register(
        phone: '77000000004',
        fullName: 'Асем Оспанова',
        city: 'Алматы',
        acceptedTermsVersion: kTermsVersion,
      );
      expect(user.hasAcceptedTerms, isTrue);

      // Как будто правила поменялись после регистрации.
      await (db.update(db.userRows)..where((u) => u.id.equals(user.id)))
          .write(const UserRowsCompanion(termsVersion: Value(0)));
      expect((await auth.refresh(user.id))!.hasAcceptedTerms, isFalse);

      final accepted = await auth.acceptTerms(user.id);
      expect(accepted!.hasAcceptedTerms, isTrue);
    });
  });
}
