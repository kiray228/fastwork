import 'dart:io';

import 'package:fastwork/data/session.dart';
import 'package:fastwork/shift_detail_page.dart';
import 'package:fastwork/theme/app_theme.dart';
import 'package:fastwork/widgets/shift_card.dart';
import 'package:fastwork_core/data/fake_shift_repository.dart';
import 'package:fastwork_core/shift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/clock.dart';

/// Экраны, которые раньше ломались на сбое сети или на необычном
/// состоянии смены: вечный кружок, «Записаться» на отменённой смене,
/// неоткрываемая своя смена.
void main() {
  Widget host(Widget child) =>
      MaterialApp(theme: AppTheme.light(), home: child);

  ShiftDetailPage detail(FakeShiftRepository repo, int id) => ShiftDetailPage(
        shiftId: id,
        repository: repo,
        session: AppSession(),
      );

  testWidgets('сбой сети на экране смены — ошибка и «Повторить», '
      'а не вечный кружок', (tester) async {
    final repo = _FlakyRepository();
    await tester.pumpWidget(host(detail(repo, 1)));
    await tester.pumpAndSettle();

    expect(find.text('Повторить'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    repo.working = true;
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();
    expect(find.text('Вознаграждение'), findsOneWidget);
  });

  testWidgets('на отменённой смене нет кнопки «Записаться»', (tester) async {
    final repo = FakeShiftRepository(clock: TestClock.today().call);
    expect(await repo.apply(1), isNotNull);
    await repo.cancelShift(1);

    await tester.pumpWidget(host(detail(repo, 1)));
    await tester.pumpAndSettle();

    expect(find.text('Смена отменена заказчиком'), findsOneWidget);
    expect(find.text('Записаться на смену'), findsNothing);
  });

  testWidgets('свою смену можно открыть, даже если рейтинг упал ниже порога',
      (tester) async {
    final now = DateTime.now();
    final mine = Shift(
      id: 1,
      workDate: DateTime(now.year, now.month, now.day + 1),
      title: 'Услуги грузчика',
      company: 'Magnum',
      address: 'ул. Абая, 1',
      startMinutes: 600,
      endMinutes: 1260,
      hourlyRate: 110000,
      workersNeeded: 2,
      workersHired: 1,
      minRating: 4.5,
      myStatus: 'active',
    );
    var opened = 0;
    await tester.pumpWidget(host(Scaffold(
      body: ListView(children: [
        ShiftCard(shift: mine, userRating: 3.9, onTap: () => opened++),
      ]),
    )));
    await tester.tap(find.text('Услуги грузчика'));
    expect(opened, 1, reason: 'отметиться и отменить запись должно быть можно');

    // Чужую смену с порогом выше рейтинга по-прежнему не открыть.
    await tester.pumpWidget(host(Scaffold(
      body: ListView(children: [
        ShiftCard(
          shift: mine.copyWith(clearMyStatus: true),
          userRating: 3.9,
          onTap: () => opened++,
        ),
      ]),
    )));
    await tester.tap(find.text('Услуги грузчика'), warnIfMissed: false);
    expect(opened, 1);
  });
}

/// Хранилище, у которого сначала «нет сети».
class _FlakyRepository extends FakeShiftRepository {
  bool working = false;

  _FlakyRepository() : super(clock: TestClock.today().call);

  @override
  Future<Shift?> shiftById(int id) {
    if (!working) {
      throw const SocketException('Failed host lookup: api.fastwork.kz');
    }
    return super.shiftById(id);
  }
}
