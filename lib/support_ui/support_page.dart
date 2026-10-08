import 'package:flutter/material.dart';

import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/support.dart';
import '../l10n/strings.dart';
import '../theme/app_colors.dart';
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
  List<SupportTicket>? tickets;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await widget.repository.tickets();
    if (!mounted) return;
    setState(() => tickets = loaded);
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
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    final created = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.profile.supportNewTicket),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: subjectController,
              autofocus: true,
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
              decoration: InputDecoration(
                labelText: tr.profile.supportWhatHappened,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(tr.profile.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(tr.profile.send),
          ),
        ],
      ),
    );

    if (created != true) return;
    final subject = subjectController.text.trim();
    final message = messageController.text.trim();
    if (subject.isEmpty || message.isEmpty) return;

    await widget.repository.createTicket(subject, message);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final list = tickets;

    return Scaffold(
      appBar: AppBar(title: Text(tr.profile.supportTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createTicket,
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(tr.profile.supportWrite),
      ),
      body: switch (list) {
        null => const TileListSkeleton(count: 3),
        [] => EmptyState(
            icon: Icons.support_agent_rounded,
            title: tr.profile.supportEmptyTitle,
            subtitle: tr.profile.supportEmptySubtitle,
          ),
        final items => ListView.builder(
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
