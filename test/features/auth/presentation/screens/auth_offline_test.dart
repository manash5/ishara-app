import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/log_in_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_themed.dart';
import '../../auth_test_utils.dart';

/// Auth needs a connection: offline, each auth screen says so and its
/// submit buttons are disabled.
void main() {
  Future<void> pumpOffline(
    WidgetTester tester,
    String location, {
    bool online = false,
  }) async {
    final env = AuthTestEnv(session: SessionState.signedOut)..online = online;
    await pumpAuthFlow(tester, env, location: location);
  }

  IsharaButton button(WidgetTester tester, String label) =>
      tester.widget<IsharaButton>(find.widgetWithText(IsharaButton, label));

  Finder notice() => find.byKey(const Key('auth-offline-notice'));

  testWidgets('log in: offline message, Log in and Google disabled', (
    tester,
  ) async {
    await pumpOffline(tester, '/log-in');
    expect(find.text(LogInScreen.offlineMessage), findsOneWidget);
    expect(notice(), findsOneWidget);
    expect(button(tester, 'Log in').onPressed, isNull);
    expect(
      tester
          .widget<GoogleSignInButton>(find.byType(GoogleSignInButton))
          .onPressed,
      isNull,
    );
  });

  testWidgets('sign up: offline message, Create account disabled', (
    tester,
  ) async {
    await pumpOffline(tester, '/sign-up');
    expect(find.text(SignUpScreen.offlineMessage), findsOneWidget);
    expect(button(tester, 'Create account').onPressed, isNull);
    expect(
      tester
          .widget<GoogleSignInButton>(find.byType(GoogleSignInButton))
          .onPressed,
      isNull,
    );
  });

  testWidgets('forgot password: offline message, sending disabled', (
    tester,
  ) async {
    await pumpOffline(tester, '/forgot-password');
    expect(find.text(ForgotPasswordScreen.offlineMessage), findsOneWidget);
    expect(button(tester, 'Send reset code').onPressed, isNull);
  });

  for (final mode in themeModes) {
    testWidgets('the notice uses the snackbar tokens (${mode.name})', (
      tester,
    ) async {
      if (mode == ThemeMode.dark) {
        tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
        addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      }
      await pumpOffline(tester, '/log-in');
      expect(
        textColor(tester, LogInScreen.offlineMessage),
        tokensFor(mode).textInverse,
      );
    });
  }

  testWidgets('online: no notice and the buttons work', (tester) async {
    await pumpOffline(tester, '/log-in', online: true);
    expect(notice(), findsNothing);
    expect(button(tester, 'Log in').onPressed, isNotNull);
  });
}
