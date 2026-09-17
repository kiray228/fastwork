import 'package:flutter/material.dart';

import 'data/database.dart';
import 'data/fake_shift_repository.dart';
import 'data/shift_repository.dart';
import 'home_shell.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  // Нужно, если до запуска приложения мы обращаемся к диску или к системе.
  WidgetsFlutterBinding.ensureInitialized();

  // Открываем базу данных и, если она пустая, кладём в неё демо-смены.
  ShiftRepository repository;
  try {
    final database = AppDatabase();
    final dbRepository = DbShiftRepository(database);
    await dbRepository.seedIfEmpty();
    repository = dbRepository;
  } catch (error, stack) {
    // Если база не открылась (например, браузер запретил хранилище) —
    // приложение не должно падать белым экраном. Работаем на данных
    // в памяти: пользователь всё увидит, просто ничего не сохранится.
    debugPrint('Не удалось открыть базу данных: $error');
    debugPrint('$stack');
    repository = FakeShiftRepository();
  }

  runApp(FastworkApp(repository: repository));
}

class FastworkApp extends StatelessWidget {
  /// Хранилище передаётся снаружи. Приложение не создаёт базу само —
  /// поэтому в тестах вместо SQLite можно подсунуть данные в памяти.
  final ShiftRepository repository;

  const FastworkApp({super.key, required this.repository});

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
      home: HomeShell(repository: repository),
    );
  }
}
