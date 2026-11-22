import 'package:material_ui/material_ui.dart';

/// Motion tokens — spec lives in `.claude/rules/motion.md` (Figma has none).
///
/// Calm and quick everywhere; playful only on the Learn roadmap and lesson
/// results. Never hard-code `Duration(...)` or `Curves.*` in widgets.
abstract final class IsharaMotion {
  // Durations.
  /// 100 ms — press feedback, colour/opacity changes.
  static const Duration instant = Durations.short2;

  /// 200 ms — selection, toggles, chips, small fades.
  static const Duration fast = Durations.short4;

  /// 300 ms — sheets, cards expanding, list item changes.
  static const Duration standard = Durations.medium2;

  /// 400 ms — route transitions.
  static const Duration page = Durations.medium4;

  /// 500 ms — XP count-up, streak flame, completion.
  static const Duration celebrate = Durations.long2;

  // Curves.
  /// Things appearing.
  static const Curve enter = Easing.emphasizedDecelerate;

  /// Things leaving — pair with [exitDuration].
  static const Curve exit = Easing.emphasizedAccelerate;

  /// Things moving or resizing on screen.
  static const Curve move = Easing.standard;

  /// Roadmap and lesson results only.
  static const Curve playful = Curves.easeOutBack;

  // Pattern constants.
  /// Buttons and tappable cards scale to this while pressed.
  static const double pressScale = 0.97;

  /// Wrong-answer shake: peak horizontal offset in logical px.
  static const double shakeOffset = 8;

  /// Wrong-answer shake: total duration.
  static const Duration shakeDuration = standard;

  /// List first-load: per-item stagger, max staggered items and rise.
  static const Duration listStagger = Duration(milliseconds: 30);
  static const int listStaggerMax = 8;
  static const double listRise = 8;

  /// Current PathNode pulse.
  static const double pulseScale = 1.06;
  static const Duration pulsePeriod = Duration(milliseconds: 1200);

  /// Lesson complete / Streak confetti: one short burst (motion.md ≤ 1.5 s).
  static const Duration confetti = Duration(milliseconds: 1200);

  /// Exit runs at ~75% of the matching enter duration.
  static Duration exitDuration(Duration enterDuration) => enterDuration * 0.75;

  /// Whether the user asked the platform to reduce motion.
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// [d], or [Duration.zero] when motion is reduced.
  static Duration duration(BuildContext context, Duration d) =>
      reduced(context) ? Duration.zero : d;
}
