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

  /// Daily goals the API accepts (`dailyGoalMinutes`, docs/api-contract.md),
  /// offered in onboarding (06) and Settings.
  static const List<int> dailyGoalMinutes = [5, 10, 15, 20];

  /// Roughly how long one lesson takes ("10 min a day · 2 lessons").
  static const int minutesPerLesson = 5;

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

  /// Setup check (09): a good distance puts the palm (wrist → middle MCP)
  /// at this fraction of the frame…
  static const double setupPalmMin = 0.12;

  /// …up to this; bigger means the hand is too close.
  static const double setupPalmMax = 0.35;

  /// Setup check (09): landmarks closer than this to an edge are cut off.
  static const double setupEdgeMargin = 0.02;
}
