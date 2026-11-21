import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  Future<void> pumpShell(WidgetTester tester) => pumpApp(
    tester,
    loggedIn: true,
    onboardingDone: true,
    location: const LearnRoute().location,
  );

  Finder tab(String label) => find.descendant(
    of: find.byType(IsharaBottomBar),
    matching: find.text(label),
  );

  IsharaTab activeTab(WidgetTester tester) =>
      tester.widget<IsharaBottomBar>(find.byType(IsharaBottomBar)).current;

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  group('tabs', () {
    testWidgets('each tab shows its screen and becomes active', (tester) async {
      await pumpShell(tester);
      expect(frameTitle('10', 'Learn'), findsOneWidget);
      expect(activeTab(tester), IsharaTab.learn);

      for (final (label, frame, name, t) in [
        ('Dictionary', '13', 'Dictionary', IsharaTab.dictionary),
        ('Ranks', '15', 'Ranks', IsharaTab.leaderboard),
        ('Profile', '16', 'Profile', IsharaTab.profile),
        ('Learn', '10', 'Learn', IsharaTab.learn),
      ]) {
        await tapAndSettle(tester, tab(label));
        expect(frameTitle(frame, name), findsOneWidget, reason: label);
        expect(activeTab(tester), t);
      }
    });

    testWidgets('branches keep their stack; re-tap returns to the root', (
      tester,
    ) async {
      await pumpShell(tester);
      await tapAndSettle(tester, tab('Dictionary'));
      await tapAndSettle(tester, find.text('Namaste'));
      expect(frameTitle('14', 'Sign detail'), findsOneWidget);
      expect(find.byType(IsharaBottomBar), findsOneWidget);

      await tapAndSettle(tester, tab('Ranks'));
      await tapAndSettle(tester, tab('Dictionary'));
      expect(frameTitle('14', 'Sign detail'), findsOneWidget);

      await tapAndSettle(tester, tab('Dictionary'));
      expect(frameTitle('13', 'Dictionary'), findsOneWidget);
    });

    testWidgets('Practice opens full-screen over the bar, not as a tab', (
      tester,
    ) async {
      await pumpShell(tester);
      await tapAndSettle(tester, find.byIcon(IsharaIcons.camera));
      expect(find.text('Practice'), findsWidgets);
      expect(find.byType(IsharaBottomBar), findsNothing);

      await tapAndSettle(tester, find.text('Done'));
      expect(frameTitle('10', 'Learn'), findsOneWidget);
      expect(activeTab(tester), IsharaTab.learn);
    });

    testWidgets('Settings opens full-screen from Profile', (tester) async {
      await pumpShell(tester);
      await tapAndSettle(tester, tab('Profile'));
      await tapAndSettle(tester, find.text('Settings'));
      expect(frameTitle('17', 'Settings'), findsOneWidget);
      expect(find.byType(IsharaBottomBar), findsNothing);
    });
  });

  group('lesson flow', () {
    Future<void> openLesson(WidgetTester tester) async {
      await pumpShell(tester);
      await tapAndSettle(tester, find.text('Open lesson (11)'));
      expect(find.text('11 · Learn – lesson sheet'), findsOneWidget);
      await tapAndSettle(tester, find.text('Start lesson'));
      expect(frameTitle('18', 'Watch & learn'), findsOneWidget);
    }

    testWidgets('steps 18–25 → complete 26 → streak 27 → Learn', (
      tester,
    ) async {
      await openLesson(tester);
      await tapAndSettle(tester, find.text('Next'));
      expect(frameTitle('19', 'Recognise'), findsOneWidget);
      await tapAndSettle(tester, find.text('25'));
      expect(frameTitle('25', 'Fingerspell (camera)'), findsOneWidget);
      await tapAndSettle(tester, find.text('Finish lesson'));
      expect(frameTitle('26', 'Lesson complete'), findsOneWidget);
      await tapAndSettle(tester, find.text('Continue'));
      expect(frameTitle('27', 'Streak'), findsOneWidget);
      await tapAndSettle(tester, find.text('Continue'));
      expect(frameTitle('10', 'Learn'), findsOneWidget);
    });

    testWidgets('Android back asks to quit (29); Keep learning stays', (
      tester,
    ) async {
      await openLesson(tester);
      await tapAndSettle(tester, find.text('Next'));
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('29 · Quit lesson?'), findsOneWidget);
      await tapAndSettle(tester, find.text('Keep learning'));
      expect(find.text('29 · Quit lesson?'), findsNothing);
      expect(frameTitle('19', 'Recognise'), findsOneWidget);
    });

    testWidgets('close button → Quit returns to Learn', (tester) async {
      await openLesson(tester);
      await tapAndSettle(tester, find.byTooltip('Close'));
      expect(find.text('29 · Quit lesson?'), findsOneWidget);
      await tapAndSettle(tester, find.text('Quit'));
      expect(frameTitle('10', 'Learn'), findsOneWidget);
    });

    testWidgets('out of hearts (28) leads back to Learn', (tester) async {
      await openLesson(tester);
      await tapAndSettle(tester, find.text('Run out of hearts (28)'));
      expect(frameTitle('28', 'Out of hearts'), findsOneWidget);
      await tapAndSettle(tester, find.text('Back to Learn'));
      expect(frameTitle('10', 'Learn'), findsOneWidget);
    });

    testWidgets('Learn offline state (12) toggles', (tester) async {
      await pumpShell(tester);
      await tapAndSettle(tester, find.byType(IsharaSwitch));
      expect(frameTitle('12', 'Learn – offline'), findsOneWidget);
      await tapAndSettle(tester, find.text('Try again'));
      expect(frameTitle('10', 'Learn'), findsOneWidget);
    });
  });
}
