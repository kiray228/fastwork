# fastwork — модель данных (версия 2, по модели EasyTap)

> Версия 1 описывала симметричный маркетплейс «человек ↔ человек».
> После разбора прототипа (см. `docs/04-analiz-easytap.md`) модель изменена
> на **B2B2C**: заказчик — компания, исполнитель — верифицированное физлицо,
> платформа — модерация и расчёты.

---

## 1. Роли участников

| Роль | Кто это | Особенность |
|---|---|---|
| `worker` | Исполнитель, физлицо | Проходит верификацию, откликается на смены |
| `manager` | Сотрудник компании-заказчика | Привязан к компании, создаёт смены |
| `operator` | Сотрудник платформы | Модерация смен, проверка документов, споры |

---

## 2. Таблицы

### cities — города
id PK, name TEXT UNIQUE, is_active INTEGER

> Лента смен фильтруется по городу пользователя. Справочник, меняется редко.

### companies — компании-заказчики
| Колонка | Тип | Заметки |
|---|---|---|
| id | INTEGER PK | |
| name | TEXT | «Magnum», «KFC» |
| bin | TEXT UNIQUE | БИН юрлица |
| logo_path | TEXT NULL | логотип на карточке смены |
| description | TEXT NULL | «Транспортная логистическая компания» |
| contract_status | TEXT | `pending` / `active` / `suspended` |
| created_at | INTEGER | |

> Договор подписывается вне приложения. В базе хранится только его
> **статус**: без `active` компания не может публиковать смены.

### locations — точки компании
| Колонка | Тип |
|---|---|
| id | INTEGER PK |
| company_id | INTEGER FK → companies.id |
| city_id | INTEGER FK → cities.id |
| title | TEXT |
| address | TEXT |
| lat, lon | REAL |
| rating | REAL NULL | кэш среднего по location_reviews |

> Связь 1:М — у сети много точек. Смена привязана к **точке**, а не к
> компании: работать человек выходит по конкретному адресу.

### users — пользователи
| Колонка | Тип | Заметки |
|---|---|---|
| id | INTEGER PK | |
| phone | TEXT UNIQUE | логин |
| password_hash | TEXT | |
| full_name | TEXT | |
| avatar_path | TEXT NULL | |
| role | TEXT | `worker` / `manager` / `operator` |
| company_id | INTEGER FK → companies.id **NULL** | заполнен только у `manager` |
| city_id | INTEGER FK → cities.id | город — по нему фильтруется лента |
| rating | REAL | кэш среднего из reviews, **стартовое значение 4.0** |
| is_verified | INTEGER | 0/1 — прошёл ли проверку документов |
| created_at | INTEGER | |

> **Почему `company_id` может быть NULL?**
> NULL означает «значения нет и не должно быть»: у исполнителя компании нет.
> Это не то же самое, что `0` или пустая строка — те были бы *значениями*.
> NULL прямо говорит: поле неприменимо.

### documents — документы исполнителя
| Колонка | Тип | Заметки |
|---|---|---|
| id | INTEGER PK | |
| user_id | INTEGER FK → users.id | |
| type | TEXT | `id_card` / `medical_book` |
| number | TEXT | |
| expires_at | INTEGER NULL | санкнижка имеет срок |
| status | TEXT | `pending` / `approved` / `rejected` |
| reviewed_by | INTEGER FK → **users.id** NULL | какой оператор проверил |
| reviewed_at | INTEGER NULL | |

> `reviewed_by` — **ссылка таблицы на саму себя** (users → users).
> Обычная практика: «кто создал», «кто проверил», «кто пригласил».

### categories — категории смен
id PK, name TEXT UNIQUE, icon_code INTEGER

### shifts — смены (бывшие «заказы»)
| Колонка | Тип | Заметки |
|---|---|---|
| id | INTEGER PK | |
| location_id | INTEGER FK → locations.id | |
| category_id | INTEGER FK → categories.id | |
| created_by | INTEGER FK → users.id | менеджер-автор |
| title | TEXT | |
| description | TEXT | обязанности |
| work_date | INTEGER | дата смены — по ней ищут |
| start_minutes | INTEGER | минут от полуночи |
| end_minutes | INTEGER | |
| break_minutes | INTEGER | неоплачиваемый перерыв; **правило**: 60 при длительности > 5 ч, иначе 0 |
| hourly_rate | INTEGER | ставка в тиынах за час |
| workers_needed | INTEGER | сколько человек нужно |
| min_rating | REAL NULL | порог допуска, NULL = без ограничений |
| cancel_deadline_hours | INTEGER | по умолчанию 10 |
| duties | TEXT | список обязанностей |
| dress_code | TEXT NULL | требования к одежде |
| employer_comment | TEXT NULL | свободный текст заказчика |
| payout_delay_days | INTEGER | через сколько дней вознаграждение |
| attendance_method | TEXT | `faceid` / `qr` / `manual` |
| auto_close_at | INTEGER NULL | когда смена закроется автоматически |
| status | TEXT | `draft`/`moderation`/`published`/`in_progress`/`done`/`cancelled` |
| created_at | INTEGER | |

> **Почему ставка за час, а не сумма за смену?**
> Сумма выводится из ставки, длительности и перерыва:
>
> ```
> длительность = end > start ? end − start : (1440 − start) + end
> сумма = ((длительность − break_minutes) / 60) × hourly_rate
> ```
>
> Ветвление обязательно: смена 18:00–06:00 заканчивается на следующий день,
> и простое вычитание даёт отрицательное число. Перерыв и ночные смены
> обнаружены по арифметике карточек прототипа — см.
> `docs/05-razbor-ekranov.md`, разделы 4 и 19.
> Хранить оба поля — значит хранить один факт дважды: при правке времени
> сумма разъедется со ставкой. Вычисляемое значение не хранят.
>
> **Исключение — момент оплаты.** Когда деньги реально начислены, сумма
> записывается в `transactions` как есть. Это не дублирование, а **снимок**:
> ставка завтра может измениться, но выплаченное вчера меняться не должно.
> Правило: текущее состояние вычисляем, свершившийся факт фиксируем.

### shift_required_documents — какие документы нужны на смену
| Колонка | Тип |
|---|---|
| shift_id | INTEGER FK → shifts.id |
| doc_type | TEXT |
| PRIMARY KEY (shift_id, doc_type) | |

> Ещё одна связка многие-ко-многим. Первичный ключ здесь **составной** —
> из двух колонок сразу: он же запрещает продублировать требование.

### applications — отклики
| Колонка | Тип | Заметки |
|---|---|---|
| id | INTEGER PK | |
| shift_id | INTEGER FK → shifts.id | |
| worker_id | INTEGER FK → users.id | |
| status | TEXT | см. ниже |
| created_at | INTEGER | |
| cancelled_at | INTEGER NULL | |
| UNIQUE(shift_id, worker_id) | | нельзя откликнуться дважды |

Статусы: `pending` → `accepted` / `rejected`, далее `cancelled_by_worker`,
`no_show` (не вышел) или `completed`.

> **Сколько мест осталось?** Считается запросом по **активным** откликам:
> `SELECT COUNT(*) FROM applications WHERE shift_id = ? AND status IN ('accepted','in_progress')`.
> Отменённые отклики места не занимают — прототип прямо обещает, что
> «место может освободиться».
> Отдельная колонка-счётчик `workers_hired` рано или поздно разойдётся с
> реальностью — это опять хранение вычисляемого.
>
> **Гонка за последнее место.** Двое откликаются одновременно на последнее
> место: оба прочитали «свободно 1», оба записались — принято на одного
> больше, чем нужно. Лечится транзакцией: проверка и вставка выполняются
> как одна неделимая операция.

### wallets — кошельки
id PK, user_id FK UNIQUE, balance_available INTEGER, balance_held INTEGER

### transactions — журнал операций
| Колонка | Тип | Заметки |
|---|---|---|
| id | INTEGER PK | |
| wallet_id | INTEGER FK → wallets.id | |
| shift_id | INTEGER FK → shifts.id NULL | по какой смене |
| type | TEXT | `hold`/`release`/`refund`/`fee`/`bonus`/`payout` |
| amount | INTEGER | со знаком |
| balance_after | INTEGER | |
| created_at | INTEGER | |

### payouts — выводы на карту
| Колонка | Тип | Заметки |
|---|---|---|
| id | INTEGER PK | |
| user_id | INTEGER FK → users.id | |
| amount | INTEGER | |
| card_mask | TEXT | `**** 4321` — **полный номер не хранится** |
| status | TEXT | `requested`/`processing`/`paid`/`failed` |
| external_ref | TEXT NULL | идентификатор в платёжной системе |
| created_at, processed_at | INTEGER | |

> Начисление и вывод — **разные вещи**. Начисление мгновенно и внутри
> системы; вывод уходит во внешний банк, занимает время и может не пройти.
> Поэтому у вывода своя таблица со своим статусом.

### worker_reviews — отзывы о исполнителе
id PK, shift_id FK, author_id FK → users (менеджер), worker_id FK → users,
rating INTEGER (1..5), comment TEXT NULL, created_at,
UNIQUE(shift_id, worker_id)

> Из них считается `users.rating`, а он работает как **допуск**:
> смена с `min_rating = 4.5` не покажется исполнителю с рейтингом ниже.

### location_reviews — отзывы о филиале
id PK, location_id FK, shift_id FK, author_id FK → users (исполнитель),
rating INTEGER (1..5), comment TEXT NULL, created_at,
UNIQUE(shift_id, author_id)

> Прототип показывает «Отзывы о филиале» — оценивают **точку**, а не
> компанию и не человека. Из них считается `locations.rating`.
>
> **Почему две таблицы, а не одна с `target_type` + `target_id`?**
> Полиморфная ссылка не может быть внешним ключом: БД не проверит, что
> объект существует, и в базу попадёт отзыв на несуществующий филиал.
> Мы потеряем ссылочную целостность — то самое, ради чего брали
> реляционную БД. Две честные таблицы лучше одной универсальной.

### attendance — факт присутствия на смене
| Колонка | Тип | Заметки |
|---|---|---|
| id | INTEGER PK | |
| application_id | INTEGER FK → applications.id UNIQUE | |
| checked_in_at | INTEGER NULL | фактический вход |
| checked_out_at | INTEGER NULL | фактический выход |
| confirmed_minutes | INTEGER NULL | подтверждённые оплачиваемые минуты |
| source | TEXT | `faceid` / `qr` / `manual` / `external` |

> Сумма на карточке — **плановая оценка**. Платят за подтверждённое время
> в рабочей зоне. У крупных клиентов отметки живут во внешней системе,
> поэтому `source = external` и данные приходят интеграцией.

### disputes — оспаривание оплаты
id PK, application_id FK, user_id FK, reason TEXT,
status TEXT (`open`/`resolved`/`rejected`/`expired`),
created_at, resolved_at NULL

> Окно подачи ограничено: только на следующий день после смены.
> Пропущенный срок необратим — статус `expired`.

### work_acts — акты выполненных работ (АВР)
| Колонка | Тип | Заметки |
|---|---|---|
| id | INTEGER PK | |
| application_id | INTEGER FK → applications.id UNIQUE | один акт на один отклик |
| status | TEXT | `pending` / `signed` / `disputed` |
| amount | INTEGER | зафиксированная сумма вознаграждения |
| signed_at | INTEGER NULL | |
| file_path | TEXT NULL | |

> **Жёсткое правило: выплата невозможна без акта со статусом `signed`.**
> Акт — юридическое основание платежа, а не формальность. Сумма в нём —
> снимок на момент подписания (см. правило про вычисляемое и зафиксированное).

### referrals — приглашения
id PK, inviter_id FK → users.id, invited_id FK → users.id UNIQUE,
bonus_amount INTEGER, status TEXT (`pending`/`paid`), created_at

> Ещё одна ссылка таблицы на `users` дважды — кто пригласил и кого.
> `invited_id UNIQUE`: одного человека нельзя привести дважды.

### promo_codes / promo_code_uses
`promo_codes`: id PK, code TEXT UNIQUE, bonus_amount, expires_at, max_uses, is_active
`promo_code_uses`: id PK, promo_code_id FK, user_id FK, used_at,
UNIQUE(promo_code_id, user_id)

> Сам код и факты его применения — разные сущности. UNIQUE не даст одному
> пользователю активировать один код дважды.

### tags / shift_tags — признаки смены
`tags`: id PK, code TEXT UNIQUE, label TEXT, icon_code INTEGER
`shift_tags`: shift_id FK, tag_id FK, PRIMARY KEY (shift_id, tag_id)

> «Можно опоздать», «Вознаграждение завтра» и подобные приманки на карточке.
> Отдельной таблицей, а не булевыми колонками: новый признак добавляется
> строкой в БД, без миграции схемы.

### stories — лента базы знаний
| Колонка | Тип | Заметки |
|---|---|---|
| id | INTEGER PK | |
| title | TEXT | |
| cover_path | TEXT | круглая иконка в шапке главной |
| body | TEXT | содержимое |
| sort_order | INTEGER | порядок в ленте |
| is_active | INTEGER | 0/1 |

> Справочный контент («как получить выплату», «зачем санкнижка»).
> С бизнес-логикой не связан, поэтому и таблица стоит особняком.

### support_tickets / support_messages
`support_tickets`: id PK, user_id FK, shift_id FK NULL, subject, status, created_at
`support_messages`: id PK, ticket_id FK, sender_id FK → users, text, created_at

---

## 3. Карта связей

```
cities ──1:М──► locations        cities ──1:М──► users
companies ──1:М──► locations ──1:М──► shifts ◄──М:1── categories
                                       │
                                       ├──1:М──► shift_required_documents
                                       ├──1:М──► applications ──М:1──► users (worker)
                                       ├──1:М──► worker_reviews ──► users
                                       ├──1:М──► location_reviews ──► locations
                                       └──1:М──► transactions ──М:1──► wallets ──1:1──► users
companies ──1:М──► users (manager)
users ──1:М──► documents ──► users (reviewed_by, оператор)
users ──1:М──► payouts
users ──1:М──► referrals ──► users (приглашённый)
users ──М:М──► promo_codes (через promo_code_uses)
applications ──1:1──► work_acts
applications ──1:1──► attendance
applications ──1:М──► disputes
users ──1:М──► support_tickets ──1:М──► support_messages
```

---

## 4. Жизненный цикл смены

1. Менеджер создаёт смену → `draft` → отправляет → `moderation`
2. Оператор проверяет → `published` (или возврат с замечаниями)
3. Исполнители видят смену, если проходят по `min_rating` и документам
4. Отклик → `applications.pending`
5. Менеджер принимает → `accepted`; набралось `workers_needed` — набор закрыт
6. Отмена исполнителем разрешена не позднее `cancel_deadline_hours` до начала
7. Начало смены → `in_progress`, деньги компании переходят в `hold`
8. Отметки входа/выхода → `attendance`; смена закрывается автоматически по
   `auto_close_at` → `done` → `release` по **подтверждённым** часам:
   исполнителям `available`, платформе `fee`
9. Исполнитель **подписывает АВР** — без этого выплата не проводится
10. Взаимные отзывы → пересчёт `users.rating`
11. Исполнитель заказывает `payout` на карту

---

## 5. Индексы

| Индекс | Зачем |
|---|---|
| `shifts(city_id, work_date, status)` | главный запрос ленты: город + дата + опубликованные |
| `applications(shift_id, status)` | подсчёт занятых мест |
| `applications(worker_id, status)` | экран «Мои подработки» |
| `worker_reviews(worker_id)` | пересчёт рейтинга исполнителя |
| `location_reviews(location_id)` | рейтинг филиала |
| `transactions(wallet_id, created_at)` | история операций |

> Первый индекс — **составной**, из трёх колонок. Порядок колонок в нём
> важен: он работает для запроса по `city_id`, по `city_id + work_date` и
> по всем трём, но **не** для запроса по одному `status`. Правило: слева
> направо, без пропусков.

## 6. Что НЕ хранится в базе

| Значение | Почему не хранится |
|---|---|
| Расстояние до смены | своё для каждого пользователя, меняется постоянно |
| Сумма за смену | выводится из ставки, времени и перерыва |
| Число свободных мест | считается `COUNT(*)` по активным откликам |
| Уровень («Новичок») | выводится из числа выполненных смен |
| Смена через полночь | выводится из сравнения `end` и `start` |
| Длительность перерыва | правило: 60 мин при смене > 5 часов |
| Итоговая выплата | считается по `attendance.confirmed_minutes` |

## 7. Что остаётся за пределами приложения

Договор с юрлицом, налоговый статус исполнителя, реальные переводы денег
через платёжного провайдера. В базе живут только **статусы и ссылки** на
эти внешние процессы (`contract_status`, `payouts.external_ref`).
Учебная версия эмулирует их локально.
