// Вход и регистрация, правила сервиса.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class AuthStrings {
  const AuthStrings();

  // ---- Экран входа: шапка и шаги ----
  /// Слоган под логотипом.
  String get tagline;
  String get signInTitle;
  String get codeTitle;
  String get aboutYouTitle;
  String get emailSubtitle;
  String codeSubtitle(String email);
  String get emailConfirmedSubtitle;
  String get phoneSubtitle;
  String get getCodeButton;
  String get confirmButton;
  String get createAccountButton;
  String get startWorkingButton;
  String get otherEmailButton;

  /// Подсказка до шага анкеты: правила покажем потом.
  String get termsLaterHint;

  // ---- Экран входа: поля ----
  String get emailLabel;
  String get codeLabel;
  String get roleWorker;
  String get roleEmployer;
  String get phoneLabel;
  String get nameLabel;

  /// Пример имени в пустом поле.
  String get nameHint;
  String get companyLabel;
  String get cityLabel;

  // ---- Экран входа: ошибки ----
  String get badEmail;
  String get badCode;
  String get phoneIncomplete;
  String get nameRequired;
  String get companyRequired;

  // ---- Правила ----
  /// Заголовок экрана чтения правил.
  String get termsPageTitle;
  String termsEdition(int version);
  String get termsGateTitle;
  String get termsUpdatedNote;
  String get termsFirstNote;
  String get acceptButton;
  String get signOutButton;

  // ---- Галочка согласия ----
  /// Слова перед ссылкой («Я принимаю»). Может быть пустой строкой.
  String get checkboxLead;

  /// Текст ссылки на правила.
  String get checkboxLink;

  /// Хвост после ссылки для исполнителя (с лимитом дохода).
  String get checkboxTailWorker;

  /// Хвост после ссылки для заказчика.
  String get checkboxTailEmployer;

  static AuthStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };
}

class _Ru extends AuthStrings {
  const _Ru();

  // ---- Экран входа: шапка и шаги ----
  @override
  String get tagline => 'Подработка рядом с домом';
  @override
  String get signInTitle => 'Вход';
  @override
  String get codeTitle => 'Код из письма';
  @override
  String get aboutYouTitle => 'Немного о вас';
  @override
  String get emailSubtitle =>
      'Введите почту — пришлём код. Если вы у нас впервые, аккаунт '
      'создастся сам';
  @override
  String codeSubtitle(String email) =>
      'Отправили код на $email. Он действует 5 минут';
  @override
  String get emailConfirmedSubtitle =>
      'Почта подтверждена. Осталось заполнить анкету';
  @override
  String get phoneSubtitle =>
      'Введите номер — если вы у нас впервые, аккаунт создастся сам';
  @override
  String get getCodeButton => 'Получить код';
  @override
  String get confirmButton => 'Подтвердить';
  @override
  String get createAccountButton => 'Создать аккаунт';
  @override
  String get startWorkingButton => 'Начать работать';
  @override
  String get otherEmailButton => 'Другой адрес';
  @override
  String get termsLaterHint =>
      'Правила сервиса покажем на следующем шаге — перед тем, '
      'как создать аккаунт.';

  // ---- Экран входа: поля ----
  @override
  String get emailLabel => 'Почта';
  @override
  String get codeLabel => 'Код из письма';
  @override
  String get roleWorker => 'Ищу подработку';
  @override
  String get roleEmployer => 'Нанимаю людей';
  @override
  String get phoneLabel => 'Номер телефона';
  @override
  String get nameLabel => 'Имя и фамилия';
  @override
  String get nameHint => 'Ернар Калдыбеков';
  @override
  String get companyLabel => 'Название компании';
  @override
  String get cityLabel => 'Город';

  // ---- Экран входа: ошибки ----
  @override
  String get badEmail => 'Проверьте адрес почты';
  @override
  String get badCode => 'Код состоит из шести цифр';
  @override
  String get phoneIncomplete => 'Введите номер телефона полностью';
  @override
  String get nameRequired => 'Введите имя и фамилию';
  @override
  String get companyRequired => 'Укажите название компании';

  // ---- Правила ----
  @override
  String get termsPageTitle => 'Правила';
  @override
  String termsEdition(int version) => 'Редакция $version';
  @override
  String get termsGateTitle => 'Правила сервиса';
  @override
  String get termsUpdatedNote =>
      'Правила обновились. Прочитайте новую редакцию — '
      'без согласия с ней работать дальше нельзя.';
  @override
  String get termsFirstNote =>
      'Прежде чем продолжить, прочитайте правила '
      'и подтвердите согласие.';
  @override
  String get acceptButton => 'Принимаю';
  @override
  String get signOutButton => 'Выйти';

  // ---- Галочка согласия ----
  @override
  String get checkboxLead => 'Я принимаю';
  @override
  String get checkboxLink => 'правила сервиса';
  @override
  String get checkboxTailWorker =>
      'включая лимит дохода 300 МРП в месяц и обработку персональных '
      'данных';
  @override
  String get checkboxTailEmployer => 'и обработку персональных данных';
}

class _Kk extends AuthStrings {
  const _Kk();

  // ---- Экран входа: шапка и шаги ----
  @override
  String get tagline => 'Үйдің жанынан қосымша жұмыс';
  @override
  String get signInTitle => 'Кіру';
  @override
  String get codeTitle => 'Хаттағы код';
  @override
  String get aboutYouTitle => 'Өзіңіз туралы';
  @override
  String get emailSubtitle =>
      'Поштаңызды енгізіңіз — код жібереміз. Бізде алғаш рет болсаңыз, '
      'аккаунт өзі ашылады';
  @override
  String codeSubtitle(String email) =>
      'Кодты $email поштасына жібердік. Ол 5 минут жарамды';
  @override
  String get emailConfirmedSubtitle =>
      'Пошта расталды. Енді сауалнаманы толтырыңыз';
  @override
  String get phoneSubtitle =>
      'Нөміріңізді енгізіңіз — бізде алғаш рет болсаңыз, аккаунт өзі ашылады';
  @override
  String get getCodeButton => 'Код алу';
  @override
  String get confirmButton => 'Растау';
  @override
  String get createAccountButton => 'Аккаунт ашу';
  @override
  String get startWorkingButton => 'Жұмысты бастау';
  @override
  String get otherEmailButton => 'Басқа пошта';
  @override
  String get termsLaterHint =>
      'Сервис ережелерін келесі қадамда — аккаунт ашар алдында '
      'көрсетеміз.';

  // ---- Экран входа: поля ----
  @override
  String get emailLabel => 'Пошта';
  @override
  String get codeLabel => 'Хаттағы код';
  @override
  String get roleWorker => 'Қосымша жұмыс іздеймін';
  @override
  String get roleEmployer => 'Адам жалдаймын';
  @override
  String get phoneLabel => 'Телефон нөмірі';
  @override
  String get nameLabel => 'Аты-жөні';
  @override
  String get nameHint => 'Ернар Қалдыбеков';
  @override
  String get companyLabel => 'Компания атауы';
  @override
  String get cityLabel => 'Қала';

  // ---- Экран входа: ошибки ----
  @override
  String get badEmail => 'Пошта мекенжайын тексеріңіз';
  @override
  String get badCode => 'Код алты цифрдан тұрады';
  @override
  String get phoneIncomplete => 'Телефон нөмірін толық енгізіңіз';
  @override
  String get nameRequired => 'Атыңыз бен тегіңізді енгізіңіз';
  @override
  String get companyRequired => 'Компания атауын көрсетіңіз';

  // ---- Правила ----
  @override
  String get termsPageTitle => 'Ережелер';
  @override
  String termsEdition(int version) => '$version-редакция';
  @override
  String get termsGateTitle => 'Сервис ережелері';
  @override
  String get termsUpdatedNote =>
      'Ережелер жаңарды. Жаңа редакциясын оқыңыз — '
      'онымен келіспей жұмысты жалғастыру мүмкін емес.';
  @override
  String get termsFirstNote =>
      'Жалғастырмас бұрын ережелерді оқып, '
      'келісіміңізді растаңыз.';
  @override
  String get acceptButton => 'Қабылдаймын';
  @override
  String get signOutButton => 'Шығу';

  // ---- Галочка согласия ----
  @override
  String get checkboxLead => 'Мен';
  @override
  String get checkboxLink => 'сервис ережелерін';
  @override
  String get checkboxTailWorker =>
      'оның ішінде айына 300 АЕК табыс шегін және дербес деректерді '
      'өңдеуді қабылдаймын';
  @override
  String get checkboxTailEmployer =>
      'және дербес деректерді өңдеуді қабылдаймын';
}

class _En extends AuthStrings {
  const _En();

  // ---- Экран входа: шапка и шаги ----
  @override
  String get tagline => 'Side jobs close to home';
  @override
  String get signInTitle => 'Sign in';
  @override
  String get codeTitle => 'Code from email';
  @override
  String get aboutYouTitle => 'About you';
  @override
  String get emailSubtitle =>
      'Enter your email and we’ll send a code. New here? Your account '
      'will be created automatically';
  @override
  String codeSubtitle(String email) =>
      'We sent a code to $email. It’s valid for 5 minutes';
  @override
  String get emailConfirmedSubtitle =>
      'Email confirmed. Just fill in your profile';
  @override
  String get phoneSubtitle =>
      'Enter your number. New here? Your account will be created '
      'automatically';
  @override
  String get getCodeButton => 'Get code';
  @override
  String get confirmButton => 'Confirm';
  @override
  String get createAccountButton => 'Create account';
  @override
  String get startWorkingButton => 'Start working';
  @override
  String get otherEmailButton => 'Use another email';
  @override
  String get termsLaterHint =>
      'We’ll show the terms of service on the next step, before '
      'your account is created.';

  // ---- Экран входа: поля ----
  @override
  String get emailLabel => 'Email';
  @override
  String get codeLabel => 'Code from email';
  @override
  String get roleWorker => 'Looking for work';
  @override
  String get roleEmployer => 'Hiring people';
  @override
  String get phoneLabel => 'Phone number';
  @override
  String get nameLabel => 'Full name';
  @override
  String get nameHint => 'Yernar Kaldybekov';
  @override
  String get companyLabel => 'Company name';
  @override
  String get cityLabel => 'City';

  // ---- Экран входа: ошибки ----
  @override
  String get badEmail => 'Check your email address';
  @override
  String get badCode => 'The code has six digits';
  @override
  String get phoneIncomplete => 'Enter your full phone number';
  @override
  String get nameRequired => 'Enter your first and last name';
  @override
  String get companyRequired => 'Enter your company name';

  // ---- Правила ----
  @override
  String get termsPageTitle => 'Terms';
  @override
  String termsEdition(int version) => 'Version $version';
  @override
  String get termsGateTitle => 'Terms of service';
  @override
  String get termsUpdatedNote =>
      'The terms have been updated. Please read the new version — '
      'you can’t keep working without accepting it.';
  @override
  String get termsFirstNote =>
      'Before you continue, please read the terms '
      'and confirm that you accept them.';
  @override
  String get acceptButton => 'I accept';
  @override
  String get signOutButton => 'Sign out';

  // ---- Галочка согласия ----
  @override
  String get checkboxLead => 'I accept the';
  @override
  String get checkboxLink => 'terms of service';
  @override
  String get checkboxTailWorker =>
      'including the income limit of 300 MCI per month and personal data '
      'processing';
  @override
  String get checkboxTailEmployer => 'and personal data processing';
}
