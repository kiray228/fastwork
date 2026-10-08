import 'package:flutter/material.dart';

import '../data/app_preferences.dart';
import '../data/repositories.dart';
import '../data/session.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/stats.dart';
import '../theme/app_colors.dart';
import 'package:fastwork_core/user.dart';
import '../widgets/async_state.dart';
import '../widgets/common.dart';
import '../widgets/nav.dart';
import '../widgets/payment_sheet.dart';
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

  /// История платежей — для сводки «потрачено за месяц».
  List<WalletEntry> payments = const [];

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
    await _loadPayments();
  }

  /// Платежи грузим отдельно и молча: если они не ответят, смены всё
  /// равно должны показаться — без сводки, но со списком.
  Future<void> _loadPayments() async {
    try {
      final summary = await widget.repos.wallet.summary();
      if (!mounted) return;
      setState(() => payments = summary.entries);
    } catch (_) {
      // Нет истории — нет и строки «потрачено».
    }
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
          BookingResult.alreadyStarted =>
            'Смена уже началась — отменить её нельзя',
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

  /// Выставить такую же смену ещё раз — на другой день.
  Future<void> _repeatShift(Shift shift) async {
    await Navigator.of(context).push(
      appRoute(
        CreateShiftPage(
          session: widget.session,
          repository: repository,
          template: shift,
          onCreated: () => Navigator.of(context).pop(),
        ),
      ),
    );
    await _load();
  }

  /// Оплатить смену, которая так и не оплачена.
  Future<void> _payShift(Shift shift) async {
    final cost = ShiftCost.of(shift);
    final result = await showCheckoutSheet(
      context,
      title: 'Оплата смены',
      note: 'Смена появится в ленте, как только пройдёт оплата.',
      lines: [
        PaymentLine(
          'Вознаграждение: ${cost.slots} × ${formatMoney(cost.slotPay)}',
          cost.pay,
        ),
        PaymentLine('Комиссия сервиса $kPlatformFeePercent%', cost.fee),
      ],
      total: cost.total,
      actionLabel: 'Оплатить ${formatMoney(cost.total)}',
      phone: widget.session.user?.phone ?? '',
      start: (method, phone, _) =>
          repository.retryPayment(shift.id, method: method, phone: phone),
      status: repository.paymentStatus,
      completeSandbox: (id, card) =>
          repository.completeSandboxPayment(id, card: card),
    );
    await _load();
    if (!mounted || result == null || !result.isPaid) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Смена опубликована')),
    );
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                      child: _StatsRow(
                        stats: employerStats(value, payments, DateTime.now()),
                      ),
                    ),
                  ),
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
                          onRepeat: () => _repeatShift(value[index]),
                          onPay: () => _payShift(value[index]),
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

/// Сводка заказчика: три числа над списком смен.
///
/// Не график, а числа: заказчику важно увидеть итог одним взглядом —
/// сколько смен прошло, набираются ли они и во что обошлись.
class _StatsRow extends StatelessWidget {
  final EmployerStats stats;

  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    final month = DateTime.now().month;
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            value: '${stats.shifts}',
            label: 'смен за 30 дней',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            value: stats.fillPercent == null ? '—' : '${stats.fillPercent}%',
            label: 'мест заполнено',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            value: formatMoney(stats.spentThisMonth),
            label: 'потрачено в ${_monthsIn[month - 1]}',
          ),
        ),
      ],
    );
  }

  static const _monthsIn = [
    'январе', 'феврале', 'марте', 'апреле', 'мае', 'июне',
    'июле', 'августе', 'сентябре', 'октябре', 'ноябре', 'декабре',
  ];
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;

  const _StatTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkInk : AppColors.ink,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.25,
              color: isDark ? AppColors.darkMuted : AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ManagerShiftCard extends StatelessWidget {
  final Shift shift;
  final VoidCallback onTap;
  final VoidCallback onCancel;
  final VoidCallback onEdit;
  final VoidCallback onRepeat;
  final VoidCallback onPay;

  const _ManagerShiftCard({
    required this.shift,
    required this.onTap,
    required this.onCancel,
    required this.onEdit,
    required this.onRepeat,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final isPast = shift.isPastOn(now);
    // Началась — условия заморожены: ни правки, ни отмены. То же правило
    // проверяет и хранилище; здесь оно только прячет кнопки, которые всё
    // равно ответили бы отказом.
    final started = shift.hasStartedAt(now);

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
                else if (shift.awaitingPayment)
                  const TagChip(
                    text: 'Ждёт оплаты',
                    icon: Icons.hourglass_top_rounded,
                    color: AppColors.warning,
                  )
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
            // Где сейчас деньги: у сервиса, ещё не пришли или вернулись.
            if (shift.awaitingPayment && !shift.isCancelled) ...[
              const InfoRow(
                icon: Icons.visibility_off_outlined,
                iconColor: AppColors.warning,
                text: 'Исполнители не видят смену, пока она не оплачена',
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onPay,
                  icon: const Icon(Icons.lock_rounded, size: 18),
                  label: Text(
                      'Оплатить ${formatMoney(ShiftCost.of(shift).total)}'),
                ),
              ),
            ] else if (shift.isFunded)
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
                // Отменить можно только смену, которая ещё не началась:
                // начавшуюся отменять поздно, отменённую — незачем.
                if (!started && !shift.isCancelled) ...[
                  // Неоплаченную не правим: за неё могут платить по
                  // старой цене прямо сейчас.
                  if (!shift.awaitingPayment)
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
                  // Повтор — значком: три слова в строку на узком
                  // экране не помещаются.
                  IconButton(
                    onPressed: onRepeat,
                    tooltip: 'Повторить',
                    icon: const Icon(Icons.replay_rounded, size: 18),
                    color: AppColors.brand,
                    visualDensity: VisualDensity.compact,
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                    padding: EdgeInsets.zero,
                  ),
                ] else
                  // Прошедшую и отменённую уже не правят — зато такую же
                  // можно выставить снова одним касанием.
                  TextButton.icon(
                    onPressed: onRepeat,
                    icon: const Icon(Icons.replay_rounded, size: 16),
                    label: const Text(
                      'Повторить',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.brand,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
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

  /// Код отметки этой смены. null — ещё не пришёл или смена не своя.
  String? code;

  @override
  void initState() {
    super.initState();
    _load();
    _loadCode();
  }

  /// Код показываем, пока смена не закончилась: после неё он ни к чему.
  Future<void> _loadCode() async {
    if (!widget.shift.isAheadAt(DateTime.now()) || widget.shift.isCancelled) {
      return;
    }
    try {
      final value = await widget.repository.checkInCode(widget.shift.id);
      if (mounted) setState(() => code = value);
    } catch (_) {
      // Нет кода — люди отметятся и без него.
    }
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
        content: Text(switch (result) {
          BookingResult.ok => 'Отмечено: ${applicant.user.fullName} не вышел',
          BookingResult.notStarted =>
            'Смена ещё не началась — отмечать невыход рано',
          _ => 'Не получилось отметить',
        }),
        behavior: SnackBarBehavior.floating,
      ),
    );
    await _load();
  }

  /// Добавить в любимые или убрать оттуда.
  ///
  /// Любимым приходит приглашение, как только заказчик опубликует новую
  /// смену, — так хорошие люди возвращаются, а смены набираются быстрее.
  Future<void> _toggleFavorite(ShiftApplicant applicant) async {
    final favorite = !applicant.isFavorite;
    final result = await guarded(
      context,
      () => widget.repository.setFavorite(
        workerId: applicant.user.id,
        favorite: favorite,
      ),
    );
    if (result == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(switch (result) {
          BookingResult.ok when favorite =>
            '${applicant.user.fullName} — в любимых. Позовём на ваши '
                'следующие смены',
          BookingResult.ok => '${applicant.user.fullName} убран из любимых',
          _ => 'В любимые — только тех, кто у вас уже отработал',
        }),
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
        content: Text(switch (result) {
          BookingResult.ok => 'Смена засчитана: ${applicant.user.fullName}',
          BookingResult.notStarted =>
            'Смена ещё не началась — засчитать её можно после начала',
          BookingResult.notMine => 'Это не ваша смена',
          _ => 'Не получилось засчитать',
        }),
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
                if (index == 0) {
                  return Column(
                    children: [
                      if (code != null) _CheckInCodeCard(code: code!),
                      _AttendanceHint(shift: widget.shift),
                    ],
                  );
                }
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
                    onFavorite:
                        item.isConfirmed ? () => _toggleFavorite(item) : null,
                  ),
                );
              },
            ),
        },
      ),
    );
  }
}

/// Код отметки крупно — чтобы показать экран людям на точке.
class _CheckInCodeCard extends StatelessWidget {
  final String code;

  const _CheckInCodeCard({required this.code});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.brand, AppColors.brandDark],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              'Код отметки',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              code.split('').join(' '),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Покажите его людям на месте: кто введёт код, '
              'тот точно пришёл',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.35,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
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

  /// В любимые — только тех, кто отработал. null — сердечка нет.
  final VoidCallback? onFavorite;

  const _ApplicantTile({
    required this.applicant,
    this.onConfirm,
    this.onNoShow,
    this.onFavorite,
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
                if (onFavorite != null)
                  IconButton(
                    onPressed: onFavorite,
                    tooltip: applicant.isFavorite
                        ? 'Убрать из любимых'
                        : 'В любимые исполнители',
                    icon: Icon(
                      applicant.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: AppColors.accent,
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
                  TagChip(
                    // По коду — человек точно был на точке; без кода —
                    // только нажал кнопку.
                    text: applicant.checkInVerified ? 'На месте · код' : 'На месте',
                    icon: applicant.checkInVerified
                        ? Icons.verified_rounded
                        : Icons.location_on_outlined,
                    color: applicant.checkInVerified
                        ? AppColors.brand
                        : AppColors.accent,
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
