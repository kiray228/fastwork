import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/user.dart';
import 'l10n/strings.dart';
import 'links.dart';
import 'theme/app_colors.dart';
import 'widgets/common.dart';

/// «Позовите друзей»: личная ссылка и сколько людей по ней пришло.
///
/// Подработку чаще всего находят через знакомых: «я тут работаю, платят
/// вовремя». Ссылка открывает приложение сразу на ленте — смены видно и
/// без входа, — а при регистрации друга запоминается, кто его позвал.
/// Человек видит, сколько друзей пришло и сколько уже вышли на смену.
class InviteFriendsCard extends StatefulWidget {
  final AppUser user;
  final ShiftRepository repository;

  const InviteFriendsCard({
    super.key,
    required this.user,
    required this.repository,
  });

  @override
  State<InviteFriendsCard> createState() => _InviteFriendsCardState();
}

class _InviteFriendsCardState extends State<InviteFriendsCard> {
  ReferralStats? stats;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Узнать тихо: не узнали — карточка с подсказкой вместо чисел.
  Future<void> _load() async {
    try {
      final value = await widget.repository.referralStats();
      if (mounted) setState(() => stats = value);
    } catch (_) {
      // Ссылкой поделиться можно и без счётчика.
    }
  }

  Future<void> _copy() async {
    final text = tr.profile.inviteText('${inviteLink(widget.user.id)}');
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(tr.profile.inviteCopied),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final current = stats;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.group_add_outlined,
            title: tr.profile.inviteTitle,
          ),
          const SizedBox(height: 8),
          Text(
            current == null || current.joined == 0
                ? tr.profile.inviteHint
                : tr.profile.inviteStats(current.joined, current.worked),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.muted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _copy,
              icon: const Icon(Icons.link_rounded, size: 18),
              label: Text(tr.profile.inviteCopy),
            ),
          ),
        ],
      ),
    );
  }
}
