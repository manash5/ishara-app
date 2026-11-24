import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_attempt_dto.dart';
import 'package:ishara_app/features/lesson/domain/entities/lesson_result.dart';

void main() {
  final attempt = LessonAttempt(
    clientEventId: 'e-1',
    lessonId: 'l-1',
    mistakes: 2,
    duration: const Duration(minutes: 4, seconds: 12),
    completedAt: DateTime.utc(2026, 11, 22, 9),
  );
  final dto = LessonAttemptDto.fromEntity(attempt);

  test('the complete body matches the contract (no lesson id)', () {
    expect(dto.toCompleteBody(), {
      'clientEventId': 'e-1',
      'mistakes': 2,
      'durationSeconds': 252,
      'completedAt': '2026-11-22T09:00:00.000Z',
    });
  });

  test('the sync payload carries the lesson id (no clientEventId or type)', () {
    final dto = LessonAttemptDto.fromEntity(attempt);
    expect(dto.toSyncPayload(), {
      'lessonId': attempt.lessonId,
      'mistakes': attempt.mistakes,
      'durationSeconds': attempt.duration.inSeconds,
      'completedAt': attempt.completedAt.toUtc().toIso8601String(),
    });
  });
}
