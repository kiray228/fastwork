import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import '../data/session.dart';
import '../theme/app_colors.dart';
import '../theme/glass.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_core/user.dart';
import '../widgets/async_state.dart';
import '../widgets/common.dart';
import 'terms_page.dart';

/// Вход и регистрация в одном экране.
///
/// Пароля нет намеренно. Вместо него — одноразовый код на почту: пароль
/// надо придумать, запомнить и не потерять, а код приходит сам и живёт
/// пять минут. Почта, а не SMS, потому что письма бесплатны, а каждое
/// SMS стоит денег — в том числе каждая проверка при отладке.
class RegisterPage extends StatefulWidget {
  final AppSession session;
  final AuthRepository auth;

  const RegisterPage({super.key, required this.session, required this.auth});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

/// Шаг входа.
///
/// Через сервер их три: почта → код → анкета. На своём устройстве шаг
/// один — анкета: там некому подтверждать почту и нечем слать письма.
enum _Step { email, code, profile }

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final companyController = TextEditingController();
  String city = kCities.first;

  /// Кто регистрируется: исполнитель или заказчик.
  String role = UserRole.worker;
  bool get isManager => role == UserRole.manager;
  bool busy = false;
  String? error;

  /// Согласие с правилами. Без него аккаунт не создаётся — это проверяет
  /// и экран, и хранилище.
  bool acceptedTerms = false;

  late _Step step =
      widget.auth.requiresEmailCode ? _Step.email : _Step.profile;

  /// Куда ушёл код: `email` — письмом, `console` — в окно сервера.
  String delivery = 'email';

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    phoneController.dispose();
    nameController.dispose();
    companyController.dispose();
    super.dispose();
  }

  /// Оставляем в номере только цифры и проверяем длину.
  String get _digits => phoneController.text.replaceAll(RegExp(r'\D'), '');
  bool get _phoneOk => _digits.length >= 10;
  bool get _nameOk => nameController.text.trim().length >= 2;
  String get _email => emailController.text.trim().toLowerCase();

  /// Обёртка вокруг любого шага: включает ожидание, ловит сбой,
  /// показывает понятную причину.
  ///
  /// Без неё каждый из трёх шагов повторял бы один и тот же try/catch,
  /// и в одном из них его однажды забыли бы.
  Future<void> _run(Future<void> Function() body) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await body();
      if (mounted) setState(() => busy = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        busy = false;
        error = describeError(e);
      });
    }
  }

  // --- шаг 1: почта --------------------------------------------------------

  Future<void> _requestCode() async {
    if (!_email.contains('@') || !_email.contains('.')) {
      setState(() => error = 'Проверьте адрес почты');
      return;
    }

    await _run(() async {
      await widget.auth.requestCode(_email);
      if (!mounted) return;
      setState(() {
        step = _Step.code;
        codeController.clear();
      });
    });
  }

  // --- шаг 2: код ----------------------------------------------------------

  Future<void> _verifyCode() async {
    if (codeController.text.trim().length != 6) {
      setState(() => error = 'Код состоит из шести цифр');
      return;
    }

    await _run(() async {
      final user = await widget.auth.verifyCode(
        _email,
        codeController.text.trim(),
      );
      if (!mounted) return;

      if (user != null) {
        // Аккаунт уже есть — сразу внутрь.
        widget.session.setUser(user);
      } else {
        // Почта подтверждена, аккаунта ещё нет — дальше анкета.
        setState(() => step = _Step.profile);
      }
    });
  }

  // --- шаг 3: анкета -------------------------------------------------------

  Future<void> _submit() async {
    if (!_phoneOk) {
      setState(() => error = 'Введите номер телефона полностью');
      return;
    }
    if (!_nameOk) {
      setState(() => error = 'Введите имя и фамилию');
      return;
    }
    if (isManager && companyController.text.trim().length < 2) {
      setState(() => error = 'Укажите название компании');
      return;
    }

    await _run(() async {
      final AppUser user;

      if (widget.auth.requiresEmailCode) {
        // Почту сервер возьмёт из токена, выданного за код.
        if (!_termsOk()) return;
        user = await widget.auth.register(
          phone: _digits,
          fullName: nameController.text.trim(),
          city: city,
          role: role,
          company: isManager ? companyController.text.trim() : null,
          acceptedTermsVersion: kTermsVersion,
        );
      } else {
        // На своём устройстве: если таким номером уже входили — пускаем,
        // иначе создаём.
        //
        // Галочку спрашиваем только у новых: вошедший раньше уже
        // соглашался, а если правила с тех пор поменялись, его встретит
        // отдельный экран согласия.
        final existing = await widget.auth.findByPhone(_digits);
        if (existing == null && !_termsOk()) return;
        user = existing ??
            await widget.auth.register(
              phone: _digits,
              fullName: nameController.text.trim(),
              city: city,
              role: role,
              company: isManager ? companyController.text.trim() : null,
              acceptedTermsVersion: kTermsVersion,
            );
        if (existing != null) await widget.auth.signIn(user);
      }

      if (!mounted) return;
      widget.session.setUser(user);
    });
  }

  /// Проверить галочку. Нет её — показываем причину и не идём дальше.
  ///
  /// Проверка внутри `_run`, а не до него: на своём устройстве галочка
  /// нужна только новому человеку, а новый он или нет, выясняется лишь
  /// после запроса к базе.
  bool _termsOk() {
    if (acceptedTerms) return true;
    throw TermsNotAccepted();
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

            Text(_title, style: text.headlineSmall?.copyWith(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              _subtitle,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.muted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Шаги меняются плавно — так видно, что это один процесс,
            // а не три разных экрана.
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: KeyedSubtree(key: ValueKey(step), child: _stepBody()),
            ),

            if (step == _Step.profile) ...[
              const SizedBox(height: 18),
              TermsCheckbox(
                value: acceptedTerms,
                onChanged: (v) => setState(() {
                  acceptedTerms = v;
                  error = null;
                }),
              ),
            ],

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
              onPressed: busy ? null : _action,
              child: busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(_buttonLabel),
            ),

            if (step == _Step.code) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: busy
                    ? null
                    : () => setState(() {
                          step = _Step.email;
                          error = null;
                        }),
                child: const Text('Другой адрес'),
              ),
            ],

            if (step != _Step.profile) ...[
              const SizedBox(height: 14),
              const Text(
                'Правила сервиса покажем на следующем шаге — перед тем, '
                'как создать аккаунт.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11.5, color: AppColors.muted, height: 1.4),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String get _title => switch (step) {
        _Step.email => 'Вход',
        _Step.code => 'Код из письма',
        // На своём устройстве анкета — это и есть вход, а не его
        // продолжение. Заголовок должен говорить то же, что и раньше.
        _Step.profile =>
          widget.auth.requiresEmailCode ? 'Немного о вас' : 'Вход',
      };

  String get _subtitle => switch (step) {
        _Step.email =>
          'Введите почту — пришлём код. Если вы у нас впервые, аккаунт '
              'создастся сам',
        _Step.code => 'Отправили код на $_email. Он действует 5 минут',
        _Step.profile => widget.auth.requiresEmailCode
            ? 'Почта подтверждена. Осталось заполнить анкету'
            : 'Введите номер — если вы у нас впервые, аккаунт создастся сам',
      };

  String get _buttonLabel => switch (step) {
        _Step.email => 'Получить код',
        _Step.code => 'Подтвердить',
        _Step.profile => isManager ? 'Создать аккаунт' : 'Начать работать',
      };

  VoidCallback get _action => switch (step) {
        _Step.email => _requestCode,
        _Step.code => _verifyCode,
        _Step.profile => _submit,
      };

  Widget _stepBody() => switch (step) {
        _Step.email => _EmailStep(
            controller: emailController,
            onChanged: () => setState(() => error = null),
            onSubmit: _requestCode,
          ),
        _Step.code => _CodeStep(
            controller: codeController,
            onChanged: () => setState(() => error = null),
            onSubmit: _verifyCode,
          ),
        _Step.profile => _ProfileStep(
            isManager: isManager,
            onRole: (value) => setState(() => role = value),
            phoneController: phoneController,
            nameController: nameController,
            companyController: companyController,
            city: city,
            onCity: (value) => setState(() => city = value),
            onChanged: () => setState(() => error = null),
          ),
      };
}

/// Шаг 1: адрес почты.
class _EmailStep extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback onSubmit;

  const _EmailStep({
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return _Field(
      label: 'Почта',
      controller: controller,
      hint: 'ernar@example.kz',
      keyboardType: TextInputType.emailAddress,
      onChanged: (_) => onChanged(),
      onSubmitted: (_) => onSubmit(),
    );
  }
}

/// Шаг 2: шестизначный код.
class _CodeStep extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback onSubmit;

  const _CodeStep({
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return _Field(
      label: 'Код из письма',
      controller: controller,
      hint: '000000',
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
      onChanged: (_) => onChanged(),
      onSubmitted: (_) => onSubmit(),
    );
  }
}

/// Шаг 3: кто ты и откуда.
class _ProfileStep extends StatelessWidget {
  final bool isManager;
  final ValueChanged<String> onRole;
  final TextEditingController phoneController;
  final TextEditingController nameController;
  final TextEditingController companyController;
  final String city;
  final ValueChanged<String> onCity;
  final VoidCallback onChanged;

  const _ProfileStep({
    required this.isManager,
    required this.onRole,
    required this.phoneController,
    required this.nameController,
    required this.companyController,
    required this.city,
    required this.onCity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Выбор роли. Роль это свойство пользователя, а не отдельная
        // таблица: поля одинаковые, различается только то, что человек
        // видит и может делать внутри приложения.
        Row(
          children: [
            Expanded(
              child: _RoleCard(
                icon: Icons.person_search_rounded,
                title: 'Ищу подработку',
                selected: !isManager,
                onTap: () => onRole(UserRole.worker),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _RoleCard(
                icon: Icons.business_center_rounded,
                title: 'Нанимаю людей',
                selected: isManager,
                onTap: () => onRole(UserRole.manager),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _Field(
          label: 'Номер телефона',
          controller: phoneController,
          hint: '+7 700 000 00 00',
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ()-]')),
            LengthLimitingTextInputFormatter(18),
          ],
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 16),
        _Field(
          label: 'Имя и фамилия',
          controller: nameController,
          hint: 'Ернар Калдыбеков',
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => onChanged(),
        ),
        if (isManager) ...[
          const SizedBox(height: 16),
          _Field(
            label: 'Название компании',
            controller: companyController,
            hint: 'Magnum',
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => onChanged(),
          ),
        ],
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
                onTap: () => onCity(c),
                child: TagChip(
                  text: c,
                  color: c == city ? AppColors.brand : null,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.brand.withValues(alpha: 0.12)
              : glassFieldFill(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.brand
                : glassFieldEdge(context),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 26,
              color: selected ? AppColors.brand : AppColors.muted,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected
                    ? AppColors.brand
                    : Theme.of(context).colorScheme.onSurface,
              ),
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

  /// Что делать по нажатию Enter — чтобы код можно было подтвердить
  /// с клавиатуры, не целясь мышью в кнопку.
  final ValueChanged<String>? onSubmitted;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
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
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: glassFieldFill(context),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: glassFieldEdge(context),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: glassFieldEdge(context),
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
