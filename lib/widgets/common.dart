import 'package:flutter/material.dart';
import 'package:fastwork_core/category.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/glass.dart';
import 'category_icon.dart';

/// Логотип-надпись. Две части разного цвета — простой приём, который
/// превращает обычный текст в узнаваемый знак.
class Wordmark extends StatelessWidget {
  final double size;

  const Wordmark({super.key, this.size = 22});

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: size,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
        children: [
          TextSpan(text: 'fast', style: TextStyle(color: ink)),
          const TextSpan(
            text: 'work',
            style: TextStyle(color: AppColors.brand),
          ),
        ],
      ),
    );
  }
}

/// Кружок с первой буквой названия компании вместо логотипа.
class CompanyAvatar extends StatelessWidget {
  final String company;
  final double size;

  const CompanyAvatar({super.key, required this.company, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forCompany(company);
    final letter = company.isEmpty ? '?' : company.characters.first;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, Colors.black, 0.25)!],
        ),
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Text(
        letter.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.42,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

/// Маленький ярлык-пилюля: «Ночная», «Выплата завтра».
class TagChip extends StatelessWidget {
  final String text;
  final Color? color;
  final IconData? icon;

  const TagChip({super.key, required this.text, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ?? (isDark ? AppColors.darkBody : AppColors.body);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: isDark ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: c),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: c,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ярлык категории работ: значок и название.
///
/// Отдельный виджет, а не `TagChip` с параметрами в каждом месте: категорию
/// показывают карточка, экран смены и форма заказчика, и выглядеть она
/// должна везде одинаково.
class CategoryChip extends StatelessWidget {
  final String category;

  const CategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) => TagChip(
        text: categoryById(category).name,
        icon: categoryIcon(category),
        color: AppColors.brand,
      );
}

/// Ярлык «оплата гарантирована»: заказчик уже внёс деньги.
class GuaranteeChip extends StatelessWidget {
  const GuaranteeChip({super.key});

  @override
  Widget build(BuildContext context) => const TagChip(
        text: 'Оплата гарантирована',
        icon: Icons.verified_user_rounded,
        color: AppColors.success,
      );
}

/// Карточка из стекла — основа всей вёрстки.
///
/// Раньше это была белая плашка с тенью. Теперь — матовое стекло: сквозь
/// неё виден размытый живой фон. Экраны этого не заметили: они как
/// создавали `SurfaceCard`, так и создают, а поменялся один этот класс.
class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Glass(
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Строка «иконка + текст» с приглушённой иконкой в мягком квадрате.
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;

  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = iconColor ?? AppColors.brand;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.withValues(alpha: isDark ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: c),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      height: 1.35,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Заголовок раздела на экране «Подробнее».
class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.brand),
        const SizedBox(width: 8),
        // Expanded не даёт длинному заголовку вылезти за край карточки.
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
      ],
    );
  }
}

/// Экран-заглушка, когда показывать нечего.
/// Пустой экран без объяснения выглядит как сломанное приложение.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brand.withValues(alpha: 0.10),
              ),
              child: Icon(icon, size: 44, color: AppColors.brand),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Экран ошибки с кнопкой «Повторить».
///
/// Главное здесь — кнопка. Сообщение об ошибке без способа её исправить
/// оставляет человека в тупике: он видит, что сломалось, и ничего не
/// может сделать. Одна кнопка превращает тупик в неудобство.
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Не получилось загрузить',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, height: 1.4),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Плавное появление элемента списка: снизу вверх и из прозрачности.
///
/// `index` задаёт задержку, поэтому карточки появляются не разом, а
/// волной — глаз успевает проследить за списком, и он ощущается живым.
/// Задержку ограничиваем шестым элементом: на длинном списке ждать
/// секунду недопустимо.
///
/// Задержка сделана без таймеров — через `Interval`. Анимация у всех
/// карточек длится одинаково, но каждая следующая начинает двигаться
/// чуть позже: до своего отрезка кривая держит значение на нуле.
class AnimatedEntrance extends StatelessWidget {
  final int index;
  final Widget child;

  const AnimatedEntrance({super.key, required this.index, required this.child});

  static const _moveMs = 320;
  static const _stepMs = 55;
  static const _maxSteps = 6;
  static const _totalMs = _moveMs + _stepMs * _maxSteps;

  @override
  Widget build(BuildContext context) {
    final start = (_stepMs * index.clamp(0, _maxSteps)) / _totalMs;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: _totalMs),
      curve: Interval(start, start + _moveMs / _totalMs,
          curve: Curves.easeOutCubic),
      child: child,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - t)),
          child: child,
        ),
      ),
    );
  }
}

/// Число, которое «докручивается» до значения вместо мгновенной подстановки.
///
/// Сумма, выросшая на глазах, читается как результат — в отличие от числа,
/// которое просто оказалось на экране.
class AnimatedNumber extends StatelessWidget {
  final int value;
  final String Function(int) format;
  final TextStyle? style;

  const AnimatedNumber({
    super.key,
    required this.value,
    required this.format,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Text(format(v.round()), style: style),
    );
  }
}
