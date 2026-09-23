import 'package:flutter/material.dart';

import 'data/repositories.dart';
import 'data/session.dart';
import 'manager/create_shift_page.dart';
import 'manager/manager_shifts_page.dart';
import 'manager/rate_workers_page.dart';
import 'my_shifts_page.dart';
import 'profile_page.dart';
import 'shifts_page.dart';
import 'theme/app_colors.dart';
import 'theme/glass.dart';

/// Каркас приложения: нижнее меню и разделы.
///
/// Разделы разные для исполнителя и заказчика. Это и есть работа с ролями:
/// приложение одно, а что в нём доступно — зависит от того, кто вошёл.
class HomeShell extends StatefulWidget {
  final AppSession session;
  final AppRepositories repos;

  const HomeShell({super.key, required this.session, required this.repos});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    // Учебные данные: пара отработанных смен, чтобы архив, кошелёк и
    // отзывы не пустовали у нового исполнителя. Повторно ничего не
    // добавится — метод сам это проверяет.
    final user = widget.session.user;
    if (user != null && !user.isManager) {
      widget.repos.shifts.prepareDemoHistory(user.id);
    }
  }

  /// Переключение вкладки — заодно перечитываем пользователя из базы.
  ///
  /// Рейтинг и число отработанных смен считаются запросом, а не лежат
  /// в объекте `AppUser`. Значит, объект в памяти устаревает: заказчик
  /// поставил оценку — рейтинг в базе изменился, а на экране нет.
  /// Перечитывание при переходе решает это без всяких подписок.
  Future<void> _openTab(int value) async {
    setState(() => index = value);

    final user = widget.session.user;
    if (user == null) return;

    final fresh = await widget.repos.auth.refresh(user.id);
    if (fresh != null && mounted) widget.session.setUser(fresh);
  }

  @override
  Widget build(BuildContext context) {
    final isManager = widget.session.user?.isManager ?? false;

    // Создаём экран заново при каждом переключении вкладки —
    // так данные всегда свежие из базы.
    final Widget page;
    if (isManager) {
      page = switch (index) {
        0 => ManagerShiftsPage(
            session: widget.session,
            repository: widget.repos.shifts,
          ),
        1 => CreateShiftPage(
            session: widget.session,
            repository: widget.repos.shifts,
            onCreated: () => setState(() => index = 0),
          ),
        2 => RateWorkersPage(
            session: widget.session,
            repository: widget.repos.shifts,
          ),
        _ => ProfilePage(session: widget.session, repos: widget.repos),
      };
    } else {
      page = switch (index) {
        0 => ShiftsPage(
            repository: widget.repos.shifts,
            session: widget.session,
          ),
        1 => MyShiftsPage(
            repository: widget.repos.shifts,
            session: widget.session,
          ),
        _ => ProfilePage(session: widget.session, repos: widget.repos),
      };
    }

    return Scaffold(
      // Вкладки не переключаются рывком: старая растворяется, новая
      // проявляется. `KeyedSubtree` с ключом-номером нужен, чтобы
      // AnimatedSwitcher понял, что перед ним именно другой экран.
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(key: ValueKey(index), child: page),
      ),
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
                ? const [
                    NavigationDestination(
                      icon: Icon(Icons.event_note_outlined),
                      selectedIcon: Icon(
                        Icons.event_note_rounded,
                        color: AppColors.brand,
                      ),
                      label: 'Мои смены',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.add_circle_outline_rounded),
                      selectedIcon: Icon(
                        Icons.add_circle_rounded,
                        color: AppColors.brand,
                      ),
                      label: 'Создать',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.star_outline_rounded),
                      selectedIcon: Icon(
                        Icons.star_rounded,
                        color: AppColors.brand,
                      ),
                      label: 'Оценки',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(
                        Icons.person_rounded,
                        color: AppColors.brand,
                      ),
                      label: 'Профиль',
                    ),
                  ]
                : const [
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
                      selectedIcon: Icon(
                        Icons.work_history_rounded,
                        color: AppColors.brand,
                      ),
                      label: 'Мои',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(
                        Icons.person_rounded,
                        color: AppColors.brand,
                      ),
                      label: 'Профиль',
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
