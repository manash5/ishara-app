import '../../../profile/domain/entities/user_profile.dart';

/// What the learner chose in onboarding 06–07 (`POST /me/onboarding`).
class OnboardingAnswers {
  const OnboardingAnswers({
    required this.dailyGoalMinutes,
    required this.dominantHand,
    this.timezone = defaultTimezone,
  });

  /// Ishara is for learners in Nepal, and the league week already runs on
  /// Kathmandu time. Dart only knows the zone's abbreviation, not its IANA
  /// name, so the app sends this until a timezone plugin is added.
  static const defaultTimezone = 'Asia/Kathmandu';

  final int dailyGoalMinutes;
  final Hand dominantHand;

  /// IANA name; the server uses it for streak days.
  final String timezone;
}
