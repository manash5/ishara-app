import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../auth/presentation/providers/session_provider.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/entities/onboarding_answers.dart';
import '../../domain/usecases/complete_onboarding.dart';
import 'daily_goal_options_provider.dart';
import 'onboarding_choices_provider.dart';

part 'onboarding_completion_provider.g.dart';

/// Sends the onboarding answers (`POST /me/onboarding`). `state` is true
/// while the request runs. On success the session's onboarding is done, so
/// the router redirect moves on to Learn.
@riverpod
class OnboardingCompletion extends _$OnboardingCompletion {
  @override
  bool build() => false;

  /// Returns the failure to show, or null on success.
  Future<Failure?> complete() async {
    if (state) return null;
    final choices = ref.read(onboardingChoicesProvider);
    final goal = ref
        .read(dailyGoalOptionsProvider)
        .where((o) => o.id == choices.dailyGoalId)
        .firstOrNull;
    if (goal == null) return const ValidationFailure('Pick a daily goal.');

    state = true;
    final result =
        await CompleteOnboarding(ref.read(onboardingRepositoryProvider))(
          OnboardingAnswers(
            dailyGoalMinutes: goal.minutes,
            dominantHand: switch (choices.hand) {
              DominantHand.left => Hand.left,
              DominantHand.right => Hand.right,
            },
          ),
        );
    if (!ref.mounted) return null;
    state = false;
    switch (result) {
      case Ok():
        ref.read(sessionProvider.notifier).onboardingCompleted();
        return null;
      case Err(:final failure):
        return failure;
    }
  }
}
