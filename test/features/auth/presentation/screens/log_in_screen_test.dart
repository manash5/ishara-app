import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/auth/data/datasources/google_id_token_source.dart';
import 'package:ishara_app/features/auth/presentation/providers/auth_form_providers.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/log_in_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_themed.dart';
import '../../auth_test_utils.dart';
import 'auth_screen_harness.dart';

/// Shows a log-in error without calling the API.
class _FailedLogIn extends LogInForm {
  @override
  AuthFormState build() => const AuthFormState(
    error: wrongCredentialsMessage,
    errorField: AuthField.password,
  );
}

/// Stuck mid-request, to show the loading button.
class _PendingLogIn extends LogInForm {
  @override
  AuthFormState build() => const AuthFormState(pending: AuthSubmit.email);
}

Finder field(String label) => find.descendant(
  of: find.widgetWithText(IsharaTextField, label),
  matching: find.byType(TextField),
);

Future<void> fillAndLogIn(WidgetTester tester, String email) async {
  await tester.enterText(field('Email'), email);
  await tester.enterText(field('Password'), 'password1');
  await tester.tap(find.widgetWithText(FilledButton, 'Log in'));
  await settleFlow(tester);
}

void main() {
  for (final mode in themeModes) {
    testWidgets('renders the Figma error state in ${mode.name}', (
      tester,
    ) async {
      await pumpAuthScreen(
        tester,
        const LogInScreen(),
        mode: mode,
        overrides: [logInFormProvider.overrideWith(_FailedLogIn.new)],
      );
      final c = tokensFor(mode);

      expect(textColor(tester, 'Welcome back'), c.textPrimary);
      expect(
        textColor(tester, 'Log in to keep your streak going.'),
        c.textSecondary,
      );
      expect(find.byType(IsharaTextField), findsNWidgets(2));
      expect(textColor(tester, wrongCredentialsMessage), c.dangerText);
      expect(find.bySemanticsLabel('Forgot password?'), findsOneWidget);
      expect(find.widgetWithText(IsharaButton, 'Log in'), findsOneWidget);
      expect(find.byType(GoogleSignInButton), findsOneWidget);
      expect(
        find.bySemanticsLabel('New to Ishara? Create account'),
        findsOneWidget,
      );
    });
  }

  testWidgets('no error before submitting', (tester) async {
    await pumpAuthScreen(tester, const LogInScreen());
    expect(find.text(wrongCredentialsMessage), findsNothing);
  });

  testWidgets('loading: button says "Logging in…" and is disabled', (
    tester,
  ) async {
    await pumpAuthScreen(
      tester,
      const LogInScreen(),
      overrides: [logInFormProvider.overrideWith(_PendingLogIn.new)],
    );
    final button = tester.widget<IsharaButton>(
      find.widgetWithText(IsharaButton, 'Logging in…'),
    );
    expect(button.onPressed, isNull);
    expect(
      tester
          .widget<GoogleSignInButton>(find.byType(GoogleSignInButton))
          .onPressed,
      isNull,
    );
  });

  testWidgets('fits at 1.3x text scale', (tester) async {
    await pumpAuthScreen(
      tester,
      const LogInScreen(),
      textScale: 1.3,
      overrides: [logInFormProvider.overrideWith(_FailedLogIn.new)],
    );
    expect(tester.takeException(), isNull);
  });

  group('with the mock API', () {
    testWidgets('Log in signs in and goes to Learn', (tester) async {
      final env = AuthTestEnv(session: SessionState.signedOut);
      final container = await pumpAuthFlow(tester, env, location: '/log-in');
      await fillAndLogIn(tester, 'learner@ishara.test');

      expect(container.read(sessionProvider).flags, (
        loggedIn: true,
        onboardingDone: true,
      ));
      expect(find.text(learnStub), findsOneWidget);
    });

    testWidgets('wrong password shows the error and stays', (tester) async {
      final env = AuthTestEnv(session: SessionState.signedOut);
      await pumpAuthFlow(tester, env, location: '/log-in');
      await fillAndLogIn(tester, 'wrong@ishara.test');

      expect(find.text(wrongCredentialsMessage), findsOneWidget);
      expect(find.byType(LogInScreen), findsOneWidget);
    });

    testWidgets('Google signs in', (tester) async {
      final env = AuthTestEnv(session: SessionState.signedOut);
      await pumpAuthFlow(tester, env, location: '/log-in');
      await tester.tap(find.byType(GoogleSignInButton));
      await settleFlow(tester);
      expect(find.text(learnStub), findsOneWidget);
    });

    testWidgets('Google cancelled: no error, stays on Log in', (tester) async {
      final env = AuthTestEnv(
        session: SessionState.signedOut,
        google: const FakeGoogleIdTokenProvider(cancel: true),
      );
      await pumpAuthFlow(tester, env, location: '/log-in');
      await tester.tap(find.byType(GoogleSignInButton));
      await settleFlow(tester);
      expect(find.byType(LogInScreen), findsOneWidget);
      expect(find.text(googleFailedMessage), findsNothing);
    });

    testWidgets('Forgot password? opens the reset screen', (tester) async {
      final env = AuthTestEnv(session: SessionState.signedOut);
      await pumpAuthFlow(tester, env, location: '/log-in');
      await tester.tap(find.bySemanticsLabel('Forgot password?'));
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });

    testWidgets('footer link replaces Log in with Sign up', (tester) async {
      final env = AuthTestEnv(session: SessionState.signedOut);
      await pumpAuthFlow(tester, env, location: '/log-in');
      await tester.tap(find.bySemanticsLabel('New to Ishara? Create account'));
      await tester.pumpAndSettle();
      expect(find.byType(SignUpScreen), findsOneWidget);
      expect(routerLocation(tester), '/sign-up');
    });
  });
}
