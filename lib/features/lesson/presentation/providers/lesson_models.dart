import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/exercise.dart';

export '../../domain/entities/exercise.dart';
export '../../domain/entities/lesson.dart';

/// Where the player is in the current exercise.
enum LessonPhase {
  /// The learner is answering.
  answering,

  /// A `FeedbackSheet` is showing [LessonPlayerState.feedback].
  feedback,

  /// Hearts ran out (Figma 28).
  outOfHearts,

  /// Every exercise is done → Lesson complete (26).
  finished,
}

/// What the fake camera reported (until the recognition pipeline lands).
enum CameraOutcome { correct, almost }

/// Match-pairs progress: the current word/video picks, finished rows and the
/// last wrong pair (shown in danger + shake until the next tap).
@immutable
class MatchProgress {
  const MatchProgress({
    this.word,
    this.video,
    this.matched = const {},
    this.wrongWord,
    this.wrongVideo,
  });

  /// Selected word index / video row.
  final int? word;
  final int? video;

  /// Word indices that are matched.
  final Set<int> matched;
  final int? wrongWord;
  final int? wrongVideo;
}

/// The lesson player's state (one per lesson).
@immutable
class LessonPlayerState {
  const LessonPlayerState({
    required this.exercises,
    required this.hearts,
    this.index = 0,
    this.mistakes = 0,
    this.selected,
    this.phase = LessonPhase.answering,
    this.feedback,
    this.match = const MatchProgress(),
    this.letterIndex = 0,
    this.cameraOutcome,
    this.cameraSkipped = false,
  });

  final List<Exercise> exercises;
  final int index;
  final int hearts;

  /// Wrong answers so far (camera "almost" doesn't count).
  final int mistakes;

  /// Selected option in recognise / pick-the-sign.
  final int? selected;
  final LessonPhase phase;

  /// Result of the last check while [phase] is [LessonPhase.feedback].
  final FeedbackResult? feedback;
  final MatchProgress match;

  /// Fingerspelling: index of the letter being signed.
  final int letterIndex;

  /// Last fake camera result on the current exercise (24 shows "almost").
  final CameraOutcome? cameraOutcome;

  /// "Can't use the camera now" was used — no more camera exercises.
  final bool cameraSkipped;

  Exercise get exercise => exercises[index];

  /// Header progress: exercises done (the current one counts once checked
  /// correct).
  double get progress {
    final done = index + (feedback == FeedbackResult.correct ? 1 : 0);
    return phase == LessonPhase.finished ? 1 : done / exercises.length;
  }

  bool get isLast => index == exercises.length - 1;

  /// Whether the footer action can be pressed.
  bool get canCheck => switch (exercise) {
    WatchExercise() => true,
    RecogniseExercise() || PickSignExercise() => selected != null,
    final MatchPairsExercise e => match.matched.length == e.words.length,
    CameraExercise() => false,
  };

  LessonPlayerState copyWith({
    List<Exercise>? exercises,
    int? index,
    int? hearts,
    int? mistakes,
    int? Function()? selected,
    LessonPhase? phase,
    FeedbackResult? Function()? feedback,
    MatchProgress? match,
    int? letterIndex,
    CameraOutcome? Function()? cameraOutcome,
    bool? cameraSkipped,
  }) => LessonPlayerState(
    exercises: exercises ?? this.exercises,
    index: index ?? this.index,
    hearts: hearts ?? this.hearts,
    mistakes: mistakes ?? this.mistakes,
    selected: selected == null ? this.selected : selected(),
    phase: phase ?? this.phase,
    feedback: feedback == null ? this.feedback : feedback(),
    match: match ?? this.match,
    letterIndex: letterIndex ?? this.letterIndex,
    cameraOutcome: cameraOutcome == null ? this.cameraOutcome : cameraOutcome(),
    cameraSkipped: cameraSkipped ?? this.cameraSkipped,
  );
}
