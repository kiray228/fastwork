import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fastwork_core/category.dart';

import '../data/session.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/shift.dart';
import '../theme/app_colors.dart';
import '../widgets/async_state.dart';
import '../widgets/category_icon.dart';
import '../widgets/common.dart';

/// Создание смены заказчиком — и правка уже созданной.
///
/// Один экран на две задачи, а не два похожих.
///
/// Форма здесь не «поля на экране»: в ней живут проверки — ставка не ниже
/// ста тенге, смена не короче часа, адрес не пустой. Сделай мы второй
/// экран для правки, эти проверки пришлось бы повторить, и однажды они
/// разошлись бы: поправили в одном месте, забыли в другом. Тогда через
/// создание пройти было бы нельзя, а через правку — можно.
class CreateShiftPage extends StatefulWidget {
  final AppSession session;
  final ShiftRepository repository;
  final VoidCallback onCreated;

  /// Смена, которую правим. `null` — создаём новую.
  final Shift? editing;

  const CreateShiftPage({
    super.key,
    required this.session,
    required this.repository,
    required this.onCreated,
    this.editing,
  });

  @override
  State<CreateShiftPage> createState() => _CreateShiftPageState();
}

class _CreateShiftPageState extends State<CreateShiftPage> {
  late final TextEditingController titleController;
  late final TextEditingController addressController;
  late final TextEditingController rateController;
  late final TextEditingController workersController;
  late final TextEditingController dutiesController;

  late DateTime date;
  late TimeOfDay start;
  late TimeOfDay end;

  /// Категория работ. У новой смены её нет, пока заказчик не выберет:
  /// подставить «что-нибудь» по умолчанию значило бы, что половина смен
  /// окажется «грузчиками» просто потому, что до списка не долистали.
  String? category;
  bool busy = false;
  String? error;

  /// Правим уже существующую смену, а не заводим новую.
  bool get isEditing => widget.editing != null;

  @override
  void initState() {
    super.initState();
    final shift = widget.editing;

    titleController = TextEditingController(text: shift?.title ?? 'Услуги ');
    addressController = TextEditingController(text: shift?.address ?? '');
    rateController = TextEditingController(
      text: shift == null ? '1100' : '${shift.hourlyRate ~/ 100}',
    );
    workersController = TextEditingController(
      text: '${shift?.workersNeeded ?? 3}',
    );
    dutiesController = TextEditingController(
      text: shift?.duties.join('\n') ?? '',
    );

    date = shift?.workDate ?? DateTime.now().add(const Duration(days: 1));
    start = _asTime(shift?.startMinutes ?? 600);
    end = _asTime(shift?.endMinutes ?? 1320);
    category = shift?.category;
  }

  static TimeOfDay _asTime(int minutes) =>
      TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

  @override
  void dispose() {
    titleController.dispose();
    addressController.dispose();
    rateController.dispose();
    workersController.dispose();
    dutiesController.dispose();
    super.dispose();
  }

  int get _startMinutes => start.hour * 60 + start.minute;
  int get _endMinutes => end.hour * 60 + end.minute;

  /// Считаем сумму теми же формулами, что и на экране исполнителя —
  /// заказчик сразу видит, во сколько ему обойдётся смена.
  Shift get _preview => Shift(
        id: 0,
        workDate: date,
        title: titleController.text,
        company: widget.session.user?.company ?? 'Компания',
        address: addressController.text,
        startMinutes: _startMinutes,
        endMinutes: _endMinutes,
        category: category ?? kOtherCategory,
        hourlyRate: (int.tryParse(rateController.text) ?? 0) * 100,
        workersNeeded: int.tryParse(workersController.text) ?? 1,
        workersHired: widget.editing?.workersHired ?? 0,
      );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      // При правке смена может быть уже на сегодня или даже на вчера —
      // тогда её собственный день обязан остаться выбираемым, иначе
      // календарь откажется открыться.
      firstDate: date.isBefore(DateTime.now()) ? date : DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => date = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? start : end,
    );
    if (picked == null) return;
    setState(() => isStart ? start = picked : end = picked);
  }

  Future<void> _pickCategory() async {
    final picked = await showCategorySheet(context, selected: category);
    if (picked == null || !mounted) return;
    setState(() {
      category = picked;
      error = null;
    });
  }

  Future<void> _submit() async {
    final title = titleController.text.trim();
    final address = addressController.text.trim();
    final rate = int.tryParse(rateController.text) ?? 0;
    final workers = int.tryParse(workersController.text) ?? 0;

    if (title.length < 5) {
      setState(() => error = 'Опишите, какие услуги нужны');
      return;
    }
    if (address.isEmpty) {
      setState(() => error = 'Укажите адрес');
      return;
    }
    if (rate < 100) {
      setState(() => error = 'Ставка должна быть не меньше 100 ₸ в час');
      return;
    }
    if (workers < 1) {
      setState(() => error = 'Нужен хотя бы один человек');
      return;
    }
    if (_preview.durationMinutes < 60) {
      setState(() => error = 'Смена должна длиться хотя бы час');
      return;
    }
    final chosen = category;
    if (chosen == null) {
      setState(() => error = 'Выберите категорию работ');
      return;
    }

    setState(() {
      busy = true;
      error = null;
    });

    final duties = dutiesController.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final existing = widget.editing;
    if (existing != null) {
      final result = await guarded(
        context,
        () => widget.repository.updateShift(
          shiftId: existing.id,
          workDate: DateTime(date.year, date.month, date.day),
          title: title,
          category: chosen,
          address: address,
          startMinutes: _startMinutes,
          endMinutes: _endMinutes,
          hourlyRate: rate * 100,
          workersNeeded: workers,
          duties: duties,
          dressCode: existing.dressCode,
        ),
      );

      if (!mounted) return;
      setState(() => busy = false);
      if (result == null) return;

      if (result != BookingResult.ok) {
        setState(() => error = switch (result) {
              BookingResult.fewerThanHired =>
                'Уже набрано ${existing.workersHired} чел. — '
                    'мест не может быть меньше',
              BookingResult.notMine => 'Это не ваша смена',
              BookingResult.alreadyCancelled => 'Смена отменена',
              _ => 'Не получилось сохранить',
            });
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Изменения сохранены')),
      );
      widget.onCreated();
      return;
    }

    final created = await guardedDone(
      context,
      () => widget.repository.createShift(
        workDate: DateTime(date.year, date.month, date.day),
        title: title,
        company: widget.session.user?.company ?? 'Компания',
        address: address,
        startMinutes: _startMinutes,
        endMinutes: _endMinutes,
        hourlyRate: rate * 100, // в тиынах
        workersNeeded: workers,
        createdBy: widget.session.workerId,
        // Город берём из профиля заказчика: смену увидят исполнители
        // того же города.
        city: widget.session.city,
        category: chosen,
        duties: duties,
      ),
    );

    if (!mounted) return;
    setState(() => busy = false);
    if (!created) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Смена опубликована')),
    );
    widget.onCreated();
  }

  @override
  Widget build(BuildContext context) {
    final preview = _preview;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Изменить смену' : 'Новая смена'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Label('Категория работ'),
                _CategoryPicker(
                  category: category,
                  onTap: _pickCategory,
                ),
                const SizedBox(height: 14),
                _Label('Какие услуги нужны'),
                _Input(
                  controller: titleController,
                  hint: 'Услуги сотрудника склада',
                  onChanged: (_) => setState(() => error = null),
                ),
                const SizedBox(height: 14),
                _Label('Адрес'),
                _Input(
                  controller: addressController,
                  hint: 'г. Алматы, ул. Абая, 10',
                  onChanged: (_) => setState(() => error = null),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  icon: Icons.schedule_rounded,
                  title: 'Когда',
                ),
                const SizedBox(height: 12),
                _PickerRow(
                  label: 'Дата',
                  value: '${date.day} ${monthsShort[date.month - 1]}, '
                      '${weekdaysShort[date.weekday - 1]}',
                  onTap: _pickDate,
                ),
                _PickerRow(
                  label: 'Начало',
                  value: formatTime(_startMinutes),
                  onTap: () => _pickTime(isStart: true),
                ),
                _PickerRow(
                  label: 'Конец',
                  value: formatTime(_endMinutes),
                  onTap: () => _pickTime(isStart: false),
                ),
                if (preview.crossesMidnight)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: TagChip(
                      text: 'Ночная смена — закончится на следующий день',
                      icon: Icons.nightlight_round,
                      color: AppColors.accent,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  icon: Icons.payments_outlined,
                  title: 'Оплата и люди',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Label('Ставка, ₸/час'),
                          _Input(
                            controller: rateController,
                            hint: '1100',
                            keyboardType: TextInputType.number,
                            formatters: [FilteringTextInputFormatter.digitsOnly],
                            onChanged: (_) => setState(() => error = null),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Label('Человек'),
                          _Input(
                            controller: workersController,
                            hint: '3',
                            keyboardType: TextInputType.number,
                            formatters: [FilteringTextInputFormatter.digitsOnly],
                            onChanged: (_) => setState(() => error = null),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _Summary(shift: preview),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  icon: Icons.checklist_rounded,
                  title: 'Обязанности',
                ),
                const SizedBox(height: 10),
                const Text(
                  'По одному пункту в строке',
                  style: TextStyle(fontSize: 12.5, color: AppColors.muted),
                ),
                const SizedBox(height: 8),
                _Input(
                  controller: dutiesController,
                  hint: 'Разгружать машины\nСортировать товар',
                  maxLines: 4,
                ),
              ],
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 18, color: AppColors.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    error!,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: busy ? null : _submit,
            child: busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(isEditing ? 'Сохранить' : 'Опубликовать смену'),
          ),
        ],
      ),
    );
  }
}

/// Сводка: сколько выйдет за смену и за всех людей.
class _Summary extends StatelessWidget {
  final Shift shift;

  const _Summary({required this.shift});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBorder.withValues(alpha: 0.5)
            : AppColors.brandSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Длительность',
            value: formatDuration(shift.durationMinutes),
          ),
          if (shift.hasUnpaidBreak)
            _SummaryRow(
              label: 'Оплачивается',
              value: formatDuration(shift.paidMinutes),
            ),
          _SummaryRow(
            label: 'Одному человеку',
            value: formatMoney(shift.totalPay),
          ),
          _SummaryRow(
            label: 'За всю смену',
            value: formatMoney(shift.totalPay * shift.workersNeeded),
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 15 : 13.5,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
              color: bold ? AppColors.brandDark : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: AppColors.muted,
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const _Input({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.formatters,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        filled: true,
        fillColor: isDark ? AppColors.darkBg : AppColors.bg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brand, width: 1.6),
        ),
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _PickerRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, color: AppColors.muted),
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

/// Поле выбора категории: выглядит как строка формы, открывает список.
class _CategoryPicker extends StatelessWidget {
  final String? category;
  final VoidCallback onTap;

  const _CategoryPicker({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chosen = category;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBg : AppColors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              chosen == null
                  ? Icons.category_outlined
                  : categoryIcon(chosen),
              size: 20,
              color: chosen == null ? AppColors.muted : AppColors.brand,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                chosen == null
                    ? 'Выберите категорию'
                    : categoryById(chosen).name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: chosen == null ? AppColors.muted : null,
                ),
              ),
            ),
            const Icon(Icons.expand_more_rounded,
                size: 20, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

/// Список категорий с поиском.
///
/// Сорок пунктов — это уже не список, который читают, а список, в котором
/// ищут. Поэтому сверху поле: набрал «сант» — остался «Сантехник».
Future<String?> showCategorySheet(BuildContext context, {String? selected}) =>
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CategorySheet(selected: selected),
    );

class _CategorySheet extends StatefulWidget {
  final String? selected;

  const _CategorySheet({required this.selected});

  @override
  State<_CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends State<_CategorySheet> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final q = query.trim().toLowerCase();
    final found = kShiftCategories
        .where((c) => q.isEmpty || c.name.toLowerCase().contains(q))
        .toList();

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.muted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: TextField(
                autofocus: false,
                onChanged: (value) => setState(() => query = value),
                decoration: const InputDecoration(
                  hintText: 'Найти категорию',
                  prefixIcon: Icon(Icons.search_rounded, size: 20),
                  isDense: true,
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                children: [
                  for (final group in kCategoryGroups)
                    if (found.any((c) => c.group == group)) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 14, 12, 4),
                        child: Text(
                          group.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                      for (final c in found.where((c) => c.group == group))
                        ListTile(
                          dense: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          leading: Icon(categoryIcon(c.id),
                              color: AppColors.brand),
                          title: Text(
                            c.name,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: c.id == widget.selected
                              ? const Icon(Icons.check_rounded,
                                  color: AppColors.brand)
                              : null,
                          onTap: () => Navigator.of(context).pop(c.id),
                        ),
                    ],
                  if (found.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Такой категории нет — выберите «Другое»',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
