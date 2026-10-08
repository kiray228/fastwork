import 'dart:io';

import 'package:fastwork/l10n/strings.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
