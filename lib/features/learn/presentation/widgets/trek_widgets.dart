import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/learn_path_provider.dart';
import 'trek_painters.dart';

/// Sizes of the Himalayan-trek roadmap. This design is Ishara's own (it
/// replaced the Figma "10 Learn" path), so these are feature constants on the
/// token scale rather than shared tokens.
abstract final class TrekSizes {
  static const double marker = IsharaSizes.iconBoxMd; // 40
  static const double markerIcon = IsharaSizes.iconMd; // 20
  static const double ridgeWidth = 132;
  static const double ridgeHeight = 56;
  static const double progressBar = IsharaSizes.stepBarHeight; // 8
  static const double flagsWidth = 96;
  static const double flagsHeight = 28;
  static const double danu = 96;
}

/// Unit banner: the stage of the climb. Flat card in the unit colour with a
/// snow-capped ridge, the learned/total progress bar and the guidebook.
class TrekUnitHeader extends StatelessWidget {
  const TrekUnitHeader({super.key, required this.unit, required this.onGuide});

  final PathUnit unit;
  final VoidCallback onGuide;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final (face, lip, fg) = UnitHeader.colorsFor(c, unit.color);
    final progress = unit.total == 0 ? 0.0 : unit.learned / unit.total;
    return Semantics(
      container: true,
      header: true,
      label:
          'Unit ${unit.number}: ${unit.title}, '
          '${unit.learned} of ${unit.total} signs learned',
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: face, borderRadius: IsharaRadius.brLg),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              width: TrekSizes.ridgeWidth,
              height: TrekSizes.ridgeHeight,
              child: ExcludeSemantics(
                child: CustomPaint(
                  painter: RidgePainter(rock: lip, snow: c.staticWhite),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(IsharaSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ExcludeSemantics(
                          child: Text(
                            'Unit ${unit.number} · base camp'.toUpperCase(),
                            style: s.labelSmall.copyWith(color: fg),
                          ),
                        ),
                      ),
                      IsharaIconButton(
                        icon: IsharaIcons.bookOpen,
                        tooltip: 'Unit ${unit.number} guidebook',
                        color: fg,
                        compact: true,
                        onPressed: onGuide,
                      ),
                    ],
                  ),
                  ExcludeSemantics(
                    child: Text(
                      unit.title,
                      style: s.titleLarge.copyWith(color: fg),
                    ),
                  ),
                  const SizedBox(height: IsharaSpacing.s3),
                  ExcludeSemantics(
                    child: Row(
                      children: [
                        SizedBox(
                          width: TrekSizes.ridgeWidth,
                          child: ClipRRect(
                            borderRadius: IsharaRadius.brFull,
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: TrekSizes.progressBar,
                              color: fg,
                              backgroundColor: fg.withValues(
                                alpha: IsharaSizes.placeholderOpacity * 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: IsharaSpacing.s2),
                        Text(
                          '${unit.learned}/${unit.total}',
                          style: s.labelMedium.copyWith(color: fg),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small flat marker sitting on the trail.
class WaypointMarker extends StatelessWidget {
  const WaypointMarker({super.key, required this.state});

  final PathNodeState state;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (Color fill, Color fg, IconData icon, Color? ring) = switch (state) {
      PathNodeState.completed => (
        c.accentDefault,
        c.textOnAccent,
        IsharaIcons.check,
        null,
      ),
      PathNodeState.review => (
        c.funLavender,
        c.funTealHero,
        IsharaIcons.rotateCcw,
        null,
      ),
      PathNodeState.checkpoint => (
        c.funTealHero,
        c.funLime,
        IsharaIcons.flag,
        null,
      ),
      PathNodeState.current => (
        c.funLime,
        c.funTealHero,
        IsharaIcons.hand,
        null,
      ),
      PathNodeState.chest => (c.funGold, c.funTealHero, IsharaIcons.flag, null),
      PathNodeState.locked => (
        c.bgSurfaceMuted,
        c.textTertiary,
        IsharaIcons.lock,
        c.borderDefault,
      ),
    };
    return Container(
      width: TrekSizes.marker,
      height: TrekSizes.marker,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(
          color: ring ?? c.bgCanvas,
          width: IsharaSizes.selectedBorder,
        ),
      ),
      child: Icon(icon, size: TrekSizes.markerIcon, color: fg),
    );
  }
}

/// Lesson name + status beside a marker.
class WaypointLabel extends StatelessWidget {
  const WaypointLabel({
    super.key,
    required this.stop,
    required this.unitNumber,
    this.alignEnd = false,
  });

  final PathStop stop;
  final int unitNumber;
  final bool alignEnd;

  static String statusOf(PathStop stop, int unit) => switch (stop.state) {
    PathNodeState.completed => 'Learned',
    PathNodeState.review => 'Review',
    PathNodeState.current => 'Next',
    PathNodeState.locked => 'Locked',
    PathNodeState.chest => 'Reward',
    PathNodeState.checkpoint => 'Unit $unit checkpoint',
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final locked = stop.state == PathNodeState.locked;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          stop.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: s.titleMedium.copyWith(
            color: locked ? c.textTertiary : c.textPrimary,
          ),
        ),
        Text(
          statusOf(stop, unitNumber),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: s.bodySmall.copyWith(color: c.textSecondary),
        ),
      ],
    );
  }
}

/// The lesson you're on: a card on the trail with a Start button.
class CurrentLessonCard extends StatelessWidget {
  const CurrentLessonCard({
    super.key,
    required this.stop,
    required this.onStart,
  });

  final PathStop stop;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Container(
      padding: const EdgeInsets.all(IsharaSpacing.cardPadding),
      decoration: BoxDecoration(
        color: c.bgSurface,
        borderRadius: IsharaRadius.brLg,
        border: Border.all(color: c.funLime, width: IsharaSizes.selectedBorder),
        boxShadow: IsharaElevation.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Takes the room it needs; ellipsises only on very large text.
              const Flexible(child: IsharaChip(label: 'Next on the trail')),
              const SizedBox(width: IsharaSpacing.s2),
              Icon(
                IsharaIcons.hand,
                size: IsharaSizes.iconMd,
                color: c.accentText,
              ),
            ],
          ),
          const SizedBox(height: IsharaSpacing.s2),
          Text(
            stop.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: s.titleLarge.copyWith(color: c.textPrimary),
          ),
          Text(
            '${stop.signs} signs · ${stop.minutes} min',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: s.bodySmall.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: IsharaSpacing.s3),
          IsharaButton(
            label: 'Start',
            icon: IsharaIcons.chevronRight,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

/// Prayer flags: the reward stop.
class PrayerFlags extends StatelessWidget {
  const PrayerFlags({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      width: TrekSizes.flagsWidth,
      height: TrekSizes.flagsHeight,
      child: CustomPaint(
        painter: PrayerFlagsPainter(
          colors: [c.funLavender, c.funLime, c.funMint, c.funPeach, c.funGold],
          string: c.borderStrong,
        ),
      ),
    );
  }
}
