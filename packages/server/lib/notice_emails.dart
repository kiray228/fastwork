import 'dart:io';

import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/notice_mail.dart';
import 'package:fastwork_core/lang.dart';

import 'code_sender.dart';
import 'server_strings.dart';

/// Разослать письма о свежих важных уведомлениях. Возвращает, сколько
/// писем ушло.
///
/// Что слать, решает ядро (`takeNoticeEmails`): какие уведомления, кому,
/// сколько в день. Здесь — только само письмо: заголовок уведомления в
/// теме, его текст, ссылка на смену и как отключить письма — на языке
/// получателя.
///
/// Письмо не ушло — не страшно: уведомление осталось в приложении.
/// Повторно не шлём, иначе сбой почтового сервиса обернулся бы пачкой
/// одинаковых писем.
Future<int> sendNoticeEmails(
  AppDatabase db,
  NoticeMailer mailer, {
  required String appUrl,
  DateTime? now,
}) async {
  final emails = await takeNoticeEmails(db, now: now ?? DateTime.now());
  var sent = 0;
  for (final e in emails) {
    final text = withLang(Lang.fromCode(e.language), () {
      final link = e.shiftId == null
          ? appUrl
          : Uri.parse(appUrl).replace(
              queryParameters: {'shift': '${e.shiftId}'}).toString();
      return '${e.body}\n\n${serverTr.noticeOpen}: $link\n\n'
          '${serverTr.noticeFooter}';
    });
    try {
      await mailer.sendNotice(e.email, e.title, text);
      sent++;
    } catch (error) {
      stderr.writeln('письмо-уведомление не ушло: $error');
    }
  }
  return sent;
}
