import 'package:flutter/material.dart';

import 'data/session.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'company_page.dart';
import 'package:fastwork_core/shift.dart';
import 'theme/app_colors.dart';
import 'widgets/booking_confirm_sheet.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';
import 'widgets/nav.dart';

/// Экран «Подробнее»: одна смена целиком.
class ShiftDetailPage extends StatefulWidget {
  final int shiftId;
  final ShiftRepository repository;
  final AppSession session;

  const ShiftDetailPage({
    super.key,
    required this.shiftId,
    required this.repository,
    required this.session,
  });

  @override
  State<ShiftDetailPage> createState() => _ShiftDetailPageState();
}

class _ShiftDetailPageState extends State<ShiftDetailPage> {
  Shift? shift;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await widget.repository.shiftById(widget.shiftId);
    if (!mounted) return;
    setState(() => shift = loaded);
  }

  /// Записаться на смену.
  ///
  /// Сначала показываем условия и ждём подтверждения — запись это
  /// обязательство, а не «заявка на рассмотрение». Только после согласия
  /// пишем в базу и перечитываем смену: занятых мест стало больше.
  Future<void> _book() async {
    final current = shift;
    if (current == null) return;

    final confirmed = await showBookingConfirmSheet(context, current);
    if (!confirmed || !mounted) return;

    setState(() => busy = true);
    final result = await guarded(
      context,
      () => widget.repository.apply(widget.shiftId),
    );
    await _load();
    if (!mounted) return;
    setState(() => busy = false);
    if (result == null) return; // сорвалось — сообщение уже показано

    _showResult(
      switch (result) {
        BookingResult.ok => 'Вы записаны на смену',
        BookingResult.noSlots => 'Не получилось: мест уже нет',
        BookingResult.alreadyBooked => 'Вы уже записаны на эту смену',
        BookingResult.ratingTooLow =>
          'Ваш рейтинг ниже требуемого для этой смены',
        BookingResult.earningsLimit =>
          'С этой сменой доход за месяц превысит 300 МРП — '
              'это предел для платформенной занятости',
        _ => 'Не получилось записаться',
      },
    );
  }

  /// Отметиться на смене: «я на месте».
  ///
  /// Это середина жизненного пути записи. Раньше смена считалась
  /// отработанной просто потому, что дата прошла, — теперь нужно
  /// действие человека и подтверждение заказчика.
  Future<void> _checkIn() async {
    setState(() => busy = true);
    final result = await guarded(
      context,
      () => widget.repository.checkIn(widget.shiftId),
    );
    await _load();
    if (!mounted) return;
    setState(() => busy = false);
    if (result == null) return;

    _showResult(
      switch (result) {
        BookingResult.ok => 'Отметка принята — заказчик её видит',
        BookingResult.alreadyBooked => 'Вы уже отметились',
        BookingResult.tooEarlyToCheckIn =>
          'Отметиться можно в день смены, не раньше чем за час до начала',
        _ => 'Не получилось отметиться',
      },
    );
  }

  /// Отменить запись — тоже с подтверждением, но коротким.
  Future<void> _cancel() async {
    final current = shift;
    if (current == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отменить запись?'),
        content: Text(
          'Место освободится, и его сможет занять другой исполнитель.\n\n'
          'Записаться заново можно будет, только если место останется '
          'свободным.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Оставить запись'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.accent),
            child: const Text('Отменить'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => busy = true);
    final result = await guarded(
      context,
      () => widget.repository.cancelApplication(widget.shiftId),
    );
    await _load();
    if (!mounted) return;
    setState(() => busy = false);
    if (result == null) return;

    _showResult(
      switch (result) {
        BookingResult.ok => 'Запись отменена',
        BookingResult.tooLateToCancel =>
          'Срок отмены прошёл — запись отменить нельзя',
        _ => 'Не получилось отменить',
      },
    );
  }

  void _showResult(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = shift;

    if (current == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Смена')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Смена'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
          const SizedBox(width: 4),
        ],
      ),
      // Содержимое прокручивается, а низ экрана закреплён — пользователь
      // видит кнопку в любой момент, а не ищет её внизу.
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                if (current.isApplied) ...[
                  _AppliedBanner(shift: current),
                  const SizedBox(height: 14),
                ] else if (!current.ratingAllows(widget.session.rating)) ...[
                  _RatingLockBanner(
                    required: current.minRating!,
                    actual: widget.session.rating,
                  ),
                  const SizedBox(height: 14),
                ],
                _HeroCard(
                  shift: current,
                  onCompanyTap: () => Navigator.of(context).push(
                    appRoute(
                      CompanyPage(
                        company: current.company,
                        repository: widget.repository,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _PayCard(shift: current),
                if (current.duties.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(
                          icon: Icons.checklist_rounded,
                          title: 'Обязанности',
                        ),
                        const SizedBox(height: 12),
                        for (final duty in current.duties)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 7),
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.brand,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    duty,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                if (current.dressCode != null) ...[
                  const SizedBox(height: 14),
                  _TextSection(
                    icon: Icons.checkroom_rounded,
                    title: 'Форма одежды',
                    text: current.dressCode!,
                  ),
                ],
                if (current.employerComment != null) ...[
                  const SizedBox(height: 14),
                  _TextSection(
                    icon: Icons.info_outline_rounded,
                    title: 'Комментарий заказчика',
                    text: current.employerComment!,
                  ),
                ],
                const SizedBox(height: 14),
                _SlotsCard(shift: current),
              ],
            ),
          ),
          _BottomBar(
            shift: current,
            busy: busy,
            userRating: widget.session.rating,
            onBook: _book,
            onCancel: _cancel,
            onCheckIn: _checkIn,
          ),
        ],
      ),
    );
  }
}

/// Плашка «вы записаны» вверху экрана.
class _AppliedBanner extends StatelessWidget {
  final Shift shift;

  const _AppliedBanner({required this.shift});

  @override
  Widget build(BuildContext context) {
    final canCancel = shift.canCancelAt(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.brand.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.brand.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.brand, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Вы записаны на эту смену',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        color: AppColors.brandDark,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            canCancel
                ? 'Отменить запись можно до '
                    '${formatDateTime(shift.cancelDeadline)}'
                : 'Срок отмены прошёл. Обязательно выйдите на смену — '
                    'неявка снижает рейтинг.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.35,
              color: canCancel ? AppColors.body : AppColors.accent,
              fontWeight: canCancel ? FontWeight.w500 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Плашка «рейтинг не дотягивает».
///
/// Рейтинг здесь не украшение профиля, а допуск: часть заказчиков берёт
/// только проверенных исполнителей.
class _RatingLockBanner extends StatelessWidget {
  final double required;
  final double actual;

  const _RatingLockBanner({required this.required, required this.actual});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_outline_rounded,
              color: AppColors.accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Этот заказчик берёт от '
                  '${required.toStringAsFixed(1)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ваш рейтинг — ${actual.toStringAsFixed(1)}. '
                  'Отработайте несколько смен без опозданий, и он вырастет.',
                  style: const TextStyle(fontSize: 12.5, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Шапка: бейдж даты, название, компания, адрес, время, ярлыки.
class _HeroCard extends StatelessWidget {
  final Shift shift;
  final VoidCallback onCompanyTap;

  const _HeroCard({required this.shift, required this.onCompanyTap});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final date = shift.workDate;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Бейдж даты: месяц / число / день недели — тремя уровнями.
              // Читается быстрее, чем строка «17.09.2026, чт».
              Container(
                width: 62,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.brand, AppColors.brandDark],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      monthsShort[date.month - 1],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    Text(
                      '${date.day}',
                      style: const TextStyle(
                        fontSize: 24,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      weekdaysShort[date.weekday - 1],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shift.title,
                      style: text.titleLarge?.copyWith(fontSize: 17, height: 1.3),
                    ),
                    const SizedBox(height: 10),
                    // Компания кликабельна — там оценка и отзывы.
                    InkWell(
                      onTap: onCompanyTap,
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          CompanyAvatar(company: shift.company, size: 28),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              shift.company,
                              style: text.titleMedium?.copyWith(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 20,
                            color: AppColors.muted,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          InfoRow(
            icon: Icons.schedule_rounded,
            text: '${formatTime(shift.startMinutes)} — '
                '${formatTime(shift.endMinutes)}'
                '${shift.crossesMidnight ? ' (следующий день)' : ''}'
                ' · ${formatDuration(shift.durationMinutes)}',
          ),
          InfoRow(icon: Icons.place_outlined, text: shift.address),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              CategoryChip(category: shift.category),
              if (shift.isFunded) const GuaranteeChip(),
              for (final tag in shift.tags)
                TagChip(
                  text: tag,
                  color: tag == 'Мало мест' ? AppColors.accent : null,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Блок «Вознаграждение» с расшифровкой, откуда взялась сумма.
class _PayCard extends StatelessWidget {
  final Shift shift;

  const _PayCard({required this.shift});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Верхняя часть с фирменным фоном — сумма должна бросаться в глаза.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.brand, AppColors.brandDark],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Вознаграждение',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formatMoney(shift.totalPay),
                    style: text.displaySmall?.copyWith(
                      fontSize: 36,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _PayRow(
                  label: 'Ставка',
                  value: '${formatMoney(shift.hourlyRate)} / час',
                ),
                _PayRow(
                  label: 'Длительность смены',
                  value: formatDuration(shift.durationMinutes),
                ),
                _PayRow(
                  label: 'Оплачивается',
                  value: formatDuration(shift.paidMinutes),
                  highlight: true,
                ),
                if (shift.isFunded) ...[
                  const SizedBox(height: 10),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        size: 14,
                        color: AppColors.success,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Заказчик уже оплатил смену — деньги у сервиса. '
                          'Вы получите их, когда он подтвердит ваш выход.',
                          style: TextStyle(fontSize: 12, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ],
                if (shift.hasUnpaidBreak) ...[
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 14,
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${formatDuration(shift.breakMinutes)} перерыва '
                          'на обед не оплачивается',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.muted,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PayRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _PayRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.muted),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: highlight
                  ? AppColors.brand
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _TextSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _TextSection({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(icon: icon, title: title),
          const SizedBox(height: 10),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}

/// Сколько людей нужно и сколько уже набрано.
class _SlotsCard extends StatelessWidget {
  final Shift shift;

  const _SlotsCard({required this.shift});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(icon: Icons.groups_outlined, title: 'Набор'),
          const SizedBox(height: 14),
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
          Text(
            shift.hasFreeSlots
                ? 'Свободно мест: ${shift.freeSlots}'
                : 'Все места заняты',
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

/// Закреплённый низ экрана: срок выплаты и кнопка отклика.
class _BottomBar extends StatelessWidget {
  final Shift shift;
  final bool busy;
  final double userRating;
  final VoidCallback onBook;
  final VoidCallback onCancel;
  final VoidCallback onCheckIn;

  const _BottomBar({
    required this.shift,
    required this.busy,
    required this.userRating,
    required this.onBook,
    required this.onCancel,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canCancel = shift.canCancelAt(DateTime.now());
    final allowed = shift.ratingAllows(userRating);

    // Что показывать на кнопке, зависит от состояния смены.
    final String label;
    final VoidCallback? action;
    final bool outlined;

    final now = DateTime.now();

    if (shift.isCompleted) {
      label = 'Смена отработана';
      action = null;
      outlined = false;
    } else if (shift.isCheckedIn) {
      label = 'Вы отметились — ждём подтверждения';
      action = null;
      outlined = true;
    } else if (shift.canCheckInAt(now)) {
      // В день смены запись уже не отменить, зато появляется отметка.
      label = 'Я на месте';
      action = onCheckIn;
      outlined = false;
    } else if (shift.isApplied && canCancel) {
      label = 'Отменить запись';
      action = onCancel;
      outlined = true;
    } else if (shift.isApplied) {
      label = 'Отмена уже недоступна';
      action = null;
      outlined = false;
    } else if (!allowed) {
      label = 'Рейтинг ниже требуемого';
      action = null;
      outlined = false;
    } else if (shift.hasFreeSlots) {
      label = 'Записаться на смену';
      action = onBook;
      outlined = false;
    } else {
      label = 'Мест нет';
      action = null;
      outlined = false;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        boxShadow: isDark
            ? null
            : const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 20,
                  offset: Offset(0, -6),
                ),
              ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 15,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    shift.payoutDelayDays == 1
                        ? 'Вознаграждение на следующий день после смены'
                        : 'Вознаграждение через ${shift.payoutDelayDays} дня',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.muted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: busy ? null : action,
                style: outlined
                    ? FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.body,
                        side: const BorderSide(color: AppColors.border),
                      )
                    : null,
                child: busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(label),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
