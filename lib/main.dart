import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/register_page.dart';
import 'auth/terms_page.dart';
import 'data/api_auth_repository.dart';
import 'data/api_client.dart';
import 'data/api_shift_repository.dart';
import 'data/api_wallet_repository.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'data/database_flutter.dart';
import 'package:fastwork_core/data/fake_shift_repository.dart';
import 'data/repositories.dart';
import 'data/session.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/payment.dart';
import 'home_shell.dart';
import 'theme/app_theme.dart';

/// Адрес сервера. Пусто — работаем на своей базе, без сети.
///
/// Задаётся при запуске, а не в коде:
///
///   flutter run -d chrome --dart-define=API_URL=http://localhost:8080
///
/// Одна и та же сборка умеет и так, и так. Разница ровно в этой строке.
const apiUrl = String.fromEnvironment('API_URL');

Future<void> main() async {
  // Нужно, если до запуска приложения мы обращаемся к диску или к системе.
  WidgetsFlutterBinding.ensureInitialized();

  final session = AppSession();
  final repos = apiUrl.isEmpty
      ? await _localRepositories(session)
      : await _serverRepositories(apiUrl);

  // Кто входил в прошлый раз — если кто-то входил, сразу пускаем внутрь.
  session.setUser(await repos.auth.restoreSession());

  runApp(FastworkApp(session: session, repos: repos));
}

/// Всё хранится на самом устройстве.
///
/// Сессию берём ту же, что получит приложение. Раньше здесь заводилась
/// своя, отдельная, — и хранилище так и не узнавало, кто вошёл: город
/// у него был пустой, и лента без сервера всегда оставалась пустой.
Future<AppRepositories> _localRepositories(AppSession session) async {
  try {
    final database = AppDatabase(openAppDatabase());
    // Один шлюз на оба хранилища — как один провайдер у настоящего
    // сервиса. Без сервера он может быть только тестовым.
    final payments = SandboxPaymentGateway();
    final dbShifts = DbShiftRepository(database, session, payments: payments);
    await dbShifts.seedIfEmpty();
    return AppRepositories(
      shifts: dbShifts,
      auth: DbAuthRepository(database),
      documents: DbDocumentRepository(database, session),
      support: DbSupportRepository(database, session),
      wallet: DbWalletRepository(database, session, payments: payments),
    );
  } catch (error, stack) {
    // Если база не открылась (например, браузер запретил хранилище) —
    // приложение не должно падать белым экраном. Работаем на данных
    // в памяти: пользователь всё увидит, просто ничего не сохранится.
    debugPrint('Не удалось открыть базу данных: $error');
    debugPrint('$stack');
    final shifts = FakeShiftRepository();
    return AppRepositories(
      shifts: shifts,
      auth: FakeAuthRepository(),
      documents: FakeDocumentRepository(),
      support: FakeSupportRepository(),
      wallet: FakeWalletRepository(shifts),
    );
  }
}

/// Всё хранится на сервере.
///
/// Обрати внимание, что меняется: только состав этого объекта. Ни один
/// экран про сервер не знает и не изменился ни на строчку — они работают
/// с интерфейсами хранилищ, а не с конкретной базой. Ради этого и была
/// вся возня со слоями.
Future<AppRepositories> _serverRepositories(String url) async {
  final client = ApiClient(baseUrl: url);
  final prefs = await SharedPreferences.getInstance();

  return AppRepositories(
    shifts: ApiShiftRepository(client),
    auth: ApiAuthRepository(
      client,
      // Токен переживает перезапуск: иначе пришлось бы входить заново
      // при каждом открытии приложения.
      readToken: () async => prefs.getString('token'),
      writeToken: (value) async => value == null
          ? await prefs.remove('token')
          : await prefs.setString('token', value),
    ),
    documents: ApiDocumentRepository(client),
    support: ApiSupportRepository(client),
    wallet: ApiWalletRepository(client),
  );
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
      builder: (context, _) {
        final user = session.user;
        if (user == null) {
          return RegisterPage(session: session, auth: repos.auth);
        }
        // Вошёл, но действующие правила не принимал — сначала они.
        if (!user.hasAcceptedTerms) {
          return TermsGatePage(session: session, auth: repos.auth);
        }
        return HomeShell(session: session, repos: repos);
      },
    );
  }
}
