import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fastwork/data/app_preferences.dart';
import 'package:fastwork/data/repositories.dart';
import 'package:fastwork/data/session.dart';
import 'package:fastwork/main.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/fake_shift_repository.dart';
import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/support.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_core/user.dart';

/// Что появилось вокруг историй: ближайшая смена в ленте, тема, «Поделиться»,
/// срок медкнижки, русский календарь.
void main() {
  AppUser testUser({String role = UserRole.worker, int completed = 0}) =>
      AppUser(
        id: 1,
        phone: '77001234567',
        fullName: 'Ернар Калдыбеков',
        city: 'Алматы',
        rating: 4.6,
        isVerified: false,
        role: role,
        company: role == UserRole.manager ? 'Magnum' : null,
        termsVersion: kTermsVersion,
        completedShifts: completed,
      );

  Future<AppPreferences> openApp(
    WidgetTester tester, {
    String role = UserRole.worker,
    FakeShiftRepository? shifts,
  }) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(420, 2200);
    addTearDown(tester.view.reset);

    final user = testUser(role: role);
    final store = shifts ?? FakeShiftRepository();
    final preferences = AppPreferences();
    await tester.pumpWidget(FastworkApp(
      session: AppSession()..setUser(user),
      repos: AppRepositories(
        shifts: store,
        auth: FakeAuthRepository(signedIn: user),
        documents: FakeDocumentRepository(),
        support: FakeSupportRepository(),
        wallet: FakeWalletRepository(store),
      ),
      preferences: preferences,
    ));
    await tester.pumpAndSettle();
    return preferences;
  }

  /// Пока история открыта, её таймер не даёт экрану «успокоиться».
  Future<void> step(WidgetTester tester, [int ms = 700]) async {
    for (var i = 0; i < ms ~/ 100; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('главный экран', () {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    Shift shiftOn(DateTime day, {int start = 540, int end = 1020}) => Shift(
          id: 1,
          workDate: day,
          title: 'Сборка заказов',
          company: 'Склад «Восток»',
          address: 'ул. Садовая, 12',
          startMinutes: start,
          endMinutes: end,
          hourlyRate: 100000,
          workersNeeded: 3,
          workersHired: 0,
        );

    testWidgets('ближайшая смена видна прямо в ленте', (tester) async {
      final shifts = FakeShiftRepository(
        shifts: [shiftOn(today.add(const Duration(days: 1)))],
      );
      await shifts.apply(1);
      await openApp(tester, shifts: shifts);

      expect(find.text('Ближайшая смена'), findsOneWidget);
      expect(find.text('Завтра, 09:00 — 17:00'), findsOneWidget);
      expect(find.text('Я на месте'), findsNothing);
    });

    testWidgets('в день смены с баннера можно отметиться', (tester) async {
      // Смена началась полчаса назад — отметка уже открыта в любое время
      // суток, в котором запустят тест.
      final minutes = now.hour * 60 + now.minute;
      final start = minutes < 30 ? 0 : minutes - 30;
      final shifts = FakeShiftRepository(
        shifts: [shiftOn(today, start: start, end: (start + 240) % 1440)],
      );
      await shifts.apply(1);
      await openApp(tester, shifts: shifts);

      await tester.tap(find.text('Я на месте'));
      await tester.pumpAndSettle();

      expect(find.text('Отметка принята — заказчик её видит'), findsOneWidget);
      expect(find.text('Вы на смене'), findsOneWidget);
      expect(find.text('Я на месте'), findsNothing);
    });

    testWidgets('без записей баннера нет', (tester) async {
      await openApp(tester);
      expect(find.textContaining('Ближайшая смена'), findsNothing);
    });

    testWidgets('пустые «Мои» ведут в ленту', (tester) async {
      await openApp(tester);

      await tester.tap(find.text('Мои'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Найти смену'));
      await tester.pumpAndSettle();

      expect(find.text('Выплаты'), findsOneWidget); // кружок историй
    });

    testWidgets('«Поделиться» кладёт описание смены в буфер обмена',
        (tester) async {
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String;
          }
          return null;
        },
      );
      addTearDown(() => tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null));

      await openApp(tester);
      await tester.tap(find.text('Подробнее').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Поделиться'));
      await tester.pumpAndSettle();

      expect(copied, contains('Смена в fastwork'));
      expect(copied, contains('₸ за смену'));
      expect(find.text('Описание смены скопировано — вставьте его в чат'),
          findsOneWidget);
    });
  });

  group('профиль', () {
    testWidgets('тему можно выбрать самому', (tester) async {
      final prefs = await openApp(tester);

      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      expect(find.text('Как в системе'), findsOneWidget);

      await tester.tap(find.text('Оформление'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Тёмное'));
      await tester.pumpAndSettle();

      expect(prefs.themeMode, ThemeMode.dark);
      final context = tester.element(find.text('Оформление'));
      expect(Theme.of(context).brightness, Brightness.dark);
      expect(find.text('Тёмное'), findsOneWidget); // подпись в строке
    });

    testWidgets('«Как работает fastwork» открывает истории', (tester) async {
      await openApp(tester);

      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Как работает fastwork'));
      await step(tester);

      expect(find.text('Подработка на один день'), findsOneWidget);
    });
  });

  group('ядро', () {
    test('ближайшие дни называются словами', () {
      final now = DateTime(2026, 9, 24, 15);
      expect(relativeDay(DateTime(2026, 9, 24), now), 'сегодня');
      expect(relativeDay(DateTime(2026, 9, 25), now), 'завтра');
      expect(relativeDay(DateTime(2026, 9, 26), now), 'послезавтра');
      expect(relativeDay(DateTime(2026, 9, 29), now), '29 сен, вт');
      // Через границу месяца и года — тоже по календарю.
      expect(relativeDay(DateTime(2027, 1, 1), DateTime(2026, 12, 31, 23)),
          'завтра');
    });

    test('ночная смена ещё идёт после полуночи', () {
      final night = Shift(
        id: 1,
        workDate: DateTime(2026, 9, 24),
        title: 'Ночная',
        company: 'Склад',
        address: 'Абая, 1',
        startMinutes: 22 * 60,
        endMinutes: 6 * 60,
        hourlyRate: 100000,
        workersNeeded: 1,
        workersHired: 0,
      );
      expect(night.endsAt, DateTime(2026, 9, 25, 6));
      expect(night.isAheadAt(DateTime(2026, 9, 25, 3)), isTrue);
      expect(night.isAheadAt(DateTime(2026, 9, 25, 7)), isFalse);
    });

    test('уровни берутся из одной таблицы', () {
      expect(testUser(completed: 0).level, 'Новичок');
      expect(testUser(completed: 5).level, 'Уверенный');
      expect(testUser(completed: 49).level, 'Опытный');
      expect(testUser(completed: 50).level, 'Профи');
      expect(testUser(completed: 7).nextLevel?.name, 'Опытный');
      expect(testUser(completed: 60).nextLevel, isNull);
    });

    test('описание смены для пересылки', () {
      final shift = Shift(
        id: 1,
        workDate: DateTime(2026, 9, 25),
        title: 'Сборка заказов',
        company: 'Склад «Восток»',
        address: 'ул. Садовая, 12',
        startMinutes: 540,
        endMinutes: 1200,
        hourlyRate: 121000,
        workersNeeded: 3,
        workersHired: 0,
        isFunded: true,
      );
      expect(
        shiftShareText(shift),
        'Сборка заказов — Склад «Восток»\n'
        '25 сен, пт, 09:00–20:00\n'
        'ул. Садовая, 12\n'
        '12 100 ₸ за смену, оплата гарантирована\n'
        'Смена в fastwork',
      );
    });
  });

  group('документы', () {
    Future<void> openDocuments(WidgetTester tester) async {
      await openApp(tester);
      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Документы'));
      await tester.pumpAndSettle();
    }

    testWidgets('у медкнижки спрашивают срок, и он виден в карточке',
        (tester) async {
      await openDocuments(tester);

      await tester.tap(find.text('Загрузить').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'МК-2041');
      await tester.tap(find.text('Отправить'));
      await tester.pumpAndSettle();
      expect(find.text('Укажите, до какого числа действует медосмотр'),
          findsOneWidget);

      await tester.tap(find.text('Действует до…'));
      await tester.pumpAndSettle();
      // Календарь по-русски — с русской кнопкой подтверждения.
      await tester.tap(find.text('ОК'));
      await tester.pumpAndSettle();

      final now = DateTime.now();
      final until = formatDate(DateTime(now.year + 1, now.month, now.day));
      expect(find.text('Действует до $until'), findsOneWidget);

      await tester.tap(find.text('Отправить'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('На проверке'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('Принят'), findsOneWidget);
      expect(find.text('Действует до $until'), findsOneWidget);
    });

    testWidgets('из документов открывается история о проверке',
        (tester) async {
      await openDocuments(tester);

      await tester.tap(find.text('Как проходит проверка'));
      await step(tester);

      expect(find.text('Какие документы нужны'), findsOneWidget);
      // Справка открыта с экрана документов — кнопки «Загрузить
      // документы» в ней нет, человек и так здесь.
      expect(find.text('Загрузить документы'), findsNothing);
    });
  });

  group('срок документа', () {
    UserDocument doc(DateTime? until) => UserDocument(
          id: 1,
          type: 'medical_book',
          number: '1',
          expiresAt: until,
          status: 'approved',
          createdAt: DateTime(2026),
        );
    final now = DateTime(2026, 9, 24, 18);

    test('действует до конца последнего дня', () {
      expect(doc(DateTime(2026, 9, 24)).isExpiredAt(now), isFalse);
      expect(doc(DateTime(2026, 9, 23)).isExpiredAt(now), isTrue);
      expect(doc(null).isExpiredAt(now), isFalse);
    });

    test('за месяц до конца срока — предупреждаем', () {
      expect(doc(DateTime(2026, 10, 10)).expiresSoonAt(now), isTrue);
      expect(doc(DateTime(2026, 12, 1)).expiresSoonAt(now), isFalse);
      expect(doc(DateTime(2026, 9, 20)).expiresSoonAt(now), isFalse,
          reason: 'просроченный — уже не «скоро»');
      expect(doc(DateTime(2026, 10, 1)).daysLeftAt(now), 7);
    });

    test('дни по-русски', () {
      expect(daysLabel(1), '1 день');
      expect(daysLabel(3), '3 дня');
      expect(daysLabel(11), '11 дней');
      expect(daysLabel(21), '21 день');
      expect(formatDate(DateTime(2027, 3, 5)), '05.03.2027');
    });
  });
}
