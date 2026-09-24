import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:fastwork_core/category.dart';
import 'package:fastwork_core/mrp.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/user.dart';
import '../widgets/category_icon.dart';

// Детали, из которых собраны картинки историй.
//
// История всегда лежит на своём ярком фоне — цвет истории, уходящий в
// темноту, — в светлой теме приложения и в тёмной одинаково. Поэтому
// здесь нет цветов темы: текст белый, панели — белое стекло поверх
// цвета. Так истории выглядят одним целым, как обложки одного журнала.
//
// Картинки не нарисованы заранее, а собраны из виджетов. Зато числа на
// них настоящие: комиссия, МРП, лимит, минимальный вывод берутся из тех
// же констант, что и правила в ядре. Поменяли МРП — поменялась картинка.

Color _white(double alpha) => Colors.white.withValues(alpha: alpha);

const _titleStyle = TextStyle(
  color: Colors.white,
  fontSize: 15,
  fontWeight: FontWeight.w800,
  height: 1.25,
);

TextStyle _captionStyle([double alpha = 0.78]) => TextStyle(
      color: _white(alpha),
      fontSize: 12.5,
      fontWeight: FontWeight.w600,
      height: 1.3,
    );

/// Панель из белого стекла — основа всех картинок.
class StoryPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const StoryPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(22));
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter.grouped(
        filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            color: _white(0.14),
            border: Border.all(color: _white(0.28)),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Появление по очереди: снизу вверх и из прозрачности.
///
/// Картинка собирается на глазах — шаг за шагом, — и глаз успевает
/// прочитать её в том порядке, в каком она задумана.
class Reveal extends StatelessWidget {
  final int index;
  final Widget child;

  const Reveal({super.key, required this.index, required this.child});

  static const _moveMs = 420;
  static const _stepMs = 110;

  @override
  Widget build(BuildContext context) {
    final delay = _stepMs * index;
    final total = _moveMs + delay;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      curve: Interval(delay / total, 1, curve: Curves.easeOutCubic),
      child: child,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 18 * (1 - t)),
          child: child,
        ),
      ),
    );
  }
}

/// Кружок со значком. Главный — белый, остальные — стеклянные.
class _Badge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool filled;
  final double size;

  const _Badge({
    required this.icon,
    required this.color,
    this.filled = true,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? Colors.white : _white(0.18),
          border: filled ? null : Border.all(color: _white(0.35)),
        ),
        child: Icon(
          icon,
          size: size * 0.5,
          color: filled ? color : Colors.white,
        ),
      );
}

/// Строка списка: значок, заголовок, подпись и, если нужно, ярлык справа.
class StepItem {
  final IconData icon;
  final String title;
  final String? caption;
  final String? tag;

  const StepItem(this.icon, this.title, {this.caption, this.tag});
}

/// Список шагов или пунктов.
///
/// `connected` — шаги связаны линией: это последовательность, «сначала,
/// потом». Без линии — просто перечень равноправных случаев.
class StepList extends StatelessWidget {
  final List<StepItem> items;
  final Color color;
  final bool connected;

  const StepList({
    super.key,
    required this.items,
    required this.color,
    this.connected = true,
  });

  @override
  Widget build(BuildContext context) {
    return StoryPanel(
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            Reveal(
              index: i,
              child: _row(items[i], last: i == items.length - 1),
            ),
        ],
      ),
    );
  }

  Widget _row(StepItem item, {required bool last}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                _Badge(icon: item.icon, color: color),
                if (!last)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: connected ? _white(0.4) : Colors.transparent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 2, bottom: last ? 0 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: _titleStyle),
                  if (item.caption != null) ...[
                    const SizedBox(height: 3),
                    Text(item.caption!, style: _captionStyle()),
                  ],
                ],
              ),
            ),
          ),
          if (item.tag != null) ...[
            const SizedBox(width: 8),
            Align(
              alignment: Alignment.topCenter,
              child: _Pill(text: item.tag!, color: color),
            ),
          ],
        ],
      ),
    );
  }
}

/// Белая «таблетка» с текстом цвета истории.
class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const _Pill({required this.text, required this.color, this.icon});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
}

/// Участник движения денег: заказчик, сервис, исполнитель.
class MoneyNode {
  final IconData icon;
  final String label;
  final String? amount;
  final bool highlight;

  const MoneyNode(this.icon, this.label, {this.amount, this.highlight = false});
}

/// Путь денег слева направо, с подписями над стрелками.
class MoneyFlow extends StatelessWidget {
  final List<MoneyNode> nodes;

  /// Подписи над стрелками. Их на одну меньше, чем участников.
  final List<String> links;
  final Color color;

  const MoneyFlow({
    super.key,
    required this.nodes,
    required this.links,
    required this.color,
  }) : assert(links.length == nodes.length - 1);

  @override
  Widget build(BuildContext context) {
    return StoryPanel(
      padding: const EdgeInsets.fromLTRB(8, 18, 8, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < nodes.length; i++) ...[
            Expanded(
              flex: 3,
              child: Reveal(index: i * 2, child: _node(nodes[i])),
            ),
            if (i < links.length)
              Expanded(
                flex: 2,
                child: Reveal(index: i * 2 + 1, child: _arrow(links[i])),
              ),
          ],
        ],
      ),
    );
  }

  Widget _node(MoneyNode node) => Column(
        children: [
          _Badge(
            icon: node.icon,
            color: color,
            filled: node.highlight,
            size: 52,
          ),
          const SizedBox(height: 8),
          Text(
            node.label,
            textAlign: TextAlign.center,
            style: _titleStyle.copyWith(fontSize: 13),
          ),
          if (node.amount != null) ...[
            const SizedBox(height: 2),
            Text(
              node.amount!,
              textAlign: TextAlign.center,
              style: _captionStyle(0.85),
            ),
          ],
        ],
      );

  Widget _arrow(String caption) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          children: [
            Text(
              caption,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: _captionStyle(0.8).copyWith(fontSize: 10.5),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: Container(height: 2, color: _white(0.6))),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 12, color: _white(0.8)),
              ],
            ),
          ],
        ),
      );
}

/// Часть суммы для полосы-разбивки.
class SplitPart {
  final String label;
  final int amount;
  final Color color;
  final String? note;

  const SplitPart(this.label, this.amount, this.color, {this.note});
}

/// Из чего складывается сумма: полоса и расшифровка под ней.
///
/// Полоса честная — доли в ней по настоящим суммам. Комиссия в 4% на ней
/// тонкая полоска, и это как раз то, что нужно увидеть.
class SplitBar extends StatelessWidget {
  final String header;
  final List<SplitPart> parts;

  const SplitBar({super.key, required this.header, required this.parts});

  @override
  Widget build(BuildContext context) {
    final total = parts.fold<int>(0, (sum, p) => sum + p.amount);

    return StoryPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: _captionStyle(0.8).copyWith(fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            formatMoney(total),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 14),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, t, child) => Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(widthFactor: t, child: child),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 14,
                child: Row(
                  // Без stretch полоски были бы нулевой высоты: пустой
                  // ColoredBox берёт самый маленький размер из разрешённых.
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final p in parts)
                      Expanded(
                        flex: math.max(1, p.amount * 1000 ~/ total),
                        child: ColoredBox(color: p.color),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < parts.length; i++)
            Reveal(
              index: i + 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: parts[i].color,
                        shape: BoxShape.circle,
                        border: Border.all(color: _white(0.6)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            parts[i].label,
                            style: _titleStyle.copyWith(fontSize: 14),
                          ),
                          if (parts[i].note != null)
                            Text(parts[i].note!, style: _captionStyle(0.7)),
                        ],
                      ),
                    ),
                    Text(
                      formatMoney(parts[i].amount),
                      style: _titleStyle.copyWith(fontSize: 14),
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

/// Одно крупное число с подписью: «0 ₸», «4%».
class BigFigure extends StatelessWidget {
  final String value;
  final String caption;
  final IconData? icon;
  final Color color;

  const BigFigure({
    super.key,
    required this.value,
    required this.caption,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Reveal(
            index: 0,
            child: _Badge(icon: icon!, color: color, size: 68),
          ),
          const SizedBox(height: 14),
        ],
        Reveal(
          index: 1,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.w800,
              letterSpacing: -2,
              height: 1.05,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Reveal(
          index: 2,
          child: Text(
            caption,
            textAlign: TextAlign.center,
            style: _captionStyle(0.85).copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

/// Слагаемое в «уравнении»: крупное значение и подпись к нему.
class EquationTerm {
  final String value;
  final String caption;

  const EquationTerm(this.value, this.caption);
}

/// Расчёт столбиком: «300 МРП × 4 325 ₸ = 1 297 500 ₸».
///
/// Столбиком, а не в строку: в строку три суммы на экран телефона не
/// влезают, а мелко набранный итог не запоминается.
class EquationStack extends StatelessWidget {
  final List<EquationTerm> terms;

  /// Знаки между слагаемыми: «×», «=».
  final List<String> operators;
  final Color color;

  const EquationStack({
    super.key,
    required this.terms,
    required this.operators,
    required this.color,
  }) : assert(operators.length == terms.length - 1);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < terms.length; i++) ...[
          Reveal(
            index: i * 2,
            child: _term(terms[i], result: i == terms.length - 1),
          ),
          if (i < operators.length)
            Reveal(
              index: i * 2 + 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  operators[i],
                  style: TextStyle(
                    color: _white(0.85),
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _term(EquationTerm term, {required bool result}) {
    final content = Row(
      children: [
        // Сумма не переносится и не обрезается — на узком экране она
        // становится чуть мельче.
        Flexible(
          flex: 3,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              term.value,
              style: TextStyle(
                color: result ? color : Colors.white,
                fontSize: result ? 28 : 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            term.caption,
            textAlign: TextAlign.right,
            style: result
                ? TextStyle(
                    color: color.withValues(alpha: 0.85),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  )
                : _captionStyle(),
          ),
        ),
      ],
    );

    if (!result) return StoryPanel(child: content);

    // Итог — на белом: это то, что нужно запомнить.
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: content,
    );
  }
}

/// Столбики по годам — как менялся МРП.
class YearBars extends StatelessWidget {
  final List<MrpRate> rates;

  const YearBars({super.key, required this.rates});

  @override
  Widget build(BuildContext context) {
    final sorted = [...rates]
      ..sort((a, b) => a.validFrom.compareTo(b.validFrom));
    // Последние три года: больше на экран телефона не влезает крупно.
    final shown =
        sorted.length > 3 ? sorted.sublist(sorted.length - 3) : sorted;
    final top = shown.map((r) => r.amount).reduce(math.max);

    return StoryPanel(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      child: SizedBox(
        height: 210,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < shown.length; i++)
              Expanded(
                child: _bar(
                  shown[i],
                  fraction: shown[i].amount / top,
                  current: i == shown.length - 1,
                  index: i,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _bar(
    MrpRate rate, {
    required double fraction,
    required bool current,
    required int index,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          formatMoney(rate.amount),
          style: _titleStyle.copyWith(fontSize: 13.5),
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: fraction),
          duration: Duration(milliseconds: 700 + index * 150),
          curve: Curves.easeOutCubic,
          builder: (context, t, _) => Container(
            width: 46,
            height: 140 * t,
            decoration: BoxDecoration(
              color: current ? Colors.white : _white(0.32),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
                bottom: Radius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('${rate.validFrom.year}', style: _captionStyle(0.85)),
      ],
    );
  }
}

/// Кольцо-шкала: сколько из целого уже занято.
class RingGauge extends StatelessWidget {
  final double fraction;
  final String value;
  final String caption;
  final double size;

  const RingGauge({
    super.key,
    required this.fraction,
    required this.value,
    required this.caption,
    this.size = 132,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: fraction.clamp(0, 1).toDouble()),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => CustomPaint(
        painter: _RingPainter(t),
        child: child,
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              Text(caption, style: _captionStyle().copyWith(fontSize: 11.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double fraction;

  _RingPainter(this.fraction);

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 12.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = _white(0.2);
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    canvas.drawArc(rect, 0, math.pi * 2, false, track);
    if (fraction > 0) {
      canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * fraction, false, arc);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.fraction != fraction;
}

/// Лимит месяца — настоящий, из хранилища.
///
/// Пока лимит едет, показываем кольцо на нуле, а не пустоту. Не приехал
/// совсем (нет сети, заказчик) — показываем, сколько лимит в этом году:
/// это число верно для всех.
class LimitMeter extends StatelessWidget {
  final Future<EarningsLimit?>? limit;

  const LimitMeter({super.key, required this.limit});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EarningsLimit?>(
      future: limit,
      builder: (context, snapshot) {
        final value = snapshot.data;
        if (value == null) {
          final now = DateTime.now();
          final yearLimit = monthlyEarningsLimit(now, kMrpHistory);
          return StoryPanel(
            child: Row(
              children: [
                const RingGauge(
                  fraction: 0,
                  value: '0%',
                  caption: 'лимита',
                  size: 116,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Лимит на ${formatMonth(monthOf(now))}',
                          style: _captionStyle()),
                      const SizedBox(height: 4),
                      Text(formatMoney(yearLimit), style: _titleStyle),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.connectionState == ConnectionState.waiting
                            ? 'Считаем ваш месяц…'
                            : 'Ваш прогресс — в «Выплатах»',
                        style: _captionStyle(0.7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final percent = (value.fraction * 100).round();
        return StoryPanel(
          child: Row(
            children: [
              RingGauge(
                fraction: value.fraction,
                value: '$percent%',
                caption: 'лимита',
                size: 116,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formatMonth(value.month), style: _captionStyle()),
                    const SizedBox(height: 8),
                    _pair('Отработано', value.earned),
                    _pair('Записаны', value.booked),
                    const Divider(color: Colors.white24, height: 14),
                    _pair('Осталось', value.remaining, strong: true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _pair(String label, int amount, {bool strong = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Expanded(child: Text(label, style: _captionStyle(0.85))),
            const SizedBox(width: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  formatMoney(amount),
                  style: _titleStyle.copyWith(fontSize: strong ? 15 : 13),
                ),
              ),
            ),
          ],
        ),
      );
}

/// Цепочка состояний слева направо: «загружен → на проверке → принят».
///
/// Последнее состояние белое — это цель, до которой всё идёт.
class StatusChain extends StatelessWidget {
  final List<StepItem> steps;
  final Color color;

  const StatusChain({super.key, required this.steps, required this.color});

  @override
  Widget build(BuildContext context) {
    return StoryPanel(
      padding: const EdgeInsets.fromLTRB(8, 18, 8, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < steps.length; i++)
            Expanded(
              child: Reveal(
                index: i,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            color: i == 0 ? Colors.transparent : _white(0.45),
                          ),
                        ),
                        _Badge(
                          icon: steps[i].icon,
                          color: color,
                          filled: i == steps.length - 1,
                          size: 46,
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: i == steps.length - 1
                                ? Colors.transparent
                                : _white(0.45),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        steps[i].title,
                        textAlign: TextAlign.center,
                        style: _titleStyle.copyWith(fontSize: 12.5),
                      ),
                    ),
                    if (steps[i].caption != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        steps[i].caption!,
                        textAlign: TextAlign.center,
                        style: _captionStyle(0.7).copyWith(fontSize: 11),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Лестница уровней: чем выше уровень, тем длиннее ступень.
///
/// Если человек известен — его ступень белая, а под лестницей написано,
/// сколько осталось до следующей.
class LevelLadder extends StatelessWidget {
  final AppUser? user;
  final Color color;

  const LevelLadder({super.key, required this.user, required this.color});

  @override
  Widget build(BuildContext context) {
    final shifts = user?.completedShifts;
    final current = shifts == null ? null : workerLevelFor(shifts);
    final next = user?.nextLevel;

    return StoryPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < kWorkerLevels.length; i++)
            Reveal(
              index: i,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: _step(
                  kWorkerLevels[i],
                  i,
                  mine: kWorkerLevels[i].name == current?.name,
                ),
              ),
            ),
          if (shifts != null) ...[
            const SizedBox(height: 10),
            Reveal(
              index: kWorkerLevels.length,
              child: Text(
                next == null
                    ? 'У вас высший уровень — $shifts смен'
                    : 'У вас $shifts смен. До уровня «${next.name}» — '
                        'ещё ${next.minShifts - shifts}',
                style: _captionStyle(0.85).copyWith(fontSize: 13),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _step(WorkerLevel level, int index, {required bool mine}) {
    return Row(
      children: [
        SizedBox(
          width: 94,
          child: Text(
            level.name,
            style: _titleStyle.copyWith(fontSize: 14),
          ),
        ),
        Expanded(
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.4 + 0.2 * index,
            child: Container(
              height: 32,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: mine ? Colors.white : _white(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                mine
                    ? 'вы здесь'
                    : level.minShifts == 0
                        ? 'с первой смены'
                        : 'от ${level.minShifts} смен',
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  color: mine ? color : _white(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Перечень с отметками: ✓ — можно или стоит, ✕ — нельзя.
class CheckList extends StatelessWidget {
  final List<String> items;
  final String? header;
  final bool positive;
  final Color color;

  const CheckList({
    super.key,
    required this.items,
    required this.color,
    this.header,
    this.positive = true,
  });

  @override
  Widget build(BuildContext context) {
    return StoryPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) ...[
            Text(
              header!.toUpperCase(),
              style: _captionStyle(0.75).copyWith(
                fontSize: 11.5,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
          ],
          for (var i = 0; i < items.length; i++)
            Reveal(
              index: i,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: positive ? Colors.white : _white(0.18),
                        border:
                            positive ? null : Border.all(color: _white(0.5)),
                      ),
                      child: Icon(
                        positive ? Icons.check_rounded : Icons.close_rounded,
                        size: 16,
                        color: positive ? color : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          items[i],
                          style: _titleStyle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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

/// «Можно» и «нельзя» друг под другом.
class DoDont extends StatelessWidget {
  final List<String> dos;
  final List<String> donts;
  final Color color;

  const DoDont({
    super.key,
    required this.dos,
    required this.donts,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckList(items: dos, header: 'Можно', color: color),
          const SizedBox(height: 12),
          CheckList(
            items: donts,
            header: 'Нельзя',
            positive: false,
            color: color,
          ),
        ],
      );
}

/// Облако категорий работ — со значками, как в ленте.
class CategoryCloud extends StatelessWidget {
  final List<String> categoryIds;

  const CategoryCloud({super.key, required this.categoryIds});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < categoryIds.length; i++)
          Reveal(
            index: i ~/ 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _white(0.16),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: _white(0.32)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(categoryIcon(categoryIds[i]),
                      size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      categoryById(categoryIds[i]).name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _titleStyle.copyWith(fontSize: 13),
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

/// Пять звёзд и средняя оценка.
class StarsRating extends StatelessWidget {
  final double rating;
  final String caption;

  const StarsRating({super.key, required this.rating, required this.caption});

  @override
  Widget build(BuildContext context) {
    IconData star(int i) {
      if (rating >= i + 0.75) return Icons.star_rounded;
      if (rating >= i + 0.25) return Icons.star_half_rounded;
      return Icons.star_outline_rounded;
    }

    return StoryPanel(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 5; i++)
                Reveal(
                  index: i,
                  child: Icon(star(i), size: 44, color: Colors.white),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Reveal(
            index: 5,
            child: Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 44,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.5,
              ),
            ),
          ),
          Reveal(
            index: 6,
            child: Text(
              caption,
              textAlign: TextAlign.center,
              style: _captionStyle(0.85).copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Шкала рейтинга от 1 до 5: где порог смены и где вы.
class ThresholdScale extends StatelessWidget {
  final double threshold;
  final double? userRating;
  final Color color;

  const ThresholdScale({
    super.key,
    required this.threshold,
    required this.userRating,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final mine = userRating;
    final open = mine != null && mine >= threshold;

    return StoryPanel(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_outline_rounded, size: 18, color: _white(0.9)),
              const SizedBox(width: 6),
              Text(
                'Смена от ${threshold.toStringAsFixed(1)}',
                style: _titleStyle,
              ),
            ],
          ),
          const SizedBox(height: 34),
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              double x(double r) => (r - 1) / 4 * w;

              return SizedBox(
                height: 44,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: _white(0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    // Зона допуска — от порога до пятёрки.
                    Positioned(
                      left: x(threshold),
                      right: 0,
                      top: 0,
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    for (final r in [1, 2, 3, 4, 5])
                      Positioned(
                        left: x(r.toDouble()) - 10,
                        width: 20,
                        top: 20,
                        child: Text(
                          '$r',
                          textAlign: TextAlign.center,
                          style: _captionStyle(0.7),
                        ),
                      ),
                    if (mine != null)
                      Positioned(
                        left: x(mine.clamp(1, 5).toDouble()) - 22,
                        width: 44,
                        top: -30,
                        child: Column(
                          children: [
                            _Pill(text: 'вы', color: color),
                            Container(
                              width: 2,
                              height: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          if (mine != null) ...[
            const SizedBox(height: 4),
            Text(
              open
                  ? 'Ваш рейтинг ${mine.toStringAsFixed(1)} — смена открыта'
                  : 'Ваш рейтинг ${mine.toStringAsFixed(1)} — пока закрыта',
              style: _captionStyle(0.9).copyWith(fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}

/// Переписка с поддержкой — как она выглядит.
class ChatPreview extends StatelessWidget {
  /// `true` — сообщение от человека, `false` — ответ поддержки.
  final List<(bool, String)> messages;
  final Color color;

  const ChatPreview({super.key, required this.messages, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < messages.length; i++)
          Reveal(
            index: i * 2,
            child: Align(
              alignment: messages[i].$1
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 270),
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: messages[i].$1 ? Colors.white : _white(0.18),
                  border: messages[i].$1
                      ? null
                      : Border.all(color: _white(0.3)),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(messages[i].$1 ? 18 : 4),
                    bottomRight: Radius.circular(messages[i].$1 ? 4 : 18),
                  ),
                ),
                child: Text(
                  messages[i].$2,
                  style: TextStyle(
                    color: messages[i].$1
                        ? Color.lerp(color, Colors.black, 0.35)
                        : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Карточка смены «как в ленте» — чтобы показать, куда смотреть.
class MiniShiftCard extends StatelessWidget {
  final Shift shift;
  final Color color;

  const MiniShiftCard({super.key, required this.shift, required this.color});

  @override
  Widget build(BuildContext context) {
    return StoryPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Reveal(
            index: 0,
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    shift.company.characters.first,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shift.company, style: _titleStyle),
                      Text(
                        '${formatTime(shift.startMinutes)} — '
                        '${formatTime(shift.endMinutes)} · '
                        '${formatDuration(shift.durationMinutes)}',
                        style: _captionStyle(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Reveal(
            index: 1,
            child: Text(
              formatMoney(shift.totalPay),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Reveal(
            index: 2,
            child: _line(categoryIcon(shift.category), shift.title),
          ),
          Reveal(index: 3, child: _line(Icons.place_outlined, shift.address)),
          const SizedBox(height: 12),
          Reveal(
            index: 4,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _Pill(
                  text: 'Оплата гарантирована',
                  icon: Icons.verified_user_rounded,
                  color: color,
                ),
                for (final tag in shift.tags) _Pill(text: tag, color: color),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Icon(icon, size: 16, color: _white(0.85)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: _captionStyle(0.9).copyWith(fontSize: 13.5),
              ),
            ),
          ],
        ),
      );
}

/// Банковская карта — как она выглядит у нас: только последние цифры.
class CardMock extends StatelessWidget {
  final String caption;

  const CardMock({super.key, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Reveal(
      index: 0,
      child: AspectRatio(
        aspectRatio: 1.62,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_white(0.42), _white(0.12)],
            ),
            border: Border.all(color: _white(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _white(0.55),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.contactless_rounded,
                      color: Colors.white, size: 26),
                ],
              ),
              const Spacer(),
              const Text(
                '••••  ••••  ••••  4242',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(caption, style: _captionStyle(0.85)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Листок календаря: «когда следующий медосмотр».
class CalendarTile extends StatelessWidget {
  final String month;
  final String day;
  final String caption;
  final Color color;

  const CalendarTile({
    super.key,
    required this.month,
    required this.day,
    required this.caption,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Reveal(
      index: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 132,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: color,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    month.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    day,
                    style: TextStyle(
                      color: Color.lerp(color, Colors.black, 0.4),
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: _captionStyle(0.85).copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
