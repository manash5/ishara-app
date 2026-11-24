import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:ishara_app/features/onboarding/data/models/onboarding_request_dto.dart';
import 'package:ishara_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:ishara_app/features/onboarding/domain/entities/onboarding_answers.dart';
import 'package:ishara_app/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:ishara_app/features/profile/data/models/user_profile_dto.dart';
import 'package:ishara_app/features/profile/domain/entities/user_profile.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

class MockRemote extends Mock implements OnboardingRemoteDataSource {}

class MockLocal extends Mock implements ProfileLocalDataSource {}

void main() {
  const answers = OnboardingAnswers(
    dailyGoalMinutes: 15,
    dominantHand: Hand.left,
  );
  final profile = UserProfileDto.fromJson(
    fixtureData<Map<String, dynamic>>('me/onboarding_200'),
  );

  setUpAll(() {
    registerFallbackValue(OnboardingRequestDto.fromEntity(answers));
    registerFallbackValue(profile);
  });

  test('request body matches the contract', () {
    expect(OnboardingRequestDto.fromEntity(answers).toJson(), {
      'dailyGoalMinutes': 15,
      'dominantHand': 'left',
      'timezone': 'Asia/Kathmandu',
    });
  });

  test('success caches the returned profile', () async {
    final remote = MockRemote();
    final local = MockLocal();
    when(() => remote.complete(any())).thenAnswer((_) async => profile);
    when(() => local.write(any())).thenAnswer((_) async {});

    final result = await OnboardingRepositoryImpl(
      remote,
      local,
    ).complete(answers);

    expect(result.valueOrNull?.onboardingDone, isTrue);
    verify(() => local.write(profile)).called(1);
  });

  test('failure is an Err and nothing is cached', () async {
    final remote = MockRemote();
    final local = MockLocal();
    when(() => remote.complete(any()))
        .thenThrow(const ValidationException('Pick a daily goal.'));

    final result = await OnboardingRepositoryImpl(
      remote,
      local,
    ).complete(answers);

    expect((result as Err).failure, isA<ValidationFailure>());
    verifyNever(() => local.write(any()));
  });

  test('against the mock API: POST /me/onboarding', () async {
    final result = await OnboardingRepositoryImpl(
      OnboardingRemoteDataSource(mockApiClient()),
      ProfileLocalDataSource(TestHive.instance),
    ).complete(answers);
    expect(result.valueOrNull?.id, FixtureIds.user);
    expect(
      ProfileLocalDataSource(TestHive.instance).read()?.value.onboardingDone,
      isTrue,
    );
  });
}
