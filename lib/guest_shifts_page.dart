import 'package:flutter/material.dart';

import 'package:fastwork_core/data/guest_shifts.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/user.dart';
import 'data/app_preferences.dart';
import 'l10n/strings.dart';
import 'shift_detail_page.dart';
import 'shifts_page.dart' show DayHeading;
import 'theme/app_colors.dart';
import 'widgets/async_state.dart';
import 'widgets/common.dart';
import 'widgets/nav.dart';
import 'widgets/shift_card.dart';

/// Лента для того, кто ещё не вошёл.
///
/// Смены выбранного города на две недели — одним списком, по дням. Сверху
/// плашка: смотреть можно сейчас, вход нужен только для записи. Открыл
/// смену и нажал «Войти и записаться» — после входа приложение откроет
/// именно её, а не пустую ленту.
class GuestShiftsPage extends StatefulWidget {
  final GuestShifts guest;

  /// Где запомнить город. null — только пока открыт экран (в тестах).
  final AppPreferences? preferences;

  /// Человек решил войти. Номер смены — если решил на её экране.
  final ValueChanged<int?> onSignIn;

  const GuestShiftsPage({
    super.key,
    required this.guest,
    required this.onSignIn,
    this.preferences,
  });

  @override
  State<GuestShiftsPage> createState() => _GuestShiftsPageState();
}

class _GuestShiftsPageState extends State<GuestShiftsPage> {
  late String city = _initialCity();
  Async<List<Shift>> state = const Loading();

  /// Номер запроса: быстро переключили город — показываем ответ про
  /// последний, а не тот, что пришёл позже.
  int _loadSeq = 0;

  String _initialCity() {
    final saved = widget.preferences?.guestCity;
    return saved != null && kCities.contains(saved) ? saved : kCities.first;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final seq = ++_loadSeq;
    final result = await load(() => widget.guest.upcoming(city));
    if (!mounted || seq != _loadSeq) return;
    setState(() => state = result);
  }

  void _pickCity(String value) {
    if (value == city) return;
    setState(() {
      city = value;
      state = const Loading();
    });
    widget.preferences?.setGuestCity(value);
    _load();
  }

  void _open(Shift shift) {
    Navigator.of(context).push(
      appRoute(
        ShiftDetailPage.guest(
          shiftId: shift.id,
          guest: widget.guest,
          onSignIn: () => widget.onSignIn(shift.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.feed.guestTitle(tr.core.city(city))),
        actions: [
          PopupMenuButton<String>(
            tooltip: tr.feed.guestCity,
            icon: const Icon(Icons.location_city_rounded),
            initialValue: city,
            onSelected: _pickCity,
            itemBuilder: (context) => [
              for (final c in kCities)
                PopupMenuItem(value: c, child: Text(tr.core.city(c))),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            _SignInBanner(onSignIn: () => widget.onSignIn(null)),
            const SizedBox(height: 16),
            ..._list(),
          ],
        ),
      ),
    );
  }

  List<Widget> _list() => switch (state) {
        Loading() => const [
            Padding(
              padding: EdgeInsets.only(top: 48),
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        Failed(:final error) => [
            ErrorView(message: describeError(error), onRetry: _retry),
          ],
        Ready(:final value) when value.isEmpty => [
            EmptyState(
              icon: Icons.event_available_rounded,
              title: tr.feed.guestEmptyTitle,
              subtitle: tr.feed.guestEmptySubtitle,
            ),
          ],
        Ready(:final value) => [
            for (final (index, shift) in value.indexed) ...[
              if (index == 0 ||
                  !isSameDay(value[index - 1].workDate, shift.workDate))
                DayHeading(date: shift.workDate),
              ShiftCard(shift: shift, onTap: () => _open(shift)),
            ],
          ],
      };

  void _retry() {
    setState(() => state = const Loading());
    _load();
  }
}

/// Плашка над лентой: смотреть — сейчас, вход — для записи.
class _SignInBanner extends StatelessWidget {
  final VoidCallback onSignIn;

  const _SignInBanner({required this.onSignIn});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      child: Row(
        children: [
          const Icon(Icons.visibility_outlined, color: AppColors.brand),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tr.feed.guestBanner,
              style: const TextStyle(fontSize: 13, height: 1.35),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onSignIn,
            // В теме кнопки во всю ширину — здесь она рядом с текстом.
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 40),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text(tr.feed.guestSignIn),
          ),
        ],
      ),
    );
  }
}
