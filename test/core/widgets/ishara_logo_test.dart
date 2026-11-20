import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('mark: 48dp SVG labelled "Ishara" (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(tester, const IsharaLogo(), mode: mode);
      await tester.pumpAndSettle();
      final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svg.width, IsharaSizes.logoMark);
      expect(
        (svg.bytesLoader as SvgAssetLoader).assetName,
        IsharaLogo.markAsset,
      );
      expect(find.bySemanticsLabel('Ishara'), findsOneWidget);
      expect(tester.takeException(), isNull);
      handle.dispose();
    });

    testWidgets('lockup: 36dp mark + wordmark (${mode.name})', (tester) async {
      await pumpThemed(
        tester,
        const IsharaLogo(variant: IsharaLogoVariant.lockup),
        mode: mode,
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<SvgPicture>(find.byType(SvgPicture)).width,
        IsharaSizes.logoLockupMark,
      );
      expect(textColor(tester, 'ishara'), c.textPrimary);
      expect(
        renderedStyle(tester, find.text('ishara'))?.fontWeight,
        FontWeight.w800,
      );
    });
  }

  test('brand assets are bundled', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final asset in [
      IsharaLogo.markAsset,
      GoogleSignInButton.logoAsset,
      ...IsharaFilledIconKind.values.map((k) => k.asset),
    ]) {
      final data = await rootBundle.loadString(asset);
      expect(data, startsWith('<svg'), reason: asset);
    }
  });
}
