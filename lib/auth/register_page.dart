import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/auth_repository.dart';
import '../data/session.dart';
import '../theme/app_colors.dart';
import '../user.dart';
import '../widgets/common.dart';

/// Вход и регистрация в одном экране.
///
/// Пароля нет намеренно: настоящая проверка номера — это SMS-код, а его
/// присылает внешний сервис. Пока входим по номеру телефона.
class RegisterPage extends StatefulWidget {
  final AppSession session;
  final AuthRepository auth;

  const RegisterPage({super.key, required this.session, required this.auth});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  String city = kCities.first;
  bool busy = false;
  String? error;

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }

  /// Оставляем в номере только цифры и проверяем длину.
  String get _digits => phoneController.text.replaceAll(RegExp(r'\D'), '');
  bool get _phoneOk => _digits.length >= 10;
  bool get _nameOk => nameController.text.trim().length >= 2;

  Future<void> _submit() async {
    if (!_phoneOk) {
      setState(() => error = 'Введите номер телефона полностью');
      return;
    }
    if (!_nameOk) {
      setState(() => error = 'Введите имя и фамилию');
      return;
    }

    setState(() {
      busy = true;
      error = null;
    });

    // Если с таким номером уже входили — просто пускаем внутрь.
    // Если нет — создаём нового пользователя.
    final existing = await widget.auth.findByPhone(_digits);
    final user = existing ??
        await widget.auth.register(
          phone: _digits,
          fullName: nameController.text.trim(),
          city: city,
        );

    if (existing != null) await widget.auth.signIn(user);
    if (!mounted) return;

    setState(() => busy = false);
    widget.session.setUser(user);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          children: [
            const Center(child: Wordmark(size: 34)),
            const SizedBox(height: 12),
            Text(
              'Подработка рядом с домом',
              textAlign: TextAlign.center,
              style: text.bodyLarge?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 36),

            Text('Вход', style: text.headlineSmall?.copyWith(fontSize: 22)),
            const SizedBox(height: 6),
            const Text(
              'Введите номер — если вы у нас впервые, аккаунт создастся сам',
              style: TextStyle(
                fontSize: 13.5,
                color: AppColors.muted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 22),

            _Field(
              label: 'Номер телефона',
              controller: phoneController,
              hint: '+7 700 000 00 00',
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ()-]')),
                LengthLimitingTextInputFormatter(18),
              ],
              onChanged: (_) => setState(() => error = null),
            ),
            const SizedBox(height: 16),
            _Field(
              label: 'Имя и фамилия',
              controller: nameController,
              hint: 'Ернар Калдыбеков',
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() => error = null),
            ),
            const SizedBox(height: 16),

            const Text(
              'Город',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in kCities)
                  GestureDetector(
                    onTap: () => setState(() => city = c),
                    child: TagChip(
                      text: c,
                      color: c == city ? AppColors.brand : null,
                    ),
                  ),
              ],
            ),

            if (error != null) ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      size: 18, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error!,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 28),
            FilledButton(
              onPressed: busy ? null : _submit,
              child: busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Начать работать'),
            ),
            const SizedBox(height: 14),
            const Text(
              'Нажимая кнопку, вы соглашаетесь с условиями оказания услуг '
              'и обработкой персональных данных.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, color: AppColors.muted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: isDark ? AppColors.darkSurface : Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.brand, width: 1.6),
            ),
          ),
        ),
      ],
    );
  }
}
