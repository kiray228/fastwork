import 'package:flutter/material.dart';

import 'data/session.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/review.dart';
import 'package:fastwork_core/shift.dart';
import 'theme/app_colors.dart';
import 'package:fastwork_core/user.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';
import 'widgets/skeleton.dart';

/// Отзывы, которые исполнитель получил от заказчиков.
class MyReviewsPage extends StatefulWidget {
  final AppSession session;
  final ShiftRepository repository;

  const MyReviewsPage({
    super.key,
    required this.session,
    required this.repository,
  });

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  Async<List<WorkerReview>> state = const Loading();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await load(
      () => widget.repository.reviewsAbout(widget.session.workerId),
    );
    if (!mounted) return;
    setState(() => state = result);
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.session.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Отзывы обо мне')),
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
              icon: Icons.reviews_outlined,
              title: 'Отзывов пока нет',
              subtitle: 'Заказчики оценивают исполнителей\n'
                  'после отработанной смены',
            ),
          Ready(:final value) => RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: value.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _Summary(reviews: value, user: user);
                  }
                  return AnimatedEntrance(
                    index: index,
                    child: _ReviewTile(review: value[index - 1]),
                  );
                },
              ),
            ),
        },
      ),
    );
  }
}

/// Шапка со средней оценкой.
///
/// Среднее считается прямо здесь, из того же списка, который показан ниже.
/// Никакого отдельного числа «рейтинг» экрану не приходит — и разъехаться
/// с отзывами оно поэтому не может.
class _Summary extends StatelessWidget {
  final List<WorkerReview> reviews;
  final AppUser? user;

  const _Summary({required this.reviews, required this.user});

  @override
  Widget build(BuildContext context) {
    final avg = reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        reviews.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SurfaceCard(
        child: Column(
          children: [
            Text(
              avg.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  Icon(
                    i <= avg.round()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 20,
                    color: AppColors.accent,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _reviewCount(reviews.length),
              style: const TextStyle(fontSize: 13, color: AppColors.muted),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.brand.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Рейтинг — это среднее по этим оценкам. Он влияет на то, '
                'к каким сменам у вас есть доступ.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.35,
                  color: AppColors.brandDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _reviewCount(int n) {
    final last = n % 10;
    final lastTwo = n % 100;
    if (lastTwo >= 11 && lastTwo <= 14) return '$n оценок';
    if (last == 1) return '$n оценка';
    if (last >= 2 && last <= 4) return '$n оценки';
    return '$n оценок';
  }
}

class _ReviewTile extends StatelessWidget {
  final WorkerReview review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CompanyAvatar(company: review.company, size: 34),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.company,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: 14),
                      ),
                      Text(
                        '${review.shiftTitle} · '
                        '${review.createdAt.day} '
                        '${monthsShort[review.createdAt.month - 1]}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 16, color: AppColors.accent),
                    const SizedBox(width: 3),
                    Text(
                      '${review.rating}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ],
            ),
            if (review.comment != null) ...[
              const SizedBox(height: 10),
              Text(
                review.comment!,
                style: const TextStyle(fontSize: 13.5, height: 1.4),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
