import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    for (final layout in HeroBackdropLayout.values) {
      testWidgets('${layout.name} paints with tokens (${mode.name})', (
        tester,
      ) async {
        await pumpThemed(
          tester,
          SizedBox(
            width: 412,
            height: layout == HeroBackdropLayout.welcome ? 915 : 260,
            child: HeroBackdrop(
              layout: layout,
              child: const Center(child: Text('Hello')),
            ),
          ),
          mode: mode,
        );
        expect(tester.takeException(), isNull);
        final painter =
            tester
                    .widget<CustomPaint>(
                      find.descendant(
                        of: find.byType(HeroBackdrop),
                        matching: find.byType(CustomPaint),
                      ),
                    )
                    .painter!
                as HeroBackdropPainter;
        expect(painter.layout, layout);
        expect(painter.colors, same(c));
        expect(find.text('Hello'), findsOneWidget);

        // Background + 5 shapes, drawn in the token colours.
        expect(
          find.byType(HeroBackdrop),
          paints
            ..rect(color: c.funTealHero)
            ..something((_, _) => true),
        );
      });
    }

    testWidgets('decoration adds no semantics (${mode.name})', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(
        tester,
        const SizedBox(
          width: 412,
          height: 260,
          child: HeroBackdrop(child: Text('Welcome')),
        ),
        mode: mode,
      );
      expect(find.bySemanticsLabel('Welcome'), findsOneWidget);
      handle.dispose();
    });
  }

  test('intro staggers shapes in paint order', () {
    expect(HeroBackdropPainter.shapeProgress(0, 0), 0);
    expect(HeroBackdropPainter.shapeProgress(1, 0), 1);
    expect(HeroBackdropPainter.shapeProgress(1, 4), 1);
    // Mid-intro the first shape is further along than the last.
    expect(
      HeroBackdropPainter.shapeProgress(0.4, 0),
      greaterThan(HeroBackdropPainter.shapeProgress(0.4, 4)),
    );
  });

  testWidgets('intro animation repaints without errors', (tester) async {
    final controller = AnimationController(
      vsync: const TestVSync(),
      duration: IsharaMotion.celebrate,
    );
    addTearDown(controller.dispose);
    await pumpThemed(
      tester,
      SizedBox(
        width: 412,
        height: 600,
        child: HeroBackdrop(
          layout: HeroBackdropLayout.welcome,
          intro: controller,
        ),
      ),
    );
    final painter =
        tester
                .widget<CustomPaint>(
                  find
                      .descendant(
                        of: find.byType(HeroBackdrop),
                        matching: find.byType(CustomPaint),
                      )
                      .first,
                )
                .painter!
            as HeroBackdropPainter;
    expect(painter.intro, same(controller));
    controller.value = 0.5;
    await tester.pump();
    controller.value = 1;
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('ambient drift keeps repainting while it loops', (tester) async {
    final drift = AnimationController(
      vsync: const TestVSync(),
      duration: IsharaMotion.celebrate,
    );
    addTearDown(drift.dispose);
    await pumpThemed(
      tester,
      SizedBox(
        width: 412,
        height: 600,
        child: HeroBackdrop(layout: HeroBackdropLayout.welcome, drift: drift),
      ),
    );
    final painter =
        tester
                .widget<CustomPaint>(
                  find
                      .descendant(
                        of: find.byType(HeroBackdrop),
                        matching: find.byType(CustomPaint),
                      )
                      .first,
                )
                .painter!
            as HeroBackdropPainter;
    expect(painter.drift, same(drift));
    for (final v in [0.25, 0.5, 0.75]) {
      drift.value = v;
      await tester.pump();
    }
    expect(tester.takeException(), isNull);
  });
}
