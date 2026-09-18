import 'package:fastwork_core/notification.dart';
import 'package:fastwork_core/review.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/user.dart';
import 'api_client.dart';
import 'package:fastwork_core/data/shift_filter.dart';
import 'package:fastwork_core/data/shift_repository.dart';

/// Смены с сервера.
///
/// Вот оно, обещание архитектуры: **четвёртая реализация того же
/// интерфейса**. Первая ходила в SQLite, вторая — в память для тестов,
/// третья ломалась нарочно, эта ходит по сети.
///
/// Ни один экран не знает, какая из них подставлена. Открой `shifts_page`
/// и убедись: там по-прежнему `widget.repository.shiftsOn(...)`, и ни
/// строчки про HTTP.
class ApiShiftRepository implements ShiftRepository {
  final ApiClient client;

  ApiShiftRepository(this.client);

  /// Дата в адресе запроса — только день, без времени.
  static String _day(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  List<Shift> _shifts(dynamic data) => (data as List<dynamic>)
      .map((e) => shiftFromJson(e as Map<String, dynamic>))
      .toList();

  /// Ответ сервера про попытку записи — обратно в наше перечисление.
  BookingResult _result(dynamic data) {
    final name = (data as Map<String, dynamic>)['result'] as String;
    return BookingResult.values.firstWhere(
      (r) => r.name == name,
      orElse: () => BookingResult.notFound,
    );
  }

  @override
  Future<List<Shift>> shiftsOn(
    DateTime date, {
    ShiftFilter filter = const ShiftFilter(),
  }) async {
    final data = await client.get('/api/shifts', {'date': _day(date)});
    // Фильтр применяем здесь — тем же кодом, что и остальные хранилища.
    // Правила сортировки и подсчёта суммы живут в одном месте, и от
    // переезда на сервер это не изменилось.
    return applyFilter(_shifts(data), filter);
  }

  @override
  Future<Set<DateTime>> daysWithShifts() async {
    final data = await client.get('/api/shifts/days') as List<dynamic>;
    return data.map((e) {
      final d = DateTime.parse(e as String);
      return DateTime(d.year, d.month, d.day);
    }).toSet();
  }

  @override
  Future<List<String>> companies() async =>
      (await client.get('/api/companies') as List<dynamic>).cast<String>();

  @override
  Future<Shift?> shiftById(int id) async {
    try {
      final data = await client.get('/api/shifts/$id');
      return shiftFromJson(data as Map<String, dynamic>);
    } on ApiException catch (e) {
      // 404 — это не сбой, а честный ответ «такой смены нет».
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<BookingResult> apply(int shiftId) async =>
      _result(await client.post('/api/shifts/$shiftId/apply'));

  @override
  Future<BookingResult> cancelApplication(int shiftId) async =>
      _result(await client.post('/api/shifts/$shiftId/cancel'));

  @override
  Future<BookingResult> checkIn(int shiftId) async =>
      _result(await client.post('/api/shifts/$shiftId/checkin'));

  @override
  Future<void> confirmAttendance({
    required int shiftId,
    required int workerId,
  }) async {
    await client.post('/api/shifts/$shiftId/confirm', {'workerId': workerId});
  }

  @override
  Future<List<Shift>> myShifts({required bool archived}) async => _shifts(
        await client.get('/api/my-shifts', {'archived': '$archived'}),
      );

  @override
  Future<List<Shift>> completedShifts() async =>
      _shifts(await client.get('/api/my-shifts/completed'));

  @override
  Future<CompanyInfo> companyInfo(String company) async {
    // Название компании идёт в адресе, а там нельзя пробелы и кириллицу
    // как есть — их кодируют.
    final data =
        await client.get('/api/companies/${Uri.encodeComponent(company)}');
    return companyInfoFromJson(data as Map<String, dynamic>);
  }

  @override
  Future<bool> hasReviewed(int shiftId) async {
    final data = await client.get('/api/shifts/$shiftId/reviewed');
    return (data as Map<String, dynamic>)['reviewed'] as bool;
  }

  @override
  Future<void> addReview({
    required int shiftId,
    required int rating,
    String? comment,
  }) async {
    await client.post(
      '/api/shifts/$shiftId/review',
      {'rating': rating, 'comment': comment},
    );
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
    final data = await client.post('/api/shifts', {
      'workDate': workDate.toIso8601String(),
      'title': title,
      'company': company,
      'address': address,
      'city': city,
      'startMinutes': startMinutes,
      'endMinutes': endMinutes,
      'hourlyRate': hourlyRate,
      'workersNeeded': workersNeeded,
      'duties': duties,
      'dressCode': dressCode,
      'minRating': minRating,
    });
    return (data as Map<String, dynamic>)['id'] as int;
  }

  @override
  Future<List<Shift>> shiftsCreatedBy(int managerId) async =>
      _shifts(await client.get('/api/manager/shifts'));

  @override
  Future<List<ShiftApplicant>> applicantsFor(int shiftId) async {
    final data =
        await client.get('/api/shifts/$shiftId/applicants') as List<dynamic>;
    return data
        .map((e) => applicantFromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PendingRating>> workersToRate(int managerId) async {
    final data = await client.get('/api/manager/to-rate') as List<dynamic>;
    return data
        .map((e) => pendingRatingFromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> rateWorker({
    required int shiftId,
    required int workerId,
    required int rating,
    String? comment,
  }) async {
    await client.post('/api/shifts/$shiftId/rate', {
      'workerId': workerId,
      'rating': rating,
      'comment': comment,
    });
  }

  @override
  Future<List<WorkerReview>> reviewsAbout(int workerId) async {
    final data = await client.get('/api/me/reviews') as List<dynamic>;
    return data
        .map((e) => workerReviewFromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<AppNotification>> notifications() async {
    final data = await client.get('/api/notifications') as List<dynamic>;
    return data
        .map((e) => notificationFromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> unreadNotifications() async {
    final data =
        await client.get('/api/notifications/unread') as Map<String, dynamic>;
    return data['count'] as int;
  }

  @override
  Future<void> markNotificationsRead() =>
      client.post('/api/notifications/read', const {});

  @override
  Future<void> prepareDemoHistory(int userId) async {
    // Учебную историю заводит сервер при первом запуске — клиенту тут
    // делать нечего.
  }
}
