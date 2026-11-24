import '../services/api/api_client.dart';
import '../services/api/api_endpoints.dart';
import '../services/api/api_response.dart';
import 'sync_event.dart';
import 'sync_result_dto.dart';

/// `POST /progress/sync`: sends queued events, oldest first.
class SyncRemoteDataSource {
  const SyncRemoteDataSource(this._api);

  final ApiClient _api;

  /// One result per event, in the same order. Throws `AppException`.
  Future<List<SyncResultDto>> sync(List<SyncEvent> events) async {
    final response = await _api.post(
      ApiEndpoints.syncProgress,
      data: {
        'events': [for (final e in events) e.toWire()],
      },
    );
    return ApiEnvelope.fromJson(
      response.data,
      (d) => SyncResponseDto.fromJson(d! as Map<String, dynamic>),
    ).requireData.results;
  }
}
