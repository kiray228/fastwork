import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fastwork/data/app_preferences.dart';
import 'package:fastwork/data/repositories.dart';
import 'package:fastwork/data/session.dart';
import 'package:fastwork/main.dart';
import 'package:fastwork/stories/story.dart';
import 'package:fastwork/stories/story_content.dart';
import 'package:fastwork/stories/story_viewer.dart';
import 'package:fastwork/theme/app_theme.dart';
import 'package:fastwork/widgets/stories_row.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/fake_shift_repository.dart';
import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_core/user.dart';

/// Истории: что в них, как их листают, куда ведут кнопки — и всё, что
/// появилось на главном экране вместе с ними.
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

  AppRepositories buildRepos(FakeShiftRepository shifts, AppUser user) =>
      AppRepositories(
        shifts: shifts,
        auth: FakeAuthRepository(signedIn: user),
        documents: FakeDocumentRepository(),
        support: FakeSupportRepository(),
        wallet: FakeWalletRepository(shifts),
      );

  void usePhone(WidgetTester tester, {Size size = const Size(420, 2200)}) {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);
  }

  Future<AppPreferences> openApp(
    WidgetTester tester, {
    String role = UserRole.worker,
    FakeShiftRepository? shifts,
  }) async {
    usePhone(tester);
    final user = testUser(role: role);
    final preferences = AppPreferences();
    await tester.pumpWidget(FastworkApp(
      session: AppSession()..setUser(user),
      repos: buildRepos(shifts ?? FakeShiftRepository(), user),
      preferences: preferences,
    ));
    await tester.pumpAndSettle();
    return preferences;
  }

  /// Пока история открыта, таймер слайда идёт, и экран «не успокаивается».
  /// Поэтому здесь не `pumpAndSettle`, а шаги по времени.
  Future<void> step(WidgetTester tester, [int ms = 700]) async {
    for (var i = 0; i < ms ~/ 100; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  /// Открыть историю кружком из ленты. Кружки листаются вбок, и дальние
  /// сначала нужно докрутить до экрана.
  Future<void> openStory(WidgetTester tester, String title) async {
    await tester.scrollUntilVisible(
      find.text(title),
      80,
      scrollable: find.descendant(
        of: find.byType(StoriesRow),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(title));
    await step(tester);
  }

  /// Касание правой части экрана — следующий слайд.
  Future<void> tapNext(WidgetTester tester) async {
    final size = tester.view.physicalSize / tester.view.devicePixelRatio;
    await tester.tapAt(Offset(size.width * 0.8, size.height * 0.45));
    await step(tester);
  }

  Future<void> tapBack(WidgetTester tester) async {
    final size = tester.view.physicalSize / tester.view.devicePixelRatio;
    await tester.tapAt(Offset(size.width * 0.1, size.height * 0.45));
    await step(tester);
  }

  group('содержание', () {
    final all = [...workerStories(), ...managerStories()];

    test('у каждой истории свой ключ, и в нём есть версия', () {
      final ids = all.map((s) => s.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
      for (final id in ids) {
        expect(id, matches(RegExp(r'^[a-z.]+\.\d+$')), reason: id);
      }
    });

    test('в каждой истории есть слайды, у кнопок есть подписи', () {
      for (final story in all) {
        expect(story.slides, isNotEmpty, reason: story.title);
        for (final slide in story.slides) {
          if (slide.action != null) {
            expect(slide.actionLabel, isNotNull, reason: slide.title);
          }
        }
      }
    });

    test('слайд показывается столько, сколько нужно на чтение', () {
      for (final slide in all.expand((s) => s.slides)) {
        expect(slide.duration.inMilliseconds, inInclusiveRange(5500, 12000));
      }
      // Длинный текст висит дольше короткого.
      const short = StorySlide(title: 'А', body: 'Б', visual: _empty);
      final long = StorySlide(title: 'А', body: 'Б' * 150, visual: _empty);
      expect(long.duration, greaterThan(short.duration));
    });

    test('у заказчика свои истории — про найм, а не про выплаты', () {
      expect(managerStories().map((s) => s.title), contains('Как нанять'));
      expect(workerStories().map((s) => s.title), contains('Выплаты'));
      expect(
        managerStories().map((s) => s.title),
        isNot(contains('Медкнижка')),
      );
    });
  });

  group('настройки телефона', () {
    test('без хранилища всё живёт в памяти', () async {
      final prefs = AppPreferences();
      var changes = 0;
      prefs.addListener(() => changes++);

      expect(prefs.isStorySeen('payouts.1'), isFalse);
      await prefs.markStorySeen('payouts.1');
      await prefs.markStorySeen('payouts.1'); // второй раз — не новость
      expect(prefs.isStorySeen('payouts.1'), isTrue);
      expect(changes, 1);
    });

    test('просмотренное и тема переживают перезапуск', () async {
      SharedPreferences.setMockInitialValues({});
      final first = await AppPreferences.open();
      await first.markStorySeen('limit.1');
      await first.setThemeMode(ThemeMode.dark);

      final second = await AppPreferences.open();
      expect(second.isStorySeen('limit.1'), isTrue);
      expect(second.isStorySeen('limit.2'), isFalse,
          reason: 'новая версия истории — снова новая');
      expect(second.themeMode, ThemeMode.dark);
    });
  });

  group('просмотр', () {
    testWidgets('кружок открывает историю, касания листают слайды',
        (tester) async {
      await openApp(tester);

      await openStory(tester, 'Выплаты');
      expect(find.text('Путь денег'), findsOneWidget);
      expect(find.text('fastwork · 1 из 4'), findsOneWidget);

      await tapNext(tester);
      expect(find.text('Вы получаете всю сумму'), findsOneWidget);

      await tapBack(tester);
      expect(find.text('Путь денег'), findsOneWidget);

      await tester.tap(find.byTooltip('Закрыть'));
      await tester.pumpAndSettle();
      expect(find.text('Путь денег'), findsNothing);
    });

    testWidgets('слайды листаются сами, а после последней истории — закрытие',
        (tester) async {
      await openApp(tester);
      final support = workerStories().last;

      await openStory(tester, support.title);
      expect(find.text(support.slides[0].title), findsOneWidget);

      await tester.pump(support.slides[0].duration);
      await step(tester);
      expect(find.text(support.slides[1].title), findsOneWidget);

      // Последний слайд последней истории — дальше некуда, история
      // закрывается сама.
      await tester.pump(support.slides[1].duration);
      await tester.pumpAndSettle();
      expect(find.text(support.slides[1].title), findsNothing);
      expect(find.text('Поддержка'), findsOneWidget); // снова лента
    });

    testWidgets('палец на экране ставит историю на паузу', (tester) async {
      await openApp(tester);
      final payouts = workerStories()[1];

      await openStory(tester, payouts.title);
      final gesture = await tester.startGesture(const Offset(300, 500));
      await step(tester, 800); // дольше, чем нужно для долгого нажатия
      await tester.pump(payouts.slides[0].duration);
      await step(tester);
      expect(find.text(payouts.slides[0].title), findsOneWidget,
          reason: 'пока палец на экране, слайд не меняется');
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);

      await gesture.up();
      // Первый кадр после отпускания только заводит таймер — время
      // слайда отсчитывается с него.
      await tester.pump();
      await tester.pump(payouts.slides[0].duration);
      await step(tester);
      expect(find.text(payouts.slides[1].title), findsOneWidget,
          reason: 'отпустили — история пошла дальше');
    });

    testWidgets('в конце истории начинается следующая', (tester) async {
      await openApp(tester);
      final stories = workerStories();
      final how = stories.first;

      await openStory(tester, how.title);
      for (var i = 1; i < how.slides.length; i++) {
        await tapNext(tester);
      }
      await tapNext(tester);

      expect(find.text(stories[1].slides.first.title), findsOneWidget);
    });

    testWidgets('посмотренная история помечается', (tester) async {
      final prefs = await openApp(tester);
      final handle = tester.ensureSemantics();

      expect(find.bySemanticsLabel('Новая история «Лимит»'), findsOneWidget);

      await openStory(tester, 'Лимит');
      await tester.tap(find.byTooltip('Закрыть'));
      await tester.pumpAndSettle();

      expect(prefs.isStorySeen('limit.1'), isTrue);
      expect(find.bySemanticsLabel('История «Лимит»'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('кнопка внизу слайда ведёт на нужный экран', (tester) async {
      await openApp(tester);

      await openStory(tester, 'Выплаты');
      for (var i = 0; i < 3; i++) {
        await tapNext(tester);
      }
      expect(find.text('Вывод на карту'), findsOneWidget);

      await tester.tap(find.text('Открыть выплаты'));
      await tester.pumpAndSettle();

      expect(find.text('Доступно к выводу'), findsOneWidget);
    });

    testWidgets('лимит в истории — настоящий, из хранилища', (tester) async {
      await openApp(tester);

      await openStory(tester, 'Лимит');
      await tapNext(tester);
      await tapNext(tester);

      expect(find.text('Ваш месяц'), findsOneWidget);
      expect(find.text('Осталось'), findsOneWidget);
      expect(find.text('Смотреть в «Выплатах»'), findsOneWidget);
    });

    testWidgets('у заказчика «Создать смену» из истории открывает форму',
        (tester) async {
      await openApp(tester, role: UserRole.manager);

      await openStory(tester, 'Как нанять');
      expect(find.text('Пять шагов'), findsOneWidget);

      await tapNext(tester);
      await tester.tap(find.text('Создать смену').last);
      await tester.pumpAndSettle();

      expect(find.text('Новая смена'), findsOneWidget);
    });

    // Инфографика не должна вылезать за экран даже на самом маленьком
    // айфоне. Переполнение Flutter считает ошибкой — и тест упадёт.
    for (final (name, stories) in [
      ('исполнителя', workerStories()),
      ('заказчика', managerStories()),
    ]) {
      testWidgets('все слайды $name помещаются на маленький экран',
          (tester) async {
        usePhone(tester, size: const Size(320, 568));
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => showStories(
                    context,
                    stories: stories,
                    data: StoryData(user: testUser(completed: 7)),
                  ),
                  child: const Text('Открыть'),
                ),
              ),
            ),
          ),
        ));
        await tester.tap(find.text('Открыть'));
        await step(tester);

        final slides = stories.expand((s) => s.slides).toList();
        for (var i = 0; i < slides.length; i++) {
          expect(find.text(slides[i].title), findsOneWidget,
              reason: 'слайд ${i + 1}');
          await tapNext(tester);
        }
        await tester.pumpAndSettle();
        expect(find.text('Открыть'), findsOneWidget);
      });
    }
  });
}

Widget _empty(BuildContext context, StoryData data) => const SizedBox();
