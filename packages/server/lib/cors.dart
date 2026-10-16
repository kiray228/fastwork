import 'package:shelf/shelf.dart';

/// Браузер не даёт странице обращаться к другому адресу, пока сервер
/// явно не разрешит. Это защита: иначе любой сайт мог бы дёргать чужие
/// сервера от твоего имени.
///
/// Сайт приложения открыт на одном адресе (github.io), а сервер — на
/// другом (onrender.com). Для браузера это «чужой» адрес, поэтому
/// разрешение нужно.
///
/// Кому разрешать — список `allowed` (переменная ALLOWED_ORIGINS, адреса
/// через запятую). Пустой список — всем, `*`: так удобно, пока сайт и
/// сервер живут на случайных адресах разработки. Когда адрес сайта
/// известен, его стоит вписать: тогда чужая страница не сможет от имени
/// вошедшего человека дёргать сервер из его браузера.
Middleware corsFor(List<String> allowed) => (innerHandler) {
      return (request) async {
        final headers = _headersFor(request.headers['origin'], allowed);
        // Перед «настоящим» запросом браузер шлёт пробный OPTIONS:
        // спрашивает разрешение. Отвечаем на него сразу.
        if (request.method == 'OPTIONS') {
          return Response.ok('', headers: headers);
        }
        final response = await innerHandler(request);
        return response.change(headers: headers);
      };
    };

/// Список адресов из переменной окружения: «a, b ,c» → [a, b, c].
List<String> parseOrigins(String? raw) => [
      for (final part in (raw ?? '').split(','))
        if (part.trim().isNotEmpty) part.trim().replaceAll(RegExp(r'/+$'), ''),
    ];

Map<String, String> _headersFor(String? origin, List<String> allowed) {
  final String? allow;
  if (allowed.isEmpty) {
    allow = '*';
  } else if (origin != null && allowed.contains(origin)) {
    // Отвечаем тем же адресом, что пришёл: заголовок принимает только один
    // адрес, не список.
    allow = origin;
  } else {
    allow = null; // чужому сайту — без разрешения, браузер ответ не отдаст
  }
  return {
    if (allow != null) 'Access-Control-Allow-Origin': allow,
    // Ответ зависит от того, кто спрашивает, — кэш не должен отдать
    // разрешение одного сайта другому.
    if (allowed.isNotEmpty) 'Vary': 'Origin',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    // X-Admin-Key здесь нет: служебный адрес зовут из терминала, а не из
    // браузера, и разрешать странице слать этот заголовок незачем.
    'Access-Control-Allow-Headers':
        'Content-Type, Authorization, Accept-Language',
  };
}
