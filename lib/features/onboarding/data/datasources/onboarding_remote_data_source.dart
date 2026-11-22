import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/api/api_endpoints.dart';
import '../../../../core/services/api/api_response.dart';
import '../../../profile/data/models/user_profile_dto.dart';
import '../models/onboarding_request_dto.dart';

/// `POST /me/onboarding`. Throws `AppException`.
class OnboardingRemoteDataSource {
  const OnboardingRemoteDataSource(this._api);

  final ApiClient _api;

  Future<UserProfileDto> complete(OnboardingRequestDto request) async {
    final response = await _api.post(
      ApiEndpoints.submitOnboarding,
      data: request.toJson(),
    );
    return ApiEnvelope.fromJson(
      response.data,
      (d) => UserProfileDto.fromJson(d! as Map<String, dynamic>),
    ).requireData;
  }
}
