import '../data/shift_filter.dart';
import '../lang.dart';
import '../shift.dart';
import '../terms.dart';
import 'core_strings.dart';

/// English.
///
/// Terms are fixed in docs/17-yazyki.md: смена — shift, исполнитель —
/// worker, заказчик — employer, МРП — MCI (monthly calculation index).
class CoreEn extends CoreStrings {
  const CoreEn();

  @override
  Lang get lang => Lang.en;

  static String _plural(int n, String one, String many) =>
      n == 1 ? '$n $one' : '$n $many';

  @override
  List<String> get monthsShort => const [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];

  @override
  List<String> get monthsNominative => const [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];

  @override
  List<String> get weekdaysShort =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  String dayMonth(DateTime date) =>
      '${date.day} ${monthsNominative[date.month - 1]}';

  @override
  String relativeDay(int daysFromToday, DateTime date) =>
      switch (daysFromToday) {
        0 => 'today',
        1 => 'tomorrow',
        2 => 'the day after tomorrow',
        _ => dayMonthWeekday(date),
      };

  @override
  String duration(int hours, int minutes) =>
      minutes == 0 ? '$hours h' : '$hours h $minutes min';

  @override
  String shifts(int n) => _plural(n, 'shift', 'shifts');

  @override
  String days(int n) => _plural(n, 'day', 'days');

  @override
  String reviews(int n) => _plural(n, 'review', 'reviews');

  @override
  String people(int n) => _plural(n, 'person', 'people');

  @override
  String city(String city) => switch (city) {
        'Алматы' => 'Almaty',
        'Астана' => 'Astana',
        'Шымкент' => 'Shymkent',
        'Караганда' => 'Karaganda',
        'Актобе' => 'Aktobe',
        'Тараз' => 'Taraz',
        _ => city,
      };

  @override
  String category(String id) => _categories[id] ?? 'Other';

  static const _categories = {
    'seller': 'Sales assistant',
    'cashier': 'Cashier',
    'sales_floor': 'Sales floor associate',
    'merchandiser': 'Merchandiser',
    'promoter': 'Promoter',
    'inventory': 'Stocktaking',
    'loader': 'Loader',
    'warehouse': 'Warehouse associate',
    'picker': 'Order picker',
    'packer': 'Packer',
    'forklift': 'Forklift driver',
    'courier': 'Courier',
    'driver': 'Driver',
    'cook': 'Cook',
    'cook_helper': 'Kitchen assistant',
    'waiter': 'Waiter',
    'barista': 'Barista',
    'bartender': 'Bartender',
    'dishwasher': 'Dishwasher',
    'baker': 'Baker, pastry cook',
    'cleaner': 'Cleaner',
    'housekeeper': 'Housekeeper',
    'janitor': 'Yard keeper',
    'car_wash': 'Car washer',
    'plumber': 'Plumber',
    'electrician': 'Electrician',
    'handyman': 'General labourer',
    'builder': 'Builder, finisher',
    'painter': 'Painter',
    'welder': 'Welder',
    'furniture': 'Furniture assembler',
    'production': 'Production worker',
    'event_staff': 'Event staff',
    'hostess': 'Host',
    'security': 'Security guard',
    'animator': 'Entertainer',
    'call_center': 'Call centre agent',
    'reception': 'Administrator, reception',
    'nanny': 'Nanny',
    'other': 'Other',
  };

  @override
  String categoryGroup(String id) => switch (id) {
        'trade' => 'Retail',
        'warehouse' => 'Warehouse and delivery',
        'food' => 'Food service',
        'cleaning' => 'Cleaning',
        'repair' => 'Repair and construction',
        'production' => 'Manufacturing',
        'events' => 'Events and security',
        _ => 'Other',
      };

  @override
  String tag(ShiftTag tag) => switch (tag) {
        ShiftTag.night => 'Night',
        ShiftTag.noBreakDeduction => 'No lunch deduction',
        ShiftTag.payoutTomorrow => 'Paid tomorrow',
        ShiftTag.fewSlots => 'Few places left',
        ShiftTag.urgent => 'Urgent',
        ShiftTag.noCancel => 'No cancellation',
      };

  @override
  String sort(ShiftSort sort) => switch (sort) {
        ShiftSort.byTime => 'Earliest first',
        ShiftSort.payDesc => 'Highest pay first',
        ShiftSort.payAsc => 'Lowest pay first',
      };

  @override
  String documentType(String type) => switch (type) {
        'id_card' => 'ID card',
        'medical_book' => 'Health certificate',
        _ => type,
      };

  @override
  String level(String id) => switch (id) {
        'novice' => 'Newcomer',
        'confident' => 'Confident',
        'experienced' => 'Experienced',
        _ => 'Pro',
      };

  @override
  String paymentMethod(String id) => id == 'kaspi' ? 'Kaspi.kz' : 'Bank card';

  @override
  String get cardFallback => 'Card';

  @override
  String get formNeedTitle => 'Describe what services you need';
  @override
  String get formNeedAddress => 'Enter the address';
  @override
  String formRateTooLow(String min) => 'The rate must be at least $min an hour';
  @override
  String formRateTooHigh(String max) =>
      'The rate cannot be more than $max an hour';
  @override
  String get formNeedWorker => 'You need at least one person';
  @override
  String formTooManyWorkers(int max) => 'No more than $max people per shift';
  @override
  String get formBadTime => 'The shift time is invalid';
  @override
  String get formTooShort => 'A shift must last at least an hour';
  @override
  String get formStartPassed => 'The start time has already passed';

  @override
  String get termsNotAccepted => 'To continue, accept the terms of service';
  @override
  String get documentNotFound => 'Document not found';
  @override
  String get ticketNotFound => 'Request not found';
  @override
  String withdrawMin(String amount) => 'The minimum withdrawal is $amount';
  @override
  String get withdrawOverBalance =>
      'Your balance is less than you want to withdraw';
  @override
  String get payoutNotFound => 'Withdrawal not found';
  @override
  String get payoutFailed => 'The transfer failed';
  @override
  String get paymentNotFound => 'Payment not found';
  @override
  String get shiftNotFound => 'Shift not found';
  @override
  String get shiftWasCancelled => 'The shift has been cancelled';
  @override
  String get shiftAlreadyPaid => 'The shift is already paid';
  @override
  String get paymentNotSandbox =>
      'This payment goes through the payment service, not the test mode';
  @override
  String get payoutNotSandbox =>
      'This withdrawal goes through the payment service, not the test mode';
  @override
  String get providerNoAnswer =>
      'The payment service did not respond. Please try again';
  @override
  String get paymentFailed => 'The payment failed';
  @override
  String get kaspiPhoneRequired =>
      'Enter the phone number linked to your Kaspi.kz';
  @override
  String get rateOnlyOwnShift => 'You can only rate workers from your shift';
  @override
  String get rateOnlyConfirmed =>
      'You can only rate someone whose attendance you confirmed';
  @override
  String get reviewOnlyWorked =>
      'You can only review a shift you have worked';
  @override
  String get emailCodesNeedServer => 'Email codes only work via the server';
  @override
  String get wrongLoginCode => 'Wrong code';
  @override
  String get operationNotFound => 'Operation not found';
  @override
  String get kaspiDeclined => 'The invoice was declined in Kaspi.kz';
  @override
  String get cardNotAccepted => 'The test gateway did not accept the card';
  @override
  String get bankDeclined =>
      'The bank declined the transaction. Try another card';

  @override
  String earning(String title, DateTime day) => '“$title”, ${dayMonth(day)}';
  @override
  String get withdrawal => 'Withdrawal to card';
  @override
  String payoutDone(String amount, String card) =>
      '$amount transferred to card $card';
  @override
  String get payoutReturned =>
      'Withdrawal failed — the money is back on your balance';
  @override
  String chargeShift(String title, String via) =>
      'Payment for “$title” · $via';
  @override
  String chargeTopup(String title, String via) =>
      'Top-up for “$title” · $via';
  @override
  String refundNoShow(String title) => 'Refund for a no-show: “$title”';
  @override
  String refundRest(String title) =>
      'Refund of the remainder: “$title” is over';
  @override
  String refundCancelled(String title) =>
      'Refund: “$title” was cancelled';
  @override
  String refundUnneeded(String title) =>
      'Refund: the payment for “$title” was not needed';
  @override
  String refundSuperseded(String title) =>
      'Top-up refund: a newer edit replaced the edit of “$title”';
  @override
  String refundNotApplied(String title) =>
      'Top-up refund: the edit of “$title” was not applied';
  @override
  String refundCheaper(String title) =>
      'Refund of the difference: “$title” became cheaper';

  @override
  String providerShift(String title) => 'Shift “$title”';
  @override
  String providerTopup(String title) => 'Top-up for shift “$title”';
  @override
  String get providerPayout => 'fastwork earnings withdrawal';

  @override
  String get someone => 'Someone';
  @override
  String get anonymousWorker => 'Worker';
  @override
  String get shiftFallback => 'Shift';

  @override
  Note applied(String name, String title, DateTime day) => (
        title: 'New booking for your shift',
        body: '$name booked “$title” on ${dayMonth(day)}.',
      );
  @override
  Note withdrew(String name, String title, DateTime day) => (
        title: 'A booking was cancelled',
        body: '$name will not come to “$title” on ${dayMonth(day)}. '
            'The place is free again.',
      );
  @override
  Note confirmed(String title, DateTime day, String amount) => (
        title: 'Shift confirmed',
        body: 'The employer confirmed your attendance at “$title” on '
            '${dayMonth(day)}. $amount credited.',
      );
  @override
  Note noShow(String title, DateTime day) => (
        title: 'No-show recorded',
        body: 'The employer recorded that you did not come to “$title” on '
            '${dayMonth(day)}. If this is a mistake, write to support.',
      );
  @override
  Note rated(int rating, String title, DateTime day) => (
        title: 'New rating: $rating out of 5',
        body: 'The employer rated your work at “$title” on '
            '${dayMonth(day)}.',
      );
  @override
  Note shiftCancelled(String title, DateTime day) => (
        title: 'Shift cancelled',
        body: 'The employer cancelled “$title” on ${dayMonth(day)}. '
            'You do not need to come.',
      );
  @override
  Note shiftChanged(String title, DateTime day, List<String> changes) => (
        title: 'The shift has changed',
        body: '“$title”, ${dayMonth(day)}: ${changes.join(', ')}.',
      );
  @override
  String changedDay(DateTime day) => 'new day — ${dayMonth(day)}';
  @override
  String changedTime(String time) => 'new time — $time';
  @override
  String changedRate(String rate) => 'new rate — $rate/h';
  @override
  String changedAddress(String address) => 'new address — $address';
  @override
  Note slotFreed(String title, DateTime day) => (
        title: 'A place is free',
        body: 'A place opened up at “$title” on ${dayMonth(day)}. '
            'Book it before someone else does.',
      );
  @override
  Note invited(String company, String title, DateTime day, String time,
          String amount) =>
      (
        title: '$company invites you back',
        body: 'You are on their list of favourite workers. New shift: '
            '“$title”, ${dayMonth(day)}, $time, $amount. Book while there '
            'are places.',
      );
  @override
  Note newShift(String company, String title, DateTime day, String time,
          String amount) =>
      (
        title: 'New shift: $company',
        body: '“$title”, ${dayMonth(day)}, $time, $amount. '
            'You follow this company.',
      );
  @override
  Note reminder(String when, String time, String title, String company,
          String address) =>
      (
        title: 'Shift $when at $time',
        body: '“$title”, $company. $address. Arrive 10 minutes early and '
            'check in in the app — “I’m here”.',
      );

  @override
  String perShift(String amount) => '$amount per shift';
  @override
  String get guaranteedSuffix => ', payment guaranteed';
  @override
  String bookVia(String link) => 'Book: $link';
  @override
  String get shiftInFastwork => 'A shift on fastwork';
  @override
  String dressCodeLine(String dressCode) => 'Dress code: $dressCode';
  @override
  String cancelUntil(String when) => 'You can cancel until $when.';
  @override
  String get rememberCheckIn =>
      'Do not forget to check in on fastwork when you arrive.';

  @override
  String get termsTitle => 'fastwork terms of service';

  @override
  List<TermsSection> get termsSections => const [
        TermsSection(
          '1. What fastwork is',
          'fastwork is a platform where employers (companies) post '
              'one-off shifts and workers book them. We are not the '
              'employer: the service agreement is made between the '
              'employer and the worker, while the service connects them, '
              'keeps the shift terms and guarantees payment.',
        ),
        TermsSection(
          '2. Payment guarantee',
          'The employer pays for the shift by card when posting it. The '
              'money is held by the service and transferred to the worker '
              'once the employer confirms that the shift was worked. If '
              'the shift is cancelled or the worker does not come, the '
              'money for that place is returned to the employer.',
        ),
        TermsSection(
          '3. Fee',
          'For the guarantee and finding people, the service charges the '
              'employer 4% of the pay. No fee is taken from the worker: '
              'they receive exactly the amount stated in the shift.',
        ),
        TermsSection(
          '4. Income cap — 300 MCI a month',
          'The worker works under the platform employment regime. Income '
              'under this regime may not exceed 300 monthly calculation '
              'indices (MCI) a month, using the MCI in force on 1 January '
              'of the current year. The service will not let you book a '
              'shift if it would take your monthly income over the cap.',
        ),
        TermsSection(
          '5. Booking and cancellation',
          'Booking a shift is a commitment to come, not an application. '
              'You can cancel it no later than the deadline stated in the '
              'shift. A no-show without cancelling is recorded by the '
              'employer and lowers the worker’s reliability.',
        ),
        TermsSection(
          '6. Ratings and reviews',
          'After a shift the employer rates the worker, and the worker '
              'rates the workplace. Ratings are tied to shifts: you can '
              'only review a place where you actually worked. Some '
              'employers only accept workers with a high rating.',
        ),
        TermsSection(
          '7. Documents and data',
          'The worker uploads an ID card and, if needed, a health '
              'certificate. The service stores the name, phone, email and '
              'city so that the employer knows who is coming. The service '
              'does not store card details: the payment provider receives '
              'them, and we keep only the last four digits.',
        ),
        TermsSection(
          '8. Disputes',
          'If the employer made a mistake — for example, recorded a '
              'no-show while you were working — write to support from the '
              'app. The service’s operations team will review the request.',
        ),
      ];
}
