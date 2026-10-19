import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork/availability_card.dart';
import 'package:fastwork_core/data/fake_shift_repository.dart';

void main() {
  testWidgets('дни отмечаются касанием и сохраняются в хранилище',
      (tester) async {
    final repo = FakeShiftRepository();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: AvailabilityCard(repository: repo)),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Когда вы свободны?'), findsOneWidget);
    expect(find.textContaining('смогут позвать'), findsOneWidget);

    await tester.tap(find.byType(FilterChip).at(1));
    await tester.pumpAndSettle();

    final now = DateTime.now();
    expect(await repo.availability(),
        {DateTime(now.year, now.month, now.day + 1)});
    expect(find.textContaining('Отмечено дней: 1'), findsOneWidget);

    // Второе касание снимает отметку.
    await tester.tap(find.byType(FilterChip).at(1));
    await tester.pumpAndSettle();
    expect(await repo.availability(), isEmpty);
  });
}
