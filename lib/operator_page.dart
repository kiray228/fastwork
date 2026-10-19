import 'package:flutter/material.dart';

import 'package:fastwork_core/support.dart';
import 'data/operator_api.dart';
import 'l10n/strings.dart';
import 'theme/app_colors.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';

/// Экран оператора: очередь документов на проверку.
///
/// С сервером документы проверяет оператор, а не приложение (`docs/29`).
/// Делать это из терминала неудобно, поэтому есть экран: открывается по
/// адресу `?operator`, просит служебный ключ и показывает очередь —
/// кто, какой документ, номер и срок, с кнопками «Одобрить» и
/// «Отклонить».
///
/// Ключ живёт только в памяти этого экрана: ни в настройках телефона,
/// ни в браузере его не остаётся.
class OperatorPage extends StatefulWidget {
  final OperatorDocuments documents;

  const OperatorPage({super.key, required this.documents});

  @override
  State<OperatorPage> createState() => _OperatorPageState();
}

class _OperatorPageState extends State<OperatorPage> {
  final keyController = TextEditingController();

  /// Ключ, с которым очередь открылась. null — ещё не открывали.
  String? key;
  Async<List<PendingDocument>>? state;

  /// Документы, по которым уже отправлено решение.
  final busy = <int>{};

  @override
  void dispose() {
    keyController.dispose();
    super.dispose();
  }

  Future<void> _open() async {
    final value = keyController.text.trim();
    if (value.isEmpty) return;
    setState(() => state = const Loading());
    final result = await load(() => widget.documents.pending(value));
    if (!mounted) return;
    setState(() {
      state = result;
      key = result is Ready ? value : null;
    });
  }

  Future<void> _review(PendingDocument doc, {required bool approved}) async {
    final current = key;
    if (current == null) return;
    setState(() => busy.add(doc.id));
    final done = await guardedDone(
      context,
      () => widget.documents.review(current, doc.id, approved: approved),
    );
    if (!mounted) return;
    setState(() {
      busy.remove(doc.id);
      // Решение принято — документ уходит из очереди.
      if (state case Ready(:final value) when done) {
        state = Ready([for (final d in value) if (d.id != doc.id) d]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr.profile.operatorTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (key == null) ..._keyForm(),
          ..._queue(),
        ],
      ),
    );
  }

  List<Widget> _keyForm() => [
        TextField(
          controller: keyController,
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(labelText: tr.profile.operatorKey),
          onSubmitted: (_) => _open(),
        ),
        const SizedBox(height: 8),
        Text(
          tr.profile.operatorKeyHint,
          style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: state is Loading ? null : _open,
          child: Text(tr.profile.operatorOpen),
        ),
        const SizedBox(height: 16),
      ];

  List<Widget> _queue() => switch (state) {
        null => const [],
        Loading() => const [
            Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        Failed(:final error) => [
            Text(
              describeError(error),
              style: const TextStyle(color: AppColors.accent),
            ),
          ],
        Ready(value: []) => [
            EmptyState(
              icon: Icons.task_alt_rounded,
              title: tr.profile.operatorEmpty,
              subtitle: '',
            ),
          ],
        Ready(:final value) => [
            for (final doc in value)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.fullName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        [
                          documentTypes[doc.type] ?? doc.type,
                          doc.number,
                          if (doc.expiresAt != null)
                            tr.profile.operatorValidUntil(
                                tr.core.dayMonth(doc.expiresAt!)),
                        ].join(' · '),
                        style: const TextStyle(color: AppColors.muted),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: busy.contains(doc.id)
                                  ? null
                                  : () => _review(doc, approved: false),
                              child: Text(tr.profile.operatorReject),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton(
                              onPressed: busy.contains(doc.id)
                                  ? null
                                  : () => _review(doc, approved: true),
                              child: Text(tr.profile.operatorApprove),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
      };
}

/// Открыли ли приложение как экран оператора: адрес с `?operator`.
bool isOperatorLink(Uri address) =>
    address.queryParameters.containsKey('operator');
