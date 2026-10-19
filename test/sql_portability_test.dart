import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Свои SQL-запросы — только через `AppDatabase.query`.
///
/// Он переводит подстановки `?` в `$1, $2` для PostgreSQL. Запрос, написанный
/// мимо него через `customSelect`, работает в тестах (там SQLite) и молча
/// ломается на сервере. Так однажды и вышло: письма о сменах на сервере не
/// уходили ни одного — запрос падал раз в минуту, а тесты были зелёными.
void main() {
  test('customSelect вызывается только внутри AppDatabase', () {
    final offenders = <String>[];
    for (final root in ['packages/core/lib', 'packages/server/lib', 'lib']) {
      for (final entity in Directory(root).listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final path = entity.path.replaceAll(r'\', '/');
        if (path.endsWith('.g.dart') ||
            path.endsWith('packages/core/lib/data/database.dart')) {
          continue;
        }
        if (entity.readAsStringSync().contains('customSelect(')) {
          offenders.add(path);
        }
      }
    }
    expect(offenders, isEmpty,
        reason: 'используйте db.query(...) — он переводит ? для PostgreSQL');
  });
}
