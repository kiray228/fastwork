import '../shift.dart';
import '../user.dart';
import 'current_user.dart';
import 'shift_repository.dart';

/// Смены для того, кто ещё не вошёл.
///
/// Раньше без входа приложение не показывало ничего: первое, что видел
/// человек, — просьба оставить почту. Даже по ссылке на смену от друга
/// сначала регистрация, а уже потом — что за смена и сколько платят.
/// Многие на этом закрывали страницу. Теперь сначала видно, на что
/// записываться, а вход нужен только для самой записи.
///
/// Только чтение и только то, что и так видно в ленте любому
/// исполнителю: ни откликов, ни переписки, ни чужих имён.
abstract class GuestShifts {
  /// Смены города на две недели вперёд, на которые ещё можно записаться.
  Future<List<Shift>> upcoming(String city);

  /// Одна смена — для ссылки от друга. null — нет такой или ещё не
  /// оплачена.
  Future<Shift?> shiftById(int id);
}

/// На сколько дней вперёд показывать гостю — столько же, сколько полоса
/// дат в ленте.
const kGuestDays = 14;

/// Больше смен гостю не нужно: ему посмотреть, что здесь бывает, а не
/// листать до конца. Заодно ответ сервера не растёт с числом смен.
const kGuestLimit = 60;

/// Гость: никого нет, есть только выбранный город.
class GuestCity implements CurrentUser {
  @override
  final String city;

  const GuestCity(this.city);

  @override
  AppUser? get user => null;

  @override
  int get workerId => 0;

  @override
  double get rating => 0;
}

/// Ближайшие смены одним списком — по дням, начиная с сегодняшнего.
///
/// Общее для сервера и телефона без сервера: оба спрашивают своё
/// хранилище так же, как лента на вкладке «Все дни».
Future<List<Shift>> upcomingShifts(
  ShiftRepository repository,
  DateTime now, {
  int days = kGuestDays,
  int limit = kGuestLimit,
}) async {
  final today = DateTime(now.year, now.month, now.day);
  final withShifts = await repository.daysWithShifts();
  final ahead = [
    for (var i = 0; i < days; i++)
      if (withShifts.contains(DateTime(today.year, today.month, today.day + i)))
        DateTime(today.year, today.month, today.day + i),
  ];
  final perDay = await Future.wait(ahead.map(repository.shiftsOn));
  final all = [for (final list in perDay) ...list];
  return all.length > limit ? all.sublist(0, limit) : all;
}

/// Гостевые смены поверх обычного хранилища: для каждого города —
/// хранилище от лица гостя из этого города.
class RepositoryGuestShifts implements GuestShifts {
  final ShiftRepository Function(String city) forCity;
  final DateTime Function() clock;

  RepositoryGuestShifts(this.forCity, {DateTime Function()? clock})
      : clock = clock ?? DateTime.now;

  @override
  Future<List<Shift>> upcoming(String city) =>
      upcomingShifts(forCity(city), clock());

  // Город для одной смены не важен: её ищут по номеру.
  //
  // Отменённую и уже прошедшую гостю не показываем: номера смен идут
  // подряд, и иначе без входа можно было бы выкачать всю историю —
  // компании, адреса, оплату.
  @override
  Future<Shift?> shiftById(int id) async {
    final shift = await forCity('').shiftById(id);
    if (shift == null || shift.isCancelled) return null;
    if (!clock().isBefore(shift.endsAt)) return null;
    return shift;
  }
}
