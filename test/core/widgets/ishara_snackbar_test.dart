import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  const message = 'You’re offline. Progress will sync later.';

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('content uses inverse tokens and elevation/2 (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        IsharaSnackbar(
          message: message,
          icon: IsharaIcons.wifiOff,
          actionLabel: 'Retry',
          onAction: () {},
        ),
        mode: mode,
      );
      final box = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(IsharaSnackbar),
              matching: find.byType(Container),
            )
            .first,
      );
      final deco = box.decoration! as BoxDecoration;
      expect(deco.color, c.bgInverse);
      expect(deco.borderRadius, IsharaRadius.brLg);
      expect(deco.boxShadow, IsharaElevation.level2);
      expect(textColor(tester, message), c.textInverse);
      expect(textColor(tester, 'Retry'), c.textInverse);
      expect(
        tester.widget<Icon>(find.byIcon(IsharaIcons.wifiOff)).color,
        c.textInverse,
      );
    });

    testWidgets('show() displays it; action fires and hides (${mode.name})', (
      tester,
    ) async {
      var retries = 0;
      final handle = tester.ensureSemantics();
      await pumpThemed(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => IsharaSnackbar.show(
              context,
              message: message,
              actionLabel: 'Retry',
              onAction: () => retries++,
            ),
            child: const Text('trigger'),
          ),
        ),
        mode: mode,
      );
      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();
      expect(find.text(message), findsOneWidget);

      expect(find.bySemanticsLabel('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(retries, 1);
      expect(find.text(message), findsNothing);
      handle.dispose();
    });

    testWidgets('no action when showAction is off (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const IsharaSnackbar(message: message),
        mode: mode,
      );
      expect(find.byType(InkWell), findsNothing);
    });
  }
}
