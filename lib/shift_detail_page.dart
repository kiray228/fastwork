import 'package:flutter/material.dart';

import 'shift.dart';
import 'theme/app_colors.dart';
import 'widgets/common.dart';

/// Экран «Подробнее»: одна смена целиком.
class ShiftDetailPage extends StatelessWidget {
  final Shift shift;

  const ShiftDetailPage({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
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
                _HeroCard(shift: shift),
                const SizedBox(height: 14),
                _PayCard(shift: shift),
                if (shift.duties.isNotEmpty) ...[
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
                        for (final duty in shift.duties)
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
                if (shift.dressCode != null) ...[
                  const SizedBox(height: 14),
                  _TextSection(
                    icon: Icons.checkroom_rounded,
                    title: 'Форма одежды',
                    text: shift.dressCode!,
                  ),
                ],
                if (shift.employerComment != null) ...[
                  const SizedBox(height: 14),
                  _TextSection(
                    icon: Icons.info_outline_rounded,
                    title: 'Комментарий заказчика',
                    text: shift.employerComment!,
                  ),
                ],
                const SizedBox(height: 14),
                _SlotsCard(shift: shift),
              ],
            ),
          ),
          _BottomBar(
            shift: shift,
            onApply: () {
              // Настоящего отклика пока нет — базы данных ещё не подключили.
              // Пока просто показываем сообщение, чтобы кнопка была живой.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Заявка на «${shift.title}» отправлена'),
                ),
              );
            },
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
  final VoidCallback onApply;

  const _BottomBar({required this.shift, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                onPressed: shift.hasFreeSlots ? onApply : null,
                child: Text(
                  shift.hasFreeSlots ? 'Оставить заявку' : 'Мест нет',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
