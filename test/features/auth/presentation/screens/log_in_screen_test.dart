import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/auth/presentation/providers/auth_form_providers.dart';
import 'package:ishara_app/features/auth/presentation/providers/fake_session_provider.dart';
import 'package:ishara_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/log_in_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';
import 'auth_screen_harness.dart';

const passwordError = 'Incorrect password. Try again.';

void main() {
  for (final mode in themeModes) {
    testWidgets('renders the Figma error state in ${mode.name}', (
      tester,
    ) async {
      await pumpAuthScreen(
        tester,
        const LogInScreen(),
        mode: mode,
        overrides: [
          logInPasswordErrorProvider.overrideWithValue(passwordError),
        ],
      );
      final c = tokensFor(mode);

      expect(textColor(tester, 'Welcome back'), c.textPrimary);
      expect(
        textColor(tester, 'Log in to keep your streak going.'),
        c.textSecondary,
      );
      expect(find.byType(IsharaTextField), findsNWidgets(2));
      expect(textColor(tester, passwordError), c.dangerText);
      expect(find.bySemanticsLabel('Forgot password?'), findsOneWidget);
      expect(find.widgetWithText(IsharaButton, 'Log in'), findsOneWidget);
      expect(find.byType(GoogleSignInButton), findsOneWidget);
      expect(
        find.bySemanticsLabel('New to Ishara? Create account'),
        findsOneWidget,
      );
    });
  }

  testWidgets('no error by default (UI-only phase)', (tester) async {
    await pumpAuthScreen(tester, const LogInScreen());
    expect(find.text(passwordError), findsNothing);
  });

  testWidgets('fits at 1.3x text scale', (tester) async {
    await pumpAuthScreen(
      tester,
      const LogInScreen(),
      textScale: 1.3,
      overrides: [logInPasswordErrorProvider.overrideWithValue(passwordError)],
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Log in logs in and goes to Learn', (tester) async {
    final container = await pumpApp(
      tester,
      location: const LogInRoute().location,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Log in'));
    await tester.pumpAndSettle();

    expect(container.read(fakeSessionProvider), (
      loggedIn: true,
      onboardingDone: true,
    ));
    expect(currentLocation(container), const LearnRoute().location);
  });

  testWidgets('Google logs in (fake)', (tester) async {
    final container = await pumpApp(
      tester,
      location: const LogInRoute().location,
    );
    await tester.tap(find.byType(GoogleSignInButton));
    await tester.pumpAndSettle();
    expect(currentLocation(container), const LearnRoute().location);
  });

  testWidgets('Forgot password? opens the reset screen', (tester) async {
    await pumpApp(tester, location: const LogInRoute().location);
    await tester.tap(find.bySemanticsLabel('Forgot password?'));
    await tester.pumpAndSettle();
    // push keeps the base URI in currentConfiguration; check the screen.
    expect(find.byType(ForgotPasswordScreen), findsOneWidget);
  });

  testWidgets('footer link replaces Log in with Sign up', (tester) async {
    final container = await pumpApp(
      tester,
      location: const LogInRoute().location,
    );
    await tester.tap(find.bySemanticsLabel('New to Ishara? Create account'));
    await tester.pumpAndSettle();
    expect(currentLocation(container), const SignUpRoute().location);
  });
}
