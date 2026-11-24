import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/api/api_endpoints.dart';
import '../../../../core/services/api/api_response.dart';
import '../models/profile_update_dto.dart';
import '../models/user_profile_dto.dart';

/// `/me` over the REST API. Throws `AppException`.
class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._api);

  final ApiClient _api;

  Future<UserProfileDto> fetchProfile() async {
    final response = await _api.get(ApiEndpoints.getProfile);
    return _parseProfile(response.data);
  }

  Future<UserProfileDto> updateProfile(ProfileUpdateDto update) async {
    final response = await _api.put(
      ApiEndpoints.getProfile,
      data: update.toJson(),
    );
    return _parseProfile(response.data);
  }

  Future<void> deleteAccount() => _api.delete(ApiEndpoints.getProfile);

  static UserProfileDto _parseProfile(Object? body) => ApiEnvelope.fromJson(
    body,
    (d) => UserProfileDto.fromJson(d! as Map<String, dynamic>),
  ).requireData;
}
