import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../data/app_preferences.dart';
import 'story.dart';

/// Открыть истории на весь экран, начиная с `initialIndex`.
///
/// Возвращает, куда человек захотел перейти кнопкой внизу слайда, или
/// null, если просто досмотрел или закрыл. Переходит уже тот, кто
/// открывал: он знает хранилища и вкладки, история — нет.
Future<StoryAction?> showStories(
  BuildContext context, {
  required List<Story> stories,
  int initialIndex = 0,
  StoryData? data,
  AppPreferences? preferences,
  bool showActions = true,
}) {
  return Navigator.of(context).push<StoryAction>(
    PageRouteBuilder<StoryAction>(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondary) => StoryViewer(
        stories: stories,
        initialIndex: initialIndex,
        data: data ?? StoryData(),
        preferences: preferences,
        showActions: showActions,
      ),
      // История «вырастает» из кружка, а не выезжает сбоку, как обычный
      // экран: это другой режим, и переход говорит об этом сразу.
      transitionsBuilder: (context, animation, secondary, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween(begin: 0.9, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    ),
  );
}

/// Просмотр историй: как в соцсетях, чтобы учиться было не нужно.
///
///  * слайды листаются сами — у каждого своё время, по длине текста;
///  * касание справа — дальше, слева — назад;
///  * палец на экране — пауза, дочитать спокойно;
///  * смахнуть вбок — к другой истории, вниз — закрыть;
///  * на компьютере — стрелки, пробел и Esc.
///
/// Если на телефоне включён экранный диктор, слайды сами не листаются:
/// диктор читает дольше, чем идёт таймер, и история уезжала бы из-под
/// него на полуслове.
class StoryViewer extends StatefulWidget {
  final List<Story> stories;
  final int initialIndex;
  final StoryData data;
  final AppPreferences? preferences;
  final bool showActions;

  const StoryViewer({
    super.key,
    required this.stories,
    required this.data,
    this.initialIndex = 0,
    this.preferences,
    this.showActions = true,
  });

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with SingleTickerProviderStateMixin {
  late final PageController pages =
      PageController(initialPage: widget.initialIndex);

  late int storyIndex = widget.initialIndex;
  int slideIndex = 0;

  /// Таймер слайда. Один на все истории: играет всегда только текущая.
  late final AnimationController timer = AnimationController(vsync: this)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) _next();
    });

  /// Листать ли самим. Выключено, когда работает экранный диктор.
  bool autoAdvance = true;
  bool started = false;

  /// Человек держит палец на экране — пауза, и подписи прячутся.
  bool held = false;

  /// Насколько историю стянули вниз, чтобы закрыть.
  double drag = 0;
  bool closing = false;

  Story get story => widget.stories[storyIndex];

  @override
  void initState() {
    super.initState();
    // Отметку «просмотрено» ставим после первого кадра: она перерисует
    // кружки на экране под историей, а перерисовывать чужое посреди
    // построения своего Flutter не даёт.
    WidgetsBinding.instance.addPostFrameCallback((_) => _markSeen());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    autoAdvance = !MediaQuery.accessibleNavigationOf(context);
    if (!started) {
      started = true;
      _play();
    } else if (!autoAdvance) {
      timer.stop();
    }
  }

  @override
  void dispose() {
    timer.dispose();
    pages.dispose();
    super.dispose();
  }

  void _markSeen() {
    if (!mounted) return;
    widget.preferences?.markStorySeen(story.id);
  }

  /// Запустить текущий слайд с начала.
  void _play() {
    timer.duration = story.slides[slideIndex].duration;
    if (autoAdvance && !held) {
      timer.forward(from: 0);
    } else {
      timer.stop();
      timer.value = 0;
    }
  }

  void _pause() => timer.stop();

  void _resume() {
    if (!autoAdvance || held || closing || timer.isAnimating) return;
    if (timer.value < 1) timer.forward();
  }

  void _next() {
    if (closing) return;
    if (slideIndex < story.slides.length - 1) {
      setState(() => slideIndex++);
      _play();
    } else if (storyIndex < widget.stories.length - 1) {
      _goToStory(storyIndex + 1);
    } else {
      _close();
    }
  }

  void _previous() {
    if (closing) return;
    if (slideIndex > 0) {
      setState(() => slideIndex--);
      _play();
    } else if (storyIndex > 0) {
      _goToStory(storyIndex - 1);
    } else {
      // Первый слайд первой истории — просто начинаем его заново.
      _play();
    }
  }

  void _goToStory(int index) {
    timer.stop();
    pages.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      storyIndex = index;
      slideIndex = 0;
    });
    _markSeen();
    _play();
  }

  void _close([StoryAction? action]) {
    if (closing) return;
    closing = true;
    timer.stop();
    Navigator.of(context).pop(action);
  }

  void _onTapUp(TapUpDetails details, double width) {
    // Левая треть — назад, остальное — вперёд. Вперёд листают чаще,
    // поэтому и места под него больше.
    if (details.localPosition.dx < width / 3) {
      _previous();
    } else {
      _next();
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _pause();
    setState(() => drag = math.max(0, drag + details.delta.dy));
  }

  void _onDragEnd(DragEndDetails details) {
    if (drag > 140 || (details.primaryVelocity ?? 0) > 800) {
      _close();
      return;
    }
    setState(() => drag = 0);
    _resume();
  }

  void _togglePause() {
    if (timer.isAnimating) {
      _pause();
    } else {
      _resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    final shrink = (drag / 1600).clamp(0.0, 0.12);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowRight): _next,
        const SingleActivator(LogicalKeyboardKey.arrowLeft): _previous,
        const SingleActivator(LogicalKeyboardKey.space): _togglePause,
        const SingleActivator(LogicalKeyboardKey.escape): _close,
      },
      child: Focus(
        autofocus: true,
        // Material — основа для текста и кнопок: без неё Flutter
        // подчёркивает весь текст жёлтым, показывая, что стиль не задан.
        child: Material(
          // Под стянутой вниз историей — затемнённый экран, а не белое.
          color: Colors.black.withValues(alpha: 1 - shrink * 6),
          child: Transform.translate(
            offset: Offset(0, drag),
            child: Transform.scale(
              scale: 1 - shrink,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(drag > 0 ? 28 : 0),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    // Смахивают к другой истории — таймер ждёт. Отпустили,
                    // не долистав, — продолжаем с того же места.
                    if (n is ScrollStartNotification && n.dragDetails != null) {
                      _pause();
                    } else if (n is ScrollEndNotification) {
                      _resume();
                    }
                    return false;
                  },
                  child: PageView.builder(
                    controller: pages,
                    itemCount: widget.stories.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) => AnimatedBuilder(
                      animation: pages,
                      builder: (context, child) {
                        var delta = 0.0;
                        if (pages.hasClients &&
                            pages.position.haveDimensions) {
                          delta = (pages.page! - index).abs().clamp(0.0, 1.0);
                        }
                        // Уходящая история чуть отъезжает вглубь и гаснет.
                        return Opacity(
                          opacity: 1 - delta * 0.5,
                          child: Transform.scale(
                            scale: 1 - delta * 0.08,
                            child: child,
                          ),
                        );
                      },
                      child: _buildStory(context, index),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStory(BuildContext context, int index) {
    final s = widget.stories[index];
    final active = index == storyIndex;
    final slideAt = active ? slideIndex : 0;
    final slide = s.slides[slideAt];

    return LayoutBuilder(
      builder: (context, constraints) => Semantics(
        customSemanticsActions: {
          const CustomSemanticsAction(label: 'Следующий слайд'): _next,
          const CustomSemanticsAction(label: 'Предыдущий слайд'): _previous,
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _pause(),
          onTapUp: (d) => _onTapUp(d, constraints.maxWidth),
          onTapCancel: _resume,
          onLongPressStart: (_) {
            setState(() => held = true);
            _pause();
          },
          onLongPressEnd: (_) {
            setState(() => held = false);
            _resume();
          },
          onVerticalDragUpdate: _onDragUpdate,
          onVerticalDragEnd: _onDragEnd,
          child: _StoryBackdrop(
            color: s.color,
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                    child: _ProgressBars(
                      count: s.slides.length,
                      current: slideAt,
                      timer: active ? timer : null,
                      manual: !autoAdvance,
                    ),
                  ),
                  _Header(
                    story: s,
                    slide: slideAt,
                    paused: held && active,
                    onClose: _close,
                  ),
                  Expanded(
                    // Подписи прячутся, пока держат палец: человек
                    // остановил историю, чтобы рассмотреть картинку.
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: held && active ? 0.35 : 1,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        child: KeyedSubtree(
                          key: ValueKey('$index/$slideAt'),
                          child: _SlideBody(
                            slide: slide,
                            color: s.color,
                            data: widget.data,
                            showAction: widget.showActions,
                            onAction: () => _close(slide.action),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Фон истории: её цвет, уходящий вниз в темноту, и два мягких пятна.
///
/// Внизу темно нарочно: там текст, и белые буквы должны читаться на любом
/// цвете истории — даже на жёлтом.
class _StoryBackdrop extends StatelessWidget {
  final Color color;
  final Widget child;

  const _StoryBackdrop({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    const night = Color(0xFF0B1020);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(color, Colors.black, 0.12)!,
            Color.lerp(color, night, 0.6)!,
            Color.lerp(color, night, 0.88)!,
          ],
          stops: const [0, 0.55, 1],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: const Alignment(1.3, -0.7),
            child: FractionallySizedBox(
              widthFactor: 1.1,
              heightFactor: 0.55,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.22),
                      Colors.white.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-1.2, 0.2),
            child: FractionallySizedBox(
              widthFactor: 1.2,
              heightFactor: 0.6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color.lerp(color, Colors.white, 0.3)!
                          .withValues(alpha: 0.45),
                      color.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Все стеклянные панели слайда размывают фон за один проход.
          BackdropGroup(child: child),
        ],
      ),
    );
  }
}

/// Полоски сверху: по одной на слайд. Текущая заполняется по таймеру.
class _ProgressBars extends StatelessWidget {
  final int count;
  final int current;
  final AnimationController? timer;

  /// Листают вручную — текущая полоска просто залита целиком.
  final bool manual;

  const _ProgressBars({
    required this.count,
    required this.current,
    required this.timer,
    required this.manual,
  });

  @override
  Widget build(BuildContext context) {
    Widget bar(double value) => ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: Colors.white.withValues(alpha: 0.35)),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: const ColoredBox(color: Colors.white),
                ),
              ],
            ),
          ),
        );

    return Semantics(
      label: 'Слайд ${current + 1} из $count',
      child: ExcludeSemantics(
        child: Row(
          children: [
            for (var i = 0; i < count; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: i != current || timer == null || manual
                      ? bar(i < current || (i == current && manual) ? 1 : 0)
                      : AnimatedBuilder(
                          animation: timer!,
                          builder: (context, _) => bar(timer!.value),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Story story;
  final int slide;
  final bool paused;
  final VoidCallback onClose;

  const _Header({
    required this.story,
    required this.slide,
    required this.paused,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 4, 0),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(story.icon, size: 20, color: story.color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'fastwork · ${slide + 1} из ${story.slides.length}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (paused)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                Icons.pause_rounded,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          IconButton(
            onPressed: onClose,
            tooltip: 'Закрыть',
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideBody extends StatelessWidget {
  final StorySlide slide;
  final Color color;
  final StoryData data;
  final bool showAction;
  final VoidCallback onAction;

  const _SlideBody({
    required this.slide,
    required this.color,
    required this.data,
    required this.showAction,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final hasAction = showAction && slide.action != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // Картинка занимает всё, что осталось от текста. Не влезает
            // на маленьком телефоне — уменьшается целиком, а не
            // обрезается: инфографика без половины не читается.
            child: LayoutBuilder(
              builder: (context, constraints) => Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: slide.visual(context, data),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            slide.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            slide.body,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
          if (hasAction) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color.lerp(color, Colors.black, 0.3),
                  minimumSize: const Size.fromHeight(54),
                  shape: const StadiumBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        slide.actionLabel ?? 'Открыть',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
