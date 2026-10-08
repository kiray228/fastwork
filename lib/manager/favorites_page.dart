import 'package:flutter/material.dart';

import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/user.dart';
import '../l10n/strings.dart';
import '../theme/app_colors.dart';
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

  const FavoritesPage({super.key, required this.repository});

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

  const _FavoriteTile({required this.user, required this.onRemove});

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
