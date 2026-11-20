import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_themed.dart';

void main() {
  double scaleOf(WidgetTester tester) =>
      tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;

  for (final mode in themeModes) {
    testWidgets('scales to 0.97 while pressed and fires onPressed '
        '(${mode.name})', (tester) async {
      var taps = 0;
      await pumpThemed(
        tester,
        PressableScale(
          onPressed: () => taps++,
          child: const SizedBox.square(dimension: 100),
        ),
        mode: mode,
      );
      expect(scaleOf(tester), 1);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(PressableScale)),
      );
      await tester.pump();
      expect(scaleOf(tester), IsharaMotion.pressScale);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(scaleOf(tester), 1);
      expect(taps, 1);
    });
  }

  testWidgets('disabled: no scale, no tap', (tester) async {
    var taps = 0;
    await pumpThemed(
      tester,
      PressableScale(
        enabled: false,
        onPressed: () => taps++,
        child: const SizedBox.square(dimension: 100),
      ),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(PressableScale)),
    );
    await tester.pump();
    expect(scaleOf(tester), 1);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(taps, 0);
  });

  testWidgets('reduced motion: no scale, tap still works', (tester) async {
    var taps = 0;
    await pumpThemed(
      tester,
      PressableScale(
        onPressed: () => taps++,
        child: const SizedBox.square(dimension: 100),
      ),
      disableAnimations: true,
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(PressableScale)),
    );
    await tester.pump();
    expect(scaleOf(tester), 1);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(taps, 1);
  });
}
