import 'package:flutter/material.dart';

import '../data/app_preferences.dart';
import '../data/repositories.dart';
import '../data/session.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/shift.dart';
import '../theme/app_colors.dart';
import 'package:fastwork_core/user.dart';
import '../widgets/async_state.dart';
import '../widgets/common.dart';
import '../widgets/nav.dart';
import '../stories/story_actions.dart';
import '../widgets/skeleton.dart';
import '../widgets/stories_row.dart';
import 'create_shift_page.dart';

/// Смены, созданные заказчиком, и кто на них записался.
class ManagerShiftsPage extends StatefulWidget {
  final AppSession session;
  final AppRepositories repos;
  final AppPreferences preferences;

  /// Переключить вкладку нижнего меню: 1 — «Создать», 2 — «Оценки».
  final ValueChanged<int> onOpenTab;

  const ManagerShiftsPage({
    super.key,
    required this.session,
    required this.repos,
    required this.preferences,
    required this.onOpenTab,
  });

  @override
  State<ManagerShiftsPage> createState() => _ManagerShiftsPageState();
}

class _ManagerShiftsPageState extends State<ManagerShiftsPage> {
  Async<List<Shift>> state = const Loading();

  ShiftRepository get repository => widget.repos.shifts;

  late final stories = storiesFor(widget.session);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await load(
      () => repository.shiftsCreatedBy(widget.session.workerId),
    );
    if (!mounted) return;
    setState(() => state = result);
  }

  /// Отменить смену. Спрашиваем подтверждение: действие видят все
  /// записавшиеся, и «случайно нажал» здесь обходится дорого.
  Future<void> _cancelShift(Shift shift) async {
    final agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отменить смену?'),
        content: Text(
          shift.workersHired > 0
              ? 'На смену записались ${shift.workersHired} чел. '
                  'Все получат уведомление, что выходить не нужно.'
              : 'Смена пропадёт из ленты. Вернуть её будет нельзя — '
                  'нужно будет создать новую.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Нет'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Отменить смену'),
          ),
        ],
      ),
    );
    if (agreed != true || !mounted) return;

    final result = await guarded(
      context,
      () => repository.cancelShift(shift.id),
    );
    if (result == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(switch (result) {
          BookingResult.ok => 'Смена отменена',
          BookingResult.notMine => 'Это не ваша смена',
          BookingResult.alreadyCancelled => 'Смена уже отменена',
          _ => 'Смену не удалось отменить',
        }),
        behavior: SnackBarBehavior.floating,
      ),
    );
    await _load();
  }

  Future<void> _editShift(Shift shift) async {
    await Navigator.of(context).push(
      appRoute(
        CreateShiftPage(
          session: widget.session,
          repository: repository,
          editing: shift,
          onCreated: () => Navigator.of(context).pop(),
        ),
      ),
    );
    await _load();
  }

  Future<void> _openApplicants(Shift shift) async {
    await Navigator.of(context).push(
      appRoute(
        _ApplicantsPage(shift: shift, repository: repository),
      ),
    );
    await _load();
  }

  Future<void> _openStory(int index) => openStories(
        context,
        session: widget.session,
        repos: widget.repos,
        preferences: widget.preferences,
        initialIndex: index,
        onCreateShift: () => widget.onOpenTab(1),
        onRateWorkers: () => widget.onOpenTab(2),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои смены')),
      // Истории листаются вместе со сменами, как у исполнителя.
      body: RefreshIndicator(
        onRefresh: _load,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: StoriesRow(
                stories: stories,
                preferences: widget.preferences,
                onOpen: _openStory,
              ),
            ),
            ...switch (state) {
              Loading() => [
                  const SliverToBoxAdapter(
                    child: ShiftListSkeleton(count: 2, shrinkWrap: true),
                  ),
                ],
              Failed(:final error) => [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: ErrorView(
                      message: describeError(error),
                      onRetry: () {
                        setState(() => state = const Loading());
                        _load();
                      },
                    ),
                  ),
                ],
              Ready(value: []) => [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: Icons.post_add_rounded,
                      title: 'Смен пока нет',
                      subtitle: 'Опубликуйте первую — люди увидят её\n'
                          'в ленте сразу после оплаты',
                      actionLabel: 'Создать смену',
                      onAction: () => widget.onOpenTab(1),
                    ),
                  ),
                ],
              Ready(:final value) => [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: SliverList.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) => AnimatedEntrance(
                        index: index,
                        child: _ManagerShiftCard(
                          shift: value[index],
                          onTap: () => _openApplicants(value[index]),
                          onCancel: () => _cancelShift(value[index]),
                          onEdit: () => _editShift(value[index]),
                        ),
                      ),
                    ),
                  ),
                ],
            },
          ],
        ),
      ),
    );
  }
}

class _ManagerShiftCard extends StatelessWidget {
  final Shift shift;
  final VoidCallback onTap;
  final VoidCallback onCancel;
  final VoidCallback onEdit;

  const _ManagerShiftCard({
    required this.shift,
    required this.onTap,
    required this.onCancel,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPast = shift.workDate.isBefore(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SurfaceCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    shift.title,
                    style: text.titleMedium?.copyWith(fontSize: 15),
                  ),
                ),
                if (shift.isCancelled)
                  const TagChip(text: 'Отменена', color: AppColors.danger)
                else if (isPast)
                  const TagChip(text: 'Прошла')
                else if (!shift.hasFreeSlots)
                  const TagChip(text: 'Набрана', color: AppColors.brand)
                else
                  TagChip(
                    text: 'Идёт набор',
                    color: AppColors.accent,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            InfoRow(
              icon: Icons.calendar_today_rounded,
              text: '${shift.workDate.day} '
                  '${monthsShort[shift.workDate.month - 1]} · '
                  '${formatTime(shift.startMinutes)}—'
                  '${formatTime(shift.endMinutes)}',
            ),
            InfoRow(
              icon: Icons.payments_outlined,
              text: '${formatMoney(shift.totalPay)} за смену · '
                  '${formatMoney(shift.hourlyRate)}/ч',
            ),
            // Где сейчас деньги: у сервиса или уже вернулись.
            if (shift.isFunded)
              InfoRow(
                icon: Icons.verified_user_outlined,
                iconColor: AppColors.success,
                text: 'Оплачено ${formatMoney(ShiftCost.of(shift).total)} — '
                    'деньги у сервиса до подтверждения выхода',
              )
            else if (shift.isCancelled)
              const InfoRow(
                icon: Icons.undo_rounded,
                iconColor: AppColors.muted,
                text: 'Неизрасходованное возвращено на карту',
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: shift.workersHired / shift.workersNeeded,
                      minHeight: 8,
                      backgroundColor:
                          isDark ? AppColors.darkBorder : AppColors.border,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.brand),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${shift.workersHired} / ${shift.workersNeeded}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.group_outlined,
                    size: 15, color: AppColors.muted),
                const SizedBox(width: 6),
                // Flexible, а не просто Text: рядом стоит кнопка «Отменить»,
                // и на узком экране двое в строку не помещались — карточка
                // ругалась полосатой лентой поверх текста.
                const Flexible(
                  child: Text(
                    'Посмотреть записавшихся',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brand,
                    ),
                  ),
                ),
                const Spacer(),
                // Отменить можно только смену, которая ещё впереди:
                // прошедшую отменять поздно, отменённую — незачем.
                if (!isPast && !shift.isCancelled) ...[
                  TextButton(
                    onPressed: onEdit,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.brand,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Изменить',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: onCancel,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Отменить',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ] else
                  const Icon(Icons.chevron_right_rounded,
                      size: 18, color: AppColors.muted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Кто записался на смену.
class _ApplicantsPage extends StatefulWidget {
  final Shift shift;
  final ShiftRepository repository;

  const _ApplicantsPage({required this.shift, required this.repository});

  @override
  State<_ApplicantsPage> createState() => _ApplicantsPageState();
}

class _ApplicantsPageState extends State<_ApplicantsPage> {
  Async<List<ShiftApplicant>> state = const Loading();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result =
        await load(() => widget.repository.applicantsFor(widget.shift.id));
    if (!mounted) return;
    setState(() => state = result);
  }

  Future<void> _markNoShow(ShiftApplicant applicant) async {
    final agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отметить невыход?'),
        content: Text(
          '${applicant.user.fullName} не вышел на смену. '
          'Отметка видна другим заказчикам и влияет на надёжность — '
          'ставьте её, только если человек действительно не пришёл.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Не вышел'),
          ),
        ],
      ),
    );
    if (agreed != true || !mounted) return;

    final result = await guarded(
      context,
      () => widget.repository.markNoShow(
        shiftId: widget.shift.id,
        workerId: applicant.user.id,
      ),
    );
    if (result == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result == BookingResult.ok
            ? 'Отмечено: ${applicant.user.fullName} не вышел'
            : 'Не получилось отметить'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    await _load();
  }

  Future<void> _confirm(ShiftApplicant applicant) async {
    final result = await guarded(
      context,
      () => widget.repository.confirmAttendance(
        shiftId: widget.shift.id,
        workerId: applicant.user.id,
      ),
    );
    if (result == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result == BookingResult.ok
            ? 'Смена засчитана: ${applicant.user.fullName}'
            : 'Это не ваша смена'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Записались')),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: switch (state) {
          Loading() => const TileListSkeleton(count: 3),
          Failed(:final error) => ErrorView(
              message: describeError(error),
              onRetry: () {
                setState(() => state = const Loading());
                _load();
              },
            ),
          Ready(value: []) => const EmptyState(
              icon: Icons.person_search_rounded,
              title: 'Пока никто не записался',
              subtitle: 'Смена опубликована — исполнители её видят',
            ),
          Ready(:final value) => ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: value.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _AttendanceHint(shift: widget.shift);
                final item = value[index - 1];
                final canMark = DateTime.now().isAfter(widget.shift.startsAt);
                return AnimatedEntrance(
                  index: index,
                  child: _ApplicantTile(
                    applicant: item,
                    // Отмечать можно только после начала смены: раньше
                    // просто не о чем говорить — человек ещё не опоздал.
                    //
                    // Раньше «Подтвердить» показывалось лишь тем, кто
                    // отметился. Но отметка — дело добровольное: человек
                    // мог отработать и не нажать кнопку, и заказчик
                    // оставался без возможности засчитать ему смену.
                    onConfirm: canMark && item.isUnmarked
                        ? () => _confirm(item)
                        : null,
                    onNoShow: canMark && item.isUnmarked
                        ? () => _markNoShow(item)
                        : null,
                  ),
                );
              },
            ),
        },
      ),
    );
  }
}

/// Объяснение, откуда берутся отметки.
class _AttendanceHint extends StatelessWidget {
  final Shift shift;

  const _AttendanceHint({required this.shift});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SurfaceCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.how_to_reg_outlined,
                size: 18, color: AppColors.brand),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Исполнитель отмечается сам в день смены. Подтвердите '
                'выход — только после этого смена идёт в оплату.',
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.35,
                  color: AppColors.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicantTile extends StatelessWidget {
  final ShiftApplicant applicant;
  final VoidCallback? onConfirm;
  final VoidCallback? onNoShow;

  const _ApplicantTile({
    required this.applicant,
    this.onConfirm,
    this.onNoShow,
  });

  @override
  Widget build(BuildContext context) {
    final user = applicant.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.brand, AppColors.brandDark],
                    ),
                  ),
                  child: Text(
                    user.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 14, color: AppColors.accent),
                          const SizedBox(width: 3),
                          Text(
                            user.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Flexible не даёт подписи вытолкнуть ярлык
                          // состояния за край карточки.
                          Flexible(
                            child: Text(
                              user.isVerified
                                  ? 'Верифицирован'
                                  : 'Без проверки',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: user.isVerified
                                    ? AppColors.brand
                                    : AppColors.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (applicant.isConfirmed)
                  const TagChip(
                    text: 'Отработал',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.brand,
                  )
                else if (applicant.isNoShow)
                  const TagChip(
                    text: 'Не вышел',
                    icon: Icons.person_off_outlined,
                    color: AppColors.danger,
                  )
                else if (applicant.isCheckedIn)
                  const TagChip(
                    text: 'На месте',
                    icon: Icons.location_on_outlined,
                    color: AppColors.accent,
                  )
                else
                  const TagChip(text: 'Записан'),
              ],
            ),
            // Надёжность показываем, только если есть о чём говорить:
            // у новичка «100%» из ниоткуда — не похвала, а пустой звук.
            if (applicant.user.hasAttendanceRecord &&
                applicant.user.noShows > 0) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.person_off_outlined,
                      size: 14, color: AppColors.warning),
                  const SizedBox(width: 6),
                  // Flexible с многоточием: на узкой карточке строка
                  // не помещалась и вылезала полосатой лентой за край.
                  Flexible(
                    child: Text(
                      'Выходит: ${applicant.user.reliabilityPercent}% · '
                      'невыходов ${applicant.user.noShows}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (applicant.checkedInAt != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded,
                      size: 14, color: AppColors.muted),
                  const SizedBox(width: 6),
                  Text(
                    'Отметился в '
                    '${formatTime(applicant.checkedInAt!.hour * 60 + applicant.checkedInAt!.minute)}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ],
            if (onConfirm != null || onNoShow != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (onConfirm != null)
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onConfirm,
                        icon: const Icon(Icons.check_rounded, size: 18),
                        label: const Text('Вышел'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(44),
                        ),
                      ),
                    ),
                  if (onConfirm != null && onNoShow != null)
                    const SizedBox(width: 10),
                  if (onNoShow != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onNoShow,
                        icon: const Icon(Icons.close_rounded, size: 18),
                        label: const Text('Не вышел'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(44),
                          foregroundColor: AppColors.danger,
                          side: const BorderSide(color: AppColors.danger),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
