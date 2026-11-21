import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  Widget feed(CameraFeed f) => SizedBox(width: 412, height: 560, child: f);

  HandLandmarkPainter painter(WidgetTester tester) =>
      tester
              .widget<CustomPaint>(
                find.descendant(
                  of: find.byType(HandLandmarkOverlay),
                  matching: find.byType(CustomPaint),
                ),
              )
              .painter!
          as HandLandmarkPainter;

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    for (final style in HandOverlayStyle.values) {
      testWidgets('placeholder + ${style.name} overlay (${mode.name})', (
        tester,
      ) async {
        await pumpThemed(tester, feed(CameraFeed(overlay: style)), mode: mode);
        expect(
          tester
              .widget<ColoredBox>(
                find
                    .descendant(
                      of: find.byType(CameraFeed),
                      matching: find.byType(ColoredBox),
                    )
                    .first,
              )
              .color,
          c.bgCamera,
        );
        expect(painter(tester).style, style);
        expect(
          painter(tester).highlighted,
          style == HandOverlayStyle.hint
              ? HandFinger.indexFinger.landmarks
              : isEmpty,
        );
      });
    }
  }

  testWidgets('live landmarks are drawn over the injected preview, mirrored', (
    tester,
  ) async {
    await pumpThemed(
      tester,
      feed(
        const CameraFeed(
          preview: ColoredBox(
            key: ValueKey('preview'),
            color: Colors.transparent,
          ),
          landmarks: HandLandmarkPainter.referencePose,
        ),
      ),
    );
    expect(find.byKey(const ValueKey('preview')), findsOneWidget);
    expect(painter(tester).mirror, isTrue);
    expect(painter(tester).landmarks, same(HandLandmarkPainter.referencePose));
  });

  testWidgets('no hand detected: preview only, no overlay', (tester) async {
    await pumpThemed(
      tester,
      feed(const CameraFeed(preview: SizedBox.expand())),
    );
    expect(find.byType(HandLandmarkOverlay), findsNothing);
  });

  testWidgets('exposes a single "Camera preview" image node', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpThemed(tester, feed(const CameraFeed()));
    expect(
      tester.getSemantics(find.byType(CameraFeed)),
      matchesSemantics(label: 'Camera preview', isImage: true),
    );
    handle.dispose();
  });
}
