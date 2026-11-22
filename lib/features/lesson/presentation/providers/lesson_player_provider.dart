import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/widgets/widgets.dart';
import 'fake_lesson_provider.dart';
import 'lesson_models.dart';

part 'lesson_player_provider.g.dart';

/// What a match-pairs tap did, so the view can add the haptic.
enum MatchTap { selected, matched, wrong }

/// Drives the lesson player (Figma 18–25) over the fake lesson.
///
/// Rules (lessons-gamification.md): a wrong non-camera answer costs one
/// heart; camera mistakes never do; at 0 hearts the lesson stops (28).
/// "Can't use the camera now" swaps every remaining camera exercise for a
/// recognise exercise on the same sign, with no penalty.
@riverpod
class LessonPlayer extends _$LessonPlayer {
  @override
  LessonPlayerState build(String lessonId) => LessonPlayerState(
    exercises: ref.watch(fakeLessonProvider(lessonId)).exercises,
    hearts: ref.watch(startingHeartsProvider),
  );

  bool get _answering => state.phase == LessonPhase.answering;

  /// Recognise / pick the sign: choose option [i].
  void select(int i) {
    if (!_answering) return;
    state = state.copyWith(selected: () => i);
  }

  /// Footer "Check" / "Continue". Returns the result to show in the
  /// `FeedbackSheet`, or null when there's nothing to show (watch exercise,
  /// or hearts just ran out).
  FeedbackResult? check() {
    if (!_answering || !state.canCheck) return null;
    switch (state.exercise) {
      case WatchExercise():
        continueNext();
        return null;
      case final RecogniseExercise e:
        return _grade(state.selected == e.answerIndex);
      case final PickSignExercise e:
        return _grade(state.selected == e.answerIndex);
      case MatchPairsExercise():
        return _showFeedback(FeedbackResult.correct);
      case CameraExercise():
        return null;
    }
  }

  FeedbackResult? _grade(bool correct) {
    if (correct) return _showFeedback(FeedbackResult.correct);
    _loseHeart();
    if (state.phase == LessonPhase.outOfHearts) return null;
    return _showFeedback(FeedbackResult.incorrect);
  }

  FeedbackResult _showFeedback(FeedbackResult result) {
    state = state.copyWith(phase: LessonPhase.feedback, feedback: () => result);
    return result;
  }

  void _loseHeart() {
    final hearts = state.hearts - 1;
    state = state.copyWith(
      hearts: hearts,
      mistakes: state.mistakes + 1,
      phase: hearts <= 0 ? LessonPhase.outOfHearts : null,
    );
  }

  /// Match pairs: tap word [word] (left) or video row [video] (right).
  MatchTap tapMatch({int? word, int? video}) {
    final e = state.exercise;
    if (!_answering || e is! MatchPairsExercise) return MatchTap.selected;
    final m = state.match;
    final pickedWord = word ?? m.word;
    final pickedVideo = video ?? m.video;
    if (pickedWord == null || pickedVideo == null) {
      state = state.copyWith(
        match: MatchProgress(
          word: pickedWord,
          video: pickedVideo,
          matched: m.matched,
        ),
      );
      return MatchTap.selected;
    }
    if (e.videoOrder[pickedVideo] == pickedWord) {
      state = state.copyWith(
        match: MatchProgress(matched: {...m.matched, pickedWord}),
      );
      return MatchTap.matched;
    }
    state = state.copyWith(
      match: MatchProgress(
        matched: m.matched,
        wrongWord: pickedWord,
        wrongVideo: pickedVideo,
      ),
    );
    _loseHeart();
    return MatchTap.wrong;
  }

  /// Fake camera result (until the recognition pipeline lands). Camera
  /// mistakes never cost hearts. Returns the result to show, or null while
  /// fingerspelling still has letters to go.
  FeedbackResult? cameraResult(CameraOutcome outcome) {
    final e = state.exercise;
    if (!_answering || e is! CameraExercise) return null;
    if (outcome == CameraOutcome.almost) {
      state = state.copyWith(cameraOutcome: () => CameraOutcome.almost);
      return _showFeedback(FeedbackResult.almost);
    }
    if (e is FingerspellExercise && state.letterIndex < e.letters.length - 1) {
      state = state.copyWith(
        letterIndex: state.letterIndex + 1,
        cameraOutcome: () => null,
      );
      return null;
    }
    state = state.copyWith(cameraOutcome: () => CameraOutcome.correct);
    return _showFeedback(FeedbackResult.correct);
  }

  /// "Try again" on the almost sheet (24).
  void retry() {
    if (state.phase != LessonPhase.feedback) return;
    state = state.copyWith(
      phase: LessonPhase.answering,
      feedback: () => null,
      cameraOutcome: () => null,
    );
  }

  /// "Can't use the camera now": swap the current and every later camera
  /// exercise for its recognise fallback. No penalty.
  void skipCamera() {
    if (!state.exercise.isCamera) return;
    state = state.copyWith(
      exercises: [
        for (final (i, e) in state.exercises.indexed)
          if (i >= state.index && e is CameraExercise) e.fallback else e,
      ],
      phase: LessonPhase.answering,
      feedback: () => null,
      selected: () => null,
      cameraOutcome: () => null,
      letterIndex: 0,
      cameraSkipped: true,
    );
  }

  /// After the feedback sheet: next exercise, or finish.
  void continueNext() {
    if (state.phase == LessonPhase.outOfHearts) return;
    if (state.isLast) {
      state = state.copyWith(phase: LessonPhase.finished);
      return;
    }
    state = state.copyWith(
      index: state.index + 1,
      phase: LessonPhase.answering,
      feedback: () => null,
      selected: () => null,
      match: const MatchProgress(),
      letterIndex: 0,
      cameraOutcome: () => null,
    );
  }
}
