import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../profile/data/models/user_profile_dto.dart';
import '../../domain/entities/auth_session.dart';

part 'auth_session_dto.freezed.dart';
part 'auth_session_dto.g.dart';

/// Session JSON from the `/auth/*` endpoints (docs/api-contract.md → Session).
@freezed
abstract class AuthSessionDto with _$AuthSessionDto {
  const AuthSessionDto._();

  const factory AuthSessionDto({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required UserProfileDto user,
  }) = _AuthSessionDto;

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDtoFromJson(json);

  AuthSession toEntity() => AuthSession(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresAt: expiresAt,
    user: user.toEntity(),
  );
}
