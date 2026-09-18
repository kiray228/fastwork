import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';

/// Кто доставляет код до человека.
///
/// Третий раз в проекте один и тот же приём: описываем **умение**, а не
/// исполнителя. Сначала так поступили с хранилищем смен, потом с тем,
/// «кто сейчас действует», теперь — с отправкой писем.
///
/// Благодаря этому почтовый сервис можно не подключать, пока пишешь код:
/// на его месте работает заглушка, которая печатает код в окно сервера.
abstract class CodeSender {
  Future<void> send(String email, String code);

  /// Как назвать способ доставки в ответе — чтобы приложение могло
  /// подсказать человеку, где искать код.
  String get name;
}

/// Печатает код в окно сервера вместо отправки письма.
///
/// Так разрабатывают всегда: подключать настоящую почту ради каждой
/// проверки долго, а иногда и платно. Заглушка ведёт себя точно так же
/// с точки зрения остального кода.
class ConsoleCodeSender implements CodeSender {
  @override
  String get name => 'console';

  @override
  Future<void> send(String email, String code) async {
    stdout.writeln('');
    stdout.writeln('  ┌────────────────────────────────────────┐');
    stdout.writeln('  │  КОД ДЛЯ ВХОДА                         │');
    stdout.writeln('  │                                        │');
    stdout.writeln('  │      $code                            │');
    stdout.writeln('  │                                        │');
    stdout.writeln('  │  для $email');
    stdout.writeln('  └────────────────────────────────────────┘');
    stdout.writeln('');
  }
}

/// Отправка письма через HTTP-интерфейс Brevo.
///
/// Зачем это, если SMTP уже написан: **хостинги блокируют почтовые
/// порты**. Render, как и почти все остальные, не выпускает наружу
/// соединения на 25, 465 и 587 — иначе с бесплатных серверов рассылали
/// бы спам вагонами.
///
/// Выглядит это неприятно: запрос не отвергается, а просто висит, пока
/// не истечёт время ожидания. В логах — `Connection timed out`.
///
/// Обходной путь стандартный: те же сервисы умеют принимать письма
/// обычным веб-запросом на порт 443, а его не блокирует никто.
///
/// Для нас это снова та же история с интерфейсом: способ доставки
/// поменялся целиком, а всё остальное приложение об этом не узнало.
class BrevoCodeSender implements CodeSender {
  final String apiKey;
  final String from;
  final String fromName;

  BrevoCodeSender({
    required this.apiKey,
    required this.from,
    this.fromName = 'fastwork',
  });

  /// Собрать из переменных окружения. null — ключ не задан.
  static BrevoCodeSender? fromEnvironment() {
    final env = Platform.environment;
    final key = env['BREVO_API_KEY'];
    // Адрес отправителя обязателен: Brevo принимает письма только от
    // адресов, подтверждённых в личном кабинете.
    final from = env['SMTP_FROM'];

    if (key == null || key.isEmpty || from == null || from.isEmpty) {
      return null;
    }
    return BrevoCodeSender(apiKey: key, from: from);
  }

  @override
  String get name => 'email';

  @override
  Future<void> send(String email, String code) async {
    final response = await http
        .post(
          Uri.parse('https://api.brevo.com/v3/smtp/email'),
          headers: {
            'api-key': apiKey,
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: jsonEncode({
            'sender': {'email': from, 'name': fromName},
            'to': [
              {'email': email},
            ],
            'subject': 'Код для входа: $code',
            'textContent': 'Ваш код для входа в fastwork: $code\n\n'
                'Код действует 5 минут.\n'
                'Если вы не пытались войти — просто не отвечайте на это письмо.',
          }),
        )
        // Без ограничения времени запрос может висеть очень долго, и
        // человек всё это время смотрит на крутящуюся кнопку.
        .timeout(const Duration(seconds: 15));

    if (response.statusCode >= 300) {
      throw CodeSendFailure(
        'Brevo ответил ${response.statusCode}: ${response.body}',
      );
    }
  }
}

/// Письмо не ушло.
class CodeSendFailure implements Exception {
  final String message;

  CodeSendFailure(this.message);

  @override
  String toString() => message;
}

/// Отправляет письмо по-настоящему.
///
/// Настраивается переменными окружения — как порт и база. В коде нет ни
/// адреса, ни пароля: их нельзя класть в репозиторий, иначе они утекут
/// вместе с ним.
///
///   SMTP_HOST=smtp-relay.brevo.com
///   SMTP_PORT=587
///   SMTP_USER=логин, который выдал сервис
///   SMTP_PASSWORD=пароль, который выдал сервис
///   SMTP_FROM=адрес, подтверждённый в сервисе (его увидит получатель)
///
/// Для Gmail SMTP_FROM можно не задавать: там логин и есть адрес.
/// Но Gmail для рассылок годится плохо — письма незнакомым людям часто
/// попадают в спам, и есть суточный предел.
///
/// Для Gmail нужен именно **пароль приложения** (создаётся в настройках
/// аккаунта при включённой двухфакторной защите), а не обычный пароль.
class SmtpCodeSender implements CodeSender {
  final String host;
  final int port;
  final String username;
  final String password;

  /// Адрес, который получатель увидит в поле «от кого».
  ///
  /// Это **не то же самое**, что логин. У Gmail они совпадают, а у
  /// сервисов рассылок логин — служебная строка вроде
  /// `8a1b2c001@smtp-brevo.com`, и письмо с таким отправителем либо не
  /// уйдёт, либо попадёт в спам. Поэтому адрес задаётся отдельно.
  final String from;

  SmtpCodeSender({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.from,
  });

  /// Собрать из переменных окружения. null — настройки не заданы,
  /// значит работаем с заглушкой.
  static SmtpCodeSender? fromEnvironment() {
    final env = Platform.environment;
    final host = env['SMTP_HOST'];
    final user = env['SMTP_USER'];
    final password = env['SMTP_PASSWORD'];

    if (host == null || user == null || password == null) return null;

    return SmtpCodeSender(
      host: host,
      port: int.tryParse(env['SMTP_PORT'] ?? '') ?? 587,
      username: user,
      password: password,
      // Если SMTP_FROM не задан, считаем, что логин и есть адрес —
      // так устроен Gmail.
      from: env['SMTP_FROM'] ?? user,
    );
  }

  @override
  String get name => 'email';

  @override
  Future<void> send(String email, String code) async {
    final server = SmtpServer(
      host,
      port: port,
      username: username,
      password: password,
      // Порт 587 — это «начать открыто и перейти на шифрование».
      // Порт 465 — «шифровать с самого начала».
      ssl: port == 465,
    );

    final message = Message()
      ..from = Address(from, 'fastwork')
      ..recipients.add(email)
      ..subject = 'Код для входа: $code'
      ..text = 'Ваш код для входа в fastwork: $code\n\n'
          'Код действует 5 минут.\n'
          'Если вы не пытались войти — просто не отвечайте на это письмо.';

    // Ограничение времени: без него запрос к заблокированному порту
    // висит минуту, и всё это время человек смотрит на крутящуюся кнопку.
    await send_(message, server).timeout(const Duration(seconds: 20));
  }
}

/// Отдельная функция, чтобы имя `send` не столкнулось с методом класса.
Future<void> send_(Message message, SmtpServer server) =>
    mailer.send(message, server);

/// Кто будет отправлять коды.
///
/// По порядку: веб-интерфейс Brevo, если задан ключ; иначе SMTP, если
/// заданы его настройки; иначе заглушка, печатающая код в окно сервера.
///
/// Brevo стоит первым не случайно: на хостинге SMTP обычно заблокирован,
/// и рабочим остаётся только веб-интерфейс.
CodeSender resolveCodeSender() =>
    BrevoCodeSender.fromEnvironment() ??
    SmtpCodeSender.fromEnvironment() ??
    ConsoleCodeSender();
