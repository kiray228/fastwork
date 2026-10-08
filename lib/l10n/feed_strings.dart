// Лента смен, карточка смены, страница компании, кольца историй.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class FeedStrings {
  const FeedStrings();

  static FeedStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };
}

class _Ru extends FeedStrings {
  const _Ru();
}

class _Kk extends FeedStrings {
  const _Kk();
}

class _En extends FeedStrings {
  const _En();
}
