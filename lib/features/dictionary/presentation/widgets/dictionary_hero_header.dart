import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

// TODO(tokens): no IsharaSizes token for these Figma values — see report.
/// Figma: the HeroBackdrop runs 48 below the header, under the panel's
/// rounded top corners (256 hero − 208 header).
const double heroPanelOverlap = IsharaSpacing.s12;

/// Figma header subtitle opacity (70%).
const double heroSubtitleOpacity = IsharaSizes.heroCaptionOpacity;

/// Figma "13 Dictionary" header: [HeroBackdrop] behind the status bar, the
/// white title + subtitle and [bottom] (the search field), then the
/// [ContentPanel] that follows overlaps the backdrop's lower edge.
class DictionaryHeroHeader extends StatelessWidget {
  const DictionaryHeroHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.bottom,
  });

  final String title;
  final String subtitle;
  final Widget bottom;

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
          bottom: -heroPanelOverlap,
          child: HeroBackdrop(),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              IsharaSpacing.screenMargin,
              IsharaSpacing.s4,
              IsharaSpacing.screenMargin,
              IsharaSpacing.s8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: s.headlineSmall.copyWith(color: c.staticWhite),
                  ),
                ),
                const SizedBox(height: IsharaSizes.titleGap),
                Text(
                  subtitle,
                  style: s.bodySmall.copyWith(
                    color: c.staticWhite.withValues(alpha: heroSubtitleOpacity),
                  ),
                ),
                const SizedBox(height: IsharaSpacing.s5),
                bottom,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
