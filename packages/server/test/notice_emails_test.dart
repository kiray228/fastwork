import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/notification.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_server/api.dart';
import 'package:fastwork_server/auth_service.dart';
import 'package:fastwork_server/code_sender.dart';
import 'package:fastwork_server/notice_emails.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

/// Почта, которая складывает письма в список.
class _Inbox implements NoticeMailer {
  final mails = <(String, String, String)>[];

  @override
  Future<void> sendNotice(String email, String subject, String text) async =>
      mails.add((email, subject, text));
}

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('письмо — на языке получателя, со ссылкой на смену и отпиской',
      () async {
    final user = await DbAuthRepository(db).register(
      phone: '77000000001',
      email: 'worker@example.kz',
      fullName: 'Азамат Серик',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    await (db.update(db.userRows)..where((u) => u.id.equals(user.id)))
        .write(const UserRowsCompanion(language: Value('kk')));
    await db.into(db.notificationRows).insert(NotificationRowsCompanion.insert(
          userId: user.id,
          kind: NotificationKind.invited.name,
          title: 'Сізді ауысымға шақырды',
          body: 'Magnum, ертең 10:00',
          shiftId: const Value(42),
          createdAt: DateTime.now(),
        ));

    final inbox = _Inbox();
    final sent = await sendNoticeEmails(db, inbox,
        appUrl: 'https://kiray228.github.io/fastwork/');
    expect(sent, 1);
    final (to, subject, text) = inbox.mails.single;
    expect(to, 'worker@example.kz');
    expect(subject, 'Сізді ауысымға шақырды');
    expect(text, contains('Magnum, ертең 10:00'));
    expect(text, contains('https://kiray228.github.io/fastwork/?shift=42'));
    expect(text, contains('Профиль'));
    expect(text, contains('өшіруге')); // подсказка — по-казахски

    // Второй запуск — ничего нового.
    expect(await sendNoticeEmails(db, inbox, appUrl: 'https://x.kz/'), 0);
  });

  test('письма отключаются в профиле', () async {
    final user = await DbAuthRepository(db).register(
      phone: '77000000002',
      email: 'w2@example.kz',
      fullName: 'Айгерим Нур',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    final token = await AuthService(db, ConsoleCodeSender())
        .issue(email: 'w2@example.kz', userId: user.id);
    final api = Api(db, ConsoleCodeSender());
    final response = await api.router.call(Request(
      'POST',
      Uri.parse('http://localhost/api/me/email-notices'),
      body: jsonEncode({'on': false}),
      headers: {'authorization': 'Bearer $token'},
    ));
    expect(response.statusCode, 200);
    final json = jsonDecode(await response.readAsString());
    expect(json['emailNotices'], isFalse);
    expect((await DbAuthRepository(db).refresh(user.id))!.emailNotices,
        isFalse);
  });
}
