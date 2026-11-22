import '../../../../core/error/result.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../entities/onboarding_answers.dart';

abstract interface class OnboardingRepository {
  /// `POST /me/onboarding`: saves the answers and marks onboarding done. The
  /// returned profile replaces the cached one.
  Future<Result<UserProfile>> complete(OnboardingAnswers answers);
}
