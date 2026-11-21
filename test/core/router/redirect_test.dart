import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/redirect.dart';

void main() {
  const out = (loggedIn: false, onboardingDone: false);
  const newUser = (loggedIn: true, onboardingDone: false);
  const done = (loggedIn: true, onboardingDone: true);

  group('sessionRedirect', () {
    test('splash and gallery are always allowed', () {
      for (final s in [out, newUser, done]) {
        expect(sessionRedirect(s, '/splash'), isNull);
        expect(sessionRedirect(s, '/gallery'), isNull);
      }
    });

    test('no session → /welcome, except the auth screens', () {
      for (final path in [
        '/learn',
        '/dictionary/namaste',
        '/lesson/a',
        '/onboarding/hand',
        '/settings',
        '/practice',
      ]) {
        expect(sessionRedirect(out, path), '/welcome', reason: path);
      }
      for (final path in [
        '/welcome',
        '/sign-up',
        '/log-in',
        '/forgot-password',
      ]) {
        expect(sessionRedirect(out, path), isNull, reason: path);
      }
    });

    test('onboarding incomplete → onboarding, steps allowed', () {
      for (final path in ['/learn', '/welcome', '/log-in', '/profile']) {
        expect(sessionRedirect(newUser, path), '/onboarding/daily-goal');
      }
      for (final path in [
        '/onboarding/daily-goal',
        '/onboarding/hand',
        '/onboarding/camera-permission',
        '/onboarding/camera-check',
      ]) {
        expect(sessionRedirect(newUser, path), isNull, reason: path);
      }
    });

    test('session check runs before onboarding check', () {
      // Logged out with onboarding "done" still goes to /welcome.
      expect(
        sessionRedirect((loggedIn: false, onboardingDone: true), '/learn'),
        '/welcome',
      );
    });

    test('fully onboarded: app allowed, auth/onboarding → /learn', () {
      for (final path in [
        '/learn',
        '/dictionary',
        '/dictionary/namaste',
        '/ranks',
        '/profile',
        '/settings',
        '/practice',
        '/lesson/a',
        '/lesson/a/complete',
        '/streak',
        '/out-of-hearts',
      ]) {
        expect(sessionRedirect(done, path), isNull, reason: path);
      }
      for (final path in ['/welcome', '/sign-up', '/onboarding/hand']) {
        expect(sessionRedirect(done, path), '/learn', reason: path);
      }
    });
  });
}
