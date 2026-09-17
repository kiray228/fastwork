import 'package:flutter/material.dart';

import 'data/auth_repository.dart';
import 'data/session.dart';
import 'data/shift_repository.dart';
import 'my_shifts_page.dart';
import 'profile_page.dart';
import 'shifts_page.dart';
import 'theme/app_colors.dart';

/// Каркас приложения: нижнее меню и три раздела.
class HomeShell extends StatefulWidget {
  final AppSession session;
  final ShiftRepository shifts;
  final AuthRepository auth;

  const HomeShell({
    super.key,
    required this.session,
    required this.shifts,
    required this.auth,
  });

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Создаём экран заново при каждом переключении вкладки —
    // так «Мои подработки» всегда показывают свежие данные из базы.
    final page = switch (index) {
      0 => ShiftsPage(repository: widget.shifts, session: widget.session),
      1 => MyShiftsPage(repository: widget.shifts, session: widget.session),
      _ => ProfilePage(session: widget.session, auth: widget.auth),
    };

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
