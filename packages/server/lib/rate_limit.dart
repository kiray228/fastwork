import 'package:shelf/shelf.dart';

/// Сколько запросов с одного адреса пускать за окно времени.
///
/// Предел «пять кодов в час на одну почту» защищает почту, но не сервер:
/// скрипт с одного адреса может просить коды для тысячи разных почт и
/// исчерпать дневную квоту рассылки, а проверку кода — перебирать по
/// тысяче почт сразу. Этот предел стоит перед входом целиком и считает
/// запросы с одного адреса, какой бы почтой они ни подписывались.
///
/// Счётчики в памяти: сервер один, и после перезапуска начать счёт
/// заново не страшно. Когда серверов станет несколько, счётчик переедет
/// в общую базу или Redis.
class RateLimiter {
  final int limit;
  final Duration window;
  final DateTime Function() clock;

  final _hits = <String, List<DateTime>>{};

  RateLimiter({
    required this.limit,
    required this.window,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  /// Записать попытку. false — предел исчерпан, отказать.
  bool allow(String key) {
    final now = clock();
    final since = now.subtract(window);
    final hits = (_hits[key] ?? [])..removeWhere((t) => !t.isAfter(since));
    if (hits.length >= limit) {
      _hits[key] = hits;
      return false;
    }
    hits.add(now);
    _hits[key] = hits;
    // Изредка чистим тех, кто давно не заходил, — иначе карта росла бы
    // бесконечно на каждом новом адресе.
    if (_hits.length > 10000) {
      _hits.removeWhere((_, list) => list.every((t) => !t.isAfter(since)));
    }
    return true;
  }
}

/// С какого адреса пришёл запрос.
///
/// За хостингом (Render) сервер видит адрес прокси, а настоящий — в
/// заголовке X-Forwarded-For. Берём **последний** адрес из него: его
/// дописал наш прокси. Первые клиент может прислать какие угодно, и по
/// ним предел обходился бы подставным заголовком.
String clientAddress(Request request) {
  final forwarded = request.headers['x-forwarded-for'];
  if (forwarded != null && forwarded.trim().isNotEmpty) {
    return forwarded.split(',').last.trim();
  }
  final info = request.context['shelf.io.connection_info'];
  try {
    return (info as dynamic).remoteAddress.address as String;
  } catch (_) {
    return 'unknown';
  }
}
