import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Настройки этого телефона: оформление и просмотренные истории.
///
/// Это не данные аккаунта. Тёмная тема, выбранная на телефоне, не должна
/// переезжать на рабочий компьютер. И то, что человек посмотрел историю
/// здесь, не значит, что он видел её на другом устройстве. Поэтому
/// настройки лежат на самом устройстве, а не на сервере.
///
/// `ChangeNotifier`, как и сессия: посмотрел историю — кольцо вокруг неё
/// посерело само, без перезагрузки экрана.
class AppPreferences extends ChangeNotifier {
  /// Где всё хранится. null — только в памяти: так в тестах и в браузере,
  /// который запретил хранилище.
  final SharedPreferences? _store;

  final ValueNotifier<ThemeMode> _theme;
  final Set<String> _seenStories;

  AppPreferences({SharedPreferences? store})
      : _store = store,
        _theme = ValueNotifier(_readThemeMode(store)),
        _seenStories = {...?store?.getStringList(_seenKey)};

  /// Открыть настройки с диска.
  ///
  /// Не открылись — работаем в памяти. Из-за настроек приложение падать
  /// не должно: без них оно просто забудет тему до следующего запуска.
  static Future<AppPreferences> open() async {
    try {
      return AppPreferences(store: await SharedPreferences.getInstance());
    } catch (error) {
      debugPrint('Настройки не открылись, храним в памяти: $error');
      return AppPreferences();
    }
  }

  static const _themeKey = 'theme_mode';
  static const _seenKey = 'seen_stories';

  static ThemeMode _readThemeMode(SharedPreferences? store) =>
      switch (store?.getString(_themeKey)) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  ThemeMode get themeMode => _theme.value;

  /// Тему слушают отдельно от остального.
  ///
  /// На неё подписано всё приложение целиком. Будь она частью общего
  /// «что-то поменялось», каждая просмотренная история перерисовывала бы
  /// приложение от корня — ради одного серого кольца.
  ValueListenable<ThemeMode> get themeListenable => _theme;

  Future<void> setThemeMode(ThemeMode value) async {
    if (value == _theme.value) return;
    _theme.value = value;
    await _store?.setString(_themeKey, value.name);
  }

  /// Видел ли человек историю.
  ///
  /// Храним ключ вместе с версией: `payouts.1`. Поменялись выплаты по
  /// существу, мы подняли версию, и кольцо вокруг истории снова стало
  /// цветным, хотя старую её человек уже смотрел.
  bool isStorySeen(String id) => _seenStories.contains(id);

  Future<void> markStorySeen(String id) async {
    if (!_seenStories.add(id)) return;
    notifyListeners();
    await _store?.setStringList(_seenKey, _seenStories.toList());
  }
}
