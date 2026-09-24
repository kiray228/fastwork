import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork/main.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/fake_shift_repository.dart';
import 'package:fastwork/data/repositories.dart';
import 'package:fastwork/data/session.dart';
import 'package:fastwork_core/data/shift_filter.dart';
import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/mrp.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/notification.dart';
import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_core/user.dart';
import 'package:fastwork/widgets/skeleton.dart';

/// Проверяем экраны целиком — как будто пользователь тыкает пальцем,
/// только очень быстро.
///
/// Вместо настоящей базы подставляем данные в памяти. Экраны разницы не
/// замечают: они работают с интерфейсами хранилищ, а не с SQLite.
void main() {
  AppUser testUser({double rating = 4.0, String role = UserRole.worker}) =>
      AppUser(
        id: 1,
        phone: '77001234567',
        fullName: 'Ернар Калдыбеков',
        city: 'Алматы',
        rating: rating,
        isVerified: false,
        role: role,
        company: role == UserRole.manager ? 'Magnum' : null,
        termsVersion: kTermsVersion,
      );

  AppRepositories buildRepos({
    FakeShiftRepository? shifts,
    AppUser? signedIn,
  }) {
    final store = shifts ?? FakeShiftRepository();
    return AppRepositories(
      shifts: store,
      auth: FakeAuthRepository(signedIn: signedIn),
      documents: FakeDocumentRepository(),
      support: FakeSupportRepository(),
      wallet: FakeWalletRepository(store),
    );
  }

  /// По умолчанию тестовый «экран» маленький — 800×600, и часть карточек
  /// в него не влезает. А списки во Flutter создают только те элементы,
  /// что видны, — поэтому ненайденная кнопка означала бы не ошибку,
  /// а просто «её ещё не нарисовали».
  void useTallPhone(WidgetTester tester) {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(420, 2200);
    addTearDown(tester.view.reset);
  }

  /// Запускаем приложение под уже вошедшим пользователем.
  Future<void> openApp(
    WidgetTester tester, {
    double rating = 4.0,
    FakeShiftRepository? shifts,
    String role = UserRole.worker,
    AppRepositories? repos,
  }) async {
    useTallPhone(tester);
    final user = testUser(rating: rating, role: role);
    final session = AppSession()..setUser(user);
    await tester.pumpWidget(FastworkApp(
      session: session,
      repos: repos ??
          buildRepos(
            shifts: shifts ?? FakeShiftRepository(userRating: rating),
            signedIn: user,
          ),
    ));
    await tester.pumpAndSettle();
  }

  /// Запускаем приложение без вошедшего пользователя.
  Future<void> openAppSignedOut(WidgetTester tester) async {
    useTallPhone(tester);
    await tester.pumpWidget(FastworkApp(
      session: AppSession(),
      repos: buildRepos(),
    ));
    await tester.pumpAndSettle();
  }

  group('вход', () {
    testWidgets('без пользователя показывается вход', (tester) async {
      await openAppSignedOut(tester);

      expect(find.text('Вход'), findsOneWidget);
      // На своём устройстве кодов нет — сразу анкета.
      expect(find.text('Начать работать'), findsOneWidget);
    });

    testWidgets('короткий номер не пускает дальше', (tester) async {
      await openAppSignedOut(tester);

      await tester.enterText(find.byType(TextField).first, '77');
      await tester.tap(find.text('Начать работать'));
      await tester.pumpAndSettle();

      expect(find.text('Введите номер телефона полностью'), findsOneWidget);
    });

    testWidgets('без согласия с правилами аккаунт не создаётся',
        (tester) async {
      await openAppSignedOut(tester);

      await tester.enterText(find.byType(TextField).at(0), '77001234567');
      await tester.enterText(find.byType(TextField).at(1), 'Ернар Калдыбеков');
      await tester.tap(find.text('Начать работать'));
      await tester.pumpAndSettle();

      expect(find.text('Чтобы продолжить, примите правила сервиса'),
          findsOneWidget);
      expect(find.text('Подробнее'), findsNothing);
    });

    testWidgets('правила открываются по ссылке у галочки', (tester) async {
      await openAppSignedOut(tester);

      await tester.tap(find.text('правила сервиса'));
      await tester.pumpAndSettle();

      expect(find.text('Правила сервиса fastwork'), findsOneWidget);
      expect(find.text('4. Лимит дохода — 300 МРП в месяц'), findsOneWidget);
    });

    testWidgets('кто не принимал правила, сначала видит их', (tester) async {
      useTallPhone(tester);
      // Аккаунт из времён до правил: версия согласия — ноль.
      final old = testUser().copyWith(termsVersion: 0);
      final session = AppSession()..setUser(old);
      final auth = FakeAuthRepository(signedIn: old);
      await tester.pumpWidget(FastworkApp(
        session: session,
        repos: buildRepos(signedIn: old)
            .withAuth(auth),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Принимаю'), findsOneWidget);
      expect(find.text('Подробнее'), findsNothing);

      // Кнопка не работает, пока нет галочки.
      final accept = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Принимаю'),
      );
      expect(accept.onPressed, isNull);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Принимаю'));
      await tester.pumpAndSettle();

      expect(find.text('Подробнее'), findsWidgets);
      expect(session.user!.hasAcceptedTerms, isTrue);
    });

    testWidgets('регистрация открывает ленту смен', (tester) async {
      await openAppSignedOut(tester);

      await tester.enterText(find.byType(TextField).at(0), '77001234567');
      await tester.enterText(find.byType(TextField).at(1), 'Ернар Калдыбеков');
      await tester.tap(find.byType(Checkbox));
      await tester.tap(find.text('Начать работать'));
      await tester.pumpAndSettle();

      expect(find.text('Подробнее'), findsWidgets);
    });
  });

  group('вход по коду с почты', () {
    /// Хранилище, которое ведёт себя как серверное: требует код.
    AppRepositories codeRepos({AppUser? signedIn}) =>
        buildRepos(signedIn: signedIn).withAuth(FakeAuthRepository(
          signedIn: signedIn,
          requiresEmailCode: true,
        ));

    Future<void> openWithCodes(WidgetTester tester) async {
      useTallPhone(tester);
      await tester.pumpWidget(FastworkApp(
        session: AppSession(),
        repos: codeRepos(),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('сначала спрашивают почту, а не телефон', (tester) async {
      await openWithCodes(tester);

      expect(find.text('Получить код'), findsOneWidget);
      expect(find.text('Почта'), findsOneWidget);
      // Ни телефона, ни выбора роли на первом шаге ещё нет.
      expect(find.text('Номер телефона'), findsNothing);
      expect(find.text('Ищу подработку'), findsNothing);
    });

    testWidgets('кривой адрес не отправляет код', (tester) async {
      await openWithCodes(tester);

      await tester.enterText(find.byType(TextField).first, 'не почта');
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      expect(find.text('Проверьте адрес почты'), findsOneWidget);
      expect(find.text('Подтвердить'), findsNothing);
    });

    testWidgets('после почты просят код', (tester) async {
      await openWithCodes(tester);

      await tester.enterText(
        find.byType(TextField).first,
        'ernar@example.kz',
      );
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      expect(find.text('Код из письма'), findsWidgets);
      expect(find.text('Подтвердить'), findsOneWidget);
      expect(
        find.textContaining('ernar@example.kz'),
        findsOneWidget,
      );
    });

    testWidgets('неверный код не пускает дальше', (tester) async {
      await openWithCodes(tester);

      await tester.enterText(find.byType(TextField).first, 'a@b.kz');
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '999999');
      await tester.tap(find.text('Подтвердить'));
      await tester.pumpAndSettle();

      // Остались на том же шаге, анкета не открылась.
      expect(find.text('Подтвердить'), findsOneWidget);
      expect(find.text('Номер телефона'), findsNothing);
    });

    testWidgets('короткий код даже не отправляется', (tester) async {
      await openWithCodes(tester);

      await tester.enterText(find.byType(TextField).first, 'a@b.kz');
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '12');
      await tester.tap(find.text('Подтвердить'));
      await tester.pumpAndSettle();

      expect(find.text('Код состоит из шести цифр'), findsOneWidget);
    });

    testWidgets('верный код ведёт к анкете, а она — в приложение',
        (tester) async {
      await openWithCodes(tester);

      await tester.enterText(find.byType(TextField).first, 'a@b.kz');
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      // 111111 — код, о котором договорились в FakeAuthRepository.
      await tester.enterText(find.byType(TextField).first, '111111');
      await tester.tap(find.text('Подтвердить'));
      await tester.pumpAndSettle();

      expect(find.text('Немного о вас'), findsOneWidget);
      expect(find.text('Номер телефона'), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), '77001234567');
      await tester.enterText(find.byType(TextField).at(1), 'Ернар Калдыбеков');
      await tester.tap(find.byType(Checkbox));
      await tester.tap(find.text('Начать работать'));
      await tester.pumpAndSettle();

      expect(find.text('Подробнее'), findsWidgets);
    });

    testWidgets('можно вернуться и указать другой адрес', (tester) async {
      await openWithCodes(tester);

      await tester.enterText(find.byType(TextField).first, 'a@b.kz');
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Другой адрес'));
      await tester.pumpAndSettle();

      expect(find.text('Получить код'), findsOneWidget);
    });
  });

  group('лента смен', () {
    testWidgets('нажатие на «Подробнее» открывает экран смены', (tester) async {
      await openApp(tester);

      await tester.tap(find.text('Подробнее').first);
      await tester.pumpAndSettle();

      expect(find.text('Вознаграждение'), findsOneWidget);
      expect(find.text('Записаться на смену'), findsOneWidget);
    });

    testWidgets('кнопка «Мест нет» не открывает экран смены', (tester) async {
      await openApp(tester);

      final soldOut = find.widgetWithText(FilledButton, 'Мест нет');
      expect(soldOut, findsOneWidget);

      // warnIfMissed: false — мы специально жмём по выключенной кнопке.
      await tester.tap(soldOut, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('Вознаграждение'), findsNothing);
    });

    testWidgets('день без смен показывает пустое состояние', (tester) async {
      await openApp(tester);

      final dayAfterTomorrow = DateTime.now().add(const Duration(days: 2));
      await tester.tap(find.text('${dayAfterTomorrow.day}').first);
      await tester.pumpAndSettle();

      expect(find.text('На этот день смен нет'), findsOneWidget);
    });

    testWidgets('фильтр по компании сокращает список', (tester) async {
      await openApp(tester);

      // Сегодня две смены: «Золотое яблоко» и Zara.
      expect(find.text('Золотое яблоко'), findsOneWidget);
      expect(find.text('Zara'), findsOneWidget);

      await tester.tap(find.text('Фильтр'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Zara').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Показать результаты'));
      await tester.pumpAndSettle();

      expect(find.text('Золотое яблоко'), findsNothing);
      expect(find.text('Zara'), findsOneWidget);
      expect(find.text('Фильтр · 1'), findsOneWidget);
    });
  });

  group('запись на смену', () {
    testWidgets('запись требует подтверждения условий', (tester) async {
      await openApp(tester);

      await tester.tap(find.text('Подробнее').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Записаться на смену'));
      await tester.pumpAndSettle();

      expect(find.text('Подтвердите запись'), findsOneWidget);
      expect(find.text('Вы обязуетесь'), findsOneWidget);

      // Пока галочка не поставлена — подтвердить нельзя.
      final confirm = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Подтверждаю'),
      );
      expect(confirm.onPressed, isNull);
    });

    testWidgets('подтверждённая запись сохраняется', (tester) async {
      await openApp(tester);

      await tester.tap(find.text('Подробнее').first);
      await tester.pumpAndSettle();
      expect(find.text('Свободно мест: 3'), findsOneWidget);

      await tester.tap(find.text('Записаться на смену'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Подтверждаю'));
      await tester.pumpAndSettle();

      expect(find.text('Вы записаны на эту смену'), findsOneWidget);
      expect(find.text('Свободно мест: 2'), findsOneWidget);

      // Что написано на нижней кнопке, зависит от времени суток: до смены
      // это «Отменить запись», в день смены — «Я на месте». Проверять это
      // здесь значило бы получить тест, который падает после обеда.
      // Сами правила проверены в repository_test и shift_test.
    });

    testWidgets('отказ в окне условий ничего не меняет', (tester) async {
      await openApp(tester);

      await tester.tap(find.text('Подробнее').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Записаться на смену'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Назад'));
      await tester.pumpAndSettle();

      expect(find.text('Вы записаны на эту смену'), findsNothing);
      expect(find.text('Свободно мест: 3'), findsOneWidget);
    });

    testWidgets('записанная смена появляется в разделе «Мои»', (tester) async {
      await openApp(tester);

      await tester.tap(find.text('Подробнее').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Записаться на смену'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Подтверждаю'));
      await tester.pumpAndSettle();

      // Приложение по-русски, и подсказка у кнопки «назад» тоже.
      await tester.tap(find.byTooltip('Назад'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Мои'));
      await tester.pumpAndSettle();

      expect(find.text('Мои подработки'), findsOneWidget);
      expect(find.text('Золотое яблоко'), findsOneWidget);

      await tester.tap(find.text('Архив'));
      await tester.pumpAndSettle();
      expect(find.text('Пока пусто'), findsOneWidget);
    });
  });

  group('лимит 300 МРП', () {
    testWidgets('смена сверх лимита не записывает и объясняет почему',
        (tester) async {
      // Обе смены сегодня: так они наверняка в одном месяце, в какой бы
      // день ни запустили тест. Каждая — 12 100 ₸.
      final now = DateTime.now();
      Shift today(int id, String title) => Shift(
            id: id,
            workDate: DateTime(now.year, now.month, now.day),
            title: title,
            company: 'Magnum',
            address: 'ул. Абая, 1',
            startMinutes: 600,
            endMinutes: 1320,
            hourlyRate: 110000,
            workersNeeded: 5,
            workersHired: 0,
          );

      // МРП в 50 ₸ — лимит 15 000 ₸: одна смена помещается, вторая нет.
      final repo = FakeShiftRepository(
        userRating: 5.0,
        shifts: [today(1, 'Первая смена'), today(2, 'Вторая смена')],
      )..mrpRates = [MrpRate(validFrom: DateTime(2020), amount: 5000)];
      expect(await repo.apply(1), BookingResult.ok);

      await openApp(tester, rating: 5.0, shifts: repo);
      await tester.tap(find.text('Вторая смена'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Записаться на смену'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Подтверждаю'));
      await tester.pumpAndSettle();

      expect(find.textContaining('превысит 300 МРП'), findsOneWidget);
      expect((await repo.shiftById(2))!.isApplied, isFalse);
    });
  });

  group('рейтинг как допуск', () {
    testWidgets('смена с порогом 4.5 закрыта при рейтинге 4.0',
        (tester) async {
      await openApp(tester, rating: 4.0);

      // Смена Sinsay через три дня требует рейтинг 4.5.
      final inThreeDays = DateTime.now().add(const Duration(days: 3));
      await tester.tap(find.text('${inThreeDays.day}').first);
      await tester.pumpAndSettle();

      expect(find.text('Нужен рейтинг 4.5'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Рейтинг ниже требуемого'),
        findsOneWidget,
      );
    });

    testWidgets('при рейтинге 4.8 та же смена открыта', (tester) async {
      await openApp(tester, rating: 4.8);

      final inThreeDays = DateTime.now().add(const Duration(days: 3));
      await tester.tap(find.text('${inThreeDays.day}').first);
      await tester.pumpAndSettle();

      expect(find.text('Нужен рейтинг 4.5'), findsNothing);
      expect(find.widgetWithText(FilledButton, 'Подробнее'), findsOneWidget);
    });
  });

  group('кошелёк и отзывы', () {
    testWidgets('кошелёк показывает заработок и предупреждение',
        (tester) async {
      final repo = FakeShiftRepository(userRating: 5.0);
      // Смена три дня назад: записался, и заказчик подтвердил выход.
      // Без подтверждения деньги не начисляются.
      await repo.apply(6);
      await repo.confirmAttendance(shiftId: 6, workerId: 1);
      await openApp(tester, rating: 5.0, shifts: repo);

      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Выплаты'));
      await tester.pumpAndSettle();

      expect(find.text('Доступно к выводу'), findsOneWidget);
      expect(find.text('Заработано всего: 12 100 ₸'), findsOneWidget);
      expect(find.textContaining('Лимит за'), findsOneWidget);
      expect(find.textContaining('Тестовый режим оплаты'), findsOneWidget);
    });

    testWidgets('без подтверждения смены выводить нечего', (tester) async {
      final repo = FakeShiftRepository(userRating: 5.0);
      await repo.apply(6);
      await openApp(tester, rating: 5.0, shifts: repo);

      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Выплаты'));
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Вывести на карту'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('заработанное выводится на карту', (tester) async {
      final repo = FakeShiftRepository(userRating: 5.0);
      await repo.apply(6);
      await repo.confirmAttendance(shiftId: 6, workerId: 1);
      await openApp(tester, rating: 5.0, shifts: repo);

      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Выплаты'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Вывести на карту'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Подставить тестовую карту'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Вывести 12 100 ₸'));
      await tester.pumpAndSettle();

      expect(find.text('Деньги отправлены на карту'), findsOneWidget);
      expect(repo.payments.operations, contains('payout:1210000'));
      expect(find.text('Вывод на карту Visa •• 4242'), findsOneWidget);
    });

    testWidgets('отказ банка оставляет окно открытым', (tester) async {
      final repo = FakeShiftRepository(userRating: 5.0);
      await repo.apply(6);
      await repo.confirmAttendance(shiftId: 6, workerId: 1);
      await openApp(tester, rating: 5.0, shifts: repo);

      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Выплаты'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Вывести на карту'));
      await tester.pumpAndSettle();

      final fields = find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(TextField),
      );
      await tester.enterText(fields.at(0), kSandboxDeclinedCardNumber);
      await tester.enterText(fields.at(1), '1230');
      await tester.enterText(fields.at(2), '123');
      await tester.tap(find.text('Вывести 12 100 ₸'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Банк отклонил'), findsOneWidget);
      expect(find.text('Вывод на карту'), findsOneWidget); // окно на месте
      expect(repo.payments.operations, isEmpty);
    });

    testWidgets('отзыв о прошедшей смене сохраняется', (tester) async {
      final repo = FakeShiftRepository(userRating: 5.0);
      await repo.apply(6);
      await repo.confirmAttendance(shiftId: 6, workerId: 1);
      await openApp(tester, rating: 5.0, shifts: repo);

      await tester.tap(find.text('Мои'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Архив'));
      await tester.pumpAndSettle();

      expect(find.text('Оценить место работы'), findsOneWidget);
      await tester.tap(find.text('Оценить место работы'));
      await tester.pumpAndSettle();

      expect(find.text('Как прошла смена?'), findsOneWidget);

      // Ставим пятую звезду и отправляем.
      await tester.tap(find.byIcon(Icons.star_outline_rounded).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Отправить отзыв'));
      await tester.pumpAndSettle();

      expect(find.text('Отзыв оставлен'), findsOneWidget);

      // И оценка появилась на странице компании.
      final info = await repo.companyInfo('Золотое яблоко');
      expect(info.rating, 5);
    });

    testWidgets('без звёзд отзыв отправить нельзя', (tester) async {
      final repo = FakeShiftRepository(userRating: 5.0);
      await repo.apply(6);
      await repo.confirmAttendance(shiftId: 6, workerId: 1);
      await openApp(tester, rating: 5.0, shifts: repo);

      await tester.tap(find.text('Мои'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Архив'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Оценить место работы'));
      await tester.pumpAndSettle();

      final send = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Отправить отзыв'),
      );
      expect(send.onPressed, isNull);
    });
  });

  group('роль заказчика', () {
    testWidgets('регистрация заказчика требует название компании',
        (tester) async {
      await openAppSignedOut(tester);

      await tester.tap(find.text('Нанимаю людей'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), '77005556677');
      await tester.enterText(find.byType(TextField).at(1), 'Асем Оспанова');
      await tester.tap(find.text('Создать аккаунт'));
      await tester.pumpAndSettle();

      expect(find.text('Укажите название компании'), findsOneWidget);
    });

    testWidgets('у заказчика другие вкладки', (tester) async {
      await openApp(tester, role: UserRole.manager);

      expect(find.text('Мои смены'), findsWidgets);
      expect(find.text('Создать'), findsOneWidget);
      // Вкладок исполнителя нет.
      expect(find.text('Смены'), findsNothing);
    });

    testWidgets('заказчик создаёт смену и видит её у себя', (tester) async {
      final shifts = FakeShiftRepository();
      await openApp(
        tester,
        role: UserRole.manager,
        repos: buildRepos(
          shifts: shifts,
          signedIn: testUser(role: UserRole.manager),
        ),
      );

      expect(find.text('Смен пока нет'), findsOneWidget);

      await tester.tap(find.text('Создать'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).at(0),
        'Услуги грузчика',
      );
      await tester.enterText(
        find.byType(TextField).at(1),
        'г. Алматы, ул. Абая, 10',
      );
      await tester.tap(find.text('Выберите категорию'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Грузчик'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Оплатить и опубликовать'));
      await tester.pumpAndSettle();

      // Без оплаты смена не публикуется: сначала окно карты.
      expect(find.text('Оплата смены'), findsOneWidget);
      expect(find.text('Комиссия сервиса 4%'), findsWidgets);
      await tester.tap(find.text('Подставить тестовую карту'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Оплатить ').last);
      await tester.pumpAndSettle();

      // Вернулись на список — смена там, и с категорией.
      expect(find.text('Услуги грузчика'), findsOneWidget);
      expect(find.text('0 / 3'), findsOneWidget);
      expect((await shifts.shiftsCreatedBy(1)).single.category, 'loader');
    });

    testWidgets('без категории смену не опубликовать', (tester) async {
      await openApp(tester, role: UserRole.manager);

      await tester.tap(find.text('Создать'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Услуги грузчика');
      await tester.enterText(find.byType(TextField).at(1), 'ул. Абая, 10');
      await tester.tap(find.text('Оплатить и опубликовать'));
      await tester.pumpAndSettle();

      expect(find.text('Выберите категорию работ'), findsOneWidget);
    });

    testWidgets('категорию можно найти поиском', (tester) async {
      await openApp(tester, role: UserRole.manager);

      await tester.tap(find.text('Создать'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Выберите категорию'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'сант');
      await tester.pumpAndSettle();

      expect(find.text('Сантехник'), findsOneWidget);
      expect(find.text('Грузчик'), findsNothing);
    });

    testWidgets('пустой адрес не даёт опубликовать смену', (tester) async {
      await openApp(tester, role: UserRole.manager);

      await tester.tap(find.text('Создать'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).at(0),
        'Услуги грузчика',
      );
      await tester.tap(find.text('Оплатить и опубликовать'));
      await tester.pumpAndSettle();

      expect(find.text('Укажите адрес'), findsOneWidget);
    });
  });

  group('документы и поддержка', () {
    testWidgets('загруженный документ уходит на проверку', (tester) async {
      await openApp(tester);

      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Документы'));
      await tester.pumpAndSettle();

      expect(find.text('Удостоверение личности'), findsOneWidget);
      expect(find.text('Не загружен'), findsNWidgets(2));

      await tester.tap(find.text('Загрузить').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, '123456789');
      await tester.tap(find.text('Отправить'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('На проверке'), findsOneWidget);

      // Через пару секунд оператор «проверяет» документ.
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('Принят'), findsOneWidget);
    });

    testWidgets('обращение в поддержку создаётся и открывается',
        (tester) async {
      await openApp(tester);

      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Поддержка'));
      await tester.pumpAndSettle();

      expect(find.text('Обращений пока нет'), findsOneWidget);

      await tester.tap(find.text('Написать'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'Нет выплаты');
      await tester.enterText(
        find.byType(TextField).at(1),
        'Отработал смену, деньги не пришли',
      );
      await tester.tap(find.text('Отправить'));
      await tester.pumpAndSettle();

      expect(find.text('Нет выплаты'), findsOneWidget);

      // Открываем переписку и пишем ещё одно сообщение.
      await tester.tap(find.text('Нет выплаты'));
      await tester.pumpAndSettle();
      expect(find.text('Отработал смену, деньги не пришли'), findsOneWidget);

      await tester.enterText(find.byType(TextField).last, 'Есть новости?');
      await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Есть новости?'), findsOneWidget);
    });
  });

  /// Прошедшая смена нашего заказчика, на которой человек отработал:
  /// записался и выход подтверждён. Только такую и можно оценить.
  Future<FakeShiftRepository> managerRepo() async {
    final now = DateTime.now();
    final repo = FakeShiftRepository(
      shifts: [
        Shift(
          id: 1,
          workDate: DateTime(now.year, now.month, now.day - 2),
          title: 'Услуги фасовщика',
          company: 'Magnum',
          address: 'г. Алматы, ул. Абая, 1',
          startMinutes: 600,
          endMinutes: 1200,
          hourlyRate: 100000,
          workersNeeded: 2,
          workersHired: 1,
          createdBy: 1,
        ),
      ],
    );
    await repo.apply(1);
    await repo.confirmAttendance(shiftId: 1, workerId: 1);
    return repo;
  }

  /// Смена, которая идёт прямо сейчас, — чтобы отметка была доступна
  /// независимо от того, в котором часу запустили тест.
  FakeShiftRepository shiftRunningNow() {
    final now = DateTime.now();
    return FakeShiftRepository(
      userRating: 5.0,
      shifts: [
        Shift(
          id: 1,
          workDate: DateTime(now.year, now.month, now.day),
          title: 'Услуги фасовщика',
          company: 'Magnum',
          address: 'г. Алматы, ул. Абая, 1',
          startMinutes: now.hour * 60 + now.minute,
          endMinutes: 1439,
          hourlyRate: 100000,
          workersNeeded: 3,
          workersHired: 0,
        ),
      ],
    );
  }

  group('выход на смену', () {
    testWidgets('в день смены появляется отметка «Я на месте»',
        (tester) async {
      final repo = shiftRunningNow();
      await repo.apply(1);
      await openApp(tester, rating: 5.0, shifts: repo);

      await tester.tap(find.text('Подробнее').first);
      await tester.pumpAndSettle();

      expect(find.text('Я на месте'), findsOneWidget);

      await tester.tap(find.text('Я на месте'));
      await tester.pumpAndSettle();

      expect(find.text('Вы отметились — ждём подтверждения'), findsOneWidget);
    });

    testWidgets('до дня смены отметки нет', (tester) async {
      // Смена №5 — через три дня, отметиться нельзя.
      final repo = FakeShiftRepository(userRating: 5.0);
      await repo.apply(5);
      await openApp(tester, rating: 5.0, shifts: repo);

      await tester.tap(find.text('чт').first);
      await tester.pumpAndSettle();

      expect(find.text('Я на месте'), findsNothing);
    });

    testWidgets('заказчик подтверждает выход', (tester) async {
      final now = DateTime.now();
      final repo = FakeShiftRepository(
        userRating: 5.0,
        shifts: [
          Shift(
            id: 1,
            workDate: DateTime(now.year, now.month, now.day),
            title: 'Услуги фасовщика',
            company: 'Magnum',
            address: 'г. Алматы, ул. Абая, 1',
            startMinutes: now.hour * 60 + now.minute,
            endMinutes: 1439,
            hourlyRate: 100000,
            workersNeeded: 3,
            workersHired: 0,
            createdBy: 1,
          ),
        ],
      );
      await repo.apply(1);
      await repo.checkIn(1);

      await openApp(
        tester,
        role: UserRole.manager,
        repos: buildRepos(
          shifts: repo,
          signedIn: testUser(role: UserRole.manager),
        ),
      );

      await tester.tap(find.text('Услуги фасовщика'));
      await tester.pumpAndSettle();

      expect(find.text('На месте'), findsOneWidget);
      await tester.tap(find.text('Вышел'));
      await tester.pumpAndSettle();

      expect(find.text('Отработал'), findsOneWidget);
      expect(find.text('Вышел'), findsNothing);
    });

    testWidgets('заказчик отмечает невыход, но сначала его переспросят',
        (tester) async {
      final now = DateTime.now();
      final repo = FakeShiftRepository(
        userRating: 5.0,
        shifts: [
          Shift(
            id: 1,
            workDate: DateTime(now.year, now.month, now.day),
            title: 'Услуги фасовщика',
            company: 'Magnum',
            address: 'г. Алматы, ул. Абая, 1',
            startMinutes: now.hour * 60 + now.minute,
            endMinutes: 1439,
            hourlyRate: 100000,
            workersNeeded: 3,
            workersHired: 0,
            createdBy: 1,
          ),
        ],
      );
      await repo.apply(1);

      await openApp(
        tester,
        role: UserRole.manager,
        repos: buildRepos(
          shifts: repo,
          signedIn: testUser(role: UserRole.manager),
        ),
      );

      await tester.tap(find.text('Услуги фасовщика'));
      await tester.pumpAndSettle();

      // Человек не отмечался — но засчитать выход всё равно можно:
      // отметка добровольная, а работал он или нет, знает заказчик.
      expect(find.text('Вышел'), findsOneWidget);

      await tester.tap(find.text('Не вышел'));
      await tester.pumpAndSettle();
      expect(find.text('Отметить невыход?'), findsOneWidget);

      // Передумал — ничего не произошло.
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(find.text('Не вышел'), findsOneWidget);

      // А теперь подтверждаем.
      await tester.tap(find.text('Не вышел'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Не вышел'));
      await tester.pumpAndSettle();

      expect(find.text('Не вышел'), findsOneWidget); // это уже ярлык
      expect(find.text('Вышел'), findsNothing);
    });

    testWidgets('до начала смены отмечать нечего', (tester) async {
      final now = DateTime.now().add(const Duration(days: 1));
      final repo = FakeShiftRepository(
        userRating: 5.0,
        shifts: [
          Shift(
            id: 1,
            workDate: DateTime(now.year, now.month, now.day),
            title: 'Завтрашняя смена',
            company: 'Magnum',
            address: 'г. Алматы, ул. Абая, 1',
            startMinutes: 600,
            endMinutes: 1200,
            hourlyRate: 100000,
            workersNeeded: 3,
            workersHired: 0,
            createdBy: 1,
          ),
        ],
      );
      await repo.apply(1);

      await openApp(
        tester,
        role: UserRole.manager,
        repos: buildRepos(
          shifts: repo,
          signedIn: testUser(role: UserRole.manager),
        ),
      );

      await tester.tap(find.text('Завтрашняя смена'));
      await tester.pumpAndSettle();

      expect(find.text('Вышел'), findsNothing);
      expect(find.text('Не вышел'), findsNothing);
    });
  });

  group('город', () {
    testWidgets('лента показывает только смены своего города',
        (tester) async {
      final now = DateTime.now();
      final repo = FakeShiftRepository(
        city: 'Астана',
        shifts: [
          Shift(
            id: 1,
            workDate: DateTime(now.year, now.month, now.day),
            title: 'Смена в Алматы',
            company: 'Magnum',
            address: 'г. Алматы, ул. Абая, 1',
            city: 'Алматы',
            startMinutes: 600,
            endMinutes: 1200,
            hourlyRate: 100000,
            workersNeeded: 3,
            workersHired: 0,
          ),
          Shift(
            id: 2,
            workDate: DateTime(now.year, now.month, now.day),
            title: 'Смена в Астане',
            company: 'Small',
            address: 'г. Астана, ул. Кенесары, 1',
            city: 'Астана',
            startMinutes: 600,
            endMinutes: 1200,
            hourlyRate: 100000,
            workersNeeded: 3,
            workersHired: 0,
          ),
        ],
      );

      await openApp(tester, shifts: repo);

      expect(find.text('Смена в Астане'), findsOneWidget);
      expect(find.text('Смена в Алматы'), findsNothing);
    });
  });

  group('поиск', () {
    FakeShiftRepository twoShifts() {
      final now = DateTime.now();
      Shift make(int id, String title, String company, String address) => Shift(
            id: id,
            workDate: DateTime(now.year, now.month, now.day),
            title: title,
            company: company,
            address: address,
            city: 'Алматы',
            startMinutes: 600,
            endMinutes: 1200,
            hourlyRate: 100000,
            workersNeeded: 3,
            workersHired: 0,
          );

      return FakeShiftRepository(shifts: [
        make(1, 'Услуги грузчика', 'Magnum', 'г. Алматы, ул. Абая, 1'),
        make(2, 'Услуги повара', 'Small', 'г. Алматы, ул. Сатпаева, 9'),
      ]);
    }

    testWidgets('находит по названию', (tester) async {
      await openApp(tester, shifts: twoShifts());

      await tester.enterText(find.byType(TextField).first, 'повар');
      // Поиск отложенный — надо дождаться, пока он сработает.
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('Услуги повара'), findsOneWidget);
      expect(find.text('Услуги грузчика'), findsNothing);
    });

    testWidgets('находит по компании и по адресу', (tester) async {
      await openApp(tester, shifts: twoShifts());

      await tester.enterText(find.byType(TextField).first, 'magnum');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('Услуги грузчика'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'сатпаева');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('Услуги повара'), findsOneWidget);
    });

    testWidgets('по пустому запросу ничего не найдено — с объяснением',
        (tester) async {
      await openApp(tester, shifts: twoShifts());

      await tester.enterText(find.byType(TextField).first, 'сварщик');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('По запросу ничего нет'), findsOneWidget);
    });

    testWidgets('крестик возвращает весь список', (tester) async {
      await openApp(tester, shifts: twoShifts());

      await tester.enterText(find.byType(TextField).first, 'повар');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('Услуги грузчика'), findsNothing);

      await tester.tap(find.byTooltip('Очистить'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('Услуги грузчика'), findsOneWidget);
      expect(find.text('Услуги повара'), findsOneWidget);
    });
  });

  group('смены заказчика: правка и отмена', () {
    Shift todayShift({int hired = 0}) {
      final now = DateTime.now();
      return Shift(
        id: 1,
        workDate: DateTime(now.year, now.month, now.day),
        title: 'Услуги грузчика',
        company: 'Magnum',
        address: 'г. Алматы, ул. Абая, 1',
        city: 'Алматы',
        startMinutes: 600,
        endMinutes: 1200,
        hourlyRate: 100000,
        workersNeeded: 3,
        workersHired: hired,
        createdBy: 1,
      );
    }

    testWidgets('у своей смены есть кнопка «Отменить»', (tester) async {
      final repo = FakeShiftRepository(shifts: [todayShift()]);
      await openApp(tester, role: UserRole.manager, shifts: repo);

      expect(find.text('Отменить'), findsOneWidget);
    });

    testWidgets('перед отменой спрашивают подтверждение', (tester) async {
      final repo = FakeShiftRepository(shifts: [todayShift()]);
      await openApp(tester, role: UserRole.manager, shifts: repo);

      await tester.tap(find.text('Отменить'));
      await tester.pumpAndSettle();

      expect(find.text('Отменить смену?'), findsOneWidget);

      // Передумал — смена остаётся.
      await tester.tap(find.text('Нет'));
      await tester.pumpAndSettle();
      expect(await repo.shiftById(1), isNotNull);
      expect((await repo.shiftById(1))!.isCancelled, isFalse);
    });

    testWidgets('после подтверждения смена помечается отменённой',
        (tester) async {
      final repo = FakeShiftRepository(shifts: [todayShift()]);
      await openApp(tester, role: UserRole.manager, shifts: repo);

      await tester.tap(find.text('Отменить'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Отменить смену'));
      await tester.pumpAndSettle();

      expect(find.text('Отменена'), findsOneWidget);
      expect((await repo.shiftById(1))!.isCancelled, isTrue);
    });

    testWidgets('«Изменить» открывает форму с заполненными полями',
        (tester) async {
      final repo = FakeShiftRepository(shifts: [todayShift()]);
      await openApp(tester, role: UserRole.manager, shifts: repo);

      await tester.tap(find.text('Изменить'));
      await tester.pumpAndSettle();

      expect(find.text('Изменить смену'), findsOneWidget);
      // Поля не пустые — это правка, а не новая смена.
      expect(find.text('Услуги грузчика'), findsWidgets);
      expect(find.text('Сохранить'), findsOneWidget);
    });

    testWidgets('правка сохраняется', (tester) async {
      final repo = FakeShiftRepository(shifts: [todayShift()]);
      await openApp(tester, role: UserRole.manager, shifts: repo);

      await tester.tap(find.text('Изменить'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Услуги повара');
      await tester.tap(find.text('Сохранить'));
      await tester.pumpAndSettle();

      expect((await repo.shiftById(1))!.title, 'Услуги повара');
    });

    testWidgets('нельзя оставить мест меньше, чем набрано', (tester) async {
      // На смену уже набрали двоих.
      final repo = FakeShiftRepository(shifts: [todayShift(hired: 2)]);

      await openApp(tester, role: UserRole.manager, shifts: repo);
      await tester.tap(find.text('Изменить'));
      await tester.pumpAndSettle();

      // Поле «сколько человек» — четвёртое по счёту на форме.
      await tester.enterText(find.byType(TextField).at(3), '1');
      await tester.tap(find.text('Сохранить'));
      await tester.pumpAndSettle();

      expect(find.textContaining('мест не может быть меньше'), findsOneWidget);
      // И смена осталась нетронутой.
      expect((await repo.shiftById(1))!.workersNeeded, 3);
    });

    testWidgets('отменённая смена исчезает из ленты исполнителя',
        (tester) async {
      final repo = FakeShiftRepository(shifts: [todayShift()]);
      await repo.cancelShift(1);

      await openApp(tester, shifts: repo);

      expect(find.text('Услуги грузчика'), findsNothing);
    });
  });

  group('уведомления', () {
    AppNotification note({
      int id = 1,
      NotificationKind kind = NotificationKind.applied,
      String title = 'Новая запись на смену',
      DateTime? readAt,
      int? shiftId,
    }) =>
        AppNotification(
          id: id,
          kind: kind,
          title: title,
          body: 'Азамат записался на «Услуги грузчика» 12 сентября.',
          shiftId: shiftId,
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          readAt: readAt,
        );

    testWidgets('без уведомлений на колокольчике нет числа', (tester) async {
      await openApp(tester);

      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('непрочитанные показываются числом', (tester) async {
      final repo = FakeShiftRepository()
        ..pushNotification(note(id: 1))
        ..pushNotification(note(id: 2, kind: NotificationKind.rated));

      await openApp(tester, shifts: repo);

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('колокольчик открывает список', (tester) async {
      final repo = FakeShiftRepository()..pushNotification(note());

      await openApp(tester, shifts: repo);
      await tester.tap(find.byTooltip('Уведомления'));
      await tester.pumpAndSettle();

      expect(find.text('Уведомления'), findsOneWidget);
      expect(find.text('Новая запись на смену'), findsOneWidget);
    });

    testWidgets('после просмотра число пропадает', (tester) async {
      final repo = FakeShiftRepository()..pushNotification(note());

      await openApp(tester, shifts: repo);
      expect(find.text('1'), findsOneWidget);

      await tester.tap(find.byTooltip('Уведомления'));
      await tester.pumpAndSettle();
      // Приложение по-русски, и подсказка у кнопки «назад» тоже.
      await tester.tap(find.byTooltip('Назад'));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsNothing);
    });

    testWidgets('пустой список объясняет, что здесь будет', (tester) async {
      await openApp(tester);
      await tester.tap(find.byTooltip('Уведомления'));
      await tester.pumpAndSettle();

      expect(find.text('Уведомлений нет'), findsOneWidget);
    });
  });

  group('оценки исполнителей', () {
    testWidgets('заказчик видит, кого нужно оценить', (tester) async {
      await openApp(
        tester,
        role: UserRole.manager,
        repos: buildRepos(
          shifts: await managerRepo(),
          signedIn: testUser(role: UserRole.manager),
        ),
      );

      await tester.tap(find.text('Оценки'));
      await tester.pumpAndSettle();

      expect(find.text('Ернар Калдыбеков'), findsOneWidget);
      expect(find.text('Оценить'), findsOneWidget);
    });

    testWidgets('после оценки список пустеет', (tester) async {
      final shifts = await managerRepo();
      await openApp(
        tester,
        role: UserRole.manager,
        repos: buildRepos(
          shifts: shifts,
          signedIn: testUser(role: UserRole.manager),
        ),
      );

      await tester.tap(find.text('Оценки'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ернар Калдыбеков'));
      await tester.pumpAndSettle();
      expect(find.text('Оцените исполнителя'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.star_outline_rounded).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Поставить оценку'));
      await tester.pumpAndSettle();

      expect(find.text('Все оценены'), findsOneWidget);

      // И оценка действительно записана.
      final received = await shifts.reviewsAbout(1);
      expect(received, hasLength(1));
      expect(received.first.rating, 5);
    });

    testWidgets('без оценок исполнитель видит пустой экран отзывов',
        (tester) async {
      await openApp(tester);

      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Отзывы обо мне'));
      await tester.pumpAndSettle();

      expect(find.text('Отзывов пока нет'), findsOneWidget);
    });

    testWidgets('полученный отзыв виден исполнителю', (tester) async {
      final shifts = await managerRepo();
      await shifts.rateWorker(
        shiftId: 1,
        workerId: 1,
        rating: 4,
        comment: 'Работал аккуратно',
      );

      await openApp(
        tester,
        repos: buildRepos(shifts: shifts, signedIn: testUser()),
      );

      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Отзывы обо мне'));
      await tester.pumpAndSettle();

      expect(find.text('Работал аккуратно'), findsOneWidget);
      // Средняя оценка посчитана из самих отзывов.
      expect(find.text('4.0'), findsOneWidget);
    });

    testWidgets('пока оценок нет, рейтинг подписан как стартовый',
        (tester) async {
      await openApp(tester);

      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();

      expect(find.text('Стартовый'), findsOneWidget);
    });
  });

  group('сбои и загрузка', () {
    testWidgets('пока данные едут, видно скелет, а не пустоту',
        (tester) async {
      useTallPhone(tester);
      final slow = SlowShiftRepository();
      final user = testUser();
      final session = AppSession()..setUser(user);

      await tester.pumpWidget(FastworkApp(
        session: session,
        repos: buildRepos(shifts: slow, signedIn: user),
      ));
      // Один кадр — ответа ещё нет.
      await tester.pump();

      expect(find.byType(ShiftListSkeleton), findsOneWidget);
      expect(find.text('Подробнее'), findsNothing);

      // «Ответ пришёл».
      slow.release();
      await tester.pumpAndSettle();

      expect(find.byType(ShiftListSkeleton), findsNothing);
      expect(find.text('Подробнее'), findsWidgets);
    });

    testWidgets('сбой хранилища показывает ошибку и кнопку повтора',
        (tester) async {
      final broken = BrokenShiftRepository();
      await openApp(
        tester,
        repos: buildRepos(shifts: broken, signedIn: testUser()),
      );

      expect(find.text('Не получилось загрузить'), findsOneWidget);
      expect(
        find.text('Нет связи с сервером. Проверьте интернет и попробуйте снова.'),
        findsOneWidget,
      );
      expect(find.text('Повторить'), findsOneWidget);
    });

    testWidgets('повтор после починки показывает смены', (tester) async {
      final broken = BrokenShiftRepository();
      await openApp(
        tester,
        repos: buildRepos(shifts: broken, signedIn: testUser()),
      );

      // «Сеть починилась» — и кнопка повтора действительно перезагружает.
      broken.working = true;
      await tester.tap(find.text('Повторить'));
      await tester.pumpAndSettle();

      expect(find.text('Не получилось загрузить'), findsNothing);
      expect(find.text('Подробнее'), findsWidgets);
    });
  });

  group('профиль', () {
    testWidgets('показывает данные пользователя', (tester) async {
      await openApp(tester);

      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();

      expect(find.text('Ернар Калдыбеков'), findsOneWidget);
      expect(find.text('4.0'), findsOneWidget); // рейтинг
      expect(find.text('Новичок'), findsOneWidget); // уровень
      expect(find.text('Алматы'), findsOneWidget); // город
    });

    testWidgets('выход возвращает на экран входа', (tester) async {
      await openApp(tester);

      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Выйти из аккаунта'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Выйти'));
      await tester.pumpAndSettle();

      expect(find.text('Начать работать'), findsOneWidget);
    });
  });
}

/// Хранилище, которое ломается — чтобы проверить экран ошибки.
///
/// Так тестируют сбои: не ждут настоящего обрыва сети, а подсовывают
/// приложению хранилище, которое гарантированно падает. Ещё одна причина,
/// по которой экраны работают с интерфейсом, а не с конкретной базой.
class BrokenShiftRepository extends FakeShiftRepository {
  bool working = false;

  @override
  Future<List<Shift>> shiftsOn(
    DateTime date, {
    ShiftFilter filter = const ShiftFilter(),
  }) {
    if (!working) {
      throw const SocketException('Failed host lookup: api.fastwork.kz');
    }
    return super.shiftsOn(date, filter: filter);
  }
}

/// Хранилище, которое отвечает не сразу — чтобы поймать момент загрузки.
///
/// Обычные фейки отвечают мгновенно, и экран «грузим» промелькивает за
/// доли кадра: проверить его нечем. Здесь ответ висит, пока тест сам не
/// разрешит его отдать.
class SlowShiftRepository extends FakeShiftRepository {
  final _gate = Completer<void>();

  void release() => _gate.complete();

  @override
  Future<List<Shift>> shiftsOn(
    DateTime date, {
    ShiftFilter filter = const ShiftFilter(),
  }) async {
    await _gate.future;
    return super.shiftsOn(date, filter: filter);
  }
}

/// Те же хранилища, но с другим входом — для тестов про вход.
extension on AppRepositories {
  AppRepositories withAuth(AuthRepository auth) => AppRepositories(
        shifts: shifts,
        auth: auth,
        documents: documents,
        support: support,
        wallet: wallet,
      );
}
