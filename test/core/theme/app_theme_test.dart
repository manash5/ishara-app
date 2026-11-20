import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final isDark = mode == ThemeMode.dark;
    final tokens = isDark ? IsharaColors.dark : IsharaColors.light;

    testWidgets('${mode.name} theme builds and resolves tokens', (
      tester,
    ) async {
      late BuildContext ctx;
      await pumpThemed(
        tester,
        Builder(
          builder: (context) {
            ctx = context;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(onPressed: () {}, child: const Text('Continue')),
                OutlinedButton(onPressed: () {}, child: const Text('Skip')),
                const TextField(),
                const Card(child: Text('Card')),
              ],
            );
          },
        ),
        mode: mode,
      );

      expect(tester.takeException(), isNull);
      final theme = Theme.of(ctx);
      expect(theme.brightness, isDark ? Brightness.dark : Brightness.light);
      expect(ctx.colors, same(tokens));
      expect(ctx.textStyles, same(IsharaTextStyles.standard));

      final scheme = theme.colorScheme;
      expect(scheme.primary, tokens.accentDefault);
      expect(scheme.onPrimary, tokens.textOnAccent);
      expect(scheme.surface, tokens.bgSurface);
      expect(scheme.onSurface, tokens.textPrimary);
      expect(scheme.error, tokens.dangerDefault);
      expect(scheme.outline, tokens.borderDefault);
      expect(theme.scaffoldBackgroundColor, tokens.bgCanvas);

      expect(theme.textTheme.bodyLarge!.fontFamily, IsharaFonts.sans);
      expect(theme.textTheme.bodyLarge!.color, tokens.textPrimary);
    });
  }

  test('primary is teal in Light and lime in Dark', () {
    expect(AppTheme.light.colorScheme.primary, const Color(0xFF1F4D52));
    expect(AppTheme.dark.colorScheme.primary, const Color(0xFFC6F04D));
    expect(
      AppTheme.dark.colorScheme.onPrimary,
      const Color(0xFF163A3E),
      reason: 'dark-teal text on lime',
    );
  });

  test('buttons use radius lg and label/large', () {
    final style = AppTheme.light.filledButtonTheme.style!;
    expect(
      style.shape!.resolve({}),
      const RoundedRectangleBorder(borderRadius: IsharaRadius.brLg),
    );
    expect(
      style.textStyle!.resolve({})!.fontSize,
      IsharaTextStyles.standard.labelLarge.fontSize,
    );
  });
}
