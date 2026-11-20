import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('trailing chevron: icon box tokens + tap (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      await pumpThemed(
        tester,
        SettingsTile(
          icon: IsharaIcons.bell,
          label: 'Notifications',
          onTap: () => taps++,
        ),
        mode: mode,
      );
      final box = tester.widget<Container>(
        find
            .ancestor(
              of: find.byIcon(IsharaIcons.bell),
              matching: find.byType(Container),
            )
            .first,
      );
      final deco = box.decoration! as BoxDecoration;
      expect(deco.color, c.funLavenderSubtle);
      expect(deco.borderRadius, IsharaRadius.brSm);
      expect(
        tester.widget<Icon>(find.byIcon(IsharaIcons.bell)).color,
        c.textPrimary,
      );
      expect(textColor(tester, 'Notifications'), c.textPrimary);
      expect(find.byIcon(IsharaIcons.chevronRight), findsOneWidget);
      expect(
        tester.getSize(find.byType(SettingsTile)).height,
        greaterThanOrEqualTo(IsharaSizes.settingsTileHeight),
      );
      expect(
        tester.getSemantics(find.byType(SettingsTile)),
        matchesSemantics(
          label: 'Notifications',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.tap(find.byType(SettingsTile));
      expect(taps, 1);
      handle.dispose();
    });

    testWidgets('trailing toggle: whole row toggles (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var on = true;
      await pumpThemed(
        tester,
        StatefulBuilder(
          builder: (context, setState) => SettingsTile(
            icon: IsharaIcons.bell,
            label: 'Daily reminder',
            trailing: SettingsTrailing.toggle,
            switchValue: on,
            onSwitchChanged: (v) => setState(() => on = v),
          ),
        ),
        mode: mode,
      );
      expect(find.byType(IsharaSwitch), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(SettingsTile)),
        matchesSemantics(
          label: 'Daily reminder',
          hasToggledState: true,
          isToggled: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.tap(find.text('Daily reminder'));
      await tester.pumpAndSettle();
      expect(on, isFalse);
      handle.dispose();
    });

    testWidgets('trailing value shows value + chevron (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(
        tester,
        SettingsTile(
          icon: IsharaIcons.bell,
          label: 'Reminder time',
          trailing: SettingsTrailing.value,
          value: '7:00 PM',
          onTap: () {},
        ),
        mode: mode,
      );
      expect(textColor(tester, '7:00 PM'), c.textSecondary);
      expect(find.byIcon(IsharaIcons.chevronRight), findsOneWidget);
      expect(find.bySemanticsLabel('Reminder time, 7:00 PM'), findsOneWidget);
      handle.dispose();
    });
  }
}
