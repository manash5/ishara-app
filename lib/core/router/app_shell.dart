import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import '../widgets/widgets.dart';
import 'app_routes.dart';

/// The four-tab shell (Figma `AppNavigationBar`). Branch order matches
/// [IsharaTab]; the centre camera button opens Practice full-screen.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final current = navigationShell.currentIndex;
    return Scaffold(
      // Content scrolls under the floating bar (screens pad by
      // IsharaSizes.bottomBarContentPadding).
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: IsharaSpacing.s3),
        child: IsharaBottomBar(
          current: IsharaTab.values[current],
          onTabSelected: (tab) => navigationShell.goBranch(
            tab.index,
            // Re-tapping the active tab returns to its first screen.
            initialLocation: tab.index == current,
          ),
          onPractice: () => const PracticeRoute().push<void>(context),
        ),
      ),
    );
  }
}
