import 'package:flutter/foundation.dart';

import '../user.dart';

/// Кто сейчас пользуется приложением.
///
/// `ChangeNotifier` умеет сообщать экранам, что данные изменились —
/// вошёл другой человек, обновился рейтинг. Экраны подписываются и
/// перерисовываются сами.
class AppSession extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;
  bool get isSignedIn => _user != null;

  /// Номер текущего пользователя. 0 — никто не вошёл.
  int get workerId => _user?.id ?? 0;

  /// Рейтинг текущего пользователя — по нему решается допуск к сменам.
  double get rating => _user?.rating ?? 0;

  void setUser(AppUser? value) {
    _user = value;
    notifyListeners();
  }
}
