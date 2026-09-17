import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork/main.dart';
import 'package:fastwork/data/fake_shift_repository.dart';

/// Проверяем экраны целиком — как будто пользователь тыкает пальцем,
/// только очень быстро.
///
/// Вместо настоящей базы подставляем данные в памяти. Экраны разницы не
/// замечают: они работают с интерфейсом хранилища, а не с SQLite.
/// Поэтому тесты идут за доли секунды и ничего не пишут на диск.
void main() {
  /// По умолчанию тестовый «экран» маленький — 800×600, и часть карточек
  /// в него не влезает. А списки во Flutter создают только те элементы,
  /// что видны, — поэтому ненайденная кнопка означала бы не ошибку,
  /// а просто «её ещё не нарисовали».
  void useTallPhone(WidgetTester tester) {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(420, 2000);
    addTearDown(tester.view.reset);
  }

  Future<void> openApp(WidgetTester tester) async {
    useTallPhone(tester);
    await tester.pumpWidget(FastworkApp(repository: FakeShiftRepository()));
    await tester.pumpAndSettle();
  }

  testWidgets('нажатие на «Подробнее» открывает экран смены', (tester) async {
    await openApp(tester);

    expect(find.text('Подробнее'), findsWidgets);

    await tester.tap(find.text('Подробнее').first);
    await tester.pumpAndSettle();

    expect(find.text('Вознаграждение'), findsOneWidget);
    expect(find.text('Записаться на смену'), findsOneWidget);
  });

  testWidgets('кнопка «Мест нет» не открывает экран смены', (tester) async {
    await openApp(tester);

    // У смены Zara мест нет — кнопка неактивна.
    final soldOut = find.widgetWithText(FilledButton, 'Мест нет');
    expect(soldOut, findsOneWidget);

    // warnIfMissed: false — мы специально жмём по выключенной кнопке.
    await tester.tap(soldOut, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Вознаграждение'), findsNothing);
  });

  testWidgets('день без смен показывает пустое состояние', (tester) async {
    await openApp(tester);

    // Послезавтра смен нет.
    final dayAfterTomorrow = DateTime.now().add(const Duration(days: 2));
    await tester.tap(find.text('${dayAfterTomorrow.day}').first);
    await tester.pumpAndSettle();

    expect(find.text('На этот день смен нет'), findsOneWidget);
  });

  testWidgets('запись требует подтверждения условий', (tester) async {
    await openApp(tester);

    await tester.tap(find.text('Подробнее').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Записаться на смену'));
    await tester.pumpAndSettle();

    // Открылось окно с условиями.
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

    // Открываем первую смену: 5 мест, 2 заняты — свободно 3.
    await tester.tap(find.text('Подробнее').first);
    await tester.pumpAndSettle();
    expect(find.text('Свободно мест: 3'), findsOneWidget);

    // Записываемся: окно условий, галочка, подтверждение.
    await tester.tap(find.text('Записаться на смену'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Подтверждаю'));
    await tester.pumpAndSettle();

    // Появилась плашка и свободных мест стало меньше.
    expect(find.text('Вы записаны на эту смену'), findsOneWidget);
    expect(find.text('Свободно мест: 2'), findsOneWidget);

    // Смена сегодня, до начала меньше 10 часов — отмена уже недоступна.
    expect(find.text('Отмена уже недоступна'), findsOneWidget);
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

    // Возвращаемся назад и открываем вкладку «Мои».
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Мои'));
    await tester.pumpAndSettle();

    expect(find.text('Мои подработки'), findsOneWidget);
    expect(find.text('Золотое яблоко'), findsOneWidget);

    // В архиве при этом пусто.
    await tester.tap(find.text('Архив'));
    await tester.pumpAndSettle();
    expect(find.text('Пока пусто'), findsOneWidget);
  });
}
