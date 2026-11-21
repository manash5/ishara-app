import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/onboarding/presentation/providers/onboarding_choices_provider.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/camera_permission_screen.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/dominant_hand_screen.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';
import '../onboarding_test_utils.dart';

void main() {
  for (final mode in themeModes) {
    testWidgets('shows both hands with Right selected ($mode)', (tester) async {
      await pumpOnboardingScreen(
        tester,
        const DominantHandScreen(),
        mode: mode,
      );
      final c = tokensFor(mode);

      expect(textColor(tester, 'Which hand do you sign with?'), c.textPrimary);
      expect(find.text('Videos play as recorded'), findsOneWidget);
      expect(find.text('Videos are mirrored for you'), findsOneWidget);
      expect(
        textColor(tester, 'Not sure? Choose the hand you write with.'),
        c.textSecondary,
      );
      final selected = tester
          .widgetList<SelectionCard>(find.byType(SelectionCard))
          .where((card) => card.selected);
      expect(selected.single.title, 'Right hand');
      final step = tester.widget<StepIndicator>(find.byType(StepIndicator));
      expect(step.current, 2);
    });
  }

  testWidgets('tapping Left hand selects it', (tester) async {
    final container = await pumpOnboardingScreen(
      tester,
      const DominantHandScreen(),
    );
    await tester.tap(find.text('Left hand'));
    await tester.pumpAndSettle();
    expect(container.read(onboardingChoicesProvider).hand, DominantHand.left);
    final selected = tester
        .widgetList<SelectionCard>(find.byType(SelectionCard))
        .where((card) => card.selected);
    expect(selected.single.title, 'Left hand');
  });

  testWidgets('fits at 1.3× text scale', (tester) async {
    await pumpOnboardingScreen(
      tester,
      const DominantHandScreen(),
      textScale: 1.3,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Continue goes to Camera permission, back returns', (
    tester,
  ) async {
    await pumpApp(
      tester,
      loggedIn: true,
      location: const DailyGoalRoute().location,
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(CameraPermissionScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(CameraPermissionScreen), findsNothing);
    expect(find.byType(DominantHandScreen), findsOneWidget);
  });
}
