import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

// TODO(tokens): Figma values with no IsharaSizes token — see report.
/// HeroBackdrop runs 48 below the header, under the panel corners.
const double _heroPanelOverlap = IsharaSpacing.s12;

/// Header bottom padding (36).
const double _headerPaddingBottom = IsharaSpacing.s8 + IsharaSpacing.s1;

/// Subtitle opacity (70%).
const double _subtitleOpacity = IsharaSizes.heroCaptionOpacity;

/// `leagueBadge` (56:3591): 56dp gold square, 28dp trophy.
const double _leagueBadge = 56;
const double _leagueBadgeIcon = 28;

/// `countdown` (56:3599) padding: left 12, right 14, vertical 6.
const EdgeInsets _countdownPadding = EdgeInsets.fromLTRB(
  IsharaSpacing.s3,
  IsharaSizes.statsIconGap,
  IsharaSizes.tooltipPaddingX,
  IsharaSizes.statsIconGap,
);

const IconData _clockIcon = IsharaIcons.clock;

/// Figma "15 Ranks" header (12:1213) over a [HeroBackdrop]: league title,
/// week subtitle, gold league badge and the countdown pill. When [badge] is
/// false (loading / error) only the title is shown.
class LeagueHeader extends StatelessWidget {
  const LeagueHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.countdown,
    this.badge = true,
  });

  final String title;
  final String? subtitle;
  final String? countdown;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: -_heroPanelOverlap,
          child: HeroBackdrop(),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              IsharaSpacing.screenMargin,
              IsharaSpacing.s4,
              IsharaSpacing.screenMargin,
              _headerPaddingBottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(
                              title,
                              style: s.headlineSmall.copyWith(
                                color: c.staticWhite,
                              ),
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: IsharaSpacing.s1),
                            Text(
                              subtitle!,
                              style: s.bodySmall.copyWith(
                                color: c.staticWhite.withValues(
                                  alpha: _subtitleOpacity,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (badge) ...[
                      const SizedBox(width: IsharaSpacing.s4),
                      ExcludeSemantics(
                        child: Container(
                          width: _leagueBadge,
                          height: _leagueBadge,
                          decoration: BoxDecoration(
                            color: c.funGold,
                            borderRadius: IsharaRadius.brLg,
                          ),
                          child: Icon(
                            IsharaIcons.trophy,
                            size: _leagueBadgeIcon,
                            color: c.funTealHero,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (countdown != null) ...[
                  const SizedBox(height: IsharaSpacing.s4),
                  Container(
                    padding: _countdownPadding,
                    decoration: BoxDecoration(
                      color: c.funTealHeroLip,
                      borderRadius: IsharaRadius.brFull,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _clockIcon,
                          size: IsharaSizes.iconSm,
                          color: c.funLime,
                        ),
                        const SizedBox(width: IsharaSizes.statsIconGap),
                        Flexible(
                          child: Text(
                            countdown!,
                            style: s.labelMedium.copyWith(color: c.staticWhite),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
