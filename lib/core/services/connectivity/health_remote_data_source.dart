import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../api/api_response.dart';

/// `GET /health` data (docs/api-contract.md → Health).
class HealthDto {
  const HealthDto({required this.status});

  factory HealthDto.fromJson(Map<String, dynamic> json) =>
      HealthDto(status: json['status'] as String);

  /// "ok" when the API is up.
  final String status;
}

/// `GET /health`: one quick probe, with no retries or back-off.
class HealthRemoteDataSource {
  const HealthRemoteDataSource(this._api);

  final ApiClient _api;

  /// Throws `AppException` (a `NetworkException` when unreachable).
  Future<HealthDto> check() async {
    final response = await _api.get(
      ApiEndpoints.health,
      options: Options()..disableRetry = true,
    );
    return ApiEnvelope.fromJson(
      response.data,
      (d) => HealthDto.fromJson(d! as Map<String, dynamic>),
    ).requireData;
  }
}
