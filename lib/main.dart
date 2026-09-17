import 'package:flutter/material.dart';

import 'shifts_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FastworkApp());
}

class FastworkApp extends StatelessWidget {
  const FastworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fastwork',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      // themeMode.system — приложение само подхватит светлую или тёмную
      // тему из настроек телефона.
      themeMode: ThemeMode.system,
      // Ограничиваем ширину, чтобы на компьютере приложение выглядело как
      // телефон, а не растягивалось на весь монитор. На настоящем телефоне
      // экран уже, поэтому ограничение просто не срабатывает.
      builder: (context, child) => ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: child,
          ),
        ),
      ),
      home: const ShiftsPage(),
    );
  }
}
