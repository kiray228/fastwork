import 'package:flutter/material.dart';

import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/review.dart';
import 'package:fastwork_core/shift.dart';
import 'theme/app_colors.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';
import 'widgets/skeleton.dart';

/// Страница компании: оценка и отзывы исполнителей.
class CompanyPage extends StatefulWidget {
  final String company;
  final ShiftRepository repository;

  /// Открыть смену из списка ближайших. Страница компании сама не знает,
  /// как устроен экран смены и кто вошёл, — это решает тот, кто её открыл.
  final void Function(int shiftId)? onOpenShift;

  const CompanyPage({
    super.key,
    required this.company,
    required this.repository,
    this.onOpenShift,
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

  bool busy = false;

  Future<void> _load() async {
    final loaded = await widget.repository.companyInfo(widget.company);
    if (!mounted) return;
    setState(() => info = loaded);
  }

  /// Подписаться на новые смены компании или отписаться.
  Future<void> _toggleFollow(CompanyInfo data) async {
    final follow = !data.isFollowed;
    setState(() => busy = true);
    final done = await guardedDone(
      context,
      () => widget.repository.followCompany(data.name, follow: follow),
    );
    await _load();
    if (!mounted) return;
    setState(() => busy = false);
    if (!done) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(follow
            ? 'Сообщим, когда ${data.name} выставит новую смену в вашем городе'
            : 'Вы отписались от новых смен ${data.name}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                      const SizedBox(height: 14),
                      // Подписка — вместо «сохранённого поиска»: чаще
                      // ищут не работу вообще, а работу у знакомого места.
                      SizedBox(
                        width: double.infinity,
                        child: data.isFollowed
                            ? OutlinedButton.icon(
                                onPressed:
                                    busy ? null : () => _toggleFollow(data),
                                icon: const Icon(
                                    Icons.notifications_active_rounded,
                                    size: 18),
                                label: const Text('Вы подписаны · Отписаться'),
                              )
                            : FilledButton.icon(
                                onPressed:
                                    busy ? null : () => _toggleFollow(data),
                                icon: const Icon(
                                    Icons.notifications_none_rounded,
                                    size: 18),
                                label: const Text('Сообщать о новых сменах'),
                              ),
                      ),
                    ],
                  ),
                ),
                if (data.upcoming.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(
                          icon: Icons.event_available_rounded,
                          title: 'Ближайшие смены',
                        ),
                        const SizedBox(height: 8),
                        for (final shift in data.upcoming)
                          _UpcomingRow(
                            shift: shift,
                            onTap: widget.onOpenShift == null
                                ? null
                                : () => widget.onOpenShift!(shift.id),
                          ),
                      ],
                    ),
                  ),
                ],
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

  static String _reviewsLabel(int count) =>
      '$count ${plural(count, 'отзыв', 'отзыва', 'отзывов')}';
}

/// Одна смена в списке ближайших: когда, что и сколько.
class _UpcomingRow extends StatelessWidget {
  final Shift shift;
  final VoidCallback? onTap;

  const _UpcomingRow({required this.shift, this.onTap});

  @override
  Widget build(BuildContext context) {
    final date = shift.workDate;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shift.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${relativeDay(date, DateTime.now())} · '
                    '${formatTime(shift.startMinutes)}–'
                    '${formatTime(shift.endMinutes)}'
                    '${shift.hasFreeSlots ? '' : ' · мест нет'}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatMoney(shift.totalPay),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.brand,
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right_rounded,
                  size: 20, color: AppColors.muted),
          ],
        ),
      ),
    );
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
