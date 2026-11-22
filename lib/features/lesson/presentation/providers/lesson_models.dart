import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/widgets.dart';

/// One exercise of a lesson (lessons-gamification.md). The player shows one
/// at a time — exercises are states, not routes.
@immutable
sealed class Exercise {
  const Exercise({required this.signId});

  /// The sign this exercise teaches or tests.
  final String signId;

  /// Figma prompt eyebrow (label/small, upper-cased by the style).
  String get eyebrow;

  bool get isCamera => false;
}

/// Figma 18: watch a new sign, then continue.
final class WatchExercise extends Exercise {
  const WatchExercise({
    required super.signId,
    required this.title,
    required this.description,
    required this.tip,
  });

  final String title;

  /// Placeholder from Figma — unverified until checked against the NDFN NSL
  /// dictionary (CLAUDE.md content rule).
  final String description;
  final String tip;

  @override
  String get eyebrow => 'New sign';
}

/// Figma 19/20: video → meaning (pick one text answer).
final class RecogniseExercise extends Exercise {
  const RecogniseExercise({
    required super.signId,
    required this.options,
    required this.answerIndex,
  });

  final List<String> options;
  final int answerIndex;

  String get answer => options[answerIndex];

  @override
  String get eyebrow => 'Recognise';
}

/// Figma 21: meaning → video (pick one of four sign videos).
final class PickSignExercise extends Exercise {
  const PickSignExercise({
    required super.signId,
    required this.meaning,
    required this.answerIndex,
    this.optionCount = 4,
  });

  final String meaning;
  final int answerIndex;
  final int optionCount;

  @override
  String get eyebrow => 'Pick the sign';
}

/// Figma 22: tap a word, then its sign video.
final class MatchPairsExercise extends Exercise {
  const MatchPairsExercise({
    required super.signId,
    required this.words,
    required this.videoOrder,
  });

  /// Left column, top to bottom.
  final List<String> words;

  /// Right column: `videoOrder[row]` is the index into [words] whose sign
  /// that video shows.
  final List<int> videoOrder;

  @override
  String get eyebrow => 'Match the pairs';
}

/// Camera exercises (23–25). "Can't use the camera now" swaps each for
/// [fallback], a recognise exercise on the same sign.
sealed class CameraExercise extends Exercise {
  const CameraExercise({required super.signId, required this.fallback});

  final RecogniseExercise fallback;

  @override
  bool get isCamera => true;
}

/// Figma 23/24: sign a greeting into the camera (DTW, practice feedback).
final class SignItExercise extends CameraExercise {
  const SignItExercise({
    required super.signId,
    required super.fallback,
    required this.title,
    required this.almostChip,
    required this.almostHint,
  });

  final String title;

  /// Figma 24 chip naming the finger to fix (e.g. "Index finger").
  final String almostChip;

  /// Figma 24 hint — placeholder, unverified (CLAUDE.md content rule).
  final String almostHint;

  @override
  String get eyebrow => 'Sign it';
}

/// Figma 25: fingerspell a word letter by letter (classifier).
final class FingerspellExercise extends CameraExercise {
  const FingerspellExercise({
    required super.signId,
    required super.fallback,
    required this.letters,
    required this.meaning,
  });

  final List<String> letters;
  final String meaning;

  String get word => letters.join();

  @override
  String get eyebrow => 'Fingerspell';
}

/// A lesson as the player receives it.
@immutable
class Lesson {
  const Lesson({required this.id, required this.exercises});

  final String id;
  final List<Exercise> exercises;
}

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
