import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fastwork_core/chat.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'l10n/strings.dart';
import 'theme/app_colors.dart';
import 'theme/glass.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';
import 'widgets/skeleton.dart';

/// Переписка исполнителя и заказчика по одной смене.
///
/// Исполнитель открывает её со своей смены — `workerId` не нужен, разговор
/// у него один. Заказчик — из списка записавшихся, и тогда `workerId` —
/// тот, с кем он говорит.
class ChatPage extends StatefulWidget {
  final ShiftRepository repository;
  final int shiftId;

  /// С кем говорит заказчик. null — говорит сам исполнитель.
  final int? workerId;

  /// Подзаголовок: название смены или имя собеседника.
  final String subtitle;

  const ChatPage({
    super.key,
    required this.repository,
    required this.shiftId,
    required this.subtitle,
    this.workerId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();
  Async<List<ShiftMessage>> messages = const Loading();
  bool sending = false;

  /// Пока переписка открыта, она сама спрашивает, нет ли нового. Не
  /// мгновенно, но человеку у входа на склад не нужно жать «обновить»,
  /// чтобы увидеть «вход со двора».
  Timer? poll;
  bool polling = false;

  bool get _isEmployer => widget.workerId != null;

  @override
  void initState() {
    super.initState();
    _load();
    poll = Timer.periodic(const Duration(seconds: 15), (_) => _load());
  }

  @override
  void dispose() {
    poll?.cancel();
    controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (polling) return;
    polling = true;
    try {
      final result = await load(() => widget.repository
          .chatMessages(widget.shiftId, workerId: widget.workerId));
      if (!mounted) return;
      // Сбой фонового опроса не прячет уже показанную переписку.
      if (result is Failed && messages is Ready) return;
      setState(() => messages = result);
    } finally {
      polling = false;
    }
  }

  Future<void> _send([String? quick]) async {
    final text = (quick ?? controller.text).trim();
    if (text.isEmpty || sending) return;

    setState(() => sending = true);
    final sent = await guardedDone(
      context,
      () => widget.repository
          .sendChatMessage(widget.shiftId, text, workerId: widget.workerId),
    );
    if (!mounted) return;
    // Поле чистим, только когда ушло: иначе набранное пропало бы.
    if (sent && quick == null) controller.clear();
    setState(() => sending = false);
    if (sent) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final quick =
        _isEmployer ? tr.shift.chatQuickEmployer : tr.shift.chatQuickWorker;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr.shift.chatTitle),
            Text(
              widget.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: switch (messages) {
              Loading() => const TileListSkeleton(count: 3),
              Failed(:final error) =>
                ErrorView(message: describeError(error), onRetry: _load),
              Ready(value: []) => EmptyState(
                  icon: Icons.forum_outlined,
                  title: tr.shift.chatEmptyTitle,
                  subtitle: tr.shift.chatEmptySubtitle,
                ),
              // Перевёрнут: свежее внизу, и открывается на нём.
              Ready(value: final list) => RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    reverse: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: list.length,
                    itemBuilder: (context, index) =>
                        _Bubble(message: list[list.length - 1 - index]),
                  ),
                ),
            },
          ),
          // Быстрые фразы: на ходу и в перчатках набирать неудобно, а
          // «опаздываю» — самое частое, что нужно сказать.
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              children: [
                for (final phrase in quick)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(phrase),
                      onPressed: sending ? null : () => _send(phrase),
                    ),
                  ),
              ],
            ),
          ),
          _Composer(
            controller: controller,
            sending: sending,
            onSend: () => _send(),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ShiftMessage message;

  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final mine = message.mine;
    final time = '${message.createdAt.hour.toString().padLeft(2, '0')}:'
        '${message.createdAt.minute.toString().padLeft(2, '0')}';

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: mine ? AppColors.brand : glassFieldFill(context),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
          border: mine ? null : Border.all(color: glassFieldEdge(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 14,
                height: 1.35,
                color: mine
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 10.5,
                color: mine
                    ? Colors.white.withValues(alpha: 0.75)
                    : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool sending;

  const _Composer({
    required this.controller,
    required this.onSend,
    required this.sending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: GlassTokens.of(context).strongFill,
        border: Border(top: BorderSide(color: glassFieldEdge(context))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                maxLength: kMaxMessageLength,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: tr.shift.chatHint,
                  counterText: '',
                  isDense: true,
                  filled: true,
                  fillColor: glassFieldFill(context),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: sending ? null : onSend,
              tooltip: tr.profile.send,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.brand,
                foregroundColor: Colors.white,
                minimumSize: const Size(46, 46),
              ),
              icon: const Icon(Icons.arrow_upward_rounded, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
