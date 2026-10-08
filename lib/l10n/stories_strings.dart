// Истории: тексты, инфографика, просмотрщик.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class StoriesStrings {
  const StoriesStrings();

  static StoriesStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };
}

class _Ru extends StoriesStrings {
  const _Ru();
}

class _Kk extends StoriesStrings {
  const _Kk();
}

class _En extends StoriesStrings {
  const _En();
}
