import 'user_profile.dart';

/// The fields `PUT /me` can change. Null fields are left as they are.
class ProfileUpdate {
  const ProfileUpdate({
    this.displayName,
    this.dailyGoalMinutes,
    this.dominantHand,
    this.timezone,
  });

  final String? displayName;
  final int? dailyGoalMinutes;
  final Hand? dominantHand;
  final String? timezone;

  bool get isEmpty =>
      displayName == null &&
      dailyGoalMinutes == null &&
      dominantHand == null &&
      timezone == null;
}
