import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  Color? fillOf(WidgetTester tester) =>
      ((tester
                  .widget<Container>(
                    find
                        .descendant(
                          of: find.byType(LeaderboardTile),
                          matching: find.byType(Container),
                        )
                        .first,
                  )
                  .decoration)!
              as BoxDecoration)
          .color;

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('variant default (${mode.name})', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(
        tester,
        const LeaderboardTile(rank: 4, name: 'Sujata R.', xp: 420),
        mode: mode,
      );
      expect(fillOf(tester), isNull);
      expect(textColor(tester, '4'), c.textSecondary);
      expect(textColor(tester, 'Sujata R.'), c.textPrimary);
      expect(textColor(tester, '420'), c.textPrimary);
      expect(
        tester.widget<IsharaFilledIcon>(find.byType(IsharaFilledIcon)).color,
        c.accentDefault,
      );
      expect(
        find.bySemanticsLabel('Rank 4, Sujata R., 420 XP'),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('variant me (${mode.name})', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(
        tester,
        const LeaderboardTile(rank: 2, name: 'Manash L.', xp: 980, isMe: true),
        mode: mode,
      );
      expect(fillOf(tester), c.accentSubtle);
      expect(textColor(tester, '2'), c.accentText);
      expect(textColor(tester, 'Manash L.'), c.accentText);
      expect(textColor(tester, '980'), c.accentText);
      expect(
        find.bySemanticsLabel('Rank 2, you, Manash L., 980 XP'),
        findsOneWidget,
      );
      handle.dispose();
    });
  }

  testWidgets('avatarName drives the initials (You shows ML)', (tester) async {
    await pumpThemed(
      tester,
      const LeaderboardTile(
        rank: 4,
        name: 'You',
        xp: 480,
        isMe: true,
        avatarName: 'Manash Lamichhane',
      ),
    );
    expect(find.text('You'), findsOneWidget);
    expect(find.text('ML'), findsOneWidget);
  });
}
