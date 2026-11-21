import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/auth/presentation/providers/fake_session_provider.dart';
import 'package:ishara_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';
import 'auth_screen_harness.dart';

void main() {
  for (final mode in themeModes) {
    testWidgets('renders the Figma form in ${mode.name}', (tester) async {
      await pumpAuthScreen(tester, const SignUpScreen(), mode: mode);
      final c = tokensFor(mode);

      expect(textColor(tester, 'Create your account'), c.textPrimary);
      expect(
        textColor(tester, 'Save your streak and progress across devices.'),
        c.textSecondary,
      );
      expect(find.byType(IsharaTextField), findsNWidgets(3));
      for (final label in ['Full name', 'Email', 'Password']) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.text('At least 8 characters'), findsOneWidget);
      expect(find.widgetWithText(IsharaButton, 'Create account'), findsOne);
      expect(find.text('or'), findsOneWidget);
      expect(find.byType(GoogleSignInButton), findsOneWidget);
      expect(
        find.bySemanticsLabel('Already have an account? Log in'),
        findsOneWidget,
      );
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor ?? c.bgCanvas, c.bgCanvas);
    });
  }

  testWidgets('fits at 1.3x text scale', (tester) async {
    await pumpAuthScreen(tester, const SignUpScreen(), textScale: 1.3);
    expect(tester.takeException(), isNull);
  });

  testWidgets('password field toggles visibility', (tester) async {
    await pumpAuthScreen(tester, const SignUpScreen());
    TextField password() => tester.widget<TextField>(
      find.descendant(
        of: find.widgetWithText(IsharaTextField, 'Password'),
        matching: find.byType(TextField),
      ),
    );

    expect(password().obscureText, isTrue);
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(password().obscureText, isFalse);
    expect(find.byTooltip('Hide password'), findsOneWidget);
  });

  testWidgets('Create account signs up and moves on to onboarding', (
    tester,
  ) async {
    final container = await pumpApp(
      tester,
      location: const SignUpRoute().location,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    expect(container.read(fakeSessionProvider), (
      loggedIn: true,
      onboardingDone: false,
    ));
    expect(currentLocation(container), const DailyGoalRoute().location);
  });

  testWidgets('Google logs in (fake)', (tester) async {
    final container = await pumpApp(
      tester,
      location: const SignUpRoute().location,
    );
    await tester.tap(find.byType(GoogleSignInButton));
    await tester.pumpAndSettle();
    expect(container.read(fakeSessionProvider).loggedIn, isTrue);
  });

  testWidgets('footer link replaces Sign up with Log in', (tester) async {
    final container = await pumpApp(
      tester,
      location: const SignUpRoute().location,
    );
    await tester.tap(find.bySemanticsLabel('Already have an account? Log in'));
    await tester.pumpAndSettle();
    expect(currentLocation(container), const LogInRoute().location);
  });

  testWidgets('back returns to Welcome', (tester) async {
    final container = await pumpApp(
      tester,
      location: const WelcomeRoute().location,
    );
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(SignUpScreen), findsNothing);
    expect(currentLocation(container), const WelcomeRoute().location);
  });
}
