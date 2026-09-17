import 'package:flutter/material.dart';

import 'shift.dart';
import 'shifts_page.dart' show IconRow;

/// Экран «Подробнее»: одна смена целиком.
class ShiftDetailPage extends StatelessWidget {
  final Shift shift;

  const ShiftDetailPage({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Смена')),
      // Основное содержимое прокручивается, а низ экрана закреплён —
      // пользователь видит кнопку в любой момент, а не ищет её внизу.
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Header(shift: shift),
                const SizedBox(height: 20),
                _PayBlock(shift: shift),
                if (shift.duties.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _Section(
                    icon: Icons.checklist,
                    title: 'Обязанности',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final duty in shift.duties)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('•  '),
                                Expanded(child: Text(duty)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                if (shift.dressCode != null) ...[
                  const SizedBox(height: 20),
                  _Section(
                    icon: Icons.checkroom,
                    title: 'Форма одежды',
                    child: Text(shift.dressCode!),
                  ),
                ],
                if (shift.employerComment != null) ...[
                  const SizedBox(height: 20),
                  _Section(
                    icon: Icons.info_outline,
                    title: 'Комментарий заказчика',
                    child: Text(shift.employerComment!),
                  ),
                ],
                const SizedBox(height: 20),
                _Section(
                  icon: Icons.groups_outlined,
                  title: 'Набор',
                  child: Text(
                    'Нужно человек: ${shift.workersNeeded}\n'
                    'Уже набрано: ${shift.workersHired}\n'
                    'Свободно мест: ${shift.freeSlots}',
                  ),
                ),
                const SizedBox(height: 24),
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
                  backgroundColor: colors.primary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Шапка: бейдж даты, название, компания, адрес, время.
class _Header extends StatelessWidget {
  final Shift shift;

  const _Header({required this.shift});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final date = shift.workDate;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Бейдж даты: месяц / число / день недели — тремя уровнями.
        // Читается быстрее, чем строка «17.09.2026, чт».
        Container(
          width: 64,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                monthsShort[date.month - 1],
                style: TextStyle(fontSize: 12, color: colors.onPrimaryContainer),
              ),
              Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimaryContainer,
                ),
              ),
              Text(
                weekdaysShort[date.weekday - 1],
                style: TextStyle(fontSize: 12, color: colors.onPrimaryContainer),
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              IconRow(
                icon: Icons.business_outlined,
                text: shift.company,
              ),
              IconRow(icon: Icons.place_outlined, text: shift.address),
              IconRow(
                icon: Icons.schedule,
                text: '${formatTime(shift.startMinutes)} — '
                    '${formatTime(shift.endMinutes)}'
                    '${shift.crossesMidnight ? ' (следующий день)' : ''}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Блок «Вознаграждение» с расшифровкой, откуда взялась сумма.
class _PayBlock extends StatelessWidget {
  final Shift shift;

  const _PayBlock({required this.shift});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded не даёт тексту вылезти за край экрана: он забирает
              // ровно то место, что осталось, а лишнее ужимает.
              const Expanded(
                child: Text(
                  'Вознаграждение',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatMoney(shift.totalPay),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24),
          _PayRow(
            label: 'Ставка',
            value: '${formatMoney(shift.hourlyRate)} / час',
          ),
          _PayRow(
            label: 'Длительность смены',
            value: formatDuration(shift.durationMinutes),
          ),
          _PayRow(
            label: 'Оплачивается часов',
            value: formatDuration(shift.paidMinutes),
          ),
          if (shift.hasUnpaidBreak) ...[
            const SizedBox(height: 8),
            Text(
              '* ${formatDuration(shift.breakMinutes)} перерыва на обед '
              'не оплачивается',
              style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class _PayRow extends StatelessWidget {
  final String label;
  final String value;

  const _PayRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: colors.onSurfaceVariant)),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}

/// Блок с заголовком и иконкой.
class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _Section({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
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
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            shift.payoutDelayDays == 1
                ? 'Вознаграждение на следующий день после смены'
                : 'Вознаграждение через ${shift.payoutDelayDays} дня после смены',
            style: TextStyle(fontSize: 13, color: colors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: shift.hasFreeSlots ? onApply : null,
              child: Text(
                shift.hasFreeSlots ? 'Оставить заявку' : 'Мест нет',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
