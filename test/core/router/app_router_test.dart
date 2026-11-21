import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/features/auth/presentation/providers/fake_session_provider.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('redirects', () {
    testWidgets('starts on Splash; Continue goes to Welcome when logged out', (
      tester,
    ) async {
      final container = await pumpApp(tester);
      expect(frameTitle('01', 'Splash'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(frameTitle('02', 'Welcome'), findsOneWidget);
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
      expect(frameTitle('02', 'Welcome'), findsOneWidget);
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
      expect(frameTitle('06', 'Daily goal'), findsOneWidget);
    });

    testWidgets('onboarded: auth screens bounce to Learn', (tester) async {
      final container = await pumpApp(
        tester,
        loggedIn: true,
        onboardingDone: true,
        location: const WelcomeRoute().location,
      );
      expect(currentLocation(container), const LearnRoute().location);
      expect(frameTitle('10', 'Learn'), findsOneWidget);
    });

    testWidgets('flipping the session re-runs the redirect', (tester) async {
      final container = await pumpApp(
        tester,
        loggedIn: true,
        onboardingDone: true,
        location: const ProfileRoute().location,
      );
      expect(frameTitle('16', 'Profile'), findsOneWidget);

      container.read(fakeSessionProvider.notifier).setOnboardingDone(false);
      await tester.pumpAndSettle();
      expect(frameTitle('06', 'Daily goal'), findsOneWidget);

      container.read(fakeSessionProvider.notifier).logOut();
      await tester.pumpAndSettle();
      expect(frameTitle('02', 'Welcome'), findsOneWidget);
    });

    testWidgets('settings log out returns to Welcome', (tester) async {
      await pumpApp(
        tester,
        loggedIn: true,
        onboardingDone: true,
        location: const SettingsRoute().location,
      );
      await tester.tap(find.text('Log out'));
      await tester.pumpAndSettle();
      expect(frameTitle('02', 'Welcome'), findsOneWidget);
    });
  });

  testWidgets('click-through: sign up → onboarding 06–09 → Learn', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    Future<void> tap(String label) async {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    await tap('Continue');
    await tap('Sign up');
    expect(frameTitle('03', 'Sign up'), findsOneWidget);
    await tap('Create account');
    expect(frameTitle('06', 'Daily goal'), findsOneWidget);
    await tap('Continue');
    expect(frameTitle('07', 'Dominant hand'), findsOneWidget);
    await tap('Continue');
    expect(frameTitle('08', 'Camera permission'), findsOneWidget);
    await tap('Allow camera');
    expect(frameTitle('09', 'Camera setup check'), findsOneWidget);
    await tap('Finish');
    expect(frameTitle('10', 'Learn'), findsOneWidget);
    expect(container.read(fakeSessionProvider).onboardingDone, isTrue);
  });

  testWidgets('click-through: log in → forgot password → Learn', (
    tester,
  ) async {
    await pumpApp(tester, location: const WelcomeRoute().location);
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    expect(frameTitle('05', 'Forgot password'), findsOneWidget);
    await tester.tap(find.text('Send reset link'));
    await tester.pumpAndSettle();
    expect(frameTitle('04', 'Log in'), findsOneWidget);
    // The screen's button (the app bar title is also "Log in").
    await tester.tap(find.widgetWithText(FilledButton, 'Log in'));
    await tester.pumpAndSettle();
    expect(frameTitle('10', 'Learn'), findsOneWidget);
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
