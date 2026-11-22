import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/auth/presentation/providers/auth_form_providers.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';
import '../../auth_test_utils.dart';
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

  group('with the mock API', () {
    Finder field(String label) => find.descendant(
      of: find.widgetWithText(IsharaTextField, label),
      matching: find.byType(TextField),
    );

    Future<void> fillAndSubmit(
      WidgetTester tester, {
      String email = 'new@ishara.test',
      String password = 'password1',
    }) async {
      await tester.enterText(field('Full name'), 'New learner');
      await tester.enterText(field('Email'), email);
      await tester.enterText(field('Password'), password);
      await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
      await settleFlow(tester);
    }

    testWidgets('Create account signs up and moves on to onboarding', (
      tester,
    ) async {
      final env = AuthTestEnv(session: SessionState.signedOut);
      final container = await pumpAuthFlow(tester, env, location: '/sign-up');
      await fillAndSubmit(tester);

      expect(container.read(sessionProvider).flags, (
        loggedIn: true,
        onboardingDone: false,
      ));
      expect(find.text(onboardingStub), findsOneWidget);
    });

    testWidgets('a taken email shows under Email', (tester) async {
      final env = AuthTestEnv(session: SessionState.signedOut);
      await pumpAuthFlow(tester, env, location: '/sign-up');
      await fillAndSubmit(tester, email: 'taken@ishara.test');
      expect(find.text(emailTakenMessage), findsOneWidget);
      expect(find.byType(SignUpScreen), findsOneWidget);
    });

    testWidgets('a short password shows the server message', (tester) async {
      final env = AuthTestEnv(session: SessionState.signedOut);
      await pumpAuthFlow(tester, env, location: '/sign-up');
      await fillAndSubmit(tester, password: 'short');
      expect(
        find.text('Use at least 8 characters for your password.'),
        findsOneWidget,
      );
    });

    testWidgets('Google signs in', (tester) async {
      final env = AuthTestEnv(session: SessionState.signedOut);
      final container = await pumpAuthFlow(tester, env, location: '/sign-up');
      await tester.tap(find.byType(GoogleSignInButton));
      await settleFlow(tester);
      expect(container.read(sessionProvider).loggedIn, isTrue);
    });

    testWidgets('footer link replaces Sign up with Log in', (tester) async {
      final env = AuthTestEnv(session: SessionState.signedOut);
      await pumpAuthFlow(tester, env, location: '/sign-up');
      await tester.tap(
        find.bySemanticsLabel('Already have an account? Log in'),
      );
      await tester.pumpAndSettle();
      expect(routerLocation(tester), '/log-in');
    });
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
