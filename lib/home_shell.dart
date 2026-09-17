import 'package:flutter/material.dart';

import 'data/repositories.dart';
import 'data/session.dart';
import 'manager/create_shift_page.dart';
import 'manager/manager_shifts_page.dart';
import 'my_shifts_page.dart';
import 'profile_page.dart';
import 'shifts_page.dart';
import 'theme/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
      body: page,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          height: 64,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          indicatorColor: AppColors.brand.withValues(alpha: 0.12),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (i) => setState(() => index = i),
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
    );
  }
}
