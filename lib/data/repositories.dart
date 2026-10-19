import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/guest_shifts.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/data/wallet_repository.dart';

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
  final WalletRepository wallet;

  /// Смены для того, кто ещё не вошёл. null — гостю смотреть нечего
  /// (так в тестах): на экране входа нет кнопки «Посмотреть смены».
  final GuestShifts? guest;

  const AppRepositories({
    required this.shifts,
    required this.auth,
    required this.documents,
    required this.support,
    required this.wallet,
    this.guest,
  });
}
