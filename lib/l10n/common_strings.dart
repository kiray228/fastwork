// Общее: нижнее меню, состояния загрузки и ошибок, общие виджеты, фильтры, даты, цвета-подписи, ссылки.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class CommonStrings {
  const CommonStrings();

  /// Заголовок выбора языка и строка в профиле.
  String get language;

  // ---- Нижнее меню ----
  String get navMyShifts;
  String get navCreate;

  /// Вкладка заказчика с отзывами об исполнителях.
  String get navRatings;
  String get navProfile;
  String get navShifts;

  /// Вкладка исполнителя «мои смены» — коротко.
  String get navMine;

  // ---- Ошибки и загрузка ----
  String get errorNoConnection;
  String get errorTimeout;
  String get errorLocalData;
  String get errorUnknown;

  /// Запасной текст, если сервер ответил ошибкой без объяснения.
  String serverReplied(int status);

  /// Через сервер по телефону не входят — только по коду с почты.
  String get serverPhoneSignInUnsupported;
  String get loadFailedTitle;
  String get retry;

  // ---- Общие виджеты ----
  String get payGuaranteed;

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

  // ---- Нижнее меню ----
  @override
  String get navMyShifts => 'Мои смены';
  @override
  String get navCreate => 'Создать';
  @override
  String get navRatings => 'Оценки';
  @override
  String get navProfile => 'Профиль';
  @override
  String get navShifts => 'Смены';
  @override
  String get navMine => 'Мои';

  // ---- Ошибки и загрузка ----
  @override
  String get errorNoConnection =>
      'Нет связи с сервером. Проверьте интернет и попробуйте снова.';
  @override
  String get errorTimeout => 'Сервер долго не отвечает. Попробуйте ещё раз.';
  @override
  String get errorLocalData => 'Не удалось прочитать данные на устройстве.';
  @override
  String get errorUnknown => 'Что-то пошло не так. Попробуйте ещё раз.';
  @override
  String serverReplied(int status) => 'Сервер ответил $status';
  @override
  String get serverPhoneSignInUnsupported =>
      'Вход через сервер — по коду с почты';
  @override
  String get loadFailedTitle => 'Не получилось загрузить';
  @override
  String get retry => 'Повторить';

  // ---- Общие виджеты ----
  @override
  String get payGuaranteed => 'Оплата гарантирована';
}

class _Kk extends CommonStrings {
  const _Kk();

  @override
  String get language => 'Тіл';

  // ---- Нижнее меню ----
  @override
  String get navMyShifts => 'Ауысымдарым';
  @override
  String get navCreate => 'Құру';
  @override
  String get navRatings => 'Бағалар';
  @override
  String get navProfile => 'Профиль';
  @override
  String get navShifts => 'Ауысымдар';
  @override
  String get navMine => 'Менікі';

  // ---- Ошибки и загрузка ----
  @override
  String get errorNoConnection =>
      'Сервермен байланыс жоқ. Интернетті тексеріп, қайталап көріңіз.';
  @override
  String get errorTimeout => 'Сервер ұзақ жауап бермей тұр. Қайталап көріңіз.';
  @override
  String get errorLocalData => 'Құрылғыдағы деректерді оқу мүмкін болмады.';
  @override
  String get errorUnknown => 'Бірдеңе дұрыс болмады. Қайталап көріңіз.';
  @override
  String serverReplied(int status) => 'Сервер жауабы: $status';
  @override
  String get serverPhoneSignInUnsupported =>
      'Сервер арқылы тек поштаға келген кодпен кіруге болады';
  @override
  String get loadFailedTitle => 'Жүктеу мүмкін болмады';
  @override
  String get retry => 'Қайталау';

  // ---- Общие виджеты ----
  @override
  String get payGuaranteed => 'Төлем кепілді';
}

class _En extends CommonStrings {
  const _En();

  @override
  String get language => 'Language';

  // ---- Нижнее меню ----
  @override
  String get navMyShifts => 'My shifts';
  @override
  String get navCreate => 'Create';
  @override
  String get navRatings => 'Ratings';
  @override
  String get navProfile => 'Profile';
  @override
  String get navShifts => 'Shifts';
  @override
  String get navMine => 'Mine';

  // ---- Ошибки и загрузка ----
  @override
  String get errorNoConnection =>
      'No connection to the server. Check your internet and try again.';
  @override
  String get errorTimeout => 'The server is taking too long. Please try again.';
  @override
  String get errorLocalData => 'Couldn’t read data on this device.';
  @override
  String get errorUnknown => 'Something went wrong. Please try again.';
  @override
  String serverReplied(int status) => 'Server responded with $status';
  @override
  String get serverPhoneSignInUnsupported =>
      'Server sign-in works only with an email code';
  @override
  String get loadFailedTitle => 'Couldn’t load';
  @override
  String get retry => 'Retry';

  // ---- Общие виджеты ----
  @override
  String get payGuaranteed => 'Pay guaranteed';
}
