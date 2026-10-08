// Надписи приложения на трёх языках.
//
// Словарь разбит по разделам — лента, смена, кошелёк, кабинет заказчика…
// Так его проще читать и переводить, и никто не правит один огромный файл.
// Всё, что говорит ядро (даты, окончания, категории, ошибки), — в
// `fastwork_core/l10n/core_strings.dart`, оно доступно как `tr.core`.
//
// Пользоваться так: `Text(tr.feed.title)`. `tr` — словарь текущего языка;
// сменили язык в профиле — приложение перерисовалось, и `tr` уже другой.

import 'package:fastwork_core/l10n/core_strings.dart';
import 'package:fastwork_core/lang.dart';

import 'common_strings.dart';
import 'feed_strings.dart';
import 'shift_strings.dart';
import 'manager_strings.dart';
import 'wallet_strings.dart';
import 'profile_strings.dart';
import 'auth_strings.dart';
import 'stories_strings.dart';

export 'package:fastwork_core/l10n/core_strings.dart' show coreTr;
export 'package:fastwork_core/lang.dart' show Lang, appLang;

class S {
  final Lang lang;
  final CoreStrings core;
  final CommonStrings common;
  final FeedStrings feed;
  final ShiftStrings shift;
  final ManagerStrings manager;
  final WalletStrings wallet;
  final ProfileStrings profile;
  final AuthStrings auth;
  final StoriesStrings stories;

  S._(this.lang)
      : core = CoreStrings.of(lang),
        common = CommonStrings.of(lang),
        feed = FeedStrings.of(lang),
        shift = ShiftStrings.of(lang),
        manager = ManagerStrings.of(lang),
        wallet = WalletStrings.of(lang),
        profile = ProfileStrings.of(lang),
        auth = AuthStrings.of(lang),
        stories = StoriesStrings.of(lang);

  static final _cache = <Lang, S>{};

  /// Словарь для языка. Собирается один раз и дальше берётся готовый.
  static S of(Lang lang) => _cache.putIfAbsent(lang, () => S._(lang));
}

/// Словарь языка, на котором приложение сейчас говорит с человеком.
S get tr => S.of(appLang);
