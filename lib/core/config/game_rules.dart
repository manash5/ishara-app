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
}
