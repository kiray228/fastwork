import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork/data/app_preferences.dart';
import 'package:fastwork/data/repositories.dart';
import 'package:fastwork/data/session.dart';
import 'package:fastwork/main.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/current_user.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/fake_shift_repository.dart';
import 'package:fastwork_core/data/guest_shifts.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/terms.dart';
import 'support/clock.dart';

/// Гость: смены видно до входа, а вход нужен только для записи.
void main() {
  final clock = TestClock.today();

  GuestShifts guest() => RepositoryGuestShifts(
        (city) => FakeShiftRepository(city: city, clock: clock.call),
        clock: clock.call,
      );

  AppRepositories repos() {
    final shifts = FakeShiftRepository(clock: clock.call);
    return AppRepositories(
      shifts: shifts,
      auth: FakeAuthRepository(),
      documents: FakeDocumentRepository(),
      support: FakeSupportRepository(),
      wallet: FakeWalletRepository(shifts),
      guest: guest(),
    );
  }

  void useTallPhone(WidgetTester tester) {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(420, 2200);
    addTearDown(tester.view.reset);
  }

  group('экран', () {
    testWidgets('со входа — в ленту гостя, оттуда в смену и обратно ко входу',
        (tester) async {
      useTallPhone(tester);
      final preferences = AppPreferences();
      await tester.pumpWidget(FastworkApp(
        session: AppSession(),
        repos: repos(),
        preferences: preferences,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Посмотреть смены без входа'));
      await tester.pumpAndSettle();
      expect(find.text('Смены · Алматы'), findsOneWidget);
      expect(find.text('Услуги курьера'), findsOneWidget);

      await tester.tap(find.text('Услуги курьера'));
      await tester.pumpAndSettle();
      // Гостю — вход вместо записи, и ни слова про переписку.
      expect(find.text('Войти и записаться'), findsOneWidget);
      expect(find.byTooltip('Написать заказчику'), findsNothing);

      await tester.tap(find.text('Войти и записаться'));
      await tester.pumpAndSettle();
      expect(find.text('Начать работать'), findsOneWidget);
      expect(find.text('Войти и записаться'), findsNothing);
    });

    testWidgets('другой город: пусто — так и сказано, город запомнен',
        (tester) async {
      useTallPhone(tester);
      final preferences = AppPreferences();
      await tester.pumpWidget(FastworkApp(
        session: AppSession(),
        repos: repos(),
        preferences: preferences,
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Посмотреть смены без входа'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Город'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Астана').last);
      await tester.pumpAndSettle();

      expect(find.text('Смены · Астана'), findsOneWidget);
      expect(find.text('Пока смен нет'), findsOneWidget);
      expect(preferences.guestCity, 'Астана');
    });

    testWidgets('ссылка от друга без входа сразу открывает смену',
        (tester) async {
      useTallPhone(tester);
      await tester.pumpWidget(FastworkApp(
        session: AppSession(),
        repos: repos(),
        sharedShiftId: 4,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Услуги курьера'), findsOneWidget);
      expect(find.text('Войти и записаться'), findsOneWidget);
    });

    testWidgets('без гостевых смен кнопки нет', (tester) async {
      final shifts = FakeShiftRepository(clock: clock.call);
      await tester.pumpWidget(FastworkApp(
        session: AppSession(),
        repos: AppRepositories(
          shifts: shifts,
          auth: FakeAuthRepository(),
          documents: FakeDocumentRepository(),
          support: FakeSupportRepository(),
          wallet: FakeWalletRepository(shifts),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Посмотреть смены без входа'), findsNothing);
    });
  });

  group('база', () {
    late AppDatabase db;
    late DbShiftRepository manager;
    late int bossId;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      final boss = await DbAuthRepository(db).register(
        phone: '77000000001',
        fullName: 'Айгуль Досова',
        city: 'Алматы',
        acceptedTermsVersion: kTermsVersion,
        role: UserRole.manager,
        company: 'Magnum',
      );
      bossId = boss.id;
      manager = DbShiftRepository(db, StaticUser(boss),
          payments: SandboxPaymentGateway(), clock: clock.call);
    });

    tearDown(() => db.close());

    test('гость видит только оплаченные смены своего города', () async {
      final day = DateTime(clock.now.year, clock.now.month, clock.now.day + 1);
      Future<int> create({required bool pay}) async {
        final checkout = await manager.createShift(
          workDate: day,
          title: 'Услуги грузчика',
          company: 'Magnum',
          address: 'ул. Абая, 1',
          startMinutes: 600,
          endMinutes: 1200,
          hourlyRate: 120000,
          workersNeeded: 2,
          createdBy: bossId,
          city: 'Алматы',
          category: 'loader',
          method: PaymentMethod.kaspi,
          phone: '87011234567',
        );
        if (pay) await manager.completeSandboxPayment(checkout.id);
        return checkout.shiftId!;
      }

      final paid = await create(pay: true);
      final unpaid = await create(pay: false);
      final guest = RepositoryGuestShifts(
        (city) => DbShiftRepository(db, GuestCity(city), clock: clock.call),
        clock: clock.call,
      );

      final almaty = await guest.upcoming('Алматы');
      expect(almaty.map((s) => s.id), [paid]);
      expect(almaty.single.myStatus, isNull);
      expect(await guest.upcoming('Астана'), isEmpty);
      expect((await guest.shiftById(paid))?.id, paid);
      expect(await guest.shiftById(unpaid), isNull);
    });
  });
}
