// Лента смен, карточка смены, страница компании, кольца историй.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class FeedStrings {
  const FeedStrings();

  /// Плитка «Все дни» в полосе дат и заголовок списка.
  String get allDays;
  String get allDaysTitle;

  static FeedStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };

  // ---- Лента: отметка «Я на месте» ----

  String get checkInByCode;
  String get checkInAccepted;
  String get alreadyCheckedIn;
  String get wrongCheckInCode;
  String get checkInTooEarly;
  String get checkInFailed;

  // ---- Лента: пустой список ----

  String get emptyDayTitle;
  String get emptyQueryTitle;
  String get emptyFilterTitle;
  String get emptyDaySubtitle;
  String get emptyQuerySubtitle;
  String get emptyFilterSubtitle;

  // ---- Лента: ближайшая смена ----

  String get statusOnShift;
  String get statusInProgress;
  String get statusNextShift;
  String get imHere;

  // ---- Лента: шапка, поиск, фильтр ----

  String get filter;

  /// «Фильтр · 2» — на кнопке, когда что-то выбрано.
  String filterCount(int n);
  String get notifications;

  /// Подсказка в строке поиска — примеры того, что можно искать.
  String get searchHint;
  String get clear;

  // ---- Карточка смены ----

  /// «2 500 ₸/ч».
  String perHour(String rate);
  String ratingRequired(String rating);

  /// Сколько мест осталось — рядом с полоской заполнения.
  String slotsLeft(int n);
  String get ratingTooLow;
  String get details;
  String get noSlotsWait;

  // ---- Страница компании ----

  String followedSnack(String company);
  String unfollowedSnack(String company);
  String get aboutCompany;
  String get noRatingsYet;
  String get followingUnfollow;
  String get followNewShifts;
  String get upcomingShifts;
  String get workerReviews;
  String get noReviewsYet;

  /// Хвост строки ближайшей смены, когда мест уже нет.
  String get noSlots;

  // ---- Окно фильтра ----

  String get categories;
  String get companies;
  String get sorting;
  String get onlyOpen;
  String get showResults;
}

class _Ru extends FeedStrings {
  const _Ru();

  @override
  String get allDays => 'Все дни';
  @override
  String get allDaysTitle => 'Две недели';

  // ---- Лента: отметка «Я на месте» ----

  @override
  String get checkInByCode => 'Отметка подтверждена кодом — заказчик её видит';
  @override
  String get checkInAccepted => 'Отметка принята — заказчик её видит';
  @override
  String get alreadyCheckedIn => 'Вы уже отметились';
  @override
  String get wrongCheckInCode =>
      'Код не подошёл — проверьте цифры у старшего смены';
  @override
  String get checkInTooEarly =>
      'Отметиться можно в день смены, не раньше чем за час до начала';
  @override
  String get checkInFailed => 'Не получилось отметиться';

  // ---- Лента: пустой список ----

  @override
  String get emptyDayTitle => 'На этот день смен нет';
  @override
  String get emptyQueryTitle => 'По запросу ничего нет';
  @override
  String get emptyFilterTitle => 'Ничего не найдено';
  @override
  String get emptyDaySubtitle => 'Выберите другую дату — зелёная точка\n'
      'под числом означает, что смены есть';
  @override
  String get emptyQuerySubtitle =>
      'Проверьте написание\nили поищите в другой день';
  @override
  String get emptyFilterSubtitle => 'Попробуйте убрать часть условий\nв фильтре';

  // ---- Лента: ближайшая смена ----

  @override
  String get statusOnShift => 'Вы на смене';
  @override
  String get statusInProgress => 'Смена идёт';
  @override
  String get statusNextShift => 'Ближайшая смена';
  @override
  String get imHere => 'Я на месте';

  // ---- Лента: шапка, поиск, фильтр ----

  @override
  String get filter => 'Фильтр';
  @override
  String filterCount(int n) => 'Фильтр · $n';
  @override
  String get notifications => 'Уведомления';
  @override
  String get searchHint => 'Сантехник, Магнум, Абая…';
  @override
  String get clear => 'Очистить';

  // ---- Карточка смены ----

  @override
  String perHour(String rate) => '$rate/ч';
  @override
  String ratingRequired(String rating) => 'Нужен рейтинг $rating';
  @override
  String slotsLeft(int n) => 'осталось $n';
  @override
  String get ratingTooLow => 'Рейтинг ниже требуемого';
  @override
  String get details => 'Подробнее';
  @override
  String get noSlotsWait => 'Мест нет · Ждать места';

  // ---- Страница компании ----

  @override
  String followedSnack(String company) =>
      'Сообщим, когда $company выставит новую смену в вашем городе';
  @override
  String unfollowedSnack(String company) =>
      'Вы отписались от новых смен $company';
  @override
  String get aboutCompany => 'О компании';
  @override
  String get noRatingsYet => 'Пока нет оценок';
  @override
  String get followingUnfollow => 'Вы подписаны · Отписаться';
  @override
  String get followNewShifts => 'Сообщать о новых сменах';
  @override
  String get upcomingShifts => 'Ближайшие смены';
  @override
  String get workerReviews => 'Отзывы исполнителей';
  @override
  String get noReviewsYet => 'Пока никто не оставил отзыв. Отработайте смену '
      'и расскажите, как всё прошло.';
  @override
  String get noSlots => 'мест нет';

  // ---- Окно фильтра ----

  @override
  String get categories => 'Категории';
  @override
  String get companies => 'Компании';
  @override
  String get sorting => 'Сортировка';
  @override
  String get onlyOpen => 'Только со свободными местами';
  @override
  String get showResults => 'Показать результаты';
}

class _Kk extends FeedStrings {
  const _Kk();

  @override
  String get allDays => 'Барлығы';
  @override
  String get allDaysTitle => 'Екі апта';

  // ---- Лента: отметка «Я на месте» ----

  @override
  String get checkInByCode =>
      'Келу кодпен расталды — тапсырыс беруші оны көріп тұр';
  @override
  String get checkInAccepted =>
      'Белгі қабылданды — тапсырыс беруші оны көріп тұр';
  @override
  String get alreadyCheckedIn => 'Сіз келгеніңізді белгілеп қойғансыз';
  @override
  String get wrongCheckInCode =>
      'Код сәйкес келмеді — сандарды ауысым жетекшісінен тексеріңіз';
  @override
  String get checkInTooEarly =>
      'Келгенді ауысым күні, басталуына бір сағаттан аз қалғанда белгілеуге '
      'болады';
  @override
  String get checkInFailed => 'Келгенді белгілеу мүмкін болмады';

  // ---- Лента: пустой список ----

  @override
  String get emptyDayTitle => 'Бұл күнге ауысым жоқ';
  @override
  String get emptyQueryTitle => 'Сұрау бойынша ештеңе жоқ';
  @override
  String get emptyFilterTitle => 'Ештеңе табылмады';
  @override
  String get emptyDaySubtitle => 'Басқа күнді таңдаңыз — күн астындағы\n'
      'жасыл нүкте ауысым барын білдіреді';
  @override
  String get emptyQuerySubtitle =>
      'Жазылуын тексеріңіз\nнемесе басқа күннен іздеңіз';
  @override
  String get emptyFilterSubtitle =>
      'Сүзгідегі кейбір шарттарды\nалып тастап көріңіз';

  // ---- Лента: ближайшая смена ----

  @override
  String get statusOnShift => 'Сіз ауысымдасыз';
  @override
  String get statusInProgress => 'Ауысым жүріп жатыр';
  @override
  String get statusNextShift => 'Жақын ауысым';
  @override
  String get imHere => 'Мен орнымдамын';

  // ---- Лента: шапка, поиск, фильтр ----

  @override
  String get filter => 'Сүзгі';
  @override
  String filterCount(int n) => 'Сүзгі · $n';
  @override
  String get notifications => 'Хабарламалар';
  @override
  String get searchHint => 'Сантехник, Магнум, Абая…';
  @override
  String get clear => 'Тазарту';

  // ---- Карточка смены ----

  @override
  String perHour(String rate) => '$rate/сағ';
  @override
  String ratingRequired(String rating) => 'Рейтинг $rating керек';
  @override
  String slotsLeft(int n) => '$n орын қалды';
  @override
  String get ratingTooLow => 'Рейтинг жеткіліксіз';
  @override
  String get details => 'Толығырақ';
  @override
  String get noSlotsWait => 'Орын жоқ · Орын күту';

  // ---- Страница компании ----

  @override
  String followedSnack(String company) =>
      '$company қалаңызда жаңа ауысым жариялағанда хабарлаймыз';
  @override
  String unfollowedSnack(String company) =>
      '$company жаңа ауысымдарынан жазылымды тоқтаттыңыз';
  @override
  String get aboutCompany => 'Компания туралы';
  @override
  String get noRatingsYet => 'Әзірге баға жоқ';
  @override
  String get followingUnfollow => 'Жазылдыңыз · Бас тарту';
  @override
  String get followNewShifts => 'Жаңа ауысымдар туралы хабарлау';
  @override
  String get upcomingShifts => 'Жақын ауысымдар';
  @override
  String get workerReviews => 'Орындаушылардың пікірлері';
  @override
  String get noReviewsYet => 'Әзірге ешкім пікір қалдырмаған. Ауысымда '
      'жұмыс істеп, қалай өткенін айтып беріңіз.';
  @override
  String get noSlots => 'орын жоқ';

  // ---- Окно фильтра ----

  @override
  String get categories => 'Санаттар';
  @override
  String get companies => 'Компаниялар';
  @override
  String get sorting => 'Сұрыптау';
  @override
  String get onlyOpen => 'Тек бос орны барлар';
  @override
  String get showResults => 'Нәтижелерді көрсету';
}

class _En extends FeedStrings {
  const _En();

  @override
  String get allDays => 'All days';
  @override
  String get allDaysTitle => 'Two weeks';

  // ---- Лента: отметка «Я на месте» ----

  @override
  String get checkInByCode =>
      'Check-in confirmed by code — the employer can see it';
  @override
  String get checkInAccepted => 'Check-in received — the employer can see it';
  @override
  String get alreadyCheckedIn => 'You’ve already checked in';
  @override
  String get wrongCheckInCode =>
      'Wrong code — check the digits with the shift lead';
  @override
  String get checkInTooEarly =>
      'You can check in on the shift day, from an hour before it starts';
  @override
  String get checkInFailed => 'Couldn’t check in';

  // ---- Лента: пустой список ----

  @override
  String get emptyDayTitle => 'No shifts on this day';
  @override
  String get emptyQueryTitle => 'Nothing matches your search';
  @override
  String get emptyFilterTitle => 'Nothing found';
  @override
  String get emptyDaySubtitle => 'Pick another date — a green dot\n'
      'under a day means there are shifts';
  @override
  String get emptyQuerySubtitle => 'Check the spelling\nor try another day';
  @override
  String get emptyFilterSubtitle => 'Try removing some\nof the filters';

  // ---- Лента: ближайшая смена ----

  @override
  String get statusOnShift => 'You’re on shift';
  @override
  String get statusInProgress => 'Shift in progress';
  @override
  String get statusNextShift => 'Next shift';
  @override
  String get imHere => 'I’m here';

  // ---- Лента: шапка, поиск, фильтр ----

  @override
  String get filter => 'Filter';
  @override
  String filterCount(int n) => 'Filter · $n';
  @override
  String get notifications => 'Notifications';
  @override
  String get searchHint => 'Plumber, Magnum…';
  @override
  String get clear => 'Clear';

  // ---- Карточка смены ----

  @override
  String perHour(String rate) => '$rate/h';
  @override
  String ratingRequired(String rating) => 'Rating $rating required';
  @override
  String slotsLeft(int n) => '$n left';
  @override
  String get ratingTooLow => 'Rating too low';
  @override
  String get details => 'Details';
  @override
  String get noSlotsWait => 'Full · Wait for a spot';

  // ---- Страница компании ----

  @override
  String followedSnack(String company) =>
      'We’ll let you know when $company posts a new shift in your city';
  @override
  String unfollowedSnack(String company) =>
      'You’ve unfollowed new shifts from $company';
  @override
  String get aboutCompany => 'About the company';
  @override
  String get noRatingsYet => 'No ratings yet';
  @override
  String get followingUnfollow => 'Following · Unfollow';
  @override
  String get followNewShifts => 'Notify me of new shifts';
  @override
  String get upcomingShifts => 'Upcoming shifts';
  @override
  String get workerReviews => 'Worker reviews';
  @override
  String get noReviewsYet =>
      'No reviews yet. Work a shift and tell others how it went.';
  @override
  String get noSlots => 'full';

  // ---- Окно фильтра ----

  @override
  String get categories => 'Categories';
  @override
  String get companies => 'Companies';
  @override
  String get sorting => 'Sort by';
  @override
  String get onlyOpen => 'Only with open spots';
  @override
  String get showResults => 'Show results';
}
