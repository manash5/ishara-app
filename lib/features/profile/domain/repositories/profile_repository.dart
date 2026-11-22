import '../../../../core/error/result.dart';
import '../entities/user_profile.dart';

abstract interface class ProfileRepository {
  /// The signed-in learner (`GET /me`).
  Future<Result<UserProfile>> getProfile();
}
