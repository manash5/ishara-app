import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/camera_setup_check_screen.dart';
import 'package:ishara_app/features/onboarding/presentation/widgets/framing_guide.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_themed.dart';
import '../../../auth/auth_test_utils.dart';
import '../onboarding_test_utils.dart';

void main() {
  for (final mode in themeModes) {
    testWidgets('camera placeholder + checklist ($mode)', (tester) async {
      await pumpOnboardingScreen(
        tester,
        const CameraSetupCheckScreen(),
        mode: mode,
      );
      final c = tokensFor(mode);

      expect(find.byType(CameraFeed), findsOneWidget);
      expect(find.byType(FramingGuide), findsOneWidget);
      expect(textColor(tester, 'Check your setup'), c.staticWhite);
      expect(textColor(tester, 'Lighting'), c.textPrimary);

      IsharaChip chip(String label) =>
          tester.widget<IsharaChip>(find.widgetWithText(IsharaChip, label));
      expect(chip('Good').tone, IsharaChipTone.success);
      expect(chip('Move a bit closer').tone, IsharaChipTone.accent);
      expect(chip('Detected').tone, IsharaChipTone.success);
      expect(find.widgetWithText(FilledButton, 'Looks good'), findsOneWidget);
      expect(find.byTooltip('Close'), findsOneWidget);
    });
  }

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
