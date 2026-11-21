import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

// TODO(tokens): Figma `leagueBanner` icon (22) and `promotionLine` vertical
// padding (6) have no dedicated IsharaSizes tokens — see report.
const double _bannerIcon = IsharaSizes.signThumbIcon;
const double _promotionLinePaddingY = IsharaSizes.statsIconGap;
const double _hairline = 1;

/// Figma `leagueBanner` (12:1218): accent/subtle card with a filled zap.
class LeagueBanner extends StatelessWidget {
  const LeagueBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(IsharaSpacing.cardPadding),
      decoration: BoxDecoration(
        color: c.accentSubtle,
        borderRadius: IsharaRadius.brLg,
      ),
      child: Row(
        children: [
          IsharaFilledIcon(
            IsharaFilledIconKind.zap,
            size: _bannerIcon,
            color: c.accentText,
          ),
          const SizedBox(width: IsharaSpacing.s3),
          Expanded(
            child: Text(
              text,
              style: context.textStyles.bodyMedium.copyWith(
                color: c.accentText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Figma `promotionLine` (12:1272): hairlines either side of an
/// upper-case label/small caption.
class PromotionZoneDivider extends StatelessWidget {
  const PromotionZoneDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final line = Expanded(
      child: Container(height: _hairline, color: c.borderDefault),
    );
    return Semantics(
      container: true,
      label: 'Promotion zone ends here',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: _promotionLinePaddingY),
        child: Row(
          children: [
            line,
            const SizedBox(width: IsharaSpacing.s2),
            Text(
              'Promotion zone'.toUpperCase(),
              style: context.textStyles.labelSmall.copyWith(
                color: c.textTertiary,
              ),
            ),
            const SizedBox(width: IsharaSpacing.s2),
            line,
          ],
        ),
      ),
    );
  }
}

/// Loading skeleton shaped like [LeaderboardTile]s.
///
/// TODO(motion): motion.md asks for a subtle shimmer (see report).
class LeaderboardSkeleton extends StatelessWidget {
  const LeaderboardSkeleton({super.key, this.count = 7});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading leaderboard',
      child: ExcludeSemantics(
        child: Column(
          children: [
            for (var i = 0; i < count; i++) ...[
              if (i > 0) const SizedBox(height: IsharaSpacing.s1),
              Container(
                height: IsharaSizes.compactTileHeight,
                decoration: BoxDecoration(
                  color: context.colors.bgSurfaceMuted,
                  borderRadius: IsharaRadius.brLg,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty / error message for the leaderboard.
///
/// TODO(widgets): Figma has no empty/error state for frame 15 (see report).
class RanksStateMessage extends StatelessWidget {
  const RanksStateMessage({
    super.key,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: IsharaSpacing.s8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: s.titleMedium.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: IsharaSpacing.stackGap),
            Text(
              body,
              textAlign: TextAlign.center,
              style: s.bodyMedium.copyWith(color: c.textSecondary),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: IsharaSpacing.s4),
              IsharaButton(
                label: actionLabel!,
                variant: IsharaButtonVariant.outlined,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
