import 'package:flutter/material.dart';

import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/user.dart';
import 'l10n/strings.dart';
import 'theme/app_colors.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';

/// «Когда вы свободны?» — дни на две недели вперёд.
///
/// Человек отмечает дни, когда готов выйти, а заказчик смены, которой
/// не хватает людей, видит его в списке «Свободны в этот день» и может
/// позвать. Лента ждёт, пока человек сам найдёт смену; эта карточка —
/// чтобы смена могла найти его.
class AvailabilityCard extends StatefulWidget {
  final ShiftRepository repository;

  const AvailabilityCard({super.key, required this.repository});

  @override
  State<AvailabilityCard> createState() => _AvailabilityCardState();
}

class _AvailabilityCardState extends State<AvailabilityCard> {
  Set<DateTime> days = {};

  /// Дни, по которым запрос ещё в пути, — их кнопки не нажимаются.
  final pending = <DateTime>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Узнать тихо: не узнали — все дни пустые, отметить можно заново.
  Future<void> _load() async {
    try {
      final value = await widget.repository.availability();
      if (mounted) setState(() => days = value);
    } catch (_) {}
  }

  Future<void> _toggle(DateTime day) async {
    final on = !days.contains(day);
    // Сразу на экране — ответ сервера не заставляет ждать каждое касание.
    setState(() {
      pending.add(day);
      on ? days.add(day) : days.remove(day);
    });
    final done = await guardedDone(
      context,
      () => widget.repository.setAvailable(day, available: on),
    );
    if (!mounted) return;
    setState(() {
      pending.remove(day);
      // Не сохранилось — возвращаем как было.
      if (!done) on ? days.remove(day) : days.add(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final ahead = [
      for (var i = 0; i < kAvailabilityDays; i++)
        DateTime(today.year, today.month, today.day + i),
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              icon: Icons.event_available_rounded,
              title: tr.profile.availabilityTitle,
            ),
            const SizedBox(height: 6),
            Text(
              days.isEmpty
                  ? tr.profile.availabilityHint
                  : tr.profile.availabilityMarked(days.length),
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.muted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final day in ahead)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(
                          '${tr.core.weekdaysShort[day.weekday - 1]} '
                          '${day.day}',
                        ),
                        selected: days.contains(day),
                        // Отмеченный день должен читаться с первого
                        // взгляда: в тёмной теме одна заливка почти
                        // сливалась с фоном.
                        showCheckmark: true,
                        checkmarkColor: AppColors.brand,
                        selectedColor: AppColors.brand.withValues(alpha: 0.22),
                        side: BorderSide(
                          color: days.contains(day)
                              ? AppColors.brand
                              : Colors.transparent,
                        ),
                        onSelected: pending.contains(day)
                            ? null
                            : (_) => _toggle(day),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
