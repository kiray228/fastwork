import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork/main.dart';

/// Проверяем, что нажатие на карточку действительно открывает экран
/// «Подробнее». Такой тест запускает настоящие виджеты — как будто
/// пользователь тыкает пальцем, только очень быстро.
void main() {
  /// По умолчанию тестовый «экран» маленький — 800×600, и часть карточек
  /// в него не влезает. А списки во Flutter создают только те элементы,
  /// что видны на экране, — поэтому ненайденная кнопка означала бы не
  /// ошибку, а просто «её ещё не нарисовали».
  /// Задаём размер повыше, чтобы поместились обе карточки.
  void useTallPhone(WidgetTester tester) {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(420, 1800);
    addTearDown(tester.view.reset);
  }

  testWidgets('нажатие на «Подробнее» открывает экран смены', (tester) async {
    useTallPhone(tester);
    await tester.pumpWidget(const FastworkApp());
    await tester.pumpAndSettle();

    // На главном экране есть карточки с кнопкой.
    expect(find.text('Подробнее'), findsWidgets);

    // Нажимаем первую кнопку и ждём, пока проиграется анимация перехода.
    await tester.tap(find.text('Подробнее').first);
    await tester.pumpAndSettle();

    // Оказались на экране смены: видим блок вознаграждения и кнопку заявки.
    expect(find.text('Вознаграждение'), findsOneWidget);
    expect(find.text('Оставить заявку'), findsOneWidget);
  });

  testWidgets('кнопка «Мест нет» не открывает экран смены', (tester) async {
    useTallPhone(tester);
    await tester.pumpWidget(const FastworkApp());
    await tester.pumpAndSettle();

    // У смены Zara мест нет — кнопка неактивна.
    final soldOut = find.widgetWithText(FilledButton, 'Мест нет');
    expect(soldOut, findsOneWidget);

    // warnIfMissed: false — мы специально жмём по выключенной кнопке,
    // и Flutter не должен ругаться, что нажатие «не попало».
    await tester.tap(soldOut, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Никуда не перешли: блока вознаграждения нет.
    expect(find.text('Вознаграждение'), findsNothing);
  });

  testWidgets('выбор дня без смен показывает пустое состояние',
      (tester) async {
    useTallPhone(tester);
    await tester.pumpWidget(const FastworkApp());
    await tester.pumpAndSettle();

    // Послезавтра смен нет — это третья плашка в полосе дат (индекс 2).
    final dayAfterTomorrow = DateTime.now().add(const Duration(days: 2));
    await tester.tap(find.text('${dayAfterTomorrow.day}').first);
    await tester.pumpAndSettle();

    expect(find.text('На этот день смен нет'), findsOneWidget);
  });
}
