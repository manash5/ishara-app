import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/auth/presentation/providers/auth_form_providers.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/log_in_screen.dart';
import 'package:ishara_app/features/auth/presentation/widgets/reset_link_sent_notice.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_themed.dart';
import '../../auth_test_utils.dart';
import 'auth_screen_harness.dart';

const notice = ResetLinkSentNotice.defaultMessage;

/// Step 2, without calling the API.
class _CodeSent extends PasswordResetForm {
  @override
  PasswordResetState build() =>
      const PasswordResetState(sentTo: 'learner@ishara.test');
}

Finder field(String label) => find.descendant(
  of: find.widgetWithText(IsharaTextField, label),
  matching: find.byType(TextField),
);

Future<void> tapButton(WidgetTester tester, String label) async {
  final button = find.widgetWithText(IsharaButton, label);
  await tester.ensureVisible(button);
  await tester.tap(button);
  await settleFlow(tester);
}

void main() {
  for (final mode in themeModes) {
    testWidgets('renders step 2 (code sent) in ${mode.name}', (tester) async {
      await pumpAuthScreen(
        tester,
        const ForgotPasswordScreen(),
        mode: mode,
        overrides: [passwordResetFormProvider.overrideWith(_CodeSent.new)],
      );
      final c = tokensFor(mode);

      expect(textColor(tester, 'Reset your password'), c.textPrimary);
      expect(find.widgetWithText(IsharaTextField, 'Email'), findsOneWidget);
      expect(textColor(tester, notice), c.successText);
      expect(
        find.widgetWithText(IsharaTextField, 'Reset code'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(IsharaTextField, 'New password'),
        findsOneWidget,
      );
      expect(find.widgetWithText(IsharaButton, 'Reset password'), findsOne);
      expect(find.widgetWithText(IsharaButton, 'Resend code'), findsOne);
      expect(find.widgetWithText(IsharaButton, 'Back to log in'), findsOne);
    });
  }

  testWidgets('step 1: no notice, "Send reset code", no code field', (
    tester,
  ) async {
    await pumpAuthScreen(tester, const ForgotPasswordScreen());
    expect(find.text(notice), findsNothing);
    expect(find.text('Send reset code'), findsOneWidget);
    expect(find.widgetWithText(IsharaTextField, 'Reset code'), findsNothing);
  });

  testWidgets('the code field takes at most 6 digits', (tester) async {
    await pumpAuthScreen(
      tester,
      const ForgotPasswordScreen(),
      overrides: [passwordResetFormProvider.overrideWith(_CodeSent.new)],
    );
    await tester.enterText(field('Reset code'), '12ab34567');
    expect(
      tester.widget<TextField>(field('Reset code')).controller!.text,
      '123456',
    );
  });

  testWidgets('fits at 1.3x text scale on step 2', (tester) async {
    await pumpAuthScreen(
      tester,
      const ForgotPasswordScreen(),
      textScale: 1.3,
      overrides: [passwordResetFormProvider.overrideWith(_CodeSent.new)],
    );
    expect(tester.takeException(), isNull);
  });

  group('with the mock API', () {
    Future<ProviderContainer> sendCode(WidgetTester tester) async {
      final env = AuthTestEnv(session: SessionState.signedOut);
      final container = await pumpAuthFlow(
        tester,
        env,
        location: '/forgot-password',
      );
      await tester.enterText(field('Email'), 'learner@ishara.test');
      await tapButton(tester, 'Send reset code');
      return container;
    }

    testWidgets('sending the code shows step 2', (tester) async {
      await sendCode(tester);
      expect(find.text(notice), findsOneWidget);
      expect(find.widgetWithText(IsharaTextField, 'Reset code'), findsOne);
      expect(find.text('Resend code'), findsOneWidget);
    });

    testWidgets('a good code signs in and goes to Learn', (tester) async {
      final container = await sendCode(tester);
      await tester.enterText(field('Reset code'), '123456');
      await tester.enterText(field('New password'), 'newpassword');
      await tapButton(tester, 'Reset password');

      expect(container.read(sessionProvider).loggedIn, isTrue);
      expect(find.text(learnStub), findsOneWidget);
    });

    testWidgets('code 000000 → 422 message under the code', (tester) async {
      await sendCode(tester);
      await tester.enterText(field('Reset code'), '000000');
      await tester.enterText(field('New password'), 'newpassword');
      await tapButton(tester, 'Reset password');

      expect(find.text('That code is invalid or has expired.'), findsOne);
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });

    testWidgets('a short code is caught before the API', (tester) async {
      await sendCode(tester);
      await tester.enterText(field('Reset code'), '123');
      await tapButton(tester, 'Reset password');
      expect(find.text('Enter the 6-digit code from the email.'), findsOne);
    });

    testWidgets('Back to log in returns to Log in', (tester) async {
      final env = AuthTestEnv(session: SessionState.signedOut);
      await pumpAuthFlow(tester, env, location: '/log-in');
      await tester.tap(find.bySemanticsLabel('Forgot password?'));
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
      await tapButton(tester, 'Back to log in');
      expect(find.byType(ForgotPasswordScreen), findsNothing);
      expect(find.byType(LogInScreen), findsOneWidget);
    });
  });
}
