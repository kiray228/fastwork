import 'package:flutter/material.dart';

import '../shift.dart';
import '../theme/app_colors.dart';

/// Горизонтальная полоса дат.
class DateStrip extends StatelessWidget {
  final DateTime today;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;
  final bool Function(DateTime) hasShiftsOn;

  const DateStrip({
    super.key,
    required this.today,
    required this.selectedDay,
    required this.onDaySelected,
    required this.hasShiftsOn,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 78,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 14,
        itemBuilder: (context, index) {
          final date = DateTime(today.year, today.month, today.day + index);
          final isSelected = index == selectedDay;
          final hasShifts = hasShiftsOn(date);

          final Color background;
          final Color textColor;

          if (isSelected) {
            background = AppColors.brand;
            textColor = Colors.white;
          } else if (hasShifts) {
            background = isDark ? AppColors.darkSurface : Colors.white;
            textColor = isDark ? AppColors.darkInk : AppColors.ink;
          } else {
            // День без смен — приглушаем, но оставляем нажимаемым.
            background = isDark
                ? AppColors.darkSurface.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.5);
            textColor = AppColors.muted;
          }

          return GestureDetector(
            onTap: () => onDaySelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 58,
              margin: const EdgeInsets.only(right: 8, top: 8, bottom: 12),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.brand
                      : (isDark ? AppColors.darkBorder : AppColors.border),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.brand.withValues(alpha: 0.32),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekdaysShort[date.weekday - 1],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.85)
                          : AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Точка-индикатор: есть ли смены в этот день.
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasShifts
                          ? (isSelected ? Colors.white : AppColors.brand)
                          : Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
