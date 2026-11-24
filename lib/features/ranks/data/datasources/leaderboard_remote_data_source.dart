import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/api/api_endpoints.dart';
import '../../../../core/services/api/api_response.dart';
import '../models/weekly_leaderboard_dto.dart';

/// `/leaderboard` over the REST API. Throws `AppException`.
class LeaderboardRemoteDataSource {
  const LeaderboardRemoteDataSource(this._api);

  final ApiClient _api;

  Future<WeeklyLeaderboardDto> fetchWeekly() async {
    final response = await _api.get(ApiEndpoints.getWeeklyLeaderboard);
    return ApiEnvelope.fromJson(
      response.data,
      (d) => WeeklyLeaderboardDto.fromJson(d! as Map<String, dynamic>),
    ).requireData;
  }
}
