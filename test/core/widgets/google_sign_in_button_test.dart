import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('outlined surface, G logo, label, tap (${mode.name})', (
      tester,
    ) async {
      var taps = 0;
      await pumpThemed(
        tester,
        GoogleSignInButton(onPressed: () => taps++),
        mode: mode,
      );
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(textColor(tester, 'Continue with Google'), c.textPrimary);
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(OutlinedButton),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, c.bgSurface);
      expect(
        tester.getSize(find.byType(OutlinedButton)).height,
        IsharaSizes.controlHeight,
      );
      await tester.tap(find.byType(GoogleSignInButton));
      await tester.pumpAndSettle();
      expect(taps, 1);
    });

    testWidgets('disabled when onPressed is null (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const GoogleSignInButton(onPressed: null),
        mode: mode,
      );
      expect(textColor(tester, 'Continue with Google'), c.textTertiary);
      final handle = tester.ensureSemantics();
      expect(
        tester.getSemantics(find.text('Continue with Google')),
        matchesSemantics(
          label: 'Continue with Google',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
        ),
      );
      handle.dispose();
    });
  }
}
