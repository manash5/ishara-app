import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../ishara_motion.dart';

/// Answer feedback that pairs visuals with haptics — never sound (Deaf-first).
abstract final class IsharaFeedback {
  /// Correct answer: light haptic. Pair with the success colour.
  static Future<void> correct() => HapticFeedback.lightImpact();

  /// Wrong answer / streak moment: medium haptic. Pair with [Shake].
  static Future<void> wrong() => HapticFeedback.mediumImpact();

  /// Streak extended (27): medium haptic, paired with the flame and count-up.
  static Future<void> streak() => HapticFeedback.mediumImpact();

  /// `FeedbackSheet` slides up in `standard`/`enter` and leaves at ~75% with
  /// `exit`. Pass to `showModalBottomSheet(sheetAnimationStyle: …)`.
  static final AnimationStyle sheetAnimationStyle = AnimationStyle(
    duration: IsharaMotion.standard,
    curve: IsharaMotion.enter,
    reverseDuration: IsharaMotion.exitDuration(IsharaMotion.standard),
    reverseCurve: IsharaMotion.exit,
  );
}
