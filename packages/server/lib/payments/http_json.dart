import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fastwork_core/payment.dart';
import 'package:http/http.dart' as http;

/// Общее для всех провайдеров: запросы с JSON, ошибки, подписи.

/// Провайдер ответил ошибкой. Текст — для журнала сервера, человеку
/// показываем своё: «платёжный сервис не ответил».
class ProviderException implements Exception {
  final String provider;
  final int status;
  final String body;

  ProviderException(this.provider, this.status, this.body);

  @override
  String toString() => '$provider ответил $status: $body';
}

/// Отправить JSON и получить JSON.
///
/// Таймаут обязателен: зависший провайдер не должен вешать запрос
/// заказчика навсегда. Двадцать секунд — с запасом на медленный банк.
Future<Map<String, dynamic>> sendJson(
  http.Client client, {
  required String provider,
  required String method,
  required Uri url,
  required Map<String, String> headers,
  Map<String, dynamic>? body,
}) async {
  final request = http.Request(method, url)
    ..headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...headers,
    });
  if (body != null) request.body = jsonEncode(body);

  final response = await http.Response.fromStream(
    await client.send(request).timeout(const Duration(seconds: 20)),
  );
  if (response.statusCode >= 400) {
    // 4xx с понятным текстом — отказ, который можно показать человеку.
    if (response.statusCode < 500) {
      final message = _messageOf(response.body);
      if (message != null) throw PaymentDeclined(message);
    }
    throw ProviderException(provider, response.statusCode, response.body);
  }
  if (response.body.trim().isEmpty) return const {};
  final decoded = jsonDecode(utf8.decode(response.bodyBytes));
  return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
}

String? _messageOf(String body) {
  try {
    final json = jsonDecode(body);
    if (json is! Map) return null;
    for (final key in ['message', 'detail', 'error', 'error_message']) {
      final value = json[key];
      if (value is String && value.isNotEmpty) return value;
      if (value is Map && value['message'] is String) {
        return value['message'] as String;
      }
    }
  } catch (_) {}
  return null;
}

/// Первое строковое значение по одному из ключей — где угодно в ответе.
///
/// Провайдеры кладут одно и то же то на верхний уровень, то внутрь
/// `order` или `data`. Искать по дереву надёжнее, чем угадывать путь:
/// если провайдер завтра обернёт ответ ещё раз, код не сломается.
String? findString(Object? json, List<String> keys) {
  if (json is Map) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.isNotEmpty) return value;
      if (value is num) return value.toString();
    }
    for (final value in json.values) {
      final found = findString(value, keys);
      if (found != null) return found;
    }
  } else if (json is List) {
    for (final item in json) {
      final found = findString(item, keys);
      if (found != null) return found;
    }
  }
  return null;
}

/// Проверить подпись вебхука: HMAC-SHA256 от тела запроса.
///
/// Провайдеры присылают её по-разному: шестнадцатеричной строкой, в
/// base64, с приставкой «sha256=». Принимаем любой из этих видов — но
/// сравниваем за постоянное время, чтобы подпись нельзя было подобрать
/// по тому, как быстро сервер отвечает «не то».
bool verifyHmac({
  required String secret,
  required List<int> body,
  required String? signature,
}) {
  if (secret.isEmpty || signature == null || signature.isEmpty) return false;
  final digest = Hmac(sha256, utf8.encode(secret)).convert(body);
  var given = signature.trim();
  if (given.startsWith('sha256=')) given = given.substring(7);

  final candidates = [
    digest.toString(),
    base64.encode(digest.bytes),
  ];
  return candidates.any((c) => _constantTimeEquals(c, given)) ||
      candidates.any((c) => _constantTimeEquals(c, given.toLowerCase()));
}

bool _constantTimeEquals(String a, String b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return diff == 0;
}
