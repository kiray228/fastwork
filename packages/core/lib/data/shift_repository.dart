import 'package:drift/drift.dart';

import '../category.dart';
import '../notification.dart';
import '../review.dart';
import '../user.dart';
import '../shift.dart';
import 'database.dart';
import 'current_user.dart';
import 'shift_filter.dart';

/// Чем закончилась попытка записаться или отменить запись.
///
/// Вместо `true`/`false` — перечисление: оно объясняет **почему** не
/// получилось, и экран может показать понятную причину.
enum BookingResult {
  ok,
  noSlots, // мест уже нет
  alreadyBooked, // уже записан
  ratingTooLow, // рейтинг ниже порога заказчика
  tooLateToCancel, // срок отмены прошёл
  tooEarlyToCheckIn, // отметиться можно только в день смены
  notMine, // чужую смену отменить или изменить нельзя
  alreadyCancelled, // смена уже отменена
  fewerThanHired, // мест меньше, чем уже набрано людей
  notFound,
}

// ---------------------------------------------------------------------------
// ИНТЕРФЕЙС
//
// Здесь описано, ЧТО умеет хранилище смен, но не сказано КАК.
// Экраны работают только с этим описанием и не знают, лежат данные
// в SQLite, на сервере или просто в памяти.
// ---------------------------------------------------------------------------

abstract class ShiftRepository {
  /// Смены на конкретный день с учётом фильтра и сортировки.
  Future<List<Shift>> shiftsOn(DateTime date, {ShiftFilter filter});

  /// В какие дни вообще есть смены — для точек в полосе дат.
  Future<Set<DateTime>> daysWithShifts();

  /// Список компаний — чтобы построить фильтр.
  Future<List<String>> companies();

  /// Ключи категорий, по которым в городе есть смены, — тоже для фильтра.
  /// Показывать в фильтре все сорок незачем: выбрав пустую, человек
  /// получил бы пустой список и решил бы, что приложение сломалось.
  Future<List<String>> categories();

  /// Одна смена по её номеру.
  Future<Shift?> shiftById(int id);

  /// Записаться на смену.
  Future<BookingResult> apply(int shiftId);

  /// Отменить свою запись.
  Future<BookingResult> cancelApplication(int shiftId);

  /// Мои смены. `archived: false` — вкладка «В работе», `true` — «Архив».
  Future<List<Shift>> myShifts({required bool archived});

  /// Отработанные смены — из них складывается заработок.
  Future<List<Shift>> completedShifts();

  /// Сводка по компании: описание, средняя оценка, отзывы.
  Future<CompanyInfo> companyInfo(String company);

  /// Оставлял ли текущий пользователь отзыв об этой смене.
  Future<bool> hasReviewed(int shiftId);

  /// Оставить отзыв. Один отзыв на смену — это следит база.
  Future<void> addReview({
    required int shiftId,
    required int rating,
    String? comment,
  });

  /// Создать смену. Доступно роли «заказчик».
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
    String category,
    List<String> duties,
    String? dressCode,
    double? minRating,
  });

  /// Смены, созданные этим заказчиком.
  Future<List<Shift>> shiftsCreatedBy(int managerId);

  /// Кто записался на смену — список для заказчика.
  Future<List<ShiftApplicant>> applicantsFor(int shiftId);

  /// Заказчик отменяет свою смену. Всем записавшимся уходит уведомление.
  Future<BookingResult> cancelShift(int shiftId);

  /// Заказчик правит свою смену.
  ///
  /// Меняется не всё подряд: день, время, ставка, адрес, описание и число
  /// мест. Компанию и город не трогаем — они берутся из профиля заказчика,
  /// а не набираются руками.
  Future<BookingResult> updateShift({
    required int shiftId,
    required DateTime workDate,
    required String title,
    required String address,
    required int startMinutes,
    required int endMinutes,
    required int hourlyRate,
    required int workersNeeded,
    String? category, // null — оставить как было
    List<String> duties,
    String? dressCode,
  });

  /// Отметиться на смене: «я на месте».
  Future<BookingResult> checkIn(int shiftId);

  /// Заказчик подтверждает, что человек отработал.
  /// Только после этого смена идёт в заработок и в рейтинг.
  Future<BookingResult> confirmAttendance({
    required int shiftId,
    required int workerId,
  });

  /// Заказчик отмечает, что человек не вышел.
  ///
  /// Только вручную и только заказчиком. Соблазнительно было бы считать
  /// невыходом любую прошедшую смену без подтверждения — но это наказывало
  /// бы исполнителя за то, что заказчик забыл нажать кнопку.
  Future<BookingResult> markNoShow({
    required int shiftId,
    required int workerId,
  });

  /// Кого заказчику осталось оценить: люди с его уже прошедших смен,
  /// которым он ещё не поставил оценку.
  Future<List<PendingRating>> workersToRate(int managerId);

  /// Поставить оценку исполнителю за смену.
  Future<void> rateWorker({
    required int shiftId,
    required int workerId,
    required int rating,
    String? comment,
  });

  /// Отзывы, которые получил исполнитель.
  Future<List<WorkerReview>> reviewsAbout(int workerId);

  /// Уведомления текущего пользователя — новые сверху.
  Future<List<AppNotification>> notifications();

  /// Сколько уведомлений не прочитано — это число на колокольчике.
  ///
  /// Отдельный метод, а не `notifications().length`: на главном экране
  /// нужно только число, и тянуть ради него все тексты из базы незачем.
  Future<int> unreadNotifications();

  /// Отметить все уведомления прочитанными.
  Future<void> markNotificationsRead();

  /// Учебные данные: пара уже отработанных смен для нового пользователя,
  /// чтобы архив, кошелёк и отзывы не пустовали. Вызывать можно сколько
  /// угодно раз — повторно ничего не добавится.
  Future<void> prepareDemoHistory(int userId);
}

/// Фильтрация и сортировка, общие для всех реализаций хранилища.
///
/// Почему не в SQL? Сумма за смену **вычисляется** из ставки, времени и
/// перерыва, и свободные места тоже считаются. Повторять эти формулы в
/// SQL значило бы держать правило в двух местах — и однажды они разойдутся.
List<Shift> applyFilter(List<Shift> shifts, ShiftFilter filter) {
  var result = shifts;

  // Поиск словами. Ищем по названию, компании и адресу сразу: человек
  // набирает «грузчик», «Магнум» или «Абая», не задумываясь, что из этого
  // куда относится.
  //
  // Приводим обе стороны к нижнему регистру — иначе «Магнум» и «магнум»
  // оказались бы разными словами, а для человека это одно и то же.
  final query = filter.query.trim().toLowerCase();
  if (query.isNotEmpty) {
    result = result.where((s) {
      // Категория тоже участвует: «сантехник» найдёт смену, даже если
      // заказчик назвал её «Замена смесителя».
      final haystack = '${s.title} ${s.categoryInfo.name} '
              '${s.company} ${s.address}'
          .toLowerCase();
      // Все слова запроса должны найтись — но в любом порядке.
      // «грузчик магнум» и «магнум грузчик» дадут одно и то же.
      return query.split(RegExp(r'\s+')).every(haystack.contains);
    }).toList();
  }

  if (filter.companies.isNotEmpty) {
    result =
        result.where((s) => filter.companies.contains(s.company)).toList();
  }
  if (filter.categories.isNotEmpty) {
    result =
        result.where((s) => filter.categories.contains(s.category)).toList();
  }
  if (filter.onlyOpen) {
    result = result.where((s) => s.hasFreeSlots).toList();
  }

  result = [...result];
  switch (filter.sort) {
    case ShiftSort.byTime:
      result.sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    case ShiftSort.payDesc:
      result.sort((a, b) => b.totalPay.compareTo(a.totalPay));
    case ShiftSort.payAsc:
      result.sort((a, b) => a.totalPay.compareTo(b.totalPay));
  }
  return result;
}

/// Ключи категорий — в том порядке, в каком они стоят в справочнике.
///
/// Порядок справочника осмысленный: склад рядом со складом, общепит
/// рядом с общепитом. По алфавиту «Бариста» оказалась бы между
/// «Аниматором» и «Водителем», и фильтр читался бы как случайный набор.
List<String> sortCategories(Iterable<String> ids) {
  final present = ids.toSet();
  return [
    for (final c in kShiftCategories)
      if (present.contains(c.id)) c.id,
  ];
}

// ---------------------------------------------------------------------------
// РЕАЛИЗАЦИЯ НА SQLite
// ---------------------------------------------------------------------------

class DbShiftRepository implements ShiftRepository {
  final AppDatabase db;
  final CurrentUser session;

  DbShiftRepository(this.db, this.session);

  int get _workerId => session.workerId;

  /// Подзапрос: сколько человек уже набрано на смену.
  /// Место занимают и записавшиеся, и те, чей выход уже подтверждён.
  static const _hiredSql = '''
    (SELECT COUNT(*) FROM application_rows a
      WHERE a.shift_id = s.id
        AND a.status IN ('active', 'completed')) AS hired''';

  /// Подзапросы про мою запись: её состояние и время отметки.
  String get _mineSql => '''
    (SELECT a2.status FROM application_rows a2
      WHERE a2.shift_id = s.id AND a2.worker_id = $_workerId)
      AS my_status,
    (SELECT a3.checked_in_at FROM application_rows a3
      WHERE a3.shift_id = s.id AND a3.worker_id = $_workerId)
      AS my_checked_in_at''';

  /// Превращаем строку из базы в объект `Shift`, с которым работают экраны.
  Shift _toShift(QueryRow row) => Shift(
        id: row.read<int>('id'),
        workDate: row.read<DateTime>('work_date'),
        title: row.read<String>('title'),
        category: row.read<String>('category'),
        company: row.read<String>('company'),
        address: row.read<String>('address'),
        city: row.read<String>('city'),
        startMinutes: row.read<int>('start_minutes'),
        endMinutes: row.read<int>('end_minutes'),
        breakMinutes: row.read<int>('break_minutes'),
        hourlyRate: row.read<int>('hourly_rate'),
        workersNeeded: row.read<int>('workers_needed'),
        // Вот оно: «набрано» не читается из колонки, а приходит из COUNT.
        workersHired: row.read<int>('hired'),
        myStatus: row.readNullable<String>('my_status'),
        myCheckedInAt: row.readNullable<DateTime>('my_checked_in_at'),
        duties: _splitDuties(row.read<String>('duties')),
        dressCode: row.readNullable<String>('dress_code'),
        employerComment: row.readNullable<String>('employer_comment'),
        payoutDelayDays: row.read<int>('payout_delay_days'),
        cancelDeadlineHours: row.read<int>('cancel_deadline_hours'),
        minRating: row.readNullable<double>('min_rating'),
        createdBy: row.readNullable<int>('created_by'),
        cancelledAt: row.readNullable<DateTime>('cancelled_at'),
      );

  static List<String> _splitDuties(String raw) =>
      raw.isEmpty ? const [] : raw.split('\n');

  @override
  Future<List<Shift>> shiftsOn(
    DateTime date, {
    ShiftFilter filter = const ShiftFilter(),
  }) async {
    final from = DateTime(date.year, date.month, date.day);
    final to = from.add(const Duration(days: 1));

    // Настоящий SQL-запрос — тот самый, про который читали в теории.
    // Город в условии: подработка в другом городе человеку не нужна.
    final rows = await db.query(
      '''
      SELECT s.*, $_hiredSql, $_mineSql
      FROM shift_rows s
      WHERE s.work_date >= ? AND s.work_date < ? AND s.city = ?
        AND s.cancelled_at IS NULL
      ''',
      variables: [
        Variable.withDateTime(from),
        Variable.withDateTime(to),
        Variable.withString(session.city),
      ],
      readsFrom: {db.shiftRows, db.applicationRows},
    ).get();

    return applyFilter(rows.map(_toShift).toList(), filter);
  }

  @override
  Future<Set<DateTime>> daysWithShifts() async {
    final rows = await db.query(
      'SELECT DISTINCT work_date FROM shift_rows '
      'WHERE city = ? AND cancelled_at IS NULL',
      variables: [Variable.withString(session.city)],
      readsFrom: {db.shiftRows},
    ).get();

    return rows.map((r) {
      final d = r.read<DateTime>('work_date');
      return DateTime(d.year, d.month, d.day);
    }).toSet();
  }

  @override
  Future<List<String>> companies() async {
    final rows = await db.query(
      'SELECT DISTINCT company FROM shift_rows '
      'WHERE city = ? AND cancelled_at IS NULL ORDER BY company',
      variables: [Variable.withString(session.city)],
      readsFrom: {db.shiftRows},
    ).get();
    return rows.map((r) => r.read<String>('company')).toList();
  }

  @override
  Future<List<String>> categories() async {
    final rows = await db.query(
      'SELECT DISTINCT category FROM shift_rows '
      'WHERE city = ? AND cancelled_at IS NULL',
      variables: [Variable.withString(session.city)],
      readsFrom: {db.shiftRows},
    ).get();
    return sortCategories(rows.map((r) => r.read<String>('category')));
  }

  @override
  Future<Shift?> shiftById(int id) async {
    final rows = await db.query(
      'SELECT s.*, $_hiredSql, $_mineSql FROM shift_rows s WHERE s.id = ?',
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
      // Отменённой смены в ленте нет, но открытый экран мог остаться
      // открытым с прошлого раза — и кнопка на нём ещё живая.
      if (shift.isCancelled) return BookingResult.alreadyCancelled;
      if (shift.isApplied) return BookingResult.alreadyBooked;
      if (!shift.ratingAllows(session.rating)) {
        return BookingResult.ratingTooLow;
      }
      if (!shift.hasFreeSlots) return BookingResult.noSlots;

      final existing = await (db.select(db.applicationRows)
            ..where((a) =>
                a.shiftId.equals(shiftId) & a.workerId.equals(_workerId)))
          .getSingleOrNull();

      if (existing != null) {
        // Запись уже была и её отменяли — возвращаем в активные.
        await (db.update(db.applicationRows)
              ..where((a) => a.id.equals(existing.id)))
            .write(const ApplicationRowsCompanion(
          status: Value(ApplicationStatus.active),
        ));
        await _notifyApplied(shift);
        return BookingResult.ok;
      }

      await db.into(db.applicationRows).insert(
            ApplicationRowsCompanion.insert(
              shiftId: shiftId,
              workerId: _workerId,
              status: ApplicationStatus.active,
              createdAt: DateTime.now(),
            ),
          );
      await _notifyApplied(shift);
      return BookingResult.ok;
    });
  }

  Future<void> _notifyApplied(Shift shift) => _notify(
        userId: shift.createdBy,
        kind: NotificationKind.applied,
        title: 'Новая запись на смену',
        body: '$_myName записался на «${shift.title}» '
            '${_dayText(shift.workDate)}.',
        shiftId: shift.id,
      );

  /// Дата словами — «12 сентября». В уведомлении она нужна затем же,
  /// зачем и в письме: читать «на смену 2026-09-12» неприятно.
  static String _dayText(DateTime date) {
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
    ];
    return '${date.day} ${months[date.month - 1]}';
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
              a.shiftId.equals(shiftId) & a.workerId.equals(_workerId)))
        .write(const ApplicationRowsCompanion(
      status: Value(ApplicationStatus.cancelled),
    ));

    await _notify(
      userId: shift.createdBy,
      kind: NotificationKind.withdrew,
      title: 'Человек снял запись',
      body: '$_myName больше не выйдет на «${shift.title}» '
          '${_dayText(shift.workDate)}. Место снова свободно.',
      shiftId: shift.id,
    );
    return BookingResult.ok;
  }

  @override
  Future<List<Shift>> myShifts({required bool archived}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // «Архив» — не отдельная таблица, а другое условие в том же запросе.
    // В работе: запись жива и день ещё не прошёл.
    // В архиве: всё остальное — отменённые, подтверждённые, просроченные.
    final condition = archived
        ? "(a.status != 'active' OR s.work_date < ?)"
        : "(a.status = 'active' AND s.work_date >= ?)";

    final rows = await db.query(
      '''
      SELECT s.*, $_hiredSql, $_mineSql
      FROM application_rows a
      JOIN shift_rows s ON s.id = a.shift_id
      WHERE a.worker_id = $_workerId AND $condition
      ORDER BY s.work_date ${archived ? 'DESC' : 'ASC'}, s.start_minutes
      ''',
      variables: [Variable.withDateTime(today)],
      readsFrom: {db.shiftRows, db.applicationRows},
    ).get();

    return rows.map(_toShift).toList();
  }

  @override
  Future<List<Shift>> completedShifts() async {
    // Раньше здесь было «запись жива и дата прошла». Это было неправдой:
    // прошедшая дата не значит, что человек работал — он мог не прийти.
    // Теперь в заработок идёт только то, что подтвердил заказчик.
    final rows = await db.query(
      '''
      SELECT s.*, $_hiredSql, $_mineSql
      FROM application_rows a
      JOIN shift_rows s ON s.id = a.shift_id
      WHERE a.worker_id = $_workerId AND a.status = 'completed'
      ORDER BY s.work_date DESC
      ''',
      readsFrom: {db.shiftRows, db.applicationRows},
    ).get();

    return rows.map(_toShift).toList();
  }

  @override
  Future<BookingResult> checkIn(int shiftId) async {
    final shift = await shiftById(shiftId);
    if (shift == null) return BookingResult.notFound;
    if (shift.isCheckedIn) return BookingResult.alreadyBooked;

    // Правило «отметиться можно только в день смены» живёт в модели,
    // рядом с остальными правилами про время. Здесь его только спрашивают.
    if (!shift.canCheckInAt(DateTime.now())) {
      return BookingResult.tooEarlyToCheckIn;
    }

    await (db.update(db.applicationRows)
          ..where((a) =>
              a.shiftId.equals(shiftId) & a.workerId.equals(_workerId)))
        .write(ApplicationRowsCompanion(
      checkedInAt: Value(DateTime.now()),
    ));
    return BookingResult.ok;
  }

  @override
  Future<BookingResult> confirmAttendance({
    required int shiftId,
    required int workerId,
  }) async {
    final shift = await _myShiftOr(shiftId);
    if (shift is BookingResult) return shift;
    shift as Shift;

    await (db.update(db.applicationRows)
          ..where((a) =>
              a.shiftId.equals(shiftId) & a.workerId.equals(workerId)))
        .write(const ApplicationRowsCompanion(
      status: Value(ApplicationStatus.completed),
    ));

    await _notify(
      userId: workerId,
      kind: NotificationKind.confirmed,
      title: 'Смена подтверждена',
      body: 'Заказчик подтвердил выход на «${shift.title}» '
          '${_dayText(shift.workDate)}. '
          'Начислено ${formatMoney(shift.totalPay)}.',
      shiftId: shiftId,
    );
    return BookingResult.ok;
  }

  /// Смена, которой распоряжается текущий заказчик, — или причина отказа.
  ///
  /// Проверка вынесена отдельно, потому что нужна дважды: и когда выход
  /// подтверждают, и когда отмечают невыход. Оба действия меняют чужую
  /// репутацию, и права на них ровно у одного человека — того, кто смену
  /// создал.
  Future<Object> _myShiftOr(int shiftId) async {
    final shift = await shiftById(shiftId);
    if (shift == null) return BookingResult.notFound;
    if (shift.createdBy != _workerId) return BookingResult.notMine;
    return shift;
  }

  @override
  Future<BookingResult> markNoShow({
    required int shiftId,
    required int workerId,
  }) async {
    final shift = await _myShiftOr(shiftId);
    if (shift is BookingResult) return shift;
    shift as Shift;

    await (db.update(db.applicationRows)
          ..where((a) =>
              a.shiftId.equals(shiftId) & a.workerId.equals(workerId)))
        .write(const ApplicationRowsCompanion(
      status: Value(ApplicationStatus.noShow),
    ));

    // Человек обязан узнать: отметка влияет на его надёжность, и если
    // заказчик ошибся, у него должен быть повод написать в поддержку.
    await _notify(
      userId: workerId,
      kind: NotificationKind.noShow,
      title: 'Отмечен невыход',
      body: 'Заказчик отметил, что вы не вышли на «${shift.title}» '
          '${_dayText(shift.workDate)}. Если это ошибка — напишите в '
          'поддержку.',
      shiftId: shiftId,
    );
    return BookingResult.ok;
  }

  @override
  Future<CompanyInfo> companyInfo(String company) async {
    // AVG и COUNT — агрегатные функции: они сворачивают много строк в одно
    // число. Средняя оценка компании нигде не хранится, она считается тут.
    final agg = await db.query(
      '''
      SELECT CAST(AVG(r.rating) AS DOUBLE PRECISION) AS avg_rating,
             COUNT(*) AS cnt
      FROM review_rows r
      JOIN shift_rows s ON s.id = r.shift_id
      WHERE s.company = ?
      ''',
      variables: [Variable.withString(company)],
      readsFrom: {db.reviewRows, db.shiftRows},
    ).getSingle();

    final rows = await db.query(
      '''
      SELECT r.*, u.full_name AS author_name
      FROM review_rows r
      JOIN shift_rows s ON s.id = r.shift_id
      LEFT JOIN user_rows u ON u.id = r.author_id
      WHERE s.company = ?
      ORDER BY r.created_at DESC
      ''',
      variables: [Variable.withString(company)],
      readsFrom: {db.reviewRows, db.shiftRows, db.userRows},
    ).get();

    return CompanyInfo(
      name: company,
      rating: agg.readNullable<double>('avg_rating'),
      reviewCount: agg.read<int>('cnt'),
      reviews: rows
          .map((r) => Review(
                id: r.read<int>('id'),
                shiftId: r.read<int>('shift_id'),
                authorName:
                    r.readNullable<String>('author_name') ?? 'Исполнитель',
                rating: r.read<int>('rating'),
                comment: r.readNullable<String>('comment'),
                createdAt: r.read<DateTime>('created_at'),
              ))
          .toList(),
    );
  }

  @override
  Future<bool> hasReviewed(int shiftId) async {
    final row = await (db.select(db.reviewRows)
          ..where((r) =>
              r.shiftId.equals(shiftId) & r.authorId.equals(_workerId)))
        .getSingleOrNull();
    return row != null;
  }

  @override
  Future<void> addReview({
    required int shiftId,
    required int rating,
    String? comment,
  }) async {
    await db.into(db.reviewRows).insert(
          ReviewRowsCompanion.insert(
            shiftId: shiftId,
            authorId: _workerId,
            rating: rating,
            comment: Value(comment),
            createdAt: DateTime.now(),
          ),
          // «Вставь, а если такая строка уже есть — обнови её».
          //
          // `target` обязателен: без него база смотрит только на первичный
          // ключ (`id`), а наше правило «один отзыв на смену» держится на
          // другом ключе — паре (смена, автор). Не указав его, получаешь
          // не обновление, а падение с ошибкой UNIQUE.
          onConflict: DoUpdate(
            (_) => ReviewRowsCompanion(
              rating: Value(rating),
              comment: Value(comment),
              createdAt: Value(DateTime.now()),
            ),
            target: [db.reviewRows.shiftId, db.reviewRows.authorId],
          ),
        );
  }

  /// Демонстрационная история для нового пользователя.
  ///
  /// Настоящих отработанных смен у него взяться неоткуда, а без них пустуют
  /// и архив, и кошелёк, и отзывы. Поэтому при первом входе добавляем пару
  /// прошедших смен — это учебные данные, в боевом приложении их бы не было.
  @override
  Future<void> prepareDemoHistory(int userId) async {
    final existing = await db.query(
      'SELECT COUNT(*) AS c FROM application_rows WHERE worker_id = ?',
      variables: [Variable.withInt(userId)],
      readsFrom: {db.applicationRows},
    ).getSingle();
    if (existing.read<int>('c') > 0) return;

    final now = DateTime.now();
    DateTime day(int minus) =>
        DateTime(now.year, now.month, now.day - minus);

    final history = [
      (day(3), 'Услуги сотрудника склада', 'warehouse', 'Золотое яблоко',
          'г. Алматы, ул. Султана Бейбарыса, 1', 600, 1320, 110000),
      (day(9), 'Услуги работника торгового зала', 'sales_floor', 'Zara',
          'г. Алматы, ул. Розыбакиева, 247А', 600, 1260, 70000),
    ];

    for (final (date, title, category, company, address, start, end, rate)
        in history) {
      final id = await db.into(db.shiftRows).insert(
            ShiftRowsCompanion.insert(
              workDate: date,
              title: title,
              category: Value(category),
              company: company,
              address: address,
              startMinutes: start,
              endMinutes: end,
              hourlyRate: rate,
              workersNeeded: 1,
            ),
          );
      await db.into(db.applicationRows).insert(
            ApplicationRowsCompanion.insert(
              shiftId: id,
              workerId: userId,
              // Учебная история — уже подтверждённые смены: человек
              // отметился, заказчик подтвердил. Иначе они не попали бы
              // ни в заработок, ни в число отработанных.
              status: ApplicationStatus.completed,
              createdAt: date,
              checkedInAt: Value(date.add(const Duration(hours: 10))),
            ),
          );
    }
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
    String category = kOtherCategory,
    List<String> duties = const [],
    String? dressCode,
    double? minRating,
  }) {
    return db.into(db.shiftRows).insert(
          ShiftRowsCompanion.insert(
            workDate: workDate,
            title: title,
            category: Value(category),
            company: company,
            address: address,
            city: Value(city),
            startMinutes: startMinutes,
            endMinutes: endMinutes,
            hourlyRate: hourlyRate,
            workersNeeded: workersNeeded,
            createdBy: Value(createdBy),
            duties: Value(duties.join('\n')),
            dressCode: Value(dressCode),
            minRating: Value(minRating),
          ),
        );
  }

  @override
  Future<List<Shift>> shiftsCreatedBy(int managerId) async {
    final rows = await db.query(
      '''
      SELECT s.*, $_hiredSql, $_mineSql
      FROM shift_rows s
      WHERE s.created_by = ?
      ORDER BY s.work_date DESC, s.start_minutes
      ''',
      variables: [Variable.withInt(managerId)],
      readsFrom: {db.shiftRows, db.applicationRows},
    ).get();

    return rows.map(_toShift).toList();
  }

  @override
  Future<List<ShiftApplicant>> applicantsFor(int shiftId) async {
    // JOIN соединяет отклики с пользователями: в откликах лежит только
    // номер работника, а имя и рейтинг — в таблице пользователей.
    // Из отклика заодно берём состояние и время отметки.
    final rows = await db.query(
      '''
      SELECT u.*,
             a.status          AS application_status,
             a.checked_in_at   AS checked_in_at,
             CAST(COALESCE(
               (SELECT AVG(w.rating) FROM worker_review_rows w
                 WHERE w.worker_id = u.id),
               u.rating
             ) AS DOUBLE PRECISION) AS live_rating,
             CAST(COALESCE((SELECT COUNT(*) FROM application_rows d
               WHERE d.worker_id = u.id AND d.status = 'completed'
             ), 0) AS INTEGER) AS done_count,
             CAST(COALESCE((SELECT COUNT(*) FROM application_rows n
               WHERE n.worker_id = u.id AND n.status = 'no_show'
             ), 0) AS INTEGER) AS missed_count
      FROM application_rows a
      JOIN user_rows u ON u.id = a.worker_id
      WHERE a.shift_id = ?
        AND a.status IN ('active', 'completed', 'no_show')
      ORDER BY live_rating DESC
      ''',
      variables: [Variable.withInt(shiftId)],
      readsFrom: {db.applicationRows, db.userRows, db.workerReviewRows},
    ).get();

    return rows
        .map((r) => ShiftApplicant(
              user: AppUser(
                id: r.read<int>('id'),
                phone: r.read<String>('phone'),
                fullName: r.read<String>('full_name'),
                city: r.read<String>('city'),
                rating: r.read<double>('live_rating'),
                isVerified: r.read<bool>('is_verified'),
                role: r.read<String>('role'),
                completedShifts: r.read<int>('done_count'),
                noShows: r.read<int>('missed_count'),
              ),
              status: r.read<String>('application_status'),
              checkedInAt: r.readNullable<DateTime>('checked_in_at'),
            ))
        .toList();
  }

  @override
  Future<List<PendingRating>> workersToRate(int managerId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Запрос из трёх таблиц сразу:
    //   смены заказчика -> кто на них был записан -> имена этих людей.
    //
    // NOT EXISTS отсекает тех, кого этот заказчик уже оценил. Это подзапрос
    // в роли условия: «оставь строку, если вот такой строки нигде нет».
    final rows = await db.query(
      '''
      SELECT s.id       AS shift_id,
             s.title    AS shift_title,
             s.work_date,
             u.id       AS worker_id,
             u.full_name,
             CAST(COALESCE(
               (SELECT AVG(w.rating) FROM worker_review_rows w
                 WHERE w.worker_id = u.id),
               u.rating
             ) AS DOUBLE PRECISION) AS worker_rating
      FROM shift_rows s
      JOIN application_rows a ON a.shift_id = s.id
                             AND a.status = 'completed'
      JOIN user_rows u ON u.id = a.worker_id
      WHERE s.created_by = ?
        AND s.work_date < ?
        AND NOT EXISTS (
          SELECT 1 FROM worker_review_rows w
           WHERE w.shift_id = s.id
             AND w.worker_id = u.id
             AND w.author_id = ?
        )
      ORDER BY s.work_date DESC
      ''',
      variables: [
        Variable.withInt(managerId),
        Variable.withDateTime(today),
        Variable.withInt(managerId),
      ],
      readsFrom: {
        db.shiftRows,
        db.applicationRows,
        db.userRows,
        db.workerReviewRows,
      },
    ).get();

    return rows
        .map((r) => PendingRating(
              shiftId: r.read<int>('shift_id'),
              shiftTitle: r.read<String>('shift_title'),
              workDate: r.read<DateTime>('work_date'),
              workerId: r.read<int>('worker_id'),
              workerName: r.read<String>('full_name'),
              workerRating: r.read<double>('worker_rating'),
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
    await db.into(db.workerReviewRows).insert(
          WorkerReviewRowsCompanion.insert(
            shiftId: shiftId,
            workerId: workerId,
            authorId: _workerId,
            rating: rating,
            comment: Value(comment),
            createdAt: DateTime.now(),
          ),
          // Передумал — оценка меняется, но не добавляется второй.
          // Цель конфликта — тот самый тройной уникальный ключ.
          onConflict: DoUpdate(
            (_) => WorkerReviewRowsCompanion(
              rating: Value(rating),
              comment: Value(comment),
              createdAt: Value(DateTime.now()),
            ),
            target: [
              db.workerReviewRows.shiftId,
              db.workerReviewRows.workerId,
              db.workerReviewRows.authorId,
            ],
          ),
        );

    final shift = await shiftById(shiftId);
    await _notify(
      userId: workerId,
      kind: NotificationKind.rated,
      title: 'Новая оценка: $rating из 5',
      body: shift == null
          ? 'Заказчик оценил вашу работу.'
          : 'Заказчик оценил работу на «${shift.title}» '
              '${_dayText(shift.workDate)}.',
      shiftId: shiftId,
    );
  }

  @override
  Future<List<WorkerReview>> reviewsAbout(int workerId) async {
    final rows = await db.query(
      '''
      SELECT w.*, s.title AS shift_title, s.company
      FROM worker_review_rows w
      JOIN shift_rows s ON s.id = w.shift_id
      WHERE w.worker_id = ?
      ORDER BY w.created_at DESC
      ''',
      variables: [Variable.withInt(workerId)],
      readsFrom: {db.workerReviewRows, db.shiftRows},
    ).get();

    return rows
        .map((r) => WorkerReview(
              id: r.read<int>('id'),
              shiftId: r.read<int>('shift_id'),
              shiftTitle: r.read<String>('shift_title'),
              company: r.read<String>('company'),
              rating: r.read<int>('rating'),
              comment: r.readNullable<String>('comment'),
              createdAt: r.read<DateTime>('created_at'),
            ))
        .toList();
  }

  /// Первое заполнение базы. Настоящих смен нам взять неоткуда,
  /// поэтому кладём демонстрационные — но уже в настоящие таблицы.
  @override
  Future<BookingResult> cancelShift(int shiftId) async {
    return db.transaction(() async {
      final shift = await shiftById(shiftId);
      if (shift == null) return BookingResult.notFound;

      // Отменить смену может только тот, кто её создал.
      //
      // Проверка стоит здесь, а не на экране: кнопку заказчик видит только
      // на своих сменах, но в запрос к серверу можно подставить любой
      // номер. Правило, которое защищает данные, обязано жить там, где
      // данные меняются.
      if (shift.createdBy != _workerId) return BookingResult.notMine;
      if (shift.isCancelled) return BookingResult.alreadyCancelled;

      final now = DateTime.now();

      await (db.update(db.shiftRows)..where((s) => s.id.equals(shiftId)))
          .write(ShiftRowsCompanion(cancelledAt: Value(now)));

      // Кого предупредить — узнаём ДО того, как снимем записи: после
      // обновления они уже не будут `active`, и список окажется пустым.
      final affected = await (db.select(db.applicationRows)
            ..where((a) =>
                a.shiftId.equals(shiftId) &
                a.status.equals(ApplicationStatus.active)))
          .get();

      await (db.update(db.applicationRows)
            ..where((a) =>
                a.shiftId.equals(shiftId) &
                a.status.equals(ApplicationStatus.active)))
          .write(const ApplicationRowsCompanion(
        status: Value(ApplicationStatus.cancelled),
      ));

      for (final application in affected) {
        await _notify(
          userId: application.workerId,
          kind: NotificationKind.shiftCancelled,
          title: 'Смена отменена',
          body: 'Заказчик отменил «${shift.title}» '
              '${_dayText(shift.workDate)}. Выходить не нужно.',
          shiftId: shiftId,
        );
      }

      return BookingResult.ok;
    });
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
    String? category,
    List<String> duties = const [],
    String? dressCode,
  }) async {
    return db.transaction(() async {
      final before = await shiftById(shiftId);
      if (before == null) return BookingResult.notFound;
      if (before.createdBy != _workerId) return BookingResult.notMine;
      if (before.isCancelled) return BookingResult.alreadyCancelled;

      // Мест не может стать меньше, чем людей уже набрано. Иначе кого-то
      // пришлось бы выставить — а обещание работы уже дано.
      if (workersNeeded < before.workersHired) {
        return BookingResult.fewerThanHired;
      }

      await (db.update(db.shiftRows)..where((s) => s.id.equals(shiftId)))
          .write(ShiftRowsCompanion(
        workDate: Value(workDate),
        title: Value(title),
        category: Value.absentIfNull(category),
        address: Value(address),
        startMinutes: Value(startMinutes),
        endMinutes: Value(endMinutes),
        hourlyRate: Value(hourlyRate),
        workersNeeded: Value(workersNeeded),
        duties: Value(duties.join('\n')),
        dressCode: Value(dressCode),
      ));

      final changes = _describeChanges(
        before,
        workDate: workDate,
        address: address,
        startMinutes: startMinutes,
        endMinutes: endMinutes,
        hourlyRate: hourlyRate,
      );

      // Молчим, если поменяли мелочь вроде описания: уведомление о том,
      // чего человек не заметит, только приучает не читать уведомления.
      if (changes.isNotEmpty) {
        final affected = await (db.select(db.applicationRows)
              ..where((a) =>
                  a.shiftId.equals(shiftId) &
                  a.status.equals(ApplicationStatus.active)))
            .get();

        for (final application in affected) {
          await _notify(
            userId: application.workerId,
            kind: NotificationKind.shiftChanged,
            title: 'Смена изменилась',
            body: '«${before.title}» ${_dayText(before.workDate)}: '
                '${changes.join(', ')}.',
            shiftId: shiftId,
          );
        }
      }

      return BookingResult.ok;
    });
  }

  /// Что именно изменилось — человеческим языком, для уведомления.
  ///
  /// Сравниваем только то, ради чего стоит побеспокоить: день, время,
  /// ставку и адрес. Из-за правки опечатки в описании писать не будем.
  static List<String> _describeChanges(
    Shift before, {
    required DateTime workDate,
    required String address,
    required int startMinutes,
    required int endMinutes,
    required int hourlyRate,
  }) {
    final changes = <String>[];

    final sameDay = before.workDate.year == workDate.year &&
        before.workDate.month == workDate.month &&
        before.workDate.day == workDate.day;
    if (!sameDay) changes.add('новый день — ${_dayText(workDate)}');

    if (before.startMinutes != startMinutes ||
        before.endMinutes != endMinutes) {
      changes.add('новое время — '
          '${formatTime(startMinutes)}–${formatTime(endMinutes)}');
    }
    if (before.hourlyRate != hourlyRate) {
      changes.add('новая ставка — ${formatMoney(hourlyRate)}/ч');
    }
    if (before.address != address) changes.add('новый адрес — $address');

    return changes;
  }

  // -------------------------------------------------------------------------
  // УВЕДОМЛЕНИЯ
  // -------------------------------------------------------------------------

  /// Записать уведомление.
  ///
  /// Обрати внимание, где стоят вызовы этого метода: прямо в тех же
  /// действиях, где событие и происходит — в `apply`, `confirmAttendance`
  /// и так далее. Не в экранах.
  ///
  /// Если бы уведомление создавал экран, то стоило появиться второму
  /// способу записаться на смену — скажем, из уведомления или с сервера —
  /// и половина событий тихо перестала бы доходить. Правило то же, что и
  /// с проверками: событие принадлежит действию, а не кнопке.
  Future<void> _notify({
    required int? userId,
    required NotificationKind kind,
    required String title,
    required String body,
    int? shiftId,
  }) async {
    // Некому — например, смена учебная, её никто не создавал.
    if (userId == null || userId == 0) return;
    // Себе не пишем: человек и так знает, что он только что сделал.
    if (userId == _workerId) return;

    await db.into(db.notificationRows).insert(
          NotificationRowsCompanion.insert(
            userId: userId,
            kind: kind.name,
            title: title,
            body: body,
            shiftId: Value(shiftId),
            createdAt: DateTime.now(),
          ),
        );
  }

  /// Как подписать действующего в тексте уведомления.
  String get _myName => session.user?.fullName ?? 'Кто-то';

  @override
  Future<List<AppNotification>> notifications() async {
    final rows = await (db.select(db.notificationRows)
          ..where((n) => n.userId.equals(_workerId))
          ..orderBy([(n) => OrderingTerm.desc(n.createdAt)])
          // Ограничение не ради экономии, а ради экрана: список на тысячу
          // строк никто не листает, а грузиться он будет заметно.
          ..limit(50))
        .get();

    return rows
        .map((r) => AppNotification(
              id: r.id,
              kind: AppNotification.kindFrom(r.kind),
              title: r.title,
              body: r.body,
              shiftId: r.shiftId,
              createdAt: r.createdAt,
              readAt: r.readAt,
            ))
        .toList();
  }

  @override
  Future<int> unreadNotifications() async {
    final row = await db.query(
      '''
      SELECT COUNT(*) AS cnt FROM notification_rows
      WHERE user_id = ? AND read_at IS NULL''',
      variables: [Variable<int>(_workerId)],
      readsFrom: {db.notificationRows},
    ).getSingle();
    return row.read<int>('cnt');
  }

  @override
  Future<void> markNotificationsRead() async {
    await (db.update(db.notificationRows)
          ..where((n) => n.userId.equals(_workerId) & n.readAt.isNull()))
        .write(NotificationRowsCompanion(readAt: Value(DateTime.now())));
  }

  Future<void> seedIfEmpty() async {
    final count = await db.shiftRows.count().getSingle();
    if (count > 0) return;

    for (final demo in buildDemoShifts()) {
      final id = await db.into(db.shiftRows).insert(
            ShiftRowsCompanion.insert(
              workDate: demo.workDate,
              title: demo.title,
              category: Value(demo.category),
              company: demo.company,
              address: demo.address,
              city: Value(demo.city),
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
              minRating: Value(demo.minRating),
            ),
          );

      // Часть мест уже занята другими работниками — заводим их отклики.
      // Номера с 100-го, чтобы не пересекаться с настоящими пользователями.
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
