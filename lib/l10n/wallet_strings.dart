// Кошелёк, вывод денег, оплата смены, график заработка.
//
// Абстрактный класс — словарь, наследники — языки. Добавили фразу сюда и
// забыли перевести — приложение не соберётся.

import 'package:fastwork_core/lang.dart';

abstract class WalletStrings {
  const WalletStrings();

  // ---- Справка о заработке ----
  String get statementLink;
  String get statementTitle;
  String get statementPrevMonth;
  String get statementNextMonth;
  String get statementShifts;
  String get statementHours;
  String get statementEarned;
  String get statementShiftsTitle;
  String get statementEmpty;
  String get statementNote;
  String get statementCopy;
  String get statementCopied;
  String get statementHeader;
  String statementLine(String day, String company, String title, String time,
      String duration, String amount);
  String statementTotal(String shifts, String hours, String amount);

  static WalletStrings of(Lang lang) => switch (lang) {
        Lang.ru => const _Ru(),
        Lang.kk => const _Kk(),
        Lang.en => const _En(),
      };

  // ---- Экран кошелька ----

  /// Заголовок экрана у заказчика.
  String get paymentsTitle;

  /// Заголовок экрана у исполнителя.
  String get payoutsTitle;
  String get withdrawSheetTitle;
  String get withdrawSheetNote;
  String get availableToWithdraw;

  /// Кнопка в окне вывода: «Вывести 12 000 ₸».
  String withdrawAmount(String amount);
  String get withdrawSentSnack;
  String get withdrawPendingSnack;
  String get escrowHelpLink;
  String get payoutsHelpLink;

  /// «Что такое лимит 300 МРП».
  String limitHelpLink(int mrp);
  String get historyTitle;
  String get managerHistoryEmpty;
  String get workerHistoryEmpty;
  String earnedTotal(String amount);
  String get withdrawToCard;

  /// Подсказка под неактивной кнопкой вывода.
  String withdrawFrom(String min);

  // ---- Гарантия оплаты — для заказчика ----

  String get escrowTitle;
  String get escrowPayOnPublish;
  String get escrowWorkerPaid;
  String get escrowRefund;
  String escrowFee(int percent);

  /// Предупреждение о тестовом режиме на экране кошелька.
  String get sandboxNotice;

  // ---- Лимит заработка за месяц ----

  /// «Лимит за сентябрь 2026».
  String limitTitle(String month);

  /// «из 1 200 000 ₸» — рядом с использованной суммой.
  String limitOf(String limit);
  String limitNote(String remaining, int mrp, String mrpValue);

  // ---- Окно оплаты ----

  String get total;
  String get kaspiPhoneMissing;
  String get paymentFailed;
  String get providerOpenFailed;
  String get checkCardNumber;
  String get checkExpiry;
  String get cvcHint;
  String get kaspiPhoneLabel;
  String get kaspiPhoneNote;
  String get payoutCardNote;
  String get tryAgain;
  String get cardPrivacy;
  String get kaspiConfirmTest;
  String get cardNumber;
  String get expiry;

  /// Подсказка в поле срока карты: «ММ/ГГ».
  String get expiryHint;
  String get fillTestCard;
  String transferAmount(String amount);
  String payAmount(String amount);
  String get providerOpened;
  String get waitingConfirmation;
  String get openKaspi;
  String get openPaymentPage;
  String get paidCheck;
  String get closePayLater;

  /// Подпись под плиткой Kaspi.kz.
  String get kaspiCaption;

  /// «Счёт на 12 000 ₸ отправлен в Kaspi.kz на номер …».
  String kaspiInvoice(String amount, String? phone);
  String sandboxBanner(String card);

  // ---- График заработка ----

  String get chartTitle;

  /// «За 8 недель — 96 000 ₸, в среднем 24 000 ₸ в рабочую неделю».
  String chartSummary(int weeks, String total, String? average);

  /// Подпись под последним столбиком.
  String get thisWeekShort;
  String get thisWeek;

  /// «неделя с 6 окт».
  String weekFrom(String date);
}

class _Ru extends WalletStrings {
  const _Ru();

  @override
  String get statementLink => 'Справка о заработке';
  @override
  String get statementTitle => 'Справка о заработке';
  @override
  String get statementPrevMonth => 'Предыдущий месяц';
  @override
  String get statementNextMonth => 'Следующий месяц';
  @override
  String get statementShifts => 'Смены';
  @override
  String get statementHours => 'Часы';
  @override
  String get statementEarned => 'Заработано';
  @override
  String get statementShiftsTitle => 'Отработанные смены';
  @override
  String get statementEmpty => 'За этот месяц подтверждённых смен нет.';
  @override
  String get statementNote =>
      'Только смены, которые подтвердил заказчик, — за них начислены деньги.';
  @override
  String get statementCopy => 'Скопировать справку';
  @override
  String get statementCopied =>
      'Справка скопирована — вставьте её в письмо или чат';
  @override
  String get statementHeader => 'Справка о заработке в fastwork';
  @override
  String statementLine(String day, String company, String title, String time,
          String duration, String amount) =>
      '$day — $company, «$title», $time, $duration — $amount';
  @override
  String statementTotal(String shifts, String hours, String amount) =>
      'Итого: $shifts, $hours, $amount';

  static String _plural(int n, String one, String few, String many) {
    final last = n % 10;
    final lastTwo = n % 100;
    if (lastTwo >= 11 && lastTwo <= 14) return '$n $many';
    if (last == 1) return '$n $one';
    if (last >= 2 && last <= 4) return '$n $few';
    return '$n $many';
  }

  // ---- Экран кошелька ----

  @override
  String get paymentsTitle => 'Платежи';
  @override
  String get payoutsTitle => 'Выплаты';
  @override
  String get withdrawSheetTitle => 'Вывод на карту';
  @override
  String get withdrawSheetNote =>
      'Переведём весь баланс. Комиссии за вывод нет.';
  @override
  String get availableToWithdraw => 'Доступно к выводу';
  @override
  String withdrawAmount(String amount) => 'Вывести $amount';
  @override
  String get withdrawSentSnack => 'Деньги отправлены на карту';
  @override
  String get withdrawPendingSnack =>
      'Перевод в обработке — деньги придут, когда банк его проведёт';
  @override
  String get escrowHelpLink => 'Как устроена оплата смен';
  @override
  String get payoutsHelpLink => 'Как работают выплаты';
  @override
  String limitHelpLink(int mrp) => 'Что такое лимит $mrp МРП';
  @override
  String get historyTitle => 'История';
  @override
  String get managerHistoryEmpty =>
      'Платежей пока нет. Они появятся, когда вы оплатите первую смену.';
  @override
  String get workerHistoryEmpty => 'Пока начислений нет. Они появятся, когда '
      'заказчик подтвердит вашу первую смену.';
  @override
  String earnedTotal(String amount) => 'Заработано всего: $amount';
  @override
  String get withdrawToCard => 'Вывести на карту';
  @override
  String withdrawFrom(String min) => 'Вывести можно от $min';

  // ---- Гарантия оплаты — для заказчика ----

  @override
  String get escrowTitle => 'Сервис — гарант оплаты';
  @override
  String get escrowPayOnPublish =>
      'Вы оплачиваете смену при публикации — деньги держит сервис.';
  @override
  String get escrowWorkerPaid =>
      'Исполнитель получает их, когда вы подтвердите его выход.';
  @override
  String get escrowRefund =>
      'За невыход и при отмене смены деньги возвращаются на карту.';
  @override
  String escrowFee(int percent) =>
      'Комиссия сервиса — $percent% сверх вознаграждения.';
  @override
  String get sandboxNotice =>
      'Тестовый режим оплаты: карты тестовые, деньги ненастоящие. '
      'Правила удержания, начисления и возврата — настоящие.';

  // ---- Лимит заработка за месяц ----

  @override
  String limitTitle(String month) => 'Лимит за $month';
  @override
  String limitOf(String limit) => 'из $limit';
  @override
  String limitNote(String remaining, int mrp, String mrpValue) =>
      'Осталось $remaining. Лимит — $mrp МРП, один МРП в этом году '
      '$mrpValue. В счёт идут и отработанные смены, и те, на которые вы '
      'записаны.';

  // ---- Окно оплаты ----

  @override
  String get total => 'Итого';
  @override
  String get kaspiPhoneMissing => 'Введите номер, к которому привязан Kaspi.kz';
  @override
  String get paymentFailed => 'Оплата не прошла';
  @override
  String get providerOpenFailed => 'Не получилось открыть страницу оплаты';
  @override
  String get checkCardNumber => 'Проверьте номер карты';
  @override
  String get checkExpiry => 'Проверьте срок действия';
  @override
  String get cvcHint => 'CVC — три цифры с обратной стороны';
  @override
  String get kaspiPhoneLabel => 'Номер телефона в Kaspi.kz';
  @override
  String get kaspiPhoneNote =>
      'На этот номер придёт счёт в приложении Kaspi.kz — останется '
      'подтвердить его там.';
  @override
  String get payoutCardNote =>
      'Карту любого банка, в том числе Kaspi Gold, вы укажете на '
      'следующем шаге — на странице платёжного сервиса.';
  @override
  String get tryAgain => 'Попробовать ещё раз';
  @override
  String get cardPrivacy =>
      'fastwork не видит номер вашей карты: его принимает платёжный '
      'сервис. Деньги хранятся у сервиса до конца смены.';
  @override
  String get kaspiConfirmTest => 'Подтвердить в Kaspi.kz (тест)';
  @override
  String get cardNumber => 'Номер карты';
  @override
  String get expiry => 'Срок';
  @override
  String get expiryHint => 'ММ/ГГ';
  @override
  String get fillTestCard => 'Подставить тестовую карту';
  @override
  String transferAmount(String amount) => 'Перевести $amount';
  @override
  String payAmount(String amount) => 'Оплатить $amount';
  @override
  String get providerOpened =>
      'Мы открыли страницу платёжного сервиса. Заплатите там и '
      'вернитесь сюда — окно само увидит оплату.';
  @override
  String get waitingConfirmation => 'Ждём подтверждение оплаты…';
  @override
  String get openKaspi => 'Открыть Kaspi.kz';
  @override
  String get openPaymentPage => 'Открыть страницу оплаты';
  @override
  String get paidCheck => 'Я оплатил — проверить';
  @override
  String get closePayLater => 'Закрыть — оплачу позже';
  @override
  String get kaspiCaption => 'Счёт в приложении';
  @override
  String kaspiInvoice(String amount, String? phone) =>
      'Счёт на $amount отправлен в Kaspi.kz'
      '${phone == null ? '' : ' на номер $phone'}. '
      'Откройте приложение Kaspi.kz и подтвердите оплату.';
  @override
  String sandboxBanner(String card) =>
      'Тестовый режим: деньги ненастоящие, платёж проходит прямо '
      'здесь. Карта $card проходит, карта на …0002 — отказ банка.';

  // ---- График заработка ----

  @override
  String get chartTitle => 'Заработок по неделям';
  @override
  String chartSummary(int weeks, String total, String? average) =>
      'За ${_plural(weeks, 'неделю', 'недели', 'недель')} — $total'
      '${average == null ? '' : ', в среднем $average в рабочую неделю'}';
  @override
  String get thisWeekShort => 'эта';
  @override
  String get thisWeek => 'эта неделя';
  @override
  String weekFrom(String date) => 'неделя с $date';
}

class _Kk extends WalletStrings {
  const _Kk();

  @override
  String get statementLink => 'Табыс туралы анықтама';
  @override
  String get statementTitle => 'Табыс туралы анықтама';
  @override
  String get statementPrevMonth => 'Алдыңғы ай';
  @override
  String get statementNextMonth => 'Келесі ай';
  @override
  String get statementShifts => 'Ауысым';
  @override
  String get statementHours => 'Сағат';
  @override
  String get statementEarned => 'Табыс';
  @override
  String get statementShiftsTitle => 'Жұмыс істелген ауысымдар';
  @override
  String get statementEmpty => 'Бұл айда расталған ауысым жоқ.';
  @override
  String get statementNote =>
      'Тек тапсырыс беруші растаған ауысымдар — ақша солар үшін есептелді.';
  @override
  String get statementCopy => 'Анықтаманы көшіру';
  @override
  String get statementCopied =>
      'Анықтама көшірілді — оны хатқа не чатқа қойыңыз';
  @override
  String get statementHeader => 'fastwork-тегі табыс туралы анықтама';
  @override
  String statementLine(String day, String company, String title, String time,
          String duration, String amount) =>
      '$day — $company, «$title», $time, $duration — $amount';
  @override
  String statementTotal(String shifts, String hours, String amount) =>
      'Барлығы: $shifts, $hours, $amount';

  // ---- Экран кошелька ----

  @override
  String get paymentsTitle => 'Төлемдер';
  @override
  String get payoutsTitle => 'Төлемдер';
  @override
  String get withdrawSheetTitle => 'Картаға шығару';
  @override
  String get withdrawSheetNote =>
      'Бүкіл теңгерімді аударамыз. Ақша шығаруға комиссия жоқ.';
  @override
  String get availableToWithdraw => 'Шығаруға қолжетімді';
  @override
  String withdrawAmount(String amount) => '$amount шығару';
  @override
  String get withdrawSentSnack => 'Ақша картаға жіберілді';
  @override
  String get withdrawPendingSnack =>
      'Аударым өңделуде — банк өткізген соң ақша түседі';
  @override
  String get escrowHelpLink => 'Ауысым төлемі қалай жұмыс істейді';
  @override
  String get payoutsHelpLink => 'Төлемдер қалай жұмыс істейді';
  @override
  String limitHelpLink(int mrp) => '$mrp АЕК лимиті деген не';
  @override
  String get historyTitle => 'Тарих';
  @override
  String get managerHistoryEmpty => 'Әзірге төлемдер жоқ. Алғашқы ауысымды '
      'төлегенде осында пайда болады.';
  @override
  String get workerHistoryEmpty => 'Әзірге түсім жоқ. Тапсырыс беруші '
      'алғашқы ауысымыңызды растағанда осында пайда болады.';
  @override
  String earnedTotal(String amount) => 'Барлық табыс: $amount';
  @override
  String get withdrawToCard => 'Картаға шығару';
  @override
  String withdrawFrom(String min) => 'Кемінде $min шығаруға болады';

  // ---- Гарантия оплаты — для заказчика ----

  @override
  String get escrowTitle => 'Сервис — төлем кепілі';
  @override
  String get escrowPayOnPublish =>
      'Ауысымды жариялағанда төлейсіз — ақшаны сервис сақтайды.';
  @override
  String get escrowWorkerPaid =>
      'Орындаушы ақшаны сіз оның келгенін растағанда алады.';
  @override
  String get escrowRefund =>
      'Орындаушы келмесе немесе ауысым тоқтатылса, ақша картаға қайтады.';
  @override
  String escrowFee(int percent) =>
      'Сервис комиссиясы — сыйақыдан бөлек $percent%.';
  @override
  String get sandboxNotice =>
      'Төлемнің тест режимі: карталар тестілік, ақша шын емес. '
      'Ұстау, есептеу және қайтару ережелері — шынайы.';

  // ---- Лимит заработка за месяц ----

  @override
  String limitTitle(String month) => 'Лимит: $month';
  @override
  String limitOf(String limit) => '$limit ішінен';
  @override
  String limitNote(String remaining, int mrp, String mrpValue) =>
      'Қалғаны: $remaining. Лимит — $mrp АЕК, биыл бір АЕК $mrpValue. '
      'Есепке жұмыс істеген ауысымдар да, жазылған ауысымдар да кіреді.';

  // ---- Окно оплаты ----

  @override
  String get total => 'Барлығы';
  @override
  String get kaspiPhoneMissing => 'Kaspi.kz тіркелген нөмірді енгізіңіз';
  @override
  String get paymentFailed => 'Төлем өтпеді';
  @override
  String get providerOpenFailed => 'Төлем бетін ашу мүмкін болмады';
  @override
  String get checkCardNumber => 'Карта нөмірін тексеріңіз';
  @override
  String get checkExpiry => 'Жарамдылық мерзімін тексеріңіз';
  @override
  String get cvcHint => 'CVC — картаның артындағы үш сан';
  @override
  String get kaspiPhoneLabel => 'Kaspi.kz-тегі телефон нөмірі';
  @override
  String get kaspiPhoneNote =>
      'Бұл нөмірге Kaspi.kz қосымшасында шот келеді — оны сонда '
      'растасаңыз болғаны.';
  @override
  String get payoutCardNote =>
      'Кез келген банк картасын, соның ішінде Kaspi Gold-ты, келесі '
      'қадамда — төлем сервисінің бетінде көрсетесіз.';
  @override
  String get tryAgain => 'Қайта көру';
  @override
  String get cardPrivacy =>
      'fastwork картаңыздың нөмірін көрмейді: оны төлем сервисі '
      'қабылдайды. Ақша ауысым аяқталғанша сервисте сақталады.';
  @override
  String get kaspiConfirmTest => 'Kaspi.kz-те растау (тест)';
  @override
  String get cardNumber => 'Карта нөмірі';
  @override
  String get expiry => 'Мерзімі';
  @override
  String get expiryHint => 'АА/ЖЖ';
  @override
  String get fillTestCard => 'Тест картасын қою';
  @override
  String transferAmount(String amount) => '$amount аудару';
  @override
  String payAmount(String amount) => '$amount төлеу';
  @override
  String get providerOpened =>
      'Төлем сервисінің бетін аштық. Сонда төлеп, осында оралыңыз — '
      'терезе төлемді өзі көреді.';
  @override
  String get waitingConfirmation => 'Төлемнің расталуын күтеміз…';
  @override
  String get openKaspi => 'Kaspi.kz ашу';
  @override
  String get openPaymentPage => 'Төлем бетін ашу';
  @override
  String get paidCheck => 'Төледім — тексеру';
  @override
  String get closePayLater => 'Жабу — кейін төлеймін';
  @override
  String get kaspiCaption => 'Қосымшадағы шот';
  @override
  String kaspiInvoice(String amount, String? phone) =>
      '$amount сомасына шот Kaspi.kz-ке'
      '${phone == null ? '' : ' $phone нөміріне'} жіберілді. '
      'Kaspi.kz қосымшасын ашып, төлемді растаңыз.';
  @override
  String sandboxBanner(String card) =>
      'Тест режимі: ақша шын емес, төлем осы жерде өтеді. $card картасы '
      'өтеді, …0002-мен аяқталатын картаға банк бас тартады.';

  // ---- График заработка ----

  @override
  String get chartTitle => 'Апталық табыс';
  @override
  String chartSummary(int weeks, String total, String? average) =>
      '$weeks аптада — $total'
      '${average == null ? '' : ', жұмыс аптасына орта есеппен $average'}';
  @override
  String get thisWeekShort => 'осы';
  @override
  String get thisWeek => 'осы апта';
  @override
  String weekFrom(String date) => '$date басталған апта';
}

class _En extends WalletStrings {
  const _En();

  @override
  String get statementLink => 'Earnings statement';
  @override
  String get statementTitle => 'Earnings statement';
  @override
  String get statementPrevMonth => 'Previous month';
  @override
  String get statementNextMonth => 'Next month';
  @override
  String get statementShifts => 'Shifts';
  @override
  String get statementHours => 'Hours';
  @override
  String get statementEarned => 'Earned';
  @override
  String get statementShiftsTitle => 'Shifts worked';
  @override
  String get statementEmpty => 'No confirmed shifts this month.';
  @override
  String get statementNote =>
      'Only shifts confirmed by the employer — the ones you were paid for.';
  @override
  String get statementCopy => 'Copy statement';
  @override
  String get statementCopied =>
      'Statement copied — paste it into an email or chat';
  @override
  String get statementHeader => 'fastwork earnings statement';
  @override
  String statementLine(String day, String company, String title, String time,
          String duration, String amount) =>
      '$day — $company, “$title”, $time, $duration — $amount';
  @override
  String statementTotal(String shifts, String hours, String amount) =>
      'Total: $shifts, $hours, $amount';

  // ---- Экран кошелька ----

  @override
  String get paymentsTitle => 'Payments';
  @override
  String get payoutsTitle => 'Payouts';
  @override
  String get withdrawSheetTitle => 'Withdraw to card';
  @override
  String get withdrawSheetNote =>
      'We’ll transfer your whole balance. No withdrawal fee.';
  @override
  String get availableToWithdraw => 'Available to withdraw';
  @override
  String withdrawAmount(String amount) => 'Withdraw $amount';
  @override
  String get withdrawSentSnack => 'Money sent to your card';
  @override
  String get withdrawPendingSnack =>
      'Transfer in progress — the money will arrive once the bank processes it';
  @override
  String get escrowHelpLink => 'How shift payment works';
  @override
  String get payoutsHelpLink => 'How payouts work';
  @override
  String limitHelpLink(int mrp) => 'What is the $mrp MCI limit';
  @override
  String get historyTitle => 'History';
  @override
  String get managerHistoryEmpty =>
      'No payments yet. They’ll show up once you pay for your first shift.';
  @override
  String get workerHistoryEmpty => 'No earnings yet. They’ll show up once '
      'an employer confirms your first shift.';
  @override
  String earnedTotal(String amount) => 'Total earned: $amount';
  @override
  String get withdrawToCard => 'Withdraw to card';
  @override
  String withdrawFrom(String min) => 'Minimum withdrawal: $min';

  // ---- Гарантия оплаты — для заказчика ----

  @override
  String get escrowTitle => 'Payment guaranteed by the service';
  @override
  String get escrowPayOnPublish =>
      'You pay when you publish a shift — the service holds the money.';
  @override
  String get escrowWorkerPaid =>
      'The worker gets it once you confirm they showed up.';
  @override
  String get escrowRefund =>
      'For no-shows and cancelled shifts, the money goes back to your card.';
  @override
  String escrowFee(int percent) => 'Service fee: $percent% on top of the pay.';
  @override
  String get sandboxNotice =>
      'Test payment mode: test cards, no real money. '
      'Holds, earnings and refunds follow the real rules.';

  // ---- Лимит заработка за месяц ----

  @override
  String limitTitle(String month) => 'Limit for $month';
  @override
  String limitOf(String limit) => 'of $limit';
  @override
  String limitNote(String remaining, int mrp, String mrpValue) =>
      '$remaining left. The limit is $mrp MCI; one MCI this year is '
      '$mrpValue. Both worked shifts and shifts you’ve booked count '
      'toward it.';

  // ---- Окно оплаты ----

  @override
  String get total => 'Total';
  @override
  String get kaspiPhoneMissing => 'Enter the number linked to Kaspi.kz';
  @override
  String get paymentFailed => 'Payment failed';
  @override
  String get providerOpenFailed => 'Couldn’t open the payment page';
  @override
  String get checkCardNumber => 'Check the card number';
  @override
  String get checkExpiry => 'Check the expiry date';
  @override
  String get cvcHint => 'CVC is the three digits on the back';
  @override
  String get kaspiPhoneLabel => 'Kaspi.kz phone number';
  @override
  String get kaspiPhoneNote =>
      'A bill will arrive in the Kaspi.kz app for this number — just '
      'confirm it there.';
  @override
  String get payoutCardNote =>
      'You’ll enter a card from any bank, Kaspi Gold included, on the '
      'next step — on the payment provider’s page.';
  @override
  String get tryAgain => 'Try again';
  @override
  String get cardPrivacy =>
      'fastwork never sees your card number: the payment provider '
      'handles it. The money is held by the service until the shift ends.';
  @override
  String get kaspiConfirmTest => 'Confirm in Kaspi.kz (test)';
  @override
  String get cardNumber => 'Card number';
  @override
  String get expiry => 'Expiry';
  @override
  String get expiryHint => 'MM/YY';
  @override
  String get fillTestCard => 'Use a test card';
  @override
  String transferAmount(String amount) => 'Transfer $amount';
  @override
  String payAmount(String amount) => 'Pay $amount';
  @override
  String get providerOpened =>
      'We’ve opened the payment page. Pay there and come back — this '
      'window will pick up the payment on its own.';
  @override
  String get waitingConfirmation => 'Waiting for payment confirmation…';
  @override
  String get openKaspi => 'Open Kaspi.kz';
  @override
  String get openPaymentPage => 'Open payment page';
  @override
  String get paidCheck => 'I’ve paid — check';
  @override
  String get closePayLater => 'Close — pay later';
  @override
  String get kaspiCaption => 'Bill in the app';
  @override
  String kaspiInvoice(String amount, String? phone) =>
      'A bill for $amount has been sent to Kaspi.kz'
      '${phone == null ? '' : ' for $phone'}. '
      'Open the Kaspi.kz app and confirm the payment.';
  @override
  String sandboxBanner(String card) =>
      'Test mode: no real money, the payment happens right here. '
      'Card $card goes through; a card ending in …0002 is declined.';

  // ---- График заработка ----

  @override
  String get chartTitle => 'Weekly earnings';
  @override
  String chartSummary(int weeks, String total, String? average) =>
      '$weeks weeks: $total'
      '${average == null ? '' : ', on average $average per working week'}';
  @override
  String get thisWeekShort => 'now';
  @override
  String get thisWeek => 'this week';
  @override
  String weekFrom(String date) => 'week of $date';
}
