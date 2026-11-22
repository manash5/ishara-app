import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/api/api_endpoints.dart';
import '../../../../core/services/api/api_response.dart';
import '../models/path_dto.dart';

/// `/path` over the REST API. Throws `AppException`.
class PathRemoteDataSource {
  const PathRemoteDataSource(this._api);

  final ApiClient _api;

  Future<PathDto> fetchPath() async {
    final response = await _api.get(ApiEndpoints.getPath);
    return ApiEnvelope.fromJson(
      response.data,
      (d) => PathDto.fromJson(d! as Map<String, dynamic>),
    ).requireData;
  }
}
