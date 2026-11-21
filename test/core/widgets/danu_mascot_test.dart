import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  test('pose artwork is transparent (no exported canvas background)', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final pose in DanuPose.values) {
      final svg = await rootBundle.loadString(pose.asset);
      expect(
        RegExp(r'<rect width="200" height="\d+" fill=').hasMatch(svg),
        isFalse,
        reason: pose.name,
      );
    }
  });

  test('all six pose SVGs are bundled', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final pose in DanuPose.values) {
      final svg = await rootBundle.loadString(pose.asset);
      expect(svg, startsWith('<svg'), reason: pose.name);
      expect(
        svg,
        isNot(contains('<filter')),
        reason: 'flutter_svg: ${pose.name}',
      );
    }
  });

  for (final mode in themeModes) {
    for (final pose in DanuPose.values) {
      testWidgets('${pose.name} (${mode.name})', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpThemed(tester, DanuMascot(pose: pose), mode: mode);
        await tester.pumpAndSettle();
        final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect((svg.bytesLoader as SvgAssetLoader).assetName, pose.asset);
        expect(
          tester.getSize(find.byType(DanuMascot)),
          const Size.square(IsharaSizes.mascot),
        );
        expect(
          find.bySemanticsLabel('Danu the Danphe, ${pose.description}'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        handle.dispose();
      });
    }
  }

  testWidgets('pose change cross-fades', (tester) async {
    await pumpThemed(tester, const DanuMascot());
    await pumpThemed(tester, const DanuMascot(pose: DanuPose.celebrate));
    await tester.pump(IsharaMotion.fast ~/ 2);
    expect(find.byType(SvgPicture), findsNWidgets(2));
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  Set<String> assetsShown(WidgetTester tester) => tester
      .widgetList<SvgPicture>(find.byType(SvgPicture))
      .map((p) => (p.bytesLoader as SvgAssetLoader).assetName)
      .toSet();

  testWidgets('animated wave draws the layered pose and keeps waving', (
    tester,
  ) async {
    await pumpThemed(
      tester,
      const DanuMascot(pose: DanuPose.wave, size: 130, animated: true),
    );
    expect(assetsShown(tester), DanuWaveLayers.all.toSet());

    double wingAngle() {
      final wing = find.ancestor(
        of: find.byWidgetPredicate(
          (w) =>
              w is SvgPicture &&
              (w.bytesLoader as SvgAssetLoader).assetName ==
                  DanuWaveLayers.wing,
        ),
        matching: find.byType(Transform),
      );
      return tester.widget<Transform>(wing.first).transform.storage[1];
    }

    final a = wingAngle();
    await tester.pump(DanuWaveMotion.period ~/ 4);
    final b = wingAngle();
    expect(a, isNot(closeTo(b, 1e-6)));
    expect(tester.takeException(), isNull);
    // Looping: unmount instead of settling.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('reduced motion shows the still wave artwork', (tester) async {
    await pumpThemed(
      tester,
      const DanuMascot(pose: DanuPose.wave, animated: true),
      disableAnimations: true,
    );
    expect(assetsShown(tester), {DanuPose.wave.asset});
  });

  testWidgets('animated has no effect on poses without layers', (tester) async {
    await pumpThemed(
      tester,
      const DanuMascot(pose: DanuPose.think, animated: true),
    );
    expect(assetsShown(tester), {DanuPose.think.asset});
  });

  test('wave layer assets are bundled', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final asset in DanuWaveLayers.all) {
      expect((await rootBundle.loadString(asset)).contains('<svg'), isTrue);
    }
  });
}
