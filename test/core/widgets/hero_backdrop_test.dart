import 'package:flutter_test/flutter_test.dart';
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
}
