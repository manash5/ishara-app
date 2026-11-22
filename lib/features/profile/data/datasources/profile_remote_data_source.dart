import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/api/api_endpoints.dart';
import '../../../../core/services/api/api_response.dart';
import '../models/user_profile_dto.dart';

/// `/me` over the REST API. Throws `AppException`.
class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._api);

  final ApiClient _api;

  Future<UserProfileDto> fetchProfile() async {
    final response = await _api.get(ApiEndpoints.getProfile);
    return ApiEnvelope.fromJson(
      response.data,
      (d) => UserProfileDto.fromJson(d! as Map<String, dynamic>),
    ).requireData;
  }
}
