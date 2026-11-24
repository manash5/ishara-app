import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../profile/domain/entities/user_profile.dart';

part 'auth_session.freezed.dart';

/// A signed-in session (`/auth/register|login|google|reset-password`): the
/// learner it belongs to. Owned by **auth**.
///
/// The tokens never reach the domain: the auth repository saves them straight
/// into `TokenStorage`, the only place they are read or written.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({required UserProfile user}) = _AuthSession;
}
