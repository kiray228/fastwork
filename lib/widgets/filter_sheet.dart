import 'package:flutter/material.dart';

import 'package:fastwork_core/category.dart';
import 'package:fastwork_core/data/shift_filter.dart';
import '../theme/app_colors.dart';
import 'category_icon.dart';

/// Окно фильтра и сортировки ленты.
/// Возвращает новый фильтр или null, если пользователь ничего не менял.
Future<ShiftFilter?> showFilterSheet(
  BuildContext context, {
  required ShiftFilter current,
  required List<String> companies,
  List<String> categories = const [],
}) {
  return showModalBottomSheet<ShiftFilter>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FilterSheet(
      current: current,
      companies: companies,
      categories: categories,
    ),
  );
}

class _FilterSheet extends StatefulWidget {
  final ShiftFilter current;
  final List<String> companies;

  /// Ключи категорий, по которым сейчас есть смены.
  final List<String> categories;

  const _FilterSheet({
    required this.current,
    required this.companies,
    required this.categories,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late ShiftFilter draft = widget.current;

  void _toggleCompany(String name) {
    final next = {...draft.companies};
    // Уже выбрана — убираем, нет — добавляем.
    next.contains(name) ? next.remove(name) : next.add(name);
    setState(() => draft = draft.copyWith(companies: next));
  }

  void _toggleCategory(String id) {
    final next = {...draft.categories};
    next.contains(id) ? next.remove(id) : next.add(id);
    setState(() => draft = draft.copyWith(categories: next));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    // Material, а не Container с цветом: списочные элементы вроде
    // RadioListTile рисуют подсветку нажатия на ближайшем Material.
    // Если его нет, Flutter честно предупреждает, что эффекты не видны.
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
              padding: const EdgeInsets.fromLTRB(20, 0, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Фильтр',
                      style: text.headlineSmall?.copyWith(fontSize: 21),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        setState(() => draft = const ShiftFilter()),
                    child: const Text('Очистить'),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                children: [
                  if (widget.categories.isNotEmpty) ...[
                    Text('Категории', style: text.titleMedium),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final id in widget.categories)
                          _Choice(
                            label: categoryById(id).name,
                            icon: categoryIcon(id),
                            selected: draft.categories.contains(id),
                            onTap: () => _toggleCategory(id),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                  ],
                  if (widget.companies.isNotEmpty) ...[
                    Text('Компании', style: text.titleMedium),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final name in widget.companies)
                          _Choice(
                            label: name,
                            selected: draft.companies.contains(name),
                            onTap: () => _toggleCompany(name),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                  ],
                  Text('Сортировка', style: text.titleMedium),
                  const SizedBox(height: 10),
                  // RadioGroup хранит выбранное значение за все кнопки сразу —
                  // поэтому каждая из них знает только своё значение.
                  RadioGroup<ShiftSort>(
                    groupValue: draft.sort,
                    onChanged: (v) =>
                        setState(() => draft = draft.copyWith(sort: v)),
                    child: Column(
                      children: [
                        for (final sort in ShiftSort.values)
                          RadioListTile<ShiftSort>(
                            value: sort,
                            activeColor: AppColors.brand,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              sort.label,
                              style: text.bodyLarge?.copyWith(fontSize: 14.5),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    value: draft.onlyOpen,
                    onChanged: (v) =>
                        setState(() => draft = draft.copyWith(onlyOpen: v)),
                    activeThumbColor: AppColors.brand,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Только со свободными местами',
                      style: text.bodyLarge?.copyWith(fontSize: 14.5),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(draft),
                    child: const Text('Показать результаты'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.brand
              : (isDark ? AppColors.darkBorder : AppColors.bg),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.brand
                : (isDark ? AppColors.darkBorder : AppColors.border),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              const Icon(Icons.check_rounded, size: 15, color: Colors.white),
              const SizedBox(width: 6),
            ] else if (icon != null) ...[
              Icon(icon, size: 15, color: AppColors.brand),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: selected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
