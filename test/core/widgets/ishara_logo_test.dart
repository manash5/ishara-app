import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

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

  for (final mode in themeModes) {
    final c = tokensFor(mode);
    testWidgets('lockup scales and goes white on the hero (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const IsharaLogo(
          variant: IsharaLogoVariant.lockup,
          scale: 1.6,
          onHero: true,
        ),
        mode: mode,
      );
      expect(textColor(tester, 'ishara'), c.staticWhite);
      expect(
        renderedStyle(tester, find.text('ishara'))?.fontSize,
        closeTo(26 * 1.6, 0.01),
      );
    });
  }

  testWidgets('intro assembles the mark from its layers, then the wordmark', (
    tester,
  ) async {
    final controller = AnimationController(
      vsync: const TestVSync(),
      duration: IsharaMotion.celebrate,
    );
    addTearDown(controller.dispose);
    await pumpThemed(
      tester,
      IsharaLogo(variant: IsharaLogoVariant.lockup, intro: controller),
    );
    final assets = tester
        .widgetList<SvgPicture>(find.byType(SvgPicture))
        .map((p) => (p.bytesLoader as SvgAssetLoader).assetName)
        .toSet();
    expect(assets, {
      IsharaLogo.tileAsset,
      IsharaLogo.bodyAsset,
      IsharaLogo.headAsset,
      IsharaLogo.crestAsset,
    });

    double wordmarkOpacity() => tester
        .widget<Opacity>(
          find
              .ancestor(of: find.text('ishara'), matching: find.byType(Opacity))
              .first,
        )
        .opacity;
    expect(wordmarkOpacity(), 0);
    controller.value = 1;
    await tester.pump();
    expect(wordmarkOpacity(), 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('without intro it is the single static mark', (tester) async {
    await pumpThemed(tester, const IsharaLogo());
    final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(
      (picture.bytesLoader as SvgAssetLoader).assetName,
      IsharaLogo.markAsset,
    );
  });
}
