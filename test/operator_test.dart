import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork/data/api_client.dart';
import 'package:fastwork/data/operator_api.dart';
import 'package:fastwork/operator_page.dart';

/// Очередь в памяти: ключ «secret», два документа.
class _Queue implements OperatorDocuments {
  final docs = [
    PendingDocument(
      id: 1,
      fullName: 'Азамат Серик',
      type: 'medical_book',
      number: 'МК-1',
      expiresAt: DateTime(2027, 3, 1),
    ),
    const PendingDocument(
      id: 2,
      fullName: 'Айгерим Нур',
      type: 'id_card',
      number: '123',
    ),
  ];
  final decisions = <(int, bool)>[];

  void _check(String key) {
    if (key != 'secret') throw ApiException('Нет доступа', 403);
  }

  @override
  Future<List<PendingDocument>> pending(String key) async {
    _check(key);
    return [...docs];
  }

  @override
  Future<void> review(String key, int documentId,
      {required bool approved}) async {
    _check(key);
    decisions.add((documentId, approved));
  }
}

void main() {
  testWidgets('неверный ключ — отказ, верный — очередь и решения',
      (tester) async {
    final queue = _Queue();
    await tester.pumpWidget(MaterialApp(home: OperatorPage(documents: queue)));

    await tester.enterText(find.byType(TextField), 'wrong');
    await tester.tap(find.text('Открыть очередь'));
    await tester.pumpAndSettle();
    expect(find.text('Нет доступа'), findsOneWidget);
    expect(find.text('Азамат Серик'), findsNothing);

    await tester.enterText(find.byType(TextField), 'secret');
    await tester.tap(find.text('Открыть очередь'));
    await tester.pumpAndSettle();
    expect(find.text('Азамат Серик'), findsOneWidget);
    expect(find.textContaining('действует до 1 мар'), findsOneWidget);
    // Ключ принят — поля для него больше нет.
    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.text('Одобрить').first);
    await tester.pumpAndSettle();
    expect(queue.decisions, [(1, true)]);
    expect(find.text('Азамат Серик'), findsNothing);

    await tester.tap(find.text('Отклонить'));
    await tester.pumpAndSettle();
    expect(queue.decisions.last, (2, false));
    expect(find.textContaining('Очередь пуста'), findsOneWidget);
  });

  test('экран оператора — по адресу с ?operator', () {
    expect(
        isOperatorLink(Uri.parse('https://x.kz/fastwork/?operator')), isTrue);
    expect(isOperatorLink(Uri.parse('https://x.kz/fastwork/?shift=1')),
        isFalse);
  });
}
