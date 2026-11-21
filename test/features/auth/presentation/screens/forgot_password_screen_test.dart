import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/auth/presentation/providers/auth_form_providers.dart';
import 'package:ishara_app/features/auth/presentation/screens/forgot_password_screen.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';
import 'auth_screen_harness.dart';

const notice = 'Link sent. Check your inbox — it expires in 1 hour.';

void main() {
  for (final mode in themeModes) {
    testWidgets('renders the Figma sent state in ${mode.name}', (tester) async {
      final container = await pumpAuthScreen(
        tester,
        const ForgotPasswordScreen(),
        mode: mode,
      );
      container.read(resetLinkSentProvider.notifier).send();
      await tester.pumpAndSettle();
      final c = tokensFor(mode);

      expect(textColor(tester, 'Reset your password'), c.textPrimary);
      expect(find.widgetWithText(IsharaTextField, 'Email'), findsOneWidget);
      expect(textColor(tester, notice), c.successText);
      expect(find.widgetWithText(IsharaButton, 'Resend link'), findsOneWidget);
      expect(
        find.widgetWithText(IsharaButton, 'Back to log in'),
        findsOneWidget,
      );
    });
  }

  testWidgets('before sending: no notice, "Send reset link"', (tester) async {
    await pumpAuthScreen(tester, const ForgotPasswordScreen());
    expect(find.text(notice), findsNothing);
    expect(find.text('Send reset link'), findsOneWidget);

    await tester.tap(find.text('Send reset link'));
    await tester.pumpAndSettle();
    expect(find.text(notice), findsOneWidget);
    expect(find.text('Resend link'), findsOneWidget);
  });

  testWidgets('fits at 1.3x text scale', (tester) async {
    final container = await pumpAuthScreen(
      tester,
      const ForgotPasswordScreen(),
      textScale: 1.3,
    );
    container.read(resetLinkSentProvider.notifier).send();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Back to log in returns to Log in', (tester) async {
    final container = await pumpApp(
      tester,
      location: const LogInRoute().location,
    );
    await tester.tap(find.bySemanticsLabel('Forgot password?'));
    await tester.pumpAndSettle();
    expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    await tester.tap(find.text('Back to log in'));
    await tester.pumpAndSettle();
    expect(find.byType(ForgotPasswordScreen), findsNothing);
    expect(currentLocation(container), const LogInRoute().location);
  });
}
