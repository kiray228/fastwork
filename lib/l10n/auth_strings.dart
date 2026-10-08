// Вход и регистрация, правила сервиса.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class AuthStrings {
  const AuthStrings();

  static AuthStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };
}

class _Ru extends AuthStrings {
  const _Ru();
}

class _Kk extends AuthStrings {
  const _Kk();
}

class _En extends AuthStrings {
  const _En();
}
