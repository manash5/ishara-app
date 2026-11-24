import '../../../../core/services/storage/hive_service.dart';
import '../models/lesson_dto.dart';

/// Lessons cached in Hive (`lesson.<id>`). Throws [CacheException]. The
/// offline queue of finished lessons is the core `SyncQueue`.
///
/// A lesson carries no video URLs (videos load by sign id), so caching it
/// never stores a short-lived signed URL.
class LessonLocalDataSource {
  const LessonLocalDataSource(this._hive);

  final HiveService _hive;

  static String lessonKey(String lessonId) => 'lesson.$lessonId';

  CacheEntry<LessonDto>? readLesson(String lessonId) => _hive.readCache(
    lessonKey(lessonId),
    (json) => LessonDto.fromJson(json! as Map<String, dynamic>),
  );

  Future<void> writeLesson(String lessonId, LessonDto lesson) =>
      _hive.putCache(lessonKey(lessonId), lesson.toJson());
}
