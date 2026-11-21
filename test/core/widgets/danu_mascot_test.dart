import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';

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
}
