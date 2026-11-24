import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../entities/profile_update.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Changes the learner's name, daily goal, dominant hand or timezone.
class UpdateProfile {
  const UpdateProfile(this._repository);

  final ProfileRepository _repository;

  /// The daily goals the app offers (minutes).
  static const dailyGoals = [5, 10, 15, 20];

  Future<Result<UserProfile>> call(ProfileUpdate update) async {
    if (update.isEmpty) return const Err(ValidationFailure());
    final goal = update.dailyGoalMinutes;
    if (goal != null && !dailyGoals.contains(goal)) {
      return const Err(ValidationFailure('Pick a daily goal of 5–20 minutes.'));
    }
    final name = update.displayName;
    if (name != null && name.trim().isEmpty) {
      return const Err(ValidationFailure('Enter your name.'));
    }
    return _repository.updateProfile(update);
  }
}
