import 'package:fastwork/links.dart';
import 'package:fastwork_core/shift.dart';
import 'package:flutter_test/flutter_test.dart';

/// Ссылки в карты и календарь — без экранов: что за адрес получится.
void main() {
  Shift shift({String address = 'ул. Абая, 10', String city = 'Алматы'}) =>
      Shift(
        id: 1,
        workDate: DateTime(2026, 10, 12),
        title: 'Услуги грузчика',
        company: 'Magnum',
        address: address,
        city: city,
        startMinutes: 1080, // 18:00
        endMinutes: 360, // 06:00 следующего дня
        hourlyRate: 110000,
        workersNeeded: 2,
        workersHired: 0,
      );

  group('адрес', () {
    test('без города в адресе город добавляется', () {
      expect(fullAddress(shift()), 'Алматы, ул. Абая, 10');
    });

    test('если город уже есть — второй раз его не пишем', () {
      expect(
        fullAddress(shift(address: 'г. Алматы, ул. Абая, 10')),
        'г. Алматы, ул. Абая, 10',
      );
    });
  });

  group('карты', () {
    test('2ГИС ищет полный адрес', () {
      final link = mapsLink(shift(city: 'Шымкент'), MapsApp.twoGis);
      expect(link.host, '2gis.kz');
      expect(Uri.decodeComponent(link.path),
          '/search/Шымкент, ул. Абая, 10');
    });

    test('Яндекс и Google получают адрес параметром', () {
      expect(mapsLink(shift(), MapsApp.yandex).queryParameters['text'],
          'Алматы, ул. Абая, 10');
      expect(mapsLink(shift(), MapsApp.google).queryParameters['query'],
          'Алматы, ул. Абая, 10');
    });
  });

  group('календарь', () {
    test('ночная смена заканчивается утром следующего дня', () {
      final link = calendarLink(shift());
      expect(link.queryParameters['dates'],
          '20261012T180000/20261013T060000');
      // Время «как на часах» и пояс отдельно — без перевода в UTC.
      expect(link.queryParameters['ctz'], 'Asia/Almaty');
    });

    test('в событии — место, сумма и срок отмены', () {
      final link = calendarLink(shift());
      expect(link.queryParameters['location'], 'Алматы, ул. Абая, 10');
      expect(link.queryParameters['text'], contains('Услуги грузчика'));
      final details = link.queryParameters['details']!;
      expect(details, contains('за смену'));
      expect(details, contains('Отменить запись можно до'));
    });
  });
}
