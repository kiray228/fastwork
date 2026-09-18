import 'package:drift/drift.dart';

part 'database.g.dart';

// ---------------------------------------------------------------------------
// ТАБЛИЦЫ
//
// Это и есть та самая база данных, про которую мы читали теорию.
// Каждый класс ниже — таблица, каждое поле — колонка.
// Drift по этому описанию сам сгенерирует SQL и типобезопасный код.
// ---------------------------------------------------------------------------

/// Таблица смен.
class ShiftRows extends Table {
  IntColumn get id => integer().autoIncrement()(); // первичный ключ
  DateTimeColumn get workDate => dateTime()();
  TextColumn get title => text()();
  TextColumn get company => text()();
  TextColumn get address => text()();

  /// Город. Лента показывает смены только того города, который выбрал
  /// человек: подработка в другом городе ему не нужна.
  TextColumn get city => text().withDefault(const Constant('Алматы'))();
  IntColumn get startMinutes => integer()();
  IntColumn get endMinutes => integer()();
  IntColumn get breakMinutes => integer().withDefault(const Constant(60))();
  IntColumn get hourlyRate => integer()(); // в тиынах
  IntColumn get workersNeeded => integer()();
  TextColumn get duties => text().withDefault(const Constant(''))();
  TextColumn get dressCode => text().nullable()();
  TextColumn get employerComment => text().nullable()();
  IntColumn get payoutDelayDays => integer().withDefault(const Constant(1))();

  /// Кто создал смену. null — учебные данные, созданные приложением.
  IntColumn get createdBy => integer().nullable()();

  /// За сколько часов до начала смены ещё можно отменить запись.
  /// Добавлена во второй версии схемы — см. миграцию ниже.
  IntColumn get cancelDeadlineHours =>
      integer().withDefault(const Constant(10))();

  /// Минимальный рейтинг для допуска к смене. null — ограничений нет.
  /// Добавлена в третьей версии схемы.
  RealColumn get minRating => real().nullable()();
}

/// Пользователи приложения.
class UserRows extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Телефон — логин. UNIQUE: два аккаунта на один номер невозможны,
  /// и это проверяет сама база, а не код.
  TextColumn get phone => text().unique()();

  /// Почта — на неё приходит код для входа, по ней же человека узнают.
  /// Может быть пустой у тех, кто регистрировался до появления кодов.
  TextColumn get email => text().nullable().unique()();

  TextColumn get fullName => text()();
  TextColumn get city => text()();

  /// Рейтинг. У новичка он не пустой, а стартовый — иначе он не прошёл бы
  /// ни один фильтр по рейтингу и не смог бы начать работать вообще.
  RealColumn get rating => real().withDefault(const Constant(4.0))();

  BoolColumn get isVerified =>
      boolean().withDefault(const Constant(false))();

  /// Роль: `worker` — исполнитель, `manager` — сотрудник компании.
  /// Роль это **свойство** пользователя, а не отдельная таблица: поля у них
  /// одинаковые, различается только поведение.
  TextColumn get role =>
      text().withDefault(const Constant(UserRole.worker))();

  /// Название компании для менеджера. У исполнителя пусто.
  TextColumn get company => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
}

/// Роли пользователей.
class UserRole {
  UserRole._();

  static const worker = 'worker';
  static const manager = 'manager';
}

/// Документы исполнителя: удостоверение, санитарная книжка.
class DocumentRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get type => text()(); // id_card / medical_book
  TextColumn get number => text()();
  DateTimeColumn get expiresAt => dateTime().nullable()();

  /// Состояние проверки: pending → approved или rejected.
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();

  /// Один документ каждого типа на человека.
  @override
  List<Set<Column>> get uniqueKeys => [
        {userId, type},
      ];
}

/// Статусы проверки документа.
class DocumentStatus {
  DocumentStatus._();

  static const pending = 'pending';
  static const approved = 'approved';
  static const rejected = 'rejected';
}

/// Обращение в поддержку.
class SupportTicketRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get subject => text()();
  TextColumn get status => text()(); // open / closed
  DateTimeColumn get createdAt => dateTime()();
}

/// Сообщение внутри обращения.
///
/// Связь один-ко-многим: одно обращение — много сообщений.
/// Внешний ключ лежит здесь, на стороне «многих».
class SupportMessageRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ticketId => integer()
      .references(SupportTicketRows, #id, onDelete: KeyAction.cascade)();

  /// Колонку нельзя назвать `text`: так называется метод drift, которым
  /// объявляют текстовые колонки, и получилось бы обращение к самому себе.
  TextColumn get body => text()();
  BoolColumn get fromSupport => boolean()();
  DateTimeColumn get createdAt => dateTime()();
}

/// Отзывы исполнителя о филиале, где он отработал смену.
///
/// Обрати внимание: отзыв привязан к **смене**, а не просто к компании.
/// Это доказывает, что человек там действительно работал, и защищает
/// от накрутки рейтинга выдуманными отзывами.
class ReviewRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get shiftId =>
      integer().references(ShiftRows, #id, onDelete: KeyAction.cascade)();
  IntColumn get authorId => integer()();
  IntColumn get rating => integer()(); // 1..5
  TextColumn get comment => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  /// Один отзыв на одну смену от одного человека.
  @override
  List<Set<Column>> get uniqueKeys => [
        {shiftId, authorId},
      ];
}

/// Отзывы заказчика об исполнителе.
///
/// Зеркало предыдущей таблицы, но в другую сторону: там исполнитель
/// оценивал место работы, здесь место работы оценивает исполнителя.
///
/// Почему это отдельная таблица, а не колонка `target_type` в общей?
/// Потому что тогда внешний ключ стал бы невозможен: одна и та же колонка
/// ссылалась бы то на смены, то на пользователей, и база перестала бы
/// следить за целостностью. Две честные таблицы лучше одной хитрой.
class WorkerReviewRows extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Смена, после которой поставлена оценка. Как и в отзывах о компании,
  /// привязка к смене — доказательство, что человек действительно работал.
  IntColumn get shiftId =>
      integer().references(ShiftRows, #id, onDelete: KeyAction.cascade)();

  /// Кого оценивают.
  IntColumn get workerId => integer()();

  /// Кто оценивает — заказчик.
  IntColumn get authorId => integer()();

  IntColumn get rating => integer()(); // 1..5
  TextColumn get comment => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  /// Один заказчик оценивает одного исполнителя за одну смену один раз.
  @override
  List<Set<Column>> get uniqueKeys => [
        {shiftId, workerId, authorId},
      ];
}

/// Одноразовые коды для входа.
///
/// Обрати внимание: хранится не сам код, а его **отпечаток** — результат
/// необратимого преобразования. Если базу украдут, коды из неё не достать.
///
/// Так же хранят пароли в любом приличном приложении. Проверка работает
/// не «сравни коды», а «посчитай отпечаток присланного и сравни отпечатки».
class AuthCodeRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text()();

  /// Отпечаток кода, а не сам код.
  TextColumn get codeHash => text()();

  DateTimeColumn get createdAt => dateTime()();

  /// Когда код перестаёт действовать. Без срока подобранный однажды код
  /// работал бы вечно.
  DateTimeColumn get expiresAt => dateTime()();

  /// Сколько раз пытались ввести. После трёх неудач код сгорает —
  /// иначе шестизначный код можно перебрать за вечер.
  IntColumn get attempts => integer().withDefault(const Constant(0))();
}

/// Выданные токены.
///
/// Раньше они лежали в таблице настроек: ключ `token:...`, значение —
/// номер пользователя. Этого больше не хватает, потому что токен теперь
/// бывает двух видов: «я знаю, кто ты» и «почта подтверждена, но
/// аккаунта ещё нет» — второй выдаётся между вводом кода и заполнением
/// анкеты.
class AuthTokenRows extends Table {
  TextColumn get token => text()();

  /// Чей токен. null — почта подтверждена, аккаунт ещё не создан.
  IntColumn get userId => integer().nullable()();

  /// Подтверждённая почта. По ней создаётся аккаунт на следующем шаге.
  TextColumn get email => text()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {token};
}

/// Мелкие настройки приложения: ключ — значение.
/// Здесь храним, кто сейчас вошёл, чтобы не спрашивать при каждом запуске.
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Таблица откликов — связка между сменой и работником.
///
/// Обрати внимание: колонки «сколько человек набрано» в таблице смен **нет**.
/// Это вычисляемое значение, и мы его считаем запросом по этой таблице.
/// Ровно то правило, о котором говорили: вычисляемое не хранят.
class ApplicationRows extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Внешний ключ: ссылка на строку в таблице смен.
  /// База не позволит создать отклик на несуществующую смену.
  IntColumn get shiftId =>
      integer().references(ShiftRows, #id, onDelete: KeyAction.cascade)();

  IntColumn get workerId => integer()();
  TextColumn get status => text()(); // active / cancelled / completed
  DateTimeColumn get createdAt => dateTime()();

  /// Когда исполнитель отметился на месте. null — ещё не отмечался.
  ///
  /// Хранить именно **время**, а не галочку «отметился», выгоднее:
  /// из времени всегда можно получить галочку (`!= null`), а из галочки
  /// время уже не вернёшь. Общее правило: храни самое подробное.
  DateTimeColumn get checkedInAt => dateTime().nullable()();

  /// Один работник не может откликнуться на одну смену дважды.
  /// Это проверяет сама база — обойти нельзя.
  @override
  List<Set<Column>> get uniqueKeys => [
        {shiftId, workerId},
      ];
}

/// Статусы отклика — это жизненный путь одной записи на смену.
///
/// ```
///   active  ──отменил──────────────────────►  cancelled
///      │
///      └──отметился и заказчик подтвердил──►  completed
/// ```
///
/// Важно: `completed` ставит **заказчик**, а не календарь. Прошедшая
/// дата не значит, что человек работал, — он мог не прийти. Пока смена
/// не подтверждена, она не идёт ни в заработок, ни в число отработанных.
///
/// Архив — это не отдельная таблица, а всё, что вышло из `active`.
class ApplicationStatus {
  ApplicationStatus._();

  static const active = 'active';
  static const cancelled = 'cancelled';
  static const completed = 'completed';
}

/// Уведомления — то, что показывает колокольчик.
///
/// Таблица намеренно «глупая»: в ней лежит уже готовый текст, а не ссылки,
/// по которым его можно собрать. Почему — написано у модели
/// `AppNotification`: уведомление рассказывает о том, что было верно
/// в момент события, а не о том, что верно сейчас.
class NotificationRows extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Кому адресовано.
  IntColumn get userId => integer()();

  /// Вид события — имя значения из `NotificationKind`.
  TextColumn get kind => text()();

  TextColumn get title => text()();
  TextColumn get body => text()();

  /// Смена, к которой относится событие.
  ///
  /// Здесь нарочно **нет** внешнего ключа со связью «удалить вместе со
  /// сменой». В остальных таблицах он есть: отклик без смены — мусор.
  /// А уведомление «смену отменили» без смены — как раз то, ради чего
  /// оно и написано. Пусть переживёт саму смену.
  IntColumn get shiftId => integer().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  /// Когда прочитано. null — ещё не прочитано.
  DateTimeColumn get readAt => dateTime().nullable()();
}

// ---------------------------------------------------------------------------
// БАЗА ДАННЫХ
// ---------------------------------------------------------------------------

@DriftDatabase(
  tables: [
    ShiftRows,
    ApplicationRows,
    UserRows,
    AppSettings,
    ReviewRows,
    DocumentRows,
    SupportTicketRows,
    SupportMessageRows,
    WorkerReviewRows,
    AuthCodeRows,
    AuthTokenRows,
    NotificationRows,
  ],
)
/// Описание базы: какие таблицы и какой версии схема.
///
/// Обрати внимание, чего здесь **нет**: ни слова о том, где именно лежит
/// файл базы. Раньше было — и из-за этого файл тянул за собой Flutter,
/// а значит, база не могла работать нигде, кроме телефона и браузера.
///
/// Теперь хранилище передают снаружи. Телефон передаёт своё, сервер —
/// обычный файл на диске, тесты — базу в памяти. Тот же приём, что и с
/// репозиториями, только этажом ниже.
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Свой запрос к базе — с поправкой на диалект.
  ///
  /// Мы пишем запросы с вопросительными знаками:
  ///
  ///     WHERE email = ? AND created_at > ?
  ///
  /// Так принято в SQLite. PostgreSQL же нумерует подстановки:
  ///
  ///     WHERE email = $1 AND created_at > $2
  ///
  /// Одна и та же мысль, разная запись. SQL — общий язык, но у каждой
  /// базы свой выговор.
  ///
  /// Чтобы не держать два набора запросов, переводим их здесь. Все свои
  /// запросы в проекте идут через этот метод, а не через `customSelect`
  /// напрямую: иначе однажды кто-нибудь напишет мимо, и сломается это
  /// только на сервере, где PostgreSQL.
  Selectable<QueryRow> query(
    String sql, {
    List<Variable> variables = const [],
    Set<ResultSetImplementation<dynamic, dynamic>> readsFrom = const {},
  }) =>
      customSelect(
        portableSql(sql),
        variables: variables,
        readsFrom: readsFrom,
      );

  /// Перевод подстановок под текущую базу.
  ///
  /// Замена работает потому, что во всех наших запросах вопросительный
  /// знак встречается только как подстановка — внутри строковых значений
  /// его нет. Будь иначе, такая замена испортила бы текст.
  String portableSql(String sql) {
    if (executor.dialect != SqlDialect.postgres) return sql;

    var index = 0;
    return sql.replaceAllMapped(RegExp(r'\?'), (_) => '\$${++index}');
  }


  /// Версия схемы. Каждое изменение таблиц поднимает номер на единицу.
  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          // Вот она, настоящая миграция.
          //
          // У пользователя на телефоне уже стоит база версии 1 с его
          // записями. Пересоздать её нельзя — он потеряет свои данные.
          // Поэтому мы не создаём базу заново, а дописываем недостающую
          // колонку в существующую таблицу.
          if (from < 2) {
            await m.addColumn(shiftRows, shiftRows.cancelDeadlineHours);
          }
          if (from < 3) {
            await m.createTable(userRows);
            await m.createTable(appSettings);
            await m.addColumn(shiftRows, shiftRows.minRating);
          }
          if (from < 4) {
            await m.createTable(reviewRows);
          }
          if (from < 5) {
            await m.addColumn(shiftRows, shiftRows.createdBy);
            await m.addColumn(userRows, userRows.role);
            await m.addColumn(userRows, userRows.company);
            await m.createTable(documentRows);
            await m.createTable(supportTicketRows);
            await m.createTable(supportMessageRows);
          }
          if (from < 6) {
            await m.createTable(workerReviewRows);
          }
          if (from < 7) {
            await m.addColumn(shiftRows, shiftRows.city);
            await m.addColumn(applicationRows, applicationRows.checkedInAt);
          }
          if (from < 8) {
            await m.addColumn(userRows, userRows.email);
            await m.createTable(authCodeRows);
            await m.createTable(authTokenRows);
          }
          if (from < 9) {
            await m.createTable(notificationRows);
          }
        },
        beforeOpen: (details) async {
          // Без этой строки SQLite не проверяет внешние ключи — редкая
          // особенность: почти любая другая база следит за ними всегда.
          //
          // PostgreSQL как раз из «любых других», и слова PRAGMA он не
          // знает вовсе — на нём сервер падал при запуске, пока эта
          // строка выполнялась безусловно.
          if (executor.dialect == SqlDialect.sqlite) {
            await customStatement('PRAGMA foreign_keys = ON');
          }
        },
      );
}
