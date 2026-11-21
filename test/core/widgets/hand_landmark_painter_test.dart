import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

/// Matches any [method] call whose paint (last Paint argument) satisfies [test].
PaintPattern _any(
  Symbol method,
  bool Function(Paint p, List<dynamic> args) test,
) => paints
  ..something(
    (m, args) => m == method && test(args.whereType<Paint>().last, args),
  );

void main() {
  Future<void> pumpOverlay(
    WidgetTester tester,
    HandLandmarkOverlay overlay,
    ThemeMode mode,
  ) => pumpThemed(
    tester,
    SizedBox(width: 200, height: 240, child: overlay),
    mode: mode,
  );

  Finder paintFinder() => find.descendant(
    of: find.byType(HandLandmarkOverlay),
    matching: find.byType(CustomPaint),
  );

  test('reference pose has 21 landmarks and 21 MediaPipe bones', () {
    expect(HandLandmarkPainter.referencePose, hasLength(21));
    expect(HandLandmarkPainter.connections, hasLength(21));
    for (final (a, b) in HandLandmarkPainter.connections) {
      expect(a, inInclusiveRange(0, 20));
      expect(b, inInclusiveRange(0, 20));
    }
    for (final p in HandLandmarkPainter.referencePose) {
      expect(p.dx, inInclusiveRange(0, 1));
      expect(p.dy, inInclusiveRange(0, 1));
    }
  });

  test('fingers map to MediaPipe landmark indices', () {
    expect(HandFinger.indexFinger.landmarks, {6, 7, 8});
    expect(HandFinger.pinky.landmarks, {18, 19, 20});
  });

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('live: lime bones, white joints, teal rings (${mode.name})', (
      tester,
    ) async {
      await pumpOverlay(tester, const HandLandmarkOverlay(), mode);
      expect(paintFinder(), paintsExactlyCountTimes(#drawLine, 21));
      expect(paintFinder(), paintsExactlyCountTimes(#drawCircle, 42));
      expect(
        paintFinder(),
        paints
          ..line(color: c.funLime, strokeWidth: 4)
          ..circle(color: c.staticWhite)
          ..circle(color: c.funTealHero, strokeWidth: 3),
      );
      expect(
        paintFinder(),
        isNot(
          _any(
            #drawLine,
            (p, _) => p.color.toARGB32() == c.dangerDefault.toARGB32(),
          ),
        ),
      );
    });

    testWidgets('hint: highlighted finger in danger (${mode.name})', (
      tester,
    ) async {
      await pumpOverlay(
        tester,
        HandLandmarkOverlay(
          style: HandOverlayStyle.hint,
          highlighted: HandFinger.indexFinger.landmarks,
        ),
        mode,
      );
      expect(
        paintFinder(),
        _any(
          #drawLine,
          (p, _) => p.color.toARGB32() == c.dangerDefault.toARGB32(),
        ),
      );
      expect(
        paintFinder(),
        _any(
          #drawCircle,
          (p, _) =>
              p.color.toARGB32() == c.dangerDefault.toARGB32() &&
              p.strokeWidth == 3,
        ),
      );
    });

    testWidgets('ghost: dotted white bones, no joints (${mode.name})', (
      tester,
    ) async {
      await pumpOverlay(
        tester,
        const HandLandmarkOverlay(style: HandOverlayStyle.ghost),
        mode,
      );
      expect(paintFinder(), paintsExactlyCountTimes(#drawCircle, 0));
      expect(
        paintFinder(),
        _any(
          #drawLine,
          (p, _) =>
              p.color.toARGB32() ==
              c.staticWhite.withValues(alpha: 0.6).toARGB32(),
        ),
      );
    });
  }

  testWidgets('mirror flips x; overlay is decorative', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpOverlay(
      tester,
      const HandLandmarkOverlay(mirror: true),
      ThemeMode.light,
    );
    final painter =
        tester.widget<CustomPaint>(paintFinder()).painter!
            as HandLandmarkPainter;
    expect(painter.mirror, isTrue);
    // Wrist (x = 0.5) stays centred; thumb tip (x ≈ 0.12) moves right.
    expect(
      paintFinder(),
      _any(#drawCircle, (_, a) => a[0] == const Offset(100, 225)),
    );
    expect(
      paintFinder(),
      _any(#drawCircle, (_, a) => a[0] == const Offset(200 - 24.5, 132.5)),
    );
    expect(
      tester.getSemantics(find.byType(HandLandmarkOverlay)).label,
      isEmpty,
    );
    handle.dispose();
  });
}
