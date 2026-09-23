import 'dart:io';

import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/current_user.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_server/api.dart';
import 'package:fastwork_server/code_sender.dart';
import 'package:fastwork_server/open_database.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

/// Точка входа сервера.
///
/// Запустить у себя:      dart run bin/server.dart
/// Проверить, что живой:  http://localhost:8080/api/health
///
/// Обрати внимание: ни порт, ни путь к базе здесь не записаны намертво.
/// Их берут из **переменных окружения** — настроек, которые задаёт тот,
/// кто запускает программу. Ровно этого ждёт любой хостинг: он сам решает,
/// на каком порту тебя слушать, и сообщает это через `PORT`.
///
/// Благодаря этому один и тот же код работает и на ноутбуке, и в облаке
/// без единой правки.
Future<void> main(List<String> args) async {
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  // Файл SQLite или PostgreSQL — решает переменная DATABASE_URL.
  // Никакого Flutter: поэтому мы и отделяли раньше описание таблиц
  // от того, где они лежат.
  final db = AppDatabase(openServerDatabase());

  // Настоящая отправка писем, если настроены SMTP_*, иначе код печатается
  // в это же окно. Приложение разницы не замечает.
  final sender = resolveCodeSender();

  // Первый запуск: кладём демонстрационные смены, иначе лента пустая.
  await DbShiftRepository(db, const StaticUser(null)).seedIfEmpty();

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_cors)
      .addHandler(Api(
        db,
        sender,
        adminKey: Platform.environment['ADMIN_KEY'] ?? '',
      ).router.call);

  // InternetAddress.anyIPv4 — «слушать все сетевые интерфейсы».
  // На localhost хватило бы и loopback, но в облаке запрос приходит
  // снаружи контейнера, и слушать только себя означало бы не отвечать никому.
  final server = await io.serve(handler, InternetAddress.anyIPv4, port);

  stdout.writeln('fastwork сервер слушает http://localhost:${server.port}');
  stdout.writeln('база: ${describeDatabase()}');
  stdout.writeln(switch (sender) {
    ConsoleCodeSender() =>
      'письма НЕ отправляются — код входа будет напечатан здесь',
    BrevoCodeSender() => 'письма отправляются через Brevo (веб-интерфейс)',
    _ => 'письма отправляются через SMTP',
  });
}

/// Браузер не даёт странице обращаться к другому адресу, пока сервер
/// явно не разрешит. Это защита: иначе любой сайт мог бы дёргать чужие
/// сервера от твоего имени.
///
/// Наше приложение открыто на одном адресе (localhost:8000), а сервер —
/// на другом (localhost:8080). Для браузера это «чужой» адрес, поэтому
/// разрешение нужно.
///
/// `*` значит «пускаю всех». Для боевого сервера так нельзя — там
/// указывают конкретный адрес приложения.
Middleware get _cors => (innerHandler) {
      return (request) async {
        // Перед «настоящим» запросом браузер шлёт пробный OPTIONS:
        // спрашивает разрешение. Отвечаем на него сразу.
        if (request.method == 'OPTIONS') {
          return Response.ok('', headers: _corsHeaders);
        }
        final response = await innerHandler(request);
        return response.change(headers: _corsHeaders);
      };
    };

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Admin-Key',
};
