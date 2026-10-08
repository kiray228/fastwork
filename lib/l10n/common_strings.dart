// Общее: нижнее меню, состояния загрузки и ошибок, общие виджеты, фильтры, даты, цвета-подписи, ссылки.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class CommonStrings {
  const CommonStrings();

  /// Заголовок выбора языка и строка в профиле.
  String get language;

  static CommonStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };
}

class _Ru extends CommonStrings {
  const _Ru();

  @override
  String get language => 'Язык';
}

class _Kk extends CommonStrings {
  const _Kk();

  @override
  String get language => 'Тіл';
}

class _En extends CommonStrings {
  const _En();

  @override
  String get language => 'Language';
}
