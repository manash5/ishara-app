import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/dictionary/presentation/screens/dictionary_screen.dart';
import 'package:ishara_app/features/dictionary/presentation/screens/sign_detail_screen.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/learn/presentation/screens/learn_screen.dart';
import 'package:ishara_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:ishara_app/features/ranks/presentation/screens/ranks_screen.dart';
import 'package:ishara_app/features/settings/presentation/screens/settings_screen.dart';

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
      expect(find.byType(LearnScreen), findsOneWidget);
      expect(activeTab(tester), IsharaTab.learn);

      for (final (label, screen, t) in [
        ('Dictionary', DictionaryScreen, IsharaTab.dictionary),
        ('Ranks', RanksScreen, IsharaTab.leaderboard),
        ('Profile', ProfileScreen, IsharaTab.profile),
        ('Learn', LearnScreen, IsharaTab.learn),
      ]) {
        await tapAndSettle(tester, tab(label));
        expect(find.byType(screen), findsOneWidget, reason: label);
        expect(activeTab(tester), t);
      }
    });

    testWidgets('branches keep their stack; re-tap returns to the root', (
      tester,
    ) async {
      await pumpShell(tester);
      await tapAndSettle(tester, tab('Dictionary'));
      await tapAndSettle(tester, find.text('Namaste').first);
      expect(find.byType(SignDetailScreen), findsOneWidget);
      expect(find.byType(IsharaBottomBar), findsOneWidget);

      await tapAndSettle(tester, tab('Ranks'));
      await tapAndSettle(tester, tab('Dictionary'));
      expect(find.byType(SignDetailScreen), findsOneWidget);

      await tapAndSettle(tester, tab('Dictionary'));
      expect(find.byType(DictionaryScreen), findsOneWidget);
      expect(find.byType(SignDetailScreen), findsNothing);
    });

    testWidgets('Practice opens full-screen over the bar, not as a tab', (
      tester,
    ) async {
      await pumpShell(tester);
      await tapAndSettle(tester, find.byIcon(IsharaIcons.camera));
      expect(find.text('Practice'), findsWidgets);
      expect(find.byType(IsharaBottomBar), findsNothing);

      await tapAndSettle(tester, find.byTooltip('Close'));
      expect(find.byType(LearnScreen), findsOneWidget);
      expect(activeTab(tester), IsharaTab.learn);
    });

    testWidgets('Settings opens full-screen from Profile', (tester) async {
      await pumpShell(tester);
      await tapAndSettle(tester, tab('Profile'));
      await tapAndSettle(tester, find.byTooltip('Settings'));
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.byType(IsharaBottomBar), findsNothing);
    });
  });

  group('learn', () {
    testWidgets('offline (12): Learn stays in the shell with its notice', (
      tester,
    ) async {
      await pumpApp(
        tester,
        loggedIn: true,
        onboardingDone: true,
        location: const LearnRoute().location,
        simulation: MockApiSimulation.offline,
      );
      expect(find.byType(LearnScreen), findsOneWidget);
      expect(find.byType(IsharaBottomBar), findsOneWidget);
    });
  });
}
