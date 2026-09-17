import 'package:flutter/material.dart';

import 'data/shift_repository.dart';
import 'shift.dart';
import 'shift_detail_page.dart';
import 'theme/app_colors.dart';
import 'widgets/common.dart';
import 'widgets/date_strip.dart';
import 'widgets/shift_card.dart';
import 'widgets/stories_row.dart';

/// Главный экран: подсказки, полоса дат и список смен.
class ShiftsPage extends StatefulWidget {
  final ShiftRepository repository;

  const ShiftsPage({super.key, required this.repository});

  @override
  State<ShiftsPage> createState() => _ShiftsPageState();
}

class _ShiftsPageState extends State<ShiftsPage> {
  /// Сегодняшняя дата без времени. Считаем один раз, чтобы она не «поехала»,
  /// если пользователь задержится в приложении до полуночи.
  late final DateTime today;

  int selectedDay = 0;

  /// null означает «ещё грузим». Пустой список — «смен нет».
  /// Это разные состояния, и показывать их надо по-разному.
  List<Shift>? shifts;
  Set<DateTime> daysWithShifts = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    _load();
  }

  DateTime dayAt(int index) =>
      DateTime(today.year, today.month, today.day + index);

  /// Запрашиваем данные у хранилища.
  ///
  /// `async`/`await` — это про ожидание: запрос к базе занимает время,
  /// и `await` говорит «подожди ответа, но не морозь при этом экран».
  Future<void> _load() async {
    final loaded = await widget.repository.shiftsOn(dayAt(selectedDay));
    final days = await widget.repository.daysWithShifts();

    // Пока мы ждали ответа, пользователь мог уйти с экрана.
    // Тогда обновлять уже нечего — и Flutter ругнётся, если попробовать.
    if (!mounted) return;

    setState(() {
      shifts = loaded;
      daysWithShifts = days;
    });
  }

  void _selectDay(int day) {
    setState(() {
      selectedDay = day;
      shifts = null; // показываем «грузим», пока идёт запрос
    });
    _load();
  }

  /// Открыть экран «Подробнее» и обновить список после возврата:
  /// пользователь мог оставить заявку, и число свободных мест изменилось.
  Future<void> _openShift(Shift shift) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShiftDetailPage(
          shiftId: shift.id,
          repository: widget.repository,
        ),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final list = shifts;
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
            hasShiftsOn: (date) => daysWithShifts.contains(date),
            onDaySelected: _selectDay,
          ),
          _ListHeader(date: selectedDate, count: list?.length),
          Expanded(
            child: switch (list) {
              null => const Center(child: CircularProgressIndicator()),
              [] => const EmptyState(
                  icon: Icons.event_busy_rounded,
                  title: 'На этот день смен нет',
                  subtitle: 'Выберите другую дату — зелёная точка\n'
                      'под числом означает, что смены есть',
                ),
              final items => RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) => ShiftCard(
                      shift: items[index],
                      onTap: () => _openShift(items[index]),
                    ),
                  ),
                ),
            },
          ),
        ],
      ),
    );
  }
}

/// Строка над списком: какая дата выбрана и сколько смен найдено.
class _ListHeader extends StatelessWidget {
  final DateTime date;
  final int? count;

  const _ListHeader({required this.date, required this.count});

  String get _countLabel {
    final c = count;
    if (c == null) return '';
    // Русские окончания: 1 смена, 2 смены, 5 смен.
    final last = c % 10;
    final lastTwo = c % 100;
    if (lastTwo >= 11 && lastTwo <= 14) return '$c смен';
    if (last == 1) return '$c смена';
    if (last >= 2 && last <= 4) return '$c смены';
    return '$c смен';
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
