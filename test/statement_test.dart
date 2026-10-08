import 'package:fastwork/earnings_statement_page.dart';
import 'package:fastwork/l10n/strings.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/user.dart';
import 'package:flutter_test/flutter_test.dart';

/// Справка о заработке: только смены месяца, по порядку, с итогом — и на
/// языке человека.
void main() {
  const user = AppUser(
    id: 1,
    phone: '77001234567',
    fullName: 'Ернар Калдыбеков',
    city: 'Алматы',
    rating: 4.6,
    isVerified: true,
  );

  Shift shift(int id, DateTime day, String company) => Shift(
        id: id,
        workDate: day,
        title: 'Услуги грузчика',
        company: company,
        address: 'ул. Абая, 1',
        startMinutes: 600,
        endMinutes: 1260, // 11 ч, из них час перерыва
        hourlyRate: 110000,
        workersNeeded: 2,
        workersHired: 1,
        myStatus: 'completed',
      );

  final shifts = [
    shift(1, DateTime(2026, 9, 20), 'Zara'),
    shift(2, DateTime(2026, 9, 5), 'Magnum'),
    shift(3, DateTime(2026, 8, 30), 'Small'), // другой месяц
  ];

  tearDown(() => appLang = Lang.ru);

  test('только смены месяца, по порядку дней, с итогом', () {
    final text = statementText(user, DateTime(2026, 9), shifts);
    expect(
      text,
      'Справка о заработке в fastwork\n'
      'Ернар Калдыбеков, +7 700 123 45 67\n'
      'Сентябрь 2026\n'
      '\n'
      '5 сен — Magnum, «Услуги грузчика», 10:00–21:00, 10 ч — 11 000 ₸\n'
      '20 сен — Zara, «Услуги грузчика», 10:00–21:00, 10 ч — 11 000 ₸\n'
      '\n'
      'Итого: 2 смены, 20 ч, 22 000 ₸',
    );
  });

  test('по-английски — английские месяц, окончания и итог', () {
    appLang = Lang.en;
    final text = statementText(user, DateTime(2026, 9), shifts);
    expect(text, startsWith('fastwork earnings statement\n'));
    expect(text, contains('September 2026'));
    expect(text, endsWith('Total: 2 shifts, 20 h, 22 000 ₸'));
  });
}
