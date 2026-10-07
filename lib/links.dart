import 'package:fastwork_core/shift.dart';

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
  twoGis('2ГИС'),
  yandex('Яндекс Карты'),
  google('Google Карты');

  final String label;

  const MapsApp(this.label);
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
    '${formatMoney(shift.totalPay)} за смену',
    if (shift.dressCode != null) 'Форма: ${shift.dressCode}',
    'Отменить запись можно до ${formatDateTime(shift.cancelDeadline)}.',
    'Не забудьте отметиться в fastwork, когда придёте.',
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
