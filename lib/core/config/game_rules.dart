/// Game constants mirrored from the server (`ishara-systems/docs/game-rules.md`).
/// The server is authoritative; these only drive the UI.
abstract final class GameRules {
  /// Hearts a learner can hold; a wrong non-camera answer costs one.
  static const int maxHearts = 5;

  /// XP for finishing a lesson, plus a bonus for zero mistakes.
  static const int lessonXp = 10;
  static const int perfectBonus = 5;

  /// Hearts refill by one every this many hours.
  static const int heartRefillHours = 4;

  /// "Can't use camera now" keeps camera exercises off for this long.
  static const int cameraSkipMinutes = 15;

  // ---- Recognition (recognition.md) ----

  /// Fingerspelling: frames the classifier's majority vote looks at.
  static const int fingerspellWindowFrames = 10;

  /// Fingerspelling: the majority class needs at least this confidence…
  static const double fingerspellMinConfidence = 0.7;

  /// …held for this long before the letter is accepted.
  static const Duration fingerspellHold = Duration(milliseconds: 500);

  /// Greetings: hold the sign still this long to finish it ("Hold the sign
  /// for 1 second").
  static const Duration signHold = Duration(seconds: 1);

  /// Greetings: a recording never runs longer than this.
  static const Duration signMaxDuration = Duration(seconds: 4);
}
