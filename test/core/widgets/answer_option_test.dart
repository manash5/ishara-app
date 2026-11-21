import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  BoxDecoration boxOf(WidgetTester tester) =>
      tester
              .widget<AnimatedContainer>(
                find.byKey(const ValueKey('answer-option-box')),
              )
              .decoration!
          as BoxDecoration;

  for (final mode in themeModes) {
    final c = tokensFor(mode);
    final expected = {
      AnswerState.idle: (c.bgSurface, c.borderDefault, 1.5, c.textPrimary),
      AnswerState.selected: (
        c.funLavenderSubtle,
        c.funLavender,
        2.0,
        c.textPrimary,
      ),
      AnswerState.correct: (
        c.successSubtle,
        c.successDefault,
        2.0,
        c.successText,
      ),
      AnswerState.wrong: (c.dangerSubtle, c.dangerDefault, 2.0, c.dangerText),
    };

    for (final MapEntry(key: state, value: (fill, border, width, fg))
        in expected.entries) {
      testWidgets('${state.name} (${mode.name})', (tester) async {
        await pumpThemed(
          tester,
          AnswerOption(label: 'Option A', state: state, onTap: () {}),
          mode: mode,
        );
        await tester.pumpAndSettle();
        final d = boxOf(tester);
        expect(d.color, fill);
        expect((d.border! as Border).top.color, border);
        expect((d.border! as Border).top.width, width);
        expect(textColor(tester, 'Option A'), fg);
        switch (state) {
          case AnswerState.correct:
            expect(
              tester.widget<Icon>(find.byIcon(IsharaIcons.check)).color,
              c.successDefault,
            );
          case AnswerState.wrong:
            expect(
              tester.widget<Icon>(find.byIcon(IsharaIcons.close)).color,
              c.dangerDefault,
            );
          default:
            expect(find.byType(Icon), findsNothing);
        }
        expect(
          tester.getSize(find.byType(AnswerOption)).height,
          greaterThanOrEqualTo(IsharaSizes.answerOptionHeight),
        );
      });
    }
  }

  testWidgets('turning wrong shakes once', (tester) async {
    Widget option(AnswerState s) =>
        AnswerOption(label: 'Option A', state: s, onTap: () {});
    double dx() => tester
        .widget<Transform>(
          find
              .descendant(
                of: find.byType(Shake),
                matching: find.byType(Transform),
              )
              .first,
        )
        .transform
        .getTranslation()
        .x;
    await pumpThemed(tester, option(AnswerState.selected));
    await pumpThemed(tester, option(AnswerState.wrong));
    var moved = false;
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 25));
      moved |= dx() != 0;
    }
    expect(moved, isTrue);
    await tester.pumpAndSettle();
    expect(dx(), 0);
  });

  testWidgets('semantics: selectable, state spoken, tap', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpThemed(
      tester,
      AnswerOption(
        label: 'Option A',
        state: AnswerState.correct,
        onTap: () => taps++,
      ),
    );
    expect(
      tester.getSemantics(find.byType(AnswerOption)),
      matchesSemantics(
        label: 'Option A, correct',
        isButton: true,
        hasSelectedState: true,
        isInMutuallyExclusiveGroup: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    await tester.tap(find.byType(AnswerOption));
    await tester.pumpAndSettle();
    expect(taps, 1);
    handle.dispose();
  });
}
