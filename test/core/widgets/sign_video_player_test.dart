import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('large: muted frame, xl radius, controls (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var replays = 0, slow = 0, mirror = 0;
      await pumpThemed(
        tester,
        SizedBox(
          width: 364,
          child: SignVideoPlayer(
            semanticLabel: 'Sign video',
            onReplay: () => replays++,
            onToggleSlowMotion: () => slow++,
            onToggleMirror: () => mirror++,
          ),
        ),
        mode: mode,
      );
      expect(
        tester.getSize(find.byType(SignVideoPlayer)),
        const Size(364, 272),
      );
      expect(
        tester
            .widget<ClipRRect>(
              find
                  .descendant(
                    of: find.byType(SignVideoPlayer),
                    matching: find.byType(ClipRRect),
                  )
                  .first,
            )
            .borderRadius,
        IsharaRadius.brXl,
      );
      expect(
        tester
            .widget<ColoredBox>(
              find
                  .descendant(
                    of: find.byType(SignVideoPlayer),
                    matching: find.byType(ColoredBox),
                  )
                  .first,
            )
            .color,
        c.bgSurfaceMuted,
      );
      expect(find.byType(HandLandmarkOverlay), findsOneWidget);
      expect(textColor(tester, '1×'), c.textPrimary);

      for (final label in ['Replay', 'Slow motion', 'Mirror video']) {
        final node = find.bySemanticsLabel(label);
        expect(node, findsOneWidget);
        expect(
          tester.getSize(node).height,
          greaterThanOrEqualTo(IsharaSizes.minTouch),
        );
        await tester.tap(node);
        await tester.pumpAndSettle();
      }
      expect((replays, slow, mirror), (1, 1, 1));
      expect(find.bySemanticsLabel('Sign video'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('slow-mo + mirrored states (${mode.name})', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(
        tester,
        SizedBox(
          width: 364,
          child: SignVideoPlayer(
            semanticLabel: 'Sign video',
            slowMotion: true,
            mirrored: true,
            video: const ColoredBox(
              key: ValueKey('video'),
              color: Colors.transparent,
            ),
            onToggleSlowMotion: () {},
            onToggleMirror: () {},
          ),
        ),
        mode: mode,
      );
      expect(textColor(tester, '0.5×'), c.accentText);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Normal speed')),
        matchesSemantics(
          label: 'Normal speed',
          isButton: true,
          hasToggledState: true,
          isToggled: true,
          hasTapAction: true,
        ),
      );
      final flip = tester.widget<Transform>(
        find
            .ancestor(
              of: find.byKey(const ValueKey('video')),
              matching: find.byType(Transform),
            )
            .first,
      );
      expect(flip.transform.entry(0, 0), -1);
      expect(find.byType(HandLandmarkOverlay), findsNothing);
      handle.dispose();
    });

    testWidgets('tile: lg radius, play badge, no controls (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const SizedBox(
          width: 170,
          child: SignVideoPlayer(
            semanticLabel: 'Option 1',
            size: SignVideoSize.tile,
          ),
        ),
        mode: mode,
      );
      expect(
        tester.getSize(find.byType(SignVideoPlayer)),
        const Size(170, 148),
      );
      final play = tester.widget<IsharaFilledIcon>(
        find.byType(IsharaFilledIcon),
      );
      expect(play.kind, IsharaFilledIconKind.play);
      expect(play.color, c.textPrimary);
      expect(find.byIcon(IsharaIcons.rotateCcw), findsNothing);
    });
  }
}
