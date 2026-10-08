// Истории: тексты, инфографика, просмотрщик.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class StoriesStrings {
  const StoriesStrings();

  static StoriesStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };

  // ---- Лента кружков и просмотрщик ----
  /// Подпись кружка для экранного диктора.
  String storyLabel(String title);
  String newStoryLabel(String title);
  String get nextSlide;
  String get previousSlide;
  String slideOf(int n, int count);
  /// «1 из 4» в шапке истории, после «fastwork ·».
  String slideCounter(int n, int count);
  String get close;
  /// Кнопка внизу слайда, если у неё нет своей подписи.
  String get open;

  // ---- Смена-пример ----
  String get exampleShiftTitle;
  String get exampleCompany;
  String get exampleAddress;
  String get payGuaranteed;

  // ---- Общие кнопки и подписи ----
  String get uploadDocuments;
  String get fullRules;
  String get contactSupport;
  String get whenToWriteTitle;
  String get dosAndDontsTitle;
  String get dos;
  String get donts;
  String get serviceFee;
  String get verifiedBadge;

  // ---- Как это работает ----
  String get howTitle;
  String get howGigTitle;
  String get howGigBody;
  String get howStepsTitle;
  String get howStepsBody;
  String get stepFind;
  String get stepFindCaption;
  String get stepBook;
  String get stepBookCaption;
  String get stepCheckIn;
  String get stepCheckInCaption;
  String get stepGetPaid;
  String get stepGetPaidCaption;
  String get howGuaranteedBody;
  String get flowEmployer;
  String get flowHolds;
  String get flowYou;
  String get flowPaysUpfront;
  String get flowAfterShift;
  String get howDocsTitle;
  String get howDocsBody;
  String get docUploadedPlural;
  String get docChecking;
  String get docVerified;

  // ---- Выплаты ----
  String get payoutsTitle;
  String get moneyPathTitle;
  String get moneyPathBody;
  String get pathEmployerPaid;
  String get pathEmployerPaidCaption;
  String get pathServiceHolds;
  String get pathServiceHoldsCaption;
  String get pathYouWorked;
  String get pathYouWorkedCaption;
  String get pathOnBalance;
  String get pathOnBalanceCaption;
  String get fullAmountTitle;
  String fullAmountBody(int fee);
  String get splitHeaderWorker;
  String get splitToYou;
  String get splitToYouNote;
  String feePaidByEmployer(int fee);
  String get whenMoneyTitle;
  String get whenMoneyBody;
  String get chainShift;
  String get chainShiftCaption;
  String get chainConfirm;
  String get chainConfirmCaption;
  String get chainBalance;
  String get chainBalanceCaption;
  String get withdrawTitle;
  /// `min` — минимальная сумма вывода, уже с «₸».
  String withdrawBody(String min);
  String get withdrawFeeCaption;
  String get openPayouts;

  // ---- Лимит ----
  String get limitTitle;
  String limitPerMonthTitle(int mrp);
  String limitBody(int mrp);
  String get mrpWhatTitle;
  String get mrpWhatBody;
  String get yourMonthTitle;
  String get yourMonthBody;
  String get seeInPayouts;
  String equationMrp(int mrp);
  String get equationMrpCaption;
  String equationMrpOn(int year);
  String get equationLimitCaption;
  /// Подпись под процентом в кольце: «40% лимита».
  String get meterOfLimit;
  /// `month` — «сентябрь 2026».
  String meterLimitFor(String month);
  String get meterCalculating;
  String get meterProgressInPayouts;
  String get meterEarned;
  String get meterBooked;
  String get meterRemaining;

  // ---- Документы ----
  String get documentsTitle;
  String get docsWhichTitle;
  String get docsWhichBody;
  String get docIdCard;
  String get docIdCardCaption;
  String get docForEveryone;
  String get docMedBook;
  String get docMedBookCaption;
  String get docPerShift;
  String get docsCheckTitle;
  String get docsCheckBody;
  String get docUploaded;
  String get docInReview;
  String get docAccepted;
  String get docsWhyTitle;
  String get docsWhyBody;
  String get docsWhyBadge;
  String get docsWhyEmployerSees;
  String get docsWhyPrivate;

  // ---- Медкнижка ----
  String get medbookTitle;
  String get medWhoTitle;
  String get medWhoBody;
  String get medHowTitle;
  String get medHowBody;
  String get medStepBook;
  String get medStepTests;
  String get medStepTestsCaption;
  String get medStepGet;
  String get medStepGetCaption;
  String get medStepUpload;
  String get medStepUploadCaption;
  String get medExpiryTitle;
  String get medExpiryBody;
  String get medCalendarCaption;
  String get uploadMedBook;

  // ---- Правила исполнителя ----
  String get rulesTitle;
  String get deadlinesTitle;
  String get deadlinesBody;
  String get ruleBooked;
  String get ruleBookedCaption;
  String get ruleCancel;
  String ruleCancelCaption(int hours);
  String get ruleHourBefore;
  String get ruleHourBeforeCaption;
  String get ruleStart;
  String get ruleStartCaption;
  String get noShowTitle;
  String get noShowBody;
  /// Подпись под «90%» в кольце надёжности.
  String get reliabilityCaption;
  String get reliabilityExample;
  String get reliabilityExampleText;
  String get workerRulesBody;
  String get doCancelInTime;
  String get doDispute;
  String get doRatePlace;
  String get dontPayForSpot;
  String get dontShareCode;
  String get dontSkip;

  // ---- Рейтинг ----
  String get ratingTitle;
  String get ratingAfterShiftTitle;
  String get ratingAfterShiftBody;
  String get ratingSample;
  String ratingYours(int count);
  String get ratingStarting;
  String get ratingUnlocksTitle;
  String get ratingUnlocksBody;
  String get levelsTitle;
  String get levelsBody;
  String get reviewsAboutMe;
  /// `shifts` — «12 смен».
  String levelTop(String shifts);
  String levelToNext(String shifts, String level, int left);
  String get levelYouAreHere;
  String get levelFromFirst;
  String levelFromShifts(int n);
  String thresholdShift(String rating);
  String get thresholdYou;
  String thresholdOpen(String rating);
  String thresholdClosed(String rating);

  // ---- Поддержка исполнителя ----
  String get supportTitle;
  String get workerSupportBody;
  String get supportMarkedNoShow;
  String get supportNoMoney;
  String get supportExtraDemands;
  String get supportCantSignIn;
  String get howToWriteTitle;
  String get howToWriteBody;
  String get chatWorker;
  String get chatSupport;
  String get chatThanks;

  // ---- Заказчик: как нанять ----
  String get hireTitle;
  String get hireStepsTitle;
  String get hireStepsBody;
  String get hireCreate;
  String get hireCreateCaption;
  String get hirePay;
  String get hirePayCaption;
  String get hirePeopleBook;
  String get hirePeopleBookCaption;
  String get hireMark;
  String get hireMarkCaption;
  String get hireRate;
  String get hireRateCaption;
  String get whoComesTitle;
  String get whoComesBody;
  String get whoComesRating;
  String get whoComesReliability;
  String get createShift;

  // ---- Заказчик: оплата ----
  String get paymentTitle;
  String get costTitle;
  String costBody(int fee);
  String get splitHeaderManager;
  String get splitToWorker;
  String get splitToWorkerNote;
  String feeForGuarantee(int fee);
  String get payForAttendedTitle;
  String get payForAttendedBody;
  String get outcomeAttended;
  String get outcomeAttendedCaption;
  String get outcomeNoShow;
  String get outcomeNoShowCaption;
  String get outcomeCancelled;
  String get outcomeCancelledCaption;
  String get outcomeChanged;
  String get outcomeChangedCaption;
  String get openPayments;

  // ---- Заказчик: отметки ----
  String get attendanceTitle;
  String get confirmAttendanceTitle;
  String get confirmAttendanceBody;
  String get attBooked;
  String get attCheckedIn;
  String get attConfirmed;
  String get attPaid;
  String get ratePeopleTitle;
  String get ratePeopleBody;
  String get rateWorkers;

  // ---- Заказчик: правила и поддержка ----
  String get managerRulesBody;
  String get doEditShift;
  String get doCancelShift;
  String get doMarkNoShow;
  String get dontPayOutside;
  String get dontOvertime;
  String get dontFalseNoShow;
  String get managerSupportBody;
  String get supportWorkerNoShow;
  String get supportPaymentFailed;
  String get supportEditPaid;
  String get supportAttendanceDispute;
}

class _Ru extends StoriesStrings {
  const _Ru();

  // ---- Лента кружков и просмотрщик ----
  @override
  String storyLabel(String title) => 'История «$title»';
  @override
  String newStoryLabel(String title) => 'Новая история «$title»';
  @override
  String get nextSlide => 'Следующий слайд';
  @override
  String get previousSlide => 'Предыдущий слайд';
  @override
  String slideOf(int n, int count) => 'Слайд $n из $count';
  @override
  String slideCounter(int n, int count) => '$n из $count';
  @override
  String get close => 'Закрыть';
  @override
  String get open => 'Открыть';

  // ---- Смена-пример ----
  @override
  String get exampleShiftTitle => 'Сборка заказов на складе';
  @override
  String get exampleCompany => 'Склад «Восток»';
  @override
  String get exampleAddress => 'ул. Садовая, 12';
  @override
  String get payGuaranteed => 'Оплата гарантирована';

  // ---- Общие кнопки и подписи ----
  @override
  String get uploadDocuments => 'Загрузить документы';
  @override
  String get fullRules => 'Правила полностью';
  @override
  String get contactSupport => 'Написать в поддержку';
  @override
  String get whenToWriteTitle => 'Когда писать нам';
  @override
  String get dosAndDontsTitle => 'Можно и нельзя';
  @override
  String get dos => 'Можно';
  @override
  String get donts => 'Нельзя';
  @override
  String get serviceFee => 'Комиссия сервиса';
  @override
  String get verifiedBadge => 'Отметка «Верифицирован»';

  // ---- Как это работает ----
  @override
  String get howTitle => 'Как это работает';
  @override
  String get howGigTitle => 'Подработка на один день';
  @override
  String get howGigBody =>
      'Компании выкладывают смены: день, время, адрес и сумму. Выбираете '
      'удобную и записываетесь — без собеседований.';
  @override
  String get howStepsTitle => 'Четыре шага до денег';
  @override
  String get howStepsBody => 'Всё в приложении — от записи до вывода на карту.';
  @override
  String get stepFind => 'Найдите смену';
  @override
  String get stepFindCaption => 'По дате, категории и компании';
  @override
  String get stepBook => 'Запишитесь';
  @override
  String get stepBookCaption => 'Место закрепится за вами';
  @override
  String get stepCheckIn => 'Отметьтесь на месте';
  @override
  String get stepCheckInCaption => 'В день смены, за час до начала';
  @override
  String get stepGetPaid => 'Получите деньги';
  @override
  String get stepGetPaidCaption => 'Когда заказчик подтвердит выход';
  @override
  String get howGuaranteedBody =>
      'Заказчик платит сервису заранее — ещё при публикации смены. Деньги '
      'ждут у нас, пока вы работаете.';
  @override
  String get flowEmployer => 'Заказчик';
  @override
  String get flowHolds => 'держит';
  @override
  String get flowYou => 'Вы';
  @override
  String get flowPaysUpfront => 'платит заранее';
  @override
  String get flowAfterShift => 'после смены';
  @override
  String get howDocsTitle => 'Начните с документов';
  @override
  String get howDocsBody =>
      'Загрузите удостоверение личности: заказчик увидит, что к нему придёт '
      'проверенный человек.';
  @override
  String get docUploadedPlural => 'Загрузили';
  @override
  String get docChecking => 'Проверяем';
  @override
  String get docVerified => 'Проверен';

  // ---- Выплаты ----
  @override
  String get payoutsTitle => 'Выплаты';
  @override
  String get moneyPathTitle => 'Путь денег';
  @override
  String get moneyPathBody =>
      'Заказчик платит заранее, а сервис держит деньги до конца смены. '
      'Поэтому на карточке и написано «Оплата гарантирована».';
  @override
  String get pathEmployerPaid => 'Заказчик оплатил смену';
  @override
  String get pathEmployerPaidCaption =>
      'Картой или через Kaspi, при публикации';
  @override
  String get pathServiceHolds => 'Сервис держит деньги';
  @override
  String get pathServiceHoldsCaption => 'До конца смены';
  @override
  String get pathYouWorked => 'Вы отработали';
  @override
  String get pathYouWorkedCaption => 'Заказчик подтверждает выход';
  @override
  String get pathOnBalance => 'Деньги на вашем балансе';
  @override
  String get pathOnBalanceCaption => 'Можно выводить на карту';
  @override
  String get fullAmountTitle => 'Вы получаете всю сумму';
  @override
  String fullAmountBody(int fee) =>
      'Комиссию сервиса — $fee% — платит заказчик сверху. Сколько написано в '
      'смене, столько и придёт.';
  @override
  String get splitHeaderWorker => 'Заказчик платит за одно место';
  @override
  String get splitToYou => 'Вам';
  @override
  String get splitToYouNote => 'ровно как в смене';
  @override
  String feePaidByEmployer(int fee) => '$fee%, платит заказчик';
  @override
  String get whenMoneyTitle => 'Когда приходят деньги';
  @override
  String get whenMoneyBody =>
      'Как только заказчик подтвердит, что вы вышли, сумма появится в '
      '«Выплатах». Срок указан в каждой смене — например, «Выплата завтра».';
  @override
  String get chainShift => 'Смена';
  @override
  String get chainShiftCaption => 'вы отработали';
  @override
  String get chainConfirm => 'Подтверждение';
  @override
  String get chainConfirmCaption => 'заказчик отметил';
  @override
  String get chainBalance => 'Баланс';
  @override
  String get chainBalanceCaption => 'можно выводить';
  @override
  String get withdrawTitle => 'Вывод на карту';
  @override
  String withdrawBody(String min) =>
      'Выводите весь баланс, от $min, на карту любого банка — хоть на Kaspi '
      'Gold. Комиссии нет, а карту вы вводите на странице платёжного сервиса.';
  @override
  String get withdrawFeeCaption => 'Комиссия за вывод — 0 ₸';
  @override
  String get openPayouts => 'Открыть выплаты';

  // ---- Лимит ----
  @override
  String get limitTitle => 'Лимит';
  @override
  String limitPerMonthTitle(int mrp) => '$mrp МРП в месяц';
  @override
  String limitBody(int mrp) =>
      'Вы работаете в режиме платформенной занятости. Доход в нём — не больше '
      '$mrp МРП в месяц, по МРП на 1 января.';
  @override
  String get mrpWhatTitle => 'Что такое МРП';
  @override
  String get mrpWhatBody =>
      'Месячный расчётный показатель — «линейка», которой государство меряет '
      'пособия, штрафы и лимиты. Его задают каждый год в законе о бюджете.';
  @override
  String get yourMonthTitle => 'Ваш месяц';
  @override
  String get yourMonthBody =>
      'Считаем и отработанное, и смены, на которые вы записаны: запись — '
      'обещание выйти. Если смена не помещается в лимит, записаться не '
      'получится.';
  @override
  String get seeInPayouts => 'Смотреть в «Выплатах»';
  @override
  String equationMrp(int mrp) => '$mrp МРП';
  @override
  String get equationMrpCaption => 'в месяц можно заработать';
  @override
  String equationMrpOn(int year) => '1 МРП на 1 января $year';
  @override
  String get equationLimitCaption => 'ваш лимит в месяц';
  @override
  String get meterOfLimit => 'лимита';
  @override
  String meterLimitFor(String month) => 'Лимит на $month';
  @override
  String get meterCalculating => 'Считаем ваш месяц…';
  @override
  String get meterProgressInPayouts => 'Ваш прогресс — в «Выплатах»';
  @override
  String get meterEarned => 'Отработано';
  @override
  String get meterBooked => 'Записаны';
  @override
  String get meterRemaining => 'Осталось';

  // ---- Документы ----
  @override
  String get documentsTitle => 'Документы';
  @override
  String get docsWhichTitle => 'Какие документы нужны';
  @override
  String get docsWhichBody =>
      'Удостоверение личности — всем. Санитарная книжка — тем, кто работает с '
      'продуктами и в общепите.';
  @override
  String get docIdCard => 'Удостоверение личности';
  @override
  String get docIdCardCaption => 'Номер документа';
  @override
  String get docForEveryone => 'всем';
  @override
  String get docMedBook => 'Санитарная книжка';
  @override
  String get docMedBookCaption => 'Если работа с едой';
  @override
  String get docPerShift => 'по смене';
  @override
  String get docsCheckTitle => 'Как проходит проверка';
  @override
  String get docsCheckBody =>
      'Загружаете документ — он уходит на проверку. Когда удостоверение '
      'примут, в профиле появится отметка «Верифицирован».';
  @override
  String get docUploaded => 'Загружен';
  @override
  String get docInReview => 'На проверке';
  @override
  String get docAccepted => 'Принят';
  @override
  String get docsWhyTitle => 'Зачем это вам';
  @override
  String get docsWhyBody =>
      'Заказчик видит отметку рядом с вашим именем и знает, что к нему придёт '
      'проверенный человек.';
  @override
  String get docsWhyBadge => 'Отметка «Верифицирован» в профиле';
  @override
  String get docsWhyEmployerSees => 'Заказчик видит её в списке записавшихся';
  @override
  String get docsWhyPrivate => 'Сами документы видит только сервис';

  // ---- Медкнижка ----
  @override
  String get medbookTitle => 'Медкнижка';
  @override
  String get medWhoTitle => 'Кому нужна медкнижка';
  @override
  String get medWhoBody =>
      'Всем, кто работает с едой и напитками, и часто — тем, кто продаёт '
      'продукты или работает с детьми. Если она нужна, заказчик напишет об '
      'этом в смене.';
  @override
  String get medHowTitle => 'Как её оформить';
  @override
  String get medHowBody =>
      'Медкнижку оформляют после медосмотра — в поликлинике или частном '
      'медцентре. Возьмите с собой удостоверение личности.';
  @override
  String get medStepBook => 'Запишитесь на медосмотр';
  @override
  String get medStepTests => 'Сдайте анализы';
  @override
  String get medStepTestsCaption => 'и пройдите врачей';
  @override
  String get medStepGet => 'Получите книжку';
  @override
  String get medStepGetCaption => 'с отметками врачей';
  @override
  String get medStepUpload => 'Загрузите её номер';
  @override
  String get medStepUploadCaption => 'Профиль → Документы';
  @override
  String get medExpiryTitle => 'Следите за сроком';
  @override
  String get medExpiryBody =>
      'Медосмотр проходят регулярно — дата следующего стоит в самой книжке. С '
      'просроченной книжкой заказчик не допустит к смене.';
  @override
  String get medCalendarCaption => 'Пример: дата следующего осмотра';
  @override
  String get uploadMedBook => 'Загрузить медкнижку';

  // ---- Правила исполнителя ----
  @override
  String get rulesTitle => 'Правила';
  @override
  String get deadlinesTitle => 'Сроки, которые важно знать';
  @override
  String get deadlinesBody =>
      'Запись — обещание выйти. Отменить её можно до срока, который указан в '
      'смене.';
  @override
  String get ruleBooked => 'Записались';
  @override
  String get ruleBookedCaption => 'Место за вами';
  @override
  String get ruleCancel => 'Отмена — до срока';
  @override
  String ruleCancelCaption(int hours) => 'Например, за $hours часов до начала';
  @override
  String get ruleHourBefore => 'За час до начала';
  @override
  String get ruleHourBeforeCaption => 'Можно отметиться на месте';
  @override
  String get ruleStart => 'Начало смены';
  @override
  String get ruleStartCaption => 'Работаете по описанию смены';
  @override
  String get noShowTitle => 'Невыход видят заказчики';
  @override
  String get noShowBody =>
      'Записались и не пришли — заказчик отметит невыход. Это снижает '
      'надёжность: долю смен, на которые вы вышли. Её видят заказчики.';
  @override
  String get reliabilityCaption => 'выходов';
  @override
  String get reliabilityExample => 'Пример';
  @override
  String get reliabilityExampleText => 'Из 10 смен вышли на 9';
  @override
  String get workerRulesBody =>
      'Сервис — гарант оплаты. Никто не вправе просить у вас денег за смену '
      'или код входа.';
  @override
  String get doCancelInTime => 'Отменить запись до срока';
  @override
  String get doDispute => 'Оспорить отметку через поддержку';
  @override
  String get doRatePlace => 'Оценить место работы';
  @override
  String get dontPayForSpot => 'Платить кому-то за место на смене';
  @override
  String get dontShareCode => 'Сообщать код входа — даже «поддержке»';
  @override
  String get dontSkip => 'Не прийти, не отменив запись';

  // ---- Рейтинг ----
  @override
  String get ratingTitle => 'Рейтинг';
  @override
  String get ratingAfterShiftTitle => 'Оценка после каждой смены';
  @override
  String get ratingAfterShiftBody =>
      'Заказчик ставит от 1 до 5 звёзд, рейтинг — среднее всех оценок. Пока '
      'оценок нет, у вас стартовый рейтинг.';
  @override
  String get ratingSample => 'пример рейтинга';
  @override
  String ratingYours(int count) => 'ваш рейтинг · оценок: $count';
  @override
  String get ratingStarting => 'ваш стартовый рейтинг';
  @override
  String get ratingUnlocksTitle => 'Рейтинг открывает смены';
  @override
  String get ratingUnlocksBody =>
      'Некоторые заказчики берут только тех, у кого рейтинг не ниже порога. '
      'Такие смены в ленте помечены замком.';
  @override
  String get levelsTitle => 'Уровни';
  @override
  String get levelsBody =>
      'Уровень растёт с числом отработанных смен и виден в профиле.';
  @override
  String get reviewsAboutMe => 'Отзывы обо мне';
  @override
  String levelTop(String shifts) => 'У вас высший уровень — $shifts';
  @override
  String levelToNext(String shifts, String level, int left) =>
      'У вас $shifts. До уровня «$level» — ещё $left';
  @override
  String get levelYouAreHere => 'вы здесь';
  @override
  String get levelFromFirst => 'с первой смены';
  @override
  String levelFromShifts(int n) => 'от $n смен';
  @override
  String thresholdShift(String rating) => 'Смена от $rating';
  @override
  String get thresholdYou => 'вы';
  @override
  String thresholdOpen(String rating) => 'Ваш рейтинг $rating — смена открыта';
  @override
  String thresholdClosed(String rating) => 'Ваш рейтинг $rating — пока закрыта';

  // ---- Поддержка исполнителя ----
  @override
  String get supportTitle => 'Поддержка';
  @override
  String get workerSupportBody =>
      'Разберёмся в споре с заказчиком, проверим оплату и поможем со входом.';
  @override
  String get supportMarkedNoShow => 'Отметили невыход, а вы работали';
  @override
  String get supportNoMoney => 'Деньги не пришли после подтверждения';
  @override
  String get supportExtraDemands => 'Просят то, чего нет в описании смены';
  @override
  String get supportCantSignIn => 'Не получается войти или записаться';
  @override
  String get howToWriteTitle => 'Как написать';
  @override
  String get howToWriteBody =>
      'Профиль → Поддержка → новое обращение. Опишите, что случилось, и '
      'назовите смену — так ответим быстрее.';
  @override
  String get chatWorker =>
      'Здравствуйте! Вчера была смена на складе, а мне отметили невыход';
  @override
  String get chatSupport =>
      'Здравствуйте! Проверим отметку у заказчика и вернёмся с ответом.';
  @override
  String get chatThanks => 'Спасибо!';

  // ---- Заказчик: как нанять ----
  @override
  String get hireTitle => 'Как нанять';
  @override
  String get hireStepsTitle => 'Пять шагов';
  @override
  String get hireStepsBody =>
      'От публикации до оценки — всё в приложении, без звонков и таблиц.';
  @override
  String get hireCreate => 'Создайте смену';
  @override
  String get hireCreateCaption => 'Категория, время, ставка, число мест';
  @override
  String get hirePay => 'Оплатите';
  @override
  String get hirePayCaption => 'Картой или счётом в Kaspi.kz';
  @override
  String get hirePeopleBook => 'Люди записываются';
  @override
  String get hirePeopleBookCaption => 'Видно рейтинг каждого';
  @override
  String get hireMark => 'Отметьте, кто вышел';
  @override
  String get hireMarkCaption => 'Деньги уйдут исполнителю';
  @override
  String get hireRate => 'Оцените работу';
  @override
  String get hireRateCaption => 'Так растёт рейтинг лучших';
  @override
  String get whoComesTitle => 'Кто к вам придёт';
  @override
  String get whoComesBody =>
      'В списке записавшихся видно, как человек работал раньше, и проверены '
      'ли его документы.';
  @override
  String get whoComesRating => 'Рейтинг по оценкам других заказчиков';
  @override
  String get whoComesReliability => 'Какую долю смен человек не пропустил';
  @override
  String get createShift => 'Создать смену';

  // ---- Заказчик: оплата ----
  @override
  String get paymentTitle => 'Оплата';
  @override
  String get costTitle => 'Сколько стоит смена';
  @override
  String costBody(int fee) =>
      'Вы платите вознаграждение и $fee% комиссии сверху. Исполнитель '
      'получает ровно ту сумму, что указана в смене.';
  @override
  String get splitHeaderManager => 'За одно место';
  @override
  String get splitToWorker => 'Исполнителю';
  @override
  String get splitToWorkerNote => 'вознаграждение из смены';
  @override
  String feeForGuarantee(int fee) => '$fee% за гарантию и подбор';
  @override
  String get payForAttendedTitle => 'Платите за тех, кто вышел';
  @override
  String get payForAttendedBody =>
      'Деньги ждут у сервиса до конца смены. Не вышел человек или смену '
      'отменили — вернём то, что не пригодилось.';
  @override
  String get outcomeAttended => 'Вышел';
  @override
  String get outcomeAttendedCaption => 'Деньги уходят исполнителю';
  @override
  String get outcomeNoShow => 'Не вышел';
  @override
  String get outcomeNoShowCaption => 'Вернём деньги за это место';
  @override
  String get outcomeCancelled => 'Смену отменили';
  @override
  String get outcomeCancelledCaption => 'Вернём остаток';
  @override
  String get outcomeChanged => 'Смену изменили';
  @override
  String get outcomeChangedCaption => 'Доплата или возврат разницы';
  @override
  String get openPayments => 'Открыть платежи';

  // ---- Заказчик: отметки ----
  @override
  String get attendanceTitle => 'Отметки';
  @override
  String get confirmAttendanceTitle => 'Подтвердите выход';
  @override
  String get confirmAttendanceBody =>
      'После смены откройте её и отметьте каждого: вышел или нет. Пока '
      'отметки нет, деньги ждут у сервиса.';
  @override
  String get attBooked => 'Записался';
  @override
  String get attCheckedIn => 'Отметился на месте';
  @override
  String get attConfirmed => 'Вы подтвердили';
  @override
  String get attPaid => 'Деньги ушли';
  @override
  String get ratePeopleTitle => 'Оцените людей';
  @override
  String get ratePeopleBody =>
      'Ваша оценка — часть рейтинга исполнителя. Поставьте в смене порог, и '
      'записаться смогут только те, кто до него дорос.';
  @override
  String get rateWorkers => 'Оценить исполнителей';

  // ---- Заказчик: правила и поддержка ----
  @override
  String get managerRulesBody =>
      'Сервис — гарант для обеих сторон: деньги за смену проходят только '
      'через него.';
  @override
  String get doEditShift => 'Изменить смену — цена пересчитается';
  @override
  String get doCancelShift => 'Отменить смену — вернём остаток';
  @override
  String get doMarkNoShow => 'Отметить невыход, если человек не пришёл';
  @override
  String get dontPayOutside => 'Договариваться об оплате мимо сервиса';
  @override
  String get dontOvertime => 'Просить работать сверх смены';
  @override
  String get dontFalseNoShow => 'Отмечать невыход тому, кто работал';
  @override
  String get managerSupportBody =>
      'Поможем с оплатой, возвратами и спорами с исполнителями.';
  @override
  String get supportWorkerNoShow => 'Исполнитель не пришёл и не отменил запись';
  @override
  String get supportPaymentFailed => 'Оплата не прошла или не вернулись деньги';
  @override
  String get supportEditPaid => 'Нужно изменить уже оплаченную смену';
  @override
  String get supportAttendanceDispute => 'Спор об отметке выхода';
}

class _Kk extends StoriesStrings {
  const _Kk();

  // ---- Лента кружков и просмотрщик ----
  @override
  String storyLabel(String title) => '«$title» сторисі';
  @override
  String newStoryLabel(String title) => 'Жаңа сторис: «$title»';
  @override
  String get nextSlide => 'Келесі слайд';
  @override
  String get previousSlide => 'Алдыңғы слайд';
  @override
  String slideOf(int n, int count) => '$count слайдтың $n-сі';
  @override
  String slideCounter(int n, int count) => '$n / $count';
  @override
  String get close => 'Жабу';
  @override
  String get open => 'Ашу';

  // ---- Смена-пример ----
  @override
  String get exampleShiftTitle => 'Қоймада тапсырыс жинау';
  @override
  String get exampleCompany => '«Восток» қоймасы';
  @override
  String get exampleAddress => 'Садовая к-сі, 12';
  @override
  String get payGuaranteed => 'Төлем кепілді';

  // ---- Общие кнопки и подписи ----
  @override
  String get uploadDocuments => 'Құжаттарды жүктеу';
  @override
  String get fullRules => 'Толық ережелер';
  @override
  String get contactSupport => 'Қолдау қызметіне жазу';
  @override
  String get whenToWriteTitle => 'Бізге қашан жазу керек';
  @override
  String get dosAndDontsTitle => 'Рұқсат пен тыйым';
  @override
  String get dos => 'Болады';
  @override
  String get donts => 'Болмайды';
  @override
  String get serviceFee => 'Сервис комиссиясы';
  @override
  String get verifiedBadge => '«Тексерілген» белгісі';

  // ---- Как это работает ----
  @override
  String get howTitle => 'Қалай жұмыс істейді';
  @override
  String get howGigTitle => 'Бір күндік қосымша жұмыс';
  @override
  String get howGigBody =>
      'Компаниялар ауысымдарды жариялайды: күні, уақыты, мекенжайы және '
      'сомасы. Ыңғайлысын таңдап, жазыласыз — сұхбатсыз.';
  @override
  String get howStepsTitle => 'Ақшаға дейін төрт қадам';
  @override
  String get howStepsBody =>
      'Бәрі қосымшада — жазылудан бастап картаға шығаруға дейін.';
  @override
  String get stepFind => 'Ауысым табыңыз';
  @override
  String get stepFindCaption => 'Күні, санаты, компаниясы бойынша';
  @override
  String get stepBook => 'Жазылыңыз';
  @override
  String get stepBookCaption => 'Орын сізге бекітіледі';
  @override
  String get stepCheckIn => 'Орнында белгіленіңіз';
  @override
  String get stepCheckInCaption => 'Ауысым күні, басталарға бір сағат қалғанда';
  @override
  String get stepGetPaid => 'Ақшаңызды алыңыз';
  @override
  String get stepGetPaidCaption => 'Тапсырыс беруші келгеніңізді растағанда';
  @override
  String get howGuaranteedBody =>
      'Тапсырыс беруші сервиске ақшаны алдын ала — ауысымды жариялағанда-ақ '
      'төлейді. Сіз жұмыс істегенше ақша бізде сақталады.';
  @override
  String get flowEmployer => 'Тапсырыс беруші';
  @override
  String get flowHolds => 'сақтайды';
  @override
  String get flowYou => 'Сіз';
  @override
  String get flowPaysUpfront => 'алдын ала төлейді';
  @override
  String get flowAfterShift => 'ауысымнан кейін';
  @override
  String get howDocsTitle => 'Құжаттардан бастаңыз';
  @override
  String get howDocsBody =>
      'Жеке куәлігіңізді жүктеңіз: тапсырыс беруші өзіне тексерілген адам '
      'келетінін көреді.';
  @override
  String get docUploadedPlural => 'Жүктелді';
  @override
  String get docChecking => 'Тексеріп жатырмыз';
  @override
  String get docVerified => 'Тексерілді';

  // ---- Выплаты ----
  @override
  String get payoutsTitle => 'Төлемдер';
  @override
  String get moneyPathTitle => 'Ақшаның жолы';
  @override
  String get moneyPathBody =>
      'Тапсырыс беруші алдын ала төлейді, ал сервис ақшаны ауысым біткенше '
      'сақтайды. Сондықтан карточкада «Төлем кепілді» деп жазылған.';
  @override
  String get pathEmployerPaid => 'Тапсырыс беруші ауысымды төледі';
  @override
  String get pathEmployerPaidCaption =>
      'Жариялағанда, картамен не Kaspi арқылы';
  @override
  String get pathServiceHolds => 'Сервис ақшаны сақтайды';
  @override
  String get pathServiceHoldsCaption => 'Ауысым біткенше';
  @override
  String get pathYouWorked => 'Сіз жұмыс істедіңіз';
  @override
  String get pathYouWorkedCaption => 'Тапсырыс беруші келгеніңізді растайды';
  @override
  String get pathOnBalance => 'Ақша теңгеріміңізде';
  @override
  String get pathOnBalanceCaption => 'Картаға шығаруға болады';
  @override
  String get fullAmountTitle => 'Сіз соманы толық аласыз';
  @override
  String fullAmountBody(int fee) =>
      'Сервис комиссиясын — $fee% — тапсырыс беруші үстіне қосып төлейді. '
      'Ауысымда қанша жазылса, сонша түседі.';
  @override
  String get splitHeaderWorker => 'Тапсырыс беруші бір орын үшін төлейді';
  @override
  String get splitToYou => 'Сізге';
  @override
  String get splitToYouNote => 'дәл ауысымдағыдай';
  @override
  String feePaidByEmployer(int fee) => '$fee%, тапсырыс беруші төлейді';
  @override
  String get whenMoneyTitle => 'Ақша қашан түседі';
  @override
  String get whenMoneyBody =>
      'Тапсырыс беруші келгеніңізді растаған бойда сома «Төлемдер» бөлімінде '
      'пайда болады. Мерзімі әр ауысымда жазылған — мысалы, «Төлем ертең».';
  @override
  String get chainShift => 'Ауысым';
  @override
  String get chainShiftCaption => 'жұмыс істедіңіз';
  @override
  String get chainConfirm => 'Растау';
  @override
  String get chainConfirmCaption => 'тапсырыс беруші белгіледі';
  @override
  String get chainBalance => 'Теңгерім';
  @override
  String get chainBalanceCaption => 'шығаруға болады';
  @override
  String get withdrawTitle => 'Картаға шығару';
  @override
  String withdrawBody(String min) =>
      'Теңгерімді толық, кемінде $min, кез келген банк картасына — тіпті '
      'Kaspi Gold-қа шығарыңыз. Комиссия жоқ, ал картаны төлем сервисінің '
      'бетінде енгізесіз.';
  @override
  String get withdrawFeeCaption => 'Шығару комиссиясы — 0 ₸';
  @override
  String get openPayouts => 'Төлемдерді ашу';

  // ---- Лимит ----
  @override
  String get limitTitle => 'Лимит';
  @override
  String limitPerMonthTitle(int mrp) => 'Айына $mrp АЕК';
  @override
  String limitBody(int mrp) =>
      'Сіз платформалық жұмыспен қамту режимінде жұмыс істейсіз. Мұнда табыс '
      'айына $mrp АЕК-тен аспайды, АЕК 1 қаңтардағы мөлшермен алынады.';
  @override
  String get mrpWhatTitle => 'АЕК деген не';
  @override
  String get mrpWhatBody =>
      'Айлық есептік көрсеткіш — мемлекет жәрдемақыны, айыппұлды және '
      'лимиттерді өлшейтін «сызғыш». Ол жыл сайын бюджет туралы заңда '
      'бекітіледі.';
  @override
  String get yourMonthTitle => 'Сіздің айыңыз';
  @override
  String get yourMonthBody =>
      'Жұмыс істегеніңізді де, жазылған ауысымдарыңызды да есептейміз: жазылу '
      '— келуге берілген уәде. Ауысым лимитке сыймаса, оған жазыла алмайсыз.';
  @override
  String get seeInPayouts => '«Төлемдер» бөлімінен көру';
  @override
  String equationMrp(int mrp) => '$mrp АЕК';
  @override
  String get equationMrpCaption => 'айына табуға болады';
  @override
  String equationMrpOn(int year) => '$year жылғы 1 қаңтардағы 1 АЕК';
  @override
  String get equationLimitCaption => 'айлық лимитіңіз';
  @override
  String get meterOfLimit => 'лимиттен';
  @override
  String meterLimitFor(String month) => '$month лимиті';
  @override
  String get meterCalculating => 'Айыңызды есептеп жатырмыз…';
  @override
  String get meterProgressInPayouts => 'Прогресіңіз — «Төлемдер» бөлімінде';
  @override
  String get meterEarned => 'Жұмыс істелді';
  @override
  String get meterBooked => 'Жазылдыңыз';
  @override
  String get meterRemaining => 'Қалды';

  // ---- Документы ----
  @override
  String get documentsTitle => 'Құжаттар';
  @override
  String get docsWhichTitle => 'Қандай құжаттар керек';
  @override
  String get docsWhichBody =>
      'Жеке куәлік — барлығына. Санитарлық кітапша — азық-түлікпен және '
      'қоғамдық тамақтануда жұмыс істейтіндерге.';
  @override
  String get docIdCard => 'Жеке куәлік';
  @override
  String get docIdCardCaption => 'Құжат нөмірі';
  @override
  String get docForEveryone => 'барлығына';
  @override
  String get docMedBook => 'Санитарлық кітапша';
  @override
  String get docMedBookCaption => 'Тамақпен жұмыс болса';
  @override
  String get docPerShift => 'ауысымға қарай';
  @override
  String get docsCheckTitle => 'Тексеру қалай өтеді';
  @override
  String get docsCheckBody =>
      'Құжатты жүктейсіз — ол тексеруге кетеді. Куәлік қабылданғанда, '
      'профиліңізде «Тексерілген» белгісі пайда болады.';
  @override
  String get docUploaded => 'Жүктелді';
  @override
  String get docInReview => 'Тексерілуде';
  @override
  String get docAccepted => 'Қабылданды';
  @override
  String get docsWhyTitle => 'Бұл сізге не береді';
  @override
  String get docsWhyBody =>
      'Тапсырыс беруші атыңыздың жанындағы белгіні көріп, өзіне тексерілген '
      'адам келетінін біледі.';
  @override
  String get docsWhyBadge => 'Профильде «Тексерілген» белгісі';
  @override
  String get docsWhyEmployerSees =>
      'Тапсырыс беруші оны жазылғандар тізімінен көреді';
  @override
  String get docsWhyPrivate => 'Құжаттардың өзін тек сервис көреді';

  // ---- Медкнижка ----
  @override
  String get medbookTitle => 'Медкітапша';
  @override
  String get medWhoTitle => 'Медкітапша кімге керек';
  @override
  String get medWhoBody =>
      'Тамақ пен сусынмен жұмыс істейтіндердің бәріне, көбіне азық-түлік '
      'сататындарға немесе балалармен жұмыс істейтіндерге де. Керек болса, '
      'тапсырыс беруші бұл туралы ауысымда жазады.';
  @override
  String get medHowTitle => 'Оны қалай алуға болады';
  @override
  String get medHowBody =>
      'Медкітапша медициналық тексеруден кейін — емханада немесе жеке '
      'медорталықта рәсімделеді. Жеке куәлігіңізді ала жүріңіз.';
  @override
  String get medStepBook => 'Медтексеруге жазылыңыз';
  @override
  String get medStepTests => 'Талдау тапсырыңыз';
  @override
  String get medStepTestsCaption => 'және дәрігерлерден өтіңіз';
  @override
  String get medStepGet => 'Кітапшаны алыңыз';
  @override
  String get medStepGetCaption => 'дәрігерлердің белгілерімен';
  @override
  String get medStepUpload => 'Оның нөмірін жүктеңіз';
  @override
  String get medStepUploadCaption => 'Профиль → Құжаттар';
  @override
  String get medExpiryTitle => 'Мерзімін қадағалаңыз';
  @override
  String get medExpiryBody =>
      'Медтексеруден үнемі өтіп тұрады — келесісінің күні кітапшаның өзінде '
      'жазылған. Мерзімі өткен кітапшамен тапсырыс беруші ауысымға жібермейді.';
  @override
  String get medCalendarCaption => 'Мысал: келесі тексеру күні';
  @override
  String get uploadMedBook => 'Медкітапшаны жүктеу';

  // ---- Правила исполнителя ----
  @override
  String get rulesTitle => 'Ережелер';
  @override
  String get deadlinesTitle => 'Білу маңызды мерзімдер';
  @override
  String get deadlinesBody =>
      'Жазылу — келуге берілген уәде. Ауысымда көрсетілген мерзімге дейін '
      'одан бас тартуға болады.';
  @override
  String get ruleBooked => 'Жазылдыңыз';
  @override
  String get ruleBookedCaption => 'Орын сіздікі';
  @override
  String get ruleCancel => 'Бас тарту — мерзімге дейін';
  @override
  String ruleCancelCaption(int hours) =>
      'Мысалы, басталуға $hours сағат қалғанда';
  @override
  String get ruleHourBefore => 'Басталуға бір сағат қалғанда';
  @override
  String get ruleHourBeforeCaption => 'Орнында белгіленуге болады';
  @override
  String get ruleStart => 'Ауысым басталды';
  @override
  String get ruleStartCaption => 'Ауысым сипаттамасы бойынша жұмыс істейсіз';
  @override
  String get noShowTitle => 'Келмегеніңізді тапсырыс берушілер көреді';
  @override
  String get noShowBody =>
      'Жазылып, келмей қалсаңыз — тапсырыс беруші келмеді деп белгілейді. Бұл '
      'сенімділікті, яғни сіз келген ауысымдардың үлесін төмендетеді. Оны '
      'тапсырыс берушілер көреді.';
  @override
  String get reliabilityCaption => 'келу';
  @override
  String get reliabilityExample => 'Мысал';
  @override
  String get reliabilityExampleText => '10 ауысымның 9-ына келдіңіз';
  @override
  String get workerRulesBody =>
      'Сервис — төлем кепілі. Ешкім сізден ауысым үшін ақша немесе кіру кодын '
      'сұрауға құқылы емес.';
  @override
  String get doCancelInTime => 'Мерзімге дейін жазылудан бас тарту';
  @override
  String get doDispute => 'Белгіге қолдау қызметі арқылы шағымдану';
  @override
  String get doRatePlace => 'Жұмыс орнын бағалау';
  @override
  String get dontPayForSpot => 'Ауысымдағы орын үшін біреуге ақша төлеу';
  @override
  String get dontShareCode => 'Кіру кодын айту — тіпті «қолдау қызметіне» де';
  @override
  String get dontSkip => 'Жазылудан бас тартпай, келмей қалу';

  // ---- Рейтинг ----
  @override
  String get ratingTitle => 'Рейтинг';
  @override
  String get ratingAfterShiftTitle => 'Әр ауысымнан кейін баға';
  @override
  String get ratingAfterShiftBody =>
      'Тапсырыс беруші 1-ден 5-ке дейін жұлдыз қояды, рейтинг — барлық '
      'бағаның орташасы. Әзірге баға болмаса, сізде бастапқы рейтинг тұрады.';
  @override
  String get ratingSample => 'рейтинг мысалы';
  @override
  String ratingYours(int count) => 'сіздің рейтингіңіз · бағалар: $count';
  @override
  String get ratingStarting => 'сіздің бастапқы рейтингіңіз';
  @override
  String get ratingUnlocksTitle => 'Рейтинг ауысымдарды ашады';
  @override
  String get ratingUnlocksBody =>
      'Кейбір тапсырыс берушілер рейтингі белгілі бір шектен төмен емес '
      'адамдарды ғана алады. Мұндай ауысымдар таспада құлыппен белгіленген.';
  @override
  String get levelsTitle => 'Деңгейлер';
  @override
  String get levelsBody =>
      'Деңгей жұмыс істеген ауысымдар санымен бірге өседі және профильде '
      'көрінеді.';
  @override
  String get reviewsAboutMe => 'Мен туралы пікірлер';
  @override
  String levelTop(String shifts) => 'Сізде ең жоғары деңгей — $shifts';
  @override
  String levelToNext(String shifts, String level, int left) =>
      'Сізде $shifts. «$level» деңгейіне дейін — тағы $left';
  @override
  String get levelYouAreHere => 'сіз осындасыз';
  @override
  String get levelFromFirst => 'бірінші ауысымнан';
  @override
  String levelFromShifts(int n) => '$n ауысымнан бастап';
  @override
  String thresholdShift(String rating) => 'Ауысым: $rating және жоғары';
  @override
  String get thresholdYou => 'сіз';
  @override
  String thresholdOpen(String rating) => 'Рейтингіңіз $rating — ауысым ашық';
  @override
  String thresholdClosed(String rating) => 'Рейтингіңіз $rating — әзірге жабық';

  // ---- Поддержка исполнителя ----
  @override
  String get supportTitle => 'Қолдау қызметі';
  @override
  String get workerSupportBody =>
      'Тапсырыс берушімен дауды шешеміз, төлемді тексереміз және кіруге '
      'көмектесеміз.';
  @override
  String get supportMarkedNoShow =>
      'Жұмыс істедіңіз, бірақ келмеді деп белгіленді';
  @override
  String get supportNoMoney => 'Растаудан кейін ақша түспеді';
  @override
  String get supportExtraDemands => 'Ауысым сипаттамасында жоқ нәрсені сұрайды';
  @override
  String get supportCantSignIn => 'Кіру не жазылу мүмкін болмай тұр';
  @override
  String get howToWriteTitle => 'Қалай жазуға болады';
  @override
  String get howToWriteBody =>
      'Профиль → Қолдау қызметі → жаңа өтініш. Не болғанын жазып, ауысымды '
      'атаңыз — осылай тезірек жауап береміз.';
  @override
  String get chatWorker =>
      'Сәлеметсіз бе! Кеше қоймада ауысымым болды, ал маған келмеді деп '
      'белгілепті';
  @override
  String get chatSupport =>
      'Сәлеметсіз бе! Тапсырыс берушідегі белгіні тексеріп, жауап береміз.';
  @override
  String get chatThanks => 'Рақмет!';

  // ---- Заказчик: как нанять ----
  @override
  String get hireTitle => 'Қалай жалдау керек';
  @override
  String get hireStepsTitle => 'Бес қадам';
  @override
  String get hireStepsBody =>
      'Жариялаудан бағалауға дейін — бәрі қосымшада, қоңыраусыз әрі кестесіз.';
  @override
  String get hireCreate => 'Ауысым құрыңыз';
  @override
  String get hireCreateCaption => 'Санат, уақыт, мөлшерлеме, орын саны';
  @override
  String get hirePay => 'Төлеңіз';
  @override
  String get hirePayCaption => 'Картамен не Kaspi.kz шотымен';
  @override
  String get hirePeopleBook => 'Адамдар жазылады';
  @override
  String get hirePeopleBookCaption => 'Әрқайсының рейтингі көрінеді';
  @override
  String get hireMark => 'Кім келгенін белгілеңіз';
  @override
  String get hireMarkCaption => 'Ақша орындаушыға кетеді';
  @override
  String get hireRate => 'Жұмысты бағалаңыз';
  @override
  String get hireRateCaption => 'Осылай үздіктердің рейтингі өседі';
  @override
  String get whoComesTitle => 'Сізге кім келеді';
  @override
  String get whoComesBody =>
      'Жазылғандар тізімінде адамның бұрын қалай жұмыс істегені және '
      'құжаттары тексерілгені көрінеді.';
  @override
  String get whoComesRating =>
      'Басқа тапсырыс берушілердің бағасы бойынша рейтинг';
  @override
  String get whoComesReliability =>
      'Адам ауысымдардың қанша бөлігін өткізіп алмаған';
  @override
  String get createShift => 'Ауысым құру';

  // ---- Заказчик: оплата ----
  @override
  String get paymentTitle => 'Төлем';
  @override
  String get costTitle => 'Ауысым қанша тұрады';
  @override
  String costBody(int fee) =>
      'Сіз сыйақыны және үстіне $fee% комиссия төлейсіз. Орындаушы ауысымда '
      'көрсетілген соманы дәл алады.';
  @override
  String get splitHeaderManager => 'Бір орын үшін';
  @override
  String get splitToWorker => 'Орындаушыға';
  @override
  String get splitToWorkerNote => 'ауысымдағы сыйақы';
  @override
  String feeForGuarantee(int fee) => '$fee% кепілдік пен іріктеу үшін';
  @override
  String get payForAttendedTitle => 'Келгендер үшін ғана төлейсіз';
  @override
  String get payForAttendedBody =>
      'Ақша ауысым біткенше сервисте сақталады. Адам келмесе немесе ауысым '
      'тоқтатылса — жұмсалмағанын қайтарамыз.';
  @override
  String get outcomeAttended => 'Келді';
  @override
  String get outcomeAttendedCaption => 'Ақша орындаушыға кетеді';
  @override
  String get outcomeNoShow => 'Келмеді';
  @override
  String get outcomeNoShowCaption => 'Бұл орынның ақшасын қайтарамыз';
  @override
  String get outcomeCancelled => 'Ауысым тоқтатылды';
  @override
  String get outcomeCancelledCaption => 'Қалғанын қайтарамыз';
  @override
  String get outcomeChanged => 'Ауысым өзгертілді';
  @override
  String get outcomeChangedCaption => 'Қосымша төлем не айырмасын қайтару';
  @override
  String get openPayments => 'Төлемдерді ашу';

  // ---- Заказчик: отметки ----
  @override
  String get attendanceTitle => 'Белгілер';
  @override
  String get confirmAttendanceTitle => 'Келгенін растаңыз';
  @override
  String get confirmAttendanceBody =>
      'Ауысымнан кейін оны ашып, әркімді белгілеңіз: келді ме, жоқ па. Белгі '
      'қойылғанша ақша сервисте тұрады.';
  @override
  String get attBooked => 'Жазылды';
  @override
  String get attCheckedIn => 'Орнында белгіленді';
  @override
  String get attConfirmed => 'Сіз растадыңыз';
  @override
  String get attPaid => 'Ақша жіберілді';
  @override
  String get ratePeopleTitle => 'Адамдарды бағалаңыз';
  @override
  String get ratePeopleBody =>
      'Сіздің бағаңыз — орындаушы рейтингінің бір бөлігі. Ауысымға шек '
      'қойыңыз, сонда оған жеткендер ғана жазыла алады.';
  @override
  String get rateWorkers => 'Орындаушыларды бағалау';

  // ---- Заказчик: правила и поддержка ----
  @override
  String get managerRulesBody =>
      'Сервис — екі тараптың да кепілі: ауысым ақшасы тек ол арқылы өтеді.';
  @override
  String get doEditShift => 'Ауысымды өзгерту — баға қайта есептеледі';
  @override
  String get doCancelShift => 'Ауысымды тоқтату — қалғанын қайтарамыз';
  @override
  String get doMarkNoShow => 'Адам келмесе, келмеді деп белгілеу';
  @override
  String get dontPayOutside => 'Төлем туралы сервистен тыс келісу';
  @override
  String get dontOvertime => 'Ауысымнан тыс жұмыс істеуді сұрау';
  @override
  String get dontFalseNoShow => 'Жұмыс істеген адамды келмеді деп белгілеу';
  @override
  String get managerSupportBody =>
      'Төлем, қайтару және орындаушылармен даулар бойынша көмектесеміз.';
  @override
  String get supportWorkerNoShow =>
      'Орындаушы келмеді және жазылудан бас тартпады';
  @override
  String get supportPaymentFailed => 'Төлем өтпеді немесе ақша қайтпады';
  @override
  String get supportEditPaid => 'Төленген ауысымды өзгерту керек';
  @override
  String get supportAttendanceDispute => 'Келу белгісі туралы дау';
}

class _En extends StoriesStrings {
  const _En();

  // ---- Лента кружков и просмотрщик ----
  @override
  String storyLabel(String title) => 'Story “$title”';
  @override
  String newStoryLabel(String title) => 'New story “$title”';
  @override
  String get nextSlide => 'Next slide';
  @override
  String get previousSlide => 'Previous slide';
  @override
  String slideOf(int n, int count) => 'Slide $n of $count';
  @override
  String slideCounter(int n, int count) => '$n of $count';
  @override
  String get close => 'Close';
  @override
  String get open => 'Open';

  // ---- Смена-пример ----
  @override
  String get exampleShiftTitle => 'Order picking at a warehouse';
  @override
  String get exampleCompany => 'Vostok Warehouse';
  @override
  String get exampleAddress => '12 Sadovaya St';
  @override
  String get payGuaranteed => 'Pay guaranteed';

  // ---- Общие кнопки и подписи ----
  @override
  String get uploadDocuments => 'Upload documents';
  @override
  String get fullRules => 'Full rules';
  @override
  String get contactSupport => 'Contact support';
  @override
  String get whenToWriteTitle => 'When to contact us';
  @override
  String get dosAndDontsTitle => 'Do’s and don’ts';
  @override
  String get dos => 'Do';
  @override
  String get donts => 'Don’t';
  @override
  String get serviceFee => 'Service fee';
  @override
  String get verifiedBadge => '“Verified” badge';

  // ---- Как это работает ----
  @override
  String get howTitle => 'How it works';
  @override
  String get howGigTitle => 'A side job for one day';
  @override
  String get howGigBody =>
      'Companies post shifts with the day, time, address and pay. Pick one '
      'that suits you and book it — no interviews.';
  @override
  String get howStepsTitle => 'Four steps to getting paid';
  @override
  String get howStepsBody =>
      'It’s all in the app — from booking to withdrawing to your card.';
  @override
  String get stepFind => 'Find a shift';
  @override
  String get stepFindCaption => 'By date, category and company';
  @override
  String get stepBook => 'Book it';
  @override
  String get stepBookCaption => 'The spot is held for you';
  @override
  String get stepCheckIn => 'Check in on site';
  @override
  String get stepCheckInCaption => 'On the day, an hour before the start';
  @override
  String get stepGetPaid => 'Get paid';
  @override
  String get stepGetPaidCaption => 'Once the employer confirms attendance';
  @override
  String get howGuaranteedBody =>
      'The employer pays the service upfront, right when posting the shift. '
      'The money waits with us while you work.';
  @override
  String get flowEmployer => 'Employer';
  @override
  String get flowHolds => 'holds';
  @override
  String get flowYou => 'You';
  @override
  String get flowPaysUpfront => 'pays upfront';
  @override
  String get flowAfterShift => 'after the shift';
  @override
  String get howDocsTitle => 'Start with your documents';
  @override
  String get howDocsBody =>
      'Upload your ID card so the employer can see a verified person is '
      'coming.';
  @override
  String get docUploadedPlural => 'Uploaded';
  @override
  String get docChecking => 'Checking';
  @override
  String get docVerified => 'Verified';

  // ---- Выплаты ----
  @override
  String get payoutsTitle => 'Payouts';
  @override
  String get moneyPathTitle => 'How the money moves';
  @override
  String get moneyPathBody =>
      'The employer pays upfront, and the service holds the money until the '
      'shift ends. That’s why the card says “Pay guaranteed”.';
  @override
  String get pathEmployerPaid => 'The employer paid for the shift';
  @override
  String get pathEmployerPaidCaption => 'By card or Kaspi, when posting';
  @override
  String get pathServiceHolds => 'The service holds the money';
  @override
  String get pathServiceHoldsCaption => 'Until the shift ends';
  @override
  String get pathYouWorked => 'You worked the shift';
  @override
  String get pathYouWorkedCaption => 'The employer confirms attendance';
  @override
  String get pathOnBalance => 'The money is in your balance';
  @override
  String get pathOnBalanceCaption => 'Ready to withdraw to a card';
  @override
  String get fullAmountTitle => 'You get the full amount';
  @override
  String fullAmountBody(int fee) =>
      'The $fee% service fee is paid by the employer on top. What the shift '
      'says is exactly what you get.';
  @override
  String get splitHeaderWorker => 'The employer pays per spot';
  @override
  String get splitToYou => 'To you';
  @override
  String get splitToYouNote => 'exactly as in the shift';
  @override
  String feePaidByEmployer(int fee) => '$fee%, paid by the employer';
  @override
  String get whenMoneyTitle => 'When the money arrives';
  @override
  String get whenMoneyBody =>
      'As soon as the employer confirms you showed up, the amount appears in '
      'Payouts. Each shift shows when — for example, “Payout tomorrow”.';
  @override
  String get chainShift => 'Shift';
  @override
  String get chainShiftCaption => 'you worked';
  @override
  String get chainConfirm => 'Confirmation';
  @override
  String get chainConfirmCaption => 'employer marked it';
  @override
  String get chainBalance => 'Balance';
  @override
  String get chainBalanceCaption => 'ready to withdraw';
  @override
  String get withdrawTitle => 'Withdraw to a card';
  @override
  String withdrawBody(String min) =>
      'Withdraw your whole balance, from $min, to any bank card — even Kaspi '
      'Gold. There’s no fee, and you enter your card on the payment '
      'provider’s page.';
  @override
  String get withdrawFeeCaption => 'Withdrawal fee: 0 ₸';
  @override
  String get openPayouts => 'Open payouts';

  // ---- Лимит ----
  @override
  String get limitTitle => 'Limit';
  @override
  String limitPerMonthTitle(int mrp) => '$mrp MCI a month';
  @override
  String limitBody(int mrp) =>
      'You work under the platform employment regime. Income under it is '
      'capped at $mrp MCI a month, using the MCI as of 1 January.';
  @override
  String get mrpWhatTitle => 'What is the MCI';
  @override
  String get mrpWhatBody =>
      'The monthly calculation index is the “ruler” the state uses to set '
      'benefits, fines and limits. It’s fixed every year in the budget law.';
  @override
  String get yourMonthTitle => 'Your month';
  @override
  String get yourMonthBody =>
      'We count both what you’ve worked and the shifts you’ve booked: a '
      'booking is a promise to show up. If a shift doesn’t fit your limit, '
      'you can’t book it.';
  @override
  String get seeInPayouts => 'View in Payouts';
  @override
  String equationMrp(int mrp) => '$mrp MCI';
  @override
  String get equationMrpCaption => 'you can earn a month';
  @override
  String equationMrpOn(int year) => '1 MCI on 1 January $year';
  @override
  String get equationLimitCaption => 'your monthly limit';
  @override
  String get meterOfLimit => 'of limit';
  @override
  String meterLimitFor(String month) => 'Limit for $month';
  @override
  String get meterCalculating => 'Calculating your month…';
  @override
  String get meterProgressInPayouts => 'Your progress is in Payouts';
  @override
  String get meterEarned => 'Worked';
  @override
  String get meterBooked => 'Booked';
  @override
  String get meterRemaining => 'Left';

  // ---- Документы ----
  @override
  String get documentsTitle => 'Documents';
  @override
  String get docsWhichTitle => 'Which documents you need';
  @override
  String get docsWhichBody =>
      'An ID card — for everyone. A health certificate — for those who work '
      'with food or in catering.';
  @override
  String get docIdCard => 'ID card';
  @override
  String get docIdCardCaption => 'Document number';
  @override
  String get docForEveryone => 'everyone';
  @override
  String get docMedBook => 'Health certificate';
  @override
  String get docMedBookCaption => 'If you work with food';
  @override
  String get docPerShift => 'per shift';
  @override
  String get docsCheckTitle => 'How verification works';
  @override
  String get docsCheckBody =>
      'Upload a document and it goes for review. Once your ID is accepted, '
      'your profile gets a “Verified” badge.';
  @override
  String get docUploaded => 'Uploaded';
  @override
  String get docInReview => 'In review';
  @override
  String get docAccepted => 'Accepted';
  @override
  String get docsWhyTitle => 'Why it matters';
  @override
  String get docsWhyBody =>
      'Employers see the badge next to your name and know a verified person '
      'is coming.';
  @override
  String get docsWhyBadge => 'A “Verified” badge on your profile';
  @override
  String get docsWhyEmployerSees => 'Employers see it in the list of bookings';
  @override
  String get docsWhyPrivate => 'Only the service sees the documents';

  // ---- Медкнижка ----
  @override
  String get medbookTitle => 'Health certificate';
  @override
  String get medWhoTitle => 'Who needs a health certificate';
  @override
  String get medWhoBody =>
      'Everyone who works with food and drinks, and often those who sell '
      'groceries or work with children. If it’s required, the employer will '
      'say so in the shift.';
  @override
  String get medHowTitle => 'How to get one';
  @override
  String get medHowBody =>
      'You get one after a medical check-up at a public clinic or a private '
      'medical center. Bring your ID card.';
  @override
  String get medStepBook => 'Book a medical check-up';
  @override
  String get medStepTests => 'Do the tests';
  @override
  String get medStepTestsCaption => 'and see the doctors';
  @override
  String get medStepGet => 'Get the certificate';
  @override
  String get medStepGetCaption => 'with the doctors’ stamps';
  @override
  String get medStepUpload => 'Upload its number';
  @override
  String get medStepUploadCaption => 'Profile → Documents';
  @override
  String get medExpiryTitle => 'Keep an eye on the date';
  @override
  String get medExpiryBody =>
      'Check-ups are regular — the next date is written in the certificate '
      'itself. With an expired one, the employer won’t let you work the shift.';
  @override
  String get medCalendarCaption => 'Example: next check-up date';
  @override
  String get uploadMedBook => 'Upload certificate';

  // ---- Правила исполнителя ----
  @override
  String get rulesTitle => 'Rules';
  @override
  String get deadlinesTitle => 'Deadlines to know';
  @override
  String get deadlinesBody =>
      'A booking is a promise to show up. You can cancel it until the '
      'deadline shown in the shift.';
  @override
  String get ruleBooked => 'Booked';
  @override
  String get ruleBookedCaption => 'The spot is yours';
  @override
  String get ruleCancel => 'Cancel by the deadline';
  @override
  String ruleCancelCaption(int hours) =>
      'For example, $hours hours before the start';
  @override
  String get ruleHourBefore => 'An hour before the start';
  @override
  String get ruleHourBeforeCaption => 'You can check in on site';
  @override
  String get ruleStart => 'Shift starts';
  @override
  String get ruleStartCaption => 'Work as the shift describes';
  @override
  String get noShowTitle => 'Employers see no-shows';
  @override
  String get noShowBody =>
      'Booked but didn’t come? The employer will mark a no-show. That lowers '
      'your reliability — the share of shifts you showed up for. Employers '
      'can see it.';
  @override
  String get reliabilityCaption => 'attended';
  @override
  String get reliabilityExample => 'Example';
  @override
  String get reliabilityExampleText => 'Showed up for 9 of 10 shifts';
  @override
  String get workerRulesBody =>
      'The service guarantees your pay. No one may ask you for money for a '
      'shift or for your sign-in code.';
  @override
  String get doCancelInTime => 'Cancel a booking by the deadline';
  @override
  String get doDispute => 'Dispute a mark through support';
  @override
  String get doRatePlace => 'Rate the workplace';
  @override
  String get dontPayForSpot => 'Pay anyone for a spot on a shift';
  @override
  String get dontShareCode => 'Share your sign-in code — even with “support”';
  @override
  String get dontSkip => 'Not show up without cancelling';

  // ---- Рейтинг ----
  @override
  String get ratingTitle => 'Rating';
  @override
  String get ratingAfterShiftTitle => 'A score after every shift';
  @override
  String get ratingAfterShiftBody =>
      'The employer gives 1 to 5 stars, and your rating is the average of all '
      'scores. Until you have any, you get a starting rating.';
  @override
  String get ratingSample => 'sample rating';
  @override
  String ratingYours(int count) => 'your rating · scores: $count';
  @override
  String get ratingStarting => 'your starting rating';
  @override
  String get ratingUnlocksTitle => 'Rating unlocks shifts';
  @override
  String get ratingUnlocksBody =>
      'Some employers only take people whose rating meets a threshold. These '
      'shifts are marked with a lock in the feed.';
  @override
  String get levelsTitle => 'Levels';
  @override
  String get levelsBody =>
      'Your level grows with the number of shifts you’ve worked and shows on '
      'your profile.';
  @override
  String get reviewsAboutMe => 'Reviews about me';
  @override
  String levelTop(String shifts) => 'You’re at the top level — $shifts';
  @override
  String levelToNext(String shifts, String level, int left) =>
      'You have $shifts. $left more to reach “$level”';
  @override
  String get levelYouAreHere => 'you’re here';
  @override
  String get levelFromFirst => 'from the first shift';
  @override
  String levelFromShifts(int n) => 'from $n shifts';
  @override
  String thresholdShift(String rating) => 'Shift: $rating and up';
  @override
  String get thresholdYou => 'you';
  @override
  String thresholdOpen(String rating) =>
      'Your rating is $rating — shift unlocked';
  @override
  String thresholdClosed(String rating) =>
      'Your rating is $rating — locked for now';

  // ---- Поддержка исполнителя ----
  @override
  String get supportTitle => 'Support';
  @override
  String get workerSupportBody =>
      'We’ll settle a dispute with an employer, check a payment and help you '
      'sign in.';
  @override
  String get supportMarkedNoShow => 'Marked a no-show, but you worked';
  @override
  String get supportNoMoney => 'No money after confirmation';
  @override
  String get supportExtraDemands =>
      'Asked for things not in the shift description';
  @override
  String get supportCantSignIn => 'Can’t sign in or book';
  @override
  String get howToWriteTitle => 'How to reach us';
  @override
  String get howToWriteBody =>
      'Profile → Support → new request. Describe what happened and name the '
      'shift — that way we’ll answer faster.';
  @override
  String get chatWorker =>
      'Hi! I had a warehouse shift yesterday, but I was marked as a no-show';
  @override
  String get chatSupport =>
      'Hi! We’ll check the mark with the employer and get back to you.';
  @override
  String get chatThanks => 'Thank you!';

  // ---- Заказчик: как нанять ----
  @override
  String get hireTitle => 'How to hire';
  @override
  String get hireStepsTitle => 'Five steps';
  @override
  String get hireStepsBody =>
      'From posting to rating — all in the app, no calls or spreadsheets.';
  @override
  String get hireCreate => 'Create a shift';
  @override
  String get hireCreateCaption => 'Category, time, rate, number of spots';
  @override
  String get hirePay => 'Pay for it';
  @override
  String get hirePayCaption => 'By card or a Kaspi.kz invoice';
  @override
  String get hirePeopleBook => 'People book';
  @override
  String get hirePeopleBookCaption => 'You see everyone’s rating';
  @override
  String get hireMark => 'Mark who showed up';
  @override
  String get hireMarkCaption => 'The money goes to the worker';
  @override
  String get hireRate => 'Rate the work';
  @override
  String get hireRateCaption => 'That’s how the best rise';
  @override
  String get whoComesTitle => 'Who’s coming';
  @override
  String get whoComesBody =>
      'The list of bookings shows how each person has worked before and '
      'whether their documents are verified.';
  @override
  String get whoComesRating => 'Rating based on other employers’ scores';
  @override
  String get whoComesReliability => 'Share of shifts they didn’t miss';
  @override
  String get createShift => 'Create shift';

  // ---- Заказчик: оплата ----
  @override
  String get paymentTitle => 'Payment';
  @override
  String get costTitle => 'What a shift costs';
  @override
  String costBody(int fee) =>
      'You pay the worker’s fee plus a $fee% service fee on top. The worker '
      'gets exactly the amount shown in the shift.';
  @override
  String get splitHeaderManager => 'Per spot';
  @override
  String get splitToWorker => 'To the worker';
  @override
  String get splitToWorkerNote => 'the fee from the shift';
  @override
  String feeForGuarantee(int fee) => '$fee% for the guarantee and matching';
  @override
  String get payForAttendedTitle => 'Pay only for those who show up';
  @override
  String get payForAttendedBody =>
      'The money waits with the service until the shift ends. If someone '
      'doesn’t show up or the shift is cancelled, we refund what wasn’t used.';
  @override
  String get outcomeAttended => 'Showed up';
  @override
  String get outcomeAttendedCaption => 'The money goes to the worker';
  @override
  String get outcomeNoShow => 'No-show';
  @override
  String get outcomeNoShowCaption => 'We refund that spot';
  @override
  String get outcomeCancelled => 'Shift cancelled';
  @override
  String get outcomeCancelledCaption => 'We refund the rest';
  @override
  String get outcomeChanged => 'Shift changed';
  @override
  String get outcomeChangedCaption => 'Top-up or refund of the difference';
  @override
  String get openPayments => 'Open payments';

  // ---- Заказчик: отметки ----
  @override
  String get attendanceTitle => 'Attendance';
  @override
  String get confirmAttendanceTitle => 'Confirm attendance';
  @override
  String get confirmAttendanceBody =>
      'After the shift, open it and mark everyone: showed up or not. Until '
      'you do, the money waits with the service.';
  @override
  String get attBooked => 'Booked';
  @override
  String get attCheckedIn => 'Checked in on site';
  @override
  String get attConfirmed => 'You confirmed';
  @override
  String get attPaid => 'Money sent';
  @override
  String get ratePeopleTitle => 'Rate people';
  @override
  String get ratePeopleBody =>
      'Your score is part of the worker’s rating. Set a threshold on a shift, '
      'and only those who meet it can book.';
  @override
  String get rateWorkers => 'Rate workers';

  // ---- Заказчик: правила и поддержка ----
  @override
  String get managerRulesBody =>
      'The service protects both sides: money for a shift only goes through '
      'it.';
  @override
  String get doEditShift => 'Edit a shift — the price is recalculated';
  @override
  String get doCancelShift => 'Cancel a shift — we refund the rest';
  @override
  String get doMarkNoShow => 'Mark a no-show if someone didn’t come';
  @override
  String get dontPayOutside => 'Arrange payment outside the service';
  @override
  String get dontOvertime => 'Ask for work beyond the shift';
  @override
  String get dontFalseNoShow => 'Mark a no-show for someone who worked';
  @override
  String get managerSupportBody =>
      'We’ll help with payments, refunds and disputes with workers.';
  @override
  String get supportWorkerNoShow => 'A worker didn’t come or cancel';
  @override
  String get supportPaymentFailed => 'Payment failed or a refund didn’t arrive';
  @override
  String get supportEditPaid => 'Need to change a shift you’ve paid for';
  @override
  String get supportAttendanceDispute => 'Dispute over an attendance mark';
}
