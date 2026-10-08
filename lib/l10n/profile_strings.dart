// Профиль, документы, отзывы, мои смены, уведомления, поддержка.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class ProfileStrings {
  const ProfileStrings();

  /// Подпись под числом смен в профиле: «Смена», «Смены», «Смен».
  String statShifts(int n);

  static ProfileStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };
}

class _Ru extends ProfileStrings {
  const _Ru();

  @override
  String statShifts(int n) {
    final last = n % 10, lastTwo = n % 100;
    if (lastTwo >= 11 && lastTwo <= 14) return 'Смен';
    if (last == 1) return 'Смена';
    if (last >= 2 && last <= 4) return 'Смены';
    return 'Смен';
  }
}

class _Kk extends ProfileStrings {
  const _Kk();

  @override
  String statShifts(int n) => 'Ауысым';
}

class _En extends ProfileStrings {
  const _En();

  @override
  String statShifts(int n) => n == 1 ? 'Shift' : 'Shifts';
}
