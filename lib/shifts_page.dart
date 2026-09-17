import 'package:flutter/material.dart';

import 'shift.dart';
import 'shift_detail_page.dart';
import 'theme/app_colors.dart';
import 'widgets/common.dart';
import 'widgets/date_strip.dart';
import 'widgets/shift_card.dart';
import 'widgets/stories_row.dart';

/// Главный экран: подсказки, полоса дат и список смен.
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
    final selectedDate = dayAt(selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Wordmark(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          const StoriesRow(),
          DateStrip(
            today: today,
            selectedDay: selectedDay,
            hasShiftsOn: hasShiftsOn,
            // Когда пользователь нажал на дату — запоминаем её и просим
            // Flutter перерисовать экран. Это и есть «состояние экрана».
            onDaySelected: (day) => setState(() => selectedDay = day),
          ),
          _ListHeader(date: selectedDate, count: shifts.length),
          Expanded(
            child: shifts.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: shifts.length,
                    itemBuilder: (context, index) => ShiftCard(
                      shift: shifts[index],
                      onTap: () => openShift(shifts[index]),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

/// Строка над списком: какая дата выбрана и сколько смен найдено.
class _ListHeader extends StatelessWidget {
  final DateTime date;
  final int count;

  const _ListHeader({required this.date, required this.count});

  String get _countLabel {
    // Русские окончания: 1 смена, 2 смены, 5 смен.
    final last = count % 10;
    final lastTwo = count % 100;
    if (lastTwo >= 11 && lastTwo <= 14) return '$count смен';
    if (last == 1) return '$count смена';
    if (last >= 2 && last <= 4) return '$count смены';
    return '$count смен';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              '${date.day} ${monthsShort[date.month - 1]}, '
              '${weekdaysShort[date.weekday - 1]}',
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _countLabel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.muted,
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brand.withValues(alpha: 0.10),
              ),
              child: const Icon(
                Icons.event_busy_rounded,
                size: 44,
                color: AppColors.brand,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'На этот день смен нет',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Выберите другую дату — зелёная точка\nпод числом означает, '
              'что смены есть',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Нижнее меню. Пока рабочая только первая вкладка —
/// остальные экраны ещё не сделаны.
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: 0,
        height: 64,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.brand.withValues(alpha: 0.12),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_fire_department_outlined),
            selectedIcon: Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.brand,
            ),
            label: 'Смены',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_history_outlined),
            label: 'Мои',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
