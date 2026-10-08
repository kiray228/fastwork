import 'dart:io';

import 'package:fastwork/data/app_preferences.dart';
import 'package:fastwork/data/repositories.dart';
import 'package:fastwork/data/session.dart';
import 'package:fastwork/l10n/strings.dart';
import 'package:fastwork/main.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/fake_shift_repository.dart';
import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_core/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/clock.dart';

/// Переводы: ни одной русской надписи мимо словаря.
///
/// Забыть вынести строку в словарь легко, а заметить трудно: по-русски
/// экран выглядит правильно, и только человек с казахским или английским
/// увидит посреди своего языка русскую фразу. Поэтому проверяем сам код:
/// кириллица в строках допустима только в словарях (`lib/l10n/`).
void main() {
  test('русские строки живут только в словарях', () {
    final offenders = <String>[];
    // Строка в одинарных или в двойных кавычках.
    final literal = RegExp(r"'(?:[^'\\]|\\.)*'" '|' r'"(?:[^"\\]|\\.)*"');
    final cyrillic = RegExp('[А-Яа-яЁё]');

    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.replaceAll(r'\', '/').startsWith('lib/l10n/'));

    for (final file in files) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        final code = line.trimLeft();
        // Комментарии и отладочный вывод человек не видит.
        if (code.startsWith('//') || code.contains('debugPrint(')) continue;
        for (final match in literal.allMatches(line)) {
          if (cyrillic.hasMatch(match.group(0)!)) {
            offenders.add('${file.path}:${i + 1}: ${code.trim()}');
          }
        }
      }
    }

    expect(offenders, isEmpty,
        reason: 'Вынесите эти строки в lib/l10n/:\n${offenders.join('\n')}');
  });

  test('словари собираются для всех языков', () {
    for (final lang in Lang.values) {
      final s = S.of(lang);
      expect(s.lang, lang);
      expect(s.common.language, isNotEmpty);
    }
    expect(S.of(Lang.kk).common.language, 'Тіл');
    expect(S.of(Lang.en).common.language, 'Language');
  });

  group('смена языка', () {
    Future<AppPreferences> openApp(WidgetTester tester,
        {String? deviceLanguage}) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(420, 2200);
      addTearDown(tester.view.reset);
      addTearDown(() => appLang = Lang.ru);

      final user = AppUser(
        id: 1,
        phone: '77001234567',
        fullName: 'Ернар Калдыбеков',
        city: 'Алматы',
        rating: 4.6,
        isVerified: false,
        termsVersion: kTermsVersion,
      );
      final store = FakeShiftRepository(clock: TestClock.today().call);
      final preferences = AppPreferences(deviceLanguage: deviceLanguage);
      await tester.pumpWidget(FastworkApp(
        session: AppSession()..setUser(user),
        repos: AppRepositories(
          shifts: store,
          auth: FakeAuthRepository(signedIn: user),
          documents: FakeDocumentRepository(),
          support: FakeSupportRepository(),
          wallet: FakeWalletRepository(store),
        ),
        preferences: preferences,
      ));
      await tester.pumpAndSettle();
      return preferences;
    }

    testWidgets('язык телефона подхватывается сам', (tester) async {
      await openApp(tester, deviceLanguage: 'kk');
      expect(find.text('Менікі'), findsOneWidget);
    });

    testWidgets('незнакомый язык телефона — по-русски', (tester) async {
      await openApp(tester, deviceLanguage: 'de');
      expect(find.text('Мои'), findsOneWidget);
    });

    testWidgets('язык меняется в профиле сразу и экран остаётся на месте',
        (tester) async {
      final preferences = await openApp(tester);
      await tester.tap(find.text('Профиль').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Язык'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(preferences.language, Lang.en);
      // Всё ещё профиль — но уже по-английски, и меню тоже.
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Mine'), findsOneWidget);
      expect(find.text('Мои'), findsNothing);

      await preferences.setLanguage(Lang.kk);
      await tester.pumpAndSettle();
      expect(find.text('Тіл'), findsOneWidget);
      expect(find.text('Менікі'), findsOneWidget);
    });
  });
}
