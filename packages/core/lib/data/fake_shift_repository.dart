import '../notification.dart';
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

  /// Город «текущего пользователя» — по нему фильтруется лента.
  String city;

  FakeShiftRepository({
    List<Shift>? shifts,
    this.userRating = 4.0,
    this.city = 'Алматы',
  }) : _shifts = shifts ?? buildDemoShifts();

  Shift _decorate(Shift s) {
    final status = _myStatuses[s.id];
    final extra = (status == ApplicationStatus.active ||
            status == ApplicationStatus.completed)
        ? 1
        : 0;
    return s.copyWith(
      workersHired: s.workersHired + extra,
      myStatus: status,
      clearMyStatus: status == null,
      myCheckedInAt: _checkIns[s.id],
      cancelledAt: _cancelled.contains(s.id) ? DateTime.now() : null,
    );
  }

  @override
  Future<List<Shift>> shiftsOn(
    DateTime date, {
    ShiftFilter filter = const ShiftFilter(),
  }) async {
    final list = _shifts
        .where((s) =>
            isSameDay(s.workDate, date) &&
            s.city == city &&
            !_cancelled.contains(s.id))
        .map(_decorate)
        .toList();
    return applyFilter(list, filter);
  }

  @override
  Future<Set<DateTime>> daysWithShifts() async => _shifts
      .where((s) => s.city == city && !_cancelled.contains(s.id))
      .map((s) => DateTime(s.workDate.year, s.workDate.month, s.workDate.day))
      .toSet();

  @override
  Future<List<String>> companies() async {
    final names = _shifts
        .where((s) => s.city == city && !_cancelled.contains(s.id))
        .map((s) => s.company)
        .toSet()
        .toList()
      ..sort();
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
    if (shift.isCancelled) return BookingResult.alreadyCancelled;
    if (shift.isApplied) return BookingResult.alreadyBooked;
    if (!shift.ratingAllows(userRating)) return BookingResult.ratingTooLow;
    if (!shift.hasFreeSlots) return BookingResult.noSlots;

    _myStatuses[shiftId] = ApplicationStatus.active;
    return BookingResult.ok;
  }

  /// Отметки о выходе: номер смены -> когда отметился.
  final Map<int, DateTime> _checkIns = {};

  @override
  Future<BookingResult> checkIn(int shiftId) async {
    final shift = await shiftById(shiftId);
    if (shift == null) return BookingResult.notFound;
    if (shift.isCheckedIn) return BookingResult.alreadyBooked;
    if (!shift.canCheckInAt(DateTime.now())) {
      return BookingResult.tooEarlyToCheckIn;
    }

    _checkIns[shiftId] = DateTime.now();
    return BookingResult.ok;
  }

  @override
  Future<BookingResult> confirmAttendance({
    required int shiftId,
    required int workerId,
  }) async {
    _myStatuses[shiftId] = ApplicationStatus.completed;
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
    // Дата больше ни при чём: смена считается отработанной только
    // после подтверждения заказчика.
    return _shifts
        .where((s) => _myStatuses[s.id] == ApplicationStatus.completed)
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
    required String city,
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
      city: city,
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
  Future<List<ShiftApplicant>> applicantsFor(int shiftId) async {
    final status = _myStatuses[shiftId];
    // Отменившиеся из списка выпадают, а не вышедшие — нет: заказчик
    // должен видеть, кого он отметил, иначе непонятно, нажалась кнопка
    // или нет.
    if (status != ApplicationStatus.active &&
        status != ApplicationStatus.completed &&
        status != ApplicationStatus.noShow) {
      return const [];
    }

    return [
      ShiftApplicant(
        user: AppUser(
          id: 1,
          phone: '77001234567',
          fullName: 'Ернар Калдыбеков',
          city: 'Алматы',
          rating: userRating,
          isVerified: false,
          noShows: status == ApplicationStatus.noShow ? 1 : 0,
        ),
        status: status!,
        checkedInAt: _checkIns[shiftId],
      ),
    ];
  }

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
            _myStatuses[s.id] == ApplicationStatus.completed &&
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
  Future<BookingResult> cancelShift(int shiftId) async {
    final index = _shifts.indexWhere((s) => s.id == shiftId);
    if (index < 0) return BookingResult.notFound;
    if (_shifts[index].isCancelled) return BookingResult.alreadyCancelled;

    _cancelled.add(shiftId);
    _myStatuses.remove(shiftId);
    return BookingResult.ok;
  }

  @override
  Future<BookingResult> markNoShow({
    required int shiftId,
    required int workerId,
  }) async {
    _myStatuses[shiftId] = ApplicationStatus.noShow;
    return BookingResult.ok;
  }

  @override
  Future<BookingResult> updateShift({
    required int shiftId,
    required DateTime workDate,
    required String title,
    required String address,
    required int startMinutes,
    required int endMinutes,
    required int hourlyRate,
    required int workersNeeded,
    List<String> duties = const [],
    String? dressCode,
  }) async {
    final index = _shifts.indexWhere((s) => s.id == shiftId);
    if (index < 0) return BookingResult.notFound;

    final before = _decorate(_shifts[index]);
    if (before.isCancelled) return BookingResult.alreadyCancelled;
    if (workersNeeded < before.workersHired) {
      return BookingResult.fewerThanHired;
    }

    final old = _shifts[index];
    _shifts[index] = Shift(
      id: old.id,
      workDate: workDate,
      title: title,
      company: old.company,
      address: address,
      city: old.city,
      startMinutes: startMinutes,
      endMinutes: endMinutes,
      breakMinutes: old.breakMinutes,
      hourlyRate: hourlyRate,
      workersNeeded: workersNeeded,
      workersHired: old.workersHired,
      duties: duties,
      dressCode: dressCode,
      employerComment: old.employerComment,
      payoutDelayDays: old.payoutDelayDays,
      cancelDeadlineHours: old.cancelDeadlineHours,
      minRating: old.minRating,
      createdBy: old.createdBy,
    );
    return BookingResult.ok;
  }

  /// Номера отменённых смен. В памяти проще держать отдельным множеством,
  /// чем пересобирать сам объект смены.
  final Set<int> _cancelled = {};

  /// Уведомления, которые кто-то «прислал» в памяти.
  final List<AppNotification> _notifications = [];

  /// Добавить уведомление руками — нужно тестам и демонстрации.
  void pushNotification(AppNotification notification) =>
      _notifications.add(notification);

  @override
  Future<List<AppNotification>> notifications() async =>
      List.unmodifiable(_notifications.reversed);

  @override
  Future<int> unreadNotifications() async =>
      _notifications.where((n) => n.isUnread).length;

  @override
  Future<void> markNotificationsRead() async {
    final now = DateTime.now();
    for (var i = 0; i < _notifications.length; i++) {
      final n = _notifications[i];
      if (n.isUnread) {
        _notifications[i] = AppNotification(
          id: n.id,
          kind: n.kind,
          title: n.title,
          body: n.body,
          shiftId: n.shiftId,
          createdAt: n.createdAt,
          readAt: now,
        );
      }
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
