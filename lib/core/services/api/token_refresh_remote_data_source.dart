import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'api_response.dart';
import 'token_storage.dart';

/// `POST /auth/refresh`. Uses a bare client (no auth or retry interceptors),
/// so a failing refresh can't loop. [AuthTokens] is the response DTO; the
/// interceptor saves it through `TokenStorage`.
class TokenRefreshRemoteDataSource {
  const TokenRefreshRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthTokens> refresh(String refreshToken) async {
    final response = await _dio.post<dynamic>(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );
    return ApiEnvelope.fromJson(response.data, AuthTokens.fromJson).requireData;
  }
}
