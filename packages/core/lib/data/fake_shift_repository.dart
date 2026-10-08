import '../category.dart';
import '../mrp.dart';
import '../notification.dart';
import '../payment.dart';
import '../review.dart';
import '../shift.dart';
import '../user.dart';
import '../l10n/core_strings.dart';
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

  /// Который сейчас час — как у `DbShiftRepository`: тесты подставляют
  /// свои часы и двигают их, когда нужно «дожить» до смены.
  DateTime Function() clock;

  FakeShiftRepository({
    List<Shift>? shifts,
    this.userRating = 4.0,
    this.city = 'Алматы',
    DateTime Function()? clock,
  })  : _shifts = shifts ?? buildDemoShifts(),
        clock = clock ?? DateTime.now;

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
      cancelledAt: _cancelled.contains(s.id) ? clock() : null,
      // Демо-смены «оплатил» сервис, новые оплачены, когда прошла оплата.
      isFunded: !_refunded.contains(s.id) && !_awaiting.contains(s.id),
      awaitingPayment: _awaiting.contains(s.id),
      onWaitlist: _waitlist.contains(s.id),
    );
  }

  /// Смены, где «я» стою в листе ожидания.
  final Set<int> _waitlist = {};

  @override
  Future<BookingResult> setWaitlist(int shiftId, {required bool join}) async {
    if (!join) {
      _waitlist.remove(shiftId);
      return BookingResult.ok;
    }
    final shift = await shiftById(shiftId);
    if (shift == null) return BookingResult.notFound;
    if (shift.isCancelled) return BookingResult.alreadyCancelled;
    if (shift.isMine) return BookingResult.alreadyBooked;
    if (shift.hasStartedAt(clock())) return BookingResult.alreadyStarted;
    _waitlist.add(shiftId);
    return BookingResult.ok;
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
            _published(s))
        .map(_decorate);
    return applyFilter(bookable(list, clock()), filter);
  }

  @override
  Future<Set<DateTime>> daysWithShifts() async => _shifts
      .where((s) =>
          s.city == city && _published(s) && !s.hasStartedAt(clock()))
      .map((s) => DateTime(s.workDate.year, s.workDate.month, s.workDate.day))
      .toSet();

  @override
  Future<List<String>> companies() async {
    final names = _shifts
        .where((s) => s.city == city && _published(s))
        .map((s) => s.company)
        .toSet()
        .toList()
      ..sort();
    return names;
  }

  @override
  Future<List<String>> categories() async => sortCategories(_shifts
      .where((s) => s.city == city && _published(s))
      .map((s) => s.category));

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
    if (shift.myStatus != null &&
        shift.myStatus != ApplicationStatus.cancelled) {
      return BookingResult.alreadyFinished;
    }
    if (shift.hasStartedAt(clock())) return BookingResult.alreadyStarted;
    if (!shift.ratingAllows(userRating)) return BookingResult.ratingTooLow;
    if (!shift.hasFreeSlots) return BookingResult.noSlots;
    final booked = _shifts
        .where((s) => _myStatuses[s.id] == ApplicationStatus.active)
        .map(_decorate);
    if (hasTimeConflict(shift, booked)) return BookingResult.timeConflict;
    final limit = await earningsLimit(shift.workDate);
    if (!limit.allows(shift.totalPay)) return BookingResult.earningsLimit;

    _myStatuses[shiftId] = ApplicationStatus.active;
    _waitlist.remove(shiftId);
    return BookingResult.ok;
  }

  /// Отметки о выходе: номер смены -> когда отметился.
  final Map<int, DateTime> _checkIns = {};

  @override
  Future<BookingResult> checkIn(int shiftId, {String? code}) async {
    final shift = await shiftById(shiftId);
    if (shift == null) return BookingResult.notFound;
    if (shift.isCheckedIn) return BookingResult.alreadyBooked;
    if (!shift.canCheckInAt(clock())) {
      return BookingResult.tooEarlyToCheckIn;
    }
    if (code != null && code.trim() != _codes[shiftId]) {
      return BookingResult.wrongCode;
    }

    _checkIns[shiftId] = clock();
    if (code != null) _verified.add(shiftId);
    return BookingResult.ok;
  }

  /// Коды отметки по сменам и смены, где отметка подтверждена кодом.
  final Map<int, String> _codes = {};
  final Set<int> _verified = {};

  @override
  Future<String?> checkInCode(int shiftId) async =>
      _codes.putIfAbsent(shiftId, newCheckInCode);

  @override
  Future<BookingResult> confirmAttendance({
    required int shiftId,
    required int workerId,
  }) async {
    final status = _myStatuses[shiftId];
    if (status == null) return BookingResult.notFound;
    if (status == ApplicationStatus.completed) return BookingResult.ok;
    if (status != ApplicationStatus.active) return BookingResult.alreadyBooked;
    final shift = (await shiftById(shiftId))!;
    if (!shift.hasStartedAt(clock())) return BookingResult.notStarted;

    _myStatuses[shiftId] = ApplicationStatus.completed;
    _record(WalletEntryKind.earning, shift.totalPay,
        coreTr.earning(shift.title, shift.workDate),
        shiftId: shiftId);
    return BookingResult.ok;
  }

  // -------------------------------------------------------------------------
  // Деньги в памяти
  // -------------------------------------------------------------------------

  /// Тестовый шлюз — тесты смотрят в его список операций.
  final payments = SandboxPaymentGateway();

  /// Журнал движений. В памяти один человек на всё, поэтому и журнал один.
  final List<WalletEntry> ledger = [];
  int _nextEntryId = 1;

  /// Сколько внесено за смену сверх расчётной цены — после правок.
  /// Нет записи — внесено ровно по цене смены.
  final Map<int, int> _paid = {};

  /// Смены, остаток по которым уже вернули.
  final Set<int> _refunded = {};

  /// Смены, которые ещё ждут оплаты: их нет в ленте.
  final Set<int> _awaiting = {};

  /// Сколько по смене вернули за невыходы.
  final Map<int, int> _noShowRefunds = {};

  /// Все попытки оплаты: и смен, и доплат.
  final List<_FakeCharge> _charges = [];

  bool _published(Shift s) =>
      !_cancelled.contains(s.id) && !_awaiting.contains(s.id);

  void _record(String kind, int amount, String title, {int? shiftId}) {
    ledger.add(WalletEntry(
      id: _nextEntryId++,
      kind: kind,
      amount: amount,
      shiftId: shiftId,
      title: title,
      createdAt: clock(),
    ));
  }

  int _paidFor(Shift shift) => _paid[shift.id] ?? ShiftCost.of(shift).total;

  @override
  Future<BookingResult> cancelApplication(int shiftId) async {
    final shift = await shiftById(shiftId);
    if (shift == null) return BookingResult.notFound;
    if (!shift.isApplied) return BookingResult.notMine;
    if (!shift.canCancelAt(clock())) {
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

  /// Значения МРП. Тесты могут подставить свои — например, крошечный МРП,
  /// чтобы упереться в лимит одной сменой.
  List<MrpRate> mrpRates = kMrpHistory;

  @override
  Future<EarningsLimit> earningsLimit(DateTime month) async {
    final from = monthOf(month);
    final mine = _shifts
        .where((s) =>
            s.workDate.year == from.year &&
            s.workDate.month == from.month &&
            !_cancelled.contains(s.id))
        .map(_decorate);
    return EarningsLimit(
      month: from,
      earned: mine
          .where((s) => s.isCompleted)
          .fold(0, (sum, s) => sum + s.totalPay),
      booked: mine
          .where((s) => s.isApplied)
          .fold(0, (sum, s) => sum + s.totalPay),
      limit: monthlyEarningsLimit(from, mrpRates),
      mrp: mrpOn(DateTime(from.year, 1, 1), mrpRates),
    );
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

    final now = clock();
    return CompanyInfo(
      name: company,
      rating: avg,
      reviewCount: list.length,
      reviews: list,
      isFollowed: _followed.contains(company),
      upcoming: bookable(
        _shifts
            .where((s) =>
                s.company == company &&
                s.city == city &&
                _published(s) &&
                !s.workDate.isBefore(DateTime(now.year, now.month, now.day)))
            .map(_decorate),
        now,
      ).take(5).toList(),
    );
  }

  /// Компании, на которые «я» подписан.
  final Set<String> _followed = {};

  @override
  Future<void> followCompany(String company, {required bool follow}) async =>
      follow ? _followed.add(company) : _followed.remove(company);

  final Set<String> _followedCategories = {};

  @override
  Future<Set<String>> followedCategories() async => {..._followedCategories};

  @override
  Future<void> followCategory(String category, {required bool follow}) async =>
      follow
          ? _followedCategories.add(category)
          : _followedCategories.remove(category);

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
      authorName: coreTr.anonymousWorker,
      rating: rating,
      comment: comment,
      createdAt: clock(),
    ));
  }

  @override
  Future<PaymentCheckout> createShift({
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
    required PaymentMethod method,
    String? phone,
    String category = kOtherCategory,
    List<String> duties = const [],
    String? dressCode,
    double? minRating,
  }) async {
    final id = (_shifts.map((s) => s.id).fold<int>(0, (a, b) => a > b ? a : b)) + 1;
    final shift = Shift(
      id: id,
      workDate: workDate,
      title: title,
      category: category,
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
    );
    final kaspiPhone = _phoneFor(method, phone);
    _shifts.add(shift);
    _awaiting.add(id);
    return _start(_FakeCharge(
      id: _charges.length + 1,
      shiftId: id,
      method: method,
      amount: ShiftCost.of(shift).total,
      phone: kaspiPhone,
    ));
  }

  static String? _phoneFor(PaymentMethod method, String? phone) {
    if (method != PaymentMethod.kaspi) return null;
    final normalized = normalizeKzPhone(phone ?? '');
    if (normalized == null) {
      throw PaymentDeclined(coreTr.kaspiPhoneRequired);
    }
    return normalized;
  }

  Future<PaymentCheckout> _start(_FakeCharge charge) async {
    final started = await payments.provider(charge.method).startCheckout(
          amount: charge.amount,
          reference: 'charge-${charge.id}',
          description: coreTr.shiftFallback,
          phone: charge.phone,
        );
    charge.operation = started.operation;
    _charges.add(charge);
    return charge.checkout;
  }

  _FakeCharge _chargeById(int id) => _charges.firstWhere(
        (c) => c.id == id,
        orElse: () => throw PaymentDeclined(coreTr.paymentNotFound),
      );

  @override
  Future<PaymentCheckout> retryPayment(
    int shiftId, {
    required PaymentMethod method,
    String? phone,
  }) async {
    if (!_awaiting.contains(shiftId)) {
      throw PaymentDeclined(coreTr.shiftAlreadyPaid);
    }
    final shift = _shifts.firstWhere((s) => s.id == shiftId);
    return _start(_FakeCharge(
      id: _charges.length + 1,
      shiftId: shiftId,
      method: method,
      amount: ShiftCost.of(shift).total,
      phone: _phoneFor(method, phone),
    ));
  }

  @override
  Future<PaymentCheckout> paymentStatus(int paymentId) async {
    final charge = _chargeById(paymentId);
    await _settle(charge);
    return charge.checkout;
  }

  @override
  Future<PaymentCheckout> completeSandboxPayment(
    int paymentId, {
    PaymentCard? card,
  }) async {
    final charge = _chargeById(paymentId);
    payments.sandboxFor(charge.method)!.complete(charge.operation, card: card);
    await _settle(charge);
    return charge.checkout;
  }

  Future<void> _settle(_FakeCharge charge) async {
    if (charge.status != CheckoutStatus.pending) return;
    final result =
        await payments.provider(charge.method).checkStatus(charge.operation);
    switch (result.state) {
      case ProviderState.pending:
        return;
      case ProviderState.failed:
        charge.status = CheckoutStatus.failed;
        charge.message = result.message;
      case ProviderState.paid:
        charge.status = CheckoutStatus.paid;
        final shiftId = charge.shiftId;
        final edit = charge.edit;
        if (edit == null) {
          if (!_awaiting.remove(shiftId)) {
            // Смену уже оплатили другой попыткой — эти деньги вернуть.
            await payments.card.refund(operation: 'fake', amount: charge.amount);
            return;
          }
          _record(WalletEntryKind.charge, -charge.amount,
              coreTr.chargeShift(
                  _shifts.firstWhere((s) => s.id == shiftId).title,
                  result.paidWith ?? charge.method.title),
              shiftId: shiftId);
        } else {
          final index = _shifts.indexWhere((s) => s.id == shiftId);
          _paid[shiftId] = _paidFor(_shifts[index]) + charge.amount;
          _shifts[index] = edit;
          _record(WalletEntryKind.charge, -charge.amount,
              coreTr.chargeTopup(
                  edit.title, result.paidWith ?? charge.method.title),
              shiftId: shiftId);
        }
    }
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
        user: _me(noShows: status == ApplicationStatus.noShow ? 1 : 0),
        status: status!,
        checkedInAt: _checkIns[shiftId],
        isFavorite: _favorites.contains(1),
        checkInVerified: _verified.contains(shiftId),
      ),
    ];
  }

  /// Единственный исполнитель в памяти — он же «текущий пользователь».
  AppUser _me({int noShows = 0}) => AppUser(
        id: 1,
        phone: '77001234567',
        fullName: 'Ернар Калдыбеков',
        city: 'Алматы',
        rating: userRating,
        isVerified: false,
        noShows: noShows,
      );

  /// Номера любимых исполнителей.
  final Set<int> _favorites = {};

  @override
  Future<BookingResult> setFavorite({
    required int workerId,
    required bool favorite,
  }) async {
    if (!favorite) {
      _favorites.remove(workerId);
      return BookingResult.ok;
    }
    final worked =
        _myStatuses.values.any((s) => s == ApplicationStatus.completed);
    if (!worked) return BookingResult.notMine;
    _favorites.add(workerId);
    return BookingResult.ok;
  }

  @override
  Future<List<AppUser>> favoriteWorkers() async =>
      [if (_favorites.contains(1)) _me()];

  /// Оценки исполнителей, поставленные заказчиком.
  final List<WorkerReview> _workerReviews = [];
  final Set<String> _rated = {}; // 'shiftId:workerId'
  int _nextWorkerReviewId = 1;

  @override
  Future<List<PendingRating>> workersToRate(int managerId) async {
    final now = clock();
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
      shiftTitle: shift?.title ?? coreTr.shiftFallback,
      company: shift?.company ?? '',
      rating: rating,
      comment: comment,
      createdAt: clock(),
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

    final shift = _decorate(_shifts[index]);
    if (shift.isCancelled) return BookingResult.alreadyCancelled;
    if (shift.hasStartedAt(clock())) return BookingResult.alreadyStarted;
    var rest = shift.awaitingPayment
        ? 0
        : _paidFor(shift) - (_noShowRefunds[shiftId] ?? 0);
    for (final e in ledger.where((e) => e.shiftId == shiftId)) {
      if (e.kind == WalletEntryKind.earning) {
        rest -= ShiftCost(slotPay: e.amount, slots: 1).total;
      }
    }
    if (rest > 0) {
      await payments.card.refund(operation: 'fake', amount: rest);
      _record(WalletEntryKind.refund, rest, coreTr.refundCancelled(shift.title),
          shiftId: shiftId);
    }

    _cancelled.add(shiftId);
    _refunded.add(shiftId);
    _myStatuses.remove(shiftId);
    return BookingResult.ok;
  }

  @override
  Future<BookingResult> markNoShow({
    required int shiftId,
    required int workerId,
  }) async {
    final status = _myStatuses[shiftId];
    if (status == null) return BookingResult.notFound;
    if (status == ApplicationStatus.noShow) return BookingResult.ok;
    if (status != ApplicationStatus.active) return BookingResult.alreadyBooked;
    final shift = (await shiftById(shiftId))!;
    if (!shift.hasStartedAt(clock())) return BookingResult.notStarted;

    _myStatuses[shiftId] = ApplicationStatus.noShow;
    final slot = ShiftCost(slotPay: shift.totalPay, slots: 1).total;
    await payments.card.refund(operation: 'fake', amount: slot);
    _noShowRefunds[shiftId] = (_noShowRefunds[shiftId] ?? 0) + slot;
    _record(WalletEntryKind.refund, slot, coreTr.refundNoShow(shift.title),
        shiftId: shiftId);
    return BookingResult.ok;
  }

  @override
  Future<ShiftEditResult> updateShift({
    required int shiftId,
    required DateTime workDate,
    required String title,
    required String address,
    required int startMinutes,
    required int endMinutes,
    required int hourlyRate,
    required int workersNeeded,
    String? category,
    List<String> duties = const [],
    String? dressCode,
    PaymentMethod method = PaymentMethod.card,
    String? phone,
  }) async {
    final index = _shifts.indexWhere((s) => s.id == shiftId);
    if (index < 0) return const ShiftEditResult(BookingResult.notFound);

    final before = _decorate(_shifts[index]);
    if (before.isCancelled) {
      return const ShiftEditResult(BookingResult.alreadyCancelled);
    }
    if (before.hasStartedAt(clock())) {
      return const ShiftEditResult(BookingResult.alreadyStarted);
    }
    if (before.awaitingPayment) {
      return const ShiftEditResult(BookingResult.awaitingPayment);
    }
    if (workersNeeded < before.workersHired) {
      return const ShiftEditResult(BookingResult.fewerThanHired);
    }

    final old = _shifts[index];
    final updated = Shift(
      id: old.id,
      workDate: workDate,
      title: title,
      category: category ?? old.category,
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

    final paid = _paidFor(before);
    final diff = ShiftCost.of(updated).total - paid;
    if (diff > 0) {
      // Подорожала — правка ждёт доплаты и применится, когда она пройдёт.
      final checkout = await _start(_FakeCharge(
        id: _charges.length + 1,
        shiftId: shiftId,
        method: method,
        amount: diff,
        phone: _phoneFor(method, phone),
        edit: updated,
      ));
      return ShiftEditResult(BookingResult.paymentRequired, checkout: checkout);
    }
    if (diff < 0) {
      await payments.card.refund(operation: 'fake', amount: -diff);
      _record(WalletEntryKind.refund, -diff, coreTr.refundCheaper(updated.title),
          shiftId: shiftId);
    }
    _paid[shiftId] = paid + diff;
    _shifts[index] = updated;
    return const ShiftEditResult(BookingResult.ok);
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
    final now = clock();
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
    final now = clock();
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

/// Попытка оплаты в памяти.
class _FakeCharge {
  final int id;
  final int shiftId;
  final PaymentMethod method;
  final int amount;
  final String? phone;

  /// Доплата: смена с новыми условиями.
  final Shift? edit;
  String status = CheckoutStatus.pending;
  String operation = '';
  String? message;

  _FakeCharge({
    required this.id,
    required this.shiftId,
    required this.method,
    required this.amount,
    this.phone,
    this.edit,
  });

  PaymentCheckout get checkout => PaymentCheckout(
        id: id,
        shiftId: shiftId,
        method: method,
        amount: amount,
        status: status,
        phone: phone,
        sandbox: true,
        message: message,
      );
}
