import 'package:flutter/foundation.dart';
import 'package:fastwork_core/lang.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Настройки этого телефона: язык, оформление и просмотренные истории.
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
  final ValueNotifier<Lang> _language;
  final Set<String> _seenStories;

  /// Человек закрыл карточку «Какая работа вам интересна?».
  bool _interestsHidden;

  /// Город, который смотрел гость до входа.
  String? _guestCity;

  /// Кто позвал: номер из ссылки-приглашения, до регистрации.
  int? _referrer;

  /// [deviceLanguage] — язык телефона. Им говорим, пока человек не выбрал
  /// язык сам; не передали — по-русски, как в тестах.
  AppPreferences({SharedPreferences? store, String? deviceLanguage})
      : _store = store,
        _theme = ValueNotifier(_readThemeMode(store)),
        _language = ValueNotifier(
            Lang.fromCode(store?.getString(_languageKey) ?? deviceLanguage)),
        _seenStories = {...?store?.getStringList(_seenKey)},
        _interestsHidden = store?.getBool(_interestsKey) ?? false,
        _guestCity = store?.getString(_guestCityKey),
        _referrer = store?.getInt(_referrerKey);

  /// Открыть настройки с диска.
  ///
  /// Не открылись — работаем в памяти. Из-за настроек приложение падать
  /// не должно: без них оно просто забудет тему до следующего запуска.
  static Future<AppPreferences> open() async {
    try {
      return AppPreferences(
        store: await SharedPreferences.getInstance(),
        // Телефон на казахском или английском — и приложение сразу на
        // нём. Любой другой язык — по-русски.
        deviceLanguage:
            WidgetsBinding.instance.platformDispatcher.locale.languageCode,
      );
    } catch (error) {
      debugPrint('Настройки не открылись, храним в памяти: $error');
      return AppPreferences();
    }
  }

  static const _themeKey = 'theme_mode';
  static const _languageKey = 'language';
  static const _seenKey = 'seen_stories';
  static const _interestsKey = 'interests_hidden';
  static const _guestCityKey = 'guest_city';
  static const _referrerKey = 'referrer';

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

  Lang get language => _language.value;

  /// Язык, как и тему, слушает всё приложение целиком.
  ValueListenable<Lang> get languageListenable => _language;

  Future<void> setLanguage(Lang value) async {
    if (value == _language.value) return;
    _language.value = value;
    await _store?.setString(_languageKey, value.code);
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

  /// Закрыта ли карточка выбора интересов в ленте. Закрыл — больше не
  /// спрашиваем: навязчивость хуже пустой подсказки.
  bool get interestsHidden => _interestsHidden;

  /// Город, который гость выбрал до входа. Им же предлагаем город в
  /// анкете: человек смотрел смены в Шымкенте — скорее всего, он оттуда.
  String? get guestCity => _guestCity;

  Future<void> setGuestCity(String city) async {
    _guestCity = city;
    await _store?.setString(_guestCityKey, city);
  }

  /// Кто позвал. Хранится на телефоне: друг открыл ссылку сегодня, а
  /// зарегистрировался через три дня — приглашение не должно потеряться.
  int? get referrer => _referrer;

  Future<void> setReferrer(int userId) async {
    _referrer = userId;
    await _store?.setInt(_referrerKey, userId);
  }

  Future<void> hideInterests() async {
    if (_interestsHidden) return;
    _interestsHidden = true;
    notifyListeners();
    await _store?.setBool(_interestsKey, true);
  }
}
