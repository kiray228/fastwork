import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/shift.dart';
import '../theme/app_colors.dart';
import '../theme/glass.dart';
import 'async_state.dart';
import '../l10n/strings.dart';

/// Строка расшифровки: за что именно платят.
class PaymentLine {
  final String label;
  final int amount;

  const PaymentLine(this.label, this.amount);
}

/// Как начать оплату: способ, телефон для Kaspi и прошлая попытка.
///
/// Прошлая попытка нужна, чтобы повтор не создал вторую смену: первый
/// раз смена создаётся, а повторно оплачивается уже созданная.
typedef StartCheckout = Future<PaymentCheckout> Function(
  PaymentMethod method,
  String? phone,
  PaymentCheckout? previous,
);

/// Окно оплаты — картой или через Kaspi.kz.
///
/// Одно на все денежные действия: оплатить смену, доплатить после правки,
/// вывести заработанное. Путь у всех один, как у настоящих провайдеров:
///
///   1. выбрать способ и нажать «Оплатить» — сервер заводит операцию;
///   2. заплатить: на странице провайдера картой или подтвердить счёт,
///      который пришёл в Kaspi.kz;
///   3. дождаться, пока провайдер подтвердит, — окно само спрашивает
///      сервер каждые несколько секунд.
///
/// В тестовом режиме второй шаг происходит прямо здесь: тестовая карта
/// или кнопка «Оплатить в Kaspi».
///
/// Возвращает последнюю оплату: прошла, ждёт или не прошла. null — до
/// оплаты дело не дошло.
Future<PaymentCheckout?> showCheckoutSheet(
  BuildContext context, {
  required String title,
  required List<PaymentLine> lines,
  required int total,
  required String actionLabel,
  required StartCheckout start,
  required Future<PaymentCheckout> Function(int id) status,
  required Future<PaymentCheckout> Function(int id, PaymentCard? card)
      completeSandbox,
  String? note,
  String phone = '',
  bool payout = false,
}) =>
    showModalBottomSheet<PaymentCheckout>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CheckoutSheet(
        title: title,
        lines: lines,
        total: total,
        actionLabel: actionLabel,
        start: start,
        status: status,
        completeSandbox: completeSandbox,
        note: note,
        phone: phone,
        payout: payout,
      ),
    );

class _CheckoutSheet extends StatefulWidget {
  final String title;
  final List<PaymentLine> lines;
  final int total;
  final String actionLabel;
  final StartCheckout start;
  final Future<PaymentCheckout> Function(int id) status;
  final Future<PaymentCheckout> Function(int id, PaymentCard? card)
      completeSandbox;
  final String? note;
  final String phone;
  final bool payout;

  const _CheckoutSheet({
    required this.title,
    required this.lines,
    required this.total,
    required this.actionLabel,
    required this.start,
    required this.status,
    required this.completeSandbox,
    required this.note,
    required this.phone,
    required this.payout,
  });

  @override
  State<_CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<_CheckoutSheet> {
  PaymentMethod method = PaymentMethod.card;
  late final phoneController = TextEditingController(
    text: widget.phone.isEmpty ? '' : formatKzPhone(widget.phone),
  );
  final numberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvcController = TextEditingController();

  /// Начатая оплата. null — ещё выбираем способ.
  PaymentCheckout? checkout;

  /// Попытка, которая не прошла, — чтобы повтор оплатил ту же смену.
  PaymentCheckout? previous;
  bool busy = false;
  String? error;

  /// Опрос сервера, пока человек платит у провайдера.
  Timer? poll;

  @override
  void dispose() {
    poll?.cancel();
    phoneController.dispose();
    numberController.dispose();
    expiryController.dispose();
    cvcController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    String? phone;
    if (method == PaymentMethod.kaspi) {
      phone = normalizeKzPhone(phoneController.text);
      if (phone == null) {
        setState(() => error = tr.wallet.kaspiPhoneMissing);
        return;
      }
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final started = await widget.start(method, phone, previous);
      if (!mounted) return;
      setState(() {
        busy = false;
        checkout = started;
      });
      _after(started);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        busy = false;
        error = describeError(e);
      });
    }
  }

  /// Что делать с оплатой после очередного ответа.
  void _after(PaymentCheckout current) {
    if (current.isPaid) {
      poll?.cancel();
      Navigator.of(context).pop(current);
      return;
    }
    if (current.isFailed) {
      poll?.cancel();
      setState(() {
        previous = current;
        checkout = null;
        error = current.message ?? tr.wallet.paymentFailed;
      });
      return;
    }
    // Настоящий провайдер: открываем его страницу и ждём, спрашивая сервер.
    if (!current.sandbox) {
      if (current.url != null) _openProvider(current.url!);
      poll ??= Timer.periodic(const Duration(seconds: 3), (_) => _check());
    }
  }

  Future<void> _openProvider(String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
    if (!ok && mounted) {
      setState(() => error = tr.wallet.providerOpenFailed);
    }
  }

  Future<void> _check() async {
    final current = checkout;
    if (current == null || busy) return;
    try {
      final fresh = await widget.status(current.id);
      if (!mounted) return;
      setState(() => checkout = fresh);
      _after(fresh);
    } catch (_) {
      // Сеть моргнула — спросим в следующий раз.
    }
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
  /// Луна, просроченную карту — дата.
  String? _validateCard() {
    final digits = cardDigits(numberController.text);
    if (!luhnValid(digits)) return tr.wallet.checkCardNumber;
    if (!expiryValid(expiryController.text, DateTime.now())) {
      return tr.wallet.checkExpiry;
    }
    final cvc = cardDigits(cvcController.text);
    if (cvc.length < 3) return tr.wallet.cvcHint;
    return null;
  }

  /// Тестовый режим: «заплатить» здесь же.
  Future<void> _paySandbox() async {
    final current = checkout!;
    PaymentCard? card;
    if (current.method == PaymentMethod.card) {
      final problem = _validateCard();
      if (problem != null) {
        setState(() => error = problem);
        return;
      }
      // Номер превращается в токен прямо здесь и дальше не идёт.
      card = tokenizeSandboxCard(numberController.text);
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final result = await widget.completeSandbox(current.id, card);
      if (!mounted) return;
      setState(() {
        busy = false;
        checkout = result;
      });
      _after(result);
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
    final current = checkout;

    return Padding(
      // Клавиатура не должна закрывать поля.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GlassSheet(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.92,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            children: [
              const SheetHandle(),
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
              _AmountRow(label: tr.wallet.total, amount: widget.total, bold: true),
              const SizedBox(height: 16),
              if (current == null)
                ..._chooseMethod()
              else if (current.sandbox)
                ..._sandboxStep(current)
              else
                ..._waitStep(current),
              if (error != null) _ErrorLine(error!),
            ],
          ),
        ),
      ),
    );
  }

  /// Шаг первый: чем платить.
  List<Widget> _chooseMethod() => [
        if (!widget.payout) ...[
          _MethodPicker(
            selected: method,
            onChanged: busy
                ? null
                : (m) => setState(() {
                      method = m;
                      error = null;
                    }),
          ),
          const SizedBox(height: 14),
        ],
        if (!widget.payout && method == PaymentMethod.kaspi) ...[
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            onChanged: (_) => setState(() => error = null),
            decoration: InputDecoration(
              labelText: tr.wallet.kaspiPhoneLabel,
              hintText: '+7 700 000 00 00',
              prefixIcon: const Icon(Icons.phone_iphone_rounded),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr.wallet.kaspiPhoneNote,
            style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
          ),
          const SizedBox(height: 14),
        ],
        if (widget.payout) ...[
          Text(
            tr.wallet.payoutCardNote,
            style: const TextStyle(
                fontSize: 13, color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 14),
        ],
        SafeArea(
          top: false,
          child: FilledButton.icon(
            onPressed: busy ? null : _start,
            icon: busy
                ? const _Spinner()
                : Icon(
                    method == PaymentMethod.kaspi
                        ? Icons.phone_iphone_rounded
                        : Icons.lock_rounded,
                    size: 18,
                  ),
            label: Text(previous == null
                ? widget.actionLabel
                : tr.wallet.tryAgain),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          tr.wallet.cardPrivacy,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 11.5, color: AppColors.muted, height: 1.4),
        ),
      ];

  /// Тестовый режим: платёж «проходит» прямо в приложении.
  List<Widget> _sandboxStep(PaymentCheckout current) => [
        const _SandboxBanner(),
        const SizedBox(height: 14),
        if (current.method == PaymentMethod.kaspi) ...[
          _KaspiInvoice(phone: current.phone, amount: current.amount),
          const SizedBox(height: 14),
          SafeArea(
            top: false,
            child: FilledButton.icon(
              onPressed: busy ? null : _paySandbox,
              icon: busy
                  ? const _Spinner()
                  : const Icon(Icons.check_circle_rounded, size: 18),
              label: Text(tr.wallet.kaspiConfirmTest),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF14635),
              ),
            ),
          ),
        ] else ...[
          TextField(
            controller: numberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(19),
              _CardNumberFormatter(),
            ],
            onChanged: (_) => setState(() => error = null),
            decoration: InputDecoration(
              labelText: tr.wallet.cardNumber,
              hintText: '0000 0000 0000 0000',
              prefixIcon: const Icon(Icons.credit_card_rounded),
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
                  decoration: InputDecoration(
                    labelText: tr.wallet.expiry,
                    hintText: tr.wallet.expiryHint,
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
              label: Text(tr.wallet.fillTestCard),
            ),
          ),
          const SizedBox(height: 6),
          SafeArea(
            top: false,
            child: FilledButton.icon(
              onPressed: busy ? null : _paySandbox,
              icon: busy
                  ? const _Spinner()
                  : const Icon(Icons.lock_rounded, size: 18),
              label: Text(widget.payout
                  ? tr.wallet.transferAmount(formatMoney(current.amount))
                  : tr.wallet.payAmount(formatMoney(current.amount))),
            ),
          ),
        ],
      ];

  /// Настоящий провайдер: человек платит у него, мы ждём подтверждения.
  List<Widget> _waitStep(PaymentCheckout current) => [
        if (current.method == PaymentMethod.kaspi && current.url == null)
          _KaspiInvoice(phone: current.phone, amount: current.amount)
        else
          _InfoBox(
            icon: Icons.open_in_new_rounded,
            text: tr.wallet.providerOpened,
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _Spinner(color: AppColors.brand),
            const SizedBox(width: 10),
            Text(
              tr.wallet.waitingConfirmation,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (current.url != null)
          OutlinedButton.icon(
            onPressed: () => _openProvider(current.url!),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: Text(current.method == PaymentMethod.kaspi
                ? tr.wallet.openKaspi
                : tr.wallet.openPaymentPage),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        TextButton(
          onPressed: busy ? null : _check,
          child: Text(tr.wallet.paidCheck),
        ),
        SafeArea(
          top: false,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(current),
            child: Text(tr.wallet.closePayLater),
          ),
        ),
      ];
}

/// Две кнопки-плитки: «Карта» и «Kaspi.kz».
class _MethodPicker extends StatelessWidget {
  final PaymentMethod selected;
  final ValueChanged<PaymentMethod>? onChanged;

  const _MethodPicker({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget tile(PaymentMethod m, IconData icon, Color color, String caption) {
      final on = m == selected;
      return Expanded(
        child: Semantics(
          selected: on,
          button: true,
          child: InkWell(
            onTap: onChanged == null ? null : () => onChanged!(m),
            borderRadius: BorderRadius.circular(18),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: on
                    ? color.withValues(alpha: 0.12)
                    : glassFieldFill(context),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: on ? color : glassFieldEdge(context),
                  width: on ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: color),
                  const SizedBox(height: 8),
                  Text(
                    m.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    caption,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tile(PaymentMethod.card, Icons.credit_card_rounded, AppColors.brand,
            'Visa, Mastercard'),
        const SizedBox(width: 10),
        tile(PaymentMethod.kaspi, Icons.phone_iphone_rounded,
            const Color(0xFFF14635), tr.wallet.kaspiCaption),
      ],
    );
  }
}

/// Карточка «счёт в Kaspi.kz отправлен на номер».
class _KaspiInvoice extends StatelessWidget {
  final String? phone;
  final int amount;

  const _KaspiInvoice({required this.phone, required this.amount});

  @override
  Widget build(BuildContext context) => _InfoBox(
        icon: Icons.phone_iphone_rounded,
        color: const Color(0xFFF14635),
        text: tr.wallet.kaspiInvoice(
          formatMoney(amount),
          phone == null ? null : formatKzPhone(phone!),
        ),
      );
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoBox({
    required this.icon,
    required this.text,
    this.color = AppColors.brand,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text, style: const TextStyle(height: 1.4)),
            ),
          ],
        ),
      );
}

class _ErrorLine extends StatelessWidget {
  final String message;

  const _ErrorLine(this.message);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 18, color: AppColors.danger),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.danger,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
}

class _Spinner extends StatelessWidget {
  final Color color;

  const _Spinner({this.color = Colors.white});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: color),
      );
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.science_outlined, size: 18, color: AppColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tr.wallet.sandboxBanner(kSandboxCardNumber),
              style: const TextStyle(fontSize: 12.5, height: 1.35),
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
