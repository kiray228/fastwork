import 'package:flutter/material.dart';

import 'theme/app_colors.dart';
import 'widgets/common.dart';

/// Профиль. Пока заглушка — настоящей регистрации ещё нет.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SurfaceCard(
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.brand, AppColors.brandDark],
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Гость', style: text.titleLarge?.copyWith(fontSize: 17)),
                      const SizedBox(height: 4),
                      const Text(
                        'Регистрация пока не сделана',
                        style: TextStyle(fontSize: 13, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: const [
                _MenuRow(icon: Icons.payments_outlined, title: 'Выплаты'),
                _MenuRow(icon: Icons.badge_outlined, title: 'Документы'),
                _MenuRow(icon: Icons.star_outline_rounded, title: 'Рейтинг'),
                _MenuRow(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Поддержка',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String title;

  const _MenuRow({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.brand, size: 22),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.muted,
      ),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Этот раздел ещё не сделан')),
      ),
    );
  }
}
