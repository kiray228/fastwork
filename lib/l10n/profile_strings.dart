// Профиль, документы, отзывы, мои смены, уведомления, поддержка.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class ProfileStrings {
  const ProfileStrings();

  // ---- Подписки на виды работ ----
  String get menuAlerts;
  String get menuAlertsHint;
  String get alertsTitle;
  String alertsHint(String city);
  String alertsOnSnack(String category);
  String alertsOffSnack(String category);

  static ProfileStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };

  // ---- Общие кнопки окон ----
  String get cancel;
  String get send;

  // ---- Экран профиля ----
  String get title;

  /// Заголовок окна выбора темы и строка меню.
  String get themeTitle;
  String get themeSystem;
  String get themeLight;
  String get themeDark;
  String get cityPickerTitle;
  String get signOutTitle;
  String get signOutBody;
  String get signOutStay;
  String get signOutConfirm;
  String get signOutButton;

  /// Строка меню у заказчика и подпись справа.
  String get menuPayments;
  String get menuPaymentsHint;

  /// Строка меню у исполнителя и подпись справа.
  String get menuPayouts;
  String get menuPayoutsHint;
  String get menuFavorites;
  String get menuFavoritesHint;
  String get menuDocsChecked;
  String get menuDocsNotChecked;

  /// Справа от «Отзывы обо мне», когда оценок ещё нет.
  String get menuReviewsNone;
  String get menuCity;
  String get menuHowItWorks;
  String get menuHowItWorksHint;
  String get menuTerms;

  /// Чип в шапке у заказчика без названия компании.
  String get roleEmployer;
  String get verified;
  String get docsNotVerified;

  /// Подпись под числом смен в профиле: «Смена», «Смены», «Смен».
  String statShifts(int n);
  String get statRating;

  /// Рейтинг по умолчанию, пока нет ни одной оценки.
  String get statStarting;

  /// Подпись под процентом выходов на смены.
  String get statAttendance;
  String get statLevel;

  // ---- Экран документов ----
  String get documentsTitle;
  String get docSentSnack;
  String get docApprovedSnack;
  String get docsHowCheck;
  String get docsWhoNeedsMedbook;
  String get docsExplainer;
  String get docNotUploaded;
  String get docPending;
  String get docApproved;
  String get docRejected;
  String docNumber(String number);
  String get docUpload;
  String get docReupload;

  /// Заголовок календаря при выборе срока.
  String get docValidUntilHelp;
  String get docNeedNumber;
  String get docNeedExpiry;

  /// Заголовок окна загрузки для неизвестного типа.
  String get docFallback;
  String get docUploadNote;
  String get docNumberHint;

  /// Кнопка, пока дата не выбрана.
  String get docValidUntilPick;
  String docValidUntil(String date);
  String docExpired(String date);
  String get docExpiresToday;

  /// [left] — уже готовое «3 дня».
  String docExpiresSoon(String date, String left);

  // ---- Экран «Мои подработки» ----
  String get myShiftsTitle;
  String get reviewThanksSnack;
  String get myShiftsEmptyTitle;
  String get myShiftsEmptyArchive;
  String get myShiftsEmptyActive;
  String get myShiftsFind;
  String get tabActive;
  String get tabArchive;
  String get archiveCancelledByEmployer;
  String get archiveNoShow;
  String get archiveUnconfirmed;
  String get archiveBookingCancelled;
  String get archiveReviewed;
  String get archiveRateWorkplace;

  // ---- Экран уведомлений ----
  String get notificationsTitle;
  String get notificationsEmptyTitle;
  String get notificationsEmptySubtitle;
  String get whenJustNow;
  String whenMinutesAgo(int n);
  String whenHoursAgo(int n);
  String get whenYesterday;
  String whenDaysAgo(int n);

  // ---- Экран «Отзывы обо мне» ----
  String get reviewsTitle;
  String get reviewsEmptyTitle;
  String get reviewsEmptySubtitle;
  String get reviewsRatingNote;

  /// «3 оценки».
  String ratingsCount(int n);

  // ---- Поддержка ----
  String get supportTitle;
  String get supportNewTicket;
  String get supportSubject;
  String get supportSubjectHint;
  String get supportWhatHappened;
  String get supportWrite;
  String get supportEmptyTitle;
  String get supportEmptySubtitle;
  String get ticketOpen;
  String get ticketClosed;

  /// «3 сообщ.» — число сообщений в обращении.
  String ticketMessages(int n);
  String get messageHint;
}

class _Ru extends ProfileStrings {
  const _Ru();

  @override
  String get menuAlerts => 'Новые смены';
  @override
  String get menuAlertsHint => 'По видам работ';
  @override
  String get alertsTitle => 'Новые смены по видам работ';
  @override
  String alertsHint(String city) =>
      'Отметьте, что умеете делать. Новая смена такого вида в городе $city придёт уведомлением.';
  @override
  String alertsOnSnack(String category) =>
      'Сообщим о новых сменах: $category';
  @override
  String alertsOffSnack(String category) => 'Больше не сообщаем: $category';

  static String _plural(int n, String one, String few, String many) {
    final last = n % 10, lastTwo = n % 100;
    if (lastTwo >= 11 && lastTwo <= 14) return many;
    if (last == 1) return one;
    if (last >= 2 && last <= 4) return few;
    return many;
  }

  // ---- Общие кнопки окон ----
  @override
  String get cancel => 'Отмена';
  @override
  String get send => 'Отправить';

  // ---- Экран профиля ----
  @override
  String get title => 'Профиль';
  @override
  String get themeTitle => 'Оформление';
  @override
  String get themeSystem => 'Как в системе';
  @override
  String get themeLight => 'Светлое';
  @override
  String get themeDark => 'Тёмное';
  @override
  String get cityPickerTitle => 'Ваш город';
  @override
  String get signOutTitle => 'Выйти из аккаунта?';
  @override
  String get signOutBody =>
      'Записи на смены сохранятся — войдите под тем же номером, '
      'и они будут на месте.';
  @override
  String get signOutStay => 'Остаться';
  @override
  String get signOutConfirm => 'Выйти';
  @override
  String get signOutButton => 'Выйти из аккаунта';
  @override
  String get menuPayments => 'Платежи';
  @override
  String get menuPaymentsHint => 'Оплата смен';
  @override
  String get menuPayouts => 'Выплаты';
  @override
  String get menuPayoutsHint => 'Вознаграждение';
  @override
  String get menuFavorites => 'Любимые исполнители';
  @override
  String get menuFavoritesHint => 'Позвать снова';
  @override
  String get menuDocsChecked => 'Проверены';
  @override
  String get menuDocsNotChecked => 'Не проверены';
  @override
  String get menuReviewsNone => 'Пока нет';
  @override
  String get menuCity => 'Город';
  @override
  String get menuHowItWorks => 'Как работает fastwork';
  @override
  String get menuHowItWorksHint => 'Истории';
  @override
  String get menuTerms => 'Правила сервиса';
  @override
  String get roleEmployer => 'Заказчик';
  @override
  String get verified => 'Верифицирован';
  @override
  String get docsNotVerified => 'Документы не проверены';
  @override
  String statShifts(int n) => _plural(n, 'Смена', 'Смены', 'Смен');
  @override
  String get statRating => 'Рейтинг';
  @override
  String get statStarting => 'Стартовый';
  @override
  String get statAttendance => 'Выходов';
  @override
  String get statLevel => 'Уровень';

  // ---- Экран документов ----
  @override
  String get documentsTitle => 'Документы';
  @override
  String get docSentSnack => 'Документ отправлен на проверку';
  @override
  String get docApprovedSnack => 'Документ проверен и принят';
  @override
  String get docsHowCheck => 'Как проходит проверка';
  @override
  String get docsWhoNeedsMedbook => 'Кому нужна медкнижка';
  @override
  String get docsExplainer =>
      'Проверенные документы открывают доступ к большему числу '
      'заказчиков. Санитарная книжка нужна для работы с продуктами.';
  @override
  String get docNotUploaded => 'Не загружен';
  @override
  String get docPending => 'На проверке';
  @override
  String get docApproved => 'Принят';
  @override
  String get docRejected => 'Отклонён';
  @override
  String docNumber(String number) => 'Номер: $number';
  @override
  String get docUpload => 'Загрузить';
  @override
  String get docReupload => 'Загрузить заново';
  @override
  String get docValidUntilHelp => 'Действует до';
  @override
  String get docNeedNumber => 'Введите номер документа';
  @override
  String get docNeedExpiry => 'Укажите, до какого числа действует медосмотр';
  @override
  String get docFallback => 'Документ';
  @override
  String get docUploadNote =>
      'Загрузка файлов пока не подключена — введите номер документа, '
      'этого достаточно для учебной версии.';
  @override
  String get docNumberHint => 'Номер документа';
  @override
  String get docValidUntilPick => 'Действует до…';
  @override
  String docValidUntil(String date) => 'Действует до $date';
  @override
  String docExpired(String date) =>
      'Срок вышел $date — пройдите медосмотр и загрузите заново';
  @override
  String get docExpiresToday => 'Действует до сегодня — пора на медосмотр';
  @override
  String docExpiresSoon(String date, String left) =>
      'Действует до $date — осталось $left';

  // ---- Экран «Мои подработки» ----
  @override
  String get myShiftsTitle => 'Мои подработки';
  @override
  String get reviewThanksSnack => 'Спасибо! Отзыв опубликован';
  @override
  String get myShiftsEmptyTitle => 'Пока пусто';
  @override
  String get myShiftsEmptyArchive =>
      'Сюда попадут завершённые\nи отменённые подработки';
  @override
  String get myShiftsEmptyActive => 'Найдите смену в ленте\nи запишитесь на неё';
  @override
  String get myShiftsFind => 'Найти смену';
  @override
  String get tabActive => 'В работе';
  @override
  String get tabArchive => 'Архив';
  @override
  String get archiveCancelledByEmployer => 'Смену отменил заказчик';
  @override
  String get archiveNoShow => 'Отмечен невыход';
  @override
  String get archiveUnconfirmed => 'Выход не подтверждён заказчиком';
  @override
  String get archiveBookingCancelled => 'Запись отменена';
  @override
  String get archiveReviewed => 'Отзыв оставлен';
  @override
  String get archiveRateWorkplace => 'Оценить место работы';

  // ---- Экран уведомлений ----
  @override
  String get notificationsTitle => 'Уведомления';
  @override
  String get notificationsEmptyTitle => 'Уведомлений нет';
  @override
  String get notificationsEmptySubtitle =>
      'Здесь появятся записи на ваши смены,\n'
      'подтверждения выхода и оценки';
  @override
  String get whenJustNow => 'только что';
  @override
  String whenMinutesAgo(int n) => '$n мин назад';
  @override
  String whenHoursAgo(int n) => '$n ч назад';
  @override
  String get whenYesterday => 'вчера';
  @override
  String whenDaysAgo(int n) => '$n дн назад';

  // ---- Экран «Отзывы обо мне» ----
  @override
  String get reviewsTitle => 'Отзывы обо мне';
  @override
  String get reviewsEmptyTitle => 'Отзывов пока нет';
  @override
  String get reviewsEmptySubtitle =>
      'Заказчики оценивают исполнителей\nпосле отработанной смены';
  @override
  String get reviewsRatingNote =>
      'Рейтинг — это среднее по этим оценкам. Он влияет на то, '
      'к каким сменам у вас есть доступ.';
  @override
  String ratingsCount(int n) =>
      '$n ${_plural(n, 'оценка', 'оценки', 'оценок')}';

  // ---- Поддержка ----
  @override
  String get supportTitle => 'Поддержка';
  @override
  String get supportNewTicket => 'Новое обращение';
  @override
  String get supportSubject => 'Тема';
  @override
  String get supportSubjectHint => 'Не пришло вознаграждение';
  @override
  String get supportWhatHappened => 'Что случилось';
  @override
  String get supportWrite => 'Написать';
  @override
  String get supportEmptyTitle => 'Обращений пока нет';
  @override
  String get supportEmptySubtitle =>
      'Напишите нам, если что-то пошло не так —\n'
      'обычно отвечаем в течение дня';
  @override
  String get ticketOpen => 'Открыто';
  @override
  String get ticketClosed => 'Закрыто';
  @override
  String ticketMessages(int n) => '$n сообщ.';
  @override
  String get messageHint => 'Сообщение';
}

class _Kk extends ProfileStrings {
  const _Kk();

  @override
  String get menuAlerts => 'Жаңа ауысымдар';
  @override
  String get menuAlertsHint => 'Жұмыс түрі бойынша';
  @override
  String get alertsTitle => 'Жұмыс түрі бойынша жаңа ауысымдар';
  @override
  String alertsHint(String city) =>
      'Не істей алатыныңызды белгілеңіз. $city қаласында осындай жаңа ауысым шыққанда хабарлама келеді.';
  @override
  String alertsOnSnack(String category) =>
      'Жаңа ауысымдар туралы хабарлаймыз: $category';
  @override
  String alertsOffSnack(String category) => 'Енді хабарламаймыз: $category';

  // ---- Общие кнопки окон ----
  @override
  String get cancel => 'Бас тарту';
  @override
  String get send => 'Жіберу';

  // ---- Экран профиля ----
  @override
  String get title => 'Профиль';
  @override
  String get themeTitle => 'Безендіру';
  @override
  String get themeSystem => 'Жүйедегідей';
  @override
  String get themeLight => 'Ашық';
  @override
  String get themeDark => 'Қараңғы';
  @override
  String get cityPickerTitle => 'Сіздің қалаңыз';
  @override
  String get signOutTitle => 'Аккаунттан шығасыз ба?';
  @override
  String get signOutBody =>
      'Ауысымдарға жазылуларыңыз сақталады — сол нөмірмен кірсеңіз, '
      'бәрі орнында болады.';
  @override
  String get signOutStay => 'Қалу';
  @override
  String get signOutConfirm => 'Шығу';
  @override
  String get signOutButton => 'Аккаунттан шығу';
  @override
  String get menuPayments => 'Төлемдер';
  @override
  String get menuPaymentsHint => 'Ауысым төлемі';
  @override
  String get menuPayouts => 'Төлемдер';
  @override
  String get menuPayoutsHint => 'Сыйақы';
  @override
  String get menuFavorites => 'Таңдаулы орындаушылар';
  @override
  String get menuFavoritesHint => 'Қайта шақыру';
  @override
  String get menuDocsChecked => 'Тексерілді';
  @override
  String get menuDocsNotChecked => 'Тексерілмеген';
  @override
  String get menuReviewsNone => 'Әзірге жоқ';
  @override
  String get menuCity => 'Қала';
  @override
  String get menuHowItWorks => 'fastwork қалай жұмыс істейді';
  @override
  String get menuHowItWorksHint => 'Сторис';
  @override
  String get menuTerms => 'Сервис ережелері';
  @override
  String get roleEmployer => 'Тапсырыс беруші';
  @override
  String get verified => 'Расталған';
  @override
  String get docsNotVerified => 'Құжаттар тексерілмеген';
  @override
  String statShifts(int n) => 'Ауысым';
  @override
  String get statRating => 'Рейтинг';
  @override
  String get statStarting => 'Бастапқы';
  @override
  String get statAttendance => 'Келу';
  @override
  String get statLevel => 'Деңгей';

  // ---- Экран документов ----
  @override
  String get documentsTitle => 'Құжаттар';
  @override
  String get docSentSnack => 'Құжат тексеруге жіберілді';
  @override
  String get docApprovedSnack => 'Құжат тексеріліп, қабылданды';
  @override
  String get docsHowCheck => 'Тексеру қалай өтеді';
  @override
  String get docsWhoNeedsMedbook => 'Медкітапша кімге керек';
  @override
  String get docsExplainer =>
      'Тексерілген құжаттар көбірек тапсырыс берушіге жол ашады. '
      'Азық-түлікпен жұмыс істеу үшін санитарлық кітапша қажет.';
  @override
  String get docNotUploaded => 'Жүктелмеген';
  @override
  String get docPending => 'Тексерілуде';
  @override
  String get docApproved => 'Қабылданды';
  @override
  String get docRejected => 'Қабылданбады';
  @override
  String docNumber(String number) => 'Нөмірі: $number';
  @override
  String get docUpload => 'Жүктеу';
  @override
  String get docReupload => 'Қайта жүктеу';
  @override
  String get docValidUntilHelp => 'Жарамдылық мерзімі';
  @override
  String get docNeedNumber => 'Құжат нөмірін енгізіңіз';
  @override
  String get docNeedExpiry =>
      'Медтексеру қай күнге дейін жарамды екенін көрсетіңіз';
  @override
  String get docFallback => 'Құжат';
  @override
  String get docUploadNote =>
      'Файл жүктеу әзірге қосылмаған — құжат нөмірін енгізіңіз, '
      'оқу нұсқасы үшін бұл жеткілікті.';
  @override
  String get docNumberHint => 'Құжат нөмірі';
  @override
  String get docValidUntilPick => 'Жарамдылық мерзімі…';
  @override
  String docValidUntil(String date) => '$date дейін жарамды';
  @override
  String docExpired(String date) =>
      'Мерзімі $date өтті — медтексеруден өтіп, қайта жүктеңіз';
  @override
  String get docExpiresToday => 'Бүгінге дейін жарамды — медтексеруге уақыт';
  @override
  String docExpiresSoon(String date, String left) =>
      '$date дейін жарамды — $left қалды';

  // ---- Экран «Мои подработки» ----
  @override
  String get myShiftsTitle => 'Менің жұмыстарым';
  @override
  String get reviewThanksSnack => 'Рахмет! Пікір жарияланды';
  @override
  String get myShiftsEmptyTitle => 'Әзірге бос';
  @override
  String get myShiftsEmptyArchive =>
      'Аяқталған және бас тартылған\nжұмыстар осында болады';
  @override
  String get myShiftsEmptyActive => 'Таспадан ауысым тауып,\nоған жазылыңыз';
  @override
  String get myShiftsFind => 'Ауысым табу';
  @override
  String get tabActive => 'Белсенді';
  @override
  String get tabArchive => 'Мұрағат';
  @override
  String get archiveCancelledByEmployer =>
      'Тапсырыс беруші ауысымды болдырмады';
  @override
  String get archiveNoShow => 'Келмеу белгіленді';
  @override
  String get archiveUnconfirmed => 'Тапсырыс беруші келгеніңізді растамады';
  @override
  String get archiveBookingCancelled => 'Жазылудан бас тартылды';
  @override
  String get archiveReviewed => 'Пікір қалдырылды';
  @override
  String get archiveRateWorkplace => 'Жұмыс орнын бағалау';

  // ---- Экран уведомлений ----
  @override
  String get notificationsTitle => 'Хабарламалар';
  @override
  String get notificationsEmptyTitle => 'Хабарламалар жоқ';
  @override
  String get notificationsEmptySubtitle =>
      'Мұнда ауысымдарыңызға жазылулар,\n'
      'келу растаулары мен бағалар шығады';
  @override
  String get whenJustNow => 'жаңа ғана';
  @override
  String whenMinutesAgo(int n) => '$n мин бұрын';
  @override
  String whenHoursAgo(int n) => '$n сағ бұрын';
  @override
  String get whenYesterday => 'кеше';
  @override
  String whenDaysAgo(int n) => '$n күн бұрын';

  // ---- Экран «Отзывы обо мне» ----
  @override
  String get reviewsTitle => 'Мен туралы пікірлер';
  @override
  String get reviewsEmptyTitle => 'Әзірге пікір жоқ';
  @override
  String get reviewsEmptySubtitle =>
      'Тапсырыс берушілер орындаушыны\nауысымнан кейін бағалайды';
  @override
  String get reviewsRatingNote =>
      'Рейтинг — осы бағалардың орташасы. Сізге қандай ауысымдар '
      'қолжетімді болатыны соған байланысты.';
  @override
  String ratingsCount(int n) => '$n баға';

  // ---- Поддержка ----
  @override
  String get supportTitle => 'Қолдау қызметі';
  @override
  String get supportNewTicket => 'Жаңа өтініш';
  @override
  String get supportSubject => 'Тақырып';
  @override
  String get supportSubjectHint => 'Сыйақы түспеді';
  @override
  String get supportWhatHappened => 'Не болды';
  @override
  String get supportWrite => 'Жазу';
  @override
  String get supportEmptyTitle => 'Әзірге өтініш жоқ';
  @override
  String get supportEmptySubtitle =>
      'Бірдеңе дұрыс болмаса, бізге жазыңыз —\n'
      'әдетте бір күн ішінде жауап береміз';
  @override
  String get ticketOpen => 'Ашық';
  @override
  String get ticketClosed => 'Жабық';
  @override
  String ticketMessages(int n) => '$n хабар.';
  @override
  String get messageHint => 'Хабарлама';
}

class _En extends ProfileStrings {
  const _En();

  @override
  String get menuAlerts => 'New shifts';
  @override
  String get menuAlertsHint => 'By job type';
  @override
  String get alertsTitle => 'New shifts by job type';
  @override
  String alertsHint(String city) =>
      "Pick what you can do. When a new shift of that kind appears in $city, you'll get a notification.";
  @override
  String alertsOnSnack(String category) =>
      "We'll let you know about new shifts: $category";
  @override
  String alertsOffSnack(String category) => 'No more alerts: $category';

  // ---- Общие кнопки окон ----
  @override
  String get cancel => 'Cancel';
  @override
  String get send => 'Send';

  // ---- Экран профиля ----
  @override
  String get title => 'Profile';
  @override
  String get themeTitle => 'Appearance';
  @override
  String get themeSystem => 'System default';
  @override
  String get themeLight => 'Light';
  @override
  String get themeDark => 'Dark';
  @override
  String get cityPickerTitle => 'Your city';
  @override
  String get signOutTitle => 'Sign out?';
  @override
  String get signOutBody =>
      'Your shift bookings will be kept — sign in with the same number '
      'and they’ll be right there.';
  @override
  String get signOutStay => 'Stay';
  @override
  String get signOutConfirm => 'Sign out';
  @override
  String get signOutButton => 'Sign out';
  @override
  String get menuPayments => 'Payments';
  @override
  String get menuPaymentsHint => 'Shift payments';
  @override
  String get menuPayouts => 'Payouts';
  @override
  String get menuPayoutsHint => 'Earnings';
  @override
  String get menuFavorites => 'Favorite workers';
  @override
  String get menuFavoritesHint => 'Invite again';
  @override
  String get menuDocsChecked => 'Verified';
  @override
  String get menuDocsNotChecked => 'Not verified';
  @override
  String get menuReviewsNone => 'None yet';
  @override
  String get menuCity => 'City';
  @override
  String get menuHowItWorks => 'How fastwork works';
  @override
  String get menuHowItWorksHint => 'Stories';
  @override
  String get menuTerms => 'Terms of service';
  @override
  String get roleEmployer => 'Employer';
  @override
  String get verified => 'Verified';
  @override
  String get docsNotVerified => 'Documents not verified';
  @override
  String statShifts(int n) => n == 1 ? 'Shift' : 'Shifts';
  @override
  String get statRating => 'Rating';
  @override
  String get statStarting => 'Starting';
  @override
  String get statAttendance => 'Attendance';
  @override
  String get statLevel => 'Level';

  // ---- Экран документов ----
  @override
  String get documentsTitle => 'Documents';
  @override
  String get docSentSnack => 'Document sent for review';
  @override
  String get docApprovedSnack => 'Document verified and accepted';
  @override
  String get docsHowCheck => 'How verification works';
  @override
  String get docsWhoNeedsMedbook => 'Who needs a health book';
  @override
  String get docsExplainer =>
      'Verified documents give you access to more employers. '
      'A health book is required to work with food.';
  @override
  String get docNotUploaded => 'Not uploaded';
  @override
  String get docPending => 'Under review';
  @override
  String get docApproved => 'Accepted';
  @override
  String get docRejected => 'Rejected';
  @override
  String docNumber(String number) => 'Number: $number';
  @override
  String get docUpload => 'Upload';
  @override
  String get docReupload => 'Upload again';
  @override
  String get docValidUntilHelp => 'Valid until';
  @override
  String get docNeedNumber => 'Enter the document number';
  @override
  String get docNeedExpiry => 'Enter the date your medical check is valid until';
  @override
  String get docFallback => 'Document';
  @override
  String get docUploadNote =>
      'File upload isn’t available yet — just enter the document number, '
      'that’s enough for the demo version.';
  @override
  String get docNumberHint => 'Document number';
  @override
  String get docValidUntilPick => 'Valid until…';
  @override
  String docValidUntil(String date) => 'Valid until $date';
  @override
  String docExpired(String date) =>
      'Expired on $date — get a medical check and upload again';
  @override
  String get docExpiresToday => 'Valid until today — time for a medical check';
  @override
  String docExpiresSoon(String date, String left) =>
      'Valid until $date — $left left';

  // ---- Экран «Мои подработки» ----
  @override
  String get myShiftsTitle => 'My gigs';
  @override
  String get reviewThanksSnack => 'Thanks! Your review is posted';
  @override
  String get myShiftsEmptyTitle => 'Nothing here yet';
  @override
  String get myShiftsEmptyArchive =>
      'Completed and cancelled\ngigs will appear here';
  @override
  String get myShiftsEmptyActive => 'Find a shift in the feed\nand book it';
  @override
  String get myShiftsFind => 'Find a shift';
  @override
  String get tabActive => 'Active';
  @override
  String get tabArchive => 'Archive';
  @override
  String get archiveCancelledByEmployer => 'Cancelled by the employer';
  @override
  String get archiveNoShow => 'Marked as no-show';
  @override
  String get archiveUnconfirmed => 'Attendance not confirmed by employer';
  @override
  String get archiveBookingCancelled => 'Booking cancelled';
  @override
  String get archiveReviewed => 'Review left';
  @override
  String get archiveRateWorkplace => 'Rate the workplace';

  // ---- Экран уведомлений ----
  @override
  String get notificationsTitle => 'Notifications';
  @override
  String get notificationsEmptyTitle => 'No notifications';
  @override
  String get notificationsEmptySubtitle =>
      'Bookings for your shifts, attendance\n'
      'confirmations and ratings will appear here';
  @override
  String get whenJustNow => 'just now';
  @override
  String whenMinutesAgo(int n) => '$n min ago';
  @override
  String whenHoursAgo(int n) => '$n h ago';
  @override
  String get whenYesterday => 'yesterday';
  @override
  String whenDaysAgo(int n) => '$n d ago';

  // ---- Экран «Отзывы обо мне» ----
  @override
  String get reviewsTitle => 'Reviews about me';
  @override
  String get reviewsEmptyTitle => 'No reviews yet';
  @override
  String get reviewsEmptySubtitle =>
      'Employers rate workers\nafter a completed shift';
  @override
  String get reviewsRatingNote =>
      'Your rating is the average of these scores. It affects '
      'which shifts you can access.';
  @override
  String ratingsCount(int n) => n == 1 ? '1 rating' : '$n ratings';

  // ---- Поддержка ----
  @override
  String get supportTitle => 'Support';
  @override
  String get supportNewTicket => 'New request';
  @override
  String get supportSubject => 'Subject';
  @override
  String get supportSubjectHint => 'Payment didn’t arrive';
  @override
  String get supportWhatHappened => 'What happened';
  @override
  String get supportWrite => 'Write';
  @override
  String get supportEmptyTitle => 'No requests yet';
  @override
  String get supportEmptySubtitle =>
      'Write to us if something went wrong —\n'
      'we usually reply within a day';
  @override
  String get ticketOpen => 'Open';
  @override
  String get ticketClosed => 'Closed';
  @override
  String ticketMessages(int n) => n == 1 ? '1 message' : '$n messages';
  @override
  String get messageHint => 'Message';
}
