import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_server/api.dart';
import 'package:fastwork_server/auth_service.dart';
import 'package:fastwork_server/code_sender.dart';
import 'package:fastwork_server/rate_limit.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

/// Сервер глазами того, кто шлёт запросы мимо приложения.
///
/// Кнопку на экране можно спрятать, но запрос всё равно можно отправить
/// руками — с чужим номером смены, обращения или документа. Здесь
/// проверяем, что сервер такие запросы отклоняет сам.
void main() {
  late AppDatabase db;
  late Api api;
  late String managerToken;
  late String strangerToken;
  late String workerToken;
  late int workerId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    api = Api(db, ConsoleCodeSender());

    final auth = DbAuthRepository(db);
    final manager = await auth.register(
      phone: '77000000001',
      email: 'boss@example.kz',
      fullName: 'Айгуль Досова',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: 'manager',
      company: 'Magnum',
    );
    final stranger = await auth.register(
      phone: '77000000003',
      email: 'other@example.kz',
      fullName: 'Чужой Заказчик',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      role: 'manager',
      company: 'Small',
    );
    final worker = await auth.register(
      phone: '77000000002',
      email: 'worker@example.kz',
      fullName: 'Ернар Калдыбеков',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
    );
    workerId = worker.id;
    final tokens = AuthService(db, ConsoleCodeSender());
    managerToken =
        await tokens.issue(email: 'boss@example.kz', userId: manager.id);
    strangerToken =
        await tokens.issue(email: 'other@example.kz', userId: stranger.id);
    workerToken =
        await tokens.issue(email: 'worker@example.kz', userId: worker.id);
  });

  tearDown(() => db.close());

  Future<(int, dynamic)> call(
    String method,
    String path, {
    String? token,
    Object? body,
  }) async {
    final response = await api.router.call(Request(
      method,
      Uri.parse('http://localhost$path'),
      body: body == null ? null : (body is String ? body : jsonEncode(body)),
      headers: {if (token != null) 'authorization': 'Bearer $token'},
    ));
    final text = await response.readAsString();
    return (
      response.statusCode,
      text.startsWith('{') || text.startsWith('[') ? jsonDecode(text) : text,
    );
  }

  final tomorrow = DateTime.now().add(const Duration(days: 1));
  final day = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

  Map<String, dynamic> shiftBody({
    int hourlyRate = 110000,
    int workersNeeded = 2,
    DateTime? workDate,
    String company = 'Magnum',
  }) =>
      {
        'method': 'card',
        'workDate': (workDate ?? day).toIso8601String(),
        'title': 'Услуги грузчика',
        'company': company,
        'address': 'ул. Абая, 1',
        'startMinutes': 600,
        'endMinutes': 1320,
        'hourlyRate': hourlyRate,
        'workersNeeded': workersNeeded,
        'category': 'loader',
      };

  /// Смена заказчика, оплаченная тестовой картой, и на ней записанный
  /// исполнитель.
  Future<int> bookedShift() async {
    // Через Kaspi: тестовое подтверждение не просит карты.
    final (_, checkout) = await call('POST', '/api/shifts',
        token: managerToken,
        body: {...shiftBody(), 'method': 'kaspi', 'phone': '87011234567'});
    await call('POST', '/api/payments/${checkout['id']}/sandbox',
        token: managerToken, body: {});
    final shiftId = checkout['shiftId'] as int;
    final (_, applied) =
        await call('POST', '/api/shifts/$shiftId/apply', token: workerToken);
    expect(applied['result'], 'ok');
    return shiftId;
  }

  group('смены', () {
    test('отрицательную ставку и ноль мест сервер не примет', () async {
      final (rate, rateError) = await call('POST', '/api/shifts',
          token: managerToken, body: shiftBody(hourlyRate: -100000));
      expect(rate, 400);
      expect(rateError['error'], contains('Ставка'));

      final (workers, _) = await call('POST', '/api/shifts',
          token: managerToken, body: shiftBody(workersNeeded: 0));
      expect(workers, 400);
    });

    test('порог рейтинга — от одного до пяти', () async {
      final (tooHigh, _) = await call('POST', '/api/shifts',
          token: managerToken, body: {...shiftBody(), 'minRating': 6});
      expect(tooHigh, 400);
      final (ok, _) = await call('POST', '/api/shifts',
          token: managerToken, body: {...shiftBody(), 'minRating': 4.5});
      expect(ok, 200);
    });

    test('смену в прошлом не создать', () async {
      final (code, json) = await call('POST', '/api/shifts',
          token: managerToken,
          body: shiftBody(
              workDate: DateTime.now().subtract(const Duration(days: 2))));
      expect(code, 400);
      expect(json['error'], contains('прошло'));
    });

    test('компания берётся из профиля, а не из запроса', () async {
      final (_, checkout) = await call('POST', '/api/shifts',
          token: managerToken, body: shiftBody(company: 'Zara'));
      final (_, shift) = await call('GET', '/api/shifts/${checkout['shiftId']}',
          token: managerToken);
      expect(shift['company'], 'Magnum');
    });

    test('кривой запрос — ошибка запроса, а не падение сервера', () async {
      final (code, _) = await call('POST', '/api/shifts',
          token: managerToken,
          body: {...shiftBody(), 'workDate': 'вчера', 'hourlyRate': 'много'});
      expect(code, 400);
    });

    test('список записавшихся видит только заказчик смены', () async {
      final shiftId = await bookedShift();

      final (_, own) = await call('GET', '/api/shifts/$shiftId/applicants',
          token: managerToken);
      expect(own, hasLength(1));

      // Телефоны и имена людей не утекают ни к исполнителю, ни к чужому
      // заказчику.
      for (final token in [workerToken, strangerToken]) {
        final (_, list) = await call(
            'GET', '/api/shifts/$shiftId/applicants',
            token: token);
        expect(list, isEmpty);
      }
    });

    test('чужой заказчик не оценит исполнителя', () async {
      final shiftId = await bookedShift();
      final (code, json) = await call('POST', '/api/shifts/$shiftId/rate',
          token: strangerToken, body: {'workerId': workerId, 'rating': 1});
      expect(code, 400);
      expect(json['error'], contains('своей смены'));
    });

    test('оценку ставят только за подтверждённый выход', () async {
      final shiftId = await bookedShift();
      // Смена завтра — выход ещё не подтверждён.
      final (code, _) = await call('POST', '/api/shifts/$shiftId/rate',
          token: managerToken, body: {'workerId': workerId, 'rating': 1});
      expect(code, 400);
    });

    test('любимые исполнители — только у заказчика и только свои', () async {
      final shiftId = await bookedShift();
      // Исполнителю этот адрес не положен.
      final (worker, _) = await call('GET', '/api/favorites', token: workerToken);
      expect(worker, 403);
      // Человек ещё не отработал у заказчика — в любимые рано.
      final (_, early) = await call('POST', '/api/favorites/$workerId',
          token: managerToken, body: {'favorite': true});
      expect(early['result'], 'notMine');
      // А чужой заказчик и подавно.
      final (_, stranger) = await call('POST', '/api/favorites/$workerId',
          token: strangerToken, body: {'favorite': true});
      expect(stranger['result'], 'notMine');
      expect(shiftId, isPositive);
    });

    test('код отметки не выдают никому, кроме заказчика смены', () async {
      final shiftId = await bookedShift();
      final (own, body) =
          await call('GET', '/api/shifts/$shiftId/code', token: managerToken);
      expect(own, 200);
      expect(body['code'], hasLength(4));
      for (final token in [workerToken, strangerToken]) {
        final (code, _) =
            await call('GET', '/api/shifts/$shiftId/code', token: token);
        expect(code, 403);
      }
    });

    test('подписка на компанию видна на её странице', () async {
      await bookedShift(); // у Magnum есть смена
      final (code, _) = await call('POST', '/api/companies/Magnum/follow',
          token: workerToken, body: {'follow': true});
      expect(code, 200);
      final (_, info) =
          await call('GET', '/api/companies/Magnum', token: workerToken);
      expect(info['isFollowed'], isTrue);
      // Свою запись человек видит в ближайших сменах компании.
      expect(info['upcoming'], isNotEmpty);
    });

    test('отзыв о компании — только от того, кто у неё работал', () async {
      final shiftId = await bookedShift();
      final (code, _) = await call('POST', '/api/shifts/$shiftId/review',
          token: strangerToken, body: {'rating': 1});
      expect(code, 400);
    });
  });

  group('поддержка и документы', () {
    test('чужое обращение не прочитать и не дописать', () async {
      final (_, created) = await call('POST', '/api/support/tickets',
          token: workerToken,
          body: {'subject': 'Выплата', 'message': 'Мой номер карты…'});
      final id = created['id'];

      final (own, messages) = await call(
          'GET', '/api/support/tickets/$id/messages',
          token: workerToken);
      expect(own, 200);
      expect(messages, hasLength(1));

      final (read, _) = await call('GET', '/api/support/tickets/$id/messages',
          token: strangerToken);
      expect(read, 400);
      final (write, _) = await call(
          'POST', '/api/support/tickets/$id/messages',
          token: strangerToken, body: {'text': 'Здравствуйте, это банк'});
      expect(write, 400);
    });

    test('документ одобряет только оператор — ни владелец, ни чужой',
        () async {
      await call('POST', '/api/documents', token: workerToken, body: {
        'type': 'medical_book',
        'number': 'МК-1',
        'expiresAt': DateTime.now().add(const Duration(days: 90)).toIso8601String(),
      });
      final (_, docs) = await call('GET', '/api/documents', token: workerToken);
      final docId = docs.single['id'];

      // Старого адреса самопроверки больше нет.
      for (final token in [workerToken, strangerToken]) {
        final (code, _) = await call('POST', '/api/documents/$docId/review',
            token: token, body: {'approved': true});
        expect(code, 404);
      }
      // Служебный — без ключа закрыт.
      final (noKey, _) = await call(
          'POST', '/api/admin/documents/$docId/review',
          token: workerToken, body: {'approved': true});
      expect(noKey, 403);
      final (_, still) = await call('GET', '/api/documents', token: workerToken);
      expect(still.single['status'], 'pending');

      // Оператор со служебным ключом видит очередь и одобряет.
      final admin = Api(db, ConsoleCodeSender(), adminKey: 'secret-key');
      Future<(int, dynamic)> asAdmin(String method, String path,
          [Object? body]) async {
        final response = await admin.router.call(Request(
          method,
          Uri.parse('http://localhost$path'),
          body: body == null ? null : jsonEncode(body),
          headers: {'x-admin-key': 'secret-key'},
        ));
        final text = await response.readAsString();
        return (response.statusCode, jsonDecode(text));
      }

      final (_, queue) = await asAdmin('GET', '/api/admin/documents');
      expect(queue.single['id'], docId);
      expect(queue.single['fullName'], 'Ернар Калдыбеков');
      final (ok, _) = await asAdmin(
          'POST', '/api/admin/documents/$docId/review', {'approved': true});
      expect(ok, 200);
      final (_, after) = await call('GET', '/api/documents', token: workerToken);
      expect(after.single['status'], 'approved');
    });

    test('документы — только известных типов, санкнижка — со сроком',
        () async {
      final (unknown, _) = await call('POST', '/api/documents',
          token: workerToken, body: {'type': 'diploma', 'number': '1'});
      expect(unknown, 400);
      final (noDate, _) = await call('POST', '/api/documents',
          token: workerToken, body: {'type': 'medical_book', 'number': '1'});
      expect(noDate, 400);
    });
  });

  group('вход по коду', () {
    test('старый токен больше не пускает', () async {
      final (fresh, _) = await call('GET', '/api/me', token: workerToken);
      expect(fresh, 200);

      // Токену четыре месяца.
      await (db.update(db.authTokenRows)
            ..where((t) => t.token.equals(AuthService.hashToken(workerToken))))
          .write(AuthTokenRowsCompanion(
        createdAt: Value(DateTime.now().subtract(const Duration(days: 120))),
      ));
      final (stale, _) = await call('GET', '/api/me', token: workerToken);
      expect(stale, 401);
    });

    test('в базе лежит отпечаток токена, а не сам токен', () async {
      final rows = await db.select(db.authTokenRows).get();
      expect(rows.map((r) => r.token), isNot(contains(workerToken)));
      expect(rows.map((r) => r.token),
          contains(AuthService.hashToken(workerToken)));

      // Утёкший из базы отпечаток за токен не сходит.
      final (status, _) = await call('GET', '/api/me',
          token: AuthService.hashToken(workerToken));
      expect(status, 401);
    });

    test('токены, записанные как есть, переводятся без выхода из аккаунта',
        () async {
      // Так токен лежал до перехода на отпечатки.
      const legacy = 'AbCdEfGhIjKlMnOpQrStUvWxYz012345';
      await db.into(db.authTokenRows).insert(AuthTokenRowsCompanion.insert(
            token: legacy,
            email: 'worker@example.kz',
            userId: Value(workerId),
            createdAt: DateTime.now(),
          ));

      final auth = AuthService(db, ConsoleCodeSender());
      expect(await auth.hashLegacyTokens(), 1);
      expect(await auth.hashLegacyTokens(), 0, reason: 'повтор ничего не портит');

      final stored = await db.select(db.authTokenRows).get();
      expect(stored.map((r) => r.token), isNot(contains(legacy)));
      final (status, _) = await call('GET', '/api/me', token: legacy);
      expect(status, 200);
    });

    test('старый токен, записанный после перевода, переводится при входе',
        () async {
      const legacy = 'ZyXwVuTsRqPoNmLkJiHgFeDcBa543210';
      await db.into(db.authTokenRows).insert(AuthTokenRowsCompanion.insert(
            token: legacy,
            email: 'worker@example.kz',
            userId: Value(workerId),
            createdAt: DateTime.now(),
          ));

      final (status, _) = await call('GET', '/api/me', token: legacy);
      expect(status, 200);
      final stored = await db.select(db.authTokenRows).get();
      expect(stored.map((r) => r.token), isNot(contains(legacy)));
    });

    test('после трёх попыток код не подойдёт, даже верный', () async {
      final auth = AuthService(db, ConsoleCodeSender());
      await auth.requestCode('worker@example.kz');
      // Код в базе хранится хэшем — подставим свой, известный тесту.
      await (db.update(db.authCodeRows)
            ..where((c) => c.email.equals('worker@example.kz')))
          .write(AuthCodeRowsCompanion(
        codeHash: Value(auth.hashForTest('worker@example.kz', '123456')),
      ));

      for (var i = 0; i < AuthService.maxAttempts; i++) {
        await expectLater(
          auth.verifyCode('worker@example.kz', '000000'),
          throwsA(isA<AuthError>()),
        );
      }
      await expectLater(
        auth.verifyCode('worker@example.kz', '123456'),
        throwsA(isA<AuthError>()),
      );
    });

    test('одновременные попытки считаются все до одной', () async {
      final auth = AuthService(db, ConsoleCodeSender());
      await auth.requestCode('worker@example.kz');
      await (db.update(db.authCodeRows)
            ..where((c) => c.email.equals('worker@example.kz')))
          .write(AuthCodeRowsCompanion(
        codeHash: Value(auth.hashForTest('worker@example.kz', '123456')),
      ));

      // Десять неверных попыток разом — раньше каждая видела «ноль
      // попыток», и предел не держал перебора.
      await Future.wait([
        for (var i = 0; i < 10; i++)
          auth
              .verifyCode('worker@example.kz', '00000$i')
              .then((_) {}, onError: (_) {}),
      ]);
      await expectLater(
        auth.verifyCode('worker@example.kz', '123456'),
        throwsA(isA<AuthError>()),
      );
    });

    test('верный код с первой попытки впускает, но только один раз',
        () async {
      final auth = AuthService(db, ConsoleCodeSender());
      await auth.requestCode('worker@example.kz');
      await (db.update(db.authCodeRows)
            ..where((c) => c.email.equals('worker@example.kz')))
          .write(AuthCodeRowsCompanion(
        codeHash: Value(auth.hashForTest('worker@example.kz', '123456')),
      ));

      expect(await auth.verifyCode('worker@example.kz', '123456'),
          'worker@example.kz');
      await expectLater(
        auth.verifyCode('worker@example.kz', '123456'),
        throwsA(isA<AuthError>()),
      );
    });
  });

  test('знакомых заказчика видит только заказчик — свои', () async {
    final (worker, _) =
        await call('GET', '/api/manager/known-workers', token: workerToken);
    expect(worker, 403);
    final (anon, _) = await call('GET', '/api/manager/known-workers');
    expect(anon, 401);
    final (code, list) =
        await call('GET', '/api/manager/known-workers', token: managerToken);
    expect(code, 200);
    expect(list, isEmpty);
  });

  test('санкнижка из запроса доходит до смены и проверяется при записи',
      () async {
    final (_, checkout) = await call('POST', '/api/shifts',
        token: managerToken,
        body: {
          ...shiftBody(),
          'method': 'kaspi',
          'phone': '87011234567',
          'needsMedicalBook': true,
        });
    await call('POST', '/api/payments/${checkout['id']}/sandbox',
        token: managerToken, body: {});
    final shiftId = checkout['shiftId'] as int;
    final (_, shift) = await call('GET', '/api/public/shifts/$shiftId');
    expect(shift['needsMedicalBook'], isTrue);
    final (_, applied) =
        await call('POST', '/api/shifts/$shiftId/apply', token: workerToken);
    expect(applied['result'], 'needsMedicalBook');
  });

  test('приглашённых считает только свой аккаунт', () async {
    final (anon, _) = await call('GET', '/api/me/referrals');
    expect(anon, 401);
    await DbAuthRepository(db).register(
      phone: '77000000009',
      fullName: 'Друг Исполнителя',
      city: 'Алматы',
      acceptedTermsVersion: kTermsVersion,
      referredBy: workerId,
    );
    final (code, mine) =
        await call('GET', '/api/me/referrals', token: workerToken);
    expect(code, 200);
    expect(mine, {'joined': 1, 'worked': 0});
    final (_, other) =
        await call('GET', '/api/me/referrals', token: managerToken);
    expect(other, {'joined': 0, 'worked': 0});
  });

  group('гость без входа', () {
    test('видит оплаченные смены своего города, но не чужие отклики',
        () async {
      final shiftId = await bookedShift();
      // Неоплаченная смена гостю не видна — для всех, кроме заказчика,
      // её ещё нет.
      final (_, unpaid) = await call('POST', '/api/shifts',
          token: managerToken,
          body: {...shiftBody(), 'method': 'kaspi', 'phone': '87011234567'});

      final (code, list) = await call('GET', '/api/public/shifts?city=%D0%90%D0%BB%D0%BC%D0%B0%D1%82%D1%8B');
      expect(code, 200);
      final ids = [for (final s in list as List) s['id']];
      expect(ids, contains(shiftId));
      expect(ids, isNot(contains(unpaid['shiftId'])));
      final shown = list.firstWhere((s) => s['id'] == shiftId);
      // Записанный исполнитель есть в счётчике, но не в «моём статусе».
      expect(shown['workersHired'], 1);
      expect(shown['myStatus'], isNull);

      final (one, single) = await call('GET', '/api/public/shifts/$shiftId');
      expect(one, 200);
      expect(single['title'], 'Услуги грузчика');
      final (hidden, _) =
          await call('GET', '/api/public/shifts/${unpaid['shiftId']}');
      expect(hidden, 404);
    });

    test('отменённую смену гость не видит, номера заказчика — тоже',
        () async {
      final shiftId = await bookedShift();
      final (_, shown) = await call('GET', '/api/public/shifts/$shiftId');
      expect(shown.containsKey('createdBy'), isFalse);
      await call('POST', '/api/shifts/$shiftId/cancel-shift',
          token: managerToken);
      final (gone, _) = await call('GET', '/api/public/shifts/$shiftId');
      expect(gone, 404);
    });

    test('частые запросы без входа упираются в предел', () async {
      final limited = Api(db, ConsoleCodeSender(),
          publicLimit: RateLimiter(
              limit: 2, window: const Duration(minutes: 1)));
      Future<int> hit() async => (await limited.router.call(Request(
              'GET',
              Uri.parse('http://localhost/api/public/shifts?city=Moscow'))))
          .statusCode;
      expect(await hit(), 400);
      expect(await hit(), 400);
      expect(await hit(), 429);
    });

    test('город — только из списка; в другом городе чужих смен нет',
        () async {
      await bookedShift();
      final (bad, error) = await call('GET', '/api/public/shifts?city=Moscow');
      expect(bad, 400);
      expect(error['error'], isNotEmpty);
      final (_, astana) = await call(
          'GET', '/api/public/shifts?city=%D0%90%D1%81%D1%82%D0%B0%D0%BD%D0%B0');
      expect(astana, isEmpty);
    });
  });
}
