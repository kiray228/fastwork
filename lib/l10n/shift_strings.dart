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

  // ---- Экран смены: шапка ----

  /// Заголовок экрана и подпись «Смена» в сводке записи.
  String get title;
  String get notFoundTitle;
  String get notFoundSubtitle;
  String get shareTooltip;
  String get shareCopied;
  String get addressCopied;
  String get copyAddressTooltip;
  String get linkOpenFailed;

  /// Заголовок окна выбора карт.
  String get routeTitle;

  /// Кнопка «Как добраться» под адресом.
  String get routeButton;
  String get toCalendar;

  /// « (следующий день)» — после времени ночной смены, с пробелом.
  String get nextDaySuffix;
  String get duties;
  String get dressCode;
  String get employerComment;

  // ---- Экран смены: запись ----

  String get bookedSnack;
  String get bookNoSlots;
  String get bookAlreadyBooked;
  String get bookRatingTooLow;
  String get bookAlreadyStarted;
  String get bookTimeConflict;
  String get bookAlreadyFinished;
  String get bookEarningsLimit;
  String get bookFailed;

  // ---- Экран смены: отметка о приходе ----

  String get checkInWithCodeSnack;
  String get checkInOkSnack;
  String get checkInAlready;
  String get checkInWrongCode;
  String get checkInTooEarly;
  String get checkInFailed;

  // ---- Экран смены: отмена записи ----

  String get cancelDialogTitle;
  String get cancelDialogBody;
  String get cancelKeep;
  String get cancelConfirm;
  String get cancelDone;
  String get cancelTooLate;
  String get cancelFailed;

  // ---- Экран смены: лист ожидания ----

  String get waitlistJoined;
  String get waitlistLeft;
  String get waitlistStarted;
  String get waitlistFailed;

  // ---- Плашки «вы записаны» и «рейтинг не дотягивает» ----

  String get appliedBanner;

  /// «Отменить запись можно до 17 сен, 08:00».
  String cancelUntil(String when);
  String get cancelDeadlinePassed;
  String ratingLockTitle(String min);
  String ratingLockBody(String actual);

  // ---- Вознаграждение ----

  String get payTitle;
  String get payRate;

  /// «1 100 ₸ / час».
  String perHour(String amount);
  String get payDuration;
  String get payPaid;
  String get payFundedNote;

  /// «1 ч перерыва на обед не оплачивается».
  String unpaidBreak(String duration);

  // ---- Набор ----

  String get slotsTitle;
  String freeSlots(int n);
  String get allSlotsTaken;

  // ---- Нижняя панель ----

  String get statusCompleted;
  String get statusCheckedIn;

  /// «Я на месте» — кнопка и заголовок окна отметки.
  String get checkInButton;
  String get cancelBooking;
  String get cancelUnavailable;
  String get ratingTooLowButton;
  String get bookButton;
  String get waitlistLeaveButton;
  String get waitlistJoinButton;
  String get payoutNextDay;
  String payoutInDays(int n);

  // ---- Окно подтверждения записи ----

  String get confirmTitle;
  String get confirmSubtitle;
  String get summaryWhen;
  String get summaryWhere;
  String get youCommit;
  String termShowUp(String when);
  String termCancelUntil(String when, int hours);
  String termNoCancel(int hours);
  String get termNoShow;
  String termUnpaidBreak(String duration);
  String get termFunded;
  String get termPayoutNextDay;
  String termPayoutInDays(int n);
  String get termEarningsLimit;
  String termDressCode(String dressCode);
  String get agreeCheckbox;
  String get back;
  String get confirmButton;

  // ---- Окно «Я на месте» ----

  String get checkInHint;
  String get checkInWithoutCode;
  String get checkInSubmit;

  // ---- Окно отзыва ----

  String get reviewTitle;
  String get reviewHint;
  String get reviewSend;

  /// Подпись под звёздами: [0] — ещё не выбрано, [1]…[5] — оценка.
  List<String> get ratingLabels;

  // ---- Карты ----

  String get map2Gis;
  String get mapYandex;
  String get mapGoogle;
}

class _Ru extends ShiftStrings {
  const _Ru();

  static String _plural(int n, String one, String few, String many) {
    final last = n % 10;
    final lastTwo = n % 100;
    if (lastTwo >= 11 && lastTwo <= 14) return '$n $many';
    if (last == 1) return '$n $one';
    if (last >= 2 && last <= 4) return '$n $few';
    return '$n $many';
  }

  /// «за 10 часов», «за 1 час».
  static String _hoursAcc(int n) => _plural(n, 'час', 'часа', 'часов');

  /// «меньше 10 часов», «меньше 21 часа».
  static String _hoursGen(int n) =>
      n % 10 == 1 && n % 100 != 11 ? '$n часа' : '$n часов';

  static String _days(int n) => _plural(n, 'день', 'дня', 'дней');

  // ---- Экран смены: шапка ----
  @override
  String get title => 'Смена';
  @override
  String get notFoundTitle => 'Смена не найдена';
  @override
  String get notFoundSubtitle =>
      'Её могли удалить, или она ещё не опубликована';
  @override
  String get shareTooltip => 'Поделиться';
  @override
  String get shareCopied => 'Описание смены скопировано — вставьте его в чат';
  @override
  String get addressCopied => 'Адрес скопирован — вставьте его в карты';
  @override
  String get copyAddressTooltip => 'Скопировать адрес';
  @override
  String get linkOpenFailed => 'Не получилось открыть ссылку';
  @override
  String get routeTitle => 'Как добраться';
  @override
  String get routeButton => 'Как добраться';
  @override
  String get toCalendar => 'В календарь';
  @override
  String get nextDaySuffix => ' (следующий день)';
  @override
  String get duties => 'Обязанности';
  @override
  String get dressCode => 'Форма одежды';
  @override
  String get employerComment => 'Комментарий заказчика';

  // ---- Экран смены: запись ----
  @override
  String get bookedSnack => 'Вы записаны на смену';
  @override
  String get bookNoSlots => 'Не получилось: мест уже нет';
  @override
  String get bookAlreadyBooked => 'Вы уже записаны на эту смену';
  @override
  String get bookRatingTooLow => 'Ваш рейтинг ниже требуемого для этой смены';
  @override
  String get bookAlreadyStarted =>
      'Смена уже началась — записаться на неё нельзя';
  @override
  String get bookTimeConflict =>
      'В это время у вас уже есть смена — две сразу не успеть';
  @override
  String get bookAlreadyFinished =>
      'Эта смена для вас уже закрыта — выход отмечен заказчиком';
  @override
  String get bookEarningsLimit =>
      'С этой сменой доход за месяц превысит 300 МРП — '
      'это предел для платформенной занятости';
  @override
  String get bookFailed => 'Не получилось записаться';

  // ---- Экран смены: отметка о приходе ----
  @override
  String get checkInWithCodeSnack =>
      'Отметка подтверждена кодом — заказчик её видит';
  @override
  String get checkInOkSnack => 'Отметка принята — заказчик её видит';
  @override
  String get checkInAlready => 'Вы уже отметились';
  @override
  String get checkInWrongCode =>
      'Код не подошёл — проверьте цифры у старшего смены';
  @override
  String get checkInTooEarly =>
      'Отметиться можно в день смены, не раньше чем за час до начала';
  @override
  String get checkInFailed => 'Не получилось отметиться';

  // ---- Экран смены: отмена записи ----
  @override
  String get cancelDialogTitle => 'Отменить запись?';
  @override
  String get cancelDialogBody =>
      'Место освободится, и его сможет занять другой исполнитель.\n\n'
      'Записаться заново можно будет, только если место останется '
      'свободным.';
  @override
  String get cancelKeep => 'Оставить запись';
  @override
  String get cancelConfirm => 'Отменить';
  @override
  String get cancelDone => 'Запись отменена';
  @override
  String get cancelTooLate => 'Срок отмены прошёл — запись отменить нельзя';
  @override
  String get cancelFailed => 'Не получилось отменить';

  // ---- Экран смены: лист ожидания ----
  @override
  String get waitlistJoined => 'Сообщим, как только освободится место';
  @override
  String get waitlistLeft => 'Вы больше не в листе ожидания';
  @override
  String get waitlistStarted => 'Смена уже началась';
  @override
  String get waitlistFailed => 'Не получилось';

  // ---- Плашки ----
  @override
  String get appliedBanner => 'Вы записаны на эту смену';
  @override
  String cancelUntil(String when) => 'Отменить запись можно до $when';
  @override
  String get cancelDeadlinePassed =>
      'Срок отмены прошёл. Обязательно выйдите на смену — '
      'неявка снижает рейтинг.';
  @override
  String ratingLockTitle(String min) => 'Этот заказчик берёт от $min';
  @override
  String ratingLockBody(String actual) => 'Ваш рейтинг — $actual. '
      'Отработайте несколько смен без опозданий, и он вырастет.';

  // ---- Вознаграждение ----
  @override
  String get payTitle => 'Вознаграждение';
  @override
  String get payRate => 'Ставка';
  @override
  String perHour(String amount) => '$amount / час';
  @override
  String get payDuration => 'Длительность смены';
  @override
  String get payPaid => 'Оплачивается';
  @override
  String get payFundedNote =>
      'Заказчик уже оплатил смену — деньги у сервиса. '
      'Вы получите их, когда он подтвердит ваш выход.';
  @override
  String unpaidBreak(String duration) =>
      '$duration перерыва на обед не оплачивается';

  // ---- Набор ----
  @override
  String get slotsTitle => 'Набор';
  @override
  String freeSlots(int n) => 'Свободно мест: $n';
  @override
  String get allSlotsTaken => 'Все места заняты';

  // ---- Нижняя панель ----
  @override
  String get statusCompleted => 'Смена отработана';
  @override
  String get statusCheckedIn => 'Вы отметились — ждём подтверждения';
  @override
  String get checkInButton => 'Я на месте';
  @override
  String get cancelBooking => 'Отменить запись';
  @override
  String get cancelUnavailable => 'Отмена уже недоступна';
  @override
  String get ratingTooLowButton => 'Рейтинг ниже требуемого';
  @override
  String get bookButton => 'Записаться на смену';
  @override
  String get waitlistLeaveButton => 'Вы в листе ожидания · Выйти';
  @override
  String get waitlistJoinButton => 'Мест нет · Сообщить, когда освободится';
  @override
  String get payoutNextDay => 'Вознаграждение на следующий день после смены';
  @override
  String payoutInDays(int n) => 'Вознаграждение через ${_days(n)}';

  // ---- Окно подтверждения записи ----
  @override
  String get confirmTitle => 'Подтвердите запись';
  @override
  String get confirmSubtitle =>
      'Это не заявка на рассмотрение. После подтверждения '
      'место закрепляется за вами.';
  @override
  String get summaryWhen => 'Когда';
  @override
  String get summaryWhere => 'Где';
  @override
  String get youCommit => 'Вы обязуетесь';
  @override
  String termShowUp(String when) =>
      'Выйти на смену $when и отработать её полностью.';
  @override
  String termCancelUntil(String when, int hours) =>
      'Отменить запись можно только до $when — это '
      'за ${_hoursAcc(hours)} до начала. После этого времени отмена '
      'невозможна.';
  @override
  String termNoCancel(int hours) =>
      'До начала меньше ${_hoursGen(hours)} — отменить эту запись будет '
      'нельзя. Записывайтесь, только если точно придёте.';
  @override
  String get termNoShow =>
      'Неявка без отмены снижает рейтинг и закрывает '
      'доступ к части заказчиков.';
  @override
  String termUnpaidBreak(String duration) =>
      'Оплачивается фактически отработанное время. '
      '$duration перерыва на обед не оплачивается.';
  @override
  String get termFunded =>
      'Оплата гарантирована: заказчик уже внёс деньги, '
      'сервис переведёт их вам после подтверждения смены. '
      'Комиссия с вас не удерживается.';
  @override
  String get termPayoutNextDay =>
      'Вознаграждение поступит на следующий день после смены.';
  @override
  String termPayoutInDays(int n) =>
      'Вознаграждение поступит через ${_days(n)} после смены.';
  @override
  String get termEarningsLimit =>
      'Доход через сервис — не больше 300 МРП в месяц. '
      'Если эта смена превысит лимит, запись не пройдёт.';
  @override
  String termDressCode(String dressCode) =>
      'Соблюдать требования к форме одежды: $dressCode';
  @override
  String get agreeCheckbox =>
      'Условия прочитаны — подтверждаю, что выйду на смену';
  @override
  String get back => 'Назад';
  @override
  String get confirmButton => 'Подтверждаю';

  // ---- Окно «Я на месте» ----
  @override
  String get checkInHint =>
      'Попросите у старшего смены код отметки — четыре цифры на его '
      'экране. С кодом заказчик видит, что вы точно на месте.';
  @override
  String get checkInWithoutCode => 'Без кода';
  @override
  String get checkInSubmit => 'Отметиться';

  // ---- Окно отзыва ----
  @override
  String get reviewTitle => 'Как прошла смена?';
  @override
  String get reviewHint =>
      'Что понравилось или нет? Это увидят другие исполнители';
  @override
  String get reviewSend => 'Отправить отзыв';
  @override
  List<String> get ratingLabels => const [
        'Выберите оценку',
        'Плохо',
        'Так себе',
        'Нормально',
        'Хорошо',
        'Отлично',
      ];

  // ---- Карты ----
  @override
  String get map2Gis => '2ГИС';
  @override
  String get mapYandex => 'Яндекс Карты';
  @override
  String get mapGoogle => 'Google Карты';
}

class _Kk extends ShiftStrings {
  const _Kk();

  // ---- Экран смены: шапка ----
  @override
  String get title => 'Ауысым';
  @override
  String get notFoundTitle => 'Ауысым табылмады';
  @override
  String get notFoundSubtitle =>
      'Ол жойылған немесе әлі жарияланбаған болуы мүмкін';
  @override
  String get shareTooltip => 'Бөлісу';
  @override
  String get shareCopied =>
      'Ауысым сипаттамасы көшірілді — оны чатқа қойыңыз';
  @override
  String get addressCopied => 'Мекенжай көшірілді — оны картаға қойыңыз';
  @override
  String get copyAddressTooltip => 'Мекенжайды көшіру';
  @override
  String get linkOpenFailed => 'Сілтемені ашу мүмкін болмады';
  @override
  String get routeTitle => 'Қалай жетуге болады';
  @override
  String get routeButton => 'Бағыт';
  @override
  String get toCalendar => 'Күнтізбеге';
  @override
  String get nextDaySuffix => ' (келесі күні)';
  @override
  String get duties => 'Міндеттер';
  @override
  String get dressCode => 'Киім үлгісі';
  @override
  String get employerComment => 'Тапсырыс берушінің түсініктемесі';

  // ---- Экран смены: запись ----
  @override
  String get bookedSnack => 'Сіз ауысымға жазылдыңыз';
  @override
  String get bookNoSlots => 'Болмады: бос орын қалмады';
  @override
  String get bookAlreadyBooked => 'Сіз бұл ауысымға жазылып қойғансыз';
  @override
  String get bookRatingTooLow =>
      'Рейтингіңіз бұл ауысымға қажетті деңгейден төмен';
  @override
  String get bookAlreadyStarted =>
      'Ауысым басталып кетті — оған жазылу мүмкін емес';
  @override
  String get bookTimeConflict =>
      'Бұл уақытта сізде басқа ауысым бар — екеуіне бірдей үлгеру мүмкін емес';
  @override
  String get bookAlreadyFinished =>
      'Бұл ауысым сіз үшін жабық — тапсырыс беруші қатысуыңызды белгілеп '
      'қойған';
  @override
  String get bookEarningsLimit =>
      'Бұл ауысыммен айлық табысыңыз 300 АЕК-тен асады — '
      'бұл платформалық жұмыспен қамтудың шегі';
  @override
  String get bookFailed => 'Жазылу мүмкін болмады';

  // ---- Экран смены: отметка о приходе ----
  @override
  String get checkInWithCodeSnack =>
      'Белгі кодпен расталды — тапсырыс беруші оны көреді';
  @override
  String get checkInOkSnack => 'Белгі қабылданды — тапсырыс беруші оны көреді';
  @override
  String get checkInAlready => 'Сіз келгеніңізді белгілеп қойғансыз';
  @override
  String get checkInWrongCode =>
      'Код сәйкес келмеді — цифрларды ауысым жетекшісінен тексеріңіз';
  @override
  String get checkInTooEarly =>
      'Келгеніңізді ауысым күні, басталуына бір сағаттан ерте емес '
      'белгілеуге болады';
  @override
  String get checkInFailed => 'Белгілеу мүмкін болмады';

  // ---- Экран смены: отмена записи ----
  @override
  String get cancelDialogTitle => 'Жазылудан бас тартасыз ба?';
  @override
  String get cancelDialogBody =>
      'Орын босайды, оны басқа орындаушы ала алады.\n\n'
      'Орын бос қалса ғана қайта жазыла аласыз.';
  @override
  String get cancelKeep => 'Жазылуды қалдыру';
  @override
  String get cancelConfirm => 'Бас тарту';
  @override
  String get cancelDone => 'Жазылудан бас тартылды';
  @override
  String get cancelTooLate =>
      'Бас тарту мерзімі өтті — жазылудан бас тарту мүмкін емес';
  @override
  String get cancelFailed => 'Бас тарту мүмкін болмады';

  // ---- Экран смены: лист ожидания ----
  @override
  String get waitlistJoined => 'Орын босаған бойда хабарлаймыз';
  @override
  String get waitlistLeft => 'Сіз енді күту тізімінде емессіз';
  @override
  String get waitlistStarted => 'Ауысым басталып кетті';
  @override
  String get waitlistFailed => 'Болмады';

  // ---- Плашки ----
  @override
  String get appliedBanner => 'Сіз бұл ауысымға жазылдыңыз';
  @override
  String cancelUntil(String when) => 'Жазылудан $when дейін бас тартуға болады';
  @override
  String get cancelDeadlinePassed =>
      'Бас тарту мерзімі өтті. Ауысымға міндетті түрде келіңіз — '
      'келмеу рейтингті төмендетеді.';
  @override
  String ratingLockTitle(String min) =>
      'Бұл тапсырыс беруші $min рейтингтен бастап алады';
  @override
  String ratingLockBody(String actual) => 'Сіздің рейтингіңіз — $actual. '
      'Бірнеше ауысымды кешікпей өтіңіз, сонда ол өседі.';

  // ---- Вознаграждение ----
  @override
  String get payTitle => 'Сыйақы';
  @override
  String get payRate => 'Мөлшерлеме';
  @override
  String perHour(String amount) => '$amount / сағ';
  @override
  String get payDuration => 'Ауысым ұзақтығы';
  @override
  String get payPaid => 'Төленеді';
  @override
  String get payFundedNote =>
      'Тапсырыс беруші ауысымды төлеп қойған — ақша сервисте. '
      'Ол сіздің келгеніңізді растағанда, ақшаны аласыз.';
  @override
  String unpaidBreak(String duration) => 'Түскі $duration үзіліс төленбейді';

  // ---- Набор ----
  @override
  String get slotsTitle => 'Орындар';
  @override
  String freeSlots(int n) => 'Бос орын: $n';
  @override
  String get allSlotsTaken => 'Барлық орын толды';

  // ---- Нижняя панель ----
  @override
  String get statusCompleted => 'Ауысым аяқталды';
  @override
  String get statusCheckedIn => 'Келгеніңіз белгіленді — растауды күтеміз';
  @override
  String get checkInButton => 'Мен орнымдамын';
  @override
  String get cancelBooking => 'Жазылудан бас тарту';
  @override
  String get cancelUnavailable => 'Бас тарту енді мүмкін емес';
  @override
  String get ratingTooLowButton => 'Рейтинг жеткіліксіз';
  @override
  String get bookButton => 'Ауысымға жазылу';
  @override
  String get waitlistLeaveButton => 'Сіз күту тізіміндесіз · Шығу';
  @override
  String get waitlistJoinButton => 'Орын жоқ · Босағанда хабарлау';
  @override
  String get payoutNextDay => 'Сыйақы ауысымнан кейінгі күні түседі';
  @override
  String payoutInDays(int n) => 'Сыйақы $n күннен кейін түседі';

  // ---- Окно подтверждения записи ----
  @override
  String get confirmTitle => 'Жазылуды растаңыз';
  @override
  String get confirmSubtitle =>
      'Бұл қарауға берілетін өтінім емес. Растағаннан кейін '
      'орын сізге бекітіледі.';
  @override
  String get summaryWhen => 'Қашан';
  @override
  String get summaryWhere => 'Қайда';
  @override
  String get youCommit => 'Сіз міндеттенесіз';
  @override
  String termShowUp(String when) =>
      'Ауысымға $when келу және оны толық атқару.';
  @override
  String termCancelUntil(String when, int hours) =>
      'Жазылудан тек $when дейін бас тартуға болады — бұл басталуына '
      '$hours сағат қалғанда. Осы уақыттан кейін бас тарту мүмкін емес.';
  @override
  String termNoCancel(int hours) =>
      'Басталуына $hours сағаттан аз қалды — бұл жазылудан бас тарту '
      'мүмкін болмайды. Міндетті түрде келетін болсаңыз ғана жазылыңыз.';
  @override
  String get termNoShow =>
      'Бас тартпай келмеу рейтингті төмендетеді және кейбір тапсырыс '
      'берушілерге жолды жабады.';
  @override
  String termUnpaidBreak(String duration) =>
      'Нақты жұмыс істеген уақыт төленеді. '
      'Түскі $duration үзіліс төленбейді.';
  @override
  String get termFunded =>
      'Төлем кепілді: тапсырыс беруші ақшаны салып қойған, '
      'сервис оны ауысым расталғаннан кейін сізге аударады. '
      'Сізден комиссия ұсталмайды.';
  @override
  String get termPayoutNextDay => 'Сыйақы ауысымнан кейінгі күні түседі.';
  @override
  String termPayoutInDays(int n) =>
      'Сыйақы ауысымнан кейін $n күнде түседі.';
  @override
  String get termEarningsLimit =>
      'Сервис арқылы табыс — айына 300 АЕК-тен аспайды. '
      'Бұл ауысым лимиттен асырса, жазылу өтпейді.';
  @override
  String termDressCode(String dressCode) =>
      'Киім үлгісіне қойылатын талаптарды сақтау: $dressCode';
  @override
  String get agreeCheckbox =>
      'Шарттармен таныстым — ауысымға келетінімді растаймын';
  @override
  String get back => 'Артқа';
  @override
  String get confirmButton => 'Растаймын';

  // ---- Окно «Я на месте» ----
  @override
  String get checkInHint =>
      'Ауысым жетекшісінен келу кодын сұраңыз — оның экранындағы төрт '
      'цифр. Код арқылы тапсырыс беруші сіздің шынымен орында екеніңізді '
      'көреді.';
  @override
  String get checkInWithoutCode => 'Кодсыз';
  @override
  String get checkInSubmit => 'Белгілеу';

  // ---- Окно отзыва ----
  @override
  String get reviewTitle => 'Ауысым қалай өтті?';
  @override
  String get reviewHint =>
      'Не ұнады, не ұнамады? Мұны басқа орындаушылар көреді';
  @override
  String get reviewSend => 'Пікір жіберу';
  @override
  List<String> get ratingLabels => const [
        'Бағаны таңдаңыз',
        'Нашар',
        'Онша емес',
        'Қалыпты',
        'Жақсы',
        'Өте жақсы',
      ];

  // ---- Карты ----
  @override
  String get map2Gis => '2GIS';
  @override
  String get mapYandex => 'Яндекс Карталар';
  @override
  String get mapGoogle => 'Google Карталар';
}

class _En extends ShiftStrings {
  const _En();

  static String _plural(int n, String one, String many) =>
      n == 1 ? '$n $one' : '$n $many';

  // ---- Экран смены: шапка ----
  @override
  String get title => 'Shift';
  @override
  String get notFoundTitle => 'Shift not found';
  @override
  String get notFoundSubtitle =>
      'It may have been deleted or not published yet';
  @override
  String get shareTooltip => 'Share';
  @override
  String get shareCopied => 'Shift details copied — paste them into a chat';
  @override
  String get addressCopied => 'Address copied — paste it into maps';
  @override
  String get copyAddressTooltip => 'Copy address';
  @override
  String get linkOpenFailed => "Couldn't open the link";
  @override
  String get routeTitle => 'Getting there';
  @override
  String get routeButton => 'Directions';
  @override
  String get toCalendar => 'Add to calendar';
  @override
  String get nextDaySuffix => ' (next day)';
  @override
  String get duties => 'Duties';
  @override
  String get dressCode => 'Dress code';
  @override
  String get employerComment => "Employer's note";

  // ---- Экран смены: запись ----
  @override
  String get bookedSnack => "You're booked for the shift";
  @override
  String get bookNoSlots => 'No luck: no spots left';
  @override
  String get bookAlreadyBooked => "You're already booked for this shift";
  @override
  String get bookRatingTooLow => 'Your rating is below what this shift requires';
  @override
  String get bookAlreadyStarted =>
      'The shift has already started — booking is closed';
  @override
  String get bookTimeConflict =>
      "You already have a shift at this time — you can't do both";
  @override
  String get bookAlreadyFinished =>
      'This shift is closed for you — the employer has already marked '
      'attendance';
  @override
  String get bookEarningsLimit =>
      'With this shift your monthly income would exceed 300 MCI — '
      'the limit for platform employment';
  @override
  String get bookFailed => "Couldn't book the shift";

  // ---- Экран смены: отметка о приходе ----
  @override
  String get checkInWithCodeSnack =>
      'Check-in confirmed by code — the employer can see it';
  @override
  String get checkInOkSnack => 'Check-in received — the employer can see it';
  @override
  String get checkInAlready => "You've already checked in";
  @override
  String get checkInWrongCode =>
      'Wrong code — check the digits with the shift lead';
  @override
  String get checkInTooEarly =>
      'You can check in on the day of the shift, no earlier than an hour '
      'before it starts';
  @override
  String get checkInFailed => "Couldn't check in";

  // ---- Экран смены: отмена записи ----
  @override
  String get cancelDialogTitle => 'Cancel booking?';
  @override
  String get cancelDialogBody =>
      'The spot will be freed up and another worker can take it.\n\n'
      'You can book again only if the spot is still free.';
  @override
  String get cancelKeep => 'Keep booking';
  @override
  String get cancelConfirm => 'Cancel';
  @override
  String get cancelDone => 'Booking cancelled';
  @override
  String get cancelTooLate =>
      "The cancellation deadline has passed — the booking can't be cancelled";
  @override
  String get cancelFailed => "Couldn't cancel";

  // ---- Экран смены: лист ожидания ----
  @override
  String get waitlistJoined => "We'll let you know as soon as a spot opens up";
  @override
  String get waitlistLeft => "You're no longer on the waitlist";
  @override
  String get waitlistStarted => 'The shift has already started';
  @override
  String get waitlistFailed => 'Something went wrong';

  // ---- Плашки ----
  @override
  String get appliedBanner => "You're booked for this shift";
  @override
  String cancelUntil(String when) => 'You can cancel until $when';
  @override
  String get cancelDeadlinePassed =>
      'The cancellation deadline has passed. Be sure to show up — '
      'a no-show lowers your rating.';
  @override
  String ratingLockTitle(String min) => 'This employer requires a $min+ rating';
  @override
  String ratingLockBody(String actual) => 'Your rating is $actual. '
      'Work a few shifts without being late and it will go up.';

  // ---- Вознаграждение ----
  @override
  String get payTitle => 'Pay';
  @override
  String get payRate => 'Rate';
  @override
  String perHour(String amount) => '$amount / h';
  @override
  String get payDuration => 'Shift length';
  @override
  String get payPaid => 'Paid time';
  @override
  String get payFundedNote =>
      'The employer has already paid for the shift — the service holds the '
      "money. You'll get it once they confirm your attendance.";
  @override
  String unpaidBreak(String duration) => 'The $duration lunch break is unpaid';

  // ---- Набор ----
  @override
  String get slotsTitle => 'Spots';
  @override
  String freeSlots(int n) => 'Spots left: $n';
  @override
  String get allSlotsTaken => 'All spots are taken';

  // ---- Нижняя панель ----
  @override
  String get statusCompleted => 'Shift completed';
  @override
  String get statusCheckedIn => 'Checked in — awaiting confirmation';
  @override
  String get checkInButton => "I'm here";
  @override
  String get cancelBooking => 'Cancel booking';
  @override
  String get cancelUnavailable => "Can't cancel anymore";
  @override
  String get ratingTooLowButton => 'Rating too low';
  @override
  String get bookButton => 'Book this shift';
  @override
  String get waitlistLeaveButton => "You're on the waitlist · Leave";
  @override
  String get waitlistJoinButton => 'No spots · Notify me when one opens';
  @override
  String get payoutNextDay => 'Paid the day after the shift';
  @override
  String payoutInDays(int n) =>
      'Paid ${_plural(n, 'day', 'days')} after the shift';

  // ---- Окно подтверждения записи ----
  @override
  String get confirmTitle => 'Confirm booking';
  @override
  String get confirmSubtitle =>
      "This isn't an application to be reviewed. Once you confirm, "
      'the spot is yours.';
  @override
  String get summaryWhen => 'When';
  @override
  String get summaryWhere => 'Where';
  @override
  String get youCommit => 'You agree to';
  @override
  String termShowUp(String when) =>
      'Show up for the shift on $when and work it in full.';
  @override
  String termCancelUntil(String when, int hours) =>
      'You can cancel only until $when — '
      '${_plural(hours, 'hour', 'hours')} before the start. '
      "After that, cancellation isn't possible.";
  @override
  String termNoCancel(int hours) =>
      'Less than ${_plural(hours, 'hour', 'hours')} to the start — '
      "you won't be able to cancel this booking. Book only if you're sure "
      "you'll come.";
  @override
  String get termNoShow =>
      'A no-show without cancelling lowers your rating and closes '
      'access to some employers.';
  @override
  String termUnpaidBreak(String duration) =>
      "You're paid for the time actually worked. "
      'The $duration lunch break is unpaid.';
  @override
  String get termFunded =>
      'Pay guaranteed: the employer has already paid in, and the service '
      'will transfer the money to you once the shift is confirmed. '
      'No commission is taken from you.';
  @override
  String get termPayoutNextDay => 'Pay arrives the day after the shift.';
  @override
  String termPayoutInDays(int n) =>
      'Pay arrives ${_plural(n, 'day', 'days')} after the shift.';
  @override
  String get termEarningsLimit =>
      'Income through the service is capped at 300 MCI a month. '
      "If this shift goes over the limit, the booking won't go through.";
  @override
  String termDressCode(String dressCode) => 'Follow the dress code: $dressCode';
  @override
  String get agreeCheckbox => "I've read the terms and confirm I'll show up";
  @override
  String get back => 'Back';
  @override
  String get confirmButton => 'Confirm';

  // ---- Окно «Я на месте» ----
  @override
  String get checkInHint =>
      'Ask the shift lead for the check-in code — four digits on their '
      "screen. With the code, the employer can see you're really here.";
  @override
  String get checkInWithoutCode => 'No code';
  @override
  String get checkInSubmit => 'Check in';

  // ---- Окно отзыва ----
  @override
  String get reviewTitle => 'How was the shift?';
  @override
  String get reviewHint => 'What did you like or not? Other workers will see it';
  @override
  String get reviewSend => 'Send review';
  @override
  List<String> get ratingLabels => const [
        'Choose a rating',
        'Bad',
        'So-so',
        'OK',
        'Good',
        'Excellent',
      ];

  // ---- Карты ----
  @override
  String get map2Gis => '2GIS';
  @override
  String get mapYandex => 'Yandex Maps';
  @override
  String get mapGoogle => 'Google Maps';
}
