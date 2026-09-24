import 'package:flutter/material.dart';

import '../data/app_preferences.dart';
import '../stories/story.dart';
import '../theme/app_colors.dart';
import '../theme/glass.dart';

/// Лента кружков-историй вверху главного экрана.
///
/// Цветное кольцо — историю ещё не смотрели, серое — уже видели. Порядок
/// не меняется: это справочник, и «Выплаты» должны лежать там же, где
/// лежали вчера.
class StoriesRow extends StatelessWidget {
  final List<Story> stories;
  final AppPreferences preferences;
  final ValueChanged<int> onOpen;

  const StoriesRow({
    super.key,
    required this.stories,
    required this.preferences,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    // Слушаем настройки: досмотрел историю — кольцо посерело сразу,
    // без перезагрузки экрана.
    return ListenableBuilder(
      listenable: preferences,
      builder: (context, _) => SizedBox(
        height: 108,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          itemCount: stories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) => _StoryBubble(
            story: stories[index],
            seen: preferences.isStorySeen(stories[index].id),
            onTap: () => onOpen(index),
          ),
        ),
      ),
    );
  }
}

class _StoryBubble extends StatefulWidget {
  final Story story;
  final bool seen;
  final VoidCallback onTap;

  const _StoryBubble({
    required this.story,
    required this.seen,
    required this.onTap,
  });

  @override
  State<_StoryBubble> createState() => _StoryBubbleState();
}

class _StoryBubbleState extends State<_StoryBubble> {
  /// Палец на кружке — он чуть проседает, как настоящая кнопка.
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    final seen = widget.seen;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: seen
          ? 'История «${story.title}»'
          : 'Новая история «${story.title}»',
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: (_) => setState(() => pressed = true),
        onTapCancel: () => setState(() => pressed = false),
        onTapUp: (_) => setState(() => pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: pressed ? 0.92 : 1,
          duration: const Duration(milliseconds: 120),
          child: SizedBox(
            width: 70,
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Кольцо-градиент — тот самый знак «здесь новое»,
                    // знакомый по соцсетям. Просмотренное — тонкое серое.
                    gradient: seen
                        ? null
                        : SweepGradient(
                            colors: [
                              story.color,
                              Color.lerp(story.color, Colors.white, 0.45)!,
                              AppColors.brand,
                              story.color,
                            ],
                          ),
                    border: seen
                        ? Border.all(
                            color: AppColors.muted.withValues(alpha: 0.45),
                            width: 1.5,
                          )
                        : null,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? AppColors.darkBg : Colors.white,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            story.color.withValues(alpha: isDark ? 0.35 : 0.2),
                            GlassTokens.of(context).strongFill,
                          ],
                        ),
                      ),
                      child: Icon(story.icon, size: 26, color: story.color),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  story.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.15,
                    fontWeight: seen ? FontWeight.w600 : FontWeight.w800,
                    color: seen
                        ? AppColors.muted
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
