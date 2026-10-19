import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/app_preferences.dart';
import '../data/repositories.dart';
import '../data/session.dart';
import '../chat_page.dart';
import '../my_reviews_page.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/stats.dart';
import '../l10n/strings.dart';
import '../theme/app_colors.dart';
import '../theme/glass.dart';
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
    // Поздно отменять — значит платить записавшимся компенсацию. Сумму
    // заказчик должен увидеть до того, как нажмёт, а не в выписке.
    final late = shift.workersHired > 0 &&
        shift.isFunded &&
        shift.isLateCancelAt(DateTime.now());
    final each = shift.lateCancelCompensation;
    final agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.manager.cancelShiftTitle),
        content: Text(
          [
            shift.workersHired > 0
                ? tr.manager.cancelShiftHired(shift.workersHired)
                : tr.manager.cancelShiftEmpty,
            if (late)
              tr.manager.cancelLateWarning(
                shift.workersHired,
                formatMoney(each),
                formatMoney(each * shift.workersHired),
                shift.cancelDeadlineHours,
              ),
          ].join('\n\n'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(tr.manager.no),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(tr.manager.cancelShiftButton),
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
          BookingResult.ok => tr.manager.shiftCancelled,
          BookingResult.notMine => tr.manager.notYourShift,
          BookingResult.alreadyCancelled => tr.manager.shiftAlreadyCancelled,
          BookingResult.alreadyStarted => tr.manager.cancelTooLate,
          _ => tr.manager.cancelFailed,
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
      title: tr.manager.paymentTitle,
      note: tr.manager.payExistingNote,
      lines: [
        PaymentLine(
          tr.manager.rewardLine(cost.slots, formatMoney(cost.slotPay)),
          cost.pay,
        ),
        PaymentLine(tr.manager.serviceFee(kPlatformFeePercent), cost.fee),
      ],
      total: cost.total,
      actionLabel: tr.manager.payAmount(formatMoney(cost.total)),
      phone: widget.session.user?.phone ?? '',
      start: (method, phone, _) =>
          repository.retryPayment(shift.id, method: method, phone: phone),
      status: repository.paymentStatus,
      completeSandbox: (id, card) =>
          repository.completeSandboxPayment(id, card: card),
    );
    await _load();
    if (!mounted || result == null || !result.isPaid) return;
    // Прошлое «ждёт оплаты» уже неправда — убираем его, а не ставим
    // новое сообщение в очередь за ним.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(tr.manager.shiftPublished)));
  }

  Future<void> _openApplicants(Shift shift) async {
    await Navigator.of(context).push(
      appRoute(
        _ApplicantsPage(
          shift: shift,
          repository: repository,
          session: widget.session,
        ),
      ),
    );
    await _load();
  }

  /// Разделы списка: что впереди и что уже было. Раньше список шёл одной
  /// лентой «новые даты сверху», и сегодняшняя смена — та, где нужен код
  /// отметки и кнопки «Вышел», — оказывалась под всеми будущими.
  static List<(String, IconData, List<Shift>)> _sections(List<Shift> all) {
    final split = splitByTime(all, DateTime.now());
    return [
      (tr.manager.sectionAhead, Icons.event_available_rounded, split.ahead),
      (tr.manager.sectionPast, Icons.history_rounded, split.past),
    ];
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
      appBar: AppBar(title: Text(tr.manager.myShiftsTitle)),
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
                      title: tr.manager.emptyTitle,
                      subtitle: tr.manager.emptySubtitle,
                      actionLabel: tr.manager.createShiftAction,
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
                  for (final (title, icon, shifts) in _sections(value))
                    if (shifts.isNotEmpty) ...[
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                        sliver: SliverToBoxAdapter(
                          child: SectionHeader(icon: icon, title: title),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        sliver: SliverList.builder(
                          itemCount: shifts.length,
                          itemBuilder: (context, index) => AnimatedEntrance(
                            index: index,
                            child: _ManagerShiftCard(
                              shift: shifts[index],
                              onTap: () => _openApplicants(shifts[index]),
                              onCancel: () => _cancelShift(shifts[index]),
                              onEdit: () => _editShift(shifts[index]),
                              onRepeat: () => _repeatShift(shifts[index]),
                              onPay: () => _payShift(shifts[index]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
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
            label: tr.manager.statShifts,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            value: stats.fillPercent == null ? '—' : '${stats.fillPercent}%',
            label: tr.manager.statFilled,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            value: formatMoney(stats.spentThisMonth),
            label: tr.manager.statSpent(month),
          ),
        ),
      ],
    );
  }
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
                  TagChip(
                    text: tr.manager.statusCancelled,
                    color: AppColors.danger,
                  )
                else if (shift.awaitingPayment)
                  TagChip(
                    text: tr.manager.statusAwaitingPayment,
                    icon: Icons.hourglass_top_rounded,
                    color: AppColors.warning,
                  )
                else if (isPast)
                  TagChip(text: tr.manager.statusPast)
                else if (!shift.hasFreeSlots)
                  TagChip(
                    text: tr.manager.statusFull,
                    color: AppColors.brand,
                  )
                else
                  TagChip(
                    text: tr.manager.statusHiring,
                    color: AppColors.accent,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            InfoRow(
              icon: Icons.calendar_today_rounded,
              text: '${tr.core.dayMonthShort(shift.workDate)} · '
                  '${formatTime(shift.startMinutes)}—'
                  '${formatTime(shift.endMinutes)}',
            ),
            InfoRow(
              icon: Icons.payments_outlined,
              text: tr.manager.payPerShift(
                formatMoney(shift.totalPay),
                formatMoney(shift.hourlyRate),
              ),
            ),
            // Где сейчас деньги: у сервиса, ещё не пришли или вернулись.
            if (shift.awaitingPayment && !shift.isCancelled) ...[
              InfoRow(
                icon: Icons.visibility_off_outlined,
                iconColor: AppColors.warning,
                text: tr.manager.hiddenUntilPaid,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onPay,
                  icon: const Icon(Icons.lock_rounded, size: 18),
                  label: Text(tr.manager
                      .payAmount(formatMoney(ShiftCost.of(shift).total))),
                ),
              ),
            ] else if (shift.isFunded)
              InfoRow(
                icon: Icons.verified_user_outlined,
                iconColor: AppColors.success,
                text: tr.manager
                    .fundedNote(formatMoney(ShiftCost.of(shift).total)),
              )
            else if (shift.isCancelled)
              InfoRow(
                icon: Icons.undo_rounded,
                iconColor: AppColors.muted,
                text: tr.manager.refundedNote,
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
                Flexible(
                  child: Text(
                    tr.manager.viewApplicants,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
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
                    child: Text(
                      tr.manager.edit,
                      style: const TextStyle(
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
                    child: Text(
                      tr.manager.cancel,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // Повтор — значком: три слова в строку на узком
                  // экране не помещаются.
                  IconButton(
                    onPressed: onRepeat,
                    tooltip: tr.manager.repeat,
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
                    label: Text(
                      tr.manager.repeat,
                      style: const TextStyle(
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
  final AppSession session;

  const _ApplicantsPage({
    required this.shift,
    required this.repository,
    required this.session,
  });

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

  /// Звать на смену есть смысл, пока она впереди, оплачена и в ней
  /// остались места. Хранилище проверит то же самое ещё раз.
  bool get _canInvite {
    final shift = widget.shift;
    return !shift.isCancelled &&
        !shift.awaitingPayment &&
        !shift.hasStartedAt(DateTime.now()) &&
        shift.hasFreeSlots;
  }

  /// Позвать знакомых: любимых и тех, кто уже отработал у заказчика.
  /// Кто уже записан, в списке не нужен.
  Future<void> _inviteKnown() async {
    final booked = switch (state) {
      Ready(:final value) => {for (final a in value) a.user.id},
      _ => <int>{},
    };
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InviteKnownSheet(
        shift: widget.shift,
        repository: widget.repository,
        skip: booked,
      ),
    );
  }

  Future<void> _load() async {
    final result =
        await load(() => widget.repository.applicantsFor(widget.shift.id));
    if (!mounted) return;
    setState(() => state = result);
  }

  /// Кого можно засчитать разом: отметились на месте, а заказчик ещё не
  /// ставил ни «Вышел», ни «Не вышел». Только после начала смены.
  List<ShiftApplicant> _readyToConfirm(List<ShiftApplicant> all) {
    if (!DateTime.now().isAfter(widget.shift.startsAt)) return const [];
    return [
      for (final a in all)
        if (a.isUnmarked && a.isCheckedIn && !pending.contains(a.user.id)) a,
    ];
  }

  /// Засчитать выход всем отметившимся — одним подтверждением.
  ///
  /// По одному, а не одним запросом: у хранилища каждое подтверждение —
  /// своё начисление и своё уведомление, и правило «второй раз не
  /// платит» уже живёт там. Сорвался кто-то один — остальные засчитаны,
  /// а он остаётся в списке с обычной кнопкой.
  Future<void> _confirmAll(List<ShiftApplicant> people) async {
    final each = widget.shift.totalPay;
    final agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.manager.confirmAllTitle),
        content: Text(tr.manager.confirmAllBody(
          people.length,
          formatMoney(each),
          formatMoney(each * people.length),
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(tr.manager.dialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(tr.manager.showedUp),
          ),
        ],
      ),
    );
    if (agreed != true || !mounted) return;

    setState(() => pending.addAll(people.map((a) => a.user.id)));
    var done = 0;
    try {
      for (final person in people) {
        final result = await guarded(
          context,
          () => widget.repository.confirmAttendance(
            shiftId: widget.shift.id,
            workerId: person.user.id,
          ),
        );
        if (result == BookingResult.ok) done++;
        if (!mounted) return;
      }
    } finally {
      if (mounted) {
        setState(() => pending.removeAll(people.map((a) => a.user.id)));
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(tr.manager.confirmAllDone(done)),
      behavior: SnackBarBehavior.floating,
    ));
    await _load();
  }

  /// Люди, по которым запрос ещё в пути: их кнопки погашены, чтобы второе
  /// нажатие не ушло следом за первым.
  final Set<int> pending = {};

  Future<BookingResult?> _marking(
    ShiftApplicant applicant,
    Future<BookingResult> Function() body,
  ) async {
    setState(() => pending.add(applicant.user.id));
    try {
      return await guarded(context, body);
    } finally {
      if (mounted) setState(() => pending.remove(applicant.user.id));
    }
  }

  Future<void> _markNoShow(ShiftApplicant applicant) async {
    final agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.manager.noShowTitle),
        content: Text(tr.manager.noShowBody(applicant.user.fullName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(tr.manager.dialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(tr.manager.noShowLabel),
          ),
        ],
      ),
    );
    if (agreed != true || !mounted) return;

    final result = await _marking(
      applicant,
      () => widget.repository.markNoShow(
        shiftId: widget.shift.id,
        workerId: applicant.user.id,
      ),
    );
    if (result == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(switch (result) {
          BookingResult.ok =>
            tr.manager.noShowMarked(applicant.user.fullName),
          BookingResult.notStarted => tr.manager.noShowTooEarly,
          BookingResult.checkedIn => tr.manager.noShowCheckedIn,
          _ => tr.manager.noShowFailed,
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
    if (pending.contains(applicant.user.id)) return;
    final favorite = !applicant.isFavorite;
    final result = await _marking(
      applicant,
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
            tr.manager.addedToFavorites(applicant.user.fullName),
          BookingResult.ok =>
            tr.manager.removedFromFavorites(applicant.user.fullName),
          _ => tr.manager.favoritesOnlyWorked,
        }),
        behavior: SnackBarBehavior.floating,
      ),
    );
    await _load();
  }

  Future<void> _confirm(ShiftApplicant applicant) async {
    // «Вышел» отпускает деньги исполнителю, и обратно их кнопкой не
    // вернуть. Невыход рядом спрашивает подтверждение — промах по
    // соседней кнопке стоит не меньше.
    final agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.manager.confirmTitle),
        content: Text(tr.manager.confirmBody(
          applicant.user.fullName,
          formatMoney(widget.shift.totalPay),
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(tr.manager.dialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(tr.manager.showedUp),
          ),
        ],
      ),
    );
    if (agreed != true || !mounted) return;

    final result = await _marking(
      applicant,
      () => widget.repository.confirmAttendance(
        shiftId: widget.shift.id,
        workerId: applicant.user.id,
      ),
    );
    if (result == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(switch (result) {
          BookingResult.ok =>
            tr.manager.attendanceConfirmed(applicant.user.fullName),
          BookingResult.notStarted => tr.manager.confirmTooEarly,
          BookingResult.notMine => tr.manager.notYourShift,
          _ => tr.manager.confirmFailed,
        }),
        behavior: SnackBarBehavior.floating,
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.manager.applicantsTitle),
        actions: [
          // Смена недобирает людей — позвать тех, с кем уже работали.
          if (_canInvite)
            IconButton(
              tooltip: tr.manager.inviteKnownButton,
              icon: const Icon(Icons.person_add_alt_1_rounded),
              onPressed: _inviteKnown,
            ),
          // Список для проходной или рабочего чата: охране нужны имена,
          // старшему смены — ещё и телефоны.
          if (state case Ready(:final value) when value.isNotEmpty)
            IconButton(
              tooltip: tr.manager.copyApplicants,
              icon: const Icon(Icons.copy_all_rounded),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(
                    text: applicantsText(widget.shift, value)));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(tr.manager.applicantsCopied),
                  behavior: SnackBarBehavior.floating,
                ));
              },
            ),
        ],
      ),
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
          Ready(value: []) => EmptyState(
              icon: Icons.person_search_rounded,
              title: tr.manager.noApplicantsTitle,
              subtitle: tr.manager.noApplicantsSubtitle,
              actionLabel: _canInvite ? tr.manager.inviteKnownButton : null,
              onAction: _canInvite ? _inviteKnown : null,
            ),
          // Потянуть вниз — увидеть, кто отметился на месте.
          Ready(:final value) => RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: value.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    final ready = _readyToConfirm(value);
                    return Column(
                      children: [
                        _DaySummary(
                          summary: AttendanceSummary.of(
                            value,
                            started:
                                DateTime.now().isAfter(widget.shift.startsAt),
                          ),
                        ),
                        if (code != null) _CheckInCodeCard(code: code!),
                        _AttendanceHint(shift: widget.shift),
                        // На большой смене жать «Вышел» каждому — десятки
                        // касаний и окон. Отметившихся можно засчитать
                        // разом, одним подтверждением с итоговой суммой.
                        if (ready.length >= 2)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: pending.isEmpty
                                    ? () => _confirmAll(ready)
                                    : null,
                                icon: const Icon(Icons.done_all_rounded,
                                    size: 18),
                                label: Text(
                                    tr.manager.confirmAllButton(ready.length)),
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                  final item = value[index - 1];
                  final canMark = DateTime.now().isAfter(widget.shift.startsAt);
                  return AnimatedEntrance(
                    index: index,
                    child: _ApplicantTile(
                      applicant: item,
                      // Смена идёт, а человека нет на месте и о нём ничего
                      // не известно — ему стоит написать.
                      missing: canMark && item.isUnmarked && !item.isCheckedIn,
                      // Отмечать можно только после начала смены: раньше
                      // просто не о чем говорить — человек ещё не опоздал.
                      //
                      // Раньше «Подтвердить» показывалось лишь тем, кто
                      // отметился. Но отметка — дело добровольное: человек
                      // мог отработать и не нажать кнопку, и заказчик
                      // оставался без возможности засчитать ему смену.
                      onConfirm: canMark &&
                              item.isUnmarked &&
                              !pending.contains(item.user.id)
                          ? () => _confirm(item)
                          : null,
                      onNoShow: canMark &&
                              item.isUnmarked &&
                              !pending.contains(item.user.id)
                          ? () => _markNoShow(item)
                          : null,
                      onFavorite:
                          item.isConfirmed ? () => _toggleFavorite(item) : null,
                      onProfile: () => Navigator.of(context).push(
                        appRoute(
                          MyReviewsPage(
                            session: widget.session,
                            repository: widget.repository,
                            worker: item.user,
                          ),
                        ),
                      ),
                      onChat: () async {
                        await Navigator.of(context).push(
                          appRoute(
                            ChatPage(
                              repository: widget.repository,
                              shiftId: widget.shift.id,
                              workerId: item.user.id,
                              subtitle: item.user.fullName,
                            ),
                          ),
                        );
                        // Прочитал — значок у человека гаснет.
                        await _load();
                      },
                    ),
                  );
                },
              ),
            ),
        },
      ),
    );
  }
}

/// Кого позвать на смену: любимые и все, кто уже отработал у заказчика.
///
/// Каждого — своей кнопкой, а не «позвать всех»: приглашение — личное,
/// и заказчик сам решает, кого хочет видеть снова.
class _InviteKnownSheet extends StatefulWidget {
  final Shift shift;
  final ShiftRepository repository;

  /// Кто уже записан — их не показываем.
  final Set<int> skip;

  const _InviteKnownSheet({
    required this.shift,
    required this.repository,
    required this.skip,
  });

  @override
  State<_InviteKnownSheet> createState() => _InviteKnownSheetState();
}

class _InviteKnownSheetState extends State<_InviteKnownSheet> {
  Async<List<KnownWorker>> state = const Loading();

  /// Свободные в день смены — люди, которые сами отметили день.
  /// Не узнали — раздела просто нет.
  List<KnownWorker> free = const [];
  final invited = <int>{};
  final pending = <int>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final freeFuture = widget.repository
        .availableWorkers(widget.shift.id)
        .catchError((Object _) => <KnownWorker>[]);
    final result = await load(widget.repository.knownWorkers);
    final available = await freeFuture;
    if (!mounted) return;
    setState(() {
      state = result;
      free = available;
    });
  }

  Future<void> _invite(AppUser user) async {
    setState(() => pending.add(user.id));
    final result = await guarded(
      context,
      () => widget.repository
          .inviteToShift(shiftId: widget.shift.id, workerId: user.id),
    );
    if (!mounted) return;
    final ok = result == BookingResult.ok ||
        result == BookingResult.alreadyBooked;
    setState(() {
      pending.remove(user.id);
      if (ok) invited.add(user.id);
    });
    // null — сбой уже показан; остальное — отказ по правилам.
    if (result != null && !ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(tr.manager.inviteFailed),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: AppColors.muted, height: 1.4);
    return GlassSheet(
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SheetHandle(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
                child: Text(
                  tr.manager.inviteKnownTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 19),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(tr.manager.inviteKnownHint, style: muted),
              ),
              ..._content(muted),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _content(TextStyle? muted) {
    switch (state) {
      case Loading():
        return const [
          Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
        ];
      case Failed(:final error):
        return [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Text(describeError(error), style: muted),
          ),
        ];
      case Ready(:final value):
        final people = [
          for (final k in value)
            if (!widget.skip.contains(k.user.id)) k,
        ];
        final known = {for (final k in value) k.user.id};
        final strangers = [
          for (final k in free)
            if (!widget.skip.contains(k.user.id) && !known.contains(k.user.id))
              k,
        ];
        if (people.isEmpty && strangers.isEmpty) {
          return [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(tr.manager.inviteKnownEmpty, style: muted),
            ),
          ];
        }
        return [
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final k in people) _tile(k),
                if (strangers.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 2),
                    child: Text(
                      tr.manager.availableTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                    child: Text(tr.manager.availableHint, style: muted),
                  ),
                  for (final k in strangers) _tile(k, stranger: true),
                ],
              ],
            ),
          ),
        ];
    }
  }

  /// [stranger] — свободный в этот день, но у заказчика ещё не работал:
  /// у него опыт вообще, а не «смен у вас».
  Widget _tile(KnownWorker known, {bool stranger = false}) {
    final user = known.user;
    final stats = stranger
        ? tr.manager.availableStats(
            user.rating.toStringAsFixed(1),
            shiftsLabel(user.completedShifts),
          )
        : tr.manager.knownWorkerStats(
            user.rating.toStringAsFixed(1),
            shiftsLabel(user.completedShifts),
          );
    return ListTile(
      leading: Icon(
        known.isFavorite ? Icons.star_rounded : Icons.person_outline_rounded,
        color: known.isFavorite ? AppColors.brand : AppColors.muted,
      ),
      title: Text(user.fullName),
      subtitle: Text(
        user.noShows > 0
            ? '$stats · ${tr.manager.knownWorkerMissed(user.noShows)}'
            : stats,
      ),
      trailing: invited.contains(user.id)
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_rounded,
                    size: 18, color: AppColors.brand),
                const SizedBox(width: 4),
                Text(tr.manager.inviteKnownDone),
              ],
            )
          : TextButton(
              onPressed:
                  pending.contains(user.id) ? null : () => _invite(user),
              child: Text(tr.manager.inviteKnownAction),
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
              tr.manager.checkInCodeTitle,
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
              tr.manager.checkInCodeHint,
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
                tr.manager.attendanceHint,
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

  /// Написать этому человеку.
  final VoidCallback? onChat;

  /// Открыть отзывы о человеке — нажатием на его имя.
  final VoidCallback? onProfile;

  /// Смена началась, а человек не отметился.
  final bool missing;

  const _ApplicantTile({
    required this.applicant,
    this.missing = false,
    this.onConfirm,
    this.onNoShow,
    this.onFavorite,
    this.onChat,
    this.onProfile,
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
                      // Имя — ссылка на отзывы о человеке: прежде чем
                      // засчитать или пригласить снова, полезно знать,
                      // что писали другие заказчики.
                      InkWell(
                        onTap: onProfile,
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                user.fullName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontSize: 14),
                              ),
                            ),
                            if (onProfile != null)
                              const Icon(Icons.chevron_right_rounded,
                                  size: 18, color: AppColors.muted),
                          ],
                        ),
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
                                  ? tr.manager.verified
                                  : tr.manager.notVerified,
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
                if (onChat != null)
                  IconButton(
                    onPressed: onChat,
                    tooltip: tr.shift.chatWithWorker,
                    // Узкая кнопка: строка с именем и рейтингом на узком
                    // телефоне и так занята почти целиком.
                    visualDensity: VisualDensity.compact,
                    constraints:
                        const BoxConstraints.tightFor(width: 36, height: 40),
                    padding: EdgeInsets.zero,
                    // Число непрочитанных от этого человека: «опаздываю»
                    // не должно ждать, пока заказчик заглянет в колокольчик.
                    icon: Badge(
                      isLabelVisible: applicant.unreadMessages > 0,
                      label: Text('${applicant.unreadMessages}'),
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppColors.brand,
                      ),
                    ),
                  ),
                if (onFavorite != null)
                  IconButton(
                    onPressed: onFavorite,
                    tooltip: applicant.isFavorite
                        ? tr.manager.removeFromFavorites
                        : tr.manager.addToFavorites,
                    icon: Icon(
                      applicant.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: AppColors.accent,
                    ),
                  ),
                if (applicant.isConfirmed)
                  TagChip(
                    text: tr.manager.statusWorked,
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.brand,
                  )
                else if (applicant.isNoShow)
                  TagChip(
                    text: tr.manager.noShowLabel,
                    icon: Icons.person_off_outlined,
                    color: AppColors.danger,
                  )
                else if (applicant.isCheckedIn)
                  TagChip(
                    // По коду — человек точно был на точке; без кода —
                    // только нажал кнопку.
                    text: applicant.checkInVerified
                        ? tr.manager.statusOnSiteCode
                        : tr.manager.statusOnSite,
                    icon: applicant.checkInVerified
                        ? Icons.verified_rounded
                        : Icons.location_on_outlined,
                    color: applicant.checkInVerified
                        ? AppColors.brand
                        : AppColors.accent,
                  )
                else if (applicant.isComingConfirmed)
                  // Накануне человек сказал «точно выйду» — на него можно
                  // рассчитывать, переспрашивать не нужно.
                  TagChip(
                    text: tr.manager.statusComing,
                    icon: Icons.thumb_up_alt_outlined,
                    color: AppColors.brand,
                  )
                else if (missing)
                  TagChip(
                    text: tr.manager.statusNotCheckedIn,
                    icon: Icons.schedule_rounded,
                    color: AppColors.warning,
                  )
                else
                  TagChip(text: tr.manager.statusBooked),
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
                      tr.manager.reliabilityLine(
                        applicant.user.reliabilityPercent,
                        applicant.user.noShows,
                      ),
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
                    tr.manager.checkedInAt(formatTime(
                        applicant.checkedInAt!.hour * 60 +
                            applicant.checkedInAt!.minute)),
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
                        label: Text(tr.manager.showedUp),
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
                        label: Text(tr.manager.noShowLabel),
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

/// Четыре числа над списком записавшихся: записались, точно выйдут, на
/// месте, не отметились.
class _DaySummary extends StatelessWidget {
  final AttendanceSummary summary;

  const _DaySummary({required this.summary});

  @override
  Widget build(BuildContext context) {
    Widget cell(int value, String label, Color color) => Expanded(
          child: Column(
            children: [
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
              ),
            ],
          ),
        );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cell(summary.booked, tr.manager.daySummaryBooked,
                Theme.of(context).colorScheme.onSurface),
            cell(summary.coming, tr.manager.daySummaryComing, AppColors.brand),
            cell(summary.onSite, tr.manager.daySummaryOnSite, AppColors.success),
            cell(
              summary.missing,
              tr.manager.daySummaryMissing,
              summary.missing > 0 ? AppColors.warning : AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

/// Список записавшихся текстом — для охраны на проходной или рабочего
/// чата. Только те, кого ждут на смене: невышедшие в него не попадают.
String applicantsText(Shift shift, List<ShiftApplicant> people) {
  final expected = [
    for (final p in people)
      if (!p.isNoShow) p,
  ];
  return [
    '${shift.title} — ${shift.company}',
    '${tr.core.dayMonth(shift.workDate)}, '
        '${formatTime(shift.startMinutes)}–${formatTime(shift.endMinutes)}, '
        '${shift.address}',
    '',
    for (final (i, p) in expected.indexed)
      '${i + 1}. ${p.user.fullName}, ${formatKzPhone(p.user.phone)}',
  ].join('\n');
}

