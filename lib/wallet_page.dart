import 'package:flutter/material.dart';

import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/mrp.dart';
import 'package:fastwork_core/shift.dart';
import 'theme/app_colors.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';
import 'widgets/skeleton.dart';

/// Кошелёк — витрина.
///
/// Экран показывает начисления по отработанным сменам, но **никаких
/// операций не проводит**: ни вывода, ни переводов. Настоящие деньги
/// требуют платёжного провайдера, юрлица и лицензий — это отдельный
/// большой проект, и к обучению программированию он отношения не имеет.
///
/// Суммы здесь тоже вычисляются из смен, а не хранятся отдельно.
class WalletPage extends StatefulWidget {
  final ShiftRepository repository;

  const WalletPage({super.key, required this.repository});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Async<List<Shift>> state = const Loading();

  /// Лимит месяца. Грузится отдельно: не узнали его — кошелёк всё равно
  /// покажет начисления, просто без полоски.
  EarningsLimit? limit;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await load(widget.repository.completedShifts);
    if (!mounted) return;
    setState(() => state = result);

    try {
      final loaded = await widget.repository.earningsLimit(DateTime.now());
      if (mounted) setState(() => limit = loaded);
    } catch (_) {
      // Без лимита кошелёк всё равно полезен.
    }
  }

  void _notImplemented() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Вывод средств пока не подключён'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (state case Failed(:final error)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Выплаты')),
        body: ErrorView(
          message: describeError(error),
          onRetry: () {
            setState(() => state = const Loading());
            _load();
          },
        ),
      );
    }

    final list = switch (state) {
      Ready(:final value) => value,
      _ => null,
    };
    final total = list == null
        ? 0
        : list.fold<int>(0, (sum, shift) => sum + shift.totalPay);

    return Scaffold(
      appBar: AppBar(title: const Text('Выплаты')),
      body: list == null
          ? const TileListSkeleton(count: 3)
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                _BalanceCard(total: total, onWithdraw: _notImplemented),
                if (limit != null) ...[
                  const SizedBox(height: 14),
                  EarningsLimitCard(limit: limit!),
                ],
                const SizedBox(height: 14),
                const _DemoNotice(),
                const SizedBox(height: 14),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        icon: Icons.receipt_long_outlined,
                        title: 'История начислений',
                      ),
                      const SizedBox(height: 14),
                      if (list.isEmpty)
                        const Text(
                          'Пока начислений нет. Они появятся после '
                          'первой отработанной смены.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: AppColors.muted,
                            height: 1.4,
                          ),
                        )
                      else
                        for (final shift in list) _EarningRow(shift: shift),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final int total;
  final VoidCallback onWithdraw;

  const _BalanceCard({required this.total, required this.onWithdraw});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.brand, AppColors.brandDark],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Заработано всего',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  // Сумма не появляется готовой, а докручивается от нуля:
                  // так виден результат работы, а не просто число.
                  child: AnimatedNumber(
                    value: total,
                    format: formatMoney,
                    style: text.displaySmall
                        ?.copyWith(fontSize: 38, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: onWithdraw,
                    child: const Text('Вывести на карту'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Честно предупреждаем, что раздел показательный.
class _DemoNotice extends StatelessWidget {
  const _DemoNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 18, color: AppColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Раздел показательный: суммы считаются по вашим сменам, '
              'но операций с деньгами приложение не проводит.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 12.5, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _EarningRow extends StatelessWidget {
  final Shift shift;

  const _EarningRow({required this.shift});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          CompanyAvatar(company: shift.company, size: 38),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shift.company,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  '${shift.workDate.day} '
                  '${monthsShort[shift.workDate.month - 1]} · '
                  '${formatDuration(shift.paidMinutes)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Text(
            '+${formatMoney(shift.totalPay)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.brand,
            ),
          ),
        ],
      ),
    );
  }
}

/// Сколько осталось до лимита в 300 МРП за месяц.
///
/// Показываем заранее, а не только отказом при записи: человек, который
/// видит «осталось 40 000 ₸», сам не станет записываться на смену за
/// 60 000 — и не наткнётся на отказ в последний момент.
class EarningsLimitCard extends StatelessWidget {
  final EarningsLimit limit;

  const EarningsLimitCard({super.key, required this.limit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nearlyFull = limit.fraction >= 0.85;
    final color = nearlyFull ? AppColors.accent : AppColors.brand;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.account_balance_rounded,
            title: 'Лимит за ${formatMonth(limit.month)}',
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  formatMoney(limit.used),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'из ${formatMoney(limit.limit)}',
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: limit.fraction,
              minHeight: 8,
              backgroundColor: isDark ? AppColors.darkBorder : AppColors.border,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Осталось ${formatMoney(limit.remaining)}. '
            'Лимит — $kEarningsLimitMrp МРП, один МРП в этом году '
            '${formatMoney(limit.mrp)}. В счёт идут и отработанные смены, '
            'и те, на которые вы записаны.',
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.muted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
