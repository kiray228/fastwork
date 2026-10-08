import 'package:flutter/material.dart';

import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/mrp.dart';
import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/shift.dart';
import '../l10n/stories_strings.dart';
import '../l10n/strings.dart';
import 'infographics.dart';
import 'story.dart';

// Что рассказывают истории.
//
// Текст короткий нарочно: историю смотрят на ходу, по пять-десять секунд
// на экран. Подробности — в правилах и на экранах, куда ведут кнопки.
//
// Числа не вписаны руками, а берутся из ядра: комиссия — из
// `kPlatformFeePercent`, МРП — из `kMrpHistory`, минимальный вывод —
// из `kMinWithdrawal`. Изменится правило — изменится и история, и
// рассказ не разойдётся с тем, как приложение работает на самом деле.

/// Смена-пример. Одна на все истории, чтобы суммы везде сходились:
/// 12 100 ₸ исполнителю, 484 ₸ комиссии, 12 584 ₸ с заказчика.
Shift get _example => Shift(
  id: 0,
  workDate: DateTime(2026),
  title: _s.exampleShiftTitle,
  category: 'picker',
  company: _s.exampleCompany,
  address: _s.exampleAddress,
  startMinutes: 9 * 60,
  endMinutes: 20 * 60,
  hourlyRate: 121000,
  workersNeeded: 5,
  workersHired: 1,
);

ShiftCost get _cost => ShiftCost(slotPay: _example.totalPay, slots: 1);

StoriesStrings get _s => tr.stories;

const _how = Color(0xFF0EA5E9);
const _money = Color(0xFF0FA36B);
const _limitColor = Color(0xFF14B8A6);
const _docs = Color(0xFF6366F1);
const _med = Color(0xFFEC4899);
const _rules = Color(0xFFF97316);
const _stars = Color(0xFFF59E0B);
const _help = Color(0xFF8B5CF6);

/// Истории исполнителя — на главном экране «Смены».
List<Story> workerStories() => [
      Story(
        id: 'how.1',
        title: _s.howTitle,
        icon: Icons.bolt_rounded,
        color: _how,
        slides: [
          StorySlide(
            title: _s.howGigTitle,
            body: _s.howGigBody,
            visual: (context, data) =>
                MiniShiftCard(shift: _example, color: _how),
          ),
          StorySlide(
            title: _s.howStepsTitle,
            body: _s.howStepsBody,
            visual: (context, data) => const StepList(
              color: _how,
              items: [
                StepItem(Icons.search_rounded, _s.stepFind,
                    caption: _s.stepFindCaption),
                StepItem(Icons.how_to_reg_rounded, _s.stepBook,
                    caption: _s.stepBookCaption),
                StepItem(Icons.location_on_rounded, _s.stepCheckIn,
                    caption: _s.stepCheckInCaption),
                StepItem(Icons.payments_rounded, _s.stepGetPaid,
                    caption: _s.stepGetPaidCaption),
              ],
            ),
          ),
          StorySlide(
            title: _s.payGuaranteed,
            body: _s.howGuaranteedBody,
            visual: (context, data) => MoneyFlow(
              color: _how,
              nodes: [
                MoneyNode(Icons.business_rounded, _s.flowEmployer,
                    amount: formatMoney(_cost.total)),
                const MoneyNode(Icons.shield_rounded, 'fastwork',
                    amount: _s.flowHolds, highlight: true),
                MoneyNode(Icons.person_rounded, _s.flowYou,
                    amount: formatMoney(_cost.pay)),
              ],
              links: const [_s.flowPaysUpfront, _s.flowAfterShift],
            ),
          ),
          StorySlide(
            title: _s.howDocsTitle,
            body: _s.howDocsBody,
            visual: (context, data) => const StatusChain(
              color: _how,
              steps: [
                StepItem(Icons.upload_file_rounded, _s.docUploadedPlural),
                StepItem(Icons.hourglass_top_rounded, _s.docChecking),
                StepItem(Icons.verified_rounded, _s.docVerified),
              ],
            ),
            action: StoryAction.documents,
            actionLabel: _s.uploadDocuments,
          ),
        ],
      ),
      Story(
        id: 'payouts.2',
        title: _s.payoutsTitle,
        icon: Icons.payments_rounded,
        color: _money,
        slides: [
          StorySlide(
            title: _s.moneyPathTitle,
            body: _s.moneyPathBody,
            visual: (context, data) => const StepList(
              color: _money,
              items: [
                StepItem(Icons.credit_card_rounded, _s.pathEmployerPaid,
                    caption: _s.pathEmployerPaidCaption),
                StepItem(Icons.shield_rounded, _s.pathServiceHolds,
                    caption: _s.pathServiceHoldsCaption),
                StepItem(Icons.fact_check_rounded, _s.pathYouWorked,
                    caption: _s.pathYouWorkedCaption),
                StepItem(Icons.account_balance_wallet_rounded,
                    _s.pathOnBalance,
                    caption: _s.pathOnBalanceCaption),
              ],
            ),
          ),
          StorySlide(
            title: _s.fullAmountTitle,
            body: _s.fullAmountBody(kPlatformFeePercent),
            visual: (context, data) => SplitBar(
              header: _s.splitHeaderWorker,
              parts: [
                SplitPart(_s.splitToYou, _cost.pay, Colors.white,
                    note: _s.splitToYouNote),
                SplitPart(_s.serviceFee, _cost.fee,
                    Colors.white.withValues(alpha: 0.35),
                    note: _s.feePaidByEmployer(kPlatformFeePercent)),
              ],
            ),
          ),
          StorySlide(
            title: _s.whenMoneyTitle,
            body: _s.whenMoneyBody,
            visual: (context, data) => const StatusChain(
              color: _money,
              steps: [
                StepItem(Icons.work_rounded, _s.chainShift,
                    caption: _s.chainShiftCaption),
                StepItem(Icons.fact_check_rounded, _s.chainConfirm,
                    caption: _s.chainConfirmCaption),
                StepItem(Icons.account_balance_wallet_rounded, _s.chainBalance,
                    caption: _s.chainBalanceCaption),
              ],
            ),
          ),
          StorySlide(
            title: _s.withdrawTitle,
            body: _s.withdrawBody(formatMoney(kMinWithdrawal)),
            visual: (context, data) =>
                const CardMock(caption: _s.withdrawFeeCaption),
            action: StoryAction.wallet,
            actionLabel: _s.openPayouts,
          ),
        ],
      ),
      Story(
        id: 'limit.1',
        title: _s.limitTitle,
        icon: Icons.donut_large_rounded,
        color: _limitColor,
        slides: [
          StorySlide(
            title: _s.limitPerMonthTitle(kEarningsLimitMrp),
            body: _s.limitBody(kEarningsLimitMrp),
            visual: (context, data) => _MrpEquation(limit: data.limit),
          ),
          StorySlide(
            title: _s.mrpWhatTitle,
            body: _s.mrpWhatBody,
            visual: (context, data) => YearBars(rates: kMrpHistory),
          ),
          StorySlide(
            title: _s.yourMonthTitle,
            body: _s.yourMonthBody,
            visual: (context, data) => LimitMeter(limit: data.limit),
            action: StoryAction.wallet,
            actionLabel: _s.seeInPayouts,
          ),
        ],
      ),
      Story(
        id: 'documents.1',
        title: _s.documentsTitle,
        icon: Icons.badge_rounded,
        color: _docs,
        slides: [
          StorySlide(
            title: _s.docsWhichTitle,
            body: _s.docsWhichBody,
            visual: (context, data) => const StepList(
              color: _docs,
              connected: false,
              items: [
                StepItem(Icons.badge_rounded, _s.docIdCard,
                    caption: _s.docIdCardCaption, tag: _s.docForEveryone),
                StepItem(Icons.medical_information_rounded,
                    _s.docMedBook,
                    caption: _s.docMedBookCaption, tag: _s.docPerShift),
              ],
            ),
          ),
          StorySlide(
            title: _s.docsCheckTitle,
            body: _s.docsCheckBody,
            visual: (context, data) => const StatusChain(
              color: _docs,
              steps: [
                StepItem(Icons.upload_file_rounded, _s.docUploaded),
                StepItem(Icons.hourglass_top_rounded, _s.docInReview),
                StepItem(Icons.verified_rounded, _s.docAccepted),
              ],
            ),
          ),
          StorySlide(
            title: _s.docsWhyTitle,
            body: _s.docsWhyBody,
            visual: (context, data) => const CheckList(
              color: _docs,
              items: [
                _s.docsWhyBadge,
                _s.docsWhyEmployerSees,
                _s.docsWhyPrivate,
              ],
            ),
            action: StoryAction.documents,
            actionLabel: _s.uploadDocuments,
          ),
        ],
      ),
      Story(
        id: 'medbook.1',
        title: _s.medbookTitle,
        icon: Icons.local_hospital_rounded,
        color: _med,
        slides: [
          StorySlide(
            title: _s.medWhoTitle,
            body: _s.medWhoBody,
            visual: (context, data) => const CategoryCloud(
              categoryIds: [
                'cook',
                'cook_helper',
                'waiter',
                'barista',
                'bartender',
                'baker',
                'dishwasher',
                'cashier',
                'seller',
                'packer',
                'nanny',
              ],
            ),
          ),
          StorySlide(
            title: _s.medHowTitle,
            body: _s.medHowBody,
            visual: (context, data) => const StepList(
              color: _med,
              items: [
                StepItem(Icons.event_available_rounded,
                    _s.medStepBook),
                StepItem(Icons.biotech_rounded, _s.medStepTests,
                    caption: _s.medStepTestsCaption),
                StepItem(Icons.menu_book_rounded, _s.medStepGet,
                    caption: _s.medStepGetCaption),
                StepItem(Icons.upload_file_rounded, _s.medStepUpload,
                    caption: _s.medStepUploadCaption),
              ],
            ),
          ),
          StorySlide(
            title: _s.medExpiryTitle,
            body: _s.medExpiryBody,
            visual: (context, data) => const CalendarTile(
              month: tr.core.monthsNominative[2],
              day: '12',
              caption: _s.medCalendarCaption,
              color: _med,
            ),
            action: StoryAction.documents,
            actionLabel: _s.uploadMedBook,
          ),
        ],
      ),
      Story(
        id: 'rules.1',
        title: _s.rulesTitle,
        icon: Icons.gavel_rounded,
        color: _rules,
        slides: [
          StorySlide(
            title: _s.deadlinesTitle,
            body: _s.deadlinesBody,
            visual: (context, data) => StepList(
              color: _rules,
              items: [
                const StepItem(Icons.how_to_reg_rounded, _s.ruleBooked,
                    caption: _s.ruleBookedCaption),
                StepItem(Icons.event_busy_rounded, _s.ruleCancel,
                    caption: _s.ruleCancelCaption(
                        _example.cancelDeadlineHours)),
                const StepItem(Icons.location_on_rounded, _s.ruleHourBefore,
                    caption: _s.ruleHourBeforeCaption),
                const StepItem(Icons.play_arrow_rounded, _s.ruleStart,
                    caption: _s.ruleStartCaption),
              ],
            ),
          ),
          StorySlide(
            title: _s.noShowTitle,
            body: _s.noShowBody,
            visual: (context, data) => const _ReliabilityExample(),
          ),
          StorySlide(
            title: _s.dosAndDontsTitle,
            body: _s.workerRulesBody,
            visual: (context, data) => const DoDont(
              color: _rules,
              dos: [
                _s.doCancelInTime,
                _s.doDispute,
                _s.doRatePlace,
              ],
              donts: [
                _s.dontPayForSpot,
                _s.dontShareCode,
                _s.dontSkip,
              ],
            ),
            action: StoryAction.terms,
            actionLabel: _s.fullRules,
          ),
        ],
      ),
      Story(
        id: 'rating.1',
        title: _s.ratingTitle,
        icon: Icons.star_rounded,
        color: _stars,
        slides: [
          StorySlide(
            title: _s.ratingAfterShiftTitle,
            body: _s.ratingAfterShiftBody,
            visual: (context, data) {
              final user = data.user;
              return StarsRating(
                rating: user?.rating ?? 4.8,
                caption: user == null
                    ? _s.ratingSample
                    : user.hasRatedShifts
                        ? _s.ratingYours(user.ratingCount)
                        : _s.ratingStarting,
              );
            },
          ),
          StorySlide(
            title: _s.ratingUnlocksTitle,
            body: _s.ratingUnlocksBody,
            visual: (context, data) => ThresholdScale(
              threshold: 4.5,
              userRating: data.user?.rating,
              color: _stars,
            ),
          ),
          StorySlide(
            title: _s.levelsTitle,
            body: _s.levelsBody,
            visual: (context, data) =>
                LevelLadder(user: data.user, color: _stars),
            action: StoryAction.reviews,
            actionLabel: _s.reviewsAboutMe,
          ),
        ],
      ),
      Story(
        id: 'support.1',
        title: _s.supportTitle,
        icon: Icons.chat_bubble_rounded,
        color: _help,
        slides: [
          StorySlide(
            title: _s.whenToWriteTitle,
            body: _s.workerSupportBody,
            visual: (context, data) => const CheckList(
              color: _help,
              items: [
                _s.supportMarkedNoShow,
                _s.supportNoMoney,
                _s.supportExtraDemands,
                _s.supportCantSignIn,
              ],
            ),
          ),
          StorySlide(
            title: _s.howToWriteTitle,
            body: _s.howToWriteBody,
            visual: (context, data) => const ChatPreview(
              color: _help,
              messages: [
                (true, _s.chatWorker),
                (false, _s.chatSupport),
                (true, _s.chatThanks),
              ],
            ),
            action: StoryAction.support,
            actionLabel: _s.contactSupport,
          ),
        ],
      ),
    ];

/// Истории заказчика — на его главном экране «Мои смены».
List<Story> managerStories() => [
      Story(
        id: 'm.how.2',
        title: _s.hireTitle,
        icon: Icons.bolt_rounded,
        color: _how,
        slides: [
          StorySlide(
            title: _s.hireStepsTitle,
            body: _s.hireStepsBody,
            visual: (context, data) => const StepList(
              color: _how,
              items: [
                StepItem(Icons.add_circle_rounded, _s.hireCreate,
                    caption: _s.hireCreateCaption),
                StepItem(Icons.credit_card_rounded, _s.hirePay,
                    caption: _s.hirePayCaption),
                StepItem(Icons.groups_rounded, _s.hirePeopleBook,
                    caption: _s.hirePeopleBookCaption),
                StepItem(Icons.fact_check_rounded, _s.hireMark,
                    caption: _s.hireMarkCaption),
                StepItem(Icons.star_rounded, _s.hireRate,
                    caption: _s.hireRateCaption),
              ],
            ),
          ),
          StorySlide(
            title: _s.whoComesTitle,
            body: _s.whoComesBody,
            visual: (context, data) => const CheckList(
              color: _how,
              items: [
                _s.whoComesRating,
                _s.whoComesReliability,
                _s.verifiedBadge,
              ],
            ),
            action: StoryAction.createShift,
            actionLabel: _s.createShift,
          ),
        ],
      ),
      Story(
        id: 'm.pay.1',
        title: _s.paymentTitle,
        icon: Icons.payments_rounded,
        color: _money,
        slides: [
          StorySlide(
            title: _s.costTitle,
            body: _s.costBody(kPlatformFeePercent),
            visual: (context, data) => SplitBar(
              header: _s.splitHeaderManager,
              parts: [
                SplitPart(_s.splitToWorker, _cost.pay, Colors.white,
                    note: _s.splitToWorkerNote),
                SplitPart(_s.serviceFee, _cost.fee,
                    Colors.white.withValues(alpha: 0.35),
                    note: _s.feeForGuarantee(kPlatformFeePercent)),
              ],
            ),
          ),
          StorySlide(
            title: _s.payForAttendedTitle,
            body: _s.payForAttendedBody,
            visual: (context, data) => const StepList(
              color: _money,
              connected: false,
              items: [
                StepItem(Icons.check_circle_rounded, _s.outcomeAttended,
                    caption: _s.outcomeAttendedCaption),
                StepItem(Icons.person_off_rounded, _s.outcomeNoShow,
                    caption: _s.outcomeNoShowCaption),
                StepItem(Icons.event_busy_rounded, _s.outcomeCancelled,
                    caption: _s.outcomeCancelledCaption),
                StepItem(Icons.edit_rounded, _s.outcomeChanged,
                    caption: _s.outcomeChangedCaption),
              ],
            ),
            action: StoryAction.wallet,
            actionLabel: _s.openPayments,
          ),
        ],
      ),
      Story(
        id: 'm.attendance.1',
        title: _s.attendanceTitle,
        icon: Icons.fact_check_rounded,
        color: _docs,
        slides: [
          StorySlide(
            title: _s.confirmAttendanceTitle,
            body: _s.confirmAttendanceBody,
            visual: (context, data) => const StatusChain(
              color: _docs,
              steps: [
                StepItem(Icons.how_to_reg_rounded, _s.attBooked),
                StepItem(Icons.location_on_rounded, _s.attCheckedIn),
                StepItem(Icons.fact_check_rounded, _s.attConfirmed),
                StepItem(Icons.payments_rounded, _s.attPaid),
              ],
            ),
          ),
          StorySlide(
            title: _s.ratePeopleTitle,
            body: _s.ratePeopleBody,
            visual: (context, data) => const ThresholdScale(
              threshold: 4.5,
              userRating: null,
              color: _docs,
            ),
            action: StoryAction.rateWorkers,
            actionLabel: _s.rateWorkers,
          ),
        ],
      ),
      Story(
        id: 'm.rules.1',
        title: _s.rulesTitle,
        icon: Icons.gavel_rounded,
        color: _rules,
        slides: [
          StorySlide(
            title: _s.dosAndDontsTitle,
            body: _s.managerRulesBody,
            visual: (context, data) => const DoDont(
              color: _rules,
              dos: [
                _s.doEditShift,
                _s.doCancelShift,
                _s.doMarkNoShow,
              ],
              donts: [
                _s.dontPayOutside,
                _s.dontOvertime,
                _s.dontFalseNoShow,
              ],
            ),
            action: StoryAction.terms,
            actionLabel: _s.fullRules,
          ),
        ],
      ),
      Story(
        id: 'm.support.1',
        title: _s.supportTitle,
        icon: Icons.chat_bubble_rounded,
        color: _help,
        slides: [
          StorySlide(
            title: _s.whenToWriteTitle,
            body: _s.managerSupportBody,
            visual: (context, data) => const CheckList(
              color: _help,
              items: [
                _s.supportWorkerNoShow,
                _s.supportPaymentFailed,
                _s.supportEditPaid,
                _s.supportAttendanceDispute,
              ],
            ),
            action: StoryAction.support,
            actionLabel: _s.contactSupport,
          ),
        ],
      ),
    ];

/// «300 МРП × 4 325 ₸ = 1 297 500 ₸».
///
/// Если лимит пришёл с сервера — считаем по его МРП: там может быть
/// значение новее, чем знает эта сборка приложения. Не пришёл — по
/// известным значениям.
class _MrpEquation extends StatelessWidget {
  final Future<EarningsLimit?>? limit;

  const _MrpEquation({required this.limit});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EarningsLimit?>(
      future: limit,
      builder: (context, snapshot) {
        final year = DateTime.now().year;
        final mrp = snapshot.data?.mrp ?? mrpOn(DateTime(year), kMrpHistory);
        return EquationStack(
          color: _limitColor,
          operators: const ['×', '='],
          terms: [
            EquationTerm(_s.equationMrp(kEarningsLimitMrp),
                _s.equationMrpCaption),
            EquationTerm(formatMoney(mrp), _s.equationMrpOn(year)),
            EquationTerm(
              formatMoney(mrp * kEarningsLimitMrp),
              _s.equationLimitCaption,
            ),
          ],
        );
      },
    );
  }
}

/// Надёжность на примере: из десяти смен вышли на девять.
class _ReliabilityExample extends StatelessWidget {
  const _ReliabilityExample();

  @override
  Widget build(BuildContext context) {
    return StoryPanel(
      child: Row(
        children: [
          const RingGauge(fraction: 0.9, value: '90%', caption: _s.reliabilityCaption),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  _s.reliabilityExample,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  _s.reliabilityExampleText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (var i = 0; i < 10; i++)
                      Expanded(
                        child: Container(
                          height: 18,
                          margin: const EdgeInsets.only(right: 3),
                          decoration: BoxDecoration(
                            color: i == 6
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
