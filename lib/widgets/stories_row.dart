import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/glass.dart';

/// Одна подсказка в ленте вверху главного экрана.
class StoryItem {
  final String title;
  final IconData icon;
  final Color color;

  const StoryItem({
    required this.title,
    required this.icon,
    required this.color,
  });
}

const demoStories = <StoryItem>[
  StoryItem(title: 'Выплаты', icon: Icons.payments_outlined, color: Color(0xFF0FA36B)),
  StoryItem(title: 'Документы', icon: Icons.badge_outlined, color: Color(0xFF6366F1)),
  StoryItem(title: 'Медкнижка', icon: Icons.local_hospital_outlined, color: Color(0xFFEC4899)),
  StoryItem(title: 'Правила', icon: Icons.gavel_outlined, color: Color(0xFFF97316)),
  StoryItem(title: 'Рейтинг', icon: Icons.star_outline, color: Color(0xFFF59E0B)),
  StoryItem(title: 'Поддержка', icon: Icons.chat_bubble_outline, color: Color(0xFF0EA5E9)),
];

/// Лента круглых подсказок — как «истории» в соцсетях.
/// Пока просто оформление: экранов за ними ещё нет.
class StoriesRow extends StatelessWidget {
  const StoriesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: demoStories.length,
        itemBuilder: (context, index) {
          final story = demoStories[index];

          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Кольцо-градиент вокруг иконки — тот самый приём,
                    // который делает ленту похожей на «истории».
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        story.color,
                        Color.lerp(story.color, Colors.white, 0.55)!,
                      ],
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: GlassTokens.of(context).strongFill,
                    ),
                    child: Icon(story.icon, size: 24, color: story.color),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  story.title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
