import 'package:drift/drift.dart';

import '../mrp.dart';
import 'database.dart';

/// Откуда брать МРП.
///
/// Отдельный маленький класс, а не метод в хранилище смен: МРП нужен
/// и записи на смену (проверить лимит), и кошельку (показать остаток),
/// и серверу (принять новое значение). Три места — одно правило, где
/// искать.
class MrpStore {
  final AppDatabase db;

  MrpStore(this.db);

  /// Все известные значения: запасные из кода плюс записанные в базу.
  ///
  /// Если в базе есть строка на ту же дату, что и в коде, побеждает база:
  /// значит, кто-то сознательно поправил значение, и код об этом не знал.
  Future<List<MrpRate>> rates() async {
    final rows = await db.select(db.mrpRateRows).get();

    final byDate = <DateTime, MrpRate>{
      for (final r in kMrpHistory) r.validFrom: r,
    };
    for (final row in rows) {
      final day = DateTime(
        row.validFrom.year,
        row.validFrom.month,
        row.validFrom.day,
      );
      byDate[day] = MrpRate(validFrom: day, amount: row.amount);
    }

    return byDate.values.toList()
      ..sort((a, b) => a.validFrom.compareTo(b.validFrom));
  }

  /// Записать новое значение — или поправить уже записанное на ту дату.
  Future<void> setRate(DateTime validFrom, int amount) async {
    final day = DateTime(validFrom.year, validFrom.month, validFrom.day);
    await db.into(db.mrpRateRows).insert(
          MrpRateRowsCompanion.insert(
            validFrom: day,
            amount: amount,
            createdAt: DateTime.now(),
          ),
          onConflict: DoUpdate(
            (_) => MrpRateRowsCompanion(amount: Value(amount)),
            target: [db.mrpRateRows.validFrom],
          ),
        );
  }
}
