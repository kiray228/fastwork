import 'package:fastwork/theme/app_theme.dart';
import 'package:fastwork/theme/glass.dart';
import 'package:fastwork/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// «Жидкое стекло»: карточки размывают фон, а фон у экрана свой.
void main() {
  Future<void> pump(WidgetTester tester, ThemeData theme) =>
      tester.pumpWidget(MaterialApp(
        theme: theme,
        home: const LiquidBackground(
          child: Scaffold(
            body: SurfaceCard(child: Text('Смена')),
          ),
        ),
      ));

  testWidgets('карточка — это стекло: размытие фона под ней', (tester) async {
    await pump(tester, AppTheme.light());

    expect(find.text('Смена'), findsOneWidget);
    expect(find.byType(Glass), findsOneWidget);
    expect(find.byType(BackdropFilter), findsOneWidget);
  });

  testWidgets('все стёкла экрана размывают фон одной группой', (tester) async {
    await pump(tester, AppTheme.light());

    // Без общей группы каждая карточка размывала бы фон отдельно.
    expect(
      find.ancestor(
        of: find.byType(BackdropFilter),
        matching: find.byType(BackdropGroup),
      ),
      findsOneWidget,
    );
  });

  testWidgets('экраны прозрачные — иначе фон под стеклом не виден',
      (tester) async {
    expect(AppTheme.light().scaffoldBackgroundColor, Colors.transparent);
    expect(AppTheme.dark().scaffoldBackgroundColor, Colors.transparent);
  });

  testWidgets('в тёмной теме стекло тёмное, в светлой — светлое',
      (tester) async {
    late GlassTokens light;
    late GlassTokens dark;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light(),
      home: Builder(builder: (c) {
        light = GlassTokens.of(c);
        return const SizedBox();
      }),
    ));
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark(),
      home: Builder(builder: (c) {
        dark = GlassTokens.of(c);
        return const SizedBox();
      }),
    ));
    // Смена темы плавная — дожидаемся, пока она доиграет.
    await tester.pumpAndSettle();

    expect(light.strongFill.computeLuminance(),
        greaterThan(dark.strongFill.computeLuminance()));
  });
}
