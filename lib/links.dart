import 'package:fastwork_core/shift.dart';

import 'l10n/strings.dart';

// Ссылки наружу: в карты и в календарь.
//
// Здесь только адреса — ни одной кнопки. Поэтому их можно проверить
// обычным тестом, без экрана: «для такой смены получится такая ссылка».
//
// Почему ссылки, а не встроенная карта. Карта в приложении — это
// отдельная библиотека, ключи, плата за запросы и мегабайты в сборке. А
// у человека на телефоне уже стоит 2ГИС или Яндекс Карты, где он и так
// строит маршруты, — достаточно открыть их с нужным адресом.

/// Адрес вместе с городом.
///
/// Заказчик пишет адрес как привык: «ул. Абая, 10» — без города, ведь
/// город и так понятен ему. Картам он не понятен: улица Абая есть в
/// каждом городе Казахстана. Если города в адресе нет — добавляем.
String fullAddress(Shift shift) {
  final address = shift.address.trim();
  if (address.toLowerCase().contains(shift.city.toLowerCase())) {
    return address;
  }
  return '${shift.city}, $address';
}

/// Куда можно открыть адрес.
enum MapsApp {
  // 2ГИС первым: в Казахстане им пользуются чаще остальных, и в нём
  // есть входы в здания и этажи — ровно то, что ищешь у склада.
  twoGis,
  yandex,
  google;

  /// Название карт на языке приложения.
  String get label => switch (this) {
        MapsApp.twoGis => tr.shift.map2Gis,
        MapsApp.yandex => tr.shift.mapYandex,
        MapsApp.google => tr.shift.mapGoogle,
      };
}

/// Ссылка на поиск адреса в картах.
///
/// Обычная https-ссылка, а не «схема приложения» вроде `dgis://`: если
/// приложение стоит, телефон откроет его сам, а если нет — откроется
/// сайт тех же карт. Со схемой без приложения не открылось бы ничего.
Uri mapsLink(Shift shift, MapsApp app) {
  final query = fullAddress(shift);
  return switch (app) {
    MapsApp.twoGis =>
      Uri.parse('https://2gis.kz/search/${Uri.encodeComponent(query)}'),
    MapsApp.yandex => Uri.https('yandex.kz', '/maps/', {'text': query}),
    MapsApp.google => Uri.https(
        'www.google.com', '/maps/search/', {'api': '1', 'query': query}),
  };
}

/// Ссылка «добавить в Google Календарь».
///
/// Календарь сам предложит напоминание — то, чего у нас нет: телефон
/// напомнит о смене накануне, даже если приложение не открывали неделю.
///
/// Время пишем «как на часах» и указываем пояс отдельно (`ctz`). Иначе
/// пришлось бы переводить в UTC, и смена в 10:00 у человека с телефоном
/// в другом поясе съехала бы на другой час.
Uri calendarLink(Shift shift) {
  String stamp(DateTime t) => '${t.year.toString().padLeft(4, '0')}'
      '${_two(t.month)}${_two(t.day)}T${_two(t.hour)}${_two(t.minute)}00';

  final details = [
    shift.company,
    tr.core.perShift(formatMoney(shift.totalPay)),
    if (shift.dressCode != null) tr.core.dressCodeLine(shift.dressCode!),
    tr.core.cancelUntil(formatDateTime(shift.cancelDeadline)),
    tr.core.rememberCheckIn,
  ].join('\n');

  return Uri.https('calendar.google.com', '/calendar/render', {
    'action': 'TEMPLATE',
    'text': '${shift.title} — fastwork',
    'dates': '${stamp(shift.startsAt)}/${stamp(shift.endsAt)}',
    'ctz': 'Asia/Almaty',
    'location': fullAddress(shift),
    'details': details,
  });
}

String _two(int n) => n.toString().padLeft(2, '0');

/// Где живёт приложение в браузере. Задаётся при сборке, как и адрес
/// сервера; по умолчанию — GitHub Pages проекта.
const appUrl = String.fromEnvironment(
  'APP_URL',
  defaultValue: 'https://kiray228.github.io/fastwork/',
);

/// Ссылками на смены можно делиться, только когда смены живут на сервере.
/// Без сервера у каждого телефона своя база и свои номера смен: ссылка
/// открыла бы у друга совсем другую смену или ничего.
const sharedLinksWork = bool.hasEnvironment('API_URL') &&
    String.fromEnvironment('API_URL') != '';

/// Ссылка на смену: открывает приложение сразу на ней.
///
/// Номер смены — в параметре адреса, а не в пути: сайт на GitHub Pages —
/// одна страница, и путь вроде `/fastwork/shift/12` ответил бы «404».
/// Параметр же страница получает целиком и сама решает, что открыть.
Uri shiftLink(int shiftId) =>
    Uri.parse(appUrl).replace(queryParameters: {'shift': '$shiftId'});

/// Номер смены из адреса, по которому открыли приложение. null — открыли
/// просто так, без ссылки на смену.
int? sharedShiftId(Uri address) =>
    int.tryParse(address.queryParameters['shift'] ?? '');
