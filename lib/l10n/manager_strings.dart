// Кабинет заказчика: его смены, создание и правка смены, оценка исполнителей, избранные.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class ManagerStrings {
  const ManagerStrings();

  static ManagerStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };
}

class _Ru extends ManagerStrings {
  const _Ru();
}

class _Kk extends ManagerStrings {
  const _Kk();
}

class _En extends ManagerStrings {
  const _En();
}
