import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);
    final expected = {
      AnswerState.idle: (c.bgSurface, c.borderDefault),
      AnswerState.selected: (c.funLavenderSubtle, c.funLavender),
      AnswerState.correct: (c.successSubtle, c.successDefault),
      AnswerState.wrong: (c.dangerSubtle, c.dangerDefault),
    };

    for (final MapEntry(key: state, value: (fill, border))
        in expected.entries) {
      testWidgets('${state.name} (${mode.name})', (tester) async {
        await pumpThemed(
          tester,
          SizedBox(
            width: 182,
            child: VideoOption(
              semanticLabel: 'Option 1',
              state: state,
              onTap: () {},
            ),
          ),
          mode: mode,
        );
        await tester.pumpAndSettle();
        final box = tester.widget<AnimatedContainer>(
          find.byKey(const ValueKey('video-option-box')),
        );
        final d = box.decoration! as BoxDecoration;
        expect(d.color, fill);
        expect((d.border! as Border).top.color, border);
        expect(
          box.padding,
          const EdgeInsets.all(IsharaSizes.videoOptionPadding),
        );
        final player = tester.widget<SignVideoPlayer>(
          find.byType(SignVideoPlayer),
        );
        expect(player.size, SignVideoSize.tile);
        expect(player.borderRadius, IsharaRadius.brMd);
      });
    }
  }

  testWidgets('semantics + tap', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpThemed(
      tester,
      SizedBox(
        width: 182,
        child: VideoOption(
          semanticLabel: 'Option 2',
          state: AnswerState.selected,
          onTap: () => taps++,
        ),
      ),
    );
    expect(
      tester.getSemantics(find.byType(VideoOption)),
      matchesSemantics(
        label: 'Option 2',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        isInMutuallyExclusiveGroup: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    await tester.tap(find.byType(VideoOption));
    await tester.pumpAndSettle();
    expect(taps, 1);
    handle.dispose();
  });
}
