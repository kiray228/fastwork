import '../data/shift_filter.dart';
import '../lang.dart';
import '../shift.dart';
import '../terms.dart';
import 'core_strings.dart';

/// Русский — язык, на котором приложение написано. Остальные словари
/// переводят его.
class CoreRu extends CoreStrings {
  const CoreRu();

  @override
  Lang get lang => Lang.ru;

  /// 1 смена, 2 смены, 5 смен, 11 смен.
  static String _plural(int n, String one, String few, String many) {
    final last = n % 10;
    final lastTwo = n % 100;
    if (lastTwo >= 11 && lastTwo <= 14) return '$n $many';
    if (last == 1) return '$n $one';
    if (last >= 2 && last <= 4) return '$n $few';
    return '$n $many';
  }

  @override
  List<String> get monthsShort => const [
        'янв', 'фев', 'мар', 'апр', 'мая', 'июн',
        'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
      ];

  @override
  List<String> get monthsNominative => const [
        'январь', 'февраль', 'март', 'апрель', 'май', 'июнь',
        'июль', 'август', 'сентябрь', 'октябрь', 'ноябрь', 'декабрь',
      ];

  @override
  List<String> get weekdaysShort =>
      const ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'];

  static const _monthsGenitive = [
    'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
    'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
  ];

  @override
  String dayMonth(DateTime date) =>
      '${date.day} ${_monthsGenitive[date.month - 1]}';

  @override
  String relativeDay(int daysFromToday, DateTime date) =>
      switch (daysFromToday) {
        0 => 'сегодня',
        1 => 'завтра',
        2 => 'послезавтра',
        _ => dayMonthWeekday(date),
      };

  @override
  String duration(int hours, int minutes) =>
      minutes == 0 ? '$hours ч' : '$hours ч $minutes мин';

  @override
  String shifts(int n) => _plural(n, 'смена', 'смены', 'смен');

  @override
  String days(int n) => _plural(n, 'день', 'дня', 'дней');

  @override
  String reviews(int n) => _plural(n, 'отзыв', 'отзыва', 'отзывов');

  @override
  String people(int n) => _plural(n, 'человек', 'человека', 'человек');

  @override
  String city(String city) => city;

  @override
  String category(String id) => _categories[id] ?? 'Другое';

  static const _categories = {
    'seller': 'Продавец-консультант',
    'cashier': 'Кассир',
    'sales_floor': 'Работник торгового зала',
    'merchandiser': 'Мерчендайзер',
    'promoter': 'Промоутер',
    'inventory': 'Инвентаризация',
    'loader': 'Грузчик',
    'warehouse': 'Сотрудник склада',
    'picker': 'Сборщик заказов',
    'packer': 'Упаковщик, фасовщик',
    'forklift': 'Водитель погрузчика',
    'courier': 'Курьер',
    'driver': 'Водитель',
    'cook': 'Повар',
    'cook_helper': 'Помощник повара',
    'waiter': 'Официант',
    'barista': 'Бариста',
    'bartender': 'Бармен',
    'dishwasher': 'Посудомойщик',
    'baker': 'Пекарь, кондитер',
    'cleaner': 'Уборщик',
    'housekeeper': 'Горничная',
    'janitor': 'Дворник',
    'car_wash': 'Мойщик автомобилей',
    'plumber': 'Сантехник',
    'electrician': 'Электрик',
    'handyman': 'Разнорабочий',
    'builder': 'Строитель, отделочник',
    'painter': 'Маляр',
    'welder': 'Сварщик',
    'furniture': 'Сборщик мебели',
    'production': 'Работник производства',
    'event_staff': 'Персонал мероприятий',
    'hostess': 'Хостес',
    'security': 'Охранник',
    'animator': 'Аниматор',
    'call_center': 'Оператор колл-центра',
    'reception': 'Администратор, ресепшен',
    'nanny': 'Няня',
    'other': 'Другое',
  };

  @override
  String categoryGroup(String id) => switch (id) {
        'trade' => 'Торговля',
        'warehouse' => 'Склад и доставка',
        'food' => 'Общепит',
        'cleaning' => 'Уборка',
        'repair' => 'Ремонт и стройка',
        'production' => 'Производство',
        'events' => 'Мероприятия и охрана',
        _ => 'Другое',
      };

  @override
  String tag(ShiftTag tag) => switch (tag) {
        ShiftTag.night => 'Ночная',
        ShiftTag.noBreakDeduction => 'Без вычета обеда',
        ShiftTag.payoutTomorrow => 'Выплата завтра',
        ShiftTag.fewSlots => 'Мало мест',
        ShiftTag.urgent => 'Срочно',
        ShiftTag.noCancel => 'Без отмены',
      };

  @override
  String sort(ShiftSort sort) => switch (sort) {
        ShiftSort.byTime => 'Сначала ранние',
        ShiftSort.payDesc => 'Сначала дорогие',
        ShiftSort.payAsc => 'Сначала дешёвые',
      };

  @override
  String documentType(String type) => switch (type) {
        'id_card' => 'Удостоверение личности',
        'medical_book' => 'Санитарная книжка',
        _ => type,
      };

  @override
  String level(String id) => switch (id) {
        'novice' => 'Новичок',
        'confident' => 'Уверенный',
        'experienced' => 'Опытный',
        _ => 'Профи',
      };

  @override
  String paymentMethod(String id) =>
      id == 'kaspi' ? 'Kaspi.kz' : 'Банковская карта';

  @override
  String get cardFallback => 'Карта';

  @override
  String get formNeedTitle => 'Опишите, какие услуги нужны';
  @override
  String get formNeedAddress => 'Укажите адрес';
  @override
  String formRateTooLow(String min) =>
      'Ставка должна быть не меньше $min в час';
  @override
  String formRateTooHigh(String max) =>
      'Ставка не может быть больше $max в час';
  @override
  String get formNeedWorker => 'Нужен хотя бы один человек';
  @override
  String formTooManyWorkers(int max) =>
      'На одну смену — не больше $max человек';
  @override
  String get formBadTime => 'Время смены указано неверно';
  @override
  String get formTooShort => 'Смена должна длиться хотя бы час';
  @override
  String get formStartPassed => 'Время начала уже прошло';

  @override
  String get termsNotAccepted => 'Чтобы продолжить, примите правила сервиса';
  @override
  String get documentNotFound => 'Документ не найден';
  @override
  String get ticketNotFound => 'Обращение не найдено';
  @override
  String withdrawMin(String amount) => 'Вывести можно от $amount';
  @override
  String get withdrawOverBalance => 'На балансе меньше, чем вы хотите вывести';
  @override
  String get payoutNotFound => 'Вывод не найден';
  @override
  String get payoutFailed => 'Перевод не прошёл';
  @override
  String get paymentNotFound => 'Оплата не найдена';
  @override
  String get shiftNotFound => 'Смена не найдена';
  @override
  String get shiftWasCancelled => 'Смена отменена';
  @override
  String get shiftAlreadyPaid => 'Смена уже оплачена';
  @override
  String get paymentNotSandbox =>
      'Эта оплата идёт через платёжный сервис, а не в тестовом режиме';
  @override
  String get payoutNotSandbox =>
      'Этот вывод идёт через платёжный сервис, а не в тестовом режиме';
  @override
  String get providerNoAnswer =>
      'Платёжный сервис не ответил. Попробуйте ещё раз';
  @override
  String get paymentFailed => 'Оплата не прошла';
  @override
  String get kaspiPhoneRequired =>
      'Укажите номер телефона, к которому привязан Kaspi.kz';
  @override
  String get rateOnlyOwnShift => 'Оценить можно только исполнителя своей смены';
  @override
  String get rateOnlyConfirmed =>
      'Оценить можно только того, чей выход подтверждён';
  @override
  String get reviewOnlyWorked =>
      'Отзыв можно оставить только о смене, которую вы отработали';
  @override
  String get emailCodesNeedServer =>
      'Коды на почту работают только через сервер';
  @override
  String get wrongLoginCode => 'Неверный код';
  @override
  String get operationNotFound => 'Операция не найдена';
  @override
  String get kaspiDeclined => 'Счёт отклонён в Kaspi.kz';
  @override
  String get cardNotAccepted => 'Карта не принята тестовым шлюзом';
  @override
  String get bankDeclined => 'Банк отклонил операцию. Попробуйте другую карту';

  @override
  String earning(String title, DateTime day) => '«$title», ${dayMonth(day)}';
  @override
  String get withdrawal => 'Вывод на карту';
  @override
  String payoutDone(String amount, String card) =>
      'Перевод $amount на карту $card выполнен';
  @override
  String get payoutReturned => 'Вывод не прошёл — деньги вернулись на баланс';
  @override
  String chargeShift(String title, String via) =>
      'Оплата смены «$title» · $via';
  @override
  String chargeTopup(String title, String via) =>
      'Доплата за смену «$title» · $via';
  @override
  String refundNoShow(String title) => 'Возврат за невыход: «$title»';
  @override
  String refundRest(String title) =>
      'Возврат остатка: смена «$title» прошла';
  @override
  String refundCancelled(String title) => 'Возврат: смена «$title» отменена';
  @override
  String refundUnneeded(String title) =>
      'Возврат: оплата «$title» не понадобилась';
  @override
  String refundSuperseded(String title) =>
      'Возврат доплаты: правку «$title» заменила новая';
  @override
  String refundNotApplied(String title) =>
      'Возврат доплаты: правка «$title» не применена';
  @override
  String refundCheaper(String title) =>
      'Возврат разницы: смена «$title» подешевела';

  @override
  String providerShift(String title) => 'Смена «$title»';
  @override
  String providerTopup(String title) => 'Доплата за смену «$title»';
  @override
  String get providerPayout => 'Вывод заработка fastwork';

  @override
  String get someone => 'Кто-то';
  @override
  String get anonymousWorker => 'Исполнитель';
  @override
  String get shiftFallback => 'Смена';

  @override
  Note applied(String name, String title, DateTime day) => (
        title: 'Новая запись на смену',
        body: '$name записался на «$title» ${dayMonth(day)}.',
      );
  @override
  Note withdrew(String name, String title, DateTime day) => (
        title: 'Человек снял запись',
        body: '$name больше не выйдет на «$title» ${dayMonth(day)}. '
            'Место снова свободно.',
      );
  @override
  Note confirmed(String title, DateTime day, String amount) => (
        title: 'Смена подтверждена',
        body: 'Заказчик подтвердил выход на «$title» ${dayMonth(day)}. '
            'Начислено $amount.',
      );
  @override
  Note noShow(String title, DateTime day) => (
        title: 'Отмечен невыход',
        body: 'Заказчик отметил, что вы не вышли на «$title» '
            '${dayMonth(day)}. Если это ошибка — напишите в поддержку.',
      );
  @override
  Note rated(int rating, String title, DateTime day) => (
        title: 'Новая оценка: $rating из 5',
        body: 'Заказчик оценил работу на «$title» ${dayMonth(day)}.',
      );
  @override
  Note shiftCancelled(String title, DateTime day) => (
        title: 'Смена отменена',
        body: 'Заказчик отменил «$title» ${dayMonth(day)}. '
            'Выходить не нужно.',
      );
  @override
  Note shiftChanged(String title, DateTime day, List<String> changes) => (
        title: 'Смена изменилась',
        body: '«$title» ${dayMonth(day)}: ${changes.join(', ')}.',
      );
  @override
  String changedDay(DateTime day) => 'новый день — ${dayMonth(day)}';
  @override
  String changedTime(String time) => 'новое время — $time';
  @override
  String changedRate(String rate) => 'новая ставка — $rate/ч';
  @override
  String changedAddress(String address) => 'новый адрес — $address';
  @override
  Note slotFreed(String title, DateTime day) => (
        title: 'Освободилось место',
        body: 'На «$title» ${dayMonth(day)} появилось свободное место. '
            'Успейте записаться, пока его не заняли.',
      );
  @override
  Note invited(String company, String title, DateTime day, String time,
          String amount) =>
      (
        title: '$company зовёт вас снова',
        body: 'Вы в списке любимых исполнителей. Новая смена: «$title» '
            '${dayMonth(day)}, $time, $amount. Записывайтесь, пока есть '
            'места.',
      );
  @override
  Note newShift(String company, String title, DateTime day, String time,
          String amount) =>
      (
        title: 'Новая смена: $company',
        body: '«$title» ${dayMonth(day)}, $time, $amount. '
            'Вы подписаны на эту компанию.',
      );
  @override
  Note newShiftInCategory(String category, String company, String title,
          DateTime day, String time, String amount) =>
      (
        title: 'Новая смена: $category',
        body: '$company, «$title» ${dayMonth(day)}, $time, $amount. '
            'Вы подписаны на этот вид работ.',
      );
  @override
  Note reminder(String when, String time, String title, String company,
          String address) =>
      (
        title: 'Смена $when в $time',
        body: '«$title», $company. $address. Придите на 10 минут раньше и '
            'отметьтесь в приложении — «Я на месте».',
      );

  @override
  String perShift(String amount) => '$amount за смену';
  @override
  String get guaranteedSuffix => ', оплата гарантирована';
  @override
  String bookVia(String link) => 'Записаться: $link';
  @override
  String get shiftInFastwork => 'Смена в fastwork';
  @override
  String dressCodeLine(String dressCode) => 'Форма: $dressCode';
  @override
  String cancelUntil(String when) => 'Отменить запись можно до $when.';
  @override
  String get rememberCheckIn =>
      'Не забудьте отметиться в fastwork, когда придёте.';

  @override
  String get termsTitle => 'Правила сервиса fastwork';

  @override
  List<TermsSection> get termsSections => const [
        TermsSection(
          '1. Что такое fastwork',
          'fastwork — площадка, на которой заказчики (компании) публикуют '
              'разовые смены, а исполнители записываются на них. Мы не '
              'работодатель: договор об оказании услуг заключается между '
              'заказчиком и исполнителем, а сервис соединяет их, хранит '
              'условия смены и гарантирует оплату.',
        ),
        TermsSection(
          '2. Гарантия оплаты',
          'Заказчик оплачивает смену картой при публикации. Деньги '
              'хранятся у сервиса и переводятся исполнителю, когда заказчик '
              'подтвердит, что смена отработана. Если смену отменили или '
              'исполнитель не вышел, деньги за это место возвращаются '
              'заказчику.',
        ),
        TermsSection(
          '3. Комиссия',
          'За гарантию и подбор людей сервис берёт с заказчика 4% от суммы '
              'вознаграждения. С исполнителя комиссия не удерживается: он '
              'получает ровно ту сумму, что указана в смене.',
        ),
        TermsSection(
          '4. Лимит дохода — 300 МРП в месяц',
          'Исполнитель работает в режиме платформенной занятости. Доход в '
              'этом режиме не может превышать 300 месячных расчётных '
              'показателей в месяц; МРП берётся тот, что действует на '
              '1 января текущего года. Сервис не даст записаться на смену, '
              'если с ней доход за месяц превысит лимит.',
        ),
        TermsSection(
          '5. Запись и отмена',
          'Запись на смену — обязательство выйти, а не заявка. Отменить её '
              'можно не позже срока, указанного в смене. Неявка без отмены '
              'отмечается заказчиком и снижает надёжность исполнителя.',
        ),
        TermsSection(
          '6. Рейтинг и отзывы',
          'Заказчик оценивает исполнителя после смены, исполнитель — место '
              'работы. Оценки привязаны к сменам: оставить отзыв можно '
              'только о том, где действительно работал. Часть заказчиков '
              'допускает к сменам только исполнителей с высоким рейтингом.',
        ),
        TermsSection(
          '7. Документы и данные',
          'Исполнитель загружает удостоверение личности и, если нужно, '
              'санитарную книжку. Сервис хранит имя, телефон, почту и '
              'город, чтобы заказчик знал, кто придёт на смену. Данные '
              'карты сервис не хранит: их принимает платёжный провайдер, '
              'у нас остаются только последние четыре цифры.',
        ),
        TermsSection(
          '8. Споры',
          'Если заказчик ошибся — например, отметил невыход, когда вы '
              'работали, — напишите в поддержку из приложения. Обращение '
              'рассмотрит операционная команда сервиса.',
        ),
      ];
}
