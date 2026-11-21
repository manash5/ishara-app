import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/features/auth/presentation/providers/fake_session_provider.dart';
import 'package:ishara_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/log_in_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:ishara_app/features/auth/presentation/widgets/splash_intro.dart';
import 'package:ishara_app/features/learn/presentation/screens/learn_screen.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/camera_permission_screen.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/camera_setup_check_screen.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/daily_goal_screen.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/dominant_hand_screen.dart';
import 'package:ishara_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_app.dart';

void main() {
  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  group('redirects', () {
    testWidgets('Splash animates, then continues to Welcome when logged out', (
      tester,
    ) async {
      final container = await pumpApp(tester, settle: false, animate: true);
      expect(find.byType(SplashScreen), findsOneWidget);
      await tester.pump(SplashMotion.total);
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(currentLocation(container), const WelcomeRoute().location);
    });

    testWidgets('no session: a deep link to /learn lands on Welcome', (
      tester,
    ) async {
      final container = await pumpApp(
        tester,
        location: const LearnRoute().location,
      );
      expect(currentLocation(container), const WelcomeRoute().location);
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets('onboarding incomplete: app routes go to Daily goal', (
      tester,
    ) async {
      final container = await pumpApp(
        tester,
        loggedIn: true,
        location: const DictionaryRoute().location,
      );
      expect(currentLocation(container), const DailyGoalRoute().location);
      expect(find.byType(DailyGoalScreen), findsOneWidget);
    });

    testWidgets('onboarded: auth screens bounce to Learn', (tester) async {
      final container = await pumpApp(
        tester,
        loggedIn: true,
        onboardingDone: true,
        location: const WelcomeRoute().location,
      );
      expect(currentLocation(container), const LearnRoute().location);
      expect(find.byType(LearnScreen), findsOneWidget);
    });

    testWidgets('flipping the session re-runs the redirect', (tester) async {
      final container = await pumpApp(
        tester,
        loggedIn: true,
        onboardingDone: true,
        location: const ProfileRoute().location,
      );
      expect(find.byType(ProfileScreen), findsOneWidget);

      container.read(fakeSessionProvider.notifier).setOnboardingDone(false);
      await tester.pumpAndSettle();
      expect(find.byType(DailyGoalScreen), findsOneWidget);

      container.read(fakeSessionProvider.notifier).logOut();
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets('settings log out returns to Welcome', (tester) async {
      await pumpApp(
        tester,
        loggedIn: true,
        onboardingDone: true,
        location: const SettingsRoute().location,
      );
      await tapAndSettle(tester, find.text('Log out'));
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });
  });

  testWidgets('click-through: sign up → onboarding 06–09 → Learn', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    // Reduced motion: Splash holds its static frame briefly, then continues.
    await tester.pump(SplashMotion.reducedHold);
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);

    await tapAndSettle(tester, find.text('Get started'));
    expect(find.byType(SignUpScreen), findsOneWidget);
    await tapAndSettle(tester, find.text('Create account'));
    expect(find.byType(DailyGoalScreen), findsOneWidget);
    await tapAndSettle(tester, find.text('Continue'));
    expect(find.byType(DominantHandScreen), findsOneWidget);
    await tapAndSettle(tester, find.text('Continue'));
    expect(find.byType(CameraPermissionScreen), findsOneWidget);
    await tapAndSettle(tester, find.text('Allow camera'));
    expect(find.byType(CameraSetupCheckScreen), findsOneWidget);
    await tapAndSettle(tester, find.text('Looks good'));
    expect(find.byType(LearnScreen), findsOneWidget);
    expect(container.read(fakeSessionProvider).onboardingDone, isTrue);
  });

  testWidgets('click-through: log in → forgot password → Learn', (
    tester,
  ) async {
    await pumpApp(tester, location: const WelcomeRoute().location);
    await tapAndSettle(tester, find.text('I already have an account'));
    expect(find.byType(LogInScreen), findsOneWidget);
    await tapAndSettle(tester, find.text('Forgot password?'));
    expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    await tapAndSettle(tester, find.text('Send reset link'));
    expect(find.text('Resend link'), findsOneWidget);
    await tapAndSettle(tester, find.text('Back to log in'));
    expect(find.byType(LogInScreen), findsOneWidget);
    await tapAndSettle(tester, find.widgetWithText(FilledButton, 'Log in'));
    expect(find.byType(LearnScreen), findsOneWidget);
  });

  testWidgets('gallery is reachable logged out and flips the session', (
    tester,
  ) async {
    final container = await pumpApp(
      tester,
      location: const GalleryRoute().location,
    );
    expect(find.text('Fake session'), findsOneWidget);
    await tester.tap(find.byKey(const Key('gallery-session-logged-in')));
    await tester.pump();
    expect(container.read(fakeSessionProvider).loggedIn, isTrue);
    await tester.tap(find.byKey(const Key('gallery-session-onboarded')));
    await tester.pump();
    expect(container.read(fakeSessionProvider).onboardingDone, isTrue);
  });
}
