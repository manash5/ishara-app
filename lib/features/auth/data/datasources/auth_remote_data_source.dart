import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/api/api_endpoints.dart';
import '../../../../core/services/api/api_response.dart';
import '../models/auth_session_dto.dart';

/// `/auth/*` over the REST API (docs/api-contract.md → Auth). Throws
/// `AppException`.
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._api);

  final ApiClient _api;

  Future<AuthSessionDto> register({
    required String email,
    required String password,
    required String displayName,
  }) => _session(ApiEndpoints.userRegister, {
    'email': email,
    'password': password,
    'displayName': displayName,
  });

  Future<AuthSessionDto> logIn({
    required String email,
    required String password,
  }) =>
      _session(ApiEndpoints.userLogin, {'email': email, 'password': password});

  Future<AuthSessionDto> signInWithGoogle(String idToken) =>
      _session(ApiEndpoints.googleLogin, {'idToken': idToken});

  Future<void> requestPasswordReset(String email) =>
      _api.post(ApiEndpoints.forgotPassword, data: {'email': email});

  Future<AuthSessionDto> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) => _session(ApiEndpoints.resetPassword, {
    'email': email,
    'code': code,
    'newPassword': newPassword,
  });

  /// Revokes [refreshToken] (`POST /auth/logout`, needs the access token).
  Future<void> logOut(String refreshToken) =>
      _api.post(ApiEndpoints.logout, data: {'refreshToken': refreshToken});

  Future<AuthSessionDto> _session(String path, Map<String, Object> body) async {
    final response = await _api.post(path, data: body);
    return ApiEnvelope.fromJson(
      response.data,
      (d) => AuthSessionDto.fromJson(d! as Map<String, dynamic>),
    ).requireData;
  }
}
