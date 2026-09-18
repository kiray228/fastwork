import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart' as pg;

/// Где сервер хранит данные.
///
/// Два варианта, и выбирает их не код, а тот, кто запускает:
///
///   есть DATABASE_URL  →  PostgreSQL  (отдельная служба, данные живут)
///   нет DATABASE_URL   →  файл SQLite (проще, но на хостинге пропадает)
///
/// Это и есть причина переезда. На бесплатном хостинге диск временный:
/// при перезапуске файл с базой исчезает вместе с аккаунтами и сменами.
/// PostgreSQL — отдельная служба со своим диском, её перезапуск сервера
/// не касается.
///
/// Обрати внимание, чего здесь **не** происходит: ни одна таблица, ни один
/// запрос не переписаны. Описание базы лежит в `fastwork_core` и про
/// PostgreSQL ничего не знает — меняется только способ её открыть.
QueryExecutor openServerDatabase() {
  final url = Platform.environment['DATABASE_URL'];

  if (url == null || url.isEmpty) {
    final path = Platform.environment['DB_PATH'] ?? 'fastwork.sqlite';
    return NativeDatabase(File(path));
  }

  return PgDatabase(endpoint: _endpointFrom(url), settings: _settings(url));
}

/// Разбираем строку подключения вида
/// `postgres://пользователь:пароль@адрес:5432/имя_базы`.
///
/// Такой формат отдают все хостинги — поэтому его и понимаем, а не
/// заводим пять отдельных переменных.
pg.Endpoint _endpointFrom(String url) {
  final uri = Uri.parse(url);
  final userInfo = uri.userInfo.split(':');

  return pg.Endpoint(
    host: uri.host,
    port: uri.hasPort ? uri.port : 5432,
    database: uri.path.replaceFirst('/', ''),
    username: userInfo.isNotEmpty ? Uri.decodeComponent(userInfo[0]) : null,
    password:
        userInfo.length > 1 ? Uri.decodeComponent(userInfo[1]) : null,
  );
}

/// Шифровать ли соединение.
///
/// В интернете — обязательно: иначе пароль и все данные идут открытым
/// текстом. На своём компьютере шифровать нечего и незачем, да и
/// сертификата у локального PostgreSQL обычно нет.
pg.ConnectionSettings _settings(String url) {
  final host = Uri.parse(url).host;
  final isLocal = host == 'localhost' || host == '127.0.0.1';

  return pg.ConnectionSettings(
    sslMode: isLocal ? pg.SslMode.disable : pg.SslMode.require,
  );
}

/// Как называется выбранное хранилище — для сообщения при запуске.
String describeDatabase() =>
    (Platform.environment['DATABASE_URL'] ?? '').isEmpty
        ? 'файл SQLite'
        : 'PostgreSQL';
