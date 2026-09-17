import 'package:flutter/material.dart';

import '../data/session.dart';
import '../data/shift_repository.dart';
import '../shift.dart';
import '../theme/app_colors.dart';
import '../user.dart';
import '../widgets/common.dart';

/// Смены, созданные заказчиком, и кто на них записался.
class ManagerShiftsPage extends StatefulWidget {
  final AppSession session;
  final ShiftRepository repository;

  const ManagerShiftsPage({
    super.key,
    required this.session,
    required this.repository,
  });

  @override
  State<ManagerShiftsPage> createState() => _ManagerShiftsPageState();
}

class _ManagerShiftsPageState extends State<ManagerShiftsPage> {
  List<Shift>? shifts;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded =
        await widget.repository.shiftsCreatedBy(widget.session.workerId);
    if (!mounted) return;
    setState(() => shifts = loaded);
  }

  Future<void> _openApplicants(Shift shift) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ApplicantsPage(
          shift: shift,
          repository: widget.repository,
        ),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final list = shifts;

    return Scaffold(
      appBar: AppBar(title: const Text('Мои смены')),
      body: switch (list) {
        null => const Center(child: CircularProgressIndicator()),
        [] => const EmptyState(
            icon: Icons.post_add_rounded,
            title: 'Смен пока нет',
            subtitle: 'Создайте первую смену на вкладке «Создать»',
          ),
        final items => RefreshIndicator(
            onRefresh: _load,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: items.length,
              itemBuilder: (context, index) => _ManagerShiftCard(
                shift: items[index],
                onTap: () => _openApplicants(items[index]),
              ),
            ),
          ),
      },
    );
  }
}

class _ManagerShiftCard extends StatelessWidget {
  final Shift shift;
  final VoidCallback onTap;

  const _ManagerShiftCard({required this.shift, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPast = shift.workDate.isBefore(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SurfaceCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    shift.title,
                    style: text.titleMedium?.copyWith(fontSize: 15),
                  ),
                ),
                if (isPast)
                  const TagChip(text: 'Прошла')
                else if (!shift.hasFreeSlots)
                  const TagChip(text: 'Набрана', color: AppColors.brand)
                else
                  TagChip(
                    text: 'Идёт набор',
                    color: AppColors.accent,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            InfoRow(
              icon: Icons.calendar_today_rounded,
              text: '${shift.workDate.day} '
                  '${monthsShort[shift.workDate.month - 1]} · '
                  '${formatTime(shift.startMinutes)}—'
                  '${formatTime(shift.endMinutes)}',
            ),
            InfoRow(
              icon: Icons.payments_outlined,
              text: '${formatMoney(shift.totalPay)} за смену · '
                  '${formatMoney(shift.hourlyRate)}/ч',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: shift.workersHired / shift.workersNeeded,
                      minHeight: 8,
                      backgroundColor:
                          isDark ? AppColors.darkBorder : AppColors.border,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.brand),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${shift.workersHired} / ${shift.workersNeeded}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.group_outlined,
                    size: 15, color: AppColors.muted),
                const SizedBox(width: 6),
                Text(
                  'Посмотреть записавшихся',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brand,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded,
                    size: 18, color: AppColors.muted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Кто записался на смену.
class _ApplicantsPage extends StatefulWidget {
  final Shift shift;
  final ShiftRepository repository;

  const _ApplicantsPage({required this.shift, required this.repository});

  @override
  State<_ApplicantsPage> createState() => _ApplicantsPageState();
}

class _ApplicantsPageState extends State<_ApplicantsPage> {
  List<AppUser>? people;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await widget.repository.applicantsFor(widget.shift.id);
    if (!mounted) return;
    setState(() => people = loaded);
  }

  @override
  Widget build(BuildContext context) {
    final list = people;

    return Scaffold(
      appBar: AppBar(title: const Text('Записались')),
      body: switch (list) {
        null => const Center(child: CircularProgressIndicator()),
        [] => const EmptyState(
            icon: Icons.person_search_rounded,
            title: 'Пока никто не записался',
            subtitle: 'Смена опубликована — исполнители её видят',
          ),
        final items => ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: items.length,
            itemBuilder: (context, index) => _ApplicantTile(user: items[index]),
          ),
      },
    );
  }
}

class _ApplicantTile extends StatelessWidget {
  final AppUser user;

  const _ApplicantTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.brand, AppColors.brandDark],
                ),
              ),
              child: Text(
                user.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 14, color: AppColors.accent),
                      const SizedBox(width: 3),
                      Text(
                        user.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        user.isVerified ? 'Верифицирован' : 'Без проверки',
                        style: TextStyle(
                          fontSize: 12,
                          color: user.isVerified
                              ? AppColors.brand
                              : AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
