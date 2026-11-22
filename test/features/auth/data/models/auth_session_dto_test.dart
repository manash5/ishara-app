import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/auth/data/models/auth_session_dto.dart';
import 'package:ishara_app/features/profile/domain/entities/user_profile.dart';

import '../../../../helpers/mock_api.dart';

void main() {
  for (final name in [
    'auth/login_200',
    'auth/register_201',
    'auth/google_200',
    'auth/refresh_200',
    'auth/reset_password_200',
  ]) {
    test('parses the $name session', () {
      final session = AuthSessionDto.fromJson(
        fixtureData<Map<String, dynamic>>(name),
      ).toEntity();
      expect(session.accessToken, isNotEmpty);
      expect(session.refreshToken, isNotEmpty);
      expect(session.expiresAt.isUtc, isTrue);
      expect(session.user.id, isNotEmpty);
      expect(session.user.dominantHand, Hand.right);
    });
  }

  test('a new account still has onboarding to do', () {
    final session = AuthSessionDto.fromJson(
      fixtureData<Map<String, dynamic>>('auth/register_201'),
    ).toEntity();
    expect(session.user.onboardingDone, isFalse);
  });
}
