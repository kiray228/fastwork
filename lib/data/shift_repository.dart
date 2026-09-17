import 'package:drift/drift.dart';

import '../shift.dart';
import 'database.dart';

/// Мы пока один пользователь приложения. Настоящей регистрации ещё нет.
const currentWorkerId = 1;

// ---------------------------------------------------------------------------
// ИНТЕРФЕЙС
//
// Здесь описано, ЧТО умеет хранилище смен, но не сказано КАК.
// Экраны работают только с этим описанием и не знают, лежат данные
// в SQLite, на сервере или просто в памяти.
//
// Это и есть тот самый приём из Clean Architecture: экран зависит от
// описания, а не от конкретной базы. Заменим базу — экраны не изменятся.
// ---------------------------------------------------------------------------

/// Чем закончилась попытка записаться или отменить запись.
///
/// Вместо `true`/`false` — перечисление: оно объясняет **почему** не
/// получилось, и экран может показать понятную причину.
enum BookingResult {
  ok,
  noSlots, // мест уже нет
  alreadyBooked, // уже записан
  tooLateToCancel, // срок отмены прошёл
  notFound,
}

abstract class ShiftRepository {
  /// Смены на конкретный день.
  Future<List<Shift>> shiftsOn(DateTime date);

  /// В какие дни вообще есть смены — для точек в полосе дат.
  Future<Set<DateTime>> daysWithShifts();

  /// Одна смена по её номеру (после отклика нужно перечитать свежие данные).
  Future<Shift?> shiftById(int id);

  /// Записаться на смену.
  Future<BookingResult> apply(int shiftId);

  /// Отменить свою запись.
  Future<BookingResult> cancelApplication(int shiftId);

  /// Мои смены. `archived: false` — вкладка «В работе», `true` — «Архив».
  Future<List<Shift>> myShifts({required bool archived});
}

// ---------------------------------------------------------------------------
// РЕАЛИЗАЦИЯ НА SQLite
// ---------------------------------------------------------------------------

class DbShiftRepository implements ShiftRepository {
  final AppDatabase db;

  DbShiftRepository(this.db);

  /// Подзапрос: сколько человек уже набрано на смену.
  /// Считаем только активные отклики — отменённые место не занимают.
  static const _hiredSql = '''
    (SELECT COUNT(*) FROM application_rows a
      WHERE a.shift_id = s.id AND a.status = 'active') AS hired''';

  /// Подзапрос: откликнулся ли на эту смену текущий пользователь.
  static const _myStatusSql = '''
    (SELECT a2.status FROM application_rows a2
      WHERE a2.shift_id = s.id AND a2.worker_id = $currentWorkerId)
      AS my_status''';

  /// Превращаем строку из базы в объект `Shift`, с которым работают экраны.
  Shift _toShift(QueryRow row) => Shift(
        id: row.read<int>('id'),
        workDate: row.read<DateTime>('work_date'),
        title: row.read<String>('title'),
        company: row.read<String>('company'),
        address: row.read<String>('address'),
        startMinutes: row.read<int>('start_minutes'),
        endMinutes: row.read<int>('end_minutes'),
        breakMinutes: row.read<int>('break_minutes'),
        hourlyRate: row.read<int>('hourly_rate'),
        workersNeeded: row.read<int>('workers_needed'),
        // Вот оно: «набрано» не читается из колонки, а приходит из COUNT.
        workersHired: row.read<int>('hired'),
        myStatus: row.readNullable<String>('my_status'),
        duties: _splitDuties(row.read<String>('duties')),
        dressCode: row.readNullable<String>('dress_code'),
        employerComment: row.readNullable<String>('employer_comment'),
        payoutDelayDays: row.read<int>('payout_delay_days'),
        cancelDeadlineHours: row.read<int>('cancel_deadline_hours'),
      );

  static List<String> _splitDuties(String raw) =>
      raw.isEmpty ? const [] : raw.split('\n');

  @override
  Future<List<Shift>> shiftsOn(DateTime date) async {
    final from = DateTime(date.year, date.month, date.day);
    final to = from.add(const Duration(days: 1));

    // Настоящий SQL-запрос — тот самый, про который читали в теории.
    final rows = await db.customSelect(
      '''
      SELECT s.*, $_hiredSql, $_myStatusSql
      FROM shift_rows s
      WHERE s.work_date >= ? AND s.work_date < ?
      ORDER BY s.start_minutes
      ''',
      variables: [Variable.withDateTime(from), Variable.withDateTime(to)],
      readsFrom: {db.shiftRows, db.applicationRows},
    ).get();

    return rows.map(_toShift).toList();
  }

  @override
  Future<Set<DateTime>> daysWithShifts() async {
    final rows = await db.customSelect(
      'SELECT DISTINCT work_date FROM shift_rows',
      readsFrom: {db.shiftRows},
    ).get();

    return rows.map((r) {
      final d = r.read<DateTime>('work_date');
      return DateTime(d.year, d.month, d.day);
    }).toSet();
  }

  @override
  Future<Shift?> shiftById(int id) async {
    final rows = await db.customSelect(
      'SELECT s.*, $_hiredSql, $_myStatusSql FROM shift_rows s WHERE s.id = ?',
      variables: [Variable.withInt(id)],
      readsFrom: {db.shiftRows, db.applicationRows},
    ).get();

    return rows.isEmpty ? null : _toShift(rows.first);
  }

  @override
  Future<BookingResult> apply(int shiftId) async {
    // Транзакция: проверка свободных мест и запись выполняются как одно
    // неделимое действие. Иначе двое могли бы занять одно место
    // одновременно — та самая «гонка», о которой говорили.
    return db.transaction(() async {
      final shift = await shiftById(shiftId);
      if (shift == null) return BookingResult.notFound;
      if (shift.isApplied) return BookingResult.alreadyBooked;
      if (!shift.hasFreeSlots) return BookingResult.noSlots;

      final existing = await (db.select(db.applicationRows)
            ..where((a) =>
                a.shiftId.equals(shiftId) &
                a.workerId.equals(currentWorkerId)))
          .getSingleOrNull();

      if (existing != null) {
        // Запись уже была и её отменяли — возвращаем в активные.
        await (db.update(db.applicationRows)
              ..where((a) => a.id.equals(existing.id)))
            .write(const ApplicationRowsCompanion(
          status: Value(ApplicationStatus.active),
        ));
        return BookingResult.ok;
      }

      await db.into(db.applicationRows).insert(
            ApplicationRowsCompanion.insert(
              shiftId: shiftId,
              workerId: currentWorkerId,
              status: ApplicationStatus.active,
              createdAt: DateTime.now(),
            ),
          );
      return BookingResult.ok;
    });
  }

  @override
  Future<BookingResult> cancelApplication(int shiftId) async {
    final shift = await shiftById(shiftId);
    if (shift == null) return BookingResult.notFound;

    // Правило: отменить можно только до крайнего срока.
    // Проверка стоит здесь, а не на экране: экранов может стать несколько,
    // а правило должно быть одно.
    if (!shift.canCancelAt(DateTime.now())) {
      return BookingResult.tooLateToCancel;
    }

    await (db.update(db.applicationRows)
          ..where((a) =>
              a.shiftId.equals(shiftId) & a.workerId.equals(currentWorkerId)))
        .write(const ApplicationRowsCompanion(
      status: Value(ApplicationStatus.cancelled),
    ));
    return BookingResult.ok;
  }

  @override
  Future<List<Shift>> myShifts({required bool archived}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // «Архив» — не отдельная таблица, а другое условие в том же запросе.
    // В работе: отклик активен и смена ещё не прошла.
    // Архив: всё остальное.
    final condition = archived
        ? "(a.status != 'active' OR s.work_date < ?)"
        : "(a.status = 'active' AND s.work_date >= ?)";

    final rows = await db.customSelect(
      '''
      SELECT s.*, $_hiredSql, $_myStatusSql
      FROM application_rows a
      JOIN shift_rows s ON s.id = a.shift_id
      WHERE a.worker_id = $currentWorkerId AND $condition
      ORDER BY s.work_date ${archived ? 'DESC' : 'ASC'}, s.start_minutes
      ''',
      variables: [Variable.withDateTime(today)],
      readsFrom: {db.shiftRows, db.applicationRows},
    ).get();

    return rows.map(_toShift).toList();
  }

  /// Первое заполнение базы. Настоящих смен нам взять неоткуда,
  /// поэтому кладём демонстрационные — но уже в настоящие таблицы.
  Future<void> seedIfEmpty() async {
    final count = await db.shiftRows.count().getSingle();
    if (count > 0) return;

    for (final demo in buildDemoShifts()) {
      final id = await db.into(db.shiftRows).insert(
            ShiftRowsCompanion.insert(
              workDate: demo.workDate,
              title: demo.title,
              company: demo.company,
              address: demo.address,
              startMinutes: demo.startMinutes,
              endMinutes: demo.endMinutes,
              breakMinutes: Value(demo.breakMinutes),
              hourlyRate: demo.hourlyRate,
              workersNeeded: demo.workersNeeded,
              duties: Value(demo.duties.join('\n')),
              dressCode: Value(demo.dressCode),
              employerComment: Value(demo.employerComment),
              payoutDelayDays: Value(demo.payoutDelayDays),
              cancelDeadlineHours: Value(demo.cancelDeadlineHours),
            ),
          );

      // Часть мест уже занята другими работниками — заводим их отклики.
      // Номера с 100-го, чтобы не пересекаться с текущим пользователем.
      for (var i = 0; i < demo.workersHired; i++) {
        await db.into(db.applicationRows).insert(
              ApplicationRowsCompanion.insert(
                shiftId: id,
                workerId: 100 + i,
                status: ApplicationStatus.active,
                createdAt: DateTime.now(),
              ),
            );
      }
    }
  }
}
