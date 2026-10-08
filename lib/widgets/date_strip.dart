import 'package:flutter/material.dart';

import 'package:fastwork_core/shift.dart';
import '../l10n/strings.dart';
import '../theme/app_colors.dart';
import '../theme/glass.dart';

/// Горизонтальная полоса дат.
///
/// Первая плитка — «Все дни»: смены на две недели вперёд одним списком.
/// Кто ищет любую подработку на ближайшие дни, не листает даты по одной.
class DateStrip extends StatelessWidget {
  /// Номер плитки «Все дни» в [selectedDay] и [onDaySelected].
  static const allDays = -1;

  /// На сколько дней вперёд полоса.
  static const days = 14;

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
        itemCount: days + 1,
        itemBuilder: (context, item) {
          if (item == 0) {
            return _AllDaysTile(
              selected: selectedDay == allDays,
              onTap: () => onDaySelected(allDays),
            );
          }
          final index = item - 1;
          final date = DateTime(today.year, today.month, today.day + index);
          final isSelected = index == selectedDay;
          final hasShifts = hasShiftsOn(date);

          final Color background;
          final Color textColor;

          if (isSelected) {
            background = AppColors.brand;
            textColor = Colors.white;
          } else if (hasShifts) {
            background = glassFieldFill(context);
            textColor = isDark ? AppColors.darkInk : AppColors.ink;
          } else {
            // День без смен — приглушаем, но оставляем нажимаемым.
            background = glassFieldFill(context).withValues(
              alpha: isDark ? 0.03 : 0.3,
            );
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
                      : glassFieldEdge(context),
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

/// Плитка «Все дни» — такого же размера, как день, чтобы полоса не
/// прыгала.
class _AllDaysTile extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _AllDaysTile({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = selected
        ? Colors.white
        : (isDark ? AppColors.darkInk : AppColors.ink);

    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 58,
          margin: const EdgeInsets.only(right: 8, top: 8, bottom: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.brand : glassFieldFill(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.brand : glassFieldEdge(context),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.view_agenda_outlined, size: 20, color: color),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    tr.feed.allDays,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
