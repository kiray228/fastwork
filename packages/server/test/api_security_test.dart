import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/database.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_server/api.dart';
import 'package:fastwork_server/auth_service.dart';
import 'package:fastwork_server/code_sender.dart';
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

    test('чужой документ не одобрить', () async {
      await call('POST', '/api/documents',
          token: workerToken, body: {'type': 'id_card', 'number': '123'});
      final (_, docs) = await call('GET', '/api/documents', token: workerToken);
      final docId = docs.single['id'];

      final (code, _) = await call('POST', '/api/documents/$docId/review',
          token: strangerToken, body: {'approved': false});
      expect(code, 400);

      final (_, after) = await call('GET', '/api/documents', token: workerToken);
      expect(after.single['status'], isNot('rejected'));
    });
  });

  group('вход по коду', () {
    test('старый токен больше не пускает', () async {
      final (fresh, _) = await call('GET', '/api/me', token: workerToken);
      expect(fresh, 200);

      // Токену четыре месяца.
      await (db.update(db.authTokenRows)
            ..where((t) => t.token.equals(workerToken)))
          .write(AuthTokenRowsCompanion(
        createdAt: Value(DateTime.now().subtract(const Duration(days: 120))),
      ));
      final (stale, _) = await call('GET', '/api/me', token: workerToken);
      expect(stale, 401);
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
}
