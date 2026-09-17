import 'package:flutter/material.dart';

import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/support.dart';
import '../theme/app_colors.dart';
import '../widgets/skeleton.dart';

/// Переписка внутри одного обращения.
///
/// Связь один-ко-многим в чистом виде: одно обращение — много сообщений.
class TicketPage extends StatefulWidget {
  final SupportTicket ticket;
  final SupportRepository repository;

  const TicketPage({
    super.key,
    required this.ticket,
    required this.repository,
  });

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final controller = TextEditingController();
  List<SupportMessage>? messages;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final loaded = await widget.repository.messages(widget.ticket.id);
    if (!mounted) return;
    setState(() => messages = loaded);
  }

  Future<void> _send() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    controller.clear();
    await widget.repository.sendMessage(widget.ticket.id, text);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final list = messages;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.ticket.subject,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: list == null
                ? const TileListSkeleton(count: 3)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    itemCount: list.length,
                    itemBuilder: (context, index) =>
                        _Bubble(message: list[index]),
                  ),
          ),
          _Composer(controller: controller, onSend: _send),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final SupportMessage message;

  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mine = !message.fromSupport;

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: mine
              ? AppColors.brand
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
          border: mine
              ? null
              : Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
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
              '${message.createdAt.hour.toString().padLeft(2, '0')}:'
              '${message.createdAt.minute.toString().padLeft(2, '0')}',
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

  const _Composer({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
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
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Сообщение',
                  isDense: true,
                  filled: true,
                  fillColor: isDark ? AppColors.darkBg : AppColors.bg,
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
              onPressed: onSend,
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
