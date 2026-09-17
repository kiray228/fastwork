import 'package:flutter/material.dart';

import '../shift.dart';
import '../theme/app_colors.dart';
import 'common.dart';

/// Карточка смены в ленте.
class ShiftCard extends StatelessWidget {
  final Shift shift;
  final VoidCallback onTap;

  /// Рейтинг текущего пользователя — по нему решается допуск к смене.
  final double userRating;

  const ShiftCard({
    super.key,
    required this.shift,
    required this.onTap,
    this.userRating = 5,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filled = shift.workersHired / shift.workersNeeded;
    final allowed = shift.ratingAllows(userRating);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SurfaceCard(
        onTap: shift.hasFreeSlots && allowed ? onTap : null,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Шапка: аватар компании, название, время
            Row(
              children: [
                CompanyAvatar(company: shift.company),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shift.company,
                        style: text.titleMedium?.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${formatTime(shift.startMinutes)} — '
                        '${formatTime(shift.endMinutes)} · '
                        '${formatDuration(shift.durationMinutes)}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Сумма — главный элемент карточки, поэтому самый крупный.
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    formatMoney(shift.totalPay),
                    style: text.displaySmall?.copyWith(fontSize: 30),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${formatMoney(shift.hourlyRate)}/ч',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brand,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            InfoRow(icon: Icons.work_outline, text: shift.title),
            InfoRow(icon: Icons.place_outlined, text: shift.address),

            if (shift.tags.isNotEmpty || !allowed) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (!allowed)
                    TagChip(
                      text: 'Нужен рейтинг '
                          '${shift.minRating!.toStringAsFixed(1)}',
                      icon: Icons.lock_outline_rounded,
                      color: AppColors.accent,
                    ),
                  for (final tag in shift.tags)
                    TagChip(
                      text: tag,
                      color: tag == 'Мало мест' ? AppColors.accent : null,
                    ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // Полоска заполнения мест: видно, насколько смена уже набрана.
            if (shift.hasFreeSlots && allowed) ...[
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: filled,
                        minHeight: 6,
                        backgroundColor:
                            isDark ? AppColors.darkBorder : AppColors.border,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.brand,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'осталось ${shift.freeSlots}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: shift.hasFreeSlots && allowed ? onTap : null,
                child: Text(
                  !allowed
                      ? 'Рейтинг ниже требуемого'
                      : shift.hasFreeSlots
                          ? 'Подробнее'
                          : 'Мест нет',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
