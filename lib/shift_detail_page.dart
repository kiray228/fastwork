import 'package:flutter/material.dart';

import 'data/shift_repository.dart';
import 'shift.dart';
import 'theme/app_colors.dart';
import 'widgets/common.dart';

/// Экран «Подробнее»: одна смена целиком.
class ShiftDetailPage extends StatefulWidget {
  final int shiftId;
  final ShiftRepository repository;

  const ShiftDetailPage({
    super.key,
    required this.shiftId,
    required this.repository,
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

  /// Оставить заявку. После записи обязательно перечитываем смену из базы:
  /// число занятых мест изменилось, и показывать старое нельзя.
  Future<void> _apply() async {
    setState(() => busy = true);
    await widget.repository.apply(widget.shiftId);
    await _load();
    if (!mounted) return;
    setState(() => busy = false);

    final current = shift;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          current != null && current.isApplied
              ? 'Заявка отправлена'
              : 'Не получилось: мест уже нет',
        ),
      ),
    );
  }

  Future<void> _cancel() async {
    setState(() => busy = true);
    await widget.repository.cancelApplication(widget.shiftId);
    await _load();
    if (!mounted) return;
    setState(() => busy = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Заявка отменена')),
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
                  const _AppliedBanner(),
                  const SizedBox(height: 14),
                ],
                _HeroCard(shift: current),
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
            onApply: _apply,
            onCancel: _cancel,
          ),
        ],
      ),
    );
  }
}

/// Плашка «вы записаны» вверху экрана.
class _AppliedBanner extends StatelessWidget {
  const _AppliedBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.brand.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.brand.withValues(alpha: 0.35)),
      ),
      child: Row(
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
    );
  }
}

/// Шапка: бейдж даты, название, компания, адрес, время, ярлыки.
class _HeroCard extends StatelessWidget {
  final Shift shift;

  const _HeroCard({required this.shift});

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
                    Row(
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
                      ],
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
          if (shift.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tag in shift.tags)
                  TagChip(
                    text: tag,
                    color: tag == 'Мало мест' ? AppColors.accent : null,
                  ),
              ],
            ),
          ],
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
  final VoidCallback onApply;
  final VoidCallback onCancel;

  const _BottomBar({
    required this.shift,
    required this.busy,
    required this.onApply,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Что показывать на кнопке, зависит от состояния смены.
    final String label;
    final VoidCallback? action;

    if (shift.isApplied) {
      label = 'Отменить заявку';
      action = onCancel;
    } else if (shift.hasFreeSlots) {
      label = 'Оставить заявку';
      action = onApply;
    } else {
      label = 'Мест нет';
      action = null;
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
                style: shift.isApplied
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
