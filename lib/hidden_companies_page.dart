import 'package:flutter/material.dart';

import 'package:fastwork_core/data/shift_repository.dart';
import 'l10n/strings.dart';
import 'theme/app_colors.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';
import 'widgets/skeleton.dart';

/// Компании, скрытые из ленты, — чтобы вернуть передумавшему.
///
/// Без этого экрана скрытую компанию было бы не найти: её смен нет в
/// ленте, значит, и до её страницы не дойти.
class HiddenCompaniesPage extends StatefulWidget {
  final ShiftRepository repository;

  const HiddenCompaniesPage({super.key, required this.repository});

  @override
  State<HiddenCompaniesPage> createState() => _HiddenCompaniesPageState();
}

class _HiddenCompaniesPageState extends State<HiddenCompaniesPage> {
  Async<List<String>> state = const Loading();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await load(
      () async => (await widget.repository.hiddenCompanies()).toList()..sort(),
    );
    if (!mounted) return;
    setState(() => state = result);
  }

  Future<void> _show(String company) async {
    final done = await guardedDone(
      context,
      () => widget.repository.hideCompany(company, hide: false),
    );
    if (!mounted || !done) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(tr.feed.companyShownSnack(company)),
      behavior: SnackBarBehavior.floating,
    ));
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr.profile.hiddenCompaniesTitle)),
      body: switch (state) {
        Loading() => const TileListSkeleton(count: 2),
        Failed(:final error) =>
          ErrorView(message: describeError(error), onRetry: _load),
        Ready(value: []) => EmptyState(
            icon: Icons.visibility_outlined,
            title: tr.profile.hiddenCompaniesTitle,
            subtitle: tr.profile.hiddenCompaniesEmpty,
          ),
        Ready(:final value) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              for (final company in value)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SurfaceCard(
                    padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
                    child: Row(
                      children: [
                        const Icon(Icons.storefront_outlined,
                            color: AppColors.muted),
                        const SizedBox(width: 12),
                        Expanded(child: Text(company)),
                        TextButton(
                          onPressed: () => _show(company),
                          child: Text(tr.profile.showAgain),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
      },
    );
  }
}
