import 'package:flutter/foundation.dart';

import 'package:fastwork_core/user.dart';
import 'package:fastwork_core/data/current_user.dart';

/// Кто сейчас пользуется приложением.
///
/// `ChangeNotifier` умеет сообщать экранам, что данные изменились —
/// вошёл другой человек, обновился рейтинг. Экраны подписываются и
/// перерисовываются сами.
class AppSession extends ChangeNotifier implements CurrentUser {
  AppUser? _user;

  @override
  AppUser? get user => _user;
  bool get isSignedIn => _user != null;

  /// Номер текущего пользователя. 0 — никто не вошёл.
  @override
  int get workerId => _user?.id ?? 0;

  /// Рейтинг текущего пользователя — по нему решается допуск к сменам.
  @override
  double get rating => _user?.rating ?? 0;

  /// Город текущего пользователя — по нему фильтруется лента.
  @override
  String get city => _user?.city ?? '';

  void setUser(AppUser? value) {
    _user = value;
    notifyListeners();
  }
}
