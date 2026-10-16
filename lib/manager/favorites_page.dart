import 'package:flutter/material.dart';

import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/user.dart';
import '../l10n/strings.dart';
import '../theme/app_colors.dart';
import '../theme/glass.dart';
import '../widgets/async_state.dart';
import '../widgets/common.dart';
import '../widgets/skeleton.dart';

/// Любимые исполнители заказчика.
///
/// Те, с кем заказчику понравилось работать. Когда он публикует новую
/// смену, им приходит приглашение — раньше, чем смену увидят остальные
/// в ленте. Добавляют сюда сердечком в списке записавшихся, убирают —
/// здесь или там же.
class FavoritesPage extends StatefulWidget {
  final ShiftRepository repository;

  /// Чьи это любимые — нужен, чтобы предложить его смены для приглашения.
  final int managerId;

  const FavoritesPage({
    super.key,
    required this.repository,
    required this.managerId,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Async<List<AppUser>> state = const Loading();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await load(widget.repository.favoriteWorkers);
    if (!mounted) return;
    setState(() => state = result);
  }

  Future<void> _remove(AppUser user) async {
    final result = await guarded(
      context,
      () => widget.repository.setFavorite(workerId: user.id, favorite: false),
    );
    if (result == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr.manager.removedFromFavorites(user.fullName)),
        behavior: SnackBarBehavior.floating,
      ),
    );
    await _load();
  }

  /// Позвать человека на смену, которая недобирает людей.
  ///
  /// Список — только то, куда звать имеет смысл: впереди, оплачена,
  /// есть свободные места.
  Future<void> _invite(AppUser user) async {
    final shifts = await guarded(
      context,
      () => widget.repository.shiftsCreatedBy(widget.managerId),
    );
    if (shifts == null || !mounted) return;
    final now = DateTime.now();
    final open = [
      for (final s in shifts)
        if (!s.isCancelled &&
            !s.awaitingPayment &&
            !s.hasStartedAt(now) &&
            s.hasFreeSlots)
          s,
    ]..sort((a, b) => a.startsAt.compareTo(b.startsAt));

    final picked = await showModalBottomSheet<Shift>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => GlassSheet(
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SheetHandle(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(
                  tr.manager.inviteSheetTitle(user.fullName),
                  style: Theme.of(sheetContext)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 19),
                ),
              ),
              if (open.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  child: Text(
                    tr.manager.inviteNoShifts,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                )
              else
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final s in open)
                        ListTile(
                          leading: const Icon(Icons.event_available_rounded,
                              color: AppColors.brand),
                          title: Text(s.title),
                          subtitle: Text(
                            '${tr.core.dayMonth(s.workDate)}, '
                            '${formatTime(s.startMinutes)}–'
                            '${formatTime(s.endMinutes)} · '
                            '${tr.feed.slotsLeft(s.freeSlots)}',
                          ),
                          onTap: () => Navigator.of(sheetContext).pop(s),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
    if (picked == null || !mounted) return;

    final result = await guarded(
      context,
      () => widget.repository
          .inviteToShift(shiftId: picked.id, workerId: user.id),
    );
    if (result == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(switch (result) {
        BookingResult.ok => tr.manager.invitedSnack(user.fullName),
        BookingResult.alreadyBooked =>
          tr.manager.inviteAlreadyBooked(user.fullName),
        _ => tr.manager.inviteFailed,
      }),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr.manager.favoritesTitle)),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: switch (state) {
          Loading() => const TileListSkeleton(count: 3),
          Failed(:final error) => ErrorView(
              message: describeError(error),
              onRetry: () {
                setState(() => state = const Loading());
                _load();
              },
            ),
          Ready(value: []) => EmptyState(
              icon: Icons.favorite_border_rounded,
              title: tr.manager.favoritesEmptyTitle,
              subtitle: tr.manager.favoritesEmptySubtitle,
            ),
          Ready(:final value) => RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: value.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return const _Hint();
                  final user = value[index - 1];
                  return AnimatedEntrance(
                    index: index,
                    child: _FavoriteTile(
                      user: user,
                      onRemove: () => _remove(user),
                      onInvite: () => _invite(user),
                    ),
                  );
                },
              ),
            ),
        },
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SurfaceCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.campaign_outlined,
                size: 18, color: AppColors.brand),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                tr.manager.favoritesHint,
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.35,
                  color: AppColors.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  final AppUser user;
  final VoidCallback onRemove;
  final VoidCallback onInvite;

  const _FavoriteTile({
    required this.user,
    required this.onRemove,
    required this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.brand, AppColors.brandDark],
                ),
              ),
              child: Text(
                user.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr.manager.favoriteStats(
                      user.rating.toStringAsFixed(1),
                      shiftsLabel(user.completedShifts),
                      tr.core.city(user.city),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onInvite,
              tooltip: tr.manager.inviteToShift,
              icon: const Icon(Icons.send_rounded, color: AppColors.brand),
            ),
            IconButton(
              onPressed: onRemove,
              tooltip: tr.manager.removeFromFavorites,
              icon: const Icon(
                Icons.favorite_rounded,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
