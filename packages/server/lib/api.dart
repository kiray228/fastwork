import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/data/current_user.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/support.dart';
import 'package:fastwork_core/review.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/user.dart';
import 'auth_service.dart';
import 'code_sender.dart';

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

  Api(this.db, CodeSender sender) : auth = AuthService(db, sender);

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
      DbShiftRepository(db, StaticUser(user));

  /// Обёртка для адресов, куда пускают только по токену.
  Future<Response> _authorized(
    Request request,
    Future<Response> Function(AppUser user) handler,
  ) async {
    final user = await _currentUser(request);
    if (user == null) return _error('Нужен вход', status: 401);
    return handler(user);
  }

  // -------------------------------------------------------------------------
  // Маршруты
  // -------------------------------------------------------------------------

  Router get router {
    final router = Router();

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
        return _error('Сначала подтвердите почту', status: 401);
      }

      final token = header.substring(7);
      final info = await auth.lookup(token);
      if (info == null) {
        return _error('Сначала подтвердите почту', status: 401);
      }
      if (info.userId != null) {
        return _error('Аккаунт с этой почтой уже создан');
      }

      final body = await _body(request);
      final phone =
          (body['phone'] as String? ?? '').replaceAll(RegExp(r'\D'), '');
      if (phone.length < 10) return _error('Некорректный номер телефона');

      final fullName = (body['fullName'] as String? ?? '').trim();
      if (fullName.length < 2) return _error('Укажите имя и фамилию');

      final repository = DbAuthRepository(db);
      if (await repository.findByPhone(phone) != null) {
        return _error('Этот номер уже зарегистрирован');
      }

      final user = await repository.register(
        phone: phone,
        email: info.email,
        fullName: fullName,
        city: body['city'] as String? ?? 'Алматы',
        role: body['role'] as String? ?? UserRole.worker,
        company: body['company'] as String?,
      );

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

    router.get('/api/companies/<name>', (Request request, String name) async {
      return _authorized(request, (user) async {
        final info = await _shiftsFor(user).companyInfo(
          Uri.decodeComponent(name),
        );
        return _json(info.toJson());
      });
    });

    router.get('/api/shifts/<id|[0-9]+>', (Request request, String id) async {
      return _authorized(request, (user) async {
        final shift = await _shiftsFor(user).shiftById(int.parse(id));
        if (shift == null) return _error('Смена не найдена', status: 404);
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

    router.post('/api/shifts/<id|[0-9]+>/checkin',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        final result = await _shiftsFor(user).checkIn(int.parse(id));
        return _json({'result': result.name});
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
        if (rating < 1 || rating > 5) return _error('Оценка от 1 до 5');

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
          return _error('Только для заказчиков', status: 403);
        }

        final body = await _body(request);
        final id = await _shiftsFor(user).createShift(
          workDate: DateTime.parse(body['workDate'] as String),
          title: body['title'] as String,
          company: body['company'] as String,
          address: body['address'] as String,
          startMinutes: body['startMinutes'] as int,
          endMinutes: body['endMinutes'] as int,
          hourlyRate: body['hourlyRate'] as int,
          workersNeeded: body['workersNeeded'] as int,
          createdBy: user.id,
          city: body['city'] as String? ?? user.city,
          duties: (body['duties'] as List<dynamic>? ?? []).cast<String>(),
          dressCode: body['dressCode'] as String?,
          minRating: (body['minRating'] as num?)?.toDouble(),
        );
        return _json({'id': id});
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
          return _error('Только для заказчиков', status: 403);
        }
        final body = await _body(request);
        await _shiftsFor(user).confirmAttendance(
          shiftId: int.parse(id),
          workerId: body['workerId'] as int,
        );
        return _json({'ok': true});
      });
    });

    router.post('/api/shifts/<id|[0-9]+>/rate',
        (Request request, String id) async {
      return _authorized(request, (user) async {
        if (!user.isManager) {
          return _error('Только для заказчиков', status: 403);
        }
        final body = await _body(request);
        final rating = body['rating'] as int? ?? 0;
        if (rating < 1 || rating > 5) return _error('Оценка от 1 до 5');

        await _shiftsFor(user).rateWorker(
          shiftId: int.parse(id),
          workerId: body['workerId'] as int,
          rating: rating,
          comment: body['comment'] as String?,
        );
        return _json({'ok': true});
      });
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
