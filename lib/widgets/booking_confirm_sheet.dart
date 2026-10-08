import 'package:flutter/material.dart';

import 'package:fastwork_core/shift.dart';
import '../theme/app_colors.dart';
import '../theme/glass.dart';
import '../l10n/strings.dart';

/// Окно подтверждения записи на смену.
///
/// Запись — это обязательство, а не «заявка на рассмотрение». Поэтому
/// перед ней человек должен явно прочитать условия и подтвердить их.
/// Возвращает `true`, если пользователь подтвердил.
Future<bool> showBookingConfirmSheet(
  BuildContext context,
  Shift shift,
) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _BookingConfirmSheet(shift: shift),
  );
  return result ?? false;
}

class _BookingConfirmSheet extends StatefulWidget {
  final Shift shift;

  const _BookingConfirmSheet({required this.shift});

  @override
  State<_BookingConfirmSheet> createState() => _BookingConfirmSheetState();
}

class _BookingConfirmSheetState extends State<_BookingConfirmSheet> {
  /// Галочка «прочитал условия». Пока не поставлена — кнопка не работает.
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    final shift = widget.shift;
    final text = Theme.of(context).textTheme;

    return GlassSheet(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Полоска-«ручка» сверху: подсказывает, что окно можно смахнуть.
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.muted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                children: [
                  Text(
                    tr.shift.confirmTitle,
                    style: text.headlineSmall?.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tr.shift.confirmSubtitle,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppColors.muted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Короткая сводка по смене — что именно подтверждаем.
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: glassFieldFill(context),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: glassFieldEdge(context)),
                    ),
                    child: Column(
                      children: [
                        _SummaryRow(
                          label: tr.shift.title,
                          value: shift.title,
                        ),
                        _SummaryRow(
                          label: tr.shift.summaryWhen,
                          value: '${formatDateTime(shift.startsAt)} — '
                              '${formatTime(shift.endMinutes)}',
                        ),
                        _SummaryRow(
                          label: tr.shift.summaryWhere,
                          value: shift.company,
                        ),
                        _SummaryRow(
                          label: tr.shift.payTitle,
                          value: formatMoney(shift.totalPay),
                          highlight: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(tr.shift.youCommit, style: text.titleMedium),
                  const SizedBox(height: 12),

                  _Term(
                    icon: Icons.schedule_rounded,
                    text: tr.shift.termShowUp(formatDateTime(shift.startsAt)),
                  ),
                  _Term(
                    icon: Icons.event_busy_rounded,
                    danger: true,
                    // До смены меньше срока отмены — значит, отменить
                    // эту запись не выйдет вовсе. Раньше здесь стояло
                    // «можно до 05:00» — время, которое уже прошло.
                    text: shift.canCancelAt(DateTime.now())
                        ? tr.shift.termCancelUntil(
                            formatDateTime(shift.cancelDeadline),
                            shift.cancelDeadlineHours,
                          )
                        : tr.shift.termNoCancel(shift.cancelDeadlineHours),
                  ),
                  _Term(
                    icon: Icons.trending_down_rounded,
                    danger: true,
                    text: tr.shift.termNoShow,
                  ),
                  if (shift.hasUnpaidBreak)
                    _Term(
                      icon: Icons.lunch_dining_rounded,
                      text: tr.shift.termUnpaidBreak(
                          formatDuration(shift.breakMinutes)),
                    ),
                  if (shift.isFunded)
                    _Term(
                      icon: Icons.verified_user_rounded,
                      text: tr.shift.termFunded,
                    ),
                  _Term(
                    icon: Icons.account_balance_wallet_outlined,
                    text: shift.payoutDelayDays == 1
                        ? tr.shift.termPayoutNextDay
                        : tr.shift.termPayoutInDays(shift.payoutDelayDays),
                  ),
                  _Term(
                    icon: Icons.account_balance_rounded,
                    text: tr.shift.termEarningsLimit,
                  ),
                  if (shift.dressCode != null)
                    _Term(
                      icon: Icons.checkroom_rounded,
                      text: tr.shift.termDressCode(shift.dressCode!),
                    ),

                  const SizedBox(height: 8),

                  // Галочка согласия. Кнопка не станет активной, пока её нет.
                  InkWell(
                    onTap: () => setState(() => agreed = !agreed),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: agreed,
                            onChanged: (v) => setState(() => agreed = v ?? false),
                            activeColor: AppColors.brand,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                tr.shift.agreeCheckbox,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Кнопки внизу — всегда на виду, не уезжают при прокрутке.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          foregroundColor: AppColors.body,
                        ),
                        child: Text(tr.shift.back),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: agreed
                            ? () => Navigator.of(context).pop(true)
                            : null,
                        child: Text(tr.shift.confirmButton),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 116,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: highlight
                    ? AppColors.brand
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Один пункт условий.
class _Term extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool danger;

  const _Term({required this.icon, required this.text, this.danger = false});

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.accent : AppColors.brand;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
