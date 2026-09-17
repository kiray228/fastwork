import 'package:flutter/material.dart';

import 'data/session.dart';
import 'data/shift_repository.dart';
import 'shift.dart';
import 'shift_detail_page.dart';
import 'theme/app_colors.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';
import 'widgets/nav.dart';
import 'widgets/review_sheet.dart';
import 'widgets/shift_card.dart';
import 'widgets/skeleton.dart';

/// «Мои подработки»: две вкладки над одними и теми же данными.
///
/// Архив — это не отдельная таблица и не отдельный список.
/// Это тот же запрос к той же таблице, только с другим условием.
class MyShiftsPage extends StatefulWidget {
  final ShiftRepository repository;
  final AppSession session;

  const MyShiftsPage({
    super.key,
    required this.repository,
    required this.session,
  });

  @override
  State<MyShiftsPage> createState() => _MyShiftsPageState();
}

class _MyShiftsPageState extends State<MyShiftsPage> {
  bool archived = false;
  Async<List<Shift>> state = const Loading();

  /// Номера смен, о которых отзыв уже оставлен.
  Set<int> reviewed = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await load(() async {
      final loaded = await widget.repository.myShifts(archived: archived);

      // Для архива узнаём, по каким сменам отзыв уже есть — чтобы не
      // предлагать оценить одно и то же дважды.
      final done = <int>{};
      if (archived) {
        for (final shift in loaded) {
          if (await widget.repository.hasReviewed(shift.id)) done.add(shift.id);
        }
      }
      return (loaded, done);
    });

    if (!mounted) return;
    setState(() {
      switch (result) {
        case Ready(value: (final loaded, final done)):
          state = Ready(loaded);
          reviewed = done;
        case Failed(:final error):
          state = Failed(error);
        case Loading():
          break;
      }
    });
  }

  /// Оценить место работы после смены.
  Future<void> _review(Shift shift) async {
    final input = await showReviewSheet(context, shift);
    if (input == null || !mounted) return;

    await widget.repository.addReview(
      shiftId: shift.id,
      rating: input.rating,
      comment: input.comment,
    );
    await _load();
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Спасибо! Отзыв опубликован')));
  }

  void _switchTab(bool value) {
    setState(() {
      archived = value;
      state = const Loading();
    });
    _load();
  }

  Future<void> _openShift(Shift shift) async {
    await Navigator.of(context).push(
      appRoute(
        ShiftDetailPage(
          shiftId: shift.id,
          repository: widget.repository,
          session: widget.session,
        ),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои подработки')),
      body: Column(
        children: [
          _Tabs(archived: archived, onChanged: _switchTab),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child: switch (state) {
                Loading() => const ShiftListSkeleton(count: 2),
                Failed(:final error) => ErrorView(
                  message: describeError(error),
                  onRetry: () {
                    setState(() => state = const Loading());
                    _load();
                  },
                ),
                Ready(value: []) => EmptyState(
                  icon: archived
                      ? Icons.inventory_2_outlined
                      : Icons.assignment_outlined,
                  title: 'Пока пусто',
                  subtitle: archived
                      ? 'Сюда попадут завершённые\nи отменённые подработки'
                      : 'Найдите смену на вкладке «Смены»\nи оставьте заявку',
                ),
                Ready(:final value) => ListView.builder(
                  key: ValueKey(archived),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final shift = value[index];
                    final isPast = shift.workDate.isBefore(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      ),
                    );

                    return AnimatedEntrance(
                      index: index,
                      child: Column(
                        children: [
                          ShiftCard(
                            shift: shift,
                            userRating: widget.session.rating,
                            onTap: () => _openShift(shift),
                          ),
                          // Оценить можно только уже отработанную смену.
                          if (archived && isPast)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: reviewed.contains(shift.id)
                                  ? const TagChip(
                                      text: 'Отзыв оставлен',
                                      icon: Icons.check_rounded,
                                      color: AppColors.brand,
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: () => _review(shift),
                                        icon: const Icon(
                                          Icons.star_outline_rounded,
                                          size: 18,
                                        ),
                                        label: const Text(
                                          'Оценить место работы',
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: const Size.fromHeight(
                                            46,
                                          ),
                                          foregroundColor: AppColors.brand,
                                          side: const BorderSide(
                                            color: AppColors.brand,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Переключатель «В работе / Архив».
class _Tabs extends StatelessWidget {
  final bool archived;
  final ValueChanged<bool> onChanged;

  const _Tabs({required this.archived, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          _TabButton(
            label: 'В работе',
            selected: !archived,
            onTap: () => onChanged(false),
          ),
          _TabButton(
            label: 'Архив',
            selected: archived,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.brand : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}
