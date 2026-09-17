import '../review.dart';
import '../shift.dart';
import '../user.dart';
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

  final List<Review> _reviews = [];
  int _nextReviewId = 1;

  @override
  Future<List<Shift>> completedShifts() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _shifts
        .where((s) =>
            _myStatuses[s.id] == ApplicationStatus.active &&
            s.workDate.isBefore(today))
        .map(_decorate)
        .toList();
  }

  @override
  Future<CompanyInfo> companyInfo(String company) async {
    final ids = _shifts
        .where((s) => s.company == company)
        .map((s) => s.id)
        .toSet();
    final list = _reviews.where((r) => ids.contains(r.shiftId)).toList();

    final avg = list.isEmpty
        ? null
        : list.map((r) => r.rating).reduce((a, b) => a + b) / list.length;

    return CompanyInfo(
      name: company,
      rating: avg,
      reviewCount: list.length,
      reviews: list,
    );
  }

  @override
  Future<bool> hasReviewed(int shiftId) async =>
      _reviews.any((r) => r.shiftId == shiftId);

  @override
  Future<void> addReview({
    required int shiftId,
    required int rating,
    String? comment,
  }) async {
    _reviews.removeWhere((r) => r.shiftId == shiftId);
    _reviews.add(Review(
      id: _nextReviewId++,
      shiftId: shiftId,
      authorName: 'Исполнитель',
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<int> createShift({
    required DateTime workDate,
    required String title,
    required String company,
    required String address,
    required int startMinutes,
    required int endMinutes,
    required int hourlyRate,
    required int workersNeeded,
    required int createdBy,
    List<String> duties = const [],
    String? dressCode,
    double? minRating,
  }) async {
    final id = (_shifts.map((s) => s.id).fold<int>(0, (a, b) => a > b ? a : b)) + 1;
    _shifts.add(Shift(
      id: id,
      workDate: workDate,
      title: title,
      company: company,
      address: address,
      startMinutes: startMinutes,
      endMinutes: endMinutes,
      hourlyRate: hourlyRate,
      workersNeeded: workersNeeded,
      workersHired: 0,
      duties: duties,
      dressCode: dressCode,
      minRating: minRating,
      createdBy: createdBy,
    ));
    return id;
  }

  @override
  Future<List<Shift>> shiftsCreatedBy(int managerId) async =>
      _shifts.where((s) => s.createdBy == managerId).map(_decorate).toList();

  @override
  Future<List<AppUser>> applicantsFor(int shiftId) async =>
      _myStatuses[shiftId] == ApplicationStatus.active
          ? [
              const AppUser(
                id: 1,
                phone: '77001234567',
                fullName: 'Ернар Калдыбеков',
                city: 'Алматы',
                rating: 4.0,
                isVerified: false,
              ),
            ]
          : const [];

  /// Оценки исполнителей, поставленные заказчиком.
  final List<WorkerReview> _workerReviews = [];
  final Set<String> _rated = {}; // 'shiftId:workerId'
  int _nextWorkerReviewId = 1;

  @override
  Future<List<PendingRating>> workersToRate(int managerId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _shifts
        .where((s) =>
            s.createdBy == managerId &&
            s.workDate.isBefore(today) &&
            !_rated.contains('${s.id}:1'))
        .map((s) => PendingRating(
              shiftId: s.id,
              shiftTitle: s.title,
              workDate: s.workDate,
              workerId: 1,
              workerName: 'Ернар Калдыбеков',
              workerRating: userRating,
            ))
        .toList();
  }

  @override
  Future<void> rateWorker({
    required int shiftId,
    required int workerId,
    required int rating,
    String? comment,
  }) async {
    _rated.add('$shiftId:$workerId');
    final shift = await shiftById(shiftId);
    _workerReviews.add(WorkerReview(
      id: _nextWorkerReviewId++,
      shiftId: shiftId,
      shiftTitle: shift?.title ?? 'Смена',
      company: shift?.company ?? '',
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<List<WorkerReview>> reviewsAbout(int workerId) async =>
      List.unmodifiable(_workerReviews);

  @override
  Future<void> prepareDemoHistory(int userId) async {
    // В памяти истории нет — тестам она не нужна.
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
