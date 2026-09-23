import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/shift.dart';
import '../theme/app_colors.dart';
import 'async_state.dart';

/// Строка расшифровки: за что именно платят.
class PaymentLine {
  final String label;
  final int amount;

  const PaymentLine(this.label, this.amount);
}

/// Окно оплаты картой.
///
/// Одно на все денежные действия: оплатить смену, доплатить после правки,
/// вывести заработанное. Различаются только подписи и то, что сделать
/// с картой, — это передают снаружи в `onCard`.
///
/// Окно само показывает отказ банка и даёт попробовать другую карту:
/// закрыть его при отказе значило бы заставить человека заново открывать
/// оплату и заново вбивать всё, кроме номера.
///
/// Возвращает `true`, если `onCard` прошёл без ошибки.
Future<bool> showPaymentSheet(
  BuildContext context, {
  required String title,
  required List<PaymentLine> lines,
  required int total,
  required String actionLabel,
  required Future<void> Function(PaymentCard card) onCard,
  String? note,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PaymentSheet(
      title: title,
      lines: lines,
      total: total,
      actionLabel: actionLabel,
      onCard: onCard,
      note: note,
    ),
  );
  return result ?? false;
}

class _PaymentSheet extends StatefulWidget {
  final String title;
  final List<PaymentLine> lines;
  final int total;
  final String actionLabel;
  final Future<void> Function(PaymentCard card) onCard;
  final String? note;

  const _PaymentSheet({
    required this.title,
    required this.lines,
    required this.total,
    required this.actionLabel,
    required this.onCard,
    required this.note,
  });

  @override
  State<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<_PaymentSheet> {
  final numberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvcController = TextEditingController();
  bool busy = false;
  String? error;

  @override
  void dispose() {
    numberController.dispose();
    expiryController.dispose();
    cvcController.dispose();
    super.dispose();
  }

  void _fillTestCard() {
    setState(() {
      numberController.text = kSandboxCardNumber;
      expiryController.text = '12/30';
      cvcController.text = '123';
      error = null;
    });
  }

  /// Проверки, которые не требуют банка. Опечатку в номере ловит алгоритм
  /// Луна, просроченную карту — дата. Спрашивать банк о заведомо неверной
  /// карте — лишняя секунда ожидания и лишний отказ в его статистике.
  String? _validate() {
    final digits = cardDigits(numberController.text);
    if (!luhnValid(digits)) return 'Проверьте номер карты';
    if (!expiryValid(expiryController.text, DateTime.now())) {
      return 'Проверьте срок действия';
    }
    final cvc = cardDigits(cvcController.text);
    if (cvc.length < 3) return 'CVC — три цифры с обратной стороны';
    return null;
  }

  Future<void> _submit() async {
    final problem = _validate();
    if (problem != null) {
      setState(() => error = problem);
      return;
    }

    // Номер превращается в токен прямо здесь и дальше не идёт.
    // В настоящем режиме это сделал бы провайдер своей формой.
    final card = tokenizeSandboxCard(numberController.text);

    setState(() {
      busy = true;
      error = null;
    });
    try {
      await widget.onCard(card);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        busy = false;
        error = describeError(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Padding(
      // Клавиатура не должна закрывать поля карты.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.muted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Text(
                widget.title,
                style: text.headlineSmall?.copyWith(fontSize: 22),
              ),
              if (widget.note != null) ...[
                const SizedBox(height: 6),
                Text(
                  widget.note!,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppColors.muted,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              for (final line in widget.lines)
                _AmountRow(label: line.label, amount: line.amount),
              const Divider(height: 20),
              _AmountRow(label: 'Итого', amount: widget.total, bold: true),
              const SizedBox(height: 16),
              const _SandboxBanner(),
              const SizedBox(height: 14),
              TextField(
                controller: numberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                  _CardNumberFormatter(),
                ],
                onChanged: (_) => setState(() => error = null),
                decoration: const InputDecoration(
                  labelText: 'Номер карты',
                  hintText: '0000 0000 0000 0000',
                  prefixIcon: Icon(Icons.credit_card_rounded),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expiryController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryFormatter(),
                      ],
                      onChanged: (_) => setState(() => error = null),
                      decoration: const InputDecoration(
                        labelText: 'Срок',
                        hintText: 'ММ/ГГ',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: cvcController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      onChanged: (_) => setState(() => error = null),
                      decoration: const InputDecoration(
                        labelText: 'CVC',
                        hintText: '•••',
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: busy ? null : _fillTestCard,
                  icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
                  label: const Text('Подставить тестовую карту'),
                ),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          size: 18, color: AppColors.danger),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          error!,
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              SafeArea(
                top: false,
                child: FilledButton.icon(
                  onPressed: busy ? null : _submit,
                  icon: busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.lock_rounded, size: 18),
                  label: Text(widget.actionLabel),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Номер карты не попадает на серверы fastwork: его принимает '
                'платёжный провайдер, у нас остаются только последние '
                'четыре цифры.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppColors.muted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final int amount;
  final bool bold;

  const _AmountRow({
    required this.label,
    required this.amount,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: bold ? 15 : 13.5,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                color: bold ? null : AppColors.muted,
              ),
            ),
          ),
          Text(
            formatMoney(amount),
            style: TextStyle(
              fontSize: bold ? 17 : 14,
              fontWeight: FontWeight.w800,
              color: bold ? AppColors.brand : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Честное предупреждение: деньги в тестовом режиме ненастоящие.
class _SandboxBanner extends StatelessWidget {
  const _SandboxBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.science_outlined, size: 18, color: AppColors.accent),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Тестовый режим: списания ненастоящие. Карта $kSandboxCardNumber '
              'проходит, карта на …0002 — отказ банка.',
              style: TextStyle(fontSize: 12.5, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

/// «4242424242424242» -> «4242 4242 4242 4242» прямо при вводе.
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = cardDigits(newValue.text);
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// «1230» -> «12/30».
class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = cardDigits(newValue.text);
    final text = digits.length <= 2
        ? digits
        : '${digits.substring(0, 2)}/${digits.substring(2)}';
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
