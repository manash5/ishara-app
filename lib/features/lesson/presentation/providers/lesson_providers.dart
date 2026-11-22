import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/config/game_rules.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/repositories/lesson_repository_impl.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/lesson_result.dart';
import '../../domain/usecases/lesson_usecases.dart';

part 'lesson_providers.g.dart';

/// A lesson and its exercises (`GET /lessons/:id`).
@riverpod
Future<Lesson> lesson(Ref ref, String lessonId) async =>
    (await GetLesson(ref.watch(lessonRepositoryProvider))(lessonId))
        .getOrThrow();

/// The learner's hearts when a lesson starts: from their stats (`GET /me`),
/// or full if the profile hasn't loaded.
@riverpod
int startingHearts(Ref ref) =>
    ref.watch(userProfileProvider).value?.stats.hearts ?? GameRules.maxHearts;

/// Finished attempts by lesson id, so Lesson complete (26) can send the
/// same `clientEventId` however often it rebuilds.
@Riverpod(keepAlive: true)
class LessonAttempts extends _$LessonAttempts {
  @override
  Map<String, LessonAttempt> build() => const {};

  void record(LessonAttempt attempt) =>
      state = {...state, attempt.lessonId: attempt};
}

/// What the server awarded for the finished lesson
/// (`POST /lessons/:id/complete`, idempotent on `clientEventId`).
@riverpod
Future<LessonResult> lessonResult(Ref ref, String lessonId) async {
  final attempt =
      ref.read(lessonAttemptsProvider)[lessonId] ??
      // Opened without playing (deep link): a stable id per lesson keeps
      // retries idempotent.
      LessonAttempt(
        clientEventId: const Uuid().v5(Namespace.url.value, 'ishara:$lessonId'),
        lessonId: lessonId,
        mistakes: 0,
        duration: Duration.zero,
        completedAt: DateTime.now().toUtc(),
      );
  return (await CompleteLesson(ref.watch(lessonRepositoryProvider))(attempt))
      .getOrThrow();
}
