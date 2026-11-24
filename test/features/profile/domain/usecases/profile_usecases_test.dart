import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/profile/data/models/user_profile_dto.dart';
import 'package:ishara_app/features/profile/domain/entities/profile_update.dart';
import 'package:ishara_app/features/profile/domain/entities/user_profile.dart';
import 'package:ishara_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:ishara_app/features/profile/domain/usecases/delete_account.dart';
import 'package:ishara_app/features/profile/domain/usecases/get_cached_profile.dart';
import 'package:ishara_app/features/profile/domain/usecases/get_profile.dart';
import 'package:ishara_app/features/profile/domain/usecases/update_profile.dart';
import 'package:ishara_app/features/profile/domain/usecases/watch_profile.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_api.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repo;
  final profile = UserProfileDto.fromJson(
    fixtureData<Map<String, dynamic>>('me/get_200'),
  ).toEntity();

  setUpAll(() => registerFallbackValue(const ProfileUpdate()));
  setUp(() => repo = MockProfileRepository());

  test('GetProfile, GetCachedProfile, WatchProfile delegate', () async {
    when(() => repo.getProfile()).thenAnswer((_) async => Ok(profile));
    when(() => repo.cachedProfile()).thenAnswer((_) async => const Ok(null));
    when(() => repo.watchProfile())
        .thenAnswer((_) => Stream.value(Ok(profile)));

    expect((await GetProfile(repo)()).valueOrNull, profile);
    expect((await GetCachedProfile(repo)()).valueOrNull, isNull);
    expect((await WatchProfile(repo)().first).valueOrNull, profile);
  });

  group('UpdateProfile', () {
    test('an empty update is rejected', () async {
      final result = await UpdateProfile(repo)(const ProfileUpdate());
      expect((result as Err).failure, isA<ValidationFailure>());
      verifyNever(() => repo.updateProfile(any()));
    });

    test('a goal outside 5/10/15/20 is rejected', () async {
      final result = await UpdateProfile(repo)(
        const ProfileUpdate(dailyGoalMinutes: 7),
      );
      expect((result as Err).failure, isA<ValidationFailure>());
    });

    test('a blank name is rejected', () async {
      final result = await UpdateProfile(repo)(
        const ProfileUpdate(displayName: '  '),
      );
      expect((result as Err).failure.message, 'Enter your name.');
    });

    test('a valid update reaches the repository', () async {
      when(() => repo.updateProfile(any()))
          .thenAnswer((_) async => Ok(profile));
      final result = await UpdateProfile(repo)(
        const ProfileUpdate(dominantHand: Hand.left),
      );
      expect(result.isOk, isTrue);
    });
  });

  test('DeleteAccount delegates', () async {
    when(() => repo.deleteAccount()).thenAnswer((_) async => const Ok(null));
    expect((await DeleteAccount(repo)()).isOk, isTrue);
  });
}
