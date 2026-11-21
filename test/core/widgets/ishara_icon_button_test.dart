import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);
    final expected = {
      IsharaIconButtonVariant.standard: (Colors.transparent, c.textPrimary),
      IsharaIconButtonVariant.tonal: (c.bgSurfaceMuted, c.textPrimary),
      IsharaIconButtonVariant.onCamera: (
        c.overlayScrim.withValues(alpha: IsharaSizes.cameraScrimOpacity),
        c.staticWhite,
      ),
    };

    for (final MapEntry(key: variant, value: (bg, fg)) in expected.entries) {
      testWidgets('${variant.name} (${mode.name})', (tester) async {
        var taps = 0;
        await pumpThemed(
          tester,
          IsharaIconButton(
            icon: IsharaIcons.arrowLeft,
            tooltip: 'Back',
            variant: variant,
            onPressed: () => taps++,
          ),
          mode: mode,
        );
        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(IconButton),
            matching: find.byType(Material),
          ),
        );
        expect(material.color, bg);
        final iconTheme = IconTheme.of(
          tester.element(find.byIcon(IsharaIcons.arrowLeft)),
        );
        expect(iconTheme.color, fg);
        expect(
          tester.getSize(find.byType(IconButton)),
          const Size.square(IsharaSizes.minTouch),
        );
        await tester.tap(find.byType(IsharaIconButton));
        await tester.pumpAndSettle();
        expect(taps, 1);
      });
    }

    testWidgets('tooltip is the accessible label (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(
        tester,
        IsharaIconButton(
          icon: IsharaIcons.close,
          tooltip: 'Close',
          onPressed: () {},
        ),
        mode: mode,
      );
      final data = tester
          .getSemantics(find.byType(IconButton))
          .getSemanticsData();
      expect(data.tooltip, 'Close');
      expect(data.flagsCollection.isButton, isTrue);
      handle.dispose();
    });

    testWidgets('disabled does nothing (${mode.name})', (tester) async {
      await pumpThemed(
        tester,
        const IsharaIconButton(
          icon: IsharaIcons.close,
          tooltip: 'Close',
          onPressed: null,
        ),
        mode: mode,
      );
      final iconTheme = IconTheme.of(
        tester.element(find.byIcon(IsharaIcons.close)),
      );
      expect(iconTheme.color, c.textTertiary);
    });
  }

  testWidgets('colour override (LessonProgressHeader close)', (tester) async {
    await pumpThemed(
      tester,
      IsharaIconButton(
        icon: IsharaIcons.close,
        tooltip: 'Close',
        color: IsharaColors.light.textSecondary,
        onPressed: () {},
      ),
    );
    expect(
      IconTheme.of(tester.element(find.byIcon(IsharaIcons.close))).color,
      IsharaColors.light.textSecondary,
    );
  });

  testWidgets('compact draws a 20dp icon in a 48dp target', (tester) async {
    await pumpThemed(
      tester,
      IsharaIconButton(
        icon: IsharaIcons.eye,
        tooltip: 'Show password',
        compact: true,
        onPressed: () {},
      ),
    );
    expect(
      tester.widget<IconButton>(find.byType(IconButton)).iconSize,
      IsharaSizes.iconMd,
    );
    expect(
      tester.getSize(find.byType(IconButton)),
      const Size.square(IsharaSizes.minTouch),
    );
  });
}
