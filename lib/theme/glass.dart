import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// «Жидкое стекло» — основа нового вида приложения.
///
/// Идея стиля простая: под интерфейсом лежит живой цветной фон, а
/// карточки, меню и окна сделаны из матового стекла — сквозь них фон
/// виден размытым. Глубина получается не из теней, а из того, что лежит
/// «под» стеклом.
///
/// Три детали отличают стекло от просто полупрозрачной плашки:
///   1. **Размытие** того, что под ним, — `BackdropFilter`.
///   2. **Блик** — светлая кромка сверху-слева, будто на край падает свет.
///   3. **Мягкая заливка** — белая дымка, чтобы текст читался на любом фоне.
///
/// Всё это собрано здесь, в одном файле. Экраны берут готовые `Glass`,
/// `GlassSheet` и `LiquidBackground` и ничего не знают про размытие —
/// так же, как не знают про SQL.
class GlassTokens {
  final Color fill;
  final Color strongFill;
  final Color edge;
  final Color edgeFaint;
  final Color sheen;
  final Color shadow;

  const GlassTokens._({
    required this.fill,
    required this.strongFill,
    required this.edge,
    required this.edgeFaint,
    required this.sheen,
    required this.shadow,
  });

  static const _light = GlassTokens._(
    fill: Color(0x99FFFFFF), // 60% белого — текст читается на любом пятне
    strongFill: Color(0xD9FFFFFF), // для окон поверх экрана
    edge: Color(0xE6FFFFFF),
    edgeFaint: Color(0x40FFFFFF),
    sheen: Color(0x66FFFFFF),
    shadow: Color(0x1A0F3D2E),
  );

  static const _dark = GlassTokens._(
    fill: Color(0x1FFFFFFF), // в темноте стекло — лёгкая светлая дымка
    strongFill: Color(0xCC141B26),
    edge: Color(0x40FFFFFF),
    edgeFaint: Color(0x0DFFFFFF),
    sheen: Color(0x1AFFFFFF),
    shadow: Color(0x66000000),
  );

  static GlassTokens of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _dark : _light;
}

/// Насколько размывать то, что под стеклом.
const _blurSigma = 22.0;

/// Кусок стекла произвольной формы.
///
/// Размытие берётся «групповое» (`BackdropFilter.grouped`): если на экране
/// двадцать карточек, движок размоет фон один раз, а не двадцать. Без
/// этого длинная лента на недорогом телефоне начала бы подтормаживать.
class Glass extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;

  /// Плотнее заливка — для того, что лежит поверх другого стекла.
  final bool strong;

  /// Тень под стеклом. Плавающим элементам — меню, кнопкам — нужна,
  /// карточкам в ленте хватает кромки.
  final bool elevated;

  const Glass({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding,
    this.strong = false,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlassTokens.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: t.shadow,
            blurRadius: elevated ? 30 : 18,
            offset: Offset(0, elevated ? 12 : 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter.grouped(
          filter: ui.ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
          child: CustomPaint(
            // Кромку рисуем поверх содержимого: иначе её закрыл бы любой
            // цветной блок внутри, например зелёная шапка с суммой.
            foregroundPainter: _GlassEdgePainter(
              radius: borderRadius,
              edge: t.edge,
              edgeFaint: t.edgeFaint,
            ),
            child: DecoratedBox(
              // Сначала дымка — она и делает стекло матовым.
              decoration: BoxDecoration(
                color: strong ? t.strongFill : t.fill,
              ),
              child: DecoratedBox(
                // Поверх дымки — блик: верх светлее низа, как у стекла под
                // лампой. Содержимое лежит выше блика, и цветные блоки
                // внутри карточки он не засвечивает.
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [t.sheen, t.sheen.withValues(alpha: 0)],
                    stops: const [0, 0.45],
                  ),
                ),
                child: padding == null
                    ? child
                    : Padding(padding: padding!, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Кромка стекла: яркая сверху-слева, едва заметная снизу-справа.
///
/// Обычная рамка одного цвета выглядит как контур из пластика. Свет,
/// «стекающий» по краю, — то, что делает плашку стеклом.
class _GlassEdgePainter extends CustomPainter {
  final BorderRadius radius;
  final Color edge;
  final Color edgeFaint;

  _GlassEdgePainter({
    required this.radius,
    required this.edge,
    required this.edgeFaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = radius.toRRect(rect).deflate(0.6);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [edge, edgeFaint, edgeFaint, edge.withValues(alpha: 0.35)],
        stops: const [0, 0.35, 0.8, 1],
      ).createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_GlassEdgePainter old) =>
      old.edge != edge || old.edgeFaint != edgeFaint || old.radius != radius;
}

/// Живой фон под стеклом.
///
/// Цветные пятна нарисованы радиальными градиентами, а не размытием:
/// градиент уже мягкий сам по себе и ничего не стоит перерисовать.
/// Фон неподвижен нарочно — движущийся фон за текстом утомляет, а в
/// тестах бесконечная анимация не дала бы экрану «успокоиться».
///
/// Каждый экран кладёт такой фон под себя сам. Общий фон на всё
/// приложение не годится: при переходе новый экран проявляется поверх
/// старого, и сквозь прозрачный фон было бы видно оба сразу.
class LiquidBackground extends StatelessWidget {
  final Widget child;

  const LiquidBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? AppColors.darkBg : const Color(0xFFEFF6F3);

    Widget blob(Alignment at, Color color, double size, double alpha) =>
        Align(
          alignment: at,
          child: FractionallySizedBox(
            widthFactor: size,
            heightFactor: size * 0.75,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: alpha),
                    color.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        );

    final a = isDark ? 0.34 : 0.45;

    return ColoredBox(
      color: base,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Пятна — фирменный изумруд и его соседи по кругу цветов.
          // Они и дают стеклу, что показывать сквозь себя.
          blob(const Alignment(-1.1, -0.95), AppColors.brand, 1.3, a),
          blob(const Alignment(1.2, -0.55), const Color(0xFF38BDF8), 1.1, a),
          blob(const Alignment(-1.0, 0.35), const Color(0xFFA78BFA), 1.0,
              a * 0.8),
          blob(const Alignment(1.1, 0.95), const Color(0xFFFBBF24), 1.1,
              a * 0.7),
          blob(const Alignment(0.2, 1.3), AppColors.brand, 1.2, a * 0.8),
          // BackdropGroup — чтобы все стёкла экрана размывали фон разом.
          BackdropGroup(child: child),
        ],
      ),
    );
  }
}

/// Нижнее окно из стекла — для фильтра, оплаты, выбора категории.
///
/// Заливка плотнее, чем у карточек: окно лежит поверх экрана со своими
/// карточками, и сквозь слишком прозрачное стекло они мешали бы читать.
class GlassSheet extends StatelessWidget {
  final Widget child;

  const GlassSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.vertical(top: Radius.circular(30));
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Material(
          color: GlassTokens.of(context).strongFill,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ),
    );
  }
}

/// «Ручка» окна сверху — подсказывает, что окно можно смахнуть.
class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 40,
          height: 5,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.muted.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      );
}

/// Заливка полей ввода и мелких «таблеток» — та же, что у полей в теме.
Color glassFieldFill(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.65);

/// Кромка полей ввода и «таблеток».
Color glassFieldEdge(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.9);
