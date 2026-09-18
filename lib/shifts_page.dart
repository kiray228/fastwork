import 'package:flutter/material.dart';

import 'data/session.dart';
import 'package:fastwork_core/data/shift_filter.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/shift.dart';
import 'notifications_page.dart';
import 'shift_detail_page.dart';
import 'theme/app_colors.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';
import 'widgets/date_strip.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/nav.dart';
import 'widgets/shift_card.dart';
import 'widgets/skeleton.dart';
import 'widgets/stories_row.dart';

/// Главный экран: подсказки, полоса дат и список смен.
class ShiftsPage extends StatefulWidget {
  final ShiftRepository repository;
  final AppSession session;

  const ShiftsPage({
    super.key,
    required this.repository,
    required this.session,
  });

  @override
  State<ShiftsPage> createState() => _ShiftsPageState();
}

class _ShiftsPageState extends State<ShiftsPage> {
  /// Сегодняшняя дата без времени. Считаем один раз, чтобы она не «поехала»,
  /// если пользователь задержится в приложении до полуночи.
  late final DateTime today;

  int selectedDay = 0;

  /// Три состояния вместо «списка или null»: грузим, получилось, сбой.
  /// Раньше при ошибке базы экран навсегда застревал на кружке — теперь
  /// он покажет, что случилось, и предложит повторить.
  Async<List<Shift>> state = const Loading();

  Set<DateTime> daysWithShifts = {};
  List<String> companies = [];

  /// Текущие настройки ленты. Хранятся одним объектом — так их проще
  /// передать в окно фильтра и вернуть обратно.
  ShiftFilter filter = const ShiftFilter();

  /// Сколько уведомлений не прочитано — число в кружке на колокольчике.
  int unread = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    _load();
    _loadUnread();
  }

  DateTime dayAt(int index) =>
      DateTime(today.year, today.month, today.day + index);

  /// Запрашиваем данные у хранилища.
  ///
  /// `async`/`await` — это про ожидание: запрос к базе занимает время,
  /// и `await` говорит «подожди ответа, но не морозь при этом экран».
  Future<void> _load() async {
    final result = await load(() async {
      final loaded = await widget.repository.shiftsOn(
        dayAt(selectedDay),
        filter: filter,
      );
      final days = await widget.repository.daysWithShifts();
      final names = await widget.repository.companies();
      return (loaded, days, names);
    });

    // Пока мы ждали ответа, пользователь мог уйти с экрана.
    // Тогда обновлять уже нечего — и Flutter ругнётся, если попробовать.
    if (!mounted) return;

    setState(() {
      switch (result) {
        case Ready(value: (final loaded, final days, final names)):
          state = Ready(loaded);
          daysWithShifts = days;
          companies = names;
        case Failed(:final error):
          state = Failed(error);
        case Loading():
          break;
      }
    });
  }

  /// Число непрочитанных грузим **отдельным** запросом, а не вместе
  /// со сменами.
  ///
  /// Причина простая: если уведомления не ответят, лента всё равно должна
  /// показаться. Свяжи мы их в один запрос — упало бы всё сразу, и человек
  /// остался бы без смен из-за неработающего колокольчика.
  Future<void> _loadUnread() async {
    try {
      final count = await widget.repository.unreadNotifications();
      if (!mounted) return;
      setState(() => unread = count);
    } catch (_) {
      // Не узнали — просто не показываем кружок.
    }
  }

  Future<void> _openNotifications() async {
    await Navigator.of(context).push(
      appRoute(
        NotificationsPage(
          session: widget.session,
          repository: widget.repository,
        ),
      ),
    );
    // Вернулись — уведомления уже прочитаны, кружок пора убрать.
    await _loadUnread();
  }

  void _retry() {
    setState(() => state = const Loading());
    _load();
  }

  /// Открыть окно фильтра и применить выбранное.
  Future<void> _openFilter() async {
    final result = await showFilterSheet(
      context,
      current: filter,
      companies: companies,
    );
    if (result == null || !mounted) return;

    setState(() {
      filter = result;
      state = const Loading();
    });
    await _load();
  }

  void _selectDay(int day) {
    setState(() {
      selectedDay = day;
      state = const Loading(); // показываем скелет, пока идёт запрос
    });
    _load();
  }

  /// Открыть экран «Подробнее» и обновить список после возврата:
  /// пользователь мог записаться, и число свободных мест изменилось.
  Future<void> _openShift(Shift shift) async {
    await Navigator.of(context).push(
      appRoute(
        ShiftDetailPage(
          shiftId: shift.id,
          repository: widget.repository,
          session: widget.session,
        ),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = dayAt(selectedDay);
    final count = switch (state) {
      Ready(:final value) => value.length,
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Wordmark(),
        actions: [
          _BellButton(unread: unread, onPressed: _openNotifications),
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
          _ListHeader(
            date: selectedDate,
            count: count,
            filter: filter,
            onFilterTap: _openFilter,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child: switch (state) {
                Loading() => const ShiftListSkeleton(),
                Failed(:final error) => ErrorView(
                    message: describeError(error),
                    onRetry: _retry,
                  ),
                Ready(value: []) => EmptyState(
                    icon: filter.isEmpty
                        ? Icons.event_busy_rounded
                        : Icons.filter_alt_off_rounded,
                    title: filter.isEmpty
                        ? 'На этот день смен нет'
                        : 'Ничего не найдено',
                    subtitle: filter.isEmpty
                        ? 'Выберите другую дату — зелёная точка\n'
                            'под числом означает, что смены есть'
                        : 'Попробуйте убрать часть условий\nв фильтре',
                  ),
                Ready(:final value) => RefreshIndicator(
                    onRefresh: _load,
                    // Ключ по дню: при смене даты AnimatedSwitcher видит
                    // новый список и проигрывает появление заново.
                    key: ValueKey(selectedDay),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: value.length,
                      itemBuilder: (context, index) => AnimatedEntrance(
                        index: index,
                        child: ShiftCard(
                          shift: value[index],
                          userRating: widget.session.rating,
                          onTap: () => _openShift(value[index]),
                        ),
                      ),
                    ),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Строка над списком: дата, число смен и кнопка фильтра.
class _ListHeader extends StatelessWidget {
  final DateTime date;
  final int? count;
  final ShiftFilter filter;
  final VoidCallback onFilterTap;

  const _ListHeader({
    required this.date,
    required this.count,
    required this.filter,
    required this.onFilterTap,
  });

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
    final active = filter.activeCount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
      child: Row(
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
          const Spacer(),
          _FilterButton(activeCount: active, onTap: onFilterTap),
        ],
      ),
    );
  }
}

/// Кнопка фильтра. Если что-то выбрано — показываем это числом,
/// чтобы пользователь не гадал, почему список короткий.
class _FilterButton extends StatelessWidget {
  final int activeCount;
  final VoidCallback onTap;

  const _FilterButton({required this.activeCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final on = activeCount > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: on
              ? AppColors.brand
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: on
                ? AppColors.brand
                : (isDark ? AppColors.darkBorder : AppColors.border),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tune_rounded,
              size: 16,
              color: on
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 6),
            Text(
              on ? 'Фильтр · $activeCount' : 'Фильтр',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: on
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Колокольчик с числом непрочитанных.
///
/// Кружок рисуется поверх значка через `Stack` — это обычный способ
/// положить одно на другое. Числа больше девяти не показываем: «12» уже
/// не помещается в кружок, а «9+» читается и означает то же самое —
/// «много».
class _BellButton extends StatelessWidget {
  final int unread;
  final VoidCallback onPressed;

  const _BellButton({required this.unread, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: 'Уведомления',
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            unread > 0
                ? Icons.notifications_rounded
                : Icons.notifications_none_rounded,
          ),
          if (unread > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                constraints: const BoxConstraints(minWidth: 16),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  unread > 9 ? '9+' : '$unread',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
