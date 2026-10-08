// Сводка для заказчика: сколько смен, насколько они набираются и во что
// обходятся.
//
// Считается из того, что приложение и так загружает: списка смен
// заказчика и истории его платежей. Отдельной таблицы под статистику нет —
// храни мы итоги отдельно, их пришлось бы пересчитывать при каждой
// записи, отмене и возврате, и однажды они разошлись бы с историей.

import 'payment.dart';
import 'shift.dart';

class EmployerStats {
  /// Смен за последние 30 дней — прошедших и идущих, без отменённых и
  /// неоплаченных.
  final int shifts;

  /// Сколько мест на этих сменах заняли люди, от 0 до 100. null — смен
  /// не было, и процент ничего бы не значил.
  final int? fillPercent;

  /// Потрачено за текущий месяц: оплаты минус возвраты, в тиынах.
  final int spentThisMonth;

  /// Смены, которые ещё набираются: впереди и есть свободные места.
  final int open;

  const EmployerStats({
    required this.shifts,
    required this.fillPercent,
    required this.spentThisMonth,
    required this.open,
  });
}

EmployerStats employerStats(
  List<Shift> shifts,
  List<WalletEntry> entries,
  DateTime now,
) {
  final since = DateTime(now.year, now.month, now.day - 30);
  final live = shifts.where((s) => !s.isCancelled && !s.awaitingPayment);

  final recent = live
      .where((s) => !s.workDate.isBefore(since) && s.hasStartedAt(now))
      .toList();
  final needed = recent.fold<int>(0, (sum, s) => sum + s.workersNeeded);
  final hired = recent.fold<int>(
      0, (sum, s) => sum + (s.workersHired > s.workersNeeded
          ? s.workersNeeded
          : s.workersHired));

  final monthStart = DateTime(now.year, now.month);
  var spent = 0;
  for (final e in entries) {
    if (e.createdAt.isBefore(monthStart)) continue;
    // Оплата записана с минусом, возврат — с плюсом: расход — это минус
    // их суммы.
    if (e.kind == WalletEntryKind.charge || e.kind == WalletEntryKind.refund) {
      spent -= e.amount;
    }
  }

  return EmployerStats(
    shifts: recent.length,
    fillPercent: needed == 0 ? null : (hired * 100 / needed).round(),
    spentThisMonth: spent,
    open: live.where((s) => !s.hasStartedAt(now) && s.hasFreeSlots).length,
  );
}
