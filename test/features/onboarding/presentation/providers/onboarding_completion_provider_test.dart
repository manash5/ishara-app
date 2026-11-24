import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/onboarding/presentation/providers/onboarding_choices_provider.dart';
import 'package:ishara_app/features/onboarding/presentation/providers/onboarding_completion_provider.dart';
import 'package:ishara_app/features/profile/data/datasources/profile_local_data_source.dart';

import '../../../auth/auth_test_utils.dart';

void main() {
  const onboarding = SessionState(
    ready: true,
    loggedIn: true,
    onboardingDone: false,
  );

  test(
    'sends the choices, caches the profile, completes the session',
    () async {
      final env = AuthTestEnv(session: onboarding);
      final container = env.container();
      container.listen(onboardingCompletionProvider, (_, _) {});
      container.read(onboardingChoicesProvider.notifier)
        ..selectDailyGoal('intense')
        ..selectHand(DominantHand.left);

      final pending = container
          .read(onboardingCompletionProvider.notifier)
          .complete();
      expect(container.read(onboardingCompletionProvider), isTrue);
      final failure = await pending;

      expect(failure, isNull);
      expect(container.read(onboardingCompletionProvider), isFalse);
      expect(container.read(sessionProvider).onboardingDone, isTrue);
      expect(
        ProfileLocalDataSource(env.hive).read()?.value.onboardingDone,
        isTrue,
      );
    },
  );

  test('a failure is returned and onboarding stays open', () async {
    final env = AuthTestEnv(session: onboarding)
      ..simulation = MockApiSimulation.offline;
    final container = env.container();
    container.listen(onboardingCompletionProvider, (_, _) {});

    final failure = await container
        .read(onboardingCompletionProvider.notifier)
        .complete();

    expect(failure, isA<NetworkFailure>());
    expect(container.read(onboardingCompletionProvider), isFalse);
    expect(container.read(sessionProvider).onboardingDone, isFalse);
  });

  test('an unknown goal id is rejected locally', () async {
    final env = AuthTestEnv(session: onboarding);
    final container = env.container();
    container.listen(onboardingCompletionProvider, (_, _) {});
    container.read(onboardingChoicesProvider.notifier).selectDailyGoal('nope');
    final failure = await container
        .read(onboardingCompletionProvider.notifier)
        .complete();
    expect(failure, isA<ValidationFailure>());
  });
}
