import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  /// (face, lip) of the node's lip surface.
  (Color?, Color?) lipColors(WidgetTester tester) {
    final boxes = tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.byKey(const ValueKey('path-node-surface')),
            matching: find.byType(DecoratedBox),
          ),
        )
        .map((b) => (b.decoration as ShapeDecoration).color)
        .toList();
    return (boxes[1], boxes[0]);
  }

  for (final mode in themeModes) {
    final c = tokensFor(mode);
    final expected = {
      PathNodeState.completed: (c.funGold, c.funGoldLip, IsharaIcons.check),
      PathNodeState.locked: (c.borderDefault, c.borderStrong, IsharaIcons.lock),
      PathNodeState.review: (
        c.funLavender,
        c.funLavenderLip,
        IsharaIcons.rotateCcw,
      ),
      PathNodeState.checkpoint: (
        c.borderDefault,
        c.borderStrong,
        IsharaIcons.trophy,
      ),
    };

    for (final MapEntry(key: state, value: (face, lip, icon))
        in expected.entries) {
      testWidgets('${state.name}: face/lip tokens + icon (${mode.name})', (
        tester,
      ) async {
        await pumpThemed(
          tester,
          PathNode(state: state, label: 'Lesson 1', onTap: () {}),
          mode: mode,
        );
        expect(lipColors(tester), (face, lip));
        expect(find.byIcon(icon), findsOneWidget);
        expect(
          tester.getSize(find.byKey(const ValueKey('path-node-surface'))),
          const Size.square(IsharaSizes.pathNode),
        );
      });
    }

    testWidgets('current: accent node, lime halo, star (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        PathNode(state: PathNodeState.current, label: 'Lesson 2', onTap: () {}),
        mode: mode,
      );
      expect(lipColors(tester), (c.accentDefault, c.accentLip));
      final halo =
          tester
                  .widget<DecoratedBox>(
                    find.byKey(const ValueKey('path-node-halo')),
                  )
                  .decoration
              as BoxDecoration;
      expect((halo.border! as Border).top.color, c.funLime);
      expect(
        (halo.border! as Border).top.width,
        IsharaSizes.pathNodeHaloStroke,
      );
      expect(
        tester.widget<IsharaFilledIcon>(find.byType(IsharaFilledIcon)).kind,
        IsharaFilledIconKind.star,
      );
    });

    testWidgets('chest: SVG artwork (${mode.name})', (tester) async {
      await pumpThemed(
        tester,
        PathNode(state: PathNodeState.chest, label: 'Unit 1', onTap: () {}),
        mode: mode,
      );
      expect(find.byType(SvgPicture), findsOneWidget);
    });
  }

  testWidgets('press drops the face into the 6dp lip, tap fires', (
    tester,
  ) async {
    var taps = 0;
    await pumpThemed(
      tester,
      PathNode(
        state: PathNodeState.completed,
        label: 'Lesson 1',
        onTap: () => taps++,
      ),
    );
    EdgeInsetsGeometry padding() =>
        tester.widget<AnimatedPadding>(find.byType(AnimatedPadding)).padding;
    expect(padding(), const EdgeInsets.only(bottom: IsharaSizes.lipNode));
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(PathNode)),
    );
    await tester.pump();
    expect(padding(), const EdgeInsets.only(top: IsharaSizes.lipNode));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('current pulses; reduced motion stops the pulse', (tester) async {
    await pumpThemed(
      tester,
      PathNode(state: PathNodeState.current, label: 'Lesson 2', onTap: () {}),
    );
    double scale() => tester
        .widget<ScaleTransition>(
          find.descendant(
            of: find.byType(PathNode),
            matching: find.byType(ScaleTransition),
          ),
        )
        .scale
        .value;
    await tester.pump(IsharaMotion.pulsePeriod ~/ 2);
    expect(scale(), greaterThan(1));

    await pumpThemed(
      tester,
      PathNode(state: PathNodeState.current, label: 'Lesson 2', onTap: () {}),
      disableAnimations: true,
    );
    await tester.pump();
    expect(scale(), 1);
    // Nothing keeps animating, so the test can settle.
    await tester.pumpAndSettle();
  });

  testWidgets('semantics: label + state, button with tap', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpThemed(
      tester,
      PathNode(state: PathNodeState.locked, label: 'Lesson 5', onTap: () {}),
    );
    expect(
      tester.getSemantics(find.byType(PathNode)),
      matchesSemantics(
        label: 'Lesson 5, locked',
        isButton: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });
}
