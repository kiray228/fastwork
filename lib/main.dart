import 'package:flutter/material.dart';

import 'shifts_page.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
      ),
      // Ограничиваем ширину, чтобы на компьютере приложение выглядело как
      // телефон, а не растягивалось на весь монитор. На настоящем телефоне
      // экран уже, поэтому ограничение просто не срабатывает.
      builder: (context, child) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: child,
        ),
      ),
      home: const ShiftsPage(),
    );
  }
}
