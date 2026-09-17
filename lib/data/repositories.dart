import 'auth_repository.dart';
import 'shift_repository.dart';
import 'support_repository.dart';

/// Все хранилища приложения в одном месте.
///
/// Без такого «свёртка» каждый экран пришлось бы принимать по четыре
/// параметра. Теперь передаётся один объект, а экран берёт из него то,
/// что ему нужно.
class AppRepositories {
  final ShiftRepository shifts;
  final AuthRepository auth;
  final DocumentRepository documents;
  final SupportRepository support;

  const AppRepositories({
    required this.shifts,
    required this.auth,
    required this.documents,
    required this.support,
  });
}
