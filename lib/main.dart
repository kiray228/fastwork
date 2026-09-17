import 'package:flutter/material.dart';

import 'auth/register_page.dart';
import 'data/auth_repository.dart';
import 'data/database.dart';
import 'data/fake_shift_repository.dart';
import 'data/repositories.dart';
import 'data/session.dart';
import 'data/shift_repository.dart';
import 'data/support_repository.dart';
import 'home_shell.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  // Нужно, если до запуска приложения мы обращаемся к диску или к системе.
  WidgetsFlutterBinding.ensureInitialized();

  final session = AppSession();
  late final AppRepositories repos;

  try {
    final database = AppDatabase();
    final dbShifts = DbShiftRepository(database, session);
    await dbShifts.seedIfEmpty();
    repos = AppRepositories(
      shifts: dbShifts,
      auth: DbAuthRepository(database),
      documents: DbDocumentRepository(database, session),
      support: DbSupportRepository(database, session),
    );
  } catch (error, stack) {
    // Если база не открылась (например, браузер запретил хранилище) —
    // приложение не должно падать белым экраном. Работаем на данных
    // в памяти: пользователь всё увидит, просто ничего не сохранится.
    debugPrint('Не удалось открыть базу данных: $error');
    debugPrint('$stack');
    repos = AppRepositories(
      shifts: FakeShiftRepository(),
      auth: FakeAuthRepository(),
      documents: FakeDocumentRepository(),
      support: FakeSupportRepository(),
    );
  }

  // Кто входил в прошлый раз — если кто-то входил, сразу пускаем внутрь.
  session.setUser(await repos.auth.restoreSession());

  runApp(FastworkApp(session: session, repos: repos));
}

class FastworkApp extends StatelessWidget {
  final AppSession session;
  final AppRepositories repos;

  const FastworkApp({
    super.key,
    required this.session,
    required this.repos,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fastwork',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      // Ограничиваем ширину, чтобы на компьютере приложение выглядело как
      // телефон, а не растягивалось на весь монитор.
      builder: (context, child) => ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: child,
          ),
        ),
      ),
      home: _AuthGate(session: session, repos: repos),
    );
  }
}

/// Развилка на входе: вошёл — показываем приложение, нет — регистрацию.
///
/// `ListenableBuilder` подписан на сессию: как только человек войдёт или
/// выйдет, этот кусок перерисуется сам. Нам не нужно нигде вручную
/// «переключать экран».
class _AuthGate extends StatelessWidget {
  final AppSession session;
  final AppRepositories repos;

  const _AuthGate({required this.session, required this.repos});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: session,
      builder: (context, _) => session.isSignedIn
          ? HomeShell(session: session, repos: repos)
          : RegisterPage(session: session, auth: repos.auth),
    );
  }
}
