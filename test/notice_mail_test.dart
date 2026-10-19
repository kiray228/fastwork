import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/notice_mail.dart';
import 'package:fastwork_core/notification.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 10, 20, 12);

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<int> user(String phone, {String? email, bool notices = true}) =>
      db.into(db.userRows).insert(UserRowsCompanion.insert(
            phone: phone,
            email: Value(email),
            fullName: 'Тест $phone',
            city: 'Алматы',
            createdAt: now,
            emailNotices: Value(notices),
          ));

  Future<int> notice(int userId, NotificationKind kind,
          {Duration ago = const Duration(minutes: 1)}) =>
      db.into(db.notificationRows).insert(NotificationRowsCompanion.insert(
            userId: userId,
            kind: kind.name,
            title: 'Заголовок ${kind.name}',
            body: 'Текст',
            shiftId: const Value(7),
            createdAt: now.subtract(ago),
          ));

  test('важные — письмом, не больше трёх в день; отмена — всегда', () async {
    final a = await user('1', email: 'a@x.kz');
    for (var i = 0; i < 4; i++) {
      await notice(a, NotificationKind.invited);
    }
    await notice(a, NotificationKind.shiftCancelled);
    await notice(a, NotificationKind.applied); // не из важных
    await notice(a, NotificationKind.invited,
        ago: const Duration(hours: 7)); // устарело

    final mails = await takeNoticeEmails(db, now: now);
    expect(mails.map((m) => m.title), [
      'Заголовок invited',
      'Заголовок invited',
      'Заголовок invited',
      'Заголовок shiftCancelled',
    ]);
    expect(mails.first.email, 'a@x.kz');
    expect(mails.first.shiftId, 7);

    // Второй запуск ничего не повторяет.
    expect(await takeNoticeEmails(db, now: now), isEmpty);

    // На следующий день предел начинается заново — но вчерашнее уже
    // решено и не досылается.
    await notice(a, NotificationKind.slotFreed);
    final tomorrow = now.add(const Duration(days: 1));
    await (db.update(db.notificationRows)
          ..where((n) => n.emailState.isNull() & n.kind.equals('slotFreed')))
        .write(NotificationRowsCompanion(createdAt: Value(tomorrow)));
    expect(await takeNoticeEmails(db, now: tomorrow), hasLength(1));
  });

  test('без почты, с отпиской или удалённым — не пишем', () async {
    final noEmail = await user('2');
    final optedOut = await user('3', email: 'c@x.kz', notices: false);
    final deleted = await user('deleted-4', email: 'd@x.kz');
    for (final u in [noEmail, optedOut, deleted]) {
      await notice(u, NotificationKind.shiftCancelled);
    }
    expect(await takeNoticeEmails(db, now: now), isEmpty);
    final states = await db.select(db.notificationRows).get();
    expect(states.map((n) => n.emailState).toSet(), {'skipped'});
  });
}
