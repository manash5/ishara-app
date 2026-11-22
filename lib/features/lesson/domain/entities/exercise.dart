/// Exercises of a lesson (lessons-gamification.md), as `GET /lessons/:id`
/// returns them. Owned by **lesson**. Pure Dart.
library;

/// One exercise of a lesson (lessons-gamification.md). The player shows one
/// at a time — exercises are states, not routes.
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
