import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  final buttonFinder = find.byWidgetPredicate((w) => w is ButtonStyleButton);

  Color? bgOf(WidgetTester tester) => tester
      .widget<Material>(
        find.descendant(of: buttonFinder, matching: find.byType(Material)),
      )
      .color;

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    group('IsharaButton (${mode.name})', () {
      final cases = {
        (IsharaButtonVariant.filled, true): (c.accentDefault, c.textOnAccent),
        (IsharaButtonVariant.filled, false): (c.bgSurfaceMuted, c.textTertiary),
        (IsharaButtonVariant.outlined, true): (c.bgSurface, c.textPrimary),
        (IsharaButtonVariant.outlined, false): (c.bgSurface, c.textTertiary),
        (IsharaButtonVariant.text, true): (Colors.transparent, c.accentText),
        (IsharaButtonVariant.text, false): (Colors.transparent, c.textTertiary),
      };

      for (final MapEntry(key: (variant, enabled), value: (bg, fg))
          in cases.entries) {
        testWidgets(
          '${variant.name} ${enabled ? 'enabled' : 'disabled'} uses tokens',
          (tester) async {
            var taps = 0;
            await pumpThemed(
              tester,
              IsharaButton(
                label: 'Continue',
                variant: variant,
                onPressed: enabled ? () => taps++ : null,
              ),
              mode: mode,
            );
            expect(bgOf(tester), bg);
            expect(textColor(tester, 'Continue'), fg);
            expect(
              tester.getSize(buttonFinder).height,
              IsharaSizes.controlHeight,
            );

            await tester.tap(find.byType(IsharaButton));
            await tester.pumpAndSettle();
            expect(taps, enabled ? 1 : 0);
          },
        );
      }

      testWidgets('outlined has a 1.5px border/default side', (tester) async {
        await pumpThemed(
          tester,
          IsharaButton(
            label: 'Skip',
            variant: IsharaButtonVariant.outlined,
            onPressed: () {},
          ),
          mode: mode,
        );
        final shape =
            tester
                    .widget<Material>(
                      find.descendant(
                        of: buttonFinder,
                        matching: find.byType(Material),
                      ),
                    )
                    .shape!
                as OutlinedBorder;
        expect(shape.side.color, c.borderDefault);
        expect(shape.side.width, IsharaSizes.outline);
      });

      testWidgets('optional icon renders at 20dp', (tester) async {
        await pumpThemed(
          tester,
          IsharaButton(
            label: 'Practice',
            icon: IsharaIcons.camera,
            onPressed: () {},
          ),
          mode: mode,
        );
        expect(
          tester.getSize(find.byIcon(IsharaIcons.camera)).width,
          IsharaSizes.iconMd,
        );
      });

      testWidgets('semantics: enabled button with label', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpThemed(
          tester,
          IsharaButton(label: 'Continue', onPressed: () {}),
          mode: mode,
        );
        expect(
          tester.getSemantics(find.text('Continue')),
          matchesSemantics(
            label: 'Continue',
            isButton: true,
            isEnabled: true,
            hasEnabledState: true,
            isFocusable: true,
            hasTapAction: true,
            hasFocusAction: true,
          ),
        );
        handle.dispose();
      });
    });
  }

  for (final mode in themeModes) {
    final c = tokensFor(mode);
    for (final (tone, fill) in [
      (IsharaButtonTone.success, c.successDefault),
      (IsharaButtonTone.danger, c.dangerDefault),
    ]) {
      testWidgets('tone ${tone.name} fills the button (${mode.name})', (
        tester,
      ) async {
        await pumpThemed(
          tester,
          IsharaButton(label: 'Continue', tone: tone, onPressed: () {}),
          mode: mode,
        );
        expect(bgOf(tester), fill);
        await pumpThemed(
          tester,
          IsharaButton(label: 'Continue', tone: tone, onPressed: null),
          mode: mode,
        );
        expect(bgOf(tester), c.bgSurfaceMuted);
      });
    }
  }
}
