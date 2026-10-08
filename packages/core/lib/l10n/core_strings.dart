// Тексты ядра на трёх языках.
//
// Здесь всё, что ядро и сервер говорят человеку сами: даты и окончания,
// названия категорий, ошибки, тексты уведомлений и строк в истории
// платежей. Надписи экранов живут отдельно — в приложении (`lib/l10n/`),
// потому что сервер их не показывает.
//
// Словарь — абстрактный класс, а каждый язык — его наследник. Так
// компилятор сам следит, чтобы перевод был полным: добавили фразу сюда и
// забыли перевести на казахский — приложение не соберётся. Словарь в виде
// таблицы «ключ → строка» так не умеет: пропущенный ключ всплыл бы только
// у человека на экране.

import '../data/shift_filter.dart';
import '../lang.dart';
import '../shift.dart';
import '../terms.dart';
import 'core_en.dart';
import 'core_kk.dart';
import 'core_ru.dart';

/// Уведомление: заголовок и текст.
typedef Note = ({String title, String body});

abstract class CoreStrings {
  const CoreStrings();

  /// Словарь для языка.
  static CoreStrings of(Lang lang) => switch (lang) {
        Lang.ru => const CoreRu(),
        Lang.kk => const CoreKk(),
        Lang.en => const CoreEn(),
      };

  Lang get lang;

  // -------------------------------------------------------------------------
  // Даты, время, числа
  // -------------------------------------------------------------------------

  /// «янв» … «дек».
  List<String> get monthsShort;

  /// «январь» … «декабрь» — как в «Лимит за сентябрь».
  List<String> get monthsNominative;

  /// «пн» … «вс».
  List<String> get weekdaysShort;

  /// «12 сентября».
  String dayMonth(DateTime date);

  /// «12 сен».
  String dayMonthShort(DateTime date) =>
      '${date.day} ${monthsShort[date.month - 1]}';

  /// «12 сен, пт».
  String dayMonthWeekday(DateTime date) =>
      '${dayMonthShort(date)}, ${weekdaysShort[date.weekday - 1]}';

  /// «17 сен, 08:00».
  String dateTimeShort(DateTime dt) =>
      '${dayMonthShort(dt)}, ${dt.hour.toString().padLeft(2, '0')}:'
      '${dt.minute.toString().padLeft(2, '0')}';

  /// «сентябрь 2026».
  String monthYear(DateTime month) =>
      '${monthsNominative[month.month - 1]} ${month.year}';

  /// «сегодня», «завтра», «послезавтра» — или дата.
  String relativeDay(int daysFromToday, DateTime date);

  /// «11 ч», «11 ч 30 мин».
  String duration(int hours, int minutes);

  /// «3 смены».
  String shifts(int n);

  /// «3 дня».
  String days(int n);

  /// «3 отзыва».
  String reviews(int n);

  /// «3 человека».
  String people(int n);

  // -------------------------------------------------------------------------
  // Справочники
  // -------------------------------------------------------------------------

  /// Город для показа. В базе город хранится по-русски — это ключ, как
  /// `id` у категории, а на экране — на языке человека.
  String city(String city);

  /// Название категории работ по её ключу.
  String category(String id);

  /// Раздел категорий по ключу раздела.
  String categoryGroup(String id);

  String tag(ShiftTag tag);

  String sort(ShiftSort sort);

  /// Тип документа: `id_card`, `medical_book`.
  String documentType(String type);

  /// Уровень исполнителя: `novice`, `confident`, `experienced`, `pro`.
  String level(String id);

  /// Способ оплаты: `card`, `kaspi`.
  String paymentMethod(String id);

  /// Карта неизвестной платёжной системы.
  String get cardFallback;

  // -------------------------------------------------------------------------
  // Условия новой смены — общие для формы и сервера
  // -------------------------------------------------------------------------

  String get formNeedTitle;
  String get formNeedAddress;
  String formRateTooLow(String min);
  String formRateTooHigh(String max);
  String get formNeedWorker;
  String formTooManyWorkers(int max);
  String get formBadTime;
  String get formTooShort;
  String get formStartPassed;

  // -------------------------------------------------------------------------
  // Отказы, которые человек видит как есть
  // -------------------------------------------------------------------------

  String get termsNotAccepted;
  String get documentNotFound;
  String get ticketNotFound;
  String withdrawMin(String amount);
  String get withdrawOverBalance;
  String get payoutNotFound;
  String get payoutFailed;
  String get paymentNotFound;
  String get shiftNotFound;
  String get shiftWasCancelled;
  String get shiftAlreadyPaid;
  String get paymentNotSandbox;
  String get payoutNotSandbox;
  String get providerNoAnswer;
  String get paymentFailed;
  String get kaspiPhoneRequired;
  String get rateOnlyOwnShift;
  String get rateOnlyConfirmed;
  String get reviewOnlyWorked;
  String get emailCodesNeedServer;
  String get wrongLoginCode;
  String get operationNotFound;
  String get kaspiDeclined;
  String get cardNotAccepted;
  String get bankDeclined;

  // -------------------------------------------------------------------------
  // История платежей — строки пишутся на языке того, чья это история
  // -------------------------------------------------------------------------

  /// «„Услуги грузчика“, 12 сентября».
  String earning(String title, DateTime day);
  String get withdrawal;
  String payoutDone(String amount, String card);
  String get payoutReturned;
  String chargeShift(String title, String via);
  String chargeTopup(String title, String via);
  String refundNoShow(String title);
  String refundRest(String title);
  String refundCancelled(String title);
  String refundUnneeded(String title);
  String refundSuperseded(String title);
  String refundNotApplied(String title);
  String refundCheaper(String title);

  /// Что увидит человек на странице провайдера.
  String providerShift(String title);
  String providerTopup(String title);
  String get providerPayout;

  // -------------------------------------------------------------------------
  // Уведомления — на языке того, кому они адресованы
  // -------------------------------------------------------------------------

  /// Кто-то без имени — подпись в уведомлении.
  String get someone;

  /// Автор отзыва без имени.
  String get anonymousWorker;

  /// Смена без названия.
  String get shiftFallback;

  Note applied(String name, String title, DateTime day);
  Note withdrew(String name, String title, DateTime day);
  Note confirmed(String title, DateTime day, String amount);
  Note noShow(String title, DateTime day);
  Note rated(int rating, String title, DateTime day);
  Note shiftCancelled(String title, DateTime day);
  Note shiftChanged(String title, DateTime day, List<String> changes);
  String changedDay(DateTime day);
  String changedTime(String time);
  String changedRate(String rate);
  String changedAddress(String address);
  Note slotFreed(String title, DateTime day);
  Note invited(String company, String title, DateTime day, String time,
      String amount);
  Note newShift(String company, String title, DateTime day, String time,
      String amount);
  Note reminder(String when, String time, String title, String company,
      String address);

  // -------------------------------------------------------------------------
  // Пересылка и календарь
  // -------------------------------------------------------------------------

  /// «12 100 ₸ за смену».
  String perShift(String amount);
  String get guaranteedSuffix;
  String bookVia(String link);
  String get shiftInFastwork;
  String dressCodeLine(String dressCode);
  String cancelUntil(String when);
  String get rememberCheckIn;

  // -------------------------------------------------------------------------
  // Правила сервиса
  // -------------------------------------------------------------------------

  String get termsTitle;
  List<TermsSection> get termsSections;
}

/// Словарь того языка, на котором сейчас говорит приложение.
CoreStrings get coreTr => CoreStrings.of(currentLang);
