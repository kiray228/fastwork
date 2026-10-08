import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../l10n/strings.dart';

/// Что выбрал человек в окне отметки.
sealed class CheckInChoice {
  const CheckInChoice();
}

/// Ввёл код с экрана заказчика.
class WithCode extends CheckInChoice {
  final String code;
  const WithCode(this.code);
}

/// Отмечается без кода — например, заказчика на месте ещё нет.
class WithoutCode extends CheckInChoice {
  const WithoutCode();
}

/// Окно «Я на месте»: код с экрана заказчика или отметка без него.
///
/// Без кода тоже можно — отметка добровольная, и наказывать человека за
/// то, что старший смены опаздывает, незачем. Но с кодом заказчик видит
/// «подтверждено кодом»: человек точно был на точке.
///
/// null — передумал и закрыл окно.
Future<CheckInChoice?> showCheckInDialog(BuildContext context) =>
    showDialog<CheckInChoice>(
      context: context,
      builder: (_) => const _CheckInDialog(),
    );

class _CheckInDialog extends StatefulWidget {
  const _CheckInDialog();

  @override
  State<_CheckInDialog> createState() => _CheckInDialogState();
}

class _CheckInDialogState extends State<_CheckInDialog> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool get _complete => controller.text.length == 4;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(tr.shift.checkInButton),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr.shift.checkInHint,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 4,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 12,
            ),
            decoration: const InputDecoration(
              hintText: '0000',
              counterText: '',
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) {
              if (_complete) {
                Navigator.of(context).pop(WithCode(controller.text));
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(const WithoutCode()),
          style: TextButton.styleFrom(foregroundColor: AppColors.muted),
          child: Text(tr.shift.checkInWithoutCode),
        ),
        TextButton(
          onPressed: _complete
              ? () => Navigator.of(context).pop(WithCode(controller.text))
              : null,
          child: Text(tr.shift.checkInSubmit),
        ),
      ],
    );
  }
}
