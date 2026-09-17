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

### companies — компании-заказчики
| Колонка | Тип | Заметки |
|---|---|---|
| id | INTEGER PK | |
| name | TEXT | «Magnum», «KFC» |
| bin | TEXT UNIQUE | БИН юрлица |
| logo_path | TEXT NULL | логотип на карточке смены |
| contract_status | TEXT | `pending` / `active` / `suspended` |
| created_at | INTEGER | |

> Договор подписывается вне приложения. В базе хранится только его
> **статус**: без `active` компания не может публиковать смены.

### locations — точки компании
| Колонка | Тип |
|---|---|
| id | INTEGER PK |
| company_id | INTEGER FK → companies.id |
| title | TEXT |
| address | TEXT |
| lat, lon | REAL |

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
| rating | REAL NULL | кэш среднего из reviews; NULL = смен ещё не было |
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
| break_minutes | INTEGER | неоплачиваемый перерыв, по умолчанию 60 |
| hourly_rate | INTEGER | ставка в тиынах за час |
| workers_needed | INTEGER | сколько человек нужно |
| min_rating | REAL NULL | порог допуска, NULL = без ограничений |
| cancel_deadline_hours | INTEGER | по умолчанию 10 |
| status | TEXT | `draft`/`moderation`/`published`/`in_progress`/`done`/`cancelled` |
| created_at | INTEGER | |

> **Почему ставка за час, а не сумма за смену?**
> Сумма выводится из ставки, длительности и перерыва:
> `((end_minutes − start_minutes − break_minutes) / 60) × hourly_rate`.
> Перерыв обнаружен по арифметике карточек прототипа — см.
> `docs/05-razbor-ekranov.md`, раздел 4.
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

> **Сколько мест осталось?** Считается запросом:
> `SELECT COUNT(*) FROM applications WHERE shift_id = ? AND status = 'accepted'`.
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

### reviews — отзывы
id PK, shift_id FK, author_id FK → users, target_id FK → users,
rating INTEGER (1..5), comment TEXT NULL, created_at,
UNIQUE(shift_id, author_id)

> Из рейтинга считается `users.rating`, а он работает как **допуск**:
> смена с `min_rating = 4.5` не покажется исполнителю с рейтингом ниже.

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
companies ──1:М──► locations ──1:М──► shifts ◄──М:1── categories
                                       │
                                       ├──1:М──► shift_required_documents
                                       ├──1:М──► applications ──М:1──► users (worker)
                                       ├──1:М──► reviews ──► users (author/target)
                                       └──1:М──► transactions ──М:1──► wallets ──1:1──► users
companies ──1:М──► users (manager)
users ──1:М──► documents ──► users (reviewed_by, оператор)
users ──1:М──► payouts
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
8. Смена закрыта → `done` → `release`: исполнителям `available`, платформе `fee`
9. Взаимные отзывы → пересчёт `users.rating`
10. Исполнитель заказывает `payout` на карту

---

## 5. Что остаётся за пределами приложения

Договор с юрлицом, налоговый статус исполнителя, реальные переводы денег
через платёжного провайдера. В базе живут только **статусы и ссылки** на
эти внешние процессы (`contract_status`, `payouts.external_ref`).
Учебная версия эмулирует их локально.
