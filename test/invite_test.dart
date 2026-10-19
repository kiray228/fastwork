import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork/invite_card.dart';
import 'package:fastwork_core/data/fake_shift_repository.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_core/user.dart';

/// Хранилище, где по ссылке уже пришли трое, и один из них работал.
class _InvitedRepository extends FakeShiftRepository {
  final ReferralStats stats;

  _InvitedRepository(this.stats);

  @override
  Future<ReferralStats> referralStats() async => stats;
}

void main() {
  const user = AppUser(
    id: 7,
    phone: '77001234567',
    fullName: 'Ернар Калдыбеков',
    city: 'Алматы',
    rating: 4.8,
    isVerified: false,
    termsVersion: kTermsVersion,
  );

  Future<void> pump(WidgetTester tester, ReferralStats stats) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: InviteFriendsCard(
          // Новый ключ — новая карточка: счётчик читается заново.
          key: ValueKey(stats.joined),
          user: user,
          repository: _InvitedRepository(stats),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('пока никто не пришёл — подсказка, потом — счётчик',
      (tester) async {
    await pump(tester, const ReferralStats());
    expect(find.textContaining('WhatsApp или Telegram'), findsOneWidget);

    await pump(tester, const ReferralStats(joined: 3, worked: 1));
    expect(find.text('По вашей ссылке пришли: 3 · вышли на смену: 1'),
        findsOneWidget);
  });

  testWidgets('приглашение со ссылкой — в буфер обмена', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(() => tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null));

    await pump(tester, const ReferralStats());
    await tester.tap(find.text('Скопировать приглашение'));
    await tester.pumpAndSettle();

    expect(copied, contains('fastwork'));
    expect(copied, endsWith('?ref=7'));
    expect(find.textContaining('Приглашение скопировано'), findsOneWidget);
  });
}
