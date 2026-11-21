import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// The four tabs of the bottom bar (Figma `AppNavigationBar` → `active`).
enum IsharaTab {
  learn('Learn', IsharaIcons.house),
  dictionary('Dictionary', IsharaIcons.bookOpen),
  leaderboard('Ranks', IsharaIcons.trophy),
  profile('Profile', IsharaIcons.user);

  const IsharaTab(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Figma `AppNavigationBar` / ui.md `IsharaBottomBar`: a rounded bg/surface
/// bar (radius 24, hairline border/subtle, elevation/2) with four labelled
/// tabs and a centre 52dp lime camera button that opens practice — the
/// camera button is an action, not a tab.
///
/// Screens using it need [IsharaSizes.bottomBarContentPadding] at the bottom.
class IsharaBottomBar extends StatelessWidget {
  const IsharaBottomBar({
    super.key,
    required this.current,
    required this.onTabSelected,
    required this.onPractice,
    this.practiceLabel = 'Practice signing',
  });

  final IsharaTab current;
  final ValueChanged<IsharaTab> onTabSelected;
  final VoidCallback? onPractice;
  final String practiceLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;

    Widget tab(IsharaTab t) {
      final active = t == current;
      final color = active ? c.accentDefault : c.textTertiary;
      return Expanded(
        child: Semantics(
          container: true,
          button: true,
          selected: active,
          label: t.label,
          onTap: () => onTabSelected(t),
          excludeSemantics: true,
          child: InkResponse(
            onTap: () => onTabSelected(t),
            radius: IsharaSizes.minTouch,
            child: SizedBox(
              height: IsharaSizes.bottomBarTabHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(t.icon, size: IsharaSizes.iconLg, color: color),
                  const SizedBox(height: IsharaSpacing.s1),
                  Text(
                    t.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: s.labelMedium.copyWith(color: color),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final practice = Expanded(
      child: Center(
        child: Semantics(
          container: true,
          button: true,
          label: practiceLabel,
          onTap: onPractice,
          excludeSemantics: true,
          child: PressableScale(
            enabled: onPractice != null,
            onPressed: onPractice,
            child: Container(
              key: const ValueKey('bottom-bar-practice'),
              width: IsharaSizes.practiceButton,
              height: IsharaSizes.practiceButton,
              decoration: BoxDecoration(
                color: c.funLime,
                shape: BoxShape.circle,
                boxShadow: IsharaElevation.level1,
              ),
              child: Icon(
                IsharaIcons.camera,
                size: IsharaSizes.iconLg,
                color: c.funTealHero,
              ),
            ),
          ),
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(
        IsharaSpacing.s2,
        IsharaSizes.bottomBarPaddingTop,
        IsharaSpacing.s2,
        IsharaSizes.bottomBarPaddingBottom,
      ),
      decoration: BoxDecoration(
        color: c.bgSurface,
        borderRadius: BorderRadius.circular(IsharaSizes.bottomBarRadius),
        border: Border.all(color: c.borderSubtle),
        boxShadow: IsharaElevation.level2,
      ),
      child: Row(
        children: [
          tab(IsharaTab.learn),
          tab(IsharaTab.dictionary),
          practice,
          tab(IsharaTab.leaderboard),
          tab(IsharaTab.profile),
        ],
      ),
    );
  }
}
