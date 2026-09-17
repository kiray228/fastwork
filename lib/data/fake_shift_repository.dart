import '../shift.dart';
import 'database.dart';
import 'shift_repository.dart';

/// Хранилище смен в памяти — без базы данных.
///
/// Нужно для тестов: они должны запускаться за секунду и не зависеть от
/// файлов на диске. Экраны разницы не замечают, потому что работают
/// с интерфейсом `ShiftRepository`, а не с конкретной базой.
///
/// Вот ради этого и нужен слой репозитория: одну и ту же программу можно
/// запустить на SQLite, на сервере или на выдуманных данных.
class FakeShiftRepository implements ShiftRepository {
  final List<Shift> _shifts;
  final Map<int, String> _myStatuses = {};

  FakeShiftRepository([List<Shift>? shifts])
      : _shifts = shifts ?? buildDemoShifts();

  Shift _decorate(Shift s) {
    final status = _myStatuses[s.id];
    final extra = status == ApplicationStatus.active ? 1 : 0;
    return s.copyWith(
      workersHired: s.workersHired + extra,
      myStatus: status,
      clearMyStatus: status == null,
    );
  }

  @override
  Future<List<Shift>> shiftsOn(DateTime date) async => _shifts
      .where((s) => isSameDay(s.workDate, date))
      .map(_decorate)
      .toList();

  @override
  Future<Set<DateTime>> daysWithShifts() async => _shifts
      .map((s) => DateTime(s.workDate.year, s.workDate.month, s.workDate.day))
      .toSet();

  @override
  Future<Shift?> shiftById(int id) async {
    for (final s in _shifts) {
      if (s.id == id) return _decorate(s);
    }
    return null;
  }

  @override
  Future<void> apply(int shiftId) async {
    final shift = await shiftById(shiftId);
    if (shift == null || !shift.hasFreeSlots) return;
    _myStatuses[shiftId] = ApplicationStatus.active;
  }

  @override
  Future<void> cancelApplication(int shiftId) async {
    if (_myStatuses.containsKey(shiftId)) {
      _myStatuses[shiftId] = ApplicationStatus.cancelled;
    }
  }

  @override
  Future<List<Shift>> myShifts({required bool archived}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _shifts.where((s) {
      final status = _myStatuses[s.id];
      if (status == null) return false;
      final isActive =
          status == ApplicationStatus.active && !s.workDate.isBefore(today);
      return archived ? !isActive : isActive;
    }).map(_decorate).toList();
  }
}
