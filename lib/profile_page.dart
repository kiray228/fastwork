import 'package:flutter/material.dart';

import 'auth/terms_page.dart';
import 'data/repositories.dart';
import 'data/session.dart';
import 'documents_page.dart';
import 'my_reviews_page.dart';
import 'support_ui/support_page.dart';
import 'theme/app_colors.dart';
import 'package:fastwork_core/user.dart';
import 'wallet_page.dart';
import 'widgets/common.dart';
import 'widgets/nav.dart';

/// Профиль пользователя.
class ProfilePage extends StatelessWidget {
  final AppSession session;
  final AppRepositories repos;

  const ProfilePage({super.key, required this.session, required this.repos});

  /// Сменить город.
  ///
  /// Город тут не украшение анкеты: от него зависит, какие смены человек
  /// вообще видит в ленте. Поэтому менять его должно быть легко.
  Future<void> _changeCity(BuildContext context) async {
    final current = session.user;
    if (current == null) return;

    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Material(
        color: Theme.of(sheetContext).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.muted.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Text(
                  'Ваш город',
                  style: Theme.of(sheetContext)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 20),
                ),
              ),
              for (final city in kCities)
                ListTile(
                  title: Text(city),
                  trailing: city == current.city
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.brand)
                      : null,
                  onTap: () => Navigator.of(sheetContext).pop(city),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );

    if (picked == null || picked == current.city) return;

    final updated = await repos.auth.changeCity(current.id, picked);
    if (updated != null) session.setUser(updated);
  }

  Future<void> _signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text(
          'Записи на смены сохранятся — войдите под тем же номером, '
          'и они будут на месте.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Остаться'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.accent),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await repos.auth.signOut();
    session.setUser(null);
  }

  @override
  Widget build(BuildContext context) {
    final user = session.user;
    if (user == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          _Header(user: user),
          const SizedBox(height: 14),
          if (!user.isManager) ...[
            _Stats(user: user),
            const SizedBox(height: 14),
          ],
          SurfaceCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                if (!user.isManager)
                  _MenuRow(
                    icon: Icons.payments_outlined,
                    title: 'Выплаты',
                    trailing: 'Вознаграждение',
                    onTap: () => Navigator.of(context).push(
                      appRoute(WalletPage(repository: repos.shifts)),
                    ),
                  ),
                if (!user.isManager)
                  _MenuRow(
                    icon: Icons.badge_outlined,
                    title: 'Документы',
                    trailing: user.isVerified ? 'Проверены' : 'Не проверены',
                    onTap: () => Navigator.of(context).push(
                      appRoute(
                        DocumentsPage(
                          repository: repos.documents,
                          session: session,
                        ),
                      ),
                    ),
                  ),
                if (!user.isManager)
                  _MenuRow(
                    icon: Icons.star_outline_rounded,
                    title: 'Отзывы обо мне',
                    trailing: user.hasRatedShifts
                        ? '${user.ratingCount}'
                        : 'Пока нет',
                    onTap: () => Navigator.of(context).push(
                      appRoute(
                        MyReviewsPage(
                          session: session,
                          repository: repos.shifts,
                        ),
                      ),
                    ),
                  ),
                _MenuRow(
                  icon: Icons.place_outlined,
                  title: 'Город',
                  trailing: user.city,
                  onTap: () => _changeCity(context),
                ),
                _MenuRow(
                  icon: Icons.gavel_rounded,
                  title: 'Правила сервиса',
                  onTap: () => Navigator.of(context).push(
                    appRoute(const TermsPage()),
                  ),
                ),
                _MenuRow(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Поддержка',
                  onTap: () => Navigator.of(context).push(
                    appRoute(SupportPage(repository: repos.support)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Выйти из аккаунта'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.muted,
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final AppUser user;

  const _Header({required this.user});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SurfaceCard(
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.brand, AppColors.brandDark],
              ),
            ),
            child: Text(
              user.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.fullName,
            textAlign: TextAlign.center,
            style: text.titleLarge?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            _formatPhone(user.phone),
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 12),
          if (user.isManager)
            TagChip(
              text: user.company ?? 'Заказчик',
              icon: Icons.business_rounded,
              color: AppColors.brand,
            )
          else if (user.isVerified)
            const TagChip(
              text: 'Верифицирован',
              icon: Icons.verified_rounded,
              color: AppColors.brand,
            )
          else
            const TagChip(
              text: 'Документы не проверены',
              icon: Icons.info_outline_rounded,
              color: AppColors.accent,
            ),
        ],
      ),
    );
  }

  /// 77000000000 -> «+7 700 000 00 00»
  static String _formatPhone(String digits) {
    if (digits.length < 11) return '+$digits';
    return '+${digits[0]} ${digits.substring(1, 4)} '
        '${digits.substring(4, 7)} ${digits.substring(7, 9)} '
        '${digits.substring(9)}';
  }
}

class _Stats extends StatelessWidget {
  final AppUser user;

  const _Stats({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.star_rounded,
            value: user.rating.toStringAsFixed(1),
            // Пока оценок нет, честнее сказать «стартовый»: это число
            // никто не заработал, оно просто стоит по умолчанию.
            label: user.hasRatedShifts ? 'Рейтинг' : 'Стартовый',
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            icon: Icons.work_history_rounded,
            value: '${user.completedShifts}',
            label: 'Смен',
            color: AppColors.brand,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          // Третья клетка меняется по обстоятельствам.
          //
          // Пока человек выходит на все смены, уровень интереснее:
          // «100% выходов» у того, кто ни разу не подвёл, — очевидность.
          // А вот появился невыход — и это важнее уровня, потому что
          // именно по этому числу его будут выбирать заказчики.
          child: user.noShows > 0
              ? _StatTile(
                  icon: Icons.event_available_rounded,
                  value: '${user.reliabilityPercent}%',
                  label: 'Выходов',
                  color: AppColors.warning,
                )
              : _StatTile(
                  icon: Icons.emoji_events_rounded,
                  value: user.level,
                  label: 'Уровень',
                  color: const Color(0xFF6366F1),
                ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;

  const _MenuRow({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.brand, size: 22),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing!,
              style: const TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
      onTap: onTap ??
          () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Этот раздел ещё не сделан')),
              ),
    );
  }
}
