import 'package:flutter/material.dart';

import 'data/shift_repository.dart';
import 'review.dart';
import 'shift.dart';
import 'theme/app_colors.dart';
import 'widgets/common.dart';
import 'widgets/skeleton.dart';

/// Страница компании: оценка и отзывы исполнителей.
class CompanyPage extends StatefulWidget {
  final String company;
  final ShiftRepository repository;

  const CompanyPage({
    super.key,
    required this.company,
    required this.repository,
  });

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  CompanyInfo? info;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await widget.repository.companyInfo(widget.company);
    if (!mounted) return;
    setState(() => info = loaded);
  }

  @override
  Widget build(BuildContext context) {
    final data = info;

    return Scaffold(
      appBar: AppBar(title: const Text('О компании')),
      body: data == null
          ? const TileListSkeleton(count: 3)
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                SurfaceCard(
                  child: Column(
                    children: [
                      CompanyAvatar(company: data.name, size: 64),
                      const SizedBox(height: 12),
                      Text(
                        data.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      if (data.rating == null)
                        const TagChip(
                          text: 'Пока нет оценок',
                          icon: Icons.star_outline_rounded,
                        )
                      else
                        TagChip(
                          text: '${data.rating!.toStringAsFixed(1)} · '
                              '${_reviewsLabel(data.reviewCount)}',
                          icon: Icons.star_rounded,
                          color: AppColors.accent,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        icon: Icons.reviews_outlined,
                        title: 'Отзывы исполнителей',
                      ),
                      const SizedBox(height: 14),
                      if (data.reviews.isEmpty)
                        const Text(
                          'Пока никто не оставил отзыв. Отработайте смену '
                          'и расскажите, как всё прошло.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: AppColors.muted,
                            height: 1.4,
                          ),
                        )
                      else
                        for (final review in data.reviews)
                          _ReviewTile(review: review),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  static String _reviewsLabel(int count) {
    final last = count % 10;
    final lastTwo = count % 100;
    if (lastTwo >= 11 && lastTwo <= 14) return '$count отзывов';
    if (last == 1) return '$count отзыв';
    if (last >= 2 && last <= 4) return '$count отзыва';
    return '$count отзывов';
  }
}

class _ReviewTile extends StatelessWidget {
  final Review review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.authorName,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 14),
                ),
              ),
              for (var i = 1; i <= 5; i++)
                Icon(
                  i <= review.rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 15,
                  color: i <= review.rating
                      ? AppColors.accent
                      : AppColors.muted.withValues(alpha: 0.4),
                ),
            ],
          ),
          if (review.comment != null) ...[
            const SizedBox(height: 6),
            Text(
              review.comment!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 13.5, height: 1.4),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            '${review.createdAt.day} '
            '${monthsShort[review.createdAt.month - 1]}',
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
