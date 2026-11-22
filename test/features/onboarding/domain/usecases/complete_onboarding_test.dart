import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/onboarding/domain/entities/onboarding_answers.dart';
import 'package:ishara_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:ishara_app/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:ishara_app/features/profile/data/models/user_profile_dto.dart';
import 'package:ishara_app/features/profile/domain/entities/user_profile.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_api.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late MockOnboardingRepository repo;
  final profile = UserProfileDto.fromJson(
    fixtureData<Map<String, dynamic>>('me/onboarding_200'),
  ).toEntity();

  setUpAll(
    () => registerFallbackValue(
      const OnboardingAnswers(dailyGoalMinutes: 10, dominantHand: Hand.right),
    ),
  );
  setUp(() => repo = MockOnboardingRepository());

  test('defaults the timezone to Asia/Kathmandu', () {
    const answers = OnboardingAnswers(
      dailyGoalMinutes: 10,
      dominantHand: Hand.left,
    );
    expect(answers.timezone, 'Asia/Kathmandu');
  });

  test('sends valid answers', () async {
    when(() => repo.complete(any())).thenAnswer((_) async => Ok(profile));
    final result = await CompleteOnboarding(repo)(
      const OnboardingAnswers(dailyGoalMinutes: 15, dominantHand: Hand.left),
    );
    expect(result.valueOrNull?.onboardingDone, isTrue);
  });

  test('rejects an unknown goal or empty timezone', () async {
    final badGoal = await CompleteOnboarding(repo)(
      const OnboardingAnswers(dailyGoalMinutes: 3, dominantHand: Hand.left),
    );
    expect((badGoal as Err).failure, isA<ValidationFailure>());
    final badZone = await CompleteOnboarding(repo)(
      const OnboardingAnswers(
        dailyGoalMinutes: 5,
        dominantHand: Hand.left,
        timezone: ' ',
      ),
    );
    expect((badZone as Err).failure, isA<ValidationFailure>());
    verifyNever(() => repo.complete(any()));
  });
}
