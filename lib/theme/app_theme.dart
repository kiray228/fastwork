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

  /// Скругление карточек. В «жидком стекле» углы круглее: стекло не
  /// режут под прямым углом, его отливают.
  static const radius = 26.0;

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

    // Поля ввода — тоже стекло: полупрозрачная заливка и светлая кромка.
    final fieldFill = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.65);
    final fieldEdge = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.9);
    OutlineInputBorder field(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      // Экраны прозрачные: под ними живой фон `LiquidBackground`, и
      // стекло карточек должно видеть его, а не сплошную заливку.
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: bg,
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
        backgroundColor: Colors.transparent,
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
          minimumSize: const Size.fromHeight(54),
          // Кнопка-капля: полностью круглые края.
          shape: const StadiumBorder(),
          textStyle: textThemeWithFallback.labelLarge?.copyWith(fontSize: 16),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: BorderSide(color: fieldEdge),
          backgroundColor: fieldFill,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: const StadiumBorder()),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldFill,
        border: field(fieldEdge),
        enabledBorder: field(fieldEdge),
        focusedBorder: field(AppColors.brand, 1.6),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.94)
            : Colors.white.withValues(alpha: 0.94),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
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
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}
