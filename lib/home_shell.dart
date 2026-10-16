import 'package:flutter/material.dart';

import 'data/app_preferences.dart';
import 'data/repositories.dart';
import 'data/session.dart';
import 'manager/create_shift_page.dart';
import 'manager/manager_shifts_page.dart';
import 'manager/rate_workers_page.dart';
import 'my_shifts_page.dart';
import 'profile_page.dart';
import 'shift_detail_page.dart';
import 'shifts_page.dart';
import 'theme/app_colors.dart';
import 'theme/glass.dart';
import 'l10n/strings.dart';
import 'widgets/nav.dart';

/// Каркас приложения: нижнее меню и разделы.
///
/// Разделы разные для исполнителя и заказчика. Это и есть работа с ролями:
/// приложение одно, а что в нём доступно — зависит от того, кто вошёл.
class HomeShell extends StatefulWidget {
  final AppSession session;
  final AppRepositories repos;
  final AppPreferences preferences;

  /// Смена, которую нужно сразу открыть, — пришли по ссылке на неё.
  final int? openShiftId;
  final VoidCallback? onShiftOpened;

  const HomeShell({
    super.key,
    required this.session,
    required this.repos,
    required this.preferences,
    this.openShiftId,
    this.onShiftOpened,
  });

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell>
    with SingleTickerProviderStateMixin {
  int index = 0;

  /// Вкладки, которые уже открывали, — их экраны живут и дальше.
  final _visited = <int>{0};

  /// Сколько раз открывали вкладку — ключ экранов, которые при каждом
  /// открытии создаются заново.
  final _opened = <int, int>{};

  /// Сколько смен создано — ключ формы: после создания она чистая.
  int _created = 0;

  /// Лента снова на экране — пусть перечитает смены, не теряя фильтра.
  final _feedShown = ValueNotifier<int>(0);

  /// Вкладки не переключаются рывком: новая проявляется.
  late final _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    value: 1,
  );

  @override
  void initState() {
    super.initState();
    // Учебные данные: пара отработанных смен, чтобы архив, кошелёк и
    // отзывы не пустовали у нового исполнителя. Повторно ничего не
    // добавится — метод сам это проверяет.
    final user = widget.session.user;
    if (user != null && !user.isManager) {
      _prepareDemo(user.id);
    }

    // Пришли по ссылке на смену — открываем её поверх ленты. После первого
    // кадра: до него открывать экран не над чем.
    final shared = widget.openShiftId;
    if (shared != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.onShiftOpened?.call();
        Navigator.of(context).push(
          appRoute(ShiftDetailPage(
            shiftId: shared,
            repository: widget.repos.shifts,
            session: widget.session,
          )),
        );
      });
    }
  }

  /// Завести учебную историю и сразу перечитать человека: иначе профиль
  /// до первого переключения вкладки показывал «0 смен», хотя отработанные
  /// смены уже лежат в архиве и кошельке.
  Future<void> _prepareDemo(int userId) async {
    try {
      await widget.repos.shifts.prepareDemoHistory(userId);
      final fresh = await widget.repos.auth.refresh(userId);
      if (fresh != null && mounted) widget.session.setUser(fresh);
    } catch (_) {
      // Без учебной истории приложение работает так же — просто беднее.
    }
  }

  @override
  void dispose() {
    _fade.dispose();
    _feedShown.dispose();
    super.dispose();
  }

  /// Переключение вкладки — заодно перечитываем пользователя из базы.
  ///
  /// Рейтинг и число отработанных смен считаются запросом, а не лежат
  /// в объекте `AppUser`. Значит, объект в памяти устаревает: заказчик
  /// поставил оценку — рейтинг в базе изменился, а на экране нет.
  /// Перечитывание при переходе решает это без всяких подписок.
  Future<void> _openTab(int value) async {
    if (value != index) {
      setState(() {
        index = value;
        _visited.add(value);
        _opened[value] = (_opened[value] ?? 0) + 1;
      });
      _fade.forward(from: 0);
      if (!_isManager && value == 0) _feedShown.value++;
    }

    final user = widget.session.user;
    if (user == null) return;

    final fresh = await widget.repos.auth.refresh(user.id);
    if (fresh != null && mounted) widget.session.setUser(fresh);
  }

  bool get _isManager => widget.session.user?.isManager ?? false;

  /// Какие вкладки не пересоздаются при переключении.
  ///
  /// Раньше каждая вкладка строилась заново при каждом переходе: данные
  /// свежие, но вместе с ними пропадало и то, что человек успел сделать, —
  /// фильтр, поиск и день в ленте, наполовину заполненная форма смены.
  /// Теперь лента и форма живут, пока жив каркас. Лента при возвращении
  /// сама перечитывает смены (`_feedShown`), так что устаревшего человек не
  /// увидит. Остальные вкладки держать незачем: в них нечего терять, а
  /// созданные заново, они точно свежие.
  bool _keeps(int tab) => _isManager ? tab == 1 : tab == 0;

  Widget _page(int tab) {
    if (_isManager) {
      return switch (tab) {
        0 => ManagerShiftsPage(
            session: widget.session,
            repos: widget.repos,
            preferences: widget.preferences,
            // Истории и пустой список зовут «Создать смену» и «Оценить» —
            // а переключать вкладки умеет только каркас.
            onOpenTab: _openTab,
          ),
        1 => CreateShiftPage(
            key: ValueKey('create-$_created'),
            session: widget.session,
            repository: widget.repos.shifts,
            onCreated: () {
              // Смена создана — следующая начнётся с чистой формы, а не
              // с копии только что опубликованной.
              setState(() => _created++);
              _openTab(0);
            },
          ),
        2 => RateWorkersPage(
            session: widget.session,
            repository: widget.repos.shifts,
          ),
        _ => ProfilePage(
            session: widget.session,
            repos: widget.repos,
            preferences: widget.preferences,
            onOpenTab: _openTab,
          ),
      };
    }
    return switch (tab) {
      0 => ShiftsPage(
          repos: widget.repos,
          session: widget.session,
          preferences: widget.preferences,
          shownAgain: _feedShown,
        ),
      1 => MyShiftsPage(
          repository: widget.repos.shifts,
          session: widget.session,
          onFindShifts: () => _openTab(0),
        ),
      _ => ProfilePage(
          session: widget.session,
          repos: widget.repos,
          preferences: widget.preferences,
          onOpenTab: _openTab,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isManager = _isManager;
    final role = isManager ? 'manager' : 'worker';
    final tabs = isManager ? 4 : 3;

    // Скрытая вкладка не рисуется, не ловит касаний и не крутит анимаций,
    // но её состояние на месте. Ключи у всех: соседи появляются и
    // исчезают, а живая вкладка не должна при этом потерять себя.
    final pages = <Widget>[
      for (var tab = 0; tab < tabs; tab++)
        if (_keeps(tab) ? _visited.contains(tab) : tab == index)
          KeyedSubtree(
            key: ValueKey(_keeps(tab)
                ? '$role-$tab'
                : '$role-$tab-${_opened[tab] ?? 0}'),
            child: Offstage(
              offstage: tab != index,
              child: TickerMode(
                enabled: tab == index,
                child: FadeTransition(
                  opacity: tab == index ? _fade : kAlwaysCompleteAnimation,
                  child: _page(tab),
                ),
              ),
            ),
          ),
    ];

    return Scaffold(
      body: Stack(fit: StackFit.expand, children: pages),
      // Меню не прибито к краю, а парит над фоном стеклянной капсулой.
      // Под ним видно фон — и ясно, что это слой поверх, а не часть экрана.
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: Glass(
          elevated: true,
          borderRadius: BorderRadius.circular(34),
          child: NavigationBar(
            selectedIndex: index,
            height: 66,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            indicatorColor: AppColors.brand.withValues(alpha: 0.12),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: _openTab,
            destinations: isManager
                ? [
                    NavigationDestination(
                      icon: Icon(Icons.event_note_outlined),
                      selectedIcon: Icon(
                        Icons.event_note_rounded,
                        color: AppColors.brand,
                      ),
                      label: tr.common.navMyShifts,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.add_circle_outline_rounded),
                      selectedIcon: Icon(
                        Icons.add_circle_rounded,
                        color: AppColors.brand,
                      ),
                      label: tr.common.navCreate,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.star_outline_rounded),
                      selectedIcon: Icon(
                        Icons.star_rounded,
                        color: AppColors.brand,
                      ),
                      label: tr.common.navRatings,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(
                        Icons.person_rounded,
                        color: AppColors.brand,
                      ),
                      label: tr.common.navProfile,
                    ),
                  ]
                : [
                    NavigationDestination(
                      icon: Icon(Icons.local_fire_department_outlined),
                      selectedIcon: Icon(
                        Icons.local_fire_department_rounded,
                        color: AppColors.brand,
                      ),
                      label: tr.common.navShifts,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.work_history_outlined),
                      selectedIcon: Icon(
                        Icons.work_history_rounded,
                        color: AppColors.brand,
                      ),
                      label: tr.common.navMine,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(
                        Icons.person_rounded,
                        color: AppColors.brand,
                      ),
                      label: tr.common.navProfile,
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
