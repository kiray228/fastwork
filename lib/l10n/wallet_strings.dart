// Кошелёк, вывод денег, оплата смены, график заработка.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class WalletStrings {
  const WalletStrings();

  static WalletStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };
}

class _Ru extends WalletStrings {
  const _Ru();
}

class _Kk extends WalletStrings {
  const _Kk();
}

class _En extends WalletStrings {
  const _En();
}
