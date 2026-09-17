import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Тема приложения: шрифты, цвета, скругления, тени.
///
/// Задаём один раз здесь — и все кнопки, карточки и поля по всему
/// приложению выглядят одинаково. Без этого каждый экран пришлось бы
/// оформлять вручную, и они бы неизбежно разъехались.
class AppTheme {
  AppTheme._();

  static const radius = 20.0;

  /// Мягкая тень под карточками. Именно она отличает «плоский» вид
  /// от аккуратного: карточка должна чуть приподниматься над фоном.
  static const cardShadow = [
    BoxShadow(
      color: Color(0x0F0F172A),
      blurRadius: 24,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final ink = isDark ? AppColors.darkInk : AppColors.ink;
    final body = isDark ? AppColors.darkBody : AppColors.body;
    final bg = isDark ? AppColors.darkBg : AppColors.bg;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;

    // Manrope — геометричный шрифт с жирными начертаниями.
    // На крупных суммах смотрится заметно дороже системного.
    final base = GoogleFonts.manropeTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );

    final textTheme = base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        color: ink,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        color: ink,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: ink,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: ink,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: base.bodyLarge?.copyWith(color: body),
      bodyMedium: base.bodyMedium?.copyWith(color: body),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w700),
    );

    // Запасные шрифты. Не во всех шрифтах есть символ тенге «₸» — если
    // его не окажется, Flutter возьмёт его из следующего шрифта списка,
    // а не нарисует пустой квадратик.
    final textThemeWithFallback = textTheme.apply(
      fontFamilyFallback: const ['Roboto', 'Noto Sans', 'Arial'],
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      textTheme: textThemeWithFallback,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brand,
        brightness: brightness,
      ).copyWith(
        primary: AppColors.brand,
        onPrimary: Colors.white,
        surface: surface,
        onSurface: ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ink),
        titleTextStyle: textThemeWithFallback.titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brand,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              isDark ? AppColors.darkBorder : AppColors.border,
          disabledForegroundColor: AppColors.muted,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: textThemeWithFallback.labelLarge?.copyWith(fontSize: 16),
          elevation: 0,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.darkBorder : AppColors.border,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ink,
        contentTextStyle: textThemeWithFallback.bodyMedium?.copyWith(
          color: isDark ? AppColors.darkBg : Colors.white,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
