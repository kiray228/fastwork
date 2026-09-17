import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// Где лежит база **в приложении**.
///
/// На телефоне это файл в папке приложения, в браузере — хранилище
/// самого браузера. Для браузера нужно указать, где лежат два служебных
/// файла (они в папке `web/`).
///
/// Этот файл — единственное место, которое знает про Flutter. Сервер его
/// не импортирует и поэтому запускается обычным `dart run`.
QueryExecutor openAppDatabase() => driftDatabase(
      name: 'fastwork',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
