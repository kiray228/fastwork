import 'dart:convert';

import 'package:http/http.dart' as http;

/// Разговор с сервером.
///
/// Один класс на всё приложение: он знает адрес сервера, помнит токен и
/// умеет превращать ответ в объекты. Репозиториям остаётся только назвать
/// адрес и разобрать результат.
class ApiClient {
  /// Адрес сервера. Задаётся при сборке:
  ///
  ///   flutter run -d chrome --dart-define=API_URL=http://localhost:8080
  ///
  /// Это и есть та самая «одна строчка», которой локальный сервер
  /// отличается от облачного. Сам код не меняется.
  final String baseUrl;

  /// Токен текущего пользователя. null — никто не вошёл.
  String? token;

  ApiClient({required this.baseUrl});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json; charset=utf-8',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$baseUrl$path').replace(queryParameters: query);

  /// Разбор ответа.
  ///
  /// Коды состояния — это язык HTTP: 200 «всё хорошо», 401 «кто ты такой»,
  /// 404 «не нашёл», 500 «сервер сломался». Всё, что не 2xx, превращаем
  /// в исключение — его поймает `load()` и покажет экран ошибки.
  dynamic _decode(http.Response response) {
    // Разбирать ответ надо осторожно. Обычно сервер присылает JSON, но
    // при сбое между нами и сервером (хостинг перезапускается, шлюз
    // отдал свою страницу ошибки) приходит HTML. Раньше на нём падал сам
    // разбор, и вместо «сервер ответил 502» человек видел невнятное
    // сообщение про формат.
    dynamic body;
    try {
      body = response.body.isEmpty
          ? null
          : jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      body = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) return body;

    final message = body is Map && body['error'] != null
        ? body['error'] as String
        : 'Сервер ответил ${response.statusCode}';
    throw ApiException(message, response.statusCode);
  }

  Future<dynamic> get(String path, [Map<String, String>? query]) async =>
      _decode(await http.get(_uri(path, query), headers: _headers));

  Future<dynamic> post(String path, [Object? body]) async => _decode(
        await http.post(
          _uri(path),
          headers: _headers,
          body: body == null ? null : jsonEncode(body),
        ),
      );
}

/// Сервер ответил ошибкой.
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
