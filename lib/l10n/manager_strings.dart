// Кабинет заказчика: его смены, создание и правка смены, оценка исполнителей, избранные.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class ManagerStrings {
  const ManagerStrings();

  /// Записался и накануне подтвердил: «точно выйду».
  String get statusComing;

  static ManagerStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };

  // ---- Общее для экранов заказчика ----
  String get notYourShift;
  String get shiftPublished;
  String get paymentTitle;

  /// «Вознаграждение: 3 × 12 100 ₸» — строка в окне оплаты.
  String rewardLine(int slots, String slotPay);
  String serviceFee(int percent);

  /// Кнопка «Оплатить 37 752 ₸».
  String payAmount(String amount);
  String get removeFromFavorites;
  String removedFromFavorites(String name);

  // ---- Мои смены ----
  String get myShiftsTitle;
  String get cancelShiftTitle;
  String cancelShiftHired(int hired);
  String get cancelShiftEmpty;
  String get no;
  String get cancelShiftButton;
  String get shiftCancelled;
  String get shiftAlreadyCancelled;
  String get cancelTooLate;
  String get cancelFailed;
  String get payExistingNote;
  String get emptyTitle;
  String get emptySubtitle;
  String get createShiftAction;

  // ---- Сводка над списком ----
  String get statShifts;
  String get statFilled;

  /// «потрачено в сентябре»; `month` — 1…12.
  String statSpent(int month);

  // ---- Карточка смены ----
  String get statusCancelled;
  String get statusAwaitingPayment;
  String get statusPast;
  String get statusFull;
  String get statusHiring;

  /// «12 100 ₸ за смену · 1 100 ₸/ч».
  String payPerShift(String total, String rate);
  String get hiddenUntilPaid;
  String fundedNote(String amount);
  String get refundedNote;
  String get viewApplicants;
  String get edit;
  String get cancel;
  String get repeat;

  // ---- Записавшиеся ----
  String get applicantsTitle;
  String get noShowTitle;
  String noShowBody(String name);
  String get dialogCancel;

  /// «Не вышел» — кнопка и ярлык невыхода.
  String get noShowLabel;
  String noShowMarked(String name);
  String get noShowTooEarly;
  String get noShowFailed;
  String addedToFavorites(String name);
  String get favoritesOnlyWorked;
  String attendanceConfirmed(String name);
  String get confirmTooEarly;
  String get confirmFailed;
  String get noApplicantsTitle;
  String get noApplicantsSubtitle;
  String get checkInCodeTitle;
  String get checkInCodeHint;
  String get attendanceHint;
  String get verified;
  String get notVerified;
  String get addToFavorites;
  String get statusWorked;
  String get statusOnSiteCode;
  String get statusOnSite;
  String get statusBooked;

  /// «Выходит: 90% · невыходов 1».
  String reliabilityLine(int percent, int noShows);

  /// «Отметился в 09:58».
  String checkedInAt(String time);

  /// «Вышел» — подтвердить выход.
  String get showedUp;

  // ---- Создание и правка смены ----
  String get editShiftTitle;
  String get repeatShiftTitle;
  String get newShiftTitle;

  /// С чего начинается название новой смены: «Услуги …». Пусто, если в
  /// языке слово «услуги» стоит не в начале.
  String get titlePrefill;

  /// Название компании, если в профиле заказчика его нет.
  String get companyFallback;
  String get needCategory;
  String get surchargeTitle;
  String get surchargeNote;
  String get priceDifference;
  String surchargeAmount(String amount);
  String get editAwaitsSurcharge;
  String get changesSaved;
  String get payNewNote;
  String get savedAwaitingPayment;
  String editFewerThanHired(int hired);
  String get editShiftCancelled;
  String get editNotPaid;
  String get editTooLate;
  String get saveFailed;
  String get categoryLabel;
  String get servicesLabel;
  String get titleHint;
  String get addressLabel;
  String get addressHint;
  String get whenSection;
  String get dateLabel;
  String get startLabel;
  String get endLabel;
  String get nightShift;
  String get paySection;
  String get rateLabel;
  String get workersLabel;
  String get dutiesSection;
  String get dutiesHelp;
  String get dutiesHint;
  String get save;
  String get payAndPublish;
  String get summaryDuration;
  String get summaryPaid;
  String get summaryPerPerson;
  String get summaryAllWorkers;
  String get summaryTotal;
  String get chooseCategory;
  String get findCategory;
  String get noSuchCategory;

  // ---- Оценки ----
  String get ratingsTitle;
  String get rateSheetTitle;
  String get rateSheetHint;
  String get rateSheetButton;
  String ratedSnack(String name);
  String get allRatedTitle;
  String get allRatedSubtitle;
  String get ratingExplainer;
  String get rateChip;

  // ---- Любимые исполнители ----
  String get favoritesTitle;
  String get favoritesEmptyTitle;
  String get favoritesEmptySubtitle;
  String get favoritesHint;

  /// «★ 4.8 · 3 смены у вас · Алматы».
  String favoriteStats(String rating, String shifts, String city);
}

class _Ru extends ManagerStrings {
  const _Ru();

  @override
  String get statusComing => 'Точно выйдет';

  // ---- Общее для экранов заказчика ----
  @override
  String get notYourShift => 'Это не ваша смена';
  @override
  String get shiftPublished => 'Смена опубликована';
  @override
  String get paymentTitle => 'Оплата смены';
  @override
  String rewardLine(int slots, String slotPay) =>
      'Вознаграждение: $slots × $slotPay';
  @override
  String serviceFee(int percent) => 'Комиссия сервиса $percent%';
  @override
  String payAmount(String amount) => 'Оплатить $amount';
  @override
  String get removeFromFavorites => 'Убрать из любимых';
  @override
  String removedFromFavorites(String name) => '$name убран из любимых';

  // ---- Мои смены ----
  @override
  String get myShiftsTitle => 'Мои смены';
  @override
  String get cancelShiftTitle => 'Отменить смену?';
  @override
  String cancelShiftHired(int hired) => 'На смену записались $hired чел. '
      'Все получат уведомление, что выходить не нужно.';
  @override
  String get cancelShiftEmpty =>
      'Смена пропадёт из ленты. Вернуть её будет нельзя — '
      'нужно будет создать новую.';
  @override
  String get no => 'Нет';
  @override
  String get cancelShiftButton => 'Отменить смену';
  @override
  String get shiftCancelled => 'Смена отменена';
  @override
  String get shiftAlreadyCancelled => 'Смена уже отменена';
  @override
  String get cancelTooLate => 'Смена уже началась — отменить её нельзя';
  @override
  String get cancelFailed => 'Смену не удалось отменить';
  @override
  String get payExistingNote =>
      'Смена появится в ленте, как только пройдёт оплата.';
  @override
  String get emptyTitle => 'Смен пока нет';
  @override
  String get emptySubtitle => 'Опубликуйте первую — люди увидят её\n'
      'в ленте сразу после оплаты';
  @override
  String get createShiftAction => 'Создать смену';

  // ---- Сводка над списком ----
  @override
  String get statShifts => 'смен за 30 дней';
  @override
  String get statFilled => 'мест заполнено';
  @override
  String statSpent(int month) => 'потрачено в ${_monthsIn[month - 1]}';

  static const _monthsIn = [
    'январе', 'феврале', 'марте', 'апреле', 'мае', 'июне',
    'июле', 'августе', 'сентябре', 'октябре', 'ноябре', 'декабре',
  ];

  // ---- Карточка смены ----
  @override
  String get statusCancelled => 'Отменена';
  @override
  String get statusAwaitingPayment => 'Ждёт оплаты';
  @override
  String get statusPast => 'Прошла';
  @override
  String get statusFull => 'Набрана';
  @override
  String get statusHiring => 'Идёт набор';
  @override
  String payPerShift(String total, String rate) =>
      '$total за смену · $rate/ч';
  @override
  String get hiddenUntilPaid =>
      'Исполнители не видят смену, пока она не оплачена';
  @override
  String fundedNote(String amount) => 'Оплачено $amount — '
      'деньги у сервиса до подтверждения выхода';
  @override
  String get refundedNote => 'Неизрасходованное возвращено на карту';
  @override
  String get viewApplicants => 'Посмотреть записавшихся';
  @override
  String get edit => 'Изменить';
  @override
  String get cancel => 'Отменить';
  @override
  String get repeat => 'Повторить';

  // ---- Записавшиеся ----
  @override
  String get applicantsTitle => 'Записались';
  @override
  String get noShowTitle => 'Отметить невыход?';
  @override
  String noShowBody(String name) => '$name не вышел на смену. '
      'Отметка видна другим заказчикам и влияет на надёжность — '
      'ставьте её, только если человек действительно не пришёл.';
  @override
  String get dialogCancel => 'Отмена';
  @override
  String get noShowLabel => 'Не вышел';
  @override
  String noShowMarked(String name) => 'Отмечено: $name не вышел';
  @override
  String get noShowTooEarly => 'Смена ещё не началась — отмечать невыход рано';
  @override
  String get noShowFailed => 'Не получилось отметить';
  @override
  String addedToFavorites(String name) =>
      '$name — в любимых. Позовём на ваши следующие смены';
  @override
  String get favoritesOnlyWorked =>
      'В любимые — только тех, кто у вас уже отработал';
  @override
  String attendanceConfirmed(String name) => 'Смена засчитана: $name';
  @override
  String get confirmTooEarly =>
      'Смена ещё не началась — засчитать её можно после начала';
  @override
  String get confirmFailed => 'Не получилось засчитать';
  @override
  String get noApplicantsTitle => 'Пока никто не записался';
  @override
  String get noApplicantsSubtitle =>
      'Смена опубликована — исполнители её видят';
  @override
  String get checkInCodeTitle => 'Код отметки';
  @override
  String get checkInCodeHint => 'Покажите его людям на месте: кто введёт код, '
      'тот точно пришёл';
  @override
  String get attendanceHint =>
      'Исполнитель отмечается сам в день смены. Подтвердите '
      'выход — только после этого смена идёт в оплату.';
  @override
  String get verified => 'Верифицирован';
  @override
  String get notVerified => 'Без проверки';
  @override
  String get addToFavorites => 'В любимые исполнители';
  @override
  String get statusWorked => 'Отработал';
  @override
  String get statusOnSiteCode => 'На месте · код';
  @override
  String get statusOnSite => 'На месте';
  @override
  String get statusBooked => 'Записан';
  @override
  String reliabilityLine(int percent, int noShows) =>
      'Выходит: $percent% · невыходов $noShows';
  @override
  String checkedInAt(String time) => 'Отметился в $time';
  @override
  String get showedUp => 'Вышел';

  // ---- Создание и правка смены ----
  @override
  String get editShiftTitle => 'Изменить смену';
  @override
  String get repeatShiftTitle => 'Повторить смену';
  @override
  String get newShiftTitle => 'Новая смена';
  @override
  String get titlePrefill => 'Услуги ';
  @override
  String get companyFallback => 'Компания';
  @override
  String get needCategory => 'Выберите категорию работ';
  @override
  String get surchargeTitle => 'Доплата за смену';
  @override
  String get surchargeNote =>
      'Смена подорожала. Новые условия появятся в ленте, как '
      'только пройдёт доплата: сервис держит оплату за все места '
      'заранее.';
  @override
  String get priceDifference => 'Разница в стоимости';
  @override
  String surchargeAmount(String amount) => 'Доплатить $amount';
  @override
  String get editAwaitsSurcharge => 'Правка применится, когда пройдёт доплата';
  @override
  String get changesSaved => 'Изменения сохранены';
  @override
  String get payNewNote =>
      'Деньги останутся у сервиса и уйдут исполнителям только после '
      'того, как вы подтвердите их выход. За невышедших и при отмене '
      'смены деньги вернутся.';
  @override
  String get savedAwaitingPayment =>
      'Смена сохранена и появится в ленте, когда пройдёт оплата. '
      'Оплатить можно в «Моих сменах»';
  @override
  String editFewerThanHired(int hired) => 'Уже набрано $hired чел. — '
      'мест не может быть меньше';
  @override
  String get editShiftCancelled => 'Смена отменена';
  @override
  String get editNotPaid => 'Смена ещё не оплачена — сначала оплатите её';
  @override
  String get editTooLate => 'Смена уже началась — менять условия поздно';
  @override
  String get saveFailed => 'Не получилось сохранить';
  @override
  String get categoryLabel => 'Категория работ';
  @override
  String get servicesLabel => 'Какие услуги нужны';
  @override
  String get titleHint => 'Услуги сотрудника склада';
  @override
  String get addressLabel => 'Адрес';
  @override
  String get addressHint => 'г. Алматы, ул. Абая, 10';
  @override
  String get whenSection => 'Когда';
  @override
  String get dateLabel => 'Дата';
  @override
  String get startLabel => 'Начало';
  @override
  String get endLabel => 'Конец';
  @override
  String get nightShift => 'Ночная смена — закончится на следующий день';
  @override
  String get paySection => 'Оплата и люди';
  @override
  String get rateLabel => 'Ставка, ₸/час';
  @override
  String get workersLabel => 'Человек';
  @override
  String get dutiesSection => 'Обязанности';
  @override
  String get dutiesHelp => 'По одному пункту в строке';
  @override
  String get dutiesHint => 'Разгружать машины\nСортировать товар';
  @override
  String get save => 'Сохранить';
  @override
  String get payAndPublish => 'Оплатить и опубликовать';
  @override
  String get summaryDuration => 'Длительность';
  @override
  String get summaryPaid => 'Оплачивается';
  @override
  String get summaryPerPerson => 'Одному человеку';
  @override
  String get summaryAllWorkers => 'Всем исполнителям';
  @override
  String get summaryTotal => 'К оплате';
  @override
  String get chooseCategory => 'Выберите категорию';
  @override
  String get findCategory => 'Найти категорию';
  @override
  String get noSuchCategory => 'Такой категории нет — выберите «Другое»';

  // ---- Оценки ----
  @override
  String get ratingsTitle => 'Оценки';
  @override
  String get rateSheetTitle => 'Оцените исполнителя';
  @override
  String get rateSheetHint => 'Пришёл вовремя? Справился с работой? '
      'Это увидят другие заказчики';
  @override
  String get rateSheetButton => 'Поставить оценку';
  @override
  String ratedSnack(String name) => 'Оценка учтена в рейтинге $name';
  @override
  String get allRatedTitle => 'Все оценены';
  @override
  String get allRatedSubtitle => 'Как только пройдёт следующая смена,\n'
      'её участники появятся здесь';
  @override
  String get ratingExplainer =>
      'Оценка сразу меняет рейтинг исполнителя — по нему его '
      'выбирают другие заказчики.';
  @override
  String get rateChip => 'Оценить';

  // ---- Любимые исполнители ----
  @override
  String get favoritesTitle => 'Любимые исполнители';
  @override
  String get favoritesEmptyTitle => 'Пока никого';
  @override
  String get favoritesEmptySubtitle =>
      'Отметьте сердечком тех, кто хорошо отработал, —\n'
      'в списке записавшихся на прошедшую смену.\n'
      'Они первыми узнают о ваших новых сменах';
  @override
  String get favoritesHint =>
      'Когда вы публикуете смену, этим людям приходит приглашение '
      '— если они в том же городе.';
  @override
  String favoriteStats(String rating, String shifts, String city) =>
      '★ $rating · $shifts у вас · $city';
}

class _Kk extends ManagerStrings {
  const _Kk();

  @override
  String get statusComing => 'Келетінін растады';

  // ---- Общее для экранов заказчика ----
  @override
  String get notYourShift => 'Бұл сіздің ауысымыңыз емес';
  @override
  String get shiftPublished => 'Ауысым жарияланды';
  @override
  String get paymentTitle => 'Ауысымға төлем';
  @override
  String rewardLine(int slots, String slotPay) =>
      'Сыйақы: $slots × $slotPay';
  @override
  String serviceFee(int percent) => 'Сервис комиссиясы $percent%';
  @override
  String payAmount(String amount) => '$amount төлеу';
  @override
  String get removeFromFavorites => 'Таңдаулылардан алып тастау';
  @override
  String removedFromFavorites(String name) =>
      '$name таңдаулылардан алынып тасталды';

  // ---- Мои смены ----
  @override
  String get myShiftsTitle => 'Менің ауысымдарым';
  @override
  String get cancelShiftTitle => 'Ауысымды болдырмайсыз ба?';
  @override
  String cancelShiftHired(int hired) => 'Ауысымға $hired адам жазылған. '
      'Барлығына келудің қажеті жоқ деген хабарлама барады.';
  @override
  String get cancelShiftEmpty =>
      'Ауысым таспадан жоғалады. Оны қайтару мүмкін емес — '
      'жаңасын құруға тура келеді.';
  @override
  String get no => 'Жоқ';
  @override
  String get cancelShiftButton => 'Ауысымды болдырмау';
  @override
  String get shiftCancelled => 'Ауысымның күші жойылды';
  @override
  String get shiftAlreadyCancelled => 'Ауысымның күші бұрын жойылған';
  @override
  String get cancelTooLate => 'Ауысым басталып кетті — енді болдырмау мүмкін емес';
  @override
  String get cancelFailed => 'Ауысымды болдырмау мүмкін болмады';
  @override
  String get payExistingNote =>
      'Төлем өткен бойда ауысым таспада пайда болады.';
  @override
  String get emptyTitle => 'Әзірге ауысым жоқ';
  @override
  String get emptySubtitle => 'Алғашқысын жариялаңыз — төлемнен кейін\n'
      'адамдар оны таспадан бірден көреді';
  @override
  String get createShiftAction => 'Ауысым құру';

  // ---- Сводка над списком ----
  @override
  String get statShifts => '30 күндегі ауысым';
  @override
  String get statFilled => 'орын толды';
  @override
  String statSpent(int month) => '${_monthsIn[month - 1]} жұмсалды';

  static const _monthsIn = [
    'қаңтарда', 'ақпанда', 'наурызда', 'сәуірде', 'мамырда', 'маусымда',
    'шілдеде', 'тамызда', 'қыркүйекте', 'қазанда', 'қарашада', 'желтоқсанда',
  ];

  // ---- Карточка смены ----
  @override
  String get statusCancelled => 'Күші жойылды';
  @override
  String get statusAwaitingPayment => 'Төлем күтуде';
  @override
  String get statusPast => 'Өтті';
  @override
  String get statusFull => 'Толды';
  @override
  String get statusHiring => 'Жинақталуда';
  @override
  String payPerShift(String total, String rate) =>
      'Ауысымға $total · $rate/сағ';
  @override
  String get hiddenUntilPaid =>
      'Төленбейінше орындаушылар ауысымды көрмейді';
  @override
  String fundedNote(String amount) => '$amount төленді — '
      'келгені расталғанша ақша сервисте сақталады';
  @override
  String get refundedNote => 'Жұмсалмаған қаражат картаға қайтарылды';
  @override
  String get viewApplicants => 'Жазылғандарды көру';
  @override
  String get edit => 'Өзгерту';
  @override
  String get cancel => 'Болдырмау';
  @override
  String get repeat => 'Қайталау';

  // ---- Записавшиеся ----
  @override
  String get applicantsTitle => 'Жазылғандар';
  @override
  String get noShowTitle => 'Келмеуді белгілейсіз бе?';
  @override
  String noShowBody(String name) => '$name ауысымға келмеді. '
      'Бұл белгіні басқа тапсырыс берушілер көреді және ол сенімділікке '
      'әсер етеді — адам шынымен келмесе ғана қойыңыз.';
  @override
  String get dialogCancel => 'Бас тарту';
  @override
  String get noShowLabel => 'Келмеді';
  @override
  String noShowMarked(String name) => 'Белгіленді: $name келмеді';
  @override
  String get noShowTooEarly =>
      'Ауысым әлі басталған жоқ — келмеуді белгілеуге ерте';
  @override
  String get noShowFailed => 'Белгілеу мүмкін болмады';
  @override
  String addedToFavorites(String name) =>
      '$name — таңдаулыларда. Келесі ауысымдарыңызға шақырамыз';
  @override
  String get favoritesOnlyWorked =>
      'Таңдаулыларға тек сізде жұмыс істеген адамдарды қосуға болады';
  @override
  String attendanceConfirmed(String name) => 'Ауысым есептелді: $name';
  @override
  String get confirmTooEarly =>
      'Ауысым әлі басталған жоқ — оны басталғаннан кейін есептеуге болады';
  @override
  String get confirmFailed => 'Есептеу мүмкін болмады';
  @override
  String get noApplicantsTitle => 'Әзірге ешкім жазылған жоқ';
  @override
  String get noApplicantsSubtitle =>
      'Ауысым жарияланды — орындаушылар оны көреді';
  @override
  String get checkInCodeTitle => 'Келу коды';
  @override
  String get checkInCodeHint => 'Оны орнындағы адамдарға көрсетіңіз: кодты '
      'енгізген адам шынымен келген';
  @override
  String get attendanceHint =>
      'Орындаушы ауысым күні келгенін өзі белгілейді. Келгенін '
      'растаңыз — содан кейін ғана ауысым төлемге жіберіледі.';
  @override
  String get verified => 'Расталған';
  @override
  String get notVerified => 'Тексерілмеген';
  @override
  String get addToFavorites => 'Таңдаулы орындаушыларға қосу';
  @override
  String get statusWorked => 'Жұмыс істеді';
  @override
  String get statusOnSiteCode => 'Орнында · код';
  @override
  String get statusOnSite => 'Орнында';
  @override
  String get statusBooked => 'Жазылған';
  @override
  String reliabilityLine(int percent, int noShows) =>
      'Келеді: $percent% · келмеу саны $noShows';
  @override
  String checkedInAt(String time) => 'Келгенін белгіледі: $time';
  @override
  String get showedUp => 'Келді';

  // ---- Создание и правка смены ----
  @override
  String get editShiftTitle => 'Ауысымды өзгерту';
  @override
  String get repeatShiftTitle => 'Ауысымды қайталау';
  @override
  String get newShiftTitle => 'Жаңа ауысым';
  // Қазақшада «қызметтері» сөзі соңында тұрады — алдын ала толтырмаймыз.
  @override
  String get titlePrefill => '';
  @override
  String get companyFallback => 'Компания';
  @override
  String get needCategory => 'Жұмыс санатын таңдаңыз';
  @override
  String get surchargeTitle => 'Ауысымға қосымша төлем';
  @override
  String get surchargeNote =>
      'Ауысым қымбаттады. Жаңа шарттар қосымша төлем өткен бойда '
      'таспада пайда болады: сервис барлық орынның төлемін алдын ала '
      'сақтайды.';
  @override
  String get priceDifference => 'Құн айырмасы';
  @override
  String surchargeAmount(String amount) => '$amount қосымша төлеу';
  @override
  String get editAwaitsSurcharge =>
      'Өзгерістер қосымша төлем өткенде күшіне енеді';
  @override
  String get changesSaved => 'Өзгерістер сақталды';
  @override
  String get payNewNote =>
      'Ақша сервисте қалады және сіз орындаушылардың келгенін '
      'растағаннан кейін ғана оларға аударылады. Келмегендер үшін және '
      'ауысымның күші жойылса, ақша қайтарылады.';
  @override
  String get savedAwaitingPayment =>
      'Ауысым сақталды, төлем өткенде таспада пайда болады. '
      'Оны «Менің ауысымдарым» бөлімінде төлеуге болады';
  @override
  String editFewerThanHired(int hired) => 'Қазірдің өзінде $hired адам '
      'жиналды — орын саны бұдан аз бола алмайды';
  @override
  String get editShiftCancelled => 'Ауысымның күші жойылған';
  @override
  String get editNotPaid => 'Ауысым әлі төленбеген — алдымен оны төлеңіз';
  @override
  String get editTooLate =>
      'Ауысым басталып кетті — шарттарды өзгертуге кеш';
  @override
  String get saveFailed => 'Сақтау мүмкін болмады';
  @override
  String get categoryLabel => 'Жұмыс санаты';
  @override
  String get servicesLabel => 'Қандай қызметтер керек';
  @override
  String get titleHint => 'Қойма қызметкерінің қызметтері';
  @override
  String get addressLabel => 'Мекенжай';
  @override
  String get addressHint => 'Алматы қ., Абай к-сі, 10';
  @override
  String get whenSection => 'Қашан';
  @override
  String get dateLabel => 'Күні';
  @override
  String get startLabel => 'Басталуы';
  @override
  String get endLabel => 'Аяқталуы';
  @override
  String get nightShift => 'Түнгі ауысым — келесі күні аяқталады';
  @override
  String get paySection => 'Төлем және адамдар';
  @override
  String get rateLabel => 'Мөлшерлеме, ₸/сағ';
  @override
  String get workersLabel => 'Адам саны';
  @override
  String get dutiesSection => 'Міндеттер';
  @override
  String get dutiesHelp => 'Әр жолға бір тармақ';
  @override
  String get dutiesHint => 'Көлік түсіру\nТауарды сұрыптау';
  @override
  String get save => 'Сақтау';
  @override
  String get payAndPublish => 'Төлеп, жариялау';
  @override
  String get summaryDuration => 'Ұзақтығы';
  @override
  String get summaryPaid => 'Төленетін уақыт';
  @override
  String get summaryPerPerson => 'Бір адамға';
  @override
  String get summaryAllWorkers => 'Барлық орындаушыға';
  @override
  String get summaryTotal => 'Төлеуге';
  @override
  String get chooseCategory => 'Санатты таңдаңыз';
  @override
  String get findCategory => 'Санатты табу';
  @override
  String get noSuchCategory => 'Мұндай санат жоқ — «Басқа» дегенді таңдаңыз';

  // ---- Оценки ----
  @override
  String get ratingsTitle => 'Бағалар';
  @override
  String get rateSheetTitle => 'Орындаушыны бағалаңыз';
  @override
  String get rateSheetHint => 'Уақытында келді ме? Жұмысты атқарды ма? '
      'Мұны басқа тапсырыс берушілер көреді';
  @override
  String get rateSheetButton => 'Баға қою';
  @override
  String ratedSnack(String name) => 'Баға $name рейтингіне есептелді';
  @override
  String get allRatedTitle => 'Барлығы бағаланды';
  @override
  String get allRatedSubtitle => 'Келесі ауысым өткен бойда\n'
      'оның қатысушылары осында шығады';
  @override
  String get ratingExplainer =>
      'Баға орындаушының рейтингін бірден өзгертеді — басқа тапсырыс '
      'берушілер оны осы рейтинг бойынша таңдайды.';
  @override
  String get rateChip => 'Бағалау';

  // ---- Любимые исполнители ----
  @override
  String get favoritesTitle => 'Таңдаулы орындаушылар';
  @override
  String get favoritesEmptyTitle => 'Әзірге ешкім жоқ';
  @override
  String get favoritesEmptySubtitle =>
      'Жақсы жұмыс істегендерді жүрекшемен белгілеңіз —\n'
      'өткен ауысымға жазылғандар тізімінде.\n'
      'Олар жаңа ауысымдарыңыз туралы бірінші біледі';
  @override
  String get favoritesHint =>
      'Сіз ауысым жариялағанда бұл адамдарға шақыру келеді '
      '— егер олар сол қалада болса.';
  @override
  String favoriteStats(String rating, String shifts, String city) =>
      '★ $rating · сізде $shifts · $city';
}

class _En extends ManagerStrings {
  const _En();

  @override
  String get statusComing => 'Confirmed coming';

  // ---- Общее для экранов заказчика ----
  @override
  String get notYourShift => 'This isn\'t your shift';
  @override
  String get shiftPublished => 'Shift published';
  @override
  String get paymentTitle => 'Shift payment';
  @override
  String rewardLine(int slots, String slotPay) => 'Pay: $slots × $slotPay';
  @override
  String serviceFee(int percent) => 'Service fee $percent%';
  @override
  String payAmount(String amount) => 'Pay $amount';
  @override
  String get removeFromFavorites => 'Remove from favorites';
  @override
  String removedFromFavorites(String name) =>
      '$name removed from favorites';

  // ---- Мои смены ----
  @override
  String get myShiftsTitle => 'My shifts';
  @override
  String get cancelShiftTitle => 'Cancel shift?';
  @override
  String cancelShiftHired(int hired) => 'People booked: $hired. '
      'Everyone will be notified that they don\'t need to come.';
  @override
  String get cancelShiftEmpty =>
      'The shift will disappear from the feed. You can\'t restore it — '
      'you\'ll have to create a new one.';
  @override
  String get no => 'No';
  @override
  String get cancelShiftButton => 'Cancel shift';
  @override
  String get shiftCancelled => 'Shift cancelled';
  @override
  String get shiftAlreadyCancelled => 'Shift already cancelled';
  @override
  String get cancelTooLate => 'The shift has started — it can\'t be cancelled';
  @override
  String get cancelFailed => 'Couldn\'t cancel the shift';
  @override
  String get payExistingNote =>
      'The shift will appear in the feed as soon as payment goes through.';
  @override
  String get emptyTitle => 'No shifts yet';
  @override
  String get emptySubtitle => 'Publish your first — people will see it\n'
      'in the feed right after payment';
  @override
  String get createShiftAction => 'Create shift';

  // ---- Сводка над списком ----
  @override
  String get statShifts => 'shifts in 30 days';
  @override
  String get statFilled => 'spots filled';
  @override
  String statSpent(int month) => 'spent in ${_months[month - 1]}';

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  // ---- Карточка смены ----
  @override
  String get statusCancelled => 'Cancelled';
  @override
  String get statusAwaitingPayment => 'Awaiting payment';
  @override
  String get statusPast => 'Past';
  @override
  String get statusFull => 'Full';
  @override
  String get statusHiring => 'Hiring';
  @override
  String payPerShift(String total, String rate) =>
      '$total per shift · $rate/h';
  @override
  String get hiddenUntilPaid => 'Workers can\'t see the shift until it\'s paid';
  @override
  String fundedNote(String amount) => 'Paid $amount — '
      'the service holds the money until attendance is confirmed';
  @override
  String get refundedNote => 'Unused funds returned to your card';
  @override
  String get viewApplicants => 'View bookings';
  @override
  String get edit => 'Edit';
  @override
  String get cancel => 'Cancel';
  @override
  String get repeat => 'Repeat';

  // ---- Записавшиеся ----
  @override
  String get applicantsTitle => 'Booked';
  @override
  String get noShowTitle => 'Mark as no-show?';
  @override
  String noShowBody(String name) => '$name didn\'t show up for the shift. '
      'Other employers see this mark and it affects reliability — '
      'only use it if the person really didn\'t come.';
  @override
  String get dialogCancel => 'Cancel';
  @override
  String get noShowLabel => 'No-show';
  @override
  String noShowMarked(String name) => 'Marked: $name didn\'t show up';
  @override
  String get noShowTooEarly =>
      'The shift hasn\'t started yet — too early to mark a no-show';
  @override
  String get noShowFailed => 'Couldn\'t mark it';
  @override
  String addedToFavorites(String name) =>
      '$name is in your favorites. We\'ll invite them to your next shifts';
  @override
  String get favoritesOnlyWorked =>
      'Only people who\'ve already worked for you can be favorites';
  @override
  String attendanceConfirmed(String name) => 'Shift counted: $name';
  @override
  String get confirmTooEarly =>
      'The shift hasn\'t started yet — you can count it once it starts';
  @override
  String get confirmFailed => 'Couldn\'t count the shift';
  @override
  String get noApplicantsTitle => 'No bookings yet';
  @override
  String get noApplicantsSubtitle =>
      'The shift is published — workers can see it';
  @override
  String get checkInCodeTitle => 'Check-in code';
  @override
  String get checkInCodeHint => 'Show it to people on site: whoever enters '
      'the code is definitely here';
  @override
  String get attendanceHint =>
      'Workers check in themselves on the day of the shift. Confirm '
      'attendance — only then does the shift go to payout.';
  @override
  String get verified => 'Verified';
  @override
  String get notVerified => 'Not verified';
  @override
  String get addToFavorites => 'Add to favorite workers';
  @override
  String get statusWorked => 'Worked';
  @override
  String get statusOnSiteCode => 'On site · code';
  @override
  String get statusOnSite => 'On site';
  @override
  String get statusBooked => 'Booked';
  @override
  String reliabilityLine(int percent, int noShows) =>
      'Shows up: $percent% · no-shows $noShows';
  @override
  String checkedInAt(String time) => 'Checked in at $time';
  @override
  String get showedUp => 'Showed up';

  // ---- Создание и правка смены ----
  @override
  String get editShiftTitle => 'Edit shift';
  @override
  String get repeatShiftTitle => 'Repeat shift';
  @override
  String get newShiftTitle => 'New shift';
  @override
  String get titlePrefill => '';
  @override
  String get companyFallback => 'Company';
  @override
  String get needCategory => 'Choose a job category';
  @override
  String get surchargeTitle => 'Extra payment';
  @override
  String get surchargeNote =>
      'The shift now costs more. The new terms will appear in the feed '
      'once the extra payment goes through: the service holds pay for all '
      'spots in advance.';
  @override
  String get priceDifference => 'Price difference';
  @override
  String surchargeAmount(String amount) => 'Pay extra $amount';
  @override
  String get editAwaitsSurcharge =>
      'Changes will apply once the extra payment goes through';
  @override
  String get changesSaved => 'Changes saved';
  @override
  String get payNewNote =>
      'The service holds the money and pays workers only after you '
      'confirm they showed up. No-shows and cancelled shifts are '
      'refunded.';
  @override
  String get savedAwaitingPayment =>
      'Shift saved — it will appear in the feed once payment goes through. '
      'You can pay in “My shifts”';
  @override
  String editFewerThanHired(int hired) => 'Already booked: $hired — '
      'there can\'t be fewer spots';
  @override
  String get editShiftCancelled => 'The shift is cancelled';
  @override
  String get editNotPaid => 'The shift isn\'t paid yet — pay for it first';
  @override
  String get editTooLate =>
      'The shift has started — too late to change the terms';
  @override
  String get saveFailed => 'Couldn\'t save';
  @override
  String get categoryLabel => 'Job category';
  @override
  String get servicesLabel => 'What services you need';
  @override
  String get titleHint => 'Warehouse staff services';
  @override
  String get addressLabel => 'Address';
  @override
  String get addressHint => '10 Abay St, Almaty';
  @override
  String get whenSection => 'When';
  @override
  String get dateLabel => 'Date';
  @override
  String get startLabel => 'Start';
  @override
  String get endLabel => 'End';
  @override
  String get nightShift => 'Night shift — ends the next day';
  @override
  String get paySection => 'Pay and people';
  @override
  String get rateLabel => 'Rate, ₸/h';
  @override
  String get workersLabel => 'People';
  @override
  String get dutiesSection => 'Duties';
  @override
  String get dutiesHelp => 'One item per line';
  @override
  String get dutiesHint => 'Unload trucks\nSort goods';
  @override
  String get save => 'Save';
  @override
  String get payAndPublish => 'Pay and publish';
  @override
  String get summaryDuration => 'Duration';
  @override
  String get summaryPaid => 'Paid time';
  @override
  String get summaryPerPerson => 'Per person';
  @override
  String get summaryAllWorkers => 'All workers';
  @override
  String get summaryTotal => 'Total';
  @override
  String get chooseCategory => 'Choose a category';
  @override
  String get findCategory => 'Find a category';
  @override
  String get noSuchCategory => 'No such category — choose “Other”';

  // ---- Оценки ----
  @override
  String get ratingsTitle => 'Ratings';
  @override
  String get rateSheetTitle => 'Rate the worker';
  @override
  String get rateSheetHint => 'On time? Did the job well? '
      'Other employers will see this';
  @override
  String get rateSheetButton => 'Submit rating';
  @override
  String ratedSnack(String name) => 'Rating added to $name\'s score';
  @override
  String get allRatedTitle => 'All rated';
  @override
  String get allRatedSubtitle => 'As soon as your next shift ends,\n'
      'its workers will show up here';
  @override
  String get ratingExplainer =>
      'Your rating changes the worker\'s score right away — other '
      'employers choose workers by it.';
  @override
  String get rateChip => 'Rate';

  // ---- Любимые исполнители ----
  @override
  String get favoritesTitle => 'Favorite workers';
  @override
  String get favoritesEmptyTitle => 'No one yet';
  @override
  String get favoritesEmptySubtitle =>
      'Tap the heart next to people who did a good job —\n'
      'in the booking list of a past shift.\n'
      'They\'ll be the first to hear about your new shifts';
  @override
  String get favoritesHint =>
      'When you publish a shift, these people get an invitation '
      '— if they\'re in the same city.';
  @override
  String favoriteStats(String rating, String shifts, String city) =>
      '★ $rating · $shifts with you · $city';
}
