import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  Finder blocks() => find.descendant(
    of: find.byType(ListSkeleton),
    matching: find.byType(Container),
  );

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('count blocks of itemHeight, gap apart, muted (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const SizedBox(
          width: 300,
          child: ListSkeleton(
            itemHeight: IsharaSizes.compactTileHeight,
            semanticLabel: 'Loading leaderboard',
            count: 3,
            gap: IsharaSpacing.s1,
          ),
        ),
        mode: mode,
      );
      expect(blocks(), findsNWidgets(3));
      final first = tester.getRect(blocks().at(0));
      final second = tester.getRect(blocks().at(1));
      expect(first.height, IsharaSizes.compactTileHeight);
      expect(second.top - first.bottom, IsharaSpacing.s1);
      final deco =
          tester.widget<Container>(blocks().first).decoration! as BoxDecoration;
      expect(deco.color, c.bgSurfaceMuted);
      expect(deco.borderRadius, IsharaRadius.brLg);
    });
  }

  testWidgets('announced once by its label, blocks hidden', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpThemed(
      tester,
      const ListSkeleton(
        itemHeight: IsharaSizes.listTileHeight,
        semanticLabel: 'Loading signs',
      ),
    );
    expect(find.bySemanticsLabel('Loading signs'), findsOneWidget);
    handle.dispose();
  });
}
