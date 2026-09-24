import 'package:flutter/material.dart';

import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/mrp.dart';
import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/shift.dart';
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
final _example = Shift(
  id: 0,
  workDate: DateTime(2026),
  title: 'Сборка заказов на складе',
  category: 'picker',
  company: 'Склад «Восток»',
  address: 'ул. Садовая, 12',
  startMinutes: 9 * 60,
  endMinutes: 20 * 60,
  hourlyRate: 121000,
  workersNeeded: 5,
  workersHired: 1,
);

final _cost = ShiftCost(slotPay: _example.totalPay, slots: 1);

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
        title: 'Как это работает',
        icon: Icons.bolt_rounded,
        color: _how,
        slides: [
          StorySlide(
            title: 'Подработка на один день',
            body: 'Компании выкладывают смены: день, время, адрес и сумму. '
                'Выбираете удобную и записываетесь — без собеседований.',
            visual: (context, data) =>
                MiniShiftCard(shift: _example, color: _how),
          ),
          StorySlide(
            title: 'Четыре шага до денег',
            body: 'Всё в приложении — от записи до вывода на карту.',
            visual: (context, data) => const StepList(
              color: _how,
              items: [
                StepItem(Icons.search_rounded, 'Найдите смену',
                    caption: 'По дате, категории и компании'),
                StepItem(Icons.how_to_reg_rounded, 'Запишитесь',
                    caption: 'Место закрепится за вами'),
                StepItem(Icons.location_on_rounded, 'Отметьтесь на месте',
                    caption: 'В день смены, за час до начала'),
                StepItem(Icons.payments_rounded, 'Получите деньги',
                    caption: 'Когда заказчик подтвердит выход'),
              ],
            ),
          ),
          StorySlide(
            title: 'Оплата гарантирована',
            body: 'Заказчик платит сервису заранее — ещё при публикации '
                'смены. Деньги ждут у нас, пока вы работаете.',
            visual: (context, data) => MoneyFlow(
              color: _how,
              nodes: [
                MoneyNode(Icons.business_rounded, 'Заказчик',
                    amount: formatMoney(_cost.total)),
                const MoneyNode(Icons.shield_rounded, 'fastwork',
                    amount: 'держит', highlight: true),
                MoneyNode(Icons.person_rounded, 'Вы',
                    amount: formatMoney(_cost.pay)),
              ],
              links: const ['платит заранее', 'после смены'],
            ),
          ),
          StorySlide(
            title: 'Начните с документов',
            body: 'Загрузите удостоверение личности: заказчик увидит, что '
                'к нему придёт проверенный человек.',
            visual: (context, data) => const StatusChain(
              color: _how,
              steps: [
                StepItem(Icons.upload_file_rounded, 'Загрузили'),
                StepItem(Icons.hourglass_top_rounded, 'Проверяем'),
                StepItem(Icons.verified_rounded, 'Проверен'),
              ],
            ),
            action: StoryAction.documents,
            actionLabel: 'Загрузить документы',
          ),
        ],
      ),
      Story(
        id: 'payouts.1',
        title: 'Выплаты',
        icon: Icons.payments_rounded,
        color: _money,
        slides: [
          StorySlide(
            title: 'Путь денег',
            body: 'Заказчик платит заранее, а сервис держит деньги до конца '
                'смены. Поэтому на карточке и написано «Оплата '
                'гарантирована».',
            visual: (context, data) => const StepList(
              color: _money,
              items: [
                StepItem(Icons.credit_card_rounded, 'Заказчик оплатил смену',
                    caption: 'Картой, при публикации'),
                StepItem(Icons.shield_rounded, 'Сервис держит деньги',
                    caption: 'До конца смены'),
                StepItem(Icons.fact_check_rounded, 'Вы отработали',
                    caption: 'Заказчик подтверждает выход'),
                StepItem(Icons.account_balance_wallet_rounded,
                    'Деньги на вашем балансе',
                    caption: 'Можно выводить на карту'),
              ],
            ),
          ),
          StorySlide(
            title: 'Вы получаете всю сумму',
            body: 'Комиссию сервиса — $kPlatformFeePercent% — платит '
                'заказчик сверху. Сколько написано в смене, столько и '
                'придёт.',
            visual: (context, data) => SplitBar(
              header: 'Заказчик платит за одно место',
              parts: [
                SplitPart('Вам', _cost.pay, Colors.white,
                    note: 'ровно как в смене'),
                SplitPart('Комиссия сервиса', _cost.fee,
                    Colors.white.withValues(alpha: 0.35),
                    note: '$kPlatformFeePercent%, платит заказчик'),
              ],
            ),
          ),
          StorySlide(
            title: 'Когда приходят деньги',
            body: 'Как только заказчик подтвердит, что вы вышли, сумма '
                'появится в «Выплатах». Срок указан в каждой смене — '
                'например, «Выплата завтра».',
            visual: (context, data) => const StatusChain(
              color: _money,
              steps: [
                StepItem(Icons.work_rounded, 'Смена',
                    caption: 'вы отработали'),
                StepItem(Icons.fact_check_rounded, 'Подтверждение',
                    caption: 'заказчик отметил'),
                StepItem(Icons.account_balance_wallet_rounded, 'Баланс',
                    caption: 'можно выводить'),
              ],
            ),
          ),
          StorySlide(
            title: 'Вывод на карту',
            body: 'Выводите весь баланс, от ${formatMoney(kMinWithdrawal)}. '
                'Комиссии за вывод нет. Номер карты к нам не попадает — '
                'храним только последние четыре цифры.',
            visual: (context, data) =>
                const CardMock(caption: 'Комиссия за вывод — 0 ₸'),
            action: StoryAction.wallet,
            actionLabel: 'Открыть выплаты',
          ),
        ],
      ),
      Story(
        id: 'limit.1',
        title: 'Лимит',
        icon: Icons.donut_large_rounded,
        color: _limitColor,
        slides: [
          StorySlide(
            title: '$kEarningsLimitMrp МРП в месяц',
            body: 'Вы работаете в режиме платформенной занятости. Доход в '
                'нём — не больше $kEarningsLimitMrp МРП в месяц, по МРП на '
                '1 января.',
            visual: (context, data) => _MrpEquation(limit: data.limit),
          ),
          StorySlide(
            title: 'Что такое МРП',
            body: 'Месячный расчётный показатель — «линейка», которой '
                'государство меряет пособия, штрафы и лимиты. Его задают '
                'каждый год в законе о бюджете.',
            visual: (context, data) => YearBars(rates: kMrpHistory),
          ),
          StorySlide(
            title: 'Ваш месяц',
            body: 'Считаем и отработанное, и смены, на которые вы '
                'записаны: запись — обещание выйти. Если смена не '
                'помещается в лимит, записаться не получится.',
            visual: (context, data) => LimitMeter(limit: data.limit),
            action: StoryAction.wallet,
            actionLabel: 'Смотреть в «Выплатах»',
          ),
        ],
      ),
      Story(
        id: 'documents.1',
        title: 'Документы',
        icon: Icons.badge_rounded,
        color: _docs,
        slides: [
          StorySlide(
            title: 'Какие документы нужны',
            body: 'Удостоверение личности — всем. Санитарная книжка — тем, '
                'кто работает с продуктами и в общепите.',
            visual: (context, data) => const StepList(
              color: _docs,
              connected: false,
              items: [
                StepItem(Icons.badge_rounded, 'Удостоверение личности',
                    caption: 'Номер документа', tag: 'всем'),
                StepItem(Icons.medical_information_rounded,
                    'Санитарная книжка',
                    caption: 'Если работа с едой', tag: 'по смене'),
              ],
            ),
          ),
          StorySlide(
            title: 'Как проходит проверка',
            body: 'Загружаете документ — он уходит на проверку. Когда '
                'удостоверение примут, в профиле появится отметка '
                '«Верифицирован».',
            visual: (context, data) => const StatusChain(
              color: _docs,
              steps: [
                StepItem(Icons.upload_file_rounded, 'Загружен'),
                StepItem(Icons.hourglass_top_rounded, 'На проверке'),
                StepItem(Icons.verified_rounded, 'Принят'),
              ],
            ),
          ),
          StorySlide(
            title: 'Зачем это вам',
            body: 'Заказчик видит отметку рядом с вашим именем и знает, что '
                'к нему придёт проверенный человек.',
            visual: (context, data) => const CheckList(
              color: _docs,
              items: [
                'Отметка «Верифицирован» в профиле',
                'Заказчик видит её в списке записавшихся',
                'Сами документы видит только сервис',
              ],
            ),
            action: StoryAction.documents,
            actionLabel: 'Загрузить документы',
          ),
        ],
      ),
      Story(
        id: 'medbook.1',
        title: 'Медкнижка',
        icon: Icons.local_hospital_rounded,
        color: _med,
        slides: [
          StorySlide(
            title: 'Кому нужна медкнижка',
            body: 'Всем, кто работает с едой и напитками, и часто — тем, кто '
                'продаёт продукты или работает с детьми. Если она нужна, '
                'заказчик напишет об этом в смене.',
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
            title: 'Как её оформить',
            body: 'Медкнижку оформляют после медосмотра — в поликлинике или '
                'частном медцентре. Возьмите с собой удостоверение личности.',
            visual: (context, data) => const StepList(
              color: _med,
              items: [
                StepItem(Icons.event_available_rounded,
                    'Запишитесь на медосмотр'),
                StepItem(Icons.biotech_rounded, 'Сдайте анализы',
                    caption: 'и пройдите врачей'),
                StepItem(Icons.menu_book_rounded, 'Получите книжку',
                    caption: 'с отметками врачей'),
                StepItem(Icons.upload_file_rounded, 'Загрузите её номер',
                    caption: 'Профиль → Документы'),
              ],
            ),
          ),
          StorySlide(
            title: 'Следите за сроком',
            body: 'Медосмотр проходят регулярно — дата следующего стоит в '
                'самой книжке. С просроченной книжкой заказчик не допустит '
                'к смене.',
            visual: (context, data) => const CalendarTile(
              month: 'март',
              day: '12',
              caption: 'Пример: дата следующего осмотра',
              color: _med,
            ),
            action: StoryAction.documents,
            actionLabel: 'Загрузить медкнижку',
          ),
        ],
      ),
      Story(
        id: 'rules.1',
        title: 'Правила',
        icon: Icons.gavel_rounded,
        color: _rules,
        slides: [
          StorySlide(
            title: 'Сроки, которые важно знать',
            body: 'Запись — обещание выйти. Отменить её можно до срока, '
                'который указан в смене.',
            visual: (context, data) => StepList(
              color: _rules,
              items: [
                const StepItem(Icons.how_to_reg_rounded, 'Записались',
                    caption: 'Место за вами'),
                StepItem(Icons.event_busy_rounded, 'Отмена — до срока',
                    caption: 'Например, за ${_example.cancelDeadlineHours} '
                        'часов до начала'),
                const StepItem(Icons.location_on_rounded, 'За час до начала',
                    caption: 'Можно отметиться на месте'),
                const StepItem(Icons.play_arrow_rounded, 'Начало смены',
                    caption: 'Работаете по описанию смены'),
              ],
            ),
          ),
          StorySlide(
            title: 'Невыход видят заказчики',
            body: 'Записались и не пришли — заказчик отметит невыход. Это '
                'снижает надёжность: долю смен, на которые вы вышли. Её '
                'видят заказчики.',
            visual: (context, data) => const _ReliabilityExample(),
          ),
          StorySlide(
            title: 'Можно и нельзя',
            body: 'Сервис — гарант оплаты. Никто не вправе просить у вас '
                'денег за смену или код входа.',
            visual: (context, data) => const DoDont(
              color: _rules,
              dos: [
                'Отменить запись до срока',
                'Оспорить отметку через поддержку',
                'Оценить место работы',
              ],
              donts: [
                'Платить кому-то за место на смене',
                'Сообщать код входа — даже «поддержке»',
                'Не прийти, не отменив запись',
              ],
            ),
            action: StoryAction.terms,
            actionLabel: 'Правила полностью',
          ),
        ],
      ),
      Story(
        id: 'rating.1',
        title: 'Рейтинг',
        icon: Icons.star_rounded,
        color: _stars,
        slides: [
          StorySlide(
            title: 'Оценка после каждой смены',
            body: 'Заказчик ставит от 1 до 5 звёзд, рейтинг — среднее всех '
                'оценок. Пока оценок нет, у вас стартовый рейтинг.',
            visual: (context, data) {
              final user = data.user;
              return StarsRating(
                rating: user?.rating ?? 4.8,
                caption: user == null
                    ? 'пример рейтинга'
                    : user.hasRatedShifts
                        ? 'ваш рейтинг · оценок: ${user.ratingCount}'
                        : 'ваш стартовый рейтинг',
              );
            },
          ),
          StorySlide(
            title: 'Рейтинг открывает смены',
            body: 'Некоторые заказчики берут только тех, у кого рейтинг не '
                'ниже порога. Такие смены в ленте помечены замком.',
            visual: (context, data) => ThresholdScale(
              threshold: 4.5,
              userRating: data.user?.rating,
              color: _stars,
            ),
          ),
          StorySlide(
            title: 'Уровни',
            body: 'Уровень растёт с числом отработанных смен и виден в '
                'профиле.',
            visual: (context, data) =>
                LevelLadder(user: data.user, color: _stars),
            action: StoryAction.reviews,
            actionLabel: 'Отзывы обо мне',
          ),
        ],
      ),
      Story(
        id: 'support.1',
        title: 'Поддержка',
        icon: Icons.chat_bubble_rounded,
        color: _help,
        slides: [
          StorySlide(
            title: 'Когда писать нам',
            body: 'Разберёмся в споре с заказчиком, проверим оплату и '
                'поможем со входом.',
            visual: (context, data) => const CheckList(
              color: _help,
              items: [
                'Отметили невыход, а вы работали',
                'Деньги не пришли после подтверждения',
                'Просят то, чего нет в описании смены',
                'Не получается войти или записаться',
              ],
            ),
          ),
          StorySlide(
            title: 'Как написать',
            body: 'Профиль → Поддержка → новое обращение. Опишите, что '
                'случилось, и назовите смену — так ответим быстрее.',
            visual: (context, data) => const ChatPreview(
              color: _help,
              messages: [
                (true, 'Здравствуйте! Вчера была смена на складе, а мне '
                    'отметили невыход'),
                (false, 'Здравствуйте! Проверим отметку у заказчика и '
                    'вернёмся с ответом.'),
                (true, 'Спасибо!'),
              ],
            ),
            action: StoryAction.support,
            actionLabel: 'Написать в поддержку',
          ),
        ],
      ),
    ];

/// Истории заказчика — на его главном экране «Мои смены».
List<Story> managerStories() => [
      Story(
        id: 'm.how.1',
        title: 'Как нанять',
        icon: Icons.bolt_rounded,
        color: _how,
        slides: [
          StorySlide(
            title: 'Пять шагов',
            body: 'От публикации до оценки — всё в приложении, без звонков '
                'и таблиц.',
            visual: (context, data) => const StepList(
              color: _how,
              items: [
                StepItem(Icons.add_circle_rounded, 'Создайте смену',
                    caption: 'Категория, время, ставка, число мест'),
                StepItem(Icons.credit_card_rounded, 'Оплатите картой',
                    caption: 'Деньги держит сервис'),
                StepItem(Icons.groups_rounded, 'Люди записываются',
                    caption: 'Видно рейтинг каждого'),
                StepItem(Icons.fact_check_rounded, 'Отметьте, кто вышел',
                    caption: 'Деньги уйдут исполнителю'),
                StepItem(Icons.star_rounded, 'Оцените работу',
                    caption: 'Так растёт рейтинг лучших'),
              ],
            ),
          ),
          StorySlide(
            title: 'Кто к вам придёт',
            body: 'В списке записавшихся видно, как человек работал раньше, '
                'и проверены ли его документы.',
            visual: (context, data) => const CheckList(
              color: _how,
              items: [
                'Рейтинг по оценкам других заказчиков',
                'Какую долю смен человек не пропустил',
                'Отметка «Верифицирован»',
              ],
            ),
            action: StoryAction.createShift,
            actionLabel: 'Создать смену',
          ),
        ],
      ),
      Story(
        id: 'm.pay.1',
        title: 'Оплата',
        icon: Icons.payments_rounded,
        color: _money,
        slides: [
          StorySlide(
            title: 'Сколько стоит смена',
            body: 'Вы платите вознаграждение и $kPlatformFeePercent% '
                'комиссии сверху. Исполнитель получает ровно ту сумму, что '
                'указана в смене.',
            visual: (context, data) => SplitBar(
              header: 'За одно место',
              parts: [
                SplitPart('Исполнителю', _cost.pay, Colors.white,
                    note: 'вознаграждение из смены'),
                SplitPart('Комиссия сервиса', _cost.fee,
                    Colors.white.withValues(alpha: 0.35),
                    note: '$kPlatformFeePercent% за гарантию и подбор'),
              ],
            ),
          ),
          StorySlide(
            title: 'Платите за тех, кто вышел',
            body: 'Деньги ждут у сервиса до конца смены. Не вышел человек '
                'или смену отменили — вернём то, что не пригодилось.',
            visual: (context, data) => const StepList(
              color: _money,
              connected: false,
              items: [
                StepItem(Icons.check_circle_rounded, 'Вышел',
                    caption: 'Деньги уходят исполнителю'),
                StepItem(Icons.person_off_rounded, 'Не вышел',
                    caption: 'Вернём деньги за это место'),
                StepItem(Icons.event_busy_rounded, 'Смену отменили',
                    caption: 'Вернём остаток'),
                StepItem(Icons.edit_rounded, 'Смену изменили',
                    caption: 'Доплата или возврат разницы'),
              ],
            ),
            action: StoryAction.wallet,
            actionLabel: 'Открыть платежи',
          ),
        ],
      ),
      Story(
        id: 'm.attendance.1',
        title: 'Отметки',
        icon: Icons.fact_check_rounded,
        color: _docs,
        slides: [
          StorySlide(
            title: 'Подтвердите выход',
            body: 'После смены откройте её и отметьте каждого: вышел или '
                'нет. Пока отметки нет, деньги ждут у сервиса.',
            visual: (context, data) => const StatusChain(
              color: _docs,
              steps: [
                StepItem(Icons.how_to_reg_rounded, 'Записался'),
                StepItem(Icons.location_on_rounded, 'Отметился на месте'),
                StepItem(Icons.fact_check_rounded, 'Вы подтвердили'),
                StepItem(Icons.payments_rounded, 'Деньги ушли'),
              ],
            ),
          ),
          StorySlide(
            title: 'Оцените людей',
            body: 'Ваша оценка — часть рейтинга исполнителя. Поставьте в '
                'смене порог, и записаться смогут только те, кто до него '
                'дорос.',
            visual: (context, data) => const ThresholdScale(
              threshold: 4.5,
              userRating: null,
              color: _docs,
            ),
            action: StoryAction.rateWorkers,
            actionLabel: 'Оценить исполнителей',
          ),
        ],
      ),
      Story(
        id: 'm.rules.1',
        title: 'Правила',
        icon: Icons.gavel_rounded,
        color: _rules,
        slides: [
          StorySlide(
            title: 'Можно и нельзя',
            body: 'Сервис — гарант для обеих сторон: деньги за смену '
                'проходят только через него.',
            visual: (context, data) => const DoDont(
              color: _rules,
              dos: [
                'Изменить смену — цена пересчитается',
                'Отменить смену — вернём остаток',
                'Отметить невыход, если человек не пришёл',
              ],
              donts: [
                'Договариваться об оплате мимо сервиса',
                'Просить работать сверх смены',
                'Отмечать невыход тому, кто работал',
              ],
            ),
            action: StoryAction.terms,
            actionLabel: 'Правила полностью',
          ),
        ],
      ),
      Story(
        id: 'm.support.1',
        title: 'Поддержка',
        icon: Icons.chat_bubble_rounded,
        color: _help,
        slides: [
          StorySlide(
            title: 'Когда писать нам',
            body: 'Поможем с оплатой, возвратами и спорами с исполнителями.',
            visual: (context, data) => const CheckList(
              color: _help,
              items: [
                'Исполнитель не пришёл и не отменил запись',
                'Оплата не прошла или не вернулись деньги',
                'Нужно изменить уже оплаченную смену',
                'Спор об отметке выхода',
              ],
            ),
            action: StoryAction.support,
            actionLabel: 'Написать в поддержку',
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
            EquationTerm('$kEarningsLimitMrp МРП', 'в месяц можно заработать'),
            EquationTerm(formatMoney(mrp), '1 МРП на 1 января $year'),
            EquationTerm(
              formatMoney(mrp * kEarningsLimitMrp),
              'ваш лимит в месяц',
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
          const RingGauge(fraction: 0.9, value: '90%', caption: 'выходов'),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Пример',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Из 10 смен вышли на 9',
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
