import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/config/game_rules.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/repositories/lesson_repository_impl.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/lesson_result.dart';
import '../../domain/usecases/complete_lesson.dart';
import '../../domain/usecases/get_lesson.dart';

part 'lesson_providers.g.dart';

/// A lesson and its exercises (`GET /lessons/:id`): the cached lesson first,
/// then the fresh one. Invalidate to retry.
@riverpod
Stream<Lesson> lesson(Ref ref, String lessonId) =>
    GetLesson(ref.watch(lessonRepositoryProvider))(lessonId)
        .map((result) => result.getOrThrow());

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

/// The last lesson the server recorded this session (hearts, XP, streak),
/// or null until one completes. The Streak screen (27) reads it.
@Riverpod(keepAlive: true)
class LatestLessonResult extends _$LatestLessonResult {
  @override
  LessonResult? build() => null;

  /// Stores [result] and refetches the profile so stats (XP, streak,
  /// hearts) match what the server awarded.
  void record(LessonResult result) {
    state = result;
    ref.invalidate(userProfileProvider);
  }
}

/// What the server awarded for the finished lesson
/// (`POST /lessons/:id/complete`, idempotent on `clientEventId`). Offline or
/// on a server error, the attempt is queued for `POST /progress/sync` and
/// this fails; Try again resends the same `clientEventId`.
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
  // Read before the request: the keepAlive notifier outlives this provider.
  final latest = ref.read(latestLessonResultProvider.notifier);
  final result = (await CompleteLesson(ref.watch(lessonRepositoryProvider))(
    attempt,
  )).getOrThrow();
  latest.record(result);
  return result;
}
