import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_themed.dart';

void main() {
  Finder painter() => find.descendant(
    of: find.byType(ConfettiBurst),
    matching: find.byType(CustomPaint),
  );

  Widget burst() =>
      const SizedBox(width: 300, height: 600, child: ConfettiBurst());

  test('the burst is within the motion spec (≤ 1.5 s)', () {
    expect(
      IsharaMotion.confetti,
      lessThanOrEqualTo(const Duration(milliseconds: 1500)),
    );
  });

  for (final mode in themeModes) {
    testWidgets('plays once, then paints nothing (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(tester, burst(), mode: mode);
      expect(painter(), findsOneWidget);
      await tester.pump(IsharaMotion.confetti ~/ 2);
      expect(painter(), findsOneWidget);
      await tester.pump(IsharaMotion.confetti);
      expect(painter(), findsNothing);
      // Never blocks input.
      expect(
        find.descendant(
          of: find.byType(ConfettiBurst),
          matching: find.byType(IgnorePointer),
        ),
        findsOneWidget,
      );
    });
  }

  testWidgets('reduced motion: no confetti at all', (tester) async {
    await pumpThemed(tester, burst(), disableAnimations: true);
    expect(painter(), findsNothing);
    expect(tester.hasRunningAnimations, isFalse);
  });
}
