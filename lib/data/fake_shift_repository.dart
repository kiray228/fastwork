import '../shift.dart';
import 'database.dart';
import 'shift_filter.dart';
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

  /// Рейтинг «текущего пользователя» — по нему проверяется допуск.
  double userRating;

  FakeShiftRepository({List<Shift>? shifts, this.userRating = 4.0})
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
  Future<List<Shift>> shiftsOn(
    DateTime date, {
    ShiftFilter filter = const ShiftFilter(),
  }) async {
    final list = _shifts
        .where((s) => isSameDay(s.workDate, date))
        .map(_decorate)
        .toList();
    return applyFilter(list, filter);
  }

  @override
  Future<Set<DateTime>> daysWithShifts() async => _shifts
      .map((s) => DateTime(s.workDate.year, s.workDate.month, s.workDate.day))
      .toSet();

  @override
  Future<List<String>> companies() async {
    final names = _shifts.map((s) => s.company).toSet().toList()..sort();
    return names;
  }

  @override
  Future<Shift?> shiftById(int id) async {
    for (final s in _shifts) {
      if (s.id == id) return _decorate(s);
    }
    return null;
  }

  @override
  Future<BookingResult> apply(int shiftId) async {
    final shift = await shiftById(shiftId);
    if (shift == null) return BookingResult.notFound;
    if (shift.isApplied) return BookingResult.alreadyBooked;
    if (!shift.ratingAllows(userRating)) return BookingResult.ratingTooLow;
    if (!shift.hasFreeSlots) return BookingResult.noSlots;

    _myStatuses[shiftId] = ApplicationStatus.active;
    return BookingResult.ok;
  }

  @override
  Future<BookingResult> cancelApplication(int shiftId) async {
    final shift = await shiftById(shiftId);
    if (shift == null) return BookingResult.notFound;
    if (!shift.canCancelAt(DateTime.now())) {
      return BookingResult.tooLateToCancel;
    }

    _myStatuses[shiftId] = ApplicationStatus.cancelled;
    return BookingResult.ok;
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
