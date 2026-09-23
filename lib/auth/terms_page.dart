import 'package:flutter/material.dart';

import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/terms.dart';
import '../data/session.dart';
import '../theme/app_colors.dart';
import '../widgets/async_state.dart';
import '../widgets/common.dart';

/// Правила сервиса целиком — чтобы прочитать.
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Правила')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: const [TermsText()],
      ),
    );
  }
}

/// Текст правил — один на экран чтения и экран согласия.
class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(kTermsTitle, style: text.titleLarge?.copyWith(fontSize: 18)),
          const SizedBox(height: 4),
          const Text(
            'Редакция $kTermsVersion',
            style: TextStyle(fontSize: 12.5, color: AppColors.muted),
          ),
          for (final section in kTermsSections) ...[
            const SizedBox(height: 16),
            Text(section.title, style: text.titleMedium),
            const SizedBox(height: 6),
            Text(
              section.body,
              style: text.bodyMedium?.copyWith(height: 1.45),
            ),
          ],
        ],
      ),
    );
  }
}

/// Экран согласия для тех, кто зарегистрировался раньше, чем появились
/// правила, — или раньше, чем они поменялись.
///
/// Без него согласие было бы только у новых людей: старые аккаунты
/// прошли регистрацию, когда галочки ещё не было, и так и работали бы.
class TermsGatePage extends StatefulWidget {
  final AppSession session;
  final AuthRepository auth;

  const TermsGatePage({super.key, required this.session, required this.auth});

  @override
  State<TermsGatePage> createState() => _TermsGatePageState();
}

class _TermsGatePageState extends State<TermsGatePage> {
  bool agreed = false;
  bool busy = false;

  Future<void> _accept() async {
    final user = widget.session.user;
    if (user == null) return;

    setState(() => busy = true);
    final updated = await guarded(context, () => widget.auth.acceptTerms(user.id));
    if (!mounted) return;
    setState(() => busy = false);
    if (updated != null) widget.session.setUser(updated);
  }

  Future<void> _signOut() async {
    await widget.auth.signOut();
    widget.session.setUser(null);
  }

  @override
  Widget build(BuildContext context) {
    final wasAccepted = (widget.session.user?.termsVersion ?? 0) > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Правила сервиса'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              children: [
                Text(
                  wasAccepted
                      ? 'Правила обновились. Прочитайте новую редакцию — '
                          'без согласия с ней работать дальше нельзя.'
                      : 'Прежде чем продолжить, прочитайте правила '
                          'и подтвердите согласие.',
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppColors.muted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                const TermsText(),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TermsCheckbox(
                    value: agreed,
                    onChanged: (v) => setState(() => agreed = v),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: agreed && !busy ? _accept : null,
                    child: const Text('Принимаю'),
                  ),
                  TextButton(
                    onPressed: busy ? null : _signOut,
                    child: const Text('Выйти'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Галочка «принимаю правила» со ссылкой на сам текст.
class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const TermsCheckbox({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
          activeColor: AppColors.brand,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => onChanged(!value),
                  child: const Text(
                    'Я принимаю ',
                    style: TextStyle(fontSize: 13.5, height: 1.35),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const TermsPage()),
                  ),
                  child: const Text(
                    'правила сервиса',
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brand,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.brand,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => onChanged(!value),
                  child: const Text(
                    ', включая лимит дохода 300 МРП в месяц и '
                    'обработку персональных данных',
                    style: TextStyle(fontSize: 13.5, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
