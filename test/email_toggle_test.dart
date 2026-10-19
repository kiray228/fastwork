import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastwork/data/repositories.dart';
import 'package:fastwork/data/session.dart';
import 'package:fastwork/main.dart';
import 'package:fastwork_core/data/auth_repository.dart';
import 'package:fastwork_core/data/fake_shift_repository.dart';
import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/terms.dart';
import 'package:fastwork_core/user.dart';

void main() {
  const withEmail = AppUser(
    id: 1,
    phone: '77001234567',
    email: 'worker@example.kz',
    fullName: 'Ернар Калдыбеков',
    city: 'Алматы',
    rating: 4.5,
    isVerified: false,
    termsVersion: kTermsVersion,
  );

  Future<AppSession> open(WidgetTester tester, AppUser user) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(420, 2600);
    addTearDown(tester.view.reset);
    final session = AppSession()..setUser(user);
    final shifts = FakeShiftRepository();
    await tester.pumpWidget(FastworkApp(
      session: session,
      repos: AppRepositories(
        shifts: shifts,
        auth: FakeAuthRepository(signedIn: user),
        documents: FakeDocumentRepository(),
        support: FakeSupportRepository(),
        wallet: FakeWalletRepository(shifts),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Профиль'));
    await tester.pumpAndSettle();
    return session;
  }

  testWidgets('письма о сменах выключаются в профиле', (tester) async {
    final session = await open(tester, withEmail);
    final toggle = find.widgetWithText(SwitchListTile, 'Письма о сменах');
    await tester.ensureVisible(toggle);
    expect(tester.widget<SwitchListTile>(toggle).value, isTrue);

    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(session.user!.emailNotices, isFalse);
    expect(tester.widget<SwitchListTile>(toggle).value, isFalse);
  });

  testWidgets('без почты переключателя нет', (tester) async {
    await open(
        tester,
        const AppUser(
          id: 1,
          phone: '77001234567',
          fullName: 'Ернар Калдыбеков',
          city: 'Алматы',
          rating: 4.5,
          isVerified: false,
          termsVersion: kTermsVersion,
        ));
    expect(find.text('Письма о сменах'), findsNothing);
  });
}
