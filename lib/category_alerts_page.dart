import 'package:flutter/material.dart';

import 'package:fastwork_core/category.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'l10n/strings.dart';
import 'theme/app_colors.dart';
import 'widgets/async_state.dart';
import 'widgets/category_icon.dart';
import 'widgets/common.dart';
import 'widgets/skeleton.dart';

/// Подписки на виды работ: «сообщать о новых сменах грузчика».
///
/// Это «сохранённый поиск» конкурентов без лишнего. Город у человека один,
/// день неважен — важно, что появилась работа, которую он умеет делать.
/// Отметил «Грузчик» — новая смена грузчика в его городе придёт
/// уведомлением, и не надо каждое утро листать ленту.
class CategoryAlertsPage extends StatefulWidget {
  final ShiftRepository repository;

  /// Город человека — для подсказки, где искать.
  final String city;

  const CategoryAlertsPage({
    super.key,
    required this.repository,
    required this.city,
  });

  @override
  State<CategoryAlertsPage> createState() => _CategoryAlertsPageState();
}

class _CategoryAlertsPageState extends State<CategoryAlertsPage> {
  Async<Set<String>> state = const Loading();

  /// Переключатели, запрос по которым ещё идёт: второй раз не нажать.
  final Set<String> busy = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await load(widget.repository.followedCategories);
    if (!mounted) return;
    setState(() => state = result);
  }

  Future<void> _toggle(Set<String> followed, ShiftCategory category) async {
    final follow = !followed.contains(category.id);
    setState(() => busy.add(category.id));
    final done = await guardedDone(
      context,
      () => widget.repository.followCategory(category.id, follow: follow),
    );
    if (!mounted) return;
    setState(() {
      busy.remove(category.id);
      if (done) {
        state = Ready(follow
            ? {...followed, category.id}
            : ({...followed}..remove(category.id)));
      }
    });
    if (!done) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(follow
            ? tr.profile.alertsOnSnack(category.name)
            : tr.profile.alertsOffSnack(category.name)),
        behavior: SnackBarBehavior.floating,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr.profile.alertsTitle)),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: switch (state) {
          Loading() => const TileListSkeleton(count: 6),
          Failed(:final error) => ErrorView(
              message: describeError(error),
              onRetry: () {
                setState(() => state = const Loading());
                _load();
              },
            ),
          Ready(:final value) => ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                SurfaceCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active_outlined,
                          size: 18, color: AppColors.brand),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          tr.profile.alertsHint(tr.core.city(widget.city)),
                          style: const TextStyle(
                            fontSize: 12.5,
                            height: 1.35,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                for (final group in kCategoryGroups) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
                    child: Text(
                      tr.core.categoryGroup(group).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  SurfaceCard(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        for (final category in kShiftCategories
                            .where((c) => c.group == group))
                          SwitchListTile(
                            value: value.contains(category.id),
                            onChanged: busy.contains(category.id)
                                ? null
                                : (_) => _toggle(value, category),
                            secondary: Icon(categoryIcon(category.id),
                                color: AppColors.brand),
                            title: Text(
                              category.name,
                              style: const TextStyle(fontSize: 14.5),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
        },
      ),
    );
  }
}
