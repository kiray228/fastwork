import 'package:flutter/material.dart';

import 'auth/register_page.dart';
import 'data/auth_repository.dart';
import 'data/database.dart';
import 'data/fake_shift_repository.dart';
import 'data/session.dart';
import 'data/shift_repository.dart';
import 'home_shell.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  // Нужно, если до запуска приложения мы обращаемся к диску или к системе.
  WidgetsFlutterBinding.ensureInitialized();

  final session = AppSession();
  late final ShiftRepository shifts;
  late final AuthRepository auth;

  try {
    final database = AppDatabase();
    final dbShifts = DbShiftRepository(database, session);
    await dbShifts.seedIfEmpty();
    shifts = dbShifts;
    auth = DbAuthRepository(database);
  } catch (error, stack) {
    // Если база не открылась (например, браузер запретил хранилище) —
    // приложение не должно падать белым экраном. Работаем на данных
    // в памяти: пользователь всё увидит, просто ничего не сохранится.
    debugPrint('Не удалось открыть базу данных: $error');
    debugPrint('$stack');
    shifts = FakeShiftRepository();
    auth = FakeAuthRepository();
  }

  // Кто входил в прошлый раз — если кто-то входил, сразу пускаем внутрь.
  session.setUser(await auth.restoreSession());

  runApp(FastworkApp(session: session, shifts: shifts, auth: auth));
}

class FastworkApp extends StatelessWidget {
  final AppSession session;
  final ShiftRepository shifts;
  final AuthRepository auth;

  const FastworkApp({
    super.key,
    required this.session,
    required this.shifts,
    required this.auth,
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
      home: _AuthGate(session: session, shifts: shifts, auth: auth),
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
  final ShiftRepository shifts;
  final AuthRepository auth;

  const _AuthGate({
    required this.session,
    required this.shifts,
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: session,
      builder: (context, _) => session.isSignedIn
          ? HomeShell(session: session, shifts: shifts, auth: auth)
          : RegisterPage(session: session, auth: auth),
    );
  }
}
