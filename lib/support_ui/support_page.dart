import 'package:flutter/material.dart';

import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/support.dart';
import '../l10n/strings.dart';
import '../theme/app_colors.dart';
import '../widgets/async_state.dart';
import '../widgets/common.dart';
import '../widgets/nav.dart';
import '../widgets/skeleton.dart';
import 'ticket_page.dart';

/// Список обращений в поддержку.
class SupportPage extends StatefulWidget {
  final SupportRepository repository;

  const SupportPage({super.key, required this.repository});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  Async<List<SupportTicket>> tickets = const Loading();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await load(widget.repository.tickets);
    if (!mounted) return;
    // Список уже был — сбой перечитывания его не прячет.
    if (result is Failed && tickets is Ready) return;
    setState(() => tickets = result);
  }

  Future<void> _openTicket(SupportTicket ticket) async {
    await Navigator.of(context).push(
      appRoute(
        TicketPage(ticket: ticket, repository: widget.repository),
      ),
    );
    await _load();
  }

  Future<void> _createTicket() async {
    // Раньше пустая тема или пустое сообщение молча закрывали окно, и
    // обращение пропадало вместе с набранным текстом. Теперь окно само
    // не даёт отправить пустое, а сбой сети показывается сообщением.
    final draft = await showDialog<(String, String)>(
      context: context,
      builder: (context) => const _NewTicketDialog(),
    );
    if (draft == null || !mounted) return;

    final (subject, message) = draft;
    final done = await guardedDone(
      context,
      () => widget.repository.createTicket(subject, message),
    );
    if (done) await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr.profile.supportTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createTicket,
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(tr.profile.supportWrite),
      ),
      // Потянуть вниз — проверить, не ответила ли поддержка.
      body: RefreshIndicator(
        onRefresh: _load,
        child: switch (tickets) {
          Loading() => const TileListSkeleton(count: 3),
          Failed(:final error) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                ErrorView(message: describeError(error), onRetry: _load),
              ],
            ),
          Ready(value: []) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                EmptyState(
                  icon: Icons.support_agent_rounded,
                  title: tr.profile.supportEmptyTitle,
                  subtitle: tr.profile.supportEmptySubtitle,
                ),
              ],
            ),
          Ready(value: final items) => ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              itemCount: items.length,
              itemBuilder: (context, index) => AnimatedEntrance(
                index: index,
                child: _TicketTile(
                  ticket: items[index],
                  onTap: () => _openTicket(items[index]),
                ),
              ),
            ),
        },
      ),
    );
  }
}

/// Окно нового обращения. Отдельный виджет со своим состоянием: ему нужны
/// поля ввода, которые надо освободить, когда окно закроется, и кнопка,
/// которая оживает, только когда заполнено и то и другое.
class _NewTicketDialog extends StatefulWidget {
  const _NewTicketDialog();

  @override
  State<_NewTicketDialog> createState() => _NewTicketDialogState();
}

class _NewTicketDialogState extends State<_NewTicketDialog> {
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  bool get _ready =>
      subjectController.text.trim().isNotEmpty &&
      messageController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(tr.profile.supportNewTicket),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: subjectController,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: tr.profile.supportSubject,
              hintText: tr.profile.supportSubjectHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: messageController,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: tr.profile.supportWhatHappened,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(tr.profile.cancel),
        ),
        TextButton(
          onPressed: _ready
              ? () => Navigator.of(context).pop((
                    subjectController.text.trim(),
                    messageController.text.trim(),
                  ))
              : null,
          child: Text(tr.profile.send),
        ),
      ],
    );
  }
}

class _TicketTile extends StatelessWidget {
  final SupportTicket ticket;
  final VoidCallback onTap;

  const _TicketTile({required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ticket.subject,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 14.5),
                  ),
                ),
                TagChip(
                  text: ticket.isOpen
                      ? tr.profile.ticketOpen
                      : tr.profile.ticketClosed,
                  color: ticket.isOpen ? AppColors.brand : null,
                ),
              ],
            ),
            if (ticket.lastMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                ticket.lastMessage!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.muted,
                  height: 1.35,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              '${tr.profile.ticketMessages(ticket.messageCount)} · '
              '${ticket.createdAt.day} '
              '${monthsShort[ticket.createdAt.month - 1]}',
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
