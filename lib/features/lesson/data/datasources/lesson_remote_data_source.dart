import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/api/api_endpoints.dart';
import '../../../../core/services/api/api_response.dart';
import '../../domain/entities/lesson_result.dart';
import '../models/lesson_dto.dart';
import '../models/lesson_result_dto.dart';

/// `/lessons` over the REST API. Throws `AppException`.
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

  Future<LessonResultDto> completeLesson(LessonAttempt attempt) async {
    final response = await _api.post(
      ApiEndpoints.completeLesson(attempt.lessonId),
      data: lessonAttemptToJson(attempt),
    );
    return ApiEnvelope.fromJson(
      response.data,
      (d) => LessonResultDto.fromJson(d! as Map<String, dynamic>),
    ).requireData;
  }
}
