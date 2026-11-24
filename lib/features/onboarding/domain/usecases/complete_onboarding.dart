import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../entities/onboarding_answers.dart';
import '../repositories/onboarding_repository.dart';

/// Finishes onboarding with the learner's daily goal and hand.
class CompleteOnboarding {
  const CompleteOnboarding(this._repository);

  final OnboardingRepository _repository;

  /// The daily goals onboarding offers (minutes).
  static const dailyGoals = [5, 10, 15, 20];

  Future<Result<UserProfile>> call(OnboardingAnswers answers) async {
    if (!dailyGoals.contains(answers.dailyGoalMinutes)) {
      return const Err(ValidationFailure('Pick a daily goal.'));
    }
    if (answers.timezone.trim().isEmpty) {
      return const Err(ValidationFailure());
    }
    return _repository.complete(answers);
  }
}
