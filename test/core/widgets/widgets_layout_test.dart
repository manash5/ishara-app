import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void _noop() {}

/// Regression: these widgets used to fill all the height they were offered
/// (a bare `Center` / `Container.alignment` under loose constraints), e.g.
/// the bottom bar in `Scaffold.bottomNavigationBar` covered the screen.
void main() {
  final cases = <String, (Widget, double)>{
    'IsharaBottomBar': (
      IsharaBottomBar(
        current: IsharaTab.learn,
        onTabSelected: (_) {},
        onPractice: _noop,
      ),
      IsharaSizes.bottomBarHeight,
    ),
    'IsharaSnackbar': (
      const IsharaSnackbar(message: 'm', actionLabel: 'Retry', onAction: _noop),
      50,
    ),
    'MatchTile': (
      const MatchTile(label: 'a', onTap: _noop),
      IsharaSizes.compactTileHeight,
    ),
    'SectionHeader': (
      const SectionHeader(title: 'a', actionLabel: 'b', onAction: _noop),
      IsharaSizes.minTouch,
    ),
    'IsharaTopAppBar': (
      const IsharaTopAppBar(title: 'a', onLeading: _noop),
      IsharaSizes.appBarHeight,
    ),
  };

  for (final MapEntry(key: name, value: (widget, height)) in cases.entries) {
    testWidgets('$name keeps its height under loose constraints', (
      tester,
    ) async {
      // pumpThemed centres the child: bounded but loose height.
      await pumpThemed(tester, SizedBox(width: 380, child: widget));
      expect(tester.getSize(find.byWidget(widget)).height, height);
    });
  }
}
