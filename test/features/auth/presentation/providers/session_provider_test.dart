import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/redirect.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/auth/presentation/providers/auth_form_providers.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:ishara_app/features/profile/data/models/user_profile_dto.dart';
import 'package:ishara_app/features/profile/presentation/providers/profile_provider.dart';

import '../../../../helpers/mock_api.dart';
import '../../auth_test_utils.dart';

void main() {
  Future<void> cacheProfile(AuthTestEnv env, {required bool onboarded}) =>
      ProfileLocalDataSource(env.hive).write(
        UserProfileDto.fromJson({
          ...fixtureData<Map<String, dynamic>>('me/get_200'),
          'onboardingDone': onboarded,
        }),
      );

  group('restore at start-up', () {
    test('starts not ready, then no tokens → signed out', () async {
      final container = AuthTestEnv().container();
      expect(container.read(sessionProvider), SessionState.restoring);
      await settleAsync();
      expect(container.read(sessionProvider), SessionState.signedOut);
    });

    test('tokens + cached profile → signed in with its onboarding', () async {
      final env = AuthTestEnv();
      await env.storeTokens();
      await cacheProfile(env, onboarded: false);
      final container = env.container();
      container.read(sessionProvider);
      await settleAsync();
      expect(
        container.read(sessionProvider),
        const SessionState(ready: true, loggedIn: true, onboardingDone: false),
      );
    });

    test('tokens, no cache → fetches /me and caches it', () async {
      final env = AuthTestEnv();
      await env.storeTokens();
      final container = env.container();
      container.read(sessionProvider);
      await settleAsync();
      expect(container.read(sessionProvider).flags, (
        loggedIn: true,
        onboardingDone: true,
      ));
      expect(
        ProfileLocalDataSource(env.hive).read()?.value.id,
        FixtureIds.user,
      );
    });

    test('tokens, offline, no cache → stays signed in', () async {
      final env = AuthTestEnv()..simulation = MockApiSimulation.offline;
      await env.storeTokens();
      final container = env.container();
      container.read(sessionProvider);
      await settleAsync();
      expect(container.read(sessionProvider).loggedIn, isTrue);
      expect(container.read(sessionProvider).ready, isTrue);
    });

    test('tokens the refresh rejects → signed out, tokens cleared', () async {
      final env = AuthTestEnv()..simulation = MockApiSimulation.sessionExpired;
      await env.storeTokens();
      final container = env.container();
      container.read(sessionProvider);
      await settleAsync();
      expect(container.read(sessionProvider), SessionState.signedOut);
      expect(await env.tokens.read(), isNull);
    });
  });

  group('during a session', () {
    Future<(AuthTestEnv, ProviderContainer)> signedIn() async {
      final env = AuthTestEnv();
      final container = env.container();
      container.listen(logInFormProvider, (_, _) {});
      await container
          .read(logInFormProvider.notifier)
          .logIn(email: 'learner@ishara.test', password: 'password1');
      expect(container.read(sessionProvider).loggedIn, isTrue);
      return (env, container);
    }

    test(
      'a 401 is refreshed once: still signed in, request succeeds',
      () async {
        final (env, container) = await signedIn();
        final before = await env.tokens.read();
        env.simulation = MockApiSimulation.unauthorized;

        container.invalidate(userProfileProvider);
        // Riverpod pauses providers nobody listens to.
        container.listen(userProfileProvider, (_, _) {});
        await settleAsync();

        final profile = container.read(userProfileProvider);
        expect(profile.hasError, isFalse);
        expect(profile.value?.id, FixtureIds.user);
        expect(container.read(sessionProvider).loggedIn, isTrue);
        final after = await env.tokens.read();
        expect(after?.accessToken, isNot(before?.accessToken));
      },
    );

    test('session expiry (refresh fails) signs out', () async {
      final (env, container) = await signedIn();
      env.simulation = MockApiSimulation.sessionExpired;
      await ProfileLocalDataSource(env.hive).clear();

      container.invalidate(userProfileProvider);
      container.listen(userProfileProvider, (_, _) {});
      await settleAsync();

      expect(container.read(sessionProvider), SessionState.signedOut);
      expect(await env.tokens.read(), isNull);
    });

    test('logOut clears tokens and every Hive box', () async {
      final (env, container) = await signedIn();
      await env.hive.settings.put('settings.theme', 'dark');
      await container.read(sessionProvider.notifier).logOut();

      expect(container.read(sessionProvider), SessionState.signedOut);
      expect(await env.tokens.read(), isNull);
      expect(env.hive.cache.isEmpty, isTrue);
      expect(env.hive.settings.isEmpty, isTrue);
    });

    test('logOut still ends the session when the API is offline', () async {
      final (env, container) = await signedIn();
      env.simulation = MockApiSimulation.offline;
      await container.read(sessionProvider.notifier).logOut();
      expect(container.read(sessionProvider), SessionState.signedOut);
      expect(await env.tokens.read(), isNull);
    });

    test('onboardingCompleted and debugOverride update the flags', () async {
      final container = AuthTestEnv(
        session: const SessionState(
          ready: true,
          loggedIn: true,
          onboardingDone: false,
        ),
      ).container();
      final session = container.read(sessionProvider.notifier);
      session.onboardingCompleted();
      expect(container.read(sessionProvider).onboardingDone, isTrue);
      session.debugOverride(onboardingDone: false);
      expect(container.read(sessionProvider).flags, (
        loggedIn: true,
        onboardingDone: false,
      ));
    });

    test('a seeded session still signs out when tokens are cleared', () async {
      final env = AuthTestEnv(
        session: const SessionState(
          ready: true,
          loggedIn: true,
          onboardingDone: true,
        ),
      );
      final container = env.container();
      expect(container.read(sessionProvider).loggedIn, isTrue);
      await env.tokens.clear();
      await settleAsync();
      expect(container.read(sessionProvider), SessionState.signedOut);
    });
  });

  group('router redirect with the real session', () {
    String? redirect(SessionState s, String location) =>
        sessionRedirect(s.flags, location);
    const onboarding = SessionState(
      ready: true,
      loggedIn: true,
      onboardingDone: false,
    );
    const done = SessionState(
      ready: true,
      loggedIn: true,
      onboardingDone: true,
    );

    test('signed out → /welcome', () {
      expect(redirect(SessionState.signedOut, '/learn'), '/welcome');
      expect(redirect(SessionState.signedOut, '/log-in'), isNull);
    });

    test('not onboarded → onboarding', () {
      expect(redirect(onboarding, '/learn'), '/onboarding/daily-goal');
      expect(redirect(onboarding, '/onboarding/hand'), isNull);
    });

    test('onboarded → /learn', () {
      expect(redirect(done, '/welcome'), '/learn');
      expect(redirect(done, '/onboarding/daily-goal'), '/learn');
      expect(redirect(done, '/dictionary'), isNull);
    });

    test('after a real log in the flags route to /learn', () async {
      final container = AuthTestEnv().container();
      await settleAsync();
      expect(redirect(container.read(sessionProvider), '/learn'), '/welcome');
      container.listen(logInFormProvider, (_, _) {});
      await container
          .read(logInFormProvider.notifier)
          .logIn(email: 'learner@ishara.test', password: 'password1');
      expect(redirect(container.read(sessionProvider), '/log-in'), '/learn');
    });
  });
}
