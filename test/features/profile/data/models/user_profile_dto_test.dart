import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/profile/data/models/profile_update_dto.dart';
import 'package:ishara_app/features/profile/data/models/user_profile_dto.dart';
import 'package:ishara_app/features/profile/domain/entities/profile_update.dart';
import 'package:ishara_app/features/profile/domain/entities/user_profile.dart';

import '../../../../helpers/mock_api.dart';

void main() {
  for (final name in ['me/get_200', 'me/put_200', 'me/onboarding_200']) {
    test('parses $name', () {
      final profile = UserProfileDto.fromJson(
        fixtureData<Map<String, dynamic>>(name),
      ).toEntity();
      expect(profile.id, FixtureIds.user);
      expect(profile.onboardingDone, isTrue);
      expect(profile.timezone, 'Asia/Kathmandu');
      expect(profile.stats.weekXp, hasLength(7));
    });
  }

  test('toJson round-trips (used for the cache)', () {
    final dto = UserProfileDto.fromJson(
      fixtureData<Map<String, dynamic>>('me/get_200'),
    );
    final json = dto.toJson();
    json['stats'] = dto.stats.toJson();
    expect(UserProfileDto.fromJson(json), dto);
  });

  test('"left" maps to Hand.left', () {
    final dto = UserProfileDto.fromJson({
      ...fixtureData<Map<String, dynamic>>('me/get_200'),
      'dominantHand': 'left',
    });
    expect(dto.toEntity().dominantHand, Hand.left);
  });

  test('ProfileUpdateDto leaves out unchanged fields', () {
    final dto = ProfileUpdateDto.fromEntity(
      const ProfileUpdate(displayName: ' Asha ', timezone: 'Asia/Kathmandu'),
    );
    expect(dto.toJson(), {'displayName': 'Asha', 'timezone': 'Asia/Kathmandu'});
  });
}
