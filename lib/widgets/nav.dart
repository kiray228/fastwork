import 'package:flutter/material.dart';

/// Переход между экранами: новый выезжает справа и проявляется.
///
/// Стандартный `MaterialPageRoute` на каждой системе выглядит по-своему —
/// на Android это одно движение, на вебе другое. Свой переход делает
/// приложение одинаковым везде и чуть быстрее стандартного: 260 мс
/// вместо 300, разница едва заметна глазу, но ощущается как отзывчивость.
Route<T> appRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondary) => page,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondary, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0.06, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
