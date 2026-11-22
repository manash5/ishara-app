import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:ishara_app/features/profile/data/models/user_profile_dto.dart';
import 'package:ishara_app/features/profile/domain/entities/profile_update.dart';
import 'package:ishara_app/features/profile/presentation/providers/profile_editor_provider.dart';
import 'package:ishara_app/features/profile/presentation/providers/profile_provider.dart';

import '../../../../helpers/mock_api.dart';
import '../../../auth/auth_test_utils.dart';

void main() {
  const signedIn = SessionState(
    ready: true,
    loggedIn: true,
    onboardingDone: true,
  );

  group('userProfileProvider', () {
    test('shows the cache first, then the fresh profile', () async {
      final env = AuthTestEnv(session: signedIn);
      await ProfileLocalDataSource(env.hive).write(
        UserProfileDto.fromJson(fixtureData<Map<String, dynamic>>('me/get_200'))
            .copyWith(displayName: 'Cached name'),
      );
      final container = env.container();
      final names = <String?>[];
      container.listen(
        userProfileProvider,
        (_, next) => names.add(next.value?.displayName),
        fireImmediately: true,
      );
      await settleAsync();
      expect(names.whereType<String>().toList(), [
        'Cached name',
        'Manash Lamichhane',
      ]);
      expect(
        container.read(profileSummaryProvider).value?.name,
        'Manash Lamichhane',
      );
    });

    test('offline without cache → AsyncError carrying a Failure', () async {
      final env = AuthTestEnv(session: signedIn)
        ..simulation = MockApiSimulation.offline;
      final container = env.container();
      container.listen(userProfileProvider, (_, _) {});
      await settleAsync();
      expect(container.read(userProfileProvider).error, isA<NetworkFailure>());
      expect(
        container.read(profileSummaryProvider).error,
        isA<NetworkFailure>(),
      );
    });
  });

  group('ProfileEditor', () {
    test('update reaches userProfileProvider through the cache', () async {
      final env = AuthTestEnv(session: signedIn);
      final container = env.container();
      container.listen(userProfileProvider, (_, _) {});
      await settleAsync();
      expect(container.read(userProfileProvider).value?.dailyGoalMinutes, 10);

      final failure = await container
          .read(profileEditorProvider.notifier)
          .update(const ProfileUpdate(dailyGoalMinutes: 20));
      await settleAsync();

      expect(failure, isNull);
      expect(container.read(profileEditorProvider), isFalse);
      expect(container.read(userProfileProvider).value?.dailyGoalMinutes, 20);
    });

    test('update failure is returned, profile unchanged', () async {
      final env = AuthTestEnv(session: signedIn);
      final container = env.container();
      container.listen(userProfileProvider, (_, _) {});
      await settleAsync();
      env.simulation = MockApiSimulation.serverError;

      final failure = await container
          .read(profileEditorProvider.notifier)
          .update(const ProfileUpdate(dailyGoalMinutes: 20));
      expect(failure, isA<ServerFailure>());
      expect(container.read(userProfileProvider).value?.dailyGoalMinutes, 10);
    });

    test('deleteAccount signs out and clears the device', () async {
      final env = AuthTestEnv(session: signedIn);
      await env.storeTokens();
      final container = env.container();
      container.listen(userProfileProvider, (_, _) {});
      await settleAsync();

      final failure = await container
          .read(profileEditorProvider.notifier)
          .deleteAccount();
      expect(failure, isNull);
      expect(container.read(sessionProvider), SessionState.signedOut);
      expect(await env.tokens.read(), isNull);
      expect(env.hive.cache.isEmpty, isTrue);
    });

    test('deleteAccount failure keeps the session', () async {
      final env = AuthTestEnv(session: signedIn)
        ..simulation = MockApiSimulation.offline;
      await env.storeTokens();
      final container = env.container();
      final failure = await container
          .read(profileEditorProvider.notifier)
          .deleteAccount();
      expect(failure, isA<NetworkFailure>());
      expect(container.read(sessionProvider).loggedIn, isTrue);
    });
  });
}
