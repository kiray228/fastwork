import 'package:fastwork/manager/manager_shifts_page.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/user.dart';
import 'package:flutter_test/flutter_test.dart';

/// Список записавшихся текстом — для проходной и рабочего чата.
void main() {
  test('в списке — кого ждут на смене, с телефонами, без невышедших', () {
    final shift = Shift(
      id: 1,
      workDate: DateTime(2026, 10, 17),
      title: 'Услуги грузчика',
      company: 'Magnum',
      address: 'ул. Абая, 1',
      startMinutes: 600,
      endMinutes: 1260,
      hourlyRate: 110000,
      workersNeeded: 3,
      workersHired: 3,
    );
    ShiftApplicant person(int id, String name, {String status = 'active'}) =>
        ShiftApplicant(
          user: AppUser(
            id: id,
            phone: '7700123456$id',
            fullName: name,
            city: 'Алматы',
            rating: 4.5,
            isVerified: false,
          ),
          status: status,
          checkedInAt: null,
        );

    final text = applicantsText(shift, [
      person(1, 'Ернар Калдыбеков'),
      person(2, 'Азамат Серик', status: 'no_show'),
      person(3, 'Айгуль Досова', status: 'completed'),
    ]);

    expect(text.split('\n').first, 'Услуги грузчика — Magnum');
    expect(text, contains('10:00–21:00, ул. Абая, 1'));
    expect(text, contains('1. Ернар Калдыбеков, +7 700 123 45 61'));
    expect(text, contains('2. Айгуль Досова, +7 700 123 45 63'));
    expect(text, isNot(contains('Азамат')));
  });
}
