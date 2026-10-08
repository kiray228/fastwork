import '../data/shift_filter.dart';
import '../lang.dart';
import '../shift.dart';
import '../terms.dart';
import 'core_strings.dart';

/// Қазақша.
///
/// Санның артынан зат есім жекеше тұрады: «3 ауысым», «5 пікір» — сондықтан
/// орыс тіліндегідей үш түрлі жалғау керек емес. Терминдер бір жерде
/// бекітілген (docs/17-yazyki.md): смена — ауысым, исполнитель —
/// орындаушы, заказчик — тапсырыс беруші, МРП — АЕК.
class CoreKk extends CoreStrings {
  const CoreKk();

  @override
  Lang get lang => Lang.kk;

  @override
  List<String> get monthsShort => const [
        'қаң', 'ақп', 'нау', 'сәу', 'мам', 'мау',
        'шіл', 'там', 'қыр', 'қаз', 'қар', 'жел',
      ];

  @override
  List<String> get monthsNominative => const [
        'қаңтар', 'ақпан', 'наурыз', 'сәуір', 'мамыр', 'маусым',
        'шілде', 'тамыз', 'қыркүйек', 'қазан', 'қараша', 'желтоқсан',
      ];

  @override
  List<String> get weekdaysShort =>
      const ['дс', 'сс', 'ср', 'бс', 'жм', 'сб', 'жс'];

  @override
  String dayMonth(DateTime date) =>
      '${date.day} ${monthsNominative[date.month - 1]}';

  @override
  String relativeDay(int daysFromToday, DateTime date) =>
      switch (daysFromToday) {
        0 => 'бүгін',
        1 => 'ертең',
        2 => 'бүрсігүні',
        _ => dayMonthWeekday(date),
      };

  @override
  String duration(int hours, int minutes) =>
      minutes == 0 ? '$hours сағ' : '$hours сағ $minutes мин';

  @override
  String shifts(int n) => '$n ауысым';

  @override
  String days(int n) => '$n күн';

  @override
  String reviews(int n) => '$n пікір';

  @override
  String people(int n) => '$n адам';

  @override
  String city(String city) => switch (city) {
        'Караганда' => 'Қарағанды',
        'Актобе' => 'Ақтөбе',
        _ => city,
      };

  @override
  String category(String id) => _categories[id] ?? 'Басқа';

  static const _categories = {
    'seller': 'Сатушы-кеңесші',
    'cashier': 'Кассир',
    'sales_floor': 'Сауда залының қызметкері',
    'merchandiser': 'Мерчендайзер',
    'promoter': 'Промоутер',
    'inventory': 'Түгендеу',
    'loader': 'Жүк тиеуші',
    'warehouse': 'Қойма қызметкері',
    'picker': 'Тапсырыс жинаушы',
    'packer': 'Орап-буып салушы',
    'forklift': 'Тиегіш жүргізушісі',
    'courier': 'Курьер',
    'driver': 'Жүргізуші',
    'cook': 'Аспаз',
    'cook_helper': 'Аспаз көмекшісі',
    'waiter': 'Даяшы',
    'barista': 'Бариста',
    'bartender': 'Бармен',
    'dishwasher': 'Ыдыс жуушы',
    'baker': 'Наубайшы, кондитер',
    'cleaner': 'Тазалаушы',
    'housekeeper': 'Бөлме қызметшісі',
    'janitor': 'Аула сыпырушы',
    'car_wash': 'Көлік жуушы',
    'plumber': 'Сантехник',
    'electrician': 'Электрик',
    'handyman': 'Көмекші жұмысшы',
    'builder': 'Құрылысшы, әрлеуші',
    'painter': 'Сырлаушы',
    'welder': 'Дәнекерлеуші',
    'furniture': 'Жиһаз құрастырушы',
    'production': 'Өндіріс қызметкері',
    'event_staff': 'Іс-шара персоналы',
    'hostess': 'Хостес',
    'security': 'Күзетші',
    'animator': 'Аниматор',
    'call_center': 'Колл-орталық операторы',
    'reception': 'Әкімші, ресепшн',
    'nanny': 'Бала күтуші',
    'other': 'Басқа',
  };

  @override
  String categoryGroup(String id) => switch (id) {
        'trade' => 'Сауда',
        'warehouse' => 'Қойма және жеткізу',
        'food' => 'Қоғамдық тамақтану',
        'cleaning' => 'Тазалау',
        'repair' => 'Жөндеу және құрылыс',
        'production' => 'Өндіріс',
        'events' => 'Іс-шаралар және күзет',
        _ => 'Басқа',
      };

  @override
  String tag(ShiftTag tag) => switch (tag) {
        ShiftTag.night => 'Түнгі',
        ShiftTag.noBreakDeduction => 'Түскі үзіліс ұсталмайды',
        ShiftTag.payoutTomorrow => 'Төлем ертең',
        ShiftTag.fewSlots => 'Орын аз',
        ShiftTag.urgent => 'Шұғыл',
        ShiftTag.noCancel => 'Бас тартусыз',
      };

  @override
  String sort(ShiftSort sort) => switch (sort) {
        ShiftSort.byTime => 'Алдымен ерте басталатындар',
        ShiftSort.payDesc => 'Алдымен көп төленетіндер',
        ShiftSort.payAsc => 'Алдымен аз төленетіндер',
      };

  @override
  String documentType(String type) => switch (type) {
        'id_card' => 'Жеке куәлік',
        'medical_book' => 'Санитарлық кітапша',
        _ => type,
      };

  @override
  String level(String id) => switch (id) {
        'novice' => 'Жаңа бастаушы',
        'confident' => 'Сенімді',
        'experienced' => 'Тәжірибелі',
        _ => 'Кәсіпқой',
      };

  @override
  String paymentMethod(String id) => id == 'kaspi' ? 'Kaspi.kz' : 'Банк картасы';

  @override
  String get cardFallback => 'Карта';

  @override
  String get formNeedTitle => 'Қандай қызмет керек екенін сипаттаңыз';
  @override
  String get formNeedAddress => 'Мекенжайды көрсетіңіз';
  @override
  String formRateTooLow(String min) =>
      'Сағаттық мөлшерлеме кемінде $min болуы керек';
  @override
  String formRateTooHigh(String max) =>
      'Сағаттық мөлшерлеме ең көбі $max бола алады';
  @override
  String get formNeedWorker => 'Кемінде бір адам керек';
  @override
  String formTooManyWorkers(int max) => 'Бір ауысымға ең көбі $max адам';
  @override
  String get formBadTime => 'Ауысым уақыты қате көрсетілген';
  @override
  String get formTooShort => 'Ауысым кемінде бір сағатқа созылуы керек';
  @override
  String get formStartPassed => 'Басталу уақыты өтіп кетті';

  @override
  String get termsNotAccepted =>
      'Жалғастыру үшін сервис ережелерін қабылдаңыз';
  @override
  String get documentNotFound => 'Құжат табылмады';
  @override
  String get ticketNotFound => 'Өтініш табылмады';
  @override
  String withdrawMin(String amount) => 'Шығарудың ең аз сомасы — $amount';
  @override
  String get withdrawOverBalance =>
      'Балансыңыздағы ақша шығарғыңыз келген сомадан аз';
  @override
  String get payoutNotFound => 'Шығару табылмады';
  @override
  String get payoutFailed => 'Аударым өтпеді';
  @override
  String get paymentNotFound => 'Төлем табылмады';
  @override
  String get shiftNotFound => 'Ауысым табылмады';
  @override
  String get shiftWasCancelled => 'Ауысымның күші жойылды';
  @override
  String get shiftAlreadyPaid => 'Ауысым төленіп қойған';
  @override
  String get paymentNotSandbox =>
      'Бұл төлем сынақ режимінде емес, төлем қызметі арқылы өтеді';
  @override
  String get payoutNotSandbox =>
      'Бұл шығару сынақ режимінде емес, төлем қызметі арқылы өтеді';
  @override
  String get providerNoAnswer =>
      'Төлем қызметі жауап бермеді. Қайталап көріңіз';
  @override
  String get paymentFailed => 'Төлем өтпеді';
  @override
  String get kaspiPhoneRequired =>
      'Kaspi.kz байланған телефон нөмірін көрсетіңіз';
  @override
  String get rateOnlyOwnShift =>
      'Тек өз ауысымыңыздың орындаушысын бағалауға болады';
  @override
  String get rateOnlyConfirmed =>
      'Тек келгені расталған адамды бағалауға болады';
  @override
  String get reviewOnlyWorked =>
      'Пікірді тек өзіңіз жұмыс істеген ауысым туралы қалдыруға болады';
  @override
  String get emailCodesNeedServer =>
      'Поштаға келетін кодтар тек сервер арқылы жұмыс істейді';
  @override
  String get wrongLoginCode => 'Код қате';
  @override
  String get operationNotFound => 'Операция табылмады';
  @override
  String get kaspiDeclined => 'Шот Kaspi.kz-те қабылданбады';
  @override
  String get cardNotAccepted => 'Картаны сынақ шлюзі қабылдамады';
  @override
  String get bankDeclined =>
      'Банк операцияны қабылдамады. Басқа картаны қолданып көріңіз';

  @override
  String earning(String title, DateTime day) => '«$title», ${dayMonth(day)}';
  @override
  String get withdrawal => 'Картаға шығару';
  @override
  String payoutDone(String amount, String card) =>
      '$amount сомасы $card картасына аударылды';
  @override
  String get payoutReturned => 'Шығару өтпеді — ақша балансқа қайтарылды';
  @override
  String chargeShift(String title, String via) =>
      '«$title» ауысымының төлемі · $via';
  @override
  String chargeTopup(String title, String via) =>
      '«$title» ауысымына қосымша төлем · $via';
  @override
  String refundNoShow(String title) => 'Келмегені үшін қайтарым: «$title»';
  @override
  String refundRest(String title) =>
      'Қалдықты қайтару: «$title» ауысымы өтті';
  @override
  String refundCancelled(String title) =>
      'Қайтарым: «$title» ауысымының күші жойылды';
  @override
  String refundUnneeded(String title) =>
      'Қайтарым: «$title» төлемі қажет болмады';
  @override
  String refundSuperseded(String title) =>
      'Қосымша төлемді қайтару: «$title» өзгерісін жаңасы алмастырды';
  @override
  String refundNotApplied(String title) =>
      'Қосымша төлемді қайтару: «$title» өзгерісі қолданылмады';
  @override
  String refundCheaper(String title) =>
      'Айырманы қайтару: «$title» ауысымы арзандады';

  @override
  String providerShift(String title) => '«$title» ауысымы';
  @override
  String providerTopup(String title) => '«$title» ауысымына қосымша төлем';
  @override
  String get providerPayout => 'fastwork табысын шығару';

  @override
  String get someone => 'Біреу';
  @override
  String get anonymousWorker => 'Орындаушы';
  @override
  String get shiftFallback => 'Ауысым';

  @override
  Note applied(String name, String title, DateTime day) => (
        title: 'Ауысымға жаңа жазылу',
        body: '$name ${dayMonth(day)} «$title» ауысымына жазылды.',
      );
  @override
  Note withdrew(String name, String title, DateTime day) => (
        title: 'Адам жазылудан бас тартты',
        body: '$name ${dayMonth(day)} «$title» ауысымына шықпайды. '
            'Орын қайта бос.',
      );
  @override
  Note confirmed(String title, DateTime day, String amount) => (
        title: 'Ауысым расталды',
        body: 'Тапсырыс беруші ${dayMonth(day)} «$title» ауысымына '
            'келгеніңізді растады. $amount есептелді.',
      );
  @override
  Note noShow(String title, DateTime day) => (
        title: 'Келмеу белгіленді',
        body: 'Тапсырыс беруші сіздің ${dayMonth(day)} «$title» '
            'ауысымына келмегеніңізді белгіледі. Егер бұл қате болса — '
            'қолдау қызметіне жазыңыз.',
      );
  @override
  Note rated(int rating, String title, DateTime day) => (
        title: 'Жаңа баға: 5-тен $rating',
        body: 'Тапсырыс беруші ${dayMonth(day)} «$title» ауысымындағы '
            'жұмысыңызды бағалады.',
      );
  @override
  Note shiftCancelled(String title, DateTime day) => (
        title: 'Ауысымның күші жойылды',
        body: 'Тапсырыс беруші ${dayMonth(day)} «$title» ауысымын '
            'болдырмады. Шығудың қажеті жоқ.',
      );
  @override
  Note shiftChanged(String title, DateTime day, List<String> changes) => (
        title: 'Ауысым өзгерді',
        body: '«$title», ${dayMonth(day)}: ${changes.join(', ')}.',
      );
  @override
  String changedDay(DateTime day) => 'жаңа күн — ${dayMonth(day)}';
  @override
  String changedTime(String time) => 'жаңа уақыт — $time';
  @override
  String changedRate(String rate) => 'жаңа мөлшерлеме — $rate/сағ';
  @override
  String changedAddress(String address) => 'жаңа мекенжай — $address';
  @override
  Note slotFreed(String title, DateTime day) => (
        title: 'Орын босады',
        body: '${dayMonth(day)} «$title» ауысымында бос орын пайда болды. '
            'Біреу алып қойғанша жазылып үлгеріңіз.',
      );
  @override
  Note invited(String company, String title, DateTime day, String time,
          String amount) =>
      (
        title: '$company сізді қайта шақырады',
        body: 'Сіз таңдаулы орындаушылар тізіміндесіз. Жаңа ауысым: '
            '«$title», ${dayMonth(day)}, $time, $amount. Орын барда '
            'жазылыңыз.',
      );
  @override
  Note newShift(String company, String title, DateTime day, String time,
          String amount) =>
      (
        title: 'Жаңа ауысым: $company',
        body: '«$title», ${dayMonth(day)}, $time, $amount. Сіз бұл '
            'компанияның жаңа ауысымдарын бақылайсыз.',
      );
  @override
  Note reminder(String when, String time, String title, String company,
          String address) =>
      (
        title: 'Ауысым $when, басталуы $time',
        body: '«$title», $company. $address. 10 минут ерте келіп, '
            'қосымшада «Келдім» деп белгіленіңіз.',
      );

  @override
  String perShift(String amount) => 'ауысым үшін $amount';
  @override
  String get guaranteedSuffix => ', төлем кепілдендірілген';
  @override
  String bookVia(String link) => 'Жазылу: $link';
  @override
  String get shiftInFastwork => 'fastwork-тегі ауысым';
  @override
  String dressCodeLine(String dressCode) => 'Киім үлгісі: $dressCode';
  @override
  String cancelUntil(String when) =>
      'Жазылудан $when дейін бас тартуға болады.';
  @override
  String get rememberCheckIn =>
      'Келгенде fastwork-те белгіленуді ұмытпаңыз.';

  @override
  String get termsTitle => 'fastwork сервисінің ережелері';

  @override
  List<TermsSection> get termsSections => const [
        TermsSection(
          '1. fastwork деген не',
          'fastwork — тапсырыс берушілер (компаниялар) бір реттік '
              'ауысымдарды жариялайтын, ал орындаушылар оларға жазылатын '
              'алаң. Біз жұмыс беруші емеспіз: қызмет көрсету шарты '
              'тапсырыс беруші мен орындаушы арасында жасалады, ал сервис '
              'оларды байланыстырады, ауысым шарттарын сақтайды және '
              'төлемге кепілдік береді.',
        ),
        TermsSection(
          '2. Төлем кепілдігі',
          'Тапсырыс беруші ауысымды жариялаған кезде оны картамен төлейді. '
              'Ақша сервисте сақталады және тапсырыс беруші ауысымның '
              'атқарылғанын растағанда орындаушыға аударылады. Егер '
              'ауысымның күші жойылса немесе орындаушы келмесе, сол '
              'орынның ақшасы тапсырыс берушіге қайтарылады.',
        ),
        TermsSection(
          '3. Комиссия',
          'Кепілдік пен адам іріктеу үшін сервис тапсырыс берушіден '
              'сыйақы сомасының 4%-ын алады. Орындаушыдан комиссия '
              'ұсталмайды: ол ауысымда көрсетілген соманы толық алады.',
        ),
        TermsSection(
          '4. Табыс лимиті — айына 300 АЕК',
          'Орындаушы платформалық жұмыспен қамту режимінде жұмыс істейді. '
              'Бұл режимдегі табыс айына 300 айлық есептік көрсеткіштен '
              'аспауы тиіс; АЕК ағымдағы жылдың 1 қаңтарындағы мөлшерде '
              'алынады. Ауысыммен бірге айлық табыс лимиттен асатын болса, '
              'сервис оған жазылуға мүмкіндік бермейді.',
        ),
        TermsSection(
          '5. Жазылу және бас тарту',
          'Ауысымға жазылу — өтінім емес, шығу міндеттемесі. Одан '
              'ауысымда көрсетілген мерзімнен кешіктірмей бас тартуға '
              'болады. Бас тартпай келмеуді тапсырыс беруші белгілейді, '
              'және бұл орындаушының сенімділігін төмендетеді.',
        ),
        TermsSection(
          '6. Рейтинг және пікірлер',
          'Ауысымнан кейін тапсырыс беруші орындаушыны, ал орындаушы '
              'жұмыс орнын бағалайды. Бағалар ауысымдарға байланған: '
              'пікірді тек шынымен жұмыс істеген жер туралы қалдыруға '
              'болады. Кейбір тапсырыс берушілер ауысымдарға тек рейтингі '
              'жоғары орындаушыларды жібереді.',
        ),
        TermsSection(
          '7. Құжаттар мен деректер',
          'Орындаушы жеке куәлігін және қажет болса санитарлық '
              'кітапшасын жүктейді. Тапсырыс беруші ауысымға кім келетінін '
              'білуі үшін сервис аты-жөнді, телефонды, поштаны және қаланы '
              'сақтайды. Сервис карта деректерін сақтамайды: оларды төлем '
              'провайдері қабылдайды, бізде тек соңғы төрт цифр қалады.',
        ),
        TermsSection(
          '8. Даулар',
          'Егер тапсырыс беруші қателессе — мысалы, сіз жұмыс істеген '
              'кезде «келмеді» деп белгілесе, — қосымшадан қолдау '
              'қызметіне жазыңыз. Өтінішті сервистің операциялық тобы '
              'қарайды.',
        ),
      ];
}
