import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork/main.dart';

/// Проверяем, что нажатие на карточку действительно открывает экран
/// «Подробнее». Такой тест запускает настоящие виджеты — как будто
/// пользователь тыкает пальцем, только очень быстро.
void main() {
  testWidgets('нажатие на «Подробнее» открывает экран смены', (tester) async {
    await tester.pumpWidget(const FastworkApp());

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
    await tester.pumpWidget(const FastworkApp());

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
}
