// Страница смены, запись на смену, отметка о приходе, отзыв о смене.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class ShiftStrings {
  const ShiftStrings();

  static ShiftStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };
}

class _Ru extends ShiftStrings {
  const _Ru();
}

class _Kk extends ShiftStrings {
  const _Kk();
}

class _En extends ShiftStrings {
  const _En();
}
