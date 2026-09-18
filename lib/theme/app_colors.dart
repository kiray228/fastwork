import 'package:flutter/material.dart';

/// Палитра fastwork.
///
/// Все цвета собраны в одном месте. Если завтра решим сменить фирменный
/// цвет — правим здесь одну строку, а не ищем по всему проекту.
/// Это то же правило, что и в базе данных: один факт хранится в одном месте.
class AppColors {
  AppColors._();

  // Фирменный — изумрудный. Деньги, рост, «получилось».
  static const brand = Color(0xFF0FA36B);
  static const brandDark = Color(0xFF0B7A50);
  static const brandSoft = Color(0xFFE6F6EF);

  // Акцент — янтарный. Для того, что нужно заметить.
  static const accent = Color(0xFFF59E0B);
  static const accentSoft = Color(0xFFFEF3C7);

  // Смысловые цвета: «получилось», «внимание», «плохо».
  //
  // Названы по смыслу, а не по цвету: `danger`, а не `red`. Если завтра
  // красный сменится на малиновый, править придётся одну строку здесь,
  // а не искать по коду все слова «red».
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFEA580C);
  static const danger = Color(0xFFDC2626);

  // Текст и фон, светлая тема
  static const ink = Color(0xFF0F172A); // заголовки, суммы
  static const body = Color(0xFF475569); // обычный текст
  static const muted = Color(0xFF94A3B8); // подписи
  static const bg = Color(0xFFF4F6F9); // фон экрана
  static const surface = Color(0xFFFFFFFF); // карточки
  static const border = Color(0xFFE6EAF0);

  // Тёмная тема
  static const darkBg = Color(0xFF0B0F17);
  static const darkSurface = Color(0xFF141B26);
  static const darkBorder = Color(0xFF243044);
  static const darkInk = Color(0xFFF1F5F9);
  static const darkBody = Color(0xFFB6C2D2);
  static const darkMuted = Color(0xFF7E8CA0);

  /// Цвет для аватарки компании.
  ///
  /// Логотипов у нас нет, поэтому рисуем кружок с первой буквой названия.
  /// Цвет выбираем по самому названию: одна и та же компания всегда получит
  /// один и тот же цвет, а разные — разные. Никакого хранения не нужно.
  static Color forCompany(String name) {
    const palette = [
      Color(0xFF6366F1), // индиго
      Color(0xFF0EA5E9), // голубой
      Color(0xFFEC4899), // розовый
      Color(0xFFF97316), // оранжевый
      Color(0xFF14B8A6), // бирюзовый
      Color(0xFF8B5CF6), // фиолетовый
    ];

    // Складываем коды символов названия и берём остаток от деления.
    // Так из текста получается устойчивое число — приём называется «хеш».
    var sum = 0;
    for (final code in name.codeUnits) {
      sum += code;
    }
    return palette[sum % palette.length];
  }
}
