import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);
    final expected = {
      MatchTileState.idle: (c.bgSurface, c.borderDefault, c.textPrimary),
      MatchTileState.selected: (
        c.funLavenderSubtle,
        c.funLavender,
        c.textPrimary,
      ),
      MatchTileState.matched: (
        c.successSubtle,
        c.successDefault,
        c.successText,
      ),
      MatchTileState.wrong: (c.dangerSubtle, c.dangerDefault, c.dangerText),
    };

    for (final MapEntry(key: state, value: (fill, border, fg))
        in expected.entries) {
      testWidgets('${state.name} (${mode.name})', (tester) async {
        await pumpThemed(
          tester,
          SizedBox(
            width: 172,
            child: MatchTile(label: 'Hello', state: state, onTap: () {}),
          ),
          mode: mode,
        );
        await tester.pumpAndSettle();
        final d =
            tester
                    .widget<AnimatedContainer>(
                      find.byKey(const ValueKey('match-tile-box')),
                    )
                    .decoration!
                as BoxDecoration;
        expect(d.color, fill);
        expect((d.border! as Border).top.color, border);
        expect(textColor(tester, 'Hello'), fg);
        expect(
          tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
          state == MatchTileState.matched ? IsharaSizes.matchedOpacity : 1,
        );
        expect(
          tester.getSize(find.byType(MatchTile)).height,
          greaterThanOrEqualTo(IsharaSizes.compactTileHeight),
        );
      });
    }
  }

  testWidgets('matched tiles are no longer tappable', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpThemed(
      tester,
      MatchTile(
        label: 'Hello',
        state: MatchTileState.matched,
        onTap: () => taps++,
      ),
    );
    await tester.tap(find.byType(MatchTile));
    await tester.pumpAndSettle();
    expect(taps, 0);
    expect(
      tester.getSemantics(find.byType(MatchTile)),
      matchesSemantics(
        label: 'Hello, matched',
        isButton: true,
        hasSelectedState: true,
        hasEnabledState: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('selectable tile taps', (tester) async {
    var taps = 0;
    await pumpThemed(tester, MatchTile(label: 'Hello', onTap: () => taps++));
    await tester.tap(find.byType(MatchTile));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });
}
