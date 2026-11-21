import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/onboarding/presentation/providers/onboarding_choices_provider.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/daily_goal_screen.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/dominant_hand_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';
import '../onboarding_test_utils.dart';

void main() {
  for (final mode in themeModes) {
    testWidgets('shows the Figma goals with Regular selected ($mode)', (
      tester,
    ) async {
      await pumpOnboardingScreen(tester, const DailyGoalScreen(), mode: mode);
      final c = tokensFor(mode);

      const title = 'How long do you want to practise each day?';
      expect(find.text(title), findsOneWidget);
      expect(textColor(tester, title), c.textPrimary);
      expect(
        textColor(tester, 'You can change your goal anytime in Settings.'),
        c.textSecondary,
      );
      for (final label in [
        '5 min a day · 1 lesson',
        '10 min a day · 2 lessons',
        '15 min a day · 3 lessons',
        '20 min a day · 4 lessons',
      ]) {
        expect(find.text(label), findsOneWidget);
      }
      final cards = tester
          .widgetList<SelectionCard>(find.byType(SelectionCard))
          .toList();
      expect(cards, hasLength(4));
      expect(cards.where((card) => card.selected).single.title, 'Regular');
      expect(find.widgetWithText(FilledButton, 'Continue'), findsOneWidget);
      final step = tester.widget<StepIndicator>(find.byType(StepIndicator));
      expect((step.current, step.total), (1, 3));
    });
  }

  testWidgets('tapping a goal selects it', (tester) async {
    final container = await pumpOnboardingScreen(
      tester,
      const DailyGoalScreen(),
    );
    await tester.tap(find.text('Intense'));
    await tester.pumpAndSettle();
    expect(container.read(onboardingChoicesProvider).dailyGoalId, 'intense');
    final selected = tester
        .widgetList<SelectionCard>(find.byType(SelectionCard))
        .where((card) => card.selected);
    expect(selected.single.title, 'Intense');
  });

  testWidgets('cards are a radio group and fit at 1.3× text', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpOnboardingScreen(tester, const DailyGoalScreen(), textScale: 1.3);
    expect(tester.takeException(), isNull);
    expect(
      tester.getSemantics(find.byKey(const ValueKey('daily-goal-regular'))),
      matchesSemantics(
        label: 'Regular, 10 min a day · 2 lessons',
        isButton: true,
        hasSelectedState: true,
        isSelected: true,
        isInMutuallyExclusiveGroup: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('Continue goes to Dominant hand', (tester) async {
    await pumpApp(
      tester,
      loggedIn: true,
      location: const DailyGoalRoute().location,
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(DominantHandScreen), findsOneWidget);
  });
}
