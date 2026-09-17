import 'package:flutter/material.dart';

void main() {
  runApp(const FastworkApp());
}

// ---------------------------------------------------------------------------
// ДАННЫЕ
// Пока это обычный класс на Dart. Базы данных тут ещё нет — список смен
// прописан руками ниже. Так проще: сначала увидим экран, потом подключим БД.
// ---------------------------------------------------------------------------

class Shift {
  final DateTime workDate; // в какой день смена
  final String title; // «Услуги грузчика»
  final String company; // «Заммлер Казахстан»
  final String address; // адрес точки
  final int startMinutes; // начало смены, минут от полуночи. 10:00 = 600
  final int endMinutes; // конец смены
  final int breakMinutes; // неоплачиваемый перерыв
  final int hourlyRate; // ставка за час, в тиынах (1100 ₸ = 110000)
  final int workersNeeded; // сколько человек нужно
  final int workersHired; // сколько уже набрано

  const Shift({
    required this.workDate,
    required this.title,
    required this.company,
    required this.address,
    required this.startMinutes,
    required this.endMinutes,
    required this.hourlyRate,
    required this.workersNeeded,
    required this.workersHired,
    this.breakMinutes = 60,
  });

  /// Сколько всего длится смена.
  /// Если конец «меньше» начала — значит смена ночная и переходит через
  /// полночь (18:00–06:00). Тогда считаем остаток суток плюс утро.
  int get durationMinutes => endMinutes > startMinutes
      ? endMinutes - startMinutes
      : (1440 - startMinutes) + endMinutes;

  /// Перерыв вычитается только если смена длится больше 5 часов.
  int get paidMinutes =>
      durationMinutes > 300 ? durationMinutes - breakMinutes : durationMinutes;

  /// Итоговая сумма за смену, в тиынах.
  int get totalPay => paidMinutes * hourlyRate ~/ 60;

  /// Есть ли ещё свободные места.
  bool get hasFreeSlots => workersHired < workersNeeded;
}

/// Выдуманные данные — те самые смены, что мы видели в прототипе.
///
/// Даты считаем от сегодняшнего дня, чтобы список всегда был актуальным.
/// Поэтому это функция, а не константа: `DateTime.now()` нельзя вычислить
/// заранее, на этапе компиляции.
List<Shift> buildDemoShifts() {
  final today = DateTime.now();
  DateTime day(int plus) => DateTime(today.year, today.month, today.day + plus);

  return [
    Shift(
      workDate: day(0),
      title: 'Услуги сотрудника склада',
      company: 'Золотое яблоко',
      address: 'г. Алматы, ул. Султана Бейбарыса, 1',
      startMinutes: 600, // 10:00
      endMinutes: 1320, // 22:00
      hourlyRate: 110000, // 1100 ₸
      workersNeeded: 5,
      workersHired: 2,
    ),
    Shift(
      workDate: day(0),
      title: 'Услуги работника торгового зала',
      company: 'Zara',
      address: 'г. Алматы, ул. Розыбакиева, 247А',
      startMinutes: 600,
      endMinutes: 1320,
      hourlyRate: 70000, // 700 ₸
      workersNeeded: 3,
      workersHired: 3, // мест нет
    ),
    Shift(
      workDate: day(1),
      title: 'Услуги грузчика (ночная смена)',
      company: 'Заммлер Казахстан',
      address: 'г. Шымкент, Орманшы ж/м, Енбекшинский район',
      startMinutes: 1080, // 18:00
      endMinutes: 360, // 06:00 следующего дня
      hourlyRate: 110000,
      workersNeeded: 10,
      workersHired: 4,
    ),
    Shift(
      workDate: day(1),
      title: 'Услуги курьера',
      company: 'Magnum',
      address: 'г. Алматы, пр. Абая, 109',
      startMinutes: 540, // 09:00
      endMinutes: 780, // 13:00 — короткая, без обеда
      hourlyRate: 90000, // 900 ₸
      workersNeeded: 4,
      workersHired: 1,
    ),
    Shift(
      workDate: day(3),
      title: 'Услуги промоутера',
      company: 'Sinsay',
      address: 'г. Шымкент, ТРЦ Mega Planet',
      startMinutes: 660, // 11:00
      endMinutes: 1140, // 19:00
      hourlyRate: 80000, // 800 ₸
      workersNeeded: 2,
      workersHired: 0,
    ),
  ];
}

/// Один ли это день? Время суток нас не интересует, только дата.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

// ---------------------------------------------------------------------------
// ФОРМАТИРОВАНИЕ
// ---------------------------------------------------------------------------

/// 1210000 тиын -> «12 100 ₸»
String formatMoney(int tiyn) {
  final tenge = tiyn ~/ 100;
  final digits = tenge.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(digits[i]);
  }
  return '$buffer ₸';
}

/// 600 -> «10:00»
String formatTime(int minutes) {
  final h = (minutes ~/ 60).toString().padLeft(2, '0');
  final m = (minutes % 60).toString().padLeft(2, '0');
  return '$h:$m';
}

// ---------------------------------------------------------------------------
// ЭКРАНЫ
// ---------------------------------------------------------------------------

class FastworkApp extends StatelessWidget {
  const FastworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fastwork',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
      ),
      home: const ShiftsPage(),
    );
  }
}

/// Главный экран: полоса дат сверху и список смен под ней.
class ShiftsPage extends StatefulWidget {
  const ShiftsPage({super.key});

  @override
  State<ShiftsPage> createState() => _ShiftsPageState();
}

class _ShiftsPageState extends State<ShiftsPage> {
  /// Все смены, какие есть. Загружаем один раз при открытии экрана.
  late final List<Shift> allShifts;

  /// Сегодняшняя дата без времени. Считаем один раз, чтобы она не «поехала»,
  /// если пользователь задержится в приложении до полуночи.
  late final DateTime today;

  /// Какой день выбран. 0 — сегодня, 1 — завтра и так далее.
  int selectedDay = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    allShifts = buildDemoShifts();
  }

  /// Дата, которая сейчас выбрана в полосе.
  DateTime dayAt(int index) =>
      DateTime(today.year, today.month, today.day + index);

  /// Смены только на выбранный день. Вот она — фильтрация.
  /// `where` оставляет из списка те элементы, для которых условие истинно.
  List<Shift> get visibleShifts => allShifts
      .where((shift) => isSameDay(shift.workDate, dayAt(selectedDay)))
      .toList();

  /// Есть ли смены в этот день. Нужно, чтобы приглушить пустые даты —
  /// ровно так же, как это сделано в прототипе.
  bool hasShiftsOn(DateTime date) =>
      allShifts.any((shift) => isSameDay(shift.workDate, date));

  @override
  Widget build(BuildContext context) {
    final shifts = visibleShifts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('fastwork'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _DateStrip(
            today: today,
            selectedDay: selectedDay,
            hasShiftsOn: hasShiftsOn,
            // Когда пользователь нажал на дату — запоминаем её и просим
            // Flutter перерисовать экран. Это и есть «состояние экрана».
            onDaySelected: (day) => setState(() => selectedDay = day),
          ),
          Expanded(
            child: shifts.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: shifts.length,
                    itemBuilder: (context, index) =>
                        _ShiftCard(shift: shifts[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Что показать, когда на выбранный день смен нет.
/// Пустой экран без объяснения выглядит как сломанное приложение.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy, size: 64, color: colors.outline),
          const SizedBox(height: 16),
          const Text(
            'На этот день смен нет',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Выберите другую дату',
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Горизонтальная полоса дат.
class _DateStrip extends StatelessWidget {
  final DateTime today;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;
  final bool Function(DateTime) hasShiftsOn;

  const _DateStrip({
    required this.today,
    required this.selectedDay,
    required this.onDaySelected,
    required this.hasShiftsOn,
  });

  static const _weekdays = ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 84,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 14,
        itemBuilder: (context, index) {
          final date = DateTime(today.year, today.month, today.day + index);
          final isSelected = index == selectedDay;
          final hasShifts = hasShiftsOn(date);

          // Цвет текста: выбранный день — белым, день без смен — бледным,
          // обычный — основным.
          final textColor = isSelected
              ? colors.onPrimary
              : hasShifts
                  ? colors.onSurface
                  : colors.onSurface.withValues(alpha: 0.35);

          return GestureDetector(
            onTap: () => onDaySelected(index),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primary
                    : colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekdays[date.weekday - 1],
                    style: TextStyle(fontSize: 12, color: textColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Карточка одной смены.
class _ShiftCard extends StatelessWidget {
  final Shift shift;

  const _ShiftCard({required this.shift});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatMoney(shift.totalPay),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _IconRow(
              icon: Icons.schedule,
              text: '${formatTime(shift.startMinutes)} — '
                  '${formatTime(shift.endMinutes)}',
            ),
            _IconRow(icon: Icons.work_outline, text: shift.title),
            _IconRow(
              icon: Icons.place_outlined,
              text: '${shift.company} • ${shift.address}',
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                // Если мест нет — кнопка неактивна. null вместо функции
                // означает «нажать нельзя», Flutter сам её приглушит.
                onPressed: shift.hasFreeSlots ? () {} : null,
                child: Text(
                  shift.hasFreeSlots
                      ? 'Подробнее'
                      : 'Мест нет',
                ),
              ),
            ),
            if (shift.hasFreeSlots) ...[
              const SizedBox(height: 6),
              Text(
                'Осталось мест: ${shift.workersNeeded - shift.workersHired}',
                style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IconRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: colors.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
