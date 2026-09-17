import 'package:flutter/material.dart';

import 'data/session.dart';
import 'data/shift_repository.dart';
import 'shift.dart';
import 'shift_detail_page.dart';
import 'theme/app_colors.dart';
import 'widgets/common.dart';
import 'widgets/shift_card.dart';

/// «Мои подработки»: две вкладки над одними и теми же данными.
///
/// Архив — это не отдельная таблица и не отдельный список.
/// Это тот же запрос к той же таблице, только с другим условием.
class MyShiftsPage extends StatefulWidget {
  final ShiftRepository repository;
  final AppSession session;

  const MyShiftsPage({
    super.key,
    required this.repository,
    required this.session,
  });

  @override
  State<MyShiftsPage> createState() => _MyShiftsPageState();
}

class _MyShiftsPageState extends State<MyShiftsPage> {
  bool archived = false;
  List<Shift>? shifts;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await widget.repository.myShifts(archived: archived);
    if (!mounted) return;
    setState(() => shifts = loaded);
  }

  void _switchTab(bool value) {
    setState(() {
      archived = value;
      shifts = null;
    });
    _load();
  }

  Future<void> _openShift(Shift shift) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShiftDetailPage(
          shiftId: shift.id,
          repository: widget.repository,
          session: widget.session,
        ),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final list = shifts;

    return Scaffold(
      appBar: AppBar(title: const Text('Мои подработки')),
      body: Column(
        children: [
          _Tabs(archived: archived, onChanged: _switchTab),
          Expanded(
            child: switch (list) {
              null => const Center(child: CircularProgressIndicator()),
              [] => EmptyState(
                  icon: archived
                      ? Icons.inventory_2_outlined
                      : Icons.assignment_outlined,
                  title: 'Пока пусто',
                  subtitle: archived
                      ? 'Сюда попадут завершённые\nи отменённые подработки'
                      : 'Найдите смену на вкладке «Смены»\nи оставьте заявку',
                ),
              final items => ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) => ShiftCard(
                    shift: items[index],
                    userRating: widget.session.rating,
                    onTap: () => _openShift(items[index]),
                  ),
                ),
            },
          ),
        ],
      ),
    );
  }
}

/// Переключатель «В работе / Архив».
class _Tabs extends StatelessWidget {
  final bool archived;
  final ValueChanged<bool> onChanged;

  const _Tabs({required this.archived, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          _TabButton(
            label: 'В работе',
            selected: !archived,
            onTap: () => onChanged(false),
          ),
          _TabButton(
            label: 'Архив',
            selected: archived,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.brand : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}
