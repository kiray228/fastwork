import 'package:flutter/material.dart';

import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/shift.dart';
import '../theme/app_colors.dart';
import 'common.dart';
import '../l10n/strings.dart';

/// Заработок по неделям: восемь столбиков, текущая неделя справа.
///
/// Нарисовано обычными виджетами, без библиотеки графиков: столбиков
/// восемь, оси не нужны — подписи стоят под столбиками, а точная сумма
/// показывается над графиком для выбранной недели. Касание по столбику
/// выбирает его — на телефоне «навести мышку» нечем.
///
/// Один ряд данных — один цвет, легенда не нужна: что это за числа,
/// говорит заголовок.
class EarningsChart extends StatefulWidget {
  final List<WeekEarnings> weeks;

  const EarningsChart({super.key, required this.weeks});

  @override
  State<EarningsChart> createState() => _EarningsChartState();
}

class _EarningsChartState extends State<EarningsChart> {
  /// Выбранная неделя. Сначала — текущая.
  late int selected = widget.weeks.length - 1;

  static const _barAreaHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    final weeks = widget.weeks;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ink = isDark ? AppColors.darkInk : AppColors.ink;
    final muted = isDark ? AppColors.darkMuted : AppColors.muted;
    final baseline = isDark ? AppColors.darkBorder : AppColors.border;

    final max = weeks.fold<int>(0, (m, w) => w.amount > m ? w.amount : m);
    final total = weeks.fold<int>(0, (sum, w) => sum + w.amount);
    final worked = weeks.where((w) => w.amount > 0).length;
    final week = weeks[selected];

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.bar_chart_rounded,
            title: tr.wallet.chartTitle,
          ),
          const SizedBox(height: 4),
          Text(
            tr.wallet.chartSummary(
              weeks.length,
              formatMoney(total),
              worked > 0 ? formatMoney(total ~/ worked) : null,
            ),
            style: TextStyle(fontSize: 12.5, height: 1.35, color: muted),
          ),
          const SizedBox(height: 14),
          // Подпись выбранной недели — над графиком, чтобы палец, которым
          // нажали на столбик, её не закрывал.
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Row(
              key: ValueKey(selected),
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  formatMoney(week.amount),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '${_weekLabel(week.start)}'
                    '${week.shifts > 0 ? ' · ${shiftsLabel(week.shifts)}' : ''}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.5, color: muted),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: _barAreaHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < weeks.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: Semantics(
                      button: true,
                      selected: i == selected,
                      label: '${_weekLabel(weeks[i].start)}: '
                          '${formatMoney(weeks[i].amount)}',
                      // Касание ловит вся колонка, а не только столбик:
                      // по низкому столбику пальцем не попасть.
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => selected = i),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            // Пустая неделя — тонкая полоска у основания:
                            // ноль виден как ноль, а не как дыра.
                            height: max == 0 || weeks[i].amount == 0
                                ? 2
                                : 6 +
                                    (_barAreaHeight - 6) *
                                        weeks[i].amount /
                                        max,
                            decoration: BoxDecoration(
                              color: weeks[i].amount == 0
                                  ? baseline
                                  : AppColors.brand.withValues(
                                      alpha: i == selected ? 1 : 0.72),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(height: 1, color: baseline),
          const SizedBox(height: 6),
          Row(
            children: [
              for (var i = 0; i < weeks.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    // Подписи через одну: восемь дат в строку не влезают.
                    i.isEven || i == weeks.length - 1
                        ? (i == weeks.length - 1
                            ? tr.wallet.thisWeekShort
                            : '${weeks[i].start.day}.'
                                '${weeks[i].start.month.toString().padLeft(2, '0')}')
                        : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: i == selected ? ink : muted,
                      fontWeight:
                          i == selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// «неделя с 6 окт» — или «эта неделя».
  String _weekLabel(DateTime start) {
    if (start == widget.weeks.last.start) return tr.wallet.thisWeek;
    return tr.wallet.weekFrom(tr.core.dayMonthShort(start));
  }
}
