import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/current_user.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/category.dart';
import 'package:fastwork_core/errors.dart';
import 'package:fastwork_core/data/mrp_store.dart';
import 'package:fastwork_core/mrp.dart';
import 'package:fastwork_core/payment.dart';
import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/data/user_language.dart';
import 'package:fastwork_core/l10n/core_strings.dart';
import 'package:fastwork_core/lang.dart';
import 'package:fastwork_core/support.dart';
import 'package:fastwork_core/notification.dart';
import 'package:fastwork_core/review.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/user.dart';
import 'auth_service.dart';
import 'code_sender.dart';
import 'server_strings.dart';
import 'payments/ioka.dart';
import 'payments/kaspi.dart';
import 'payments/http_json.dart';

/// Все адреса сервера.
///
/// Сервер — это программа, которая слушает запросы и отвечает на них.
/// Каждый адрес («маршрут») — одно умение. Присмотрись: умения ровно те же,
/// что в `ShiftRepository`. Это не совпадение — интерфейс хранилища мы
/// писали как список того, что приложению нужно, и сервер обязан отдавать
/// именно это.
///
/// Внутри сервер пользуется теми же `DbShiftRepository` и
/// `DbAuthRepository`, что раньше работали на телефоне. Весь SQL, все
/// правила, все транзакции переехали сюда целиком — их не переписывали.
class Api {
  final AppDatabase db;
  final AuthService auth;

  /// Ключ для служебных адресов — например, чтобы записать новый МРП.
  /// Пустой — служебные адреса выключены совсем.
  final String adminKey;

  /// Через кого идут деньги — один шлюз на весь сервер.
  final PaymentGateway payments;

  /// Секреты подписи вебхуков: `ioka`, `apipay`. Пусто — подпись не
  /// проверяем, но и не доверяем: вебхук только повод спросить провайдера.
  final Map<String, String> webhookSecrets;

  Api(
    this.db,
    CodeSender sender, {
    this.adminKey = '',
    PaymentGateway? payments,
    this.webhookSecrets = const {},
  })  : auth = AuthService(db, sender),
        payments = payments ?? SandboxPaymentGateway();

  /// Найти пользователя по почте — нужно после ввода кода.
  Future<AppUser?> _userByEmail(String email) async {
    final row = await (db.select(db.userRows)
          ..where((u) => u.email.equals(email)))
        .getSingleOrNull();
    return row == null ? null : DbAuthRepository(db).refresh(row.id);
  }

  // -------------------------------------------------------------------------
  // Мелкие помощники
  // -------------------------------------------------------------------------

  /// Ответ с данными. `jsonEncode` превращает объект Dart в текст.
  Response _json(Object? data, {int status = 200}) => Response(
        status,
        body: jsonEncode(data),
        headers: {'content-type': 'application/json; charset=utf-8'},
      );

  Response _error(String message, {int status = 400}) =>
      _json({'error': message}, status: status);

  Future<Map<String, dynamic>> _body(Request request) async {
    final text = await request.readAsString();
    if (text.isEmpty) return {};
    return jsonDecode(text) as Map<String, dynamic>;
  }

  /// Кто прислал запрос.
  ///
  /// Токен приходит в заголовке `Authorization: Bearer <токен>` — это
  /// общепринятый способ, его понимают все инструменты.
  Future<AppUser?> _currentUser(Request request) async {
    final header = request.headers['authorization'];
    if (header == null || !header.startsWith('Bearer ')) return null;

    final info = await auth.lookup(header.substring(7));
    if (info?.userId == null) return null;

    return DbAuthRepository(db).refresh(info!.userId!);
  }

  /// Хранилище от имени того, кто прислал запрос.
  ///
  /// Вот зачем `AppSession` пригодился на сервере: репозиторий спрашивает
  /// у него, кто сейчас действует. На телефоне это был вошедший человек,
  /// здесь — автор запроса. Сам репозиторий разницы не замечает.
  ///
  /// Сессия создаётся **на каждый запрос заново**. Это важно: сервер
  /// обслуживает много людей одновременно, и одна общая сессия перепутала
  /// бы их между собой.
  DbShiftRepository _shiftsFor(AppUser user) =>
      DbShiftRepository(db, StaticUser(user), payments: payments);

  /// Карта из тела запроса. null — не прислали.
  static PaymentCard? _card(Map<String, dynamic> body) {
    final raw = body['card'];
    return raw is Map<String, dynamic> ? PaymentCard.fromJson(raw) : null;
  }

  DbWalletRepository _walletFor(AppUser? user) =>
      DbWalletRepository(db, StaticUser(user), payments: payments);

  /// Отказ по деньгам — 402 «нужна оплата». Код редкий, но ровно про это:
  /// запрос правильный, не хватило платежа.
  Response _declined(PaymentDeclined e) => _error(e.message, status: 402);

  /// Обёртка для адресов, куда пускают только по токену.
  Future<Response> _authorized(
    Request request,
    Future<Response> Function(AppUser user) handler,
  ) async {
    final user = await _currentUser(request);
    if (user == null) return _error(serverTr.needLogin, status: 401);
    // Запоминаем язык человека: на нём ему придут уведомления, которые
    // пишутся без него, — «вас подтвердили», «смену отменили». Только если
    // язык прислали: запрос без заголовка (скрипт, старая версия
    // приложения) не должен переучивать сервер на русский.
    if (request.headers.containsKey('accept-language')) {
      await rememberLanguage(db, user.id, currentLang);
    }
    try {
      return await handler(user);
    } on UserError catch (e) {
      // Отказ по правилам — его текст и есть объяснение.
      return _error(e.message);
    } on FormatException {
      // Кривой JSON или дата, которую не разобрать. Раньше это было
      // «сервер упал» (500), хотя ошибся тот, кто прислал запрос.
      return _error(serverTr.badRequest);
    } on TypeError {
      // Число пришло строкой, поля нет вовсе — тоже ошибка запроса.
      return _error(serverTr.badRequestShape);
    }
  }

  /// Проверить условия смены из запроса — теми же правилами, что и форма
  /// в приложении. null — всё в порядке.
  static String? _shiftInputError(Map<String, dynamic> body) =>
      shiftFormError(
        title: body['title'] as String,
        address: body['address'] as String,
        workDate: DateTime.parse(body['workDate'] as String),
        startMinutes: body['startMinutes'] as int,
        endMinutes: body['endMinutes'] as int,
        hourlyRate: body['hourlyRate'] as int,
        workersNeeded: body['workersNeeded'] as int,
        now: DateTime.now(),
      );

  // -------------------------------------------------------------------------
  // Маршруты
  // -------------------------------------------------------------------------

  /// Все маршруты — на языке запроса.
  ///
  /// Язык приходит в заголовке `Accept-Language`, и весь запрос
  /// выполняется внутри `withLang`: ошибки, тексты уведомлений самому себе,
  /// строки кошелька — всё на нём. Нет заголовка — по-русски.
  Handler get router {
    final routes = _routes;
    return (request) => withLang(
          Lang.fromHeader(request.headers['accept-language']),
          () => routes.call(request),
        );
  }

  Router get _routes {
    final router = Router();

    // --- корневой адрес -----------------------------------------------------
    //
    // Сюда попадают, когда открывают адрес сервера в браузере. Раньше
    // здесь была пустая ошибка «маршрут не найден» — и было непонятно,
    // сервер сломан или просто показывать ему нечего.
    //
    // Это не сайт: страниц у сервера нет, он отвечает только приложению.
    // Но сказать об этом человеку стоит.
    router.get('/', (Request request) {
      return Response.ok(
        '''
<!doctype html>
<html lang="ru">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>fastwork — сервер</title>
  <style>
    body { font-family: system-ui, sans-serif; background: #F4F6F9;
           color: #0F172A; margin: 0; display: grid; place-items: center;
           min-height: 100vh; padding: 24px; }
    .card { background: #fff; border-radius: 20px; padding: 32px;
            max-width: 460px; box-shadow: 0 8px 30px rgba(0,0,0,.06); }
    h1 { margin: 0 0 4px; font-size: 26px; letter-spacing: -.5px; }
    h1 span { color: #0FA36B; }
    p { color: #64748B; line-height: 1.5; font-size: 14px; }
    code { background: #F4F6F9; padding: 2px 6px; border-radius: 6px;
           font-size: 13px; }
    .ok { display: inline-block; background: rgba(15,163,107,.12);
          color: #0B7A50; font-weight: 700; font-size: 13px;
          padding: 6px 12px; border-radius: 999px; margin-bottom: 16px; }
  </style>
</head>
<body>
  <div class="card">
    <div class="ok">● сервер работает</div>
    <h1>fast<span>work</span></h1>
    <p>Это сервер, а не сайт. Страниц у него нет — он отвечает
       приложению на запросы о сменах, записях и оценках.</p>
    <p>Проверить, что он жив:
       <a href="/api/health"><code>/api/health</code></a></p>
    <p>Чтобы открыть приложение, запустите его с этим адресом:<br>
       <code>flutter run -d chrome --dart-define=API_URL=…</code></p>
  </div>
</body>
</html>
''',
        headers: {'content-type': 'text/html; charset=utf-8'},
      );
    });

    // --- проверка, что сервер жив -----------------------------------------
    // Хостинги дёргают такой адрес, чтобы понять, работает ли программа.
    router.get('/api/health', (Request r) => _json({'status': 'ok'}));

    // --- вход и регистрация ------------------------------------------------

    // --- вход по коду с почты ----------------------------------------------

    router.post('/api/auth/request-code', (Request request) async {
      final body = await _body(request);
      try {
        final delivery = await auth.requestCode(body['email'] as String? ?? '');
        // `delivery` говорит приложению, где искать код: в почте или,
        // пока почтовый сервис не подключён, в окне сервера.
        return _json({'ok': true, 'delivery': delivery});
      } on AuthError catch (e) {
        return _error(e.message, status: e.status);
      }
    });

    router.post('/api/auth/verify', (Request request) async {
      final body = await _body(request);
      try {
        final email = await auth.verifyCode(
          body['email'] as String? ?? '',
          body['code'] as String? ?? '',
        );

        final user = await _userByEmail(email);
        final token = await auth.issue(email: email, userId: user?.id);

        // Пользователя может ещё не быть — тогда почта подтверждена, а
        // анкету заполнят следующим шагом. Токен уже выдан, но он пускает
        // только в регистрацию.
        return _json({'token': token, 'user': user?.toJson()});
      } on AuthError catch (e) {
        return _error(e.message, status: e.status);
      }
    });

    router.post('/api/auth/register', (Request request) async {
      final header = request.headers['authorization'];
      if (header == null || !header.startsWith('Bearer ')) {
        return _error(serverTr.confirmEmailFirst, status: 401);
      }

      final token = header.substring(7);
      final info = await auth.lookup(token);
      if (info == null) {
        return _error(serverTr.confirmEmailFirst, status: 401);
      }
      if (info.userId != null) {
        return _error(serverTr.accountExists);
      }

      final body = await _body(request);
      final phone =
          (body['phone'] as String? ?? '').replaceAll(RegExp(r'\D'), '');
      if (phone.length < 10) return _error(serverTr.badPhone);

      final fullName = (body['fullName'] as String? ?? '').trim();
      if (fullName.length < 2) return _error(serverTr.needFullName);

      final repository = DbAuthRepository(db);
      if (await repository.findByPhone(phone) != null) {
        return _error(serverTr.phoneTaken);
      }

      final AppUser user;
      try {
        user = await repository.register(
          phone: phone,
          email: info.email,
          fullName: fullName,
          city: body['city'] as String? ?? 'Алматы',
          role: body['role'] as String? ?? UserRole.worker,
          company: body['company'] as String?,
          // Старое приложение этого поля не шлёт — значит, правил человек
          // не видел, и аккаунт без них не создаём.
          acceptedTermsVersion: body['acceptedTermsVersion'] as int? ?? 0,
        );
      } on UserError catch (e) {
        return _error(e.message);
      }

      // Теперь токен принадлежит созданному аккаунту.
      await auth.bind(token, user.id);
      return _json({'token': token, 'user': user.toJson()});
    });

    router.post('/api/auth/logout', (Request request) async {
      final header = request.headers['authorization'];
      if (header != null && header.startsWith('Bearer ')) {
        await auth.revoke(header.substring(7));
      }
      return _json({'ok': true});
    });

    router.get('/api/me', (Request request) async {
      return _authorized(request, (user) async => _json(user.toJson()));
    });

    router.post('/api/me/accept-terms', (Request request) async {
      return _authorized(request, (user) async {
        final updated = await DbAuthRepository(db).acceptTerms(user.id);
        return _json(updated!.toJson());
      });
    });

    router.get('/api/me/limit', (Request request) async {
      return _authorized(request, (user) async {
        final raw = request.url.queryParameters['month'];
        final month = raw == null ? DateTime.now() : DateTime.parse(raw);
        final limit = await _shiftsFor(user).earningsLimit(month);
        return _json(limit.toJson());
      });
    });

    // --- МРП ---------------------------------------------------------------
    //
    // Посмотреть может кто угодно: это не секрет, а цифра из закона.
    router.get('/api/mrp', (Request request) async {
      final rates = await MrpStore(db).rates();
      return _json({
        'current': mrpOn(DateTime.now(), rates),
        'limitMrp': kEarningsLimitMrp,
        'monthlyLimit': monthlyEarningsLimit(DateTime.now(), rates),
        'rates': rates.map((r) => r.toJson()).toList(),
      });
    });

    // А записать новое значение — только по служебному ключу.
    //
    // Отдельной роли «администратор» в приложении нет, и заводить её ради
    // одной цифры в год незачем. Ключ задаётся переменной окружения
    // ADMIN_KEY на хостинге и в код не попадает.
    //
    //   curl -X POST https://…/api/admin/mrp \
    //     -H 'X-Admin-Key: …' \
    //     -d '{"validFrom": "2027-01-01", "tenge": 4700}'
    router.post('/api/admin/mrp', (Request request) async {
      if (adminKey.isEmpty || request.headers['x-admin-key'] != adminKey) {
        return _error(serverTr.noAccess, status: 403);
      }
      final body = await _body(request);
      final validFrom = DateTime.tryParse(body['validFrom'] as String? ?? '');
      final tenge = body['tenge'] as int? ?? 0;
      if (validFrom == null) return _error(serverTr.needValidFrom);
      if (tenge <= 0) return _error(serverTr.needMrp);

      await MrpStore(db).setRate(validFrom, tenge * 100);
      return _json({'ok': true});
    });

    router.post('/api/me/city', (Request request) async {
      return _authorized(request, (user) async {
        final body = await _body(request);
        final updated = await DbAuthRepository(db).changeCity(
          user.id,
          body['city'] as String? ?? user.city,
        );
        return _json(updated!.toJson());
      });
    });

    // --- лента смен --------------------------------------------------------

    router.get('/api/shifts', (Request request) async {
      return _authorized(request, (user) async {
        final raw = request.url.queryParameters['date'];
        final date = raw == null ? DateTime.now() : DateTime.parse(raw);

        final shifts = await _shiftsFor(user).shiftsOn(date);
        return _json(shifts.map((s) => s.toJson()).toList());
      });
    });

    router.get('/api/shifts/days', (Request request) async {
      return _authorized(request, (user) async {
        final days = await _shiftsFor(user).daysWithShifts();
        return _json(days.map((d) => d.toIso8601String()).toList());
      });
    });

    router.get('/api/companies', (Request request) async {
      return _authorized(
        request,
        (user) async => _json(await _shiftsFor(user).companies()),
      );
    });

    router.get('/api/categories', (Request request) async {
      return _authorized(
        request,
        (user) async => _json(await _shiftsFor(user).categories()),
      );
    });

    router.get('/api/companies/<name>', (Request request, String name) async {
      return _authorized(request, (user) async {
        final info = await _shiftsFor(user).companyInfo(
          Uri.decodeComponent(name),
        );
        return _json(info.toJson());
      });
    });

    // Подписка на новые смены компании.
    router.post('/api/companies/<name>/follow',
        (Request request, String name) async {
      return _authorized(request, (user) async {
        final body = await _body(request);
        await _shiftsFor(user).followCompany(
          Uri.decodeComponent(name),
          follow: body['follow'] as bool? ?? true,
        );
        return _json({'ok': true});
      });
    });

    // Подписки на виды работ: какие есть и включить/выключить одну.
    router.get('/api/me/categories', (Request request) async {
      return _authorized(request, (user) async {
        final followed = await _shiftsFor(user).followedCategories();
        return _json(followed.toList()..sort());
      });
    });

    router.post('/api/me/categories/<id>', (Request request, String id) async {
      return _authorized(request, (user) async {
        final category = Uri.decodeComponent(id);
        if (!kShiftCategories.any((c) => c.id == category)) {
          return _error(serverTr.unknownCategory);
        }
        final body = await _body(request);
        await _shiftsFor(user).followCategory(
          category,
          follow: body['follow'] as bool? ?? true,
        );
        return _json({'ok': true});
      });
    });

    router.get('/api/shifts/<id|[0-9]+>', (Request request, String id) async {
      return _authorized(request, (user) async {
        final shift = await _shiftsFor(user).shiftById(int.parse(id));
        if (shift == null) return _error(coreTr.shiftNotFound, status: 404);
        return _json(shift.toJson());
      });
    });

    // --- действия исполнителя ---------------------------------------------

    router.post('/api/shifts/<id|[0-9]+>/apply',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final result = await _shiftsFor(user).apply(int.parse(id));
        return _json({'result': result.name});
      });
    });

    router.post('/api/shifts/<id|[0-9]+>/cancel',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final result =
            await _shiftsFor(user).cancelApplication(int.parse(id));
        return _json({'result': result.name});
      });
    });

    // Заказчик отменяет свою смену. Адрес отличается от /cancel, которым
    // исполнитель снимает **свою запись**: действия разные, и путать их
    // нельзя. Кто здесь имеет право, проверяет хранилище.
    router.post('/api/shifts/<id|[0-9]+>/cancel-shift',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final result = await _shiftsFor(user).cancelShift(int.parse(id));
        return _json({'result': result.name});
      });
    });

    // Лист ожидания: «скажите, когда освободится место» и обратно.
    router.post('/api/shifts/<id|[0-9]+>/waitlist',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final body = await _body(request);
        final result = await _shiftsFor(user).setWaitlist(
          int.parse(id),
          join: body['join'] as bool? ?? true,
        );
        return _json({'result': result.name});
      });
    });

    router.post('/api/shifts/<id|[0-9]+>/checkin',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final body = await _body(request);
        final result = await _shiftsFor(user).checkIn(
          int.parse(id),
          code: body['code'] as String?,
        );
        return _json({'result': result.name});
      });
    });

    // Код отметки — только заказчику этой смены.
    router.get('/api/shifts/<id|[0-9]+>/code',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final code = await _shiftsFor(user).checkInCode(int.parse(id));
        if (code == null) return _error(serverTr.notYourShift, status: 403);
        return _json({'code': code});
      });
    });

    router.get('/api/my-shifts', (Request request) async {
      return _authorized(request, (user) async {
        final archived = request.url.queryParameters['archived'] == 'true';
        final shifts = await _shiftsFor(user).myShifts(archived: archived);
        return _json(shifts.map((s) => s.toJson()).toList());
      });
    });

    router.get('/api/my-shifts/completed', (Request request) async {
      return _authorized(request, (user) async {
        final shifts = await _shiftsFor(user).completedShifts();
        return _json(shifts.map((s) => s.toJson()).toList());
      });
    });

    router.get('/api/me/reviews', (Request request) async {
      return _authorized(request, (user) async {
        final reviews = await _shiftsFor(user).reviewsAbout(user.id);
        return _json(reviews.map((r) => r.toJson()).toList());
      });
    });

    // --- уведомления ------------------------------------------------------

    router.get('/api/notifications', (Request request) async {
      return _authorized(request, (user) async {
        final items = await _shiftsFor(user).notifications();
        return _json(items.map((n) => n.toJson()).toList());
      });
    });

    // Число непрочитанных — отдельный адрес, потому что приложение
    // спрашивает его часто, а тексты ему для кружка не нужны.
    router.get('/api/notifications/unread', (Request request) async {
      return _authorized(request, (user) async {
        final count = await _shiftsFor(user).unreadNotifications();
        return _json({'count': count});
      });
    });

    router.post('/api/notifications/read', (Request request) async {
      return _authorized(request, (user) async {
        await _shiftsFor(user).markNotificationsRead();
        return _json({'ok': true});
      });
    });

    // --- отзывы о месте работы --------------------------------------------

    router.get('/api/shifts/<id|[0-9]+>/reviewed',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final done = await _shiftsFor(user).hasReviewed(int.parse(id));
        return _json({'reviewed': done});
      });
    });

    router.post('/api/shifts/<id|[0-9]+>/review',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final body = await _body(request);
        final rating = body['rating'] as int? ?? 0;
        if (rating < 1 || rating > 5) return _error(serverTr.ratingRange);

        await _shiftsFor(user).addReview(
          shiftId: int.parse(id),
          rating: rating,
          comment: body['comment'] as String?,
        );
        return _json({'ok': true});
      });
    });

    // --- заказчик ----------------------------------------------------------

    router.post('/api/shifts', (Request request) async {
      return _authorized(request, (user) async {
        // Роль проверяет сервер, а не экран. Спрятать кнопку — не защита:
        // запрос можно отправить и без приложения.
        if (!user.isManager) {
          return _error(serverTr.employersOnly, status: 403);
        }

        final body = await _body(request);
        final category = body['category'] as String? ?? kOtherCategory;
        // Ключ категории приходит снаружи — проверяем, что такой есть.
        // Иначе в базе завелись бы категории, которых нет ни в одном
        // фильтре, и смены с ними никто бы не нашёл.
        if (!isKnownCategory(category)) {
          return _error(serverTr.unknownCategory);
        }
        // Смена без оплаты не публикуется — в этом вся гарантия. Способ
        // обязателен: старое приложение, которое присылало карту прямо
        // сюда, должно обновиться.
        final method = body['method'] as String?;
        if (method == null) {
          return _error(serverTr.updateApp,
              status: 426);
        }
        final problem = _shiftInputError(body);
        if (problem != null) return _error(problem);
        final PaymentCheckout checkout;
        try {
          checkout = await _shiftsFor(user).createShift(
            method: PaymentMethod.fromId(method),
            phone: body['phone'] as String?,
            workDate: DateTime.parse(body['workDate'] as String),
            title: body['title'] as String,
            // Компания и город — из профиля заказчика, а не из запроса.
            // Иначе кто угодно мог бы выставить смену от имени «Magnum»
            // и собрать отзывы, которые достанутся настоящему Magnum.
            company: user.company ?? body['company'] as String,
            address: body['address'] as String,
            startMinutes: body['startMinutes'] as int,
            endMinutes: body['endMinutes'] as int,
            hourlyRate: body['hourlyRate'] as int,
            workersNeeded: body['workersNeeded'] as int,
            createdBy: user.id,
            city: user.city,
            category: category,
            duties: (body['duties'] as List<dynamic>? ?? []).cast<String>(),
            dressCode: body['dressCode'] as String?,
            minRating: (body['minRating'] as num?)?.toDouble(),
          );
        } on PaymentDeclined catch (e) {
          return _declined(e);
        }
        return _json(checkout.toJson());
      });
    });

    // Оплатить неоплаченную смену ещё раз — другим способом или заново.
    router.post('/api/shifts/<id|[0-9]+>/pay',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final body = await _body(request);
        try {
          final checkout = await _shiftsFor(user).retryPayment(
            int.parse(id),
            method: PaymentMethod.fromId(body['method'] as String?),
            phone: body['phone'] as String?,
          );
          return _json(checkout.toJson());
        } on PaymentDeclined catch (e) {
          return _declined(e);
        }
      });
    });

    // Правка смены. Адрес тот же, что у смены, — так принято: POST на
    // адрес самой вещи означает «измени вот эту». Право менять проверяет
    // хранилище: там же, где данные.
    router.post('/api/shifts/<id|[0-9]+>', (Request request, String id) async {
      return _authorized(request, (user) async {
        if (!user.isManager) {
          return _error(serverTr.employersOnly, status: 403);
        }

        final body = await _body(request);
        // Старое приложение категорию не присылает — тогда её не трогаем.
        final category = body['category'] as String?;
        if (category != null && !isKnownCategory(category)) {
          return _error(serverTr.unknownCategory);
        }
        final problem = _shiftInputError(body);
        if (problem != null) return _error(problem);
        final ShiftEditResult result;
        try {
          result = await _shiftsFor(user).updateShift(
            method: PaymentMethod.fromId(body['method'] as String?),
            phone: body['phone'] as String?,
            shiftId: int.parse(id),
            workDate: DateTime.parse(body['workDate'] as String),
            title: body['title'] as String,
            address: body['address'] as String,
            startMinutes: body['startMinutes'] as int,
            endMinutes: body['endMinutes'] as int,
            hourlyRate: body['hourlyRate'] as int,
            workersNeeded: body['workersNeeded'] as int,
            category: category,
            duties: (body['duties'] as List<dynamic>? ?? []).cast<String>(),
            dressCode: body['dressCode'] as String?,
          );
        } on PaymentDeclined catch (e) {
          return _declined(e);
        }
        return _json(result.toJson());
      });
    });

    router.get('/api/manager/shifts', (Request request) async {
      return _authorized(request, (user) async {
        final shifts = await _shiftsFor(user).shiftsCreatedBy(user.id);
        return _json(shifts.map((s) => s.toJson()).toList());
      });
    });

    router.get('/api/manager/to-rate', (Request request) async {
      return _authorized(request, (user) async {
        final pending = await _shiftsFor(user).workersToRate(user.id);
        return _json(pending.map((p) => p.toJson()).toList());
      });
    });

    router.get('/api/shifts/<id|[0-9]+>/applicants',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final people = await _shiftsFor(user).applicantsFor(int.parse(id));
        return _json(people.map((p) => p.toJson()).toList());
      });
    });

    router.post('/api/shifts/<id|[0-9]+>/confirm',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        if (!user.isManager) {
          return _error(serverTr.employersOnly, status: 403);
        }
        final body = await _body(request);
        final result = await _shiftsFor(user).confirmAttendance(
          shiftId: int.parse(id),
          workerId: body['workerId'] as int,
        );
        return _json({'result': result.name});
      });
    });

    // Отметка «не вышел». Отдельный адрес, а не флаг в подтверждении:
    // это противоположное по смыслу действие, и путать их нельзя.
    router.post('/api/shifts/<id|[0-9]+>/no-show',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        if (!user.isManager) {
          return _error(serverTr.employersOnly, status: 403);
        }
        final body = await _body(request);
        final result = await _shiftsFor(user).markNoShow(
          shiftId: int.parse(id),
          workerId: body['workerId'] as int,
        );
        return _json({'result': result.name});
      });
    });

    // Любимые исполнители заказчика. Адрес — номер исполнителя: «этого
    // человека — в любимые» или «из любимых».
    router.get('/api/favorites', (Request request) async {
      return _authorized(request, (user) async {
        if (!user.isManager) {
          return _error(serverTr.employersOnly, status: 403);
        }
        final people = await _shiftsFor(user).favoriteWorkers();
        return _json(people.map((p) => p.toJson()).toList());
      });
    });

    router.post('/api/favorites/<id|[0-9]+>',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        if (!user.isManager) {
          return _error(serverTr.employersOnly, status: 403);
        }
        final body = await _body(request);
        final result = await _shiftsFor(user).setFavorite(
          workerId: int.parse(id),
          favorite: body['favorite'] as bool? ?? true,
        );
        return _json({'result': result.name});
      });
    });

    router.post('/api/shifts/<id|[0-9]+>/rate',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        if (!user.isManager) {
          return _error(serverTr.employersOnly, status: 403);
        }
        final body = await _body(request);
        final rating = body['rating'] as int? ?? 0;
        if (rating < 1 || rating > 5) return _error(serverTr.ratingRange);

        await _shiftsFor(user).rateWorker(
          shiftId: int.parse(id),
          workerId: body['workerId'] as int,
          rating: rating,
          comment: body['comment'] as String?,
        );
        return _json({'ok': true});
      });
    });

    // --- кошелёк -----------------------------------------------------------

    router.get('/api/wallet', (Request request) async {
      return _authorized(request, (user) async {
        final summary = await DbWalletRepository(
          db,
          StaticUser(user),
          payments: payments,
        ).summary();
        return _json(summary.toJson());
      });
    });

    router.post('/api/wallet/withdraw', (Request request) async {
      return _authorized(request, (user) async {
        final body = await _body(request);
        try {
          final checkout = await _walletFor(user)
              .startWithdrawal(body['amount'] as int? ?? 0);
          return _json(checkout.toJson());
        } on PaymentDeclined catch (e) {
          return _declined(e);
        }
      });
    });

    router.get('/api/wallet/payouts/<id|[0-9]+>',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        try {
          return _json(
              (await _walletFor(user).withdrawalStatus(int.parse(id))).toJson());
        } on PaymentDeclined catch (e) {
          return _declined(e);
        }
      });
    });

    router.post('/api/wallet/payouts/<id|[0-9]+>/sandbox',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final card = _card(await _body(request));
        if (card == null) return _error(serverTr.needCard);
        try {
          final checkout = await _walletFor(user)
              .completeSandboxWithdrawal(int.parse(id), card);
          return _json(checkout.toJson());
        } on PaymentDeclined catch (e) {
          return _declined(e);
        }
      });
    });

    // --- оплаты ------------------------------------------------------------

    // Как идёт оплата. Приложение спрашивает раз в несколько секунд, пока
    // человек платит на странице провайдера или в Kaspi.kz. Если провайдер
    // уже подтвердил — смена публикуется прямо в этом запросе.
    router.get('/api/payments/<id|[0-9]+>', (Request request, String id) async {
      return _authorized(request, (user) async {
        try {
          return _json(
              (await _shiftsFor(user).paymentStatus(int.parse(id))).toJson());
        } on PaymentDeclined catch (e) {
          return _declined(e);
        }
      });
    });

    // Тестовый режим: «заплатить» без провайдера.
    router.post('/api/payments/<id|[0-9]+>/sandbox',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        try {
          final checkout = await _shiftsFor(user).completeSandboxPayment(
            int.parse(id),
            card: _card(await _body(request)),
          );
          return _json(checkout.toJson());
        } on PaymentDeclined catch (e) {
          return _declined(e);
        }
      });
    });

    // Вебхуки провайдеров: «по операции такой-то что-то произошло».
    //
    // Верим не вебхуку, а провайдеру: по номеру операции сами спрашиваем,
    // как она прошла. Поддельный вебхук поэтому ничего не сломает. Подпись
    // всё равно проверяем, если секрет задан: так мусорные запросы даже
    // не доходят до провайдера.
    router.post('/api/payments/webhook/<provider|ioka|apipay>',
        (Request request, String provider) async {
      final raw = await request.read().expand((chunk) => chunk).toList();
      final secret = webhookSecrets[provider] ?? '';
      if (secret.isNotEmpty) {
        final signature = request.headers[
            provider == 'ioka' ? 'x-signature' : 'x-webhook-signature'];
        if (!verifyHmac(secret: secret, body: raw, signature: signature)) {
          return _error(serverTr.badSignature, status: 401);
        }
      }

      final Map<String, dynamic> json;
      try {
        json = jsonDecode(utf8.decode(raw)) as Map<String, dynamic>;
      } catch (_) {
        return _error(serverTr.expectedJson);
      }
      final operation = provider == 'ioka'
          ? IokaProvider.operationFromWebhook(json)
          : KaspiInvoiceProvider.operationFromWebhook(json);
      if (operation != null) {
        await DbShiftRepository(db, const StaticUser(null), payments: payments)
            .settleOperation(provider, operation);
        await _walletFor(null).settleOperation(provider, operation);
      }
      return _json({'ok': true});
    });

    // Сюда провайдер возвращает человека после оплаты. Само приложение
    // осталось открытым в другой вкладке и уже знает, чем всё кончилось, —
    // здесь только просьба вернуться в него.
    router.get('/api/payments/return', (Request request) {
      final failed = request.url.queryParameters['result'] == 'failure';
      return Response.ok(
        _returnPage(failed),
        headers: {'content-type': 'text/html; charset=utf-8'},
      );
    });

    // --- документы ---------------------------------------------------------

    router.get('/api/documents', (Request request) async {
      return _authorized(request, (user) async {
        final docs = await DbDocumentRepository(db, StaticUser(user))
            .documents();
        return _json(docs.map((d) => d.toJson()).toList());
      });
    });

    router.post('/api/documents', (Request request) async {
      return _authorized(request, (user) async {
        final body = await _body(request);
        await DbDocumentRepository(db, StaticUser(user)).upload(
          type: body['type'] as String,
          number: body['number'] as String,
          expiresAt: body['expiresAt'] == null
              ? null
              : DateTime.parse(body['expiresAt'] as String),
        );
        return _json({'ok': true});
      });
    });

    router.post('/api/documents/<id|[0-9]+>/review',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final body = await _body(request);
        await DbDocumentRepository(db, StaticUser(user)).review(
          int.parse(id),
          approved: body['approved'] as bool? ?? true,
        );
        return _json({'ok': true});
      });
    });

    // --- поддержка ---------------------------------------------------------

    router.get('/api/support/tickets', (Request request) async {
      return _authorized(request, (user) async {
        final list =
            await DbSupportRepository(db, StaticUser(user)).tickets();
        return _json(list.map((t) => t.toJson()).toList());
      });
    });

    router.post('/api/support/tickets', (Request request) async {
      return _authorized(request, (user) async {
        final body = await _body(request);
        final id = await DbSupportRepository(db, StaticUser(user))
            .createTicket(
          body['subject'] as String,
          body['message'] as String,
        );
        return _json({'id': id});
      });
    });

    router.get('/api/support/tickets/<id|[0-9]+>/messages',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final list = await DbSupportRepository(db, StaticUser(user))
            .messages(int.parse(id));
        return _json(list.map((m) => m.toJson()).toList());
      });
    });

    router.post('/api/support/tickets/<id|[0-9]+>/messages',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final body = await _body(request);
        await DbSupportRepository(db, StaticUser(user)).sendMessage(
          int.parse(id),
          body['text'] as String,
        );
        return _json({'ok': true});
      });
    });

    return router;
  }
}

/// Страница «вернитесь в приложение» после оплаты у провайдера.
String _returnPage(bool failed) => """<!DOCTYPE html>
<html lang="${currentLang.code}"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${serverTr.paymentPageTitle}</title>
<style>
body{margin:0;min-height:100vh;display:flex;align-items:center;
justify-content:center;background:#EFF6F3;font-family:system-ui,
-apple-system,sans-serif;color:#0F172A;text-align:center;padding:24px}
.card{max-width:360px;background:#fff;border-radius:24px;padding:32px;
box-shadow:0 12px 40px rgba(15,61,46,.12)}
.icon{font-size:48px}h1{font-size:22px;margin:12px 0 8px}
p{color:#475569;line-height:1.45;margin:0}
</style></head><body><div class="card">
<div class="icon">${failed ? '⚠️' : '✅'}</div>
<h1>${failed ? serverTr.paymentFailed : serverTr.paymentAccepted}</h1>
<p>${failed ? serverTr.paymentFailedHint : serverTr.paymentAcceptedHint}</p>
</div></body></html>""";
