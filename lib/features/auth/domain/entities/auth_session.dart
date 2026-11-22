import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../profile/domain/entities/user_profile.dart';

part 'auth_session.freezed.dart';

/// A signed-in session (`/auth/register|login|google|refresh|reset-password`).
/// Owned by **auth**; the router's session state reads it once auth's data
/// layer lands.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required UserProfile user,
  }) = _AuthSession;
}
