import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/stats.dart';
import 'package:flutter_test/flutter_test.dart';

/// Ярлыки, зависящие от времени, и сводка заказчика — без экранов.
void main() {
  final now = DateTime(2026, 10, 8, 12); // четверг, полдень

  Shift shift({
    required int daysAhead,
    int start = 600,
    int needed = 3,
    int hired = 0,
    DateTime? cancelledAt,
    bool awaitingPayment = false,
  }) =>
      Shift(
        id: daysAhead * 1000 + start,
        workDate: DateTime(2026, 10, 8 + daysAhead),
        title: 'Смена',
        company: 'Magnum',
        address: 'ул. Абая, 1',
        startMinutes: start,
        endMinutes: start + 240,
        hourlyRate: 100000,
        workersNeeded: needed,
        workersHired: hired,
        cancelledAt: cancelledAt,
        awaitingPayment: awaitingPayment,
      );

  group('ярлыки по времени', () {
    test('«Срочно» — если начнётся в ближайшие сутки и люди нужны', () {
      expect(shift(daysAhead: 1, start: 600).tagsAt(now), contains('Срочно'));
      expect(shift(daysAhead: 1, start: 780).tagsAt(now),
          isNot(contains('Срочно')),
          reason: 'через 25 часов — ещё не горит');
      expect(shift(daysAhead: 1, hired: 3).tagsAt(now),
          isNot(contains('Срочно')),
          reason: 'набрана — срочности нет');
    });

    test('«Без отмены» — до начала меньше срока отмены', () {
      // Завтра в 10:00 — 22 часа: отменить можно ещё 12 часов.
      expect(shift(daysAhead: 1).tagsAt(now), isNot(contains('Без отмены')));
      // Сегодня в 18:00 — 6 часов: записался — придётся идти.
      expect(shift(daysAhead: 0, start: 1080).tagsAt(now),
          contains('Без отмены'));
    });
  });

  group('сводка заказчика', () {
    test('места, смены и расходы считаются по истории', () {
      final stats = employerStats(
        [
          shift(daysAhead: -2, needed: 4, hired: 3),
          shift(daysAhead: -10, needed: 2, hired: 2),
          shift(daysAhead: -40, needed: 5, hired: 0), // давно — не в счёт
          shift(daysAhead: -1, needed: 9, cancelledAt: now), // отменена
          shift(daysAhead: 3, needed: 2, hired: 1), // впереди, набирается
          shift(daysAhead: 4, awaitingPayment: true), // не оплачена
        ],
        [
          WalletEntry(
            id: 1,
            kind: WalletEntryKind.charge,
            amount: -2000000,
            title: 'Оплата',
            createdAt: DateTime(2026, 10, 2),
          ),
          WalletEntry(
            id: 2,
            kind: WalletEntryKind.refund,
            amount: 500000,
            title: 'Возврат',
            createdAt: DateTime(2026, 10, 5),
          ),
          WalletEntry(
            id: 3,
            kind: WalletEntryKind.charge,
            amount: -900000,
            title: 'Прошлый месяц',
            createdAt: DateTime(2026, 9, 28),
          ),
        ],
        now,
      );

      expect(stats.shifts, 2);
      expect(stats.fillPercent, 83); // 5 из 6
      expect(stats.spentThisMonth, 1500000);
      expect(stats.open, 1);
    });

    test('без смен процент не выдумываем', () {
      final stats = employerStats(const [], const [], now);
      expect(stats.fillPercent, isNull);
      expect(stats.spentThisMonth, 0);
    });
  });
}
