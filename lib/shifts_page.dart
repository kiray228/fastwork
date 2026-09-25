import 'dart:async';

import 'package:flutter/material.dart';

import 'data/app_preferences.dart';
import 'data/repositories.dart';
import 'data/session.dart';
import 'package:fastwork_core/data/shift_filter.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/shift.dart';
import 'notifications_page.dart';
import 'shift_detail_page.dart';
import 'stories/story_actions.dart';
import 'theme/app_colors.dart';
import 'theme/glass.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';
import 'widgets/date_strip.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/nav.dart';
import 'widgets/shift_card.dart';
import 'widgets/skeleton.dart';
import 'widgets/stories_row.dart';

/// Главный экран: истории, ближайшая смена, полоса дат и список смен.
class ShiftsPage extends StatefulWidget {
  final AppRepositories repos;
  final AppSession session;
  final AppPreferences preferences;

  const ShiftsPage({
    super.key,
    required this.repos,
    required this.session,
    required this.preferences,
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
  List<String> categories = [];

  /// Текущие настройки ленты. Хранятся одним объектом — так их проще
  /// передать в окно фильтра и вернуть обратно.
  ShiftFilter filter = const ShiftFilter();

  /// Сколько уведомлений не прочитано — число в кружке на колокольчике.
  int unread = 0;

  /// Ближайшая смена, на которую человек записан. null — таких нет.
  Shift? upcoming;

  /// Идёт отметка «я на месте» с баннера — кнопку прячем под кружок.
  bool checkingIn = false;

  final TextEditingController searchController = TextEditingController();

  /// Отложенный запуск поиска.
  ///
  /// Без него запрос к базе уходил бы на **каждую букву**: набрал
  /// «грузчик» — семь запросов, из которых нужен только последний.
  /// Ждём, пока человек остановится на треть секунды, и только тогда ищем.
  /// Приём называется debounce.
  Timer? searchDebounce;

  ShiftRepository get repository => widget.repos.shifts;

  /// Истории собираются один раз на экран: в них картинки и тексты,
  /// пересобирать их на каждое движение ленты незачем.
  late final stories = storiesFor(widget.session);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    _load();
    _loadUnread();
    _loadUpcoming();
  }

  @override
  void dispose() {
    searchDebounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        filter = filter.copyWith(query: value);
        state = const Loading();
      });
      _load();
    });
  }

  DateTime dayAt(int index) =>
      DateTime(today.year, today.month, today.day + index);

  /// Запрашиваем данные у хранилища.
  ///
  /// `async`/`await` — это про ожидание: запрос к базе занимает время,
  /// и `await` говорит «подожди ответа, но не морозь при этом экран».
  Future<void> _load() async {
    final result = await load(() async {
      final loaded = await repository.shiftsOn(
        dayAt(selectedDay),
        filter: filter,
      );
      final days = await repository.daysWithShifts();
      final names = await repository.companies();
      final kinds = await repository.categories();
      return (loaded, days, names, kinds);
    });

    // Пока мы ждали ответа, пользователь мог уйти с экрана.
    // Тогда обновлять уже нечего — и Flutter ругнётся, если попробовать.
    if (!mounted) return;

    setState(() {
      switch (result) {
        case Ready(value: (final loaded, final days, final names, final kinds)):
          state = Ready(loaded);
          daysWithShifts = days;
          companies = names;
          categories = kinds;
        case Failed(:final error):
          state = Failed(error);
        case Loading():
          break;
      }
    });
  }

  /// Потянули ленту вниз — обновляем всё, что на экране.
  Future<void> _refresh() => Future.wait([
        _load(),
        _loadUnread(),
        _loadUpcoming(),
      ]);

  /// Число непрочитанных грузим **отдельным** запросом, а не вместе
  /// со сменами.
  ///
  /// Причина простая: если уведомления не ответят, лента всё равно должна
  /// показаться. Свяжи мы их в один запрос — упало бы всё сразу, и человек
  /// остался бы без смен из-за неработающего колокольчика.
  Future<void> _loadUnread() async {
    try {
      final count = await repository.unreadNotifications();
      if (!mounted) return;
      setState(() => unread = count);
    } catch (_) {
      // Не узнали — просто не показываем кружок.
    }
  }

  /// Ближайшая смена — по тому же правилу, что и колокольчик: отдельным
  /// запросом, чтобы её сбой не оставил человека без ленты.
  ///
  /// Раньше, чтобы узнать, когда и куда идти, нужно было открыть «Мои» и
  /// найти смену в списке. Теперь главное — на главном экране.
  Future<void> _loadUpcoming() async {
    try {
      final mine = await repository.myShifts(archived: false);
      final now = DateTime.now();
      final ahead = mine
          .where((s) => s.isApplied && !s.isCancelled && s.isAheadAt(now))
          .toList()
        ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
      if (!mounted) return;
      setState(() => upcoming = ahead.isEmpty ? null : ahead.first);
    } catch (_) {
      // Не узнали — баннера просто не будет.
    }
  }

  Future<void> _openNotifications() async {
    await Navigator.of(context).push(
      appRoute(
        NotificationsPage(
          session: widget.session,
          repository: repository,
        ),
      ),
    );
    // Вернулись — уведомления уже прочитаны, кружок пора убрать.
    await _loadUnread();
  }

  Future<void> _openStory(int index) => openStories(
        context,
        session: widget.session,
        repos: widget.repos,
        preferences: widget.preferences,
        initialIndex: index,
      );

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
      categories: categories,
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
          repository: repository,
          session: widget.session,
        ),
      ),
    );
    await _refresh();
  }

  /// «Я на месте» прямо с главного экрана — без захода в смену.
  Future<void> _checkIn(Shift shift) async {
    setState(() => checkingIn = true);
    final result = await guarded(context, () => repository.checkIn(shift.id));
    if (!mounted) return;
    setState(() => checkingIn = false);
    if (result == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(switch (result) {
          BookingResult.ok => 'Отметка принята — заказчик её видит',
          BookingResult.alreadyBooked => 'Вы уже отметились',
          BookingResult.tooEarlyToCheckIn =>
            'Отметиться можно в день смены, не раньше чем за час до начала',
          _ => 'Не получилось отметиться',
        }),
      ),
    );
    await _loadUpcoming();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = dayAt(selectedDay);
    final count = switch (state) {
      Ready(:final value) => value.length,
      _ => null,
    };
    final next = upcoming;

    return Scaffold(
      appBar: AppBar(
        title: const Wordmark(),
        actions: [
          _BellButton(unread: unread, onPressed: _openNotifications),
          const SizedBox(width: 4),
        ],
      ),
      // Вся лента листается целиком — истории и даты уезжают вверх вместе
      // со сменами. Раньше они стояли на месте и на телефоне занимали
      // половину экрана, а на карточки оставалось полторы строки.
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          // Тянуть вниз можно, даже когда смен нет: обновить пустой день
          // тоже бывает нужно.
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: StoriesRow(
                stories: stories,
                preferences: widget.preferences,
                onOpen: _openStory,
              ),
            ),
            if (next != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                  child: _NextShiftBanner(
                    shift: next,
                    now: DateTime.now(),
                    busy: checkingIn,
                    onOpen: () => _openShift(next),
                    onCheckIn: () => _checkIn(next),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: DateStrip(
                today: today,
                selectedDay: selectedDay,
                hasShiftsOn: (date) => daysWithShifts.contains(date),
                onDaySelected: _selectDay,
              ),
            ),
            SliverToBoxAdapter(
              child: _SearchField(
                controller: searchController,
                onChanged: _onSearchChanged,
                onClear: () {
                  searchController.clear();
                  _onSearchChanged('');
                },
              ),
            ),
            SliverToBoxAdapter(
              child: _ListHeader(
                date: selectedDate,
                count: count,
                filter: filter,
                onFilterTap: _openFilter,
              ),
            ),
            ...switch (state) {
              Loading() => [
                  const SliverToBoxAdapter(
                    child: ShiftListSkeleton(shrinkWrap: true),
                  ),
                ],
              Failed(:final error) => [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: ErrorView(
                      message: describeError(error),
                      onRetry: _retry,
                    ),
                  ),
                ],
              Ready(value: []) => [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: filter.isEmpty
                          ? Icons.event_busy_rounded
                          : Icons.filter_alt_off_rounded,
                      title: filter.isEmpty
                          ? 'На этот день смен нет'
                          : filter.query.isNotEmpty
                              ? 'По запросу ничего нет'
                              : 'Ничего не найдено',
                      subtitle: filter.isEmpty
                          ? 'Выберите другую дату — зелёная точка\n'
                              'под числом означает, что смены есть'
                          : filter.query.isNotEmpty
                              ? 'Проверьте написание\nили поищите в другой день'
                              : 'Попробуйте убрать часть условий\nв фильтре',
                    ),
                  ),
                ],
              Ready(:final value) => [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: SliverList.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) => AnimatedEntrance(
                        // Ключ по дню: при смене даты карточки появляются
                        // волной заново, а не просто подменяются.
                        key: ValueKey('$selectedDay/${value[index].id}'),
                        index: index,
                        child: ShiftCard(
                          shift: value[index],
                          userRating: widget.session.rating,
                          onTap: () => _openShift(value[index]),
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

/// Ближайшая смена — прямо на главном экране.
///
/// Когда можно отметиться, на баннере появляется кнопка «Я на месте»:
/// человек у проходной не должен искать смену по вкладкам.
class _NextShiftBanner extends StatelessWidget {
  final Shift shift;
  final DateTime now;
  final bool busy;
  final VoidCallback onOpen;
  final VoidCallback onCheckIn;

  const _NextShiftBanner({
    required this.shift,
    required this.now,
    required this.busy,
    required this.onOpen,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final canCheckIn = shift.canCheckInAt(now);
    final started = !now.isBefore(shift.startsAt);
    final day = relativeDay(shift.workDate, now);

    // Три строки вместо одной длинной: «что», «когда», «где». В одну
    // строку «Ближайшая смена · послезавтра, 09:00» не влезала, и время —
    // самое важное — обрезалось многоточием.
    final status = shift.isCheckedIn
        ? 'Вы на смене'
        : started
            ? 'Смена идёт'
            : 'Ближайшая смена';
    final when = '${day[0].toUpperCase()}${day.substring(1)}, '
        '${formatTime(shift.startMinutes)} — ${formatTime(shift.endMinutes)}';

    return SurfaceCard(
      onTap: onOpen,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.brand, AppColors.brandDark],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  shift.isCheckedIn
                      ? Icons.how_to_reg_rounded
                      : Icons.event_available_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brand,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      when,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 15.5),
                    ),
                    Text(
                      '${shift.company} · ${shift.address}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
          if (canCheckIn) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: busy ? null : onCheckIn,
                icon: busy
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.location_on_rounded, size: 18),
                label: const Text('Я на месте'),
              ),
            ),
          ],
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
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
    final on = activeCount > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: on
              ? AppColors.brand
              : glassFieldFill(context),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: on
                ? AppColors.brand
                : glassFieldEdge(context),
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

/// Строка поиска над лентой.
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      // ValueListenableBuilder слушает сам контроллер: крестик должен
      // появляться сразу при вводе, а не через треть секунды вместе
      // с результатами поиска.
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) => TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Сантехник, Магнум, Абая…',
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    onPressed: onClear,
                    tooltip: 'Очистить',
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}
