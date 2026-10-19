import 'package:drift/drift.dart';

import '../notification.dart';
import 'database.dart';

/// Письма о важных уведомлениях.
///
/// Уведомление живёт в колокольчике приложения — и человек узнаёт о нём,
/// только когда приложение откроет. Приглашение на смену завтра, отмена
/// смены через три часа, «освободилось место» — всё это теряет смысл,
/// если прочитано вечером. Поэтому важные уведомления сервер дублирует
/// письмом на почту, с которой человек входит.
///
/// Здесь — решение, *какие* письма отправить: само письмо отправляет
/// сервер. Так правило проверяется обычным тестом на базе в памяти.

/// Какие уведомления дублировать письмом.
const kEmailedKinds = {
  NotificationKind.invited,
  NotificationKind.newShift,
  NotificationKind.slotFreed,
  NotificationKind.shiftCancelled,
  NotificationKind.shiftChanged,
  NotificationKind.reminder,
  NotificationKind.confirmed,
  NotificationKind.message,
};

/// Эти — всегда, без дневного предела: они про смену, на которую человек
/// уже записан, и пропустить их дороже, чем получить лишнее письмо.
const kAlwaysEmailed = {
  NotificationKind.shiftCancelled,
  NotificationKind.shiftChanged,
  NotificationKind.reminder,
};

/// Сколько остальных писем в день. Больше — уже рассылка, от которой
/// отписываются целиком.
const kNoticeEmailsPerDay = 3;

/// Уведомление старше этого письмом не дублируем: сервер мог спать, и
/// после пробуждения человек получил бы пачку устаревших писем.
const kNoticeEmailWindow = Duration(hours: 6);

/// Письмо, которое пора отправить.
class NoticeEmail {
  final int notificationId;
  final String email;
  final String? language;
  final String title;
  final String body;
  final int? shiftId;

  const NoticeEmail({
    required this.notificationId,
    required this.email,
    required this.language,
    required this.title,
    required this.body,
    required this.shiftId,
  });
}

/// Забрать письма, которые пора отправить, — не больше [limit].
///
/// Каждое уведомление решается один раз: состояние ставится условным
/// обновлением «если ещё не решали», поэтому два запуска подряд (или два
/// экземпляра сервера) одно письмо дважды не отправят. Что не прошло —
/// по пределу, без почты или с отпиской — помечается `skipped`.
Future<List<NoticeEmail>> takeNoticeEmails(
  AppDatabase db, {
  required DateTime now,
  int limit = 50,
}) async {
  final kinds = [for (final k in kEmailedKinds) k.name];
  final rows = await db.customSelect(
    'SELECT n.id, n.user_id, n.kind, n.title, n.body, n.shift_id, '
    'u.email, u.language, u.email_notices, u.phone '
    'FROM notification_rows n JOIN user_rows u ON u.id = n.user_id '
    'WHERE n.email_state IS NULL AND n.created_at >= ? '
    'AND n.kind IN (${List.filled(kinds.length, '?').join(', ')}) '
    'ORDER BY n.id LIMIT ?',
    variables: [
      Variable.withDateTime(now.subtract(kNoticeEmailWindow)),
      for (final k in kinds) Variable.withString(k),
      Variable.withInt(limit),
    ],
    readsFrom: {db.notificationRows, db.userRows},
  ).get();

  final today = DateTime(now.year, now.month, now.day);
  final sentToday = <int, int>{};
  final result = <NoticeEmail>[];
  for (final r in rows) {
    final id = r.read<int>('id');
    final userId = r.read<int>('user_id');
    final email = r.readNullable<String>('email');
    final kind = NotificationKind.values.byName(r.read<String>('kind'));

    var send = email != null &&
        email.isNotEmpty &&
        r.read<bool>('email_notices') &&
        !r.read<String>('phone').startsWith('deleted-');
    if (send && !kAlwaysEmailed.contains(kind)) {
      final count = sentToday[userId] ??= await _sentSince(db, userId, today);
      if (count >= kNoticeEmailsPerDay) send = false;
    }

    final claimed = await (db.update(db.notificationRows)
          ..where((n) => n.id.equals(id) & n.emailState.isNull()))
        .write(NotificationRowsCompanion(
      emailState: Value(send ? 'sent' : 'skipped'),
    ));
    if (claimed == 0 || !send) continue;
    if (!kAlwaysEmailed.contains(kind)) {
      sentToday[userId] = sentToday[userId]! + 1;
    }
    result.add(NoticeEmail(
      notificationId: id,
      email: email!,
      language: r.readNullable<String>('language'),
      title: r.read<String>('title'),
      body: r.read<String>('body'),
      shiftId: r.readNullable<int>('shift_id'),
    ));
  }
  return result;
}

/// Сколько писем с пределом человек уже получил с [since].
Future<int> _sentSince(AppDatabase db, int userId, DateTime since) async {
  final always = [for (final k in kAlwaysEmailed) k.name];
  final row = await db.customSelect(
    'SELECT COUNT(*) AS c FROM notification_rows '
    "WHERE user_id = ? AND email_state = 'sent' AND created_at >= ? "
    'AND kind NOT IN (${List.filled(always.length, '?').join(', ')})',
    variables: [
      Variable.withInt(userId),
      Variable.withDateTime(since),
      for (final k in always) Variable.withString(k),
    ],
    readsFrom: {db.notificationRows},
  ).getSingle();
  return row.read<int>('c');
}
