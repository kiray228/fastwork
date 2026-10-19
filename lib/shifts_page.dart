import 'dart:async';

import 'package:flutter/material.dart';

import 'category_alerts_page.dart';
import 'data/app_preferences.dart';
import 'data/repositories.dart';
import 'data/session.dart';
import 'documents_page.dart';
import 'package:fastwork_core/data/shift_filter.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/shift.dart';
import 'notifications_page.dart';
import 'shift_detail_page.dart';
import 'stories/story_actions.dart';
import 'theme/app_colors.dart';
import 'theme/glass.dart';
import 'widgets/async_state.dart';
import 'widgets/check_in_dialog.dart';
import 'widgets/common.dart';
import 'widgets/date_strip.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/nav.dart';
import 'widgets/shift_card.dart';
import 'widgets/skeleton.dart';
import 'widgets/stories_row.dart';
import 'l10n/strings.dart';

/// Главный экран: истории, ближайшая смена, полоса дат и список смен.
class ShiftsPage extends StatefulWidget {
  final AppRepositories repos;
  final AppSession session;
  final AppPreferences preferences;

  /// Срабатывает, когда на ленту вернулись с другой вкладки. Экран при
  /// этом не пересоздаётся — фильтр, поиск и день остаются, — а смены
  /// перечитываются: пока человек был в профиле, их могли разобрать.
  final Listenable? shownAgain;

  const ShiftsPage({
    super.key,
    required this.repos,
    required this.session,
    required this.preferences,
    this.shownAgain,
  });

  @override
  State<ShiftsPage> createState() => _ShiftsPageState();
}

class _ShiftsPageState extends State<ShiftsPage> {
  /// Сегодняшняя дата без времени. Считаем один раз, чтобы она не «поехала»,
  /// если пользователь задержится в приложении до полуночи. Пересчитываем,
  /// только когда на ленту вернулись (`_onShownAgain`): экран теперь живёт
  /// между вкладками и может дожить до завтра.
  late DateTime today;

  int selectedDay = 0;

  /// Лента ещё ни разу не загружалась — см. конец `_load`.
  bool _firstLoad = true;

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

  /// Сколько смен в ленте требуют санкнижку — не своих.
  int get _medicalShifts => switch (state) {
        Ready(:final value) =>
          value.where((s) => s.needsMedicalBook && !s.isMine).length,
        _ => 0,
      };

  /// Номер последнего запроса ленты — см. `_load`.
  int _loadSeq = 0;

  /// Показать карточку «Какая работа вам интересна?»: человек ещё не
  /// выбрал ни одного вида работ. Узнаём вместе с тем, что ему подходит.
  bool askInterests = false;

  /// Есть ли у человека санкнижка (проверенная или на проверке, не
  /// просроченная). null — ещё не узнавали: спрашиваем, только когда в
  /// ленте появились смены, где она нужна.
  bool? hasMedicalBook;

  /// Закрыл подсказку про санкнижку — до следующего запуска не показываем.
  bool medicalNudgeHidden = false;

  Future<void> _checkMedicalBook() async {
    try {
      final docs = await widget.repos.documents.documents();
      final now = DateTime.now();
      final has = docs.any((d) =>
          d.type == 'medical_book' &&
          d.status != 'rejected' &&
          !d.isExpiredAt(now));
      if (mounted) setState(() => hasMedicalBook = has);
    } catch (_) {
      // Не узнали — подсказку не показываем: лучше промолчать, чем
      // зря просить книжку у того, у кого она есть.
    }
  }

  Future<void> _addMedicalBook() async {
    await Navigator.of(context).push(
      appRoute(
        DocumentsPage(
          repository: widget.repos.documents,
          session: widget.session,
        ),
      ),
    );
    await _checkMedicalBook();
  }

  Future<void> _chooseInterests() async {
    await Navigator.of(context).push(
      appRoute(
        CategoryAlertsPage(
          repository: repository,
          city: widget.session.city,
        ),
      ),
    );
    // Выбрал — карточка уходит, а ярлыки «Вам подходит» появляются сразу.
    await _loadTaste();
    if (filter.sort != ShiftSort.forYou) await _load();
  }

  /// Истории собираются один раз на экран: в них картинки и тексты,
  /// пересобирать их на каждое движение ленты незачем.
  late final stories = storiesFor(widget.session);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    _load();
    _loadTaste();
    _loadUnread();
    _loadUpcoming();
    widget.shownAgain?.addListener(_onShownAgain);
  }

  @override
  void didUpdateWidget(ShiftsPage old) {
    super.didUpdateWidget(old);
    if (old.shownAgain != widget.shownAgain) {
      old.shownAgain?.removeListener(_onShownAgain);
      widget.shownAgain?.addListener(_onShownAgain);
    }
  }

  /// Вернулись на ленту — перечитываем то, что могло устареть.
  void _onShownAgain() {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    // Наступило завтра: полоса дат начинается с нового «сегодня». Выбранный
    // день — номер в полосе — сдвигаем, чтобы осталась та же дата; если она
    // уже прошла — первый день.
    if (day != today) {
      final passed = day.difference(today).inDays;
      setState(() {
        today = day;
        if (selectedDay != DateStrip.allDays) {
          selectedDay = selectedDay - passed < 0 ? 0 : selectedDay - passed;
        }
      });
    }
    _refresh();
  }

  @override
  void dispose() {
    widget.shownAgain?.removeListener(_onShownAgain);
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
    // Номер запроса. Человек быстро тапнул «3 окт», потом «4 окт»: если
    // ответ про третье придёт позже, он не должен лечь под заголовок
    // четвёртого. Показываем только ответ на последний запрос.
    final seq = ++_loadSeq;
    final result = await load(() async {
      // Компании и виды работ для фильтра не зависят от дня — спрашиваем
      // их сразу, параллельно со сменами, а не по очереди после них.
      final names = repository.companies();
      final kinds = repository.categories();
      final days = await repository.daysWithShifts();
      final List<Shift> loaded;
      if (selectedDay == DateStrip.allDays) {
        // Все дни — это дни с точками в полосе: пустые спрашивать незачем.
        final ahead = [
          for (var i = 0; i < DateStrip.days; i++)
            if (days.contains(dayAt(i))) dayAt(i),
        ];
        final perDay = await Future.wait(
            ahead.map((day) => repository.shiftsOn(day, filter: filter)));
        loaded = [for (final list in perDay) ...list];
      } else {
        loaded = await repository.shiftsOn(dayAt(selectedDay), filter: filter);
      }
      return (loaded, days, await names, await kinds);
    });

    // Пока мы ждали ответа, пользователь мог уйти с экрана.
    // Тогда обновлять уже нечего — и Flutter ругнётся, если попробовать.
    if (!mounted || seq != _loadSeq) return;

    // Первый взгляд днём: утренние смены уже начались, записаться сегодня
    // не на что, хотя завтра и дальше смены есть. Пустая лента при первом
    // запуске выглядит как неработающее приложение — поэтому вместо неё
    // сразу «Все дни». Только в первый раз: выбранный руками пустой день
    // остаётся пустым, как человек и просил.
    if (result case Ready(value: (final loaded, final days, _, _))
        when _firstLoad) {
      _firstLoad = false;
      if (selectedDay == 0 && loaded.isEmpty && days.isNotEmpty) {
        setState(() {
          selectedDay = DateStrip.allDays;
          state = const Loading();
        });
        await _load();
        return;
      }
    }

    setState(() {
      switch (result) {
        case Ready(value: (final loaded, final days, final names, final kinds)):
          state = Ready(loaded);
          daysWithShifts = days;
          companies = names;
          categories = kinds;
          if (hasMedicalBook == null &&
              loaded.any((s) => s.needsMedicalBook)) {
            _checkMedicalBook();
          }
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
  /// Что подходит человеку — отдельно и молча, как колокольчик: не
  /// узнали — лента та же, просто без отметок «Вам подходит».
  Future<void> _loadTaste() async {
    try {
      final taste = await repository.workerTaste();
      if (!mounted) return;
      // Видов работ не выбрано — спросим карточкой вверху ленты.
      setState(() => askInterests = taste.followedCategories.isEmpty);
      if (taste.isEmpty) return;
      setState(() => filter = filter.copyWith(taste: taste));
      // Сортировку «Сначала подходящие» пересчитываем с новым знанием.
      if (filter.sort == ShiftSort.forYou) await _load();
    } catch (_) {
      // Без подсказок лента всё равно полезна.
    }
  }

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
    final choice = await showCheckInDialog(context);
    if (choice == null || !mounted) return;
    final code = choice is WithCode ? choice.code : null;

    setState(() => checkingIn = true);
    final result = await guarded(
      context,
      () => repository.checkIn(shift.id, code: code),
    );
    if (!mounted) return;
    setState(() => checkingIn = false);
    if (result == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(switch (result) {
          BookingResult.ok when code != null => tr.feed.checkInByCode,
          BookingResult.ok => tr.feed.checkInAccepted,
          BookingResult.alreadyBooked => tr.feed.alreadyCheckedIn,
          BookingResult.wrongCode => tr.feed.wrongCheckInCode,
          BookingResult.tooManyAttempts => tr.feed.checkInLocked,
          BookingResult.tooEarlyToCheckIn => tr.feed.checkInTooEarly,
          _ => tr.feed.checkInFailed,
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
            // Новичку «Вам подходит» не из чего собрать — спросим прямо.
            if (askInterests && !widget.preferences.interestsHidden)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: _InterestsCard(
                    onChoose: _chooseInterests,
                    onHide: () async {
                      await widget.preferences.hideInterests();
                      if (mounted) setState(() {});
                    },
                  ),
                ),
              ),
            // Смены с продуктами в ленте есть, а санкнижки нет — сказать,
            // сколько работы она откроет и где её добавить.
            if (_medicalShifts > 0 &&
                hasMedicalBook == false &&
                !medicalNudgeHidden)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: _MedicalBookCard(
                    shifts: _medicalShifts,
                    onAdd: _addMedicalBook,
                    onHide: () => setState(() => medicalNudgeHidden = true),
                  ),
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
                date: selectedDay == DateStrip.allDays ? null : selectedDate,
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
                          ? tr.feed.emptyDayTitle
                          : filter.query.isNotEmpty
                              ? tr.feed.emptyQueryTitle
                              : tr.feed.emptyFilterTitle,
                      subtitle: filter.isEmpty
                          ? tr.feed.emptyDaySubtitle
                          : filter.query.isNotEmpty
                              ? tr.feed.emptyQuerySubtitle
                              : tr.feed.emptyFilterSubtitle,
                    ),
                  ),
                ],
              Ready(:final value) when selectedDay == DateStrip.allDays => [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: SliverList.list(
                      children: [
                        for (final (index, shift) in value.indexed) ...[
                          // Новый день — подпись над его первой сменой.
                          if (index == 0 ||
                              !isSameDay(value[index - 1].workDate,
                                  shift.workDate))
                            DayHeading(date: shift.workDate),
                          AnimatedEntrance(
                            key: ValueKey('all/${shift.id}'),
                            index: index,
                            child: ShiftCard(
                              shift: shift,
                              userRating: widget.session.rating,
                              forYou: filter.taste.matches(shift),
                              onTap: () => _openShift(shift),
                            ),
                          ),
                        ],
                      ],
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
                          forYou: filter.taste.matches(value[index]),
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
        ? tr.feed.statusOnShift
        : started
            ? tr.feed.statusInProgress
            : tr.feed.statusNextShift;
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
                label: Text(tr.feed.imHere),
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
  /// null — «Все дни».
  final DateTime? date;
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
    return shiftsLabel(c);
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
              switch (date) {
                null => tr.feed.allDaysTitle,
                final date => tr.core.dayMonthWeekday(date),
              },
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

/// Подпись дня в списке «Все дни»: «Завтра, 9 окт, пт».
class DayHeading extends StatelessWidget {
  final DateTime date;

  const DayHeading({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final relative = relativeDay(date, DateTime.now());
    final full = tr.core.dayMonthWeekday(date);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 10),
      child: Text(
        relative == full
            ? full
            : '${relative[0].toUpperCase()}${relative.substring(1)}, $full',
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontSize: 14.5, color: AppColors.muted),
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
              on ? tr.feed.filterCount(activeCount) : tr.feed.filter,
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
      tooltip: tr.feed.notifications,
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
            hintText: tr.feed.searchHint,
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    onPressed: onClear,
                    tooltip: tr.feed.clear,
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

/// Карточка «Какая работа вам интересна?» — для того, кто ещё ничего не
/// выбрал. Ведёт в подписки на виды работ: выбор сразу включает и
/// подсказки «Вам подходит», и уведомления о новых сменах.
/// «Санкнижка откроет ещё 5 смен»: в ленте есть смены с продуктами, а
/// книжки у человека нет.
class _MedicalBookCard extends StatelessWidget {
  final int shifts;
  final VoidCallback onAdd;
  final VoidCallback onHide;

  const _MedicalBookCard({
    required this.shifts,
    required this.onAdd,
    required this.onHide,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
      child: Row(
        children: [
          const Icon(Icons.medical_information_outlined,
              color: AppColors.brand),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.feed.medicalNudgeTitle(shiftsLabel(shifts)),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 14.5),
                ),
                const SizedBox(height: 4),
                Text(
                  tr.feed.medicalNudgeBody,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.muted,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: onAdd,
                  child: Text(tr.feed.medicalNudgeAction),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onHide,
            tooltip: tr.feed.interestsHide,
            icon: const Icon(Icons.close_rounded, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _InterestsCard extends StatelessWidget {
  final VoidCallback onChoose;
  final VoidCallback onHide;

  const _InterestsCard({required this.onChoose, required this.onHide});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: AppColors.brand),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.feed.interestsTitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 14.5),
                ),
                const SizedBox(height: 4),
                Text(
                  tr.feed.interestsBody,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.muted,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: onChoose,
                  child: Text(tr.feed.interestsAction),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onHide,
            tooltip: tr.feed.interestsHide,
            icon: const Icon(Icons.close_rounded, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
