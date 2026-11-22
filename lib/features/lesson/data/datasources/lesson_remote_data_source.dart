import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/api/api_endpoints.dart';
import '../../../../core/services/api/api_response.dart';
import '../models/lesson_attempt_dto.dart';
import '../models/lesson_dto.dart';
import '../models/lesson_result_dto.dart';
import '../models/progress_sync_dto.dart';

/// `/lessons` and `/progress` over the REST API. Throws `AppException`.
class LessonRemoteDataSource {
  const LessonRemoteDataSource(this._api);

  final ApiClient _api;

  Future<LessonDto> fetchLesson(String lessonId) async {
    final response = await _api.get(ApiEndpoints.getLessonById(lessonId));
    return ApiEnvelope.fromJson(
      response.data,
      (d) => LessonDto.fromJson(d! as Map<String, dynamic>),
    ).requireData;
  }

  /// `POST /lessons/:id/complete` (idempotent on `clientEventId`).
  Future<LessonResultDto> completeLesson(LessonAttemptDto attempt) async {
    final response = await _api.post(
      ApiEndpoints.completeLesson(attempt.lessonId),
      data: attempt.toCompleteBody(),
    );
    return ApiEnvelope.fromJson(
      response.data,
      (d) => LessonResultDto.fromJson(d! as Map<String, dynamic>),
    ).requireData;
  }

  /// `POST /progress/sync` with [events] in the order given (oldest first).
  Future<ProgressSyncDto> syncProgress(List<LessonAttemptDto> events) async {
    final response = await _api.post(
      ApiEndpoints.syncProgress,
      data: {
        'events': [for (final e in events) e.toSyncEvent()],
      },
    );
    return ApiEnvelope.fromJson(
      response.data,
      (d) => ProgressSyncDto.fromJson(d! as Map<String, dynamic>),
    ).requireData;
  }
}
