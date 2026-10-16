import 'package:flutter/material.dart';

import 'data/session.dart';
import 'l10n/strings.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/shift.dart';
import 'shift_detail_page.dart';
import 'theme/app_colors.dart';
import 'theme/glass.dart';
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

  /// Перейти в ленту — с пустого списка «В работе».
  final VoidCallback? onFindShifts;

  const MyShiftsPage({
    super.key,
    required this.repository,
    required this.session,
    this.onFindShifts,
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

  /// Номер последнего запроса: быстро переключили вкладку туда и обратно —
  /// ответ для старой вкладки не должен лечь в новую.
  int _loadSeq = 0;

  Future<void> _load() async {
    final seq = ++_loadSeq;
    final tab = archived;
    final result = await load(() async {
      final loaded = await widget.repository.myShifts(archived: tab);

      // Для архива узнаём, по каким сменам отзыв уже есть — чтобы не
      // предлагать оценить одно и то же дважды. Оценить можно только
      // отработанную смену, поэтому про отменённые не спрашиваем, а про
      // остальные — разом, а не по одной: тридцать смен по очереди — это
      // тридцать запросов подряд и полминуты скелетона.
      final done = <int>{};
      if (tab) {
        final completed = loaded.where((s) => s.isCompleted).toList();
        final answers = await Future.wait(
            completed.map((s) => widget.repository.hasReviewed(s.id)));
        for (var i = 0; i < completed.length; i++) {
          if (answers[i]) done.add(completed[i].id);
        }
      }
      return (loaded, done);
    });

    if (!mounted || seq != _loadSeq) return;
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

    final saved = await guardedDone(
      context,
      () => widget.repository.addReview(
        shiftId: shift.id,
        rating: input.rating,
        comment: input.comment,
      ),
    );
    await _load();
    if (!saved && mounted) return;
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(tr.profile.reviewThanksSnack)));
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
      appBar: AppBar(title: Text(tr.profile.myShiftsTitle)),
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
                Ready(value: []) => RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      EmptyState(
                        icon: archived
                            ? Icons.inventory_2_outlined
                            : Icons.assignment_outlined,
                        title: tr.profile.myShiftsEmptyTitle,
                        subtitle: archived
                            ? tr.profile.myShiftsEmptyArchive
                            : tr.profile.myShiftsEmptyActive,
                        actionLabel: archived ? null : tr.profile.myShiftsFind,
                        onAction: archived ? null : widget.onFindShifts,
                      ),
                    ],
                  ),
                ),
                // Потянуть вниз — узнать, подтвердил ли заказчик выход.
                Ready(:final value) => RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    key: ValueKey(archived),
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: value.length + (archived ? 0 : 1),
                    itemBuilder: (context, rawIndex) {
                      // «В работе» начинается с итога: сколько смен впереди
                      // и сколько за них придёт. Ради этого числа человек
                      // и выходит на смены.
                      if (!archived && rawIndex == 0) {
                        return _UpcomingTotal(shifts: value);
                      }
                      final index = archived ? rawIndex : rawIndex - 1;
                      final shift = value[index];
                      final now = DateTime.now();

                      return AnimatedEntrance(
                        index: index,
                        child: Column(
                          children: [
                            ShiftCard(
                              shift: shift,
                              userRating: widget.session.rating,
                              onTap: () => _openShift(shift),
                            ),
                            if (archived)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _ArchiveFooter(
                                  shift: shift,
                                  now: now,
                                  reviewed: reviewed.contains(shift.id),
                                  onReview: () => _review(shift),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
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
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: glassFieldFill(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: glassFieldEdge(context),
        ),
      ),
      child: Row(
        children: [
          _TabButton(
            label: tr.profile.tabActive,
            selected: !archived,
            onTap: () => onChanged(false),
          ),
          _TabButton(
            label: tr.profile.tabArchive,
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
      // Экранному чтецу — что это кнопка и какая вкладка выбрана.
      child: Semantics(
        button: true,
        selected: selected,
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
      ),
    );
  }
}

/// Что показать под карточкой в архиве.
///
/// Прошедшая смена может кончиться тремя разными способами, и человеку
/// важно видеть, каким именно: отработал и подтверждено, отметки не было,
/// или запись отменена. Раньше всё это выглядело одинаково.
class _ArchiveFooter extends StatelessWidget {
  final Shift shift;
  final DateTime now;
  final bool reviewed;
  final VoidCallback onReview;

  const _ArchiveFooter({
    required this.shift,
    required this.now,
    required this.reviewed,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    // Отменил заказчик — это не то же самое, что «человек передумал».
    // Раньше обе истории выглядели одинаково: «Запись отменена», и
    // выходило, будто исполнитель сам отказался.
    if (shift.isCancelled) {
      return TagChip(
        text: tr.profile.archiveCancelledByEmployer,
        icon: Icons.event_busy_rounded,
        color: AppColors.danger,
      );
    }

    // Невыход — не то же самое, что «запись отменена». Человек должен
    // видеть отметку: она влияет на его надёжность, и если заказчик
    // ошибся, есть повод написать в поддержку.
    if (shift.isNoShow) {
      return TagChip(
        text: tr.profile.archiveNoShow,
        icon: Icons.person_off_outlined,
        color: AppColors.danger,
      );
    }

    if (shift.isUnconfirmedOn(now)) {
      return TagChip(
        text: tr.profile.archiveUnconfirmed,
        icon: Icons.help_outline_rounded,
        color: AppColors.muted,
      );
    }

    if (!shift.isCompleted) {
      return TagChip(
        text: tr.profile.archiveBookingCancelled,
        icon: Icons.close_rounded,
        color: AppColors.muted,
      );
    }

    // Отработанную смену можно оценить — но только один раз.
    if (reviewed) {
      return TagChip(
        text: tr.profile.archiveReviewed,
        icon: Icons.check_rounded,
        color: AppColors.brand,
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onReview,
        icon: const Icon(Icons.star_outline_rounded, size: 18),
        label: Text(tr.profile.archiveRateWorkplace),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(46),
          foregroundColor: AppColors.brand,
          side: const BorderSide(color: AppColors.brand),
        ),
      ),
    );
  }
}

/// Итог над «В работе»: сколько смен впереди и сколько за них заплатят.
class _UpcomingTotal extends StatelessWidget {
  final List<Shift> shifts;

  const _UpcomingTotal({required this.shifts});

  @override
  Widget build(BuildContext context) {
    final booked = [
      for (final s in shifts)
        if (s.isApplied && !s.isCancelled) s,
    ];
    if (booked.isEmpty) return const SizedBox.shrink();
    final total = booked.fold(0, (sum, s) => sum + s.totalPay);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined,
              size: 18, color: AppColors.brand),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tr.profile.upcomingTotal(
                  shiftsLabel(booked.length), formatMoney(total)),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

