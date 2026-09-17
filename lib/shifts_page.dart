import 'package:flutter/material.dart';

import 'shift.dart';
import 'shift_detail_page.dart';

/// Главный экран: полоса дат сверху и список смен под ней.
class ShiftsPage extends StatefulWidget {
  const ShiftsPage({super.key});

  @override
  State<ShiftsPage> createState() => _ShiftsPageState();
}

class _ShiftsPageState extends State<ShiftsPage> {
  /// Все смены, какие есть. Загружаем один раз при открытии экрана.
  late final List<Shift> allShifts;

  /// Сегодняшняя дата без времени. Считаем один раз, чтобы она не «поехала»,
  /// если пользователь задержится в приложении до полуночи.
  late final DateTime today;

  /// Какой день выбран. 0 — сегодня, 1 — завтра и так далее.
  int selectedDay = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    allShifts = buildDemoShifts();
  }

  DateTime dayAt(int index) =>
      DateTime(today.year, today.month, today.day + index);

  /// Смены только на выбранный день.
  /// `where` оставляет из списка те элементы, для которых условие истинно.
  List<Shift> get visibleShifts => allShifts
      .where((shift) => isSameDay(shift.workDate, dayAt(selectedDay)))
      .toList();

  /// Есть ли смены в этот день — чтобы приглушить пустые даты.
  bool hasShiftsOn(DateTime date) =>
      allShifts.any((shift) => isSameDay(shift.workDate, date));

  /// Открыть экран «Подробнее».
  ///
  /// `Navigator` — это стопка экранов. `push` кладёт новый экран поверх
  /// текущего, кнопка «назад» его снимает. Смену передаём прямо в конструктор
  /// нового экрана — как аргумент в обычную функцию.
  void openShift(Shift shift) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ShiftDetailPage(shift: shift)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shifts = visibleShifts;

    return Scaffold(
      appBar: AppBar(title: const Text('fastwork'), centerTitle: true),
      body: Column(
        children: [
          _DateStrip(
            today: today,
            selectedDay: selectedDay,
            hasShiftsOn: hasShiftsOn,
            // Когда пользователь нажал на дату — запоминаем её и просим
            // Flutter перерисовать экран. Это и есть «состояние экрана».
            onDaySelected: (day) => setState(() => selectedDay = day),
          ),
          Expanded(
            child: shifts.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: shifts.length,
                    itemBuilder: (context, index) => _ShiftCard(
                      shift: shifts[index],
                      onTap: () => openShift(shifts[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Что показать, когда на выбранный день смен нет.
/// Пустой экран без объяснения выглядит как сломанное приложение.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy, size: 64, color: colors.outline),
          const SizedBox(height: 16),
          const Text(
            'На этот день смен нет',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Выберите другую дату',
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Горизонтальная полоса дат.
class _DateStrip extends StatelessWidget {
  final DateTime today;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;
  final bool Function(DateTime) hasShiftsOn;

  const _DateStrip({
    required this.today,
    required this.selectedDay,
    required this.onDaySelected,
    required this.hasShiftsOn,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 84,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 14,
        itemBuilder: (context, index) {
          final date = DateTime(today.year, today.month, today.day + index);
          final isSelected = index == selectedDay;
          final hasShifts = hasShiftsOn(date);

          // Цвет текста: выбранный день — белым, день без смен — бледным,
          // обычный — основным.
          final textColor = isSelected
              ? colors.onPrimary
              : hasShifts
                  ? colors.onSurface
                  : colors.onSurface.withValues(alpha: 0.35);

          return GestureDetector(
            onTap: () => onDaySelected(index),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isSelected ? colors.primary : colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekdaysShort[date.weekday - 1],
                    style: TextStyle(fontSize: 12, color: textColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Карточка одной смены в списке.
class _ShiftCard extends StatelessWidget {
  final Shift shift;
  final VoidCallback onTap;

  const _ShiftCard({required this.shift, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    formatMoney(shift.totalPay),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (shift.crossesMidnight)
                  Chip(
                    label: const Text('ночная'),
                    visualDensity: VisualDensity.compact,
                    labelStyle: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            IconRow(
              icon: Icons.schedule,
              text: '${formatTime(shift.startMinutes)} — '
                  '${formatTime(shift.endMinutes)}',
            ),
            IconRow(icon: Icons.work_outline, text: shift.title),
            IconRow(
              icon: Icons.place_outlined,
              text: '${shift.company} • ${shift.address}',
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                // Если мест нет — кнопка неактивна. null вместо функции
                // означает «нажать нельзя», Flutter сам её приглушит.
                onPressed: shift.hasFreeSlots ? onTap : null,
                child: Text(shift.hasFreeSlots ? 'Подробнее' : 'Мест нет'),
              ),
            ),
            if (shift.hasFreeSlots) ...[
              const SizedBox(height: 6),
              Text(
                'Осталось мест: ${shift.freeSlots}',
                style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Строка «иконка + текст». Используется на обоих экранах,
/// поэтому вынесена отдельно и не приватная.
class IconRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: colors.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
