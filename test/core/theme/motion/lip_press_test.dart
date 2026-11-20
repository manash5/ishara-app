import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_themed.dart';

void main() {
  const faceKey = Key('face');

  double dyOf(WidgetTester tester) => tester
      .widget<Transform>(
        find.ancestor(
          of: find.byKey(faceKey),
          matching: find.byType(Transform),
        ),
      )
      .transform
      .getTranslation()
      .y;

  Widget lip({required bool pressed}) => LipPress(
    pressed: pressed,
    lipHeight: IsharaLip.pathNode,
    child: const SizedBox.square(key: faceKey, dimension: 50),
  );

  for (final mode in themeModes) {
    testWidgets('drops by the lip height when pressed (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(tester, lip(pressed: false), mode: mode);
      expect(dyOf(tester), 0);

      await pumpThemed(tester, lip(pressed: true), mode: mode);
      await tester.pumpAndSettle();
      expect(dyOf(tester), IsharaLip.pathNode);

      await pumpThemed(tester, lip(pressed: false), mode: mode);
      await tester.pumpAndSettle();
      expect(dyOf(tester), 0);
    });
  }

  testWidgets('reduced motion: change is instant', (tester) async {
    await pumpThemed(tester, lip(pressed: false), disableAnimations: true);
    await pumpThemed(tester, lip(pressed: true), disableAnimations: true);
    await tester.pump();
    expect(dyOf(tester), IsharaLip.pathNode);
  });
}
