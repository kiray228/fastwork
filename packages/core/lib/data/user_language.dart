import 'package:drift/drift.dart';

import '../l10n/core_strings.dart';
import '../lang.dart';
import 'database.dart';

/// На каком языке писать этому человеку.
///
/// Язык хранится у пользователя: сервер запоминает его из заголовка
/// каждого запроса. Уведомление или строка истории часто пишется, когда
/// самого человека в приложении нет, — и тогда язык берут отсюда. Не знаем
/// — пишем на языке [fallback], то есть того, кто сейчас действует.
Future<CoreStrings> stringsForUser(
  AppDatabase db,
  int userId,
  CoreStrings fallback,
) async {
  final row = await (db.select(db.userRows)..where((u) => u.id.equals(userId)))
      .getSingleOrNull();
  final code = row?.language;
  return code == null ? fallback : CoreStrings.of(Lang.fromCode(code));
}

/// Запомнить язык человека. Ничего не пишет, если язык тот же.
Future<void> rememberLanguage(AppDatabase db, int userId, Lang lang) =>
    (db.update(db.userRows)
          ..where((u) =>
              u.id.equals(userId) &
              (u.language.isNull() | u.language.equals(lang.code).not())))
        .write(UserRowsCompanion(language: Value(lang.code)));
