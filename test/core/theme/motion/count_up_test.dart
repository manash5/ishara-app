import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_themed.dart';

void main() {
  Widget counter() =>
      CountUp(value: 15, builder: (_, v) => Text('+$v', key: const Key('n')));

  String shown(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(const Key('n'))).data!;

  for (final mode in themeModes) {
    testWidgets('counts up to the value in celebrate (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(tester, counter(), mode: mode);
      expect(shown(tester), '+0');
      await tester.pump(IsharaMotion.celebrate ~/ 2);
      final mid = int.parse(shown(tester).substring(1));
      expect(mid, inExclusiveRange(0, 15));
      await tester.pump(IsharaMotion.celebrate);
      expect(shown(tester), '+15');
    });
  }

  testWidgets('reduced motion shows the final value at once', (tester) async {
    await pumpThemed(tester, counter(), disableAnimations: true);
    expect(shown(tester), '+15');
  });
}
