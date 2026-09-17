import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

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
  IntColumn get startMinutes => integer()();
  IntColumn get endMinutes => integer()();
  IntColumn get breakMinutes => integer().withDefault(const Constant(60))();
  IntColumn get hourlyRate => integer()(); // в тиынах
  IntColumn get workersNeeded => integer()();
  TextColumn get duties => text().withDefault(const Constant(''))();
  TextColumn get dressCode => text().nullable()();
  TextColumn get employerComment => text().nullable()();
  IntColumn get payoutDelayDays => integer().withDefault(const Constant(1))();

  /// За сколько часов до начала смены ещё можно отменить запись.
  /// Добавлена во второй версии схемы — см. миграцию ниже.
  IntColumn get cancelDeadlineHours =>
      integer().withDefault(const Constant(10))();
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

  /// Один работник не может откликнуться на одну смену дважды.
  /// Это проверяет сама база — обойти нельзя.
  @override
  List<Set<Column>> get uniqueKeys => [
        {shiftId, workerId},
      ];
}

/// Статусы отклика. Архив — это не отдельная таблица, а другой статус.
class ApplicationStatus {
  ApplicationStatus._();

  static const active = 'active';
  static const cancelled = 'cancelled';
  static const completed = 'completed';
}

// ---------------------------------------------------------------------------
// БАЗА ДАННЫХ
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [ShiftRows, ApplicationRows])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _open());

  /// Открываем базу. На телефоне это файл в папке приложения,
  /// в браузере — хранилище самого браузера. Для браузера нужно указать,
  /// где лежат два служебных файла (они в папке `web/`).
  static QueryExecutor _open() => driftDatabase(
        name: 'fastwork',
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
      );

  /// Версия схемы. Мы добавили колонку — значит версия выросла с 1 до 2.
  @override
  int get schemaVersion => 2;

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
        },
        beforeOpen: (details) async {
          // Без этой строки SQLite не проверяет внешние ключи.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
