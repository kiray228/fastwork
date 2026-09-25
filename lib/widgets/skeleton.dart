import 'package:flutter/material.dart';

import '../theme/glass.dart';
import '../theme/app_theme.dart';

/// Серая «косточка» на месте будущего текста.
///
/// Приём называется skeleton — скелет экрана. Пока данные едут, человек
/// видит не пустоту и не кружок посередине, а форму того, что сейчас
/// появится. Ожидание кажется короче, и экран не «прыгает» при загрузке.
class Bone extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const Bone({
    super.key,
    required this.width,
    this.height = 12,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Блик, который бесконечно пробегает по скелету слева направо.
///
/// Анимация здесь не украшение: неподвижный серый макет легко принять за
/// сломанный экран, а движение говорит «идёт работа, подожди».
///
/// `SingleTickerProviderStateMixin` даёт доступ к «тикеру» — часам,
/// которые дёргают анимацию на каждом кадре экрана.
class Shimmer extends StatefulWidget {
  final Widget child;

  const Shimmer({super.key, required this.child});

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    // Контроллер держит тикер. Не освободить его — значит оставить
    // анимацию крутиться после закрытия экрана и тратить батарею.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final highlight = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.white.withValues(alpha: 0.65);

    return AnimatedBuilder(
      animation: controller,
      // child собирается один раз и передаётся в builder готовым:
      // пересчитывать вёрстку на каждом кадре незачем, меняется только блик.
      child: widget.child,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) {
          final t = controller.value * 2 - 0.5;
          return LinearGradient(
            begin: Alignment(t - 0.6, 0),
            end: Alignment(t + 0.6, 0),
            colors: [
              Colors.transparent,
              highlight,
              Colors.transparent,
            ],
          ).createShader(bounds);
        },
        child: child,
      ),
    );
  }
}

/// Скелет одной карточки смены — повторяет её настоящую раскладку.
class ShiftCardSkeleton extends StatelessWidget {
  const ShiftCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: GlassTokens.of(context).fill,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(
          color: glassFieldEdge(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Bone(width: 44, height: 44, radius: 14),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Bone(width: 150, height: 13),
                  SizedBox(height: 8),
                  Bone(width: 90, height: 11),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Bone(width: 200, height: 11),
          const SizedBox(height: 10),
          const Bone(width: 160, height: 11),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Bone(width: 110, height: 20, radius: 10),
              Bone(width: 70, height: 20, radius: 10),
            ],
          ),
        ],
      ),
    );
  }
}

/// Несколько скелетов подряд — то, что показываем вместо списка.
class ShiftListSkeleton extends StatelessWidget {
  final int count;

  /// Скелет внутри другого списка — берёт высоту по содержимому, а не
  /// весь экран.
  final bool shrinkWrap;

  const ShiftListSkeleton({super.key, this.count = 3, this.shrinkWrap = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        shrinkWrap: shrinkWrap,
        // Скелет не листают — он живёт меньше секунды.
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          for (var i = 0; i < count; i++) const ShiftCardSkeleton(),
        ],
      ),
    );
  }
}

/// Скелет для простых списков-строк: документы, обращения, отзывы.
class TileListSkeleton extends StatelessWidget {
  final int count;

  const TileListSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          for (var i = 0; i < count; i++)
            Container(
              height: 76,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: GlassTokens.of(context).fill,
                borderRadius: BorderRadius.circular(AppTheme.radius),
                border: Border.all(
                  color: glassFieldEdge(context),
                ),
              ),
              child: Row(
                children: const [
                  Bone(width: 44, height: 44, radius: 22),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Bone(width: 140, height: 12),
                      SizedBox(height: 8),
                      Bone(width: 80, height: 10),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
