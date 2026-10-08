import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/user.dart';
import 'l10n/strings.dart';
import 'theme/app_colors.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';
import 'widgets/skeleton.dart';

/// Справка о заработке за месяц.
///
/// Подработку не всегда видно в банке: деньги приходят разными суммами
/// от разных заказчиков. А подтвердить доход нужно то для кредита, то для
/// аренды, то просто для себя — сколько вышло за месяц. Здесь всё в одном
/// месте: какие смены, где, сколько часов и денег, и итог. Справку можно
/// скопировать одним касанием и отправить в письме или чате.
///
/// В справку идут только смены, которые заказчик подтвердил: именно за
/// них начислены деньги.
class EarningsStatementPage extends StatefulWidget {
  final ShiftRepository repository;
  final AppUser user;

  /// Какой месяц открыть. Не передали — текущий.
  final DateTime? month;

  const EarningsStatementPage({
    super.key,
    required this.repository,
    required this.user,
    this.month,
  });

  @override
  State<EarningsStatementPage> createState() => _EarningsStatementPageState();
}

class _EarningsStatementPageState extends State<EarningsStatementPage> {
  Async<List<Shift>> state = const Loading();
  late DateTime month = _monthOf(widget.month ?? DateTime.now());

  static DateTime _monthOf(DateTime date) => DateTime(date.year, date.month);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await load(widget.repository.completedShifts);
    if (!mounted) return;
    setState(() => state = result);
  }

  bool get _isCurrentMonth => month == _monthOf(DateTime.now());

  void _shift(int months) =>
      setState(() => month = DateTime(month.year, month.month + months));

  Future<void> _copy(List<Shift> shifts) async {
    await Clipboard.setData(ClipboardData(
      text: statementText(widget.user, month, shifts),
    ));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(tr.wallet.statementCopied),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr.wallet.statementTitle)),
      body: switch (state) {
        Loading() => const TileListSkeleton(count: 4),
        Failed(:final error) => ErrorView(
            message: describeError(error),
            onRetry: () {
              setState(() => state = const Loading());
              _load();
            },
          ),
        Ready(:final value) => _body(shiftsInMonth(value, month)),
      },
    );
  }

  Widget _body(List<Shift> shifts) {
    final minutes = shifts.fold(0, (sum, s) => sum + s.paidMinutes);
    final earned = shifts.fold(0, (sum, s) => sum + s.totalPay);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => _shift(-1),
              tooltip: tr.wallet.statementPrevMonth,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Expanded(
              child: Text(
                _capitalized(tr.core.monthYear(month)),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 17),
              ),
            ),
            IconButton(
              onPressed: _isCurrentMonth ? null : () => _shift(1),
              tooltip: tr.wallet.statementNextMonth,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _Total(
              value: '${shifts.length}',
              caption: tr.wallet.statementShifts,
            ),
            const SizedBox(width: 10),
            _Total(
              value: formatDuration(minutes),
              caption: tr.wallet.statementHours,
            ),
            const SizedBox(width: 10),
            _Total(
              value: formatMoney(earned),
              caption: tr.wallet.statementEarned,
              accent: true,
            ),
          ],
        ),
        const SizedBox(height: 14),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                icon: Icons.receipt_long_outlined,
                title: tr.wallet.statementShiftsTitle,
              ),
              const SizedBox(height: 12),
              if (shifts.isEmpty)
                Text(
                  tr.wallet.statementEmpty,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.4,
                    color: AppColors.muted,
                  ),
                )
              else
                for (final shift in shifts) _StatementRow(shift: shift),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          tr.wallet.statementNote,
          style: const TextStyle(
            fontSize: 12.5,
            height: 1.35,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: shifts.isEmpty ? null : () => _copy(shifts),
          icon: const Icon(Icons.copy_rounded, size: 18),
          label: Text(tr.wallet.statementCopy),
        ),
      ],
    );
  }
}

/// Отработанные смены месяца — по порядку дней.
List<Shift> shiftsInMonth(List<Shift> shifts, DateTime month) => shifts
    .where((s) =>
        s.workDate.year == month.year && s.workDate.month == month.month)
    .toList()
  ..sort((a, b) {
    final byDay = a.workDate.compareTo(b.workDate);
    return byDay != 0 ? byDay : a.startMinutes.compareTo(b.startMinutes);
  });

/// Справка текстом — на языке приложения.
///
/// Обычный текст, а не PDF: его можно вставить куда угодно — в письмо,
/// WhatsApp, Telegram, — и он одинаково читается везде.
String statementText(AppUser user, DateTime month, List<Shift> shifts) {
  final sorted = shiftsInMonth(shifts, month);
  final minutes = sorted.fold(0, (sum, s) => sum + s.paidMinutes);
  final earned = sorted.fold(0, (sum, s) => sum + s.totalPay);
  return [
    tr.wallet.statementHeader,
    '${user.fullName}, ${formatKzPhone(user.phone)}',
    _capitalized(tr.core.monthYear(month)),
    '',
    for (final s in sorted)
      tr.wallet.statementLine(
        tr.core.dayMonthShort(s.workDate),
        s.company,
        s.title,
        '${formatTime(s.startMinutes)}–${formatTime(s.endMinutes)}',
        formatDuration(s.paidMinutes),
        formatMoney(s.totalPay),
      ),
    '',
    tr.wallet.statementTotal(
      tr.core.shifts(sorted.length),
      formatDuration(minutes),
      formatMoney(earned),
    ),
  ].join('\n');
}

String _capitalized(String text) =>
    text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

class _Total extends StatelessWidget {
  final String value;
  final String caption;
  final bool accent;

  const _Total({
    required this.value,
    required this.caption,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SurfaceCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: accent ? AppColors.brand : null,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatementRow extends StatelessWidget {
  final Shift shift;

  const _StatementRow({required this.shift});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Text(
              tr.core.dayMonthShort(shift.workDate),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shift.company,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${shift.title} · ${formatDuration(shift.paidMinutes)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatMoney(shift.totalPay),
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
