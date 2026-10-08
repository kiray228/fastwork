// Что сервер говорит сам: ошибки запросов, вход по коду, письмо с кодом,
// страница после оплаты.
//
// Всё остальное (ошибки правил, уведомления, строки кошелька) говорит
// ядро — его словарь в `fastwork_core/l10n/`. Язык один на запрос: его
// присылает приложение в заголовке `Accept-Language`, а сервер выполняет
// запрос внутри `withLang` — см. `Api.router`.

import 'package:fastwork_core/lang.dart';

abstract class ServerStrings {
  const ServerStrings();

  static ServerStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };

  // ---- Запросы ----
  String get needLogin;
  String get badRequest;
  String get badRequestShape;
  String get expectedJson;
  String get badSignature;
  String get noAccess;
  String get employersOnly;
  String get notYourShift;
  String get ratingRange;
  String get unknownCategory;
  String get updateApp;
  String get needCard;
  String get needValidFrom;
  String get needMrp;

  // ---- Регистрация ----
  String get confirmEmailFirst;
  String get accountExists;
  String get badPhone;
  String get needFullName;
  String get phoneTaken;

  // ---- Вход по коду ----
  String get checkEmail;
  String get tooManyCodes;
  String get emailNotSent;
  String get requestCodeFirst;
  String get codeExpired;
  String get attemptsOver;
  String get codeWrongLast;
  String codeWrong(int attemptsLeft);
  String get codeUsed;

  // ---- Письмо с кодом ----
  String emailSubject(String code);
  String emailBody(String code);

  // ---- Страница после оплаты ----
  String get paymentPageTitle;
  String get paymentFailed;
  String get paymentAccepted;
  String get paymentFailedHint;
  String get paymentAcceptedHint;
}

class _Ru extends ServerStrings {
  const _Ru();

  @override
  String get needLogin => 'Нужен вход';
  @override
  String get badRequest => 'Не получилось разобрать запрос';
  @override
  String get badRequestShape =>
      'В запросе не хватает данных или они не того вида';
  @override
  String get expectedJson => 'Ожидался JSON';
  @override
  String get badSignature => 'Подпись не сходится';
  @override
  String get noAccess => 'Нет доступа';
  @override
  String get employersOnly => 'Только для заказчиков';
  @override
  String get notYourShift => 'Это не ваша смена';
  @override
  String get ratingRange => 'Оценка от 1 до 5';
  @override
  String get unknownCategory => 'Неизвестная категория работ';
  @override
  String get updateApp => 'Обновите приложение: изменился способ оплаты';
  @override
  String get needCard => 'Укажите карту';
  @override
  String get needValidFrom => 'Укажите дату validFrom';
  @override
  String get needMrp => 'Укажите МРП в тенге';

  @override
  String get confirmEmailFirst => 'Сначала подтвердите почту';
  @override
  String get accountExists => 'Аккаунт с этой почтой уже создан';
  @override
  String get badPhone => 'Некорректный номер телефона';
  @override
  String get needFullName => 'Укажите имя и фамилию';
  @override
  String get phoneTaken => 'Этот номер уже зарегистрирован';

  @override
  String get checkEmail => 'Проверьте адрес почты';
  @override
  String get tooManyCodes => 'Слишком много запросов. Попробуйте через час.';
  @override
  String get emailNotSent =>
      'Не получилось отправить письмо. Попробуйте ещё раз через минуту.';
  @override
  String get requestCodeFirst => 'Сначала запросите код';
  @override
  String get codeExpired => 'Код устарел, запросите новый';
  @override
  String get attemptsOver => 'Попытки кончились, запросите новый код';
  @override
  String get codeWrongLast =>
      'Код неверный. Попытки кончились, запросите новый';
  @override
  String codeWrong(int attemptsLeft) =>
      'Код неверный. Осталось попыток: $attemptsLeft';
  @override
  String get codeUsed => 'Код уже использован, запросите новый';

  @override
  String emailSubject(String code) => 'Код для входа: $code';
  @override
  String emailBody(String code) => 'Ваш код для входа в fastwork: $code\n\n'
      'Код действует 5 минут.\n'
      'Если вы не пытались войти — просто не отвечайте на это письмо.';

  @override
  String get paymentPageTitle => 'fastwork — оплата';
  @override
  String get paymentFailed => 'Оплата не прошла';
  @override
  String get paymentAccepted => 'Оплата принята';
  @override
  String get paymentFailedHint => 'Вернитесь в приложение fastwork и '
      'попробуйте ещё раз или выберите другой способ.';
  @override
  String get paymentAcceptedHint => 'Вернитесь в приложение fastwork — '
      'смена появится в ленте, как только банк подтвердит платёж.';
}

class _Kk extends ServerStrings {
  const _Kk();

  @override
  String get needLogin => 'Жүйеге кіру қажет';
  @override
  String get badRequest => 'Сұранысты оқу мүмкін болмады';
  @override
  String get badRequestShape =>
      'Сұраныста деректер жетіспейді немесе олар дұрыс емес';
  @override
  String get expectedJson => 'JSON күтілген еді';
  @override
  String get badSignature => 'Қолтаңба сәйкес келмейді';
  @override
  String get noAccess => 'Рұқсат жоқ';
  @override
  String get employersOnly => 'Тек тапсырыс берушілер үшін';
  @override
  String get notYourShift => 'Бұл сіздің ауысымыңыз емес';
  @override
  String get ratingRange => 'Баға 1-ден 5-ке дейін';
  @override
  String get unknownCategory => 'Белгісіз жұмыс санаты';
  @override
  String get updateApp => 'Қосымшаны жаңартыңыз: төлеу тәсілі өзгерді';
  @override
  String get needCard => 'Картаны көрсетіңіз';
  @override
  String get needValidFrom => 'validFrom күнін көрсетіңіз';
  @override
  String get needMrp => 'АЕК мөлшерін теңгемен көрсетіңіз';

  @override
  String get confirmEmailFirst => 'Алдымен поштаны растаңыз';
  @override
  String get accountExists => 'Бұл поштамен аккаунт бұрыннан бар';
  @override
  String get badPhone => 'Телефон нөмірі дұрыс емес';
  @override
  String get needFullName => 'Аты-жөніңізді көрсетіңіз';
  @override
  String get phoneTaken => 'Бұл нөмір тіркеліп қойған';

  @override
  String get checkEmail => 'Пошта мекенжайын тексеріңіз';
  @override
  String get tooManyCodes =>
      'Сұраныс тым көп. Бір сағаттан кейін қайталаңыз.';
  @override
  String get emailNotSent =>
      'Хат жіберілмеді. Бір минуттан кейін қайталап көріңіз.';
  @override
  String get requestCodeFirst => 'Алдымен код сұраңыз';
  @override
  String get codeExpired => 'Кодтың мерзімі өтті, жаңасын сұраңыз';
  @override
  String get attemptsOver => 'Әрекеттер таусылды, жаңа код сұраңыз';
  @override
  String get codeWrongLast =>
      'Код қате. Әрекеттер таусылды, жаңасын сұраңыз';
  @override
  String codeWrong(int attemptsLeft) =>
      'Код қате. Қалған әрекет: $attemptsLeft';
  @override
  String get codeUsed => 'Код қолданылып қойған, жаңасын сұраңыз';

  @override
  String emailSubject(String code) => 'Кіру коды: $code';
  @override
  String emailBody(String code) => 'fastwork-қа кіру кодыңыз: $code\n\n'
      'Код 5 минут жарамды.\n'
      'Егер сіз кіруге тырыспаған болсаңыз, бұл хатқа жауап бермеңіз.';

  @override
  String get paymentPageTitle => 'fastwork — төлем';
  @override
  String get paymentFailed => 'Төлем өтпеді';
  @override
  String get paymentAccepted => 'Төлем қабылданды';
  @override
  String get paymentFailedHint => 'fastwork қосымшасына оралып, қайта '
      'көріңіз немесе басқа тәсілді таңдаңыз.';
  @override
  String get paymentAcceptedHint => 'fastwork қосымшасына оралыңыз — банк '
      'төлемді растаған соң ауысым таспада пайда болады.';
}

class _En extends ServerStrings {
  const _En();

  @override
  String get needLogin => 'Please sign in';
  @override
  String get badRequest => "Couldn't read the request";
  @override
  String get badRequestShape =>
      'The request is missing data or has it in the wrong format';
  @override
  String get expectedJson => 'Expected JSON';
  @override
  String get badSignature => "Signature doesn't match";
  @override
  String get noAccess => 'Access denied';
  @override
  String get employersOnly => 'Employers only';
  @override
  String get notYourShift => 'This is not your shift';
  @override
  String get ratingRange => 'Rating must be from 1 to 5';
  @override
  String get unknownCategory => 'Unknown job category';
  @override
  String get updateApp => 'Please update the app: the payment flow has changed';
  @override
  String get needCard => 'Please enter a card';
  @override
  String get needValidFrom => 'Please set validFrom';
  @override
  String get needMrp => 'Please set the MCI in tenge';

  @override
  String get confirmEmailFirst => 'Please confirm your email first';
  @override
  String get accountExists => 'An account with this email already exists';
  @override
  String get badPhone => 'Invalid phone number';
  @override
  String get needFullName => 'Please enter your first and last name';
  @override
  String get phoneTaken => 'This number is already registered';

  @override
  String get checkEmail => 'Please check the email address';
  @override
  String get tooManyCodes => 'Too many requests. Try again in an hour.';
  @override
  String get emailNotSent =>
      "Couldn't send the email. Please try again in a minute.";
  @override
  String get requestCodeFirst => 'Request a code first';
  @override
  String get codeExpired => 'The code has expired, request a new one';
  @override
  String get attemptsOver => 'No attempts left, request a new code';
  @override
  String get codeWrongLast => 'Wrong code. No attempts left, request a new one';
  @override
  String codeWrong(int attemptsLeft) =>
      'Wrong code. Attempts left: $attemptsLeft';
  @override
  String get codeUsed => 'This code has already been used, request a new one';

  @override
  String emailSubject(String code) => 'Your sign-in code: $code';
  @override
  String emailBody(String code) => 'Your fastwork sign-in code: $code\n\n'
      'The code is valid for 5 minutes.\n'
      "If you didn't try to sign in, just ignore this email.";

  @override
  String get paymentPageTitle => 'fastwork — payment';
  @override
  String get paymentFailed => 'Payment failed';
  @override
  String get paymentAccepted => 'Payment received';
  @override
  String get paymentFailedHint => 'Go back to the fastwork app and try '
      'again or choose another method.';
  @override
  String get paymentAcceptedHint => 'Go back to the fastwork app — the shift '
      'will appear in the feed as soon as the bank confirms the payment.';
}

/// Словарь языка текущего запроса.
ServerStrings get serverTr => ServerStrings.of(currentLang);
