import 'package:flutter/material.dart';

import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/notification.dart';
import 'data/session.dart';
import 'shift_detail_page.dart';
import 'theme/app_colors.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';
import 'widgets/skeleton.dart';

/// Уведомления — то, что показывает колокольчик.
///
/// Экран сознательно ничего не решает сам: он не знает, когда приходит
/// уведомление и о чём. Его дело — показать список и отметить прочитанным.
/// Кто и когда пишет уведомления, решает хранилище, рядом с самим событием.
class NotificationsPage extends StatefulWidget {
  final AppSession session;
  final ShiftRepository repository;

  const NotificationsPage({
    super.key,
    required this.session,
    required this.repository,
  });

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Async<List<AppNotification>> state = const Loading();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await load(widget.repository.notifications);
    if (!mounted) return;
    setState(() => state = result);

    // Открыл — значит прочитал. Отмечаем после показа, а не до: пусть
    // непрочитанные успеют подсветиться, иначе человек не поймёт,
    // что именно было новым.
    //
    // Ошибку здесь глотаем намеренно: список человек уже видит, и падать
    // из-за того, что не удалось снять кружок, было бы хуже, чем
    // показать кружок лишний раз.
    if (result is Ready<List<AppNotification>>) {
      try {
        await widget.repository.markNotificationsRead();
      } catch (_) {
        // Не получилось — не беда, отметим в следующий раз.
      }
    }
  }

  void _open(AppNotification notification) {
    final shiftId = notification.shiftId;
    if (shiftId == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ShiftDetailPage(
          shiftId: shiftId,
          repository: widget.repository,
          session: widget.session,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Уведомления')),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: switch (state) {
          Loading() => const TileListSkeleton(),
          Failed(:final error) => ErrorView(
              message: describeError(error),
              onRetry: () {
                setState(() => state = const Loading());
                _load();
              },
            ),
          Ready(value: []) => const EmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'Уведомлений нет',
              subtitle: 'Здесь появятся записи на ваши смены,\n'
                  'подтверждения выхода и оценки',
            ),
          Ready(:final value) => RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: value.length,
                itemBuilder: (context, index) => AnimatedEntrance(
                  index: index,
                  child: _NotificationTile(
                    notification: value[index],
                    onTap: () => _open(value[index]),
                  ),
                ),
              ),
            ),
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  /// Значок выбирается по виду события, а не по тексту. Ради этого вид
  /// и хранится отдельным полем.
  (IconData, Color) get _look => switch (notification.kind) {
        NotificationKind.applied => (Icons.person_add_alt_1, AppColors.brand),
        NotificationKind.withdrew => (Icons.person_remove_alt_1, AppColors.warning),
        NotificationKind.confirmed => (Icons.check_circle, AppColors.success),
        NotificationKind.rated => (Icons.star_rounded, AppColors.accent),
        NotificationKind.shiftCancelled => (Icons.event_busy, AppColors.danger),
        NotificationKind.shiftChanged => (Icons.edit_calendar, AppColors.warning),
        NotificationKind.noShow => (Icons.person_off, AppColors.danger),
      };

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _look;
    final unread = notification.isUnread;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SurfaceCard(
        padding: const EdgeInsets.all(14),
        onTap: notification.shiftId == null ? null : onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight:
                                unread ? FontWeight.w700 : FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      // Непрочитанное помечаем точкой, а не цветом фона:
                      // фон пришлось бы подбирать и под тёмную тему тоже.
                      if (unread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: const TextStyle(fontSize: 13, height: 1.35),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    describeWhen(notification.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// «5 минут назад», «вчера», «12 сентября».
///
/// Точное время здесь не нужно и даже мешает: человеку важно «давно или
/// только что», а не «14:37:02».
String describeWhen(DateTime moment) {
  final diff = DateTime.now().difference(moment);

  if (diff.inMinutes < 1) return 'только что';
  if (diff.inMinutes < 60) return '${diff.inMinutes} мин назад';
  if (diff.inHours < 24) return '${diff.inHours} ч назад';
  if (diff.inDays == 1) return 'вчера';
  if (diff.inDays < 7) return '${diff.inDays} дн назад';

  const months = [
    'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
    'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
  ];
  return '${moment.day} ${months[moment.month - 1]}';
}
