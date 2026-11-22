import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/camera_setup_check_screen.dart';
import 'package:ishara_app/features/onboarding/presentation/widgets/framing_guide.dart';
import 'package:ishara_app/features/recognition/data/recognition_providers.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_themed.dart';
import '../../../auth/auth_test_utils.dart';
import '../onboarding_test_utils.dart';

void main() {
  IsharaChip chip(WidgetTester tester, String label) =>
      tester.widget<IsharaChip>(find.widgetWithText(IsharaChip, label));

  for (final mode in themeModes) {
    testWidgets('a hand in view passes every check ($mode)', (tester) async {
      await pumpOnboardingScreen(
        tester,
        const CameraSetupCheckScreen(),
        mode: mode,
      );
      await tester.pump(const Duration(seconds: 1));
      final c = tokensFor(mode);

      expect(find.byType(FramingGuide), findsOneWidget);
      expect(textColor(tester, 'Check your setup'), c.staticWhite);
      expect(textColor(tester, 'Lighting'), c.textPrimary);
      // Lighting and distance both read "Good"; the hand is detected.
      expect(find.widgetWithText(IsharaChip, 'Good'), findsNWidgets(2));
      expect(chip(tester, 'Detected').tone, IsharaChipTone.success);
      final feed = tester.widget<CameraFeed>(find.byType(CameraFeed));
      expect(feed.landmarks, hasLength(21));
      expect(feed.overlay, HandOverlayStyle.live);
      expect(find.widgetWithText(FilledButton, 'Looks good'), findsOneWidget);
      expect(find.byTooltip('Close'), findsOneWidget);
    });
  }

  testWidgets('no hand: every check asks for one, ghost pose', (tester) async {
    await pumpOnboardingScreen(
      tester,
      const CameraSetupCheckScreen(),
      camera: FakeCameraScenario.noHand,
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.widgetWithText(IsharaChip, 'Show your hand'), findsNWidgets(3));
    for (final c in tester.widgetList<IsharaChip>(
      find.widgetWithText(IsharaChip, 'Show your hand'),
    )) {
      expect(c.tone, IsharaChipTone.accent);
    }
    final feed = tester.widget<CameraFeed>(find.byType(CameraFeed));
    expect(feed.landmarks, isNull);
    expect(feed.overlay, HandOverlayStyle.ghost);
  });

  testWidgets('fits at 1.3× text scale', (tester) async {
    await pumpOnboardingScreen(
      tester,
      const CameraSetupCheckScreen(),
      textScale: 1.3,
    );
    expect(tester.takeException(), isNull);
  });

  group('Looks good with the mock API', () {
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
        location: '/onboarding/camera-check',
      );
      await tester.tap(find.text('Looks good'));
      await settleFlow(tester);
      expect(container.read(sessionProvider).onboardingDone, isTrue);
      expect(find.text(learnStub), findsOneWidget);
    });

    testWidgets('a failure shows a snackbar and stays', (tester) async {
      final env = AuthTestEnv(session: onboarding)
        ..simulation = MockApiSimulation.serverError;
      final container = await pumpAuthFlow(
        tester,
        env,
        location: '/onboarding/camera-check',
      );
      await tester.tap(find.text('Looks good'));
      await settleFlow(tester);
      expect(container.read(sessionProvider).onboardingDone, isFalse);
      expect(find.text(const ServerFailure().message), findsOneWidget);
      expect(find.text(learnStub), findsNothing);
    });
  });
}
