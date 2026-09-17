import 'package:flutter/material.dart';

import '../data/session.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/review.dart';
import 'package:fastwork_core/shift.dart';
import '../theme/app_colors.dart';
import '../widgets/async_state.dart';
import '../widgets/common.dart';
import '../widgets/review_sheet.dart';
import '../widgets/skeleton.dart';

/// Кого заказчику осталось оценить после отработанных смен.
///
/// Здесь замыкается круг: исполнитель оценивает место работы, заказчик —
/// исполнителя. До этого экрана рейтинг был просто числом в колонке,
/// теперь он наконец становится заработанным.
class RateWorkersPage extends StatefulWidget {
  final AppSession session;
  final ShiftRepository repository;

  const RateWorkersPage({
    super.key,
    required this.session,
    required this.repository,
  });

  @override
  State<RateWorkersPage> createState() => _RateWorkersPageState();
}

class _RateWorkersPageState extends State<RateWorkersPage> {
  Async<List<PendingRating>> state = const Loading();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // `load` сам ловит сбой и возвращает его как состояние — экрану
    // остаётся только показать нужную картинку.
    final result = await load(
      () => widget.repository.workersToRate(widget.session.workerId),
    );
    if (!mounted) return;
    setState(() => state = result);
  }

  Future<void> _rate(PendingRating item) async {
    final input = await showRatingSheet(
      context,
      title: 'Оцените исполнителя',
      subtitle: '${item.workerName} · ${item.shiftTitle}',
      hint: 'Пришёл вовремя? Справился с работой? '
          'Это увидят другие заказчики',
      buttonLabel: 'Поставить оценку',
    );
    if (input == null || !mounted) return;

    final saved = await guardedDone(
      context,
      () => widget.repository.rateWorker(
        shiftId: item.shiftId,
        workerId: item.workerId,
        rating: input.rating,
        comment: input.comment,
      ),
    );
    if (!mounted || !saved) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Оценка учтена в рейтинге ${item.workerName}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Оценки')),
      // AnimatedSwitcher сглаживает смену состояния: скелет не пропадает
      // рывком, а растворяется в списке.
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
              icon: Icons.task_alt_rounded,
              title: 'Все оценены',
              subtitle: 'Как только пройдёт следующая смена,\n'
                  'её участники появятся здесь',
            ),
          Ready(:final value) => RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: value.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return const _Explainer();
                  final item = value[index - 1];
                  return AnimatedEntrance(
                    index: index,
                    child: _PendingTile(
                      item: item,
                      onTap: () => _rate(item),
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

class _Explainer extends StatelessWidget {
  const _Explainer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SurfaceCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded,
                size: 18, color: AppColors.brand),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Оценка сразу меняет рейтинг исполнителя — по нему его '
                'выбирают другие заказчики.',
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

class _PendingTile extends StatelessWidget {
  final PendingRating item;
  final VoidCallback onTap;

  const _PendingTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final initials = _initials(item.workerName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        padding: const EdgeInsets.all(14),
        onTap: onTap,
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
                initials,
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
                    item.workerName,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${item.shiftTitle} · ${item.workDate.day} '
                    '${monthsShort[item.workDate.month - 1]}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 14, color: AppColors.accent),
                      const SizedBox(width: 3),
                      Text(
                        item.workerRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const TagChip(
              text: 'Оценить',
              icon: Icons.star_outline_rounded,
              color: AppColors.brand,
            ),
          ],
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}
