import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/onboarding/presentation/providers/onboarding_choices_provider.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/camera_permission_screen.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/camera_setup_check_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';
import '../../../auth/auth_test_utils.dart';
import '../onboarding_test_utils.dart';

void main() {
  for (final mode in themeModes) {
    testWidgets('hero + privacy panel ($mode)', (tester) async {
      await pumpOnboardingScreen(
        tester,
        const CameraPermissionScreen(),
        mode: mode,
      );
      final c = tokensFor(mode);

      expect(find.byType(HeroBackdrop), findsOneWidget);
      expect(textColor(tester, 'Let Ishara see your hands'), c.staticWhite);
      expect(textColor(tester, 'Your privacy'), c.textPrimary);
      expect(
        find.text('Processed on your phone — video never leaves it'),
        findsOneWidget,
      );
      expect(find.text('Only 21 points on each hand are read'), findsOneWidget);
      expect(find.text('Skip camera exercises anytime'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Allow camera'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Not now'), findsOneWidget);
      expect(
        tester.widget<StepIndicator>(find.byType(StepIndicator)).current,
        3,
      );
    });
  }

  testWidgets('fits at 1.3× text scale', (tester) async {
    await pumpOnboardingScreen(
      tester,
      const CameraPermissionScreen(),
      textScale: 1.3,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Allow camera goes to the setup check', (tester) async {
    final container = await pumpApp(
      tester,
      loggedIn: true,
      location: const DominantHandRoute().location,
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allow camera'));
    await tester.pumpAndSettle();
    expect(find.byType(CameraSetupCheckScreen), findsOneWidget);
    expect(container.read(onboardingChoicesProvider).cameraAllowed, isTrue);
  });

  group('Not now with the mock API', () {
    const onboarding = SessionState(
      ready: true,
      loggedIn: true,
      onboardingDone: false,
    );

    testWidgets('finishes onboarding and lands on Learn', (tester) async {
      final env = AuthTestEnv(session: onboarding);
      final container = await pumpAuthFlow(
        tester,
        env,
        location: '/onboarding/camera-permission',
      );
      await tester.tap(find.text('Not now'));
      await settleFlow(tester);
      expect(container.read(sessionProvider).onboardingDone, isTrue);
      expect(container.read(onboardingChoicesProvider).cameraAllowed, isFalse);
      expect(find.text(learnStub), findsOneWidget);
    });

    testWidgets('a failure shows a snackbar and stays', (tester) async {
      final env = AuthTestEnv(session: onboarding)
        ..simulation = MockApiSimulation.serverError;
      final container = await pumpAuthFlow(
        tester,
        env,
        location: '/onboarding/camera-permission',
      );
      await tester.tap(find.text('Not now'));
      await settleFlow(tester);
      expect(container.read(sessionProvider).onboardingDone, isFalse);
      expect(find.text(const ServerFailure().message), findsOneWidget);
      expect(find.text(learnStub), findsNothing);
    });
  });
}
