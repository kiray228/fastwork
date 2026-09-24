import 'package:flutter/material.dart';

import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/mrp.dart';
import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/shift.dart';
import 'stories/story.dart';
import 'stories/story_actions.dart';
import 'theme/app_colors.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';
import 'widgets/payment_sheet.dart';
import 'widgets/skeleton.dart';

/// Кошелёк исполнителя и платежи заказчика — один экран на обоих.
///
/// Раньше здесь была витрина: суммы считались по сменам, а кнопка вывода
/// честно говорила «не подключено». Теперь за экраном настоящий журнал
/// движений денег: начисления приходят, когда заказчик подтверждает
/// выход, а вывод на карту уходит через платёжный шлюз.
///
/// Заказчику тот же журнал показывает другую сторону: оплаты смен,
/// доплаты и возвраты.
class WalletPage extends StatefulWidget {
  final ShiftRepository repository;
  final WalletRepository wallet;
  final bool isManager;

  const WalletPage({
    super.key,
    required this.repository,
    required this.wallet,
    this.isManager = false,
  });

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Async<WalletSummary> state = const Loading();

  /// Лимит месяца. Грузится отдельно: не узнали его — кошелёк всё равно
  /// покажет деньги, просто без полоски.
  EarningsLimit? limit;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await load(widget.wallet.summary);
    if (!mounted) return;
    setState(() => state = result);

    if (widget.isManager) return;
    try {
      final loaded = await widget.repository.earningsLimit(DateTime.now());
      if (mounted) setState(() => limit = loaded);
    } catch (_) {
      // Без лимита кошелёк всё равно полезен.
    }
  }

  /// Вывести весь баланс на карту.
  ///
  /// Весь, а не произвольную сумму: так проще и человеку, и нам — поле
  /// для суммы добавим, когда кто-то попросит вывести половину.
  Future<void> _withdraw(int balance) async {
    final done = await showPaymentSheet(
      context,
      title: 'Вывод на карту',
      note: 'Переведём весь баланс. Комиссии за вывод нет.',
      lines: [PaymentLine('Доступно к выводу', balance)],
      total: balance,
      actionLabel: 'Вывести ${formatMoney(balance)}',
      onCard: (card) => widget.wallet.withdraw(amount: balance, card: card),
    );
    if (!done || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Деньги отправлены на карту')),
    );
    setState(() => state = const Loading());
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isManager ? 'Платежи' : 'Выплаты';

    if (state case Failed(:final error)) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ErrorView(
          message: describeError(error),
          onRetry: () {
            setState(() => state = const Loading());
            _load();
          },
        ),
      );
    }

    final summary = switch (state) {
      Ready(:final value) => value,
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: summary == null
          ? const TileListSkeleton(count: 3)
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                if (widget.isManager)
                  const _EscrowExplainer()
                else
                  _BalanceCard(
                    summary: summary,
                    onWithdraw: summary.balance >= kMinWithdrawal
                        ? () => _withdraw(summary.balance)
                        : null,
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: HelpLink(
                    label: widget.isManager
                        ? 'Как устроена оплата смен'
                        : 'Как работают выплаты',
                    onTap: () => openHelpStory(
                      context,
                      widget.isManager ? 'm.pay' : 'payouts',
                    ),
                  ),
                ),
                if (summary.sandbox) ...[
                  const SizedBox(height: 14),
                  const _SandboxNotice(),
                ],
                if (limit != null) ...[
                  const SizedBox(height: 14),
                  EarningsLimitCard(limit: limit!),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: HelpLink(
                      label: 'Что такое лимит $kEarningsLimitMrp МРП',
                      onTap: () => openHelpStory(
                        context,
                        'limit',
                        data: StoryData(
                          loadLimit: limitLoader(widget.repository),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        icon: Icons.receipt_long_outlined,
                        title: 'История',
                      ),
                      const SizedBox(height: 14),
                      if (summary.entries.isEmpty)
                        Text(
                          widget.isManager
                              ? 'Платежей пока нет. Они появятся, когда вы '
                                  'оплатите первую смену.'
                              : 'Пока начислений нет. Они появятся, когда '
                                  'заказчик подтвердит вашу первую смену.',
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: AppColors.muted,
                            height: 1.4,
                          ),
                        )
                      else
                        for (final entry in summary.entries)
                          _EntryRow(entry: entry),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final WalletSummary summary;
  final VoidCallback? onWithdraw;

  const _BalanceCard({required this.summary, required this.onWithdraw});

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
                  'Доступно к выводу',
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
                    value: summary.balance,
                    format: formatMoney,
                    style: text.displaySmall
                        ?.copyWith(fontSize: 38, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Заработано всего: ${formatMoney(summary.earnedTotal)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onWithdraw,
                    child: const Text('Вывести на карту'),
                  ),
                ),
                if (onWithdraw == null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Вывести можно от ${formatMoney(kMinWithdrawal)}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Как устроена гарантия — для заказчика.
class _EscrowExplainer extends StatelessWidget {
  const _EscrowExplainer();

  @override
  Widget build(BuildContext context) {
    return const SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.verified_user_outlined,
            title: 'Сервис — гарант оплаты',
          ),
          SizedBox(height: 10),
          InfoRow(
            icon: Icons.lock_outline_rounded,
            text: 'Вы оплачиваете смену при публикации — деньги держит '
                'сервис.',
          ),
          InfoRow(
            icon: Icons.how_to_reg_outlined,
            text: 'Исполнитель получает их, когда вы подтвердите его выход.',
          ),
          InfoRow(
            icon: Icons.undo_rounded,
            text: 'За невыход и при отмене смены деньги возвращаются '
                'на карту.',
          ),
          InfoRow(
            icon: Icons.percent_rounded,
            text: 'Комиссия сервиса — $kPlatformFeePercent% сверх '
                'вознаграждения.',
          ),
        ],
      ),
    );
  }
}

/// Честно предупреждаем, что деньги пока ненастоящие.
class _SandboxNotice extends StatelessWidget {
  const _SandboxNotice();

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
          const Icon(Icons.science_outlined, size: 18, color: AppColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Тестовый режим оплаты: карты тестовые, деньги ненастоящие. '
              'Правила удержания, начисления и возврата — настоящие.',
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

class _EntryRow extends StatelessWidget {
  final WalletEntry entry;

  const _EntryRow({required this.entry});

  IconData get _icon => switch (entry.kind) {
        WalletEntryKind.earning => Icons.work_history_rounded,
        WalletEntryKind.withdrawal => Icons.north_east_rounded,
        WalletEntryKind.charge => Icons.credit_card_rounded,
        WalletEntryKind.refund => Icons.undo_rounded,
        _ => Icons.swap_horiz_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final incoming = entry.amount > 0;
    final color = incoming ? AppColors.brand : AppColors.muted;
    final date = entry.createdAt;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  '${date.day} ${monthsShort[date.month - 1]}',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Text(
            '${incoming ? '+' : '−'}${formatMoney(entry.amount.abs())}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: incoming
                  ? AppColors.brand
                  : Theme.of(context).colorScheme.onSurface,
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
