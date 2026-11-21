import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);
    testWidgets(
      'uppercase caption over a hairline surface card (${mode.name})',
      (tester) async {
        await pumpThemed(
          tester,
          SizedBox(
            width: 364,
            child: SettingsGroup(
              title: 'Learning',
              tiles: [
                SettingsTile(
                  icon: IsharaIcons.target,
                  label: 'Daily goal',
                  onTap: () {},
                ),
              ],
            ),
          ),
          mode: mode,
        );
        expect(textColor(tester, 'LEARNING'), c.textSecondary);
        final card = tester.widget<Material>(
          find
              .descendant(
                of: find.byType(SettingsGroup),
                matching: find.byType(Material),
              )
              .first,
        );
        expect(card.color, c.bgSurface);
        final shape = card.shape! as RoundedRectangleBorder;
        expect(shape.borderRadius, IsharaRadius.brLg);
        expect(shape.side.color, c.borderSubtle);
        expect(find.text('Daily goal'), findsOneWidget);
      },
    );
  }

  testWidgets('caption is announced as a header', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpThemed(tester, const SettingsGroup(title: 'Account', tiles: []));
    final data = tester.getSemantics(find.text('ACCOUNT')).getSemanticsData();
    expect(data.flagsCollection.isHeader, isTrue);
    handle.dispose();
  });
}
