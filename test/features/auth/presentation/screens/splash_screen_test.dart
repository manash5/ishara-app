import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:ishara_app/features/auth/presentation/widgets/splash_intro.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';
import 'auth_screen_harness.dart';

/// Progress of the Danphe logo intro (0 = not started, 1 = complete).
double logoOpacity(WidgetTester tester) =>
    tester.widget<IsharaLogo>(find.byType(IsharaLogo)).intro!.value;

void main() {
  for (final mode in themeModes) {
    testWidgets('renders the Figma end state in ${mode.name}', (tester) async {
      await pumpSplashRouter(tester, const SplashScreen(), mode: mode);
      // Just before the end: still on Splash, everything visible.
      await tester.pump(SplashMotion.total - IsharaMotion.instant);

      expect(find.byType(HeroBackdrop), findsOneWidget);
      expect(find.bySemanticsLabel('Ishara'), findsOneWidget);
      expect(find.text('ishara'), findsOneWidget);
      expect(
        textColor(tester, 'Learn Nepali Sign Language'),
        tokensFor(mode).funLime,
      );
      // The wordmark stays white on the teal hero in both themes.
      expect(textColor(tester, 'ishara'), tokensFor(mode).staticWhite);
      expect(find.text('Continue'), findsNothing);

      await tester.pumpAndSettle();
    });
  }

  testWidgets('Danphe logo assembles, then the splash continues to /learn', (
    tester,
  ) async {
    await pumpSplashRouter(tester, const SplashScreen());
    await tester.pump();
    expect(logoOpacity(tester), 0);

    await tester.pump(SplashMotion.total ~/ 2);
    expect(logoOpacity(tester), inExclusiveRange(0, 1));
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(SplashMotion.total ~/ 2);
    await tester.pumpAndSettle();
    expect(find.text(learnStub), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);
  });

  testWidgets('reduced motion: static end frame, then continues', (
    tester,
  ) async {
    await pumpSplashRouter(
      tester,
      const SplashScreen(),
      disableAnimations: true,
    );
    await tester.pump();
    expect(logoOpacity(tester), 1);
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(SplashMotion.reducedHold);
    await tester.pumpAndSettle();
    expect(find.text(learnStub), findsOneWidget);
  });

  testWidgets('waits on the last frame until the session is restored', (
    tester,
  ) async {
    final container = await pumpSplashRouter(
      tester,
      const SplashScreen(),
      disableAnimations: true,
      session: SessionState.restoring,
    );
    await tester.pump();
    await tester.pump(SplashMotion.reducedHold * 3);
    await tester.pumpAndSettle();
    expect(find.byType(SplashScreen), findsOneWidget);

    container.read(sessionProvider.notifier).debugOverride(loggedIn: false);
    await tester.pumpAndSettle();
    expect(find.text(learnStub), findsOneWidget);
  });

  group('in the app, the redirect picks the destination', () {
    // Full animated splash; Learn's current node pulses forever, so pump
    // past the intro instead of settling.
    Future<String> landAfterSplash(
      WidgetTester tester, {
      bool loggedIn = false,
      bool onboardingDone = false,
    }) async {
      final container = await pumpApp(
        tester,
        loggedIn: loggedIn,
        onboardingDone: onboardingDone,
        settle: false,
        animate: true,
      );
      await tester.pump(SplashMotion.total);
      for (var i = 0; i < 5; i++) {
        await tester.pump(IsharaMotion.page);
      }
      final location = currentLocation(container);
      await tester.pumpWidget(const SizedBox());
      return location;
    }

    testWidgets('logged out → Welcome', (tester) async {
      expect(await landAfterSplash(tester), const WelcomeRoute().location);
    });

    testWidgets('logged in, onboarding to do → onboarding', (tester) async {
      expect(
        await landAfterSplash(tester, loggedIn: true),
        const DailyGoalRoute().location,
      );
    });

    testWidgets('logged in and onboarded → Learn', (tester) async {
      expect(
        await landAfterSplash(tester, loggedIn: true, onboardingDone: true),
        const LearnRoute().location,
      );
    });
  });
}
