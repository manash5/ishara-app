import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/learn_path_provider.dart';
import 'trek_painters.dart';
import 'trek_widgets.dart';

/// Layout of the Himalayan-trek roadmap (Ishara's own design; see
/// [TrekSizes]). The trail climbs up the screen: each unit is a stage with
/// its first lesson at the bottom and its summit checkpoint at the top.
abstract final class PathLayout {
  /// The trail sways this fraction of the width either side of centre.
  static const double sway = 0.2;
  static const double swayStep = 0.9; // radians per stop

  /// Waypoint row: 48dp target + breathing room; text scales on top.
  static const double rowPadding = IsharaSpacing.s8;
  static const double labelGap = IsharaSpacing.s8;

  /// Current-lesson card: fixed chrome (2×16 padding, 2×2 border, 8 + 12
  /// gaps, 56 button, 8 chip padding) plus its one-line texts (chip 16,
  /// title 28, details 18), which scale with the user's text size.
  static const double cardChrome =
      IsharaSpacing.cardPadding * 2 +
      IsharaSizes.selectedBorder * 2 +
      IsharaSpacing.s2 +
      IsharaSpacing.s3 +
      IsharaSizes.controlHeight +
      IsharaSpacing.s2;
  static const double cardText = 16 + 28 + 18;
  static const double cardMargin = IsharaSpacing.s3;

  /// Horizontal trail position of the [index]-th stop (fraction of width).
  static double xOf(int index) =>
      0.5 + sway * math.sin(index * swayStep + math.pi / 6);

  /// Which stretch of trail a guide Danu stands beside: the lowest gap
  /// between stop j and j + 1 (of [stops]) with at least [need] (fraction of
  /// the width) free on its side, else the roomiest gap.
  static int guideGap(int stops, {required bool onLeft, required double need}) {
    double room(int j) {
      final (a, b) = (xOf(j), xOf(j + 1));
      return onLeft ? math.min(a, b) : 1 - math.max(a, b);
    }

    var best = 0;
    for (var j = 0; j < stops - 1; j++) {
      if (room(j) >= need) return j;
      if (room(j) > room(best)) best = j;
    }
    return best;
  }
}

/// The scrolling trek: stages stacked bottom (Unit 1) → top, each a banner
/// (base camp) with its waypoints climbing a curved trail above it. Rows fade
/// and rise in and the trail draws itself on first load; all instant with
/// reduced motion.
class LearnPathView extends StatefulWidget {
  const LearnPathView({
    super.key,
    required this.units,
    required this.onStop,
    required this.onGuide,
    this.bottomPadding = 0,
  });

  final List<PathUnit> units;
  final void Function(PathUnit unit, PathStop stop) onStop;
  final ValueChanged<PathUnit> onGuide;
  final double bottomPadding;

  /// First-load stagger: up to [maxStaggered] rows, [staggerStep] apart.
  static const int maxStaggered = 8;
  static const Duration staggerStep = Duration(milliseconds: 30);
  static const double riseOffset = IsharaSpacing.s2;

  @override
  State<LearnPathView> createState() => _LearnPathViewState();
}

class _LearnPathViewState extends State<LearnPathView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: IsharaMotion.celebrate * 2,
  );
  late final Animation<double> _trail = CurvedAnimation(
    parent: _entrance,
    curve: IsharaMotion.enter,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (IsharaMotion.reduced(context)) {
      _entrance.value = 1;
    } else {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  /// Rows in bottom-up order (the order they appear on first load).
  Animation<double> _rowEntrance(int order) {
    final total = _entrance.duration!.inMilliseconds;
    final start =
        (LearnPathView.staggerStep.inMilliseconds *
            math.min(order, LearnPathView.maxStaggered)) /
        total;
    final end = start + IsharaMotion.standard.inMilliseconds / total;
    return CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, math.min(end, 1), curve: IsharaMotion.enter),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Stops stagger in bottom-up across all units: unit k's first stop
    // follows the last stop of unit k-1.
    final firstOrder = <int>[];
    var n = 0;
    for (final unit in widget.units) {
      firstOrder.add(n);
      n += unit.stops.length;
    }
    return CustomScrollView(
      key: const Key('learn-path'),
      // Climb upwards: the first stage starts at the bottom of the screen.
      reverse: true,
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: widget.bottomPadding)),
        for (final (u, unit) in widget.units.indexed)
          SliverToBoxAdapter(
            child: _Stage(
              unit: unit,
              guide: TrekGuide.spotFor(widget.units, u),
              trail: _trail,
              entranceFor: (i) => _rowEntrance(firstOrder[u] + i),
              onStop: (stop) => widget.onStop(unit, stop),
              onGuide: () => widget.onGuide(unit),
            ),
          ),
      ],
    );
  }
}

/// One stage: waypoints on the trail, climbing up from the banner (base camp).
class _Stage extends StatelessWidget {
  const _Stage({
    required this.unit,
    required this.guide,
    required this.trail,
    required this.entranceFor,
    required this.onStop,
    required this.onGuide,
  });

  final PathUnit unit;

  /// Danu beside this stage's trail ([TrekGuide.spotFor]), if any.
  final TrekGuideSpot? guide;
  final Animation<double> trail;

  /// Entrance animation for the stop at this index (first lesson = 0).
  final Animation<double> Function(int index) entranceFor;
  final ValueChanged<PathStop> onStop;
  final VoidCallback onGuide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: IsharaSpacing.screenMargin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: IsharaSpacing.s4),
          _Trail(
            unit: unit,
            guide: guide,
            trail: trail,
            entranceFor: entranceFor,
            onStop: onStop,
          ),
          const SizedBox(height: IsharaSpacing.s2),
          // The banner is the stage's base camp, at the foot of its trail.
          TrekUnitHeader(unit: unit, onGuide: onGuide),
        ],
      ),
    );
  }
}

class _Trail extends StatelessWidget {
  const _Trail({
    required this.unit,
    required this.guide,
    required this.trail,
    required this.entranceFor,
    required this.onStop,
  });

  final PathUnit unit;
  final TrekGuideSpot? guide;
  final Animation<double> trail;
  final Animation<double> Function(int index) entranceFor;
  final ValueChanged<PathStop> onStop;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final scaler = MediaQuery.textScalerOf(context);
    final labelText =
        s.titleMedium.height! * s.titleMedium.fontSize! +
        s.bodySmall.height! * s.bodySmall.fontSize!;
    final rowH =
        math.max(IsharaSizes.minTouch, scaler.scale(labelText)) +
        PathLayout.rowPadding;
    final cardH =
        PathLayout.cardChrome +
        scaler.scale(PathLayout.cardText) +
        PathLayout.cardMargin * 2;

    final stops = unit.stops;
    final reached = stops.lastIndexWhere(
      (s) =>
          s.state == PathNodeState.current ||
          s.state == PathNodeState.completed ||
          s.state == PathNodeState.review,
    );

    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        final cardW = w - TrekSizes.danu;
        final anchors = List<Offset>.filled(stops.length, Offset.zero);
        final rows = <Widget>[];
        var y = 0.0;
        final spot = guide;
        final below = spot == null
            ? -1
            : PathLayout.guideGap(
                stops.length,
                onLeft: spot.onLeft,
                need: (TrekSizes.danu + IsharaSpacing.s2) / w,
              );
        // Rows top → bottom are the stops last → first (the trail climbs).
        for (var i = stops.length - 1; i >= 0; i--) {
          final stop = stops[i];
          final current = stop.state == PathNodeState.current;
          final h = current ? cardH : rowH;
          final x = current ? cardW / 2 : w * PathLayout.xOf(i);
          anchors[i] = Offset(x, y + h / 2);
          rows.add(
            Positioned(
              left: 0,
              right: 0,
              top: y,
              height: h,
              child: _Entrance(
                animation: entranceFor(i),
                child: current
                    ? _CurrentRow(
                        stop: stop,
                        cardWidth: cardW,
                        onStart: () => onStop(stop),
                      )
                    : _WaypointRow(
                        stop: stop,
                        unitNumber: unit.number,
                        x: x,
                        width: w,
                        onTap: () => onStop(stop),
                      ),
              ),
            ),
          );
          y += h;
          // Danu's own row, between this stop and the one below it.
          if (spot != null && i == below + 1) {
            rows.add(
              Positioned(
                left: 0,
                right: 0,
                top: y,
                height: TrekSizes.guideRow,
                child: _Entrance(
                  animation: entranceFor(i),
                  child: _GuideRow(spot: spot),
                ),
              ),
            );
            y += TrekSizes.guideRow;
          }
        }
        return SizedBox(
          height: y,
          child: Stack(
            children: [
              Positioned.fill(
                child: ExcludeSemantics(
                  child: CustomPaint(
                    painter: TrailPainter(
                      points: anchors,
                      walked: reached + 1,
                      walkedColor: c.accentDefault,
                      aheadColor: c.borderStrong,
                      progress: trail,
                    ),
                  ),
                ),
              ),
              ...rows,
            ],
          ),
        );
      },
    );
  }
}

class _WaypointRow extends StatelessWidget {
  const _WaypointRow({
    required this.stop,
    required this.unitNumber,
    required this.x,
    required this.width,
    required this.onTap,
  });

  final PathStop stop;
  final int unitNumber;
  final double x;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelRight = x <= width / 2;
    final reward = stop.state == PathNodeState.chest;
    final half = (reward ? TrekSizes.flagsWidth : IsharaSizes.minTouch) / 2;
    final gap = PathLayout.labelGap / 2;
    return Semantics(
      container: true,
      button: true,
      label: '${stop.title}, ${WaypointLabel.statusOf(stop, unitNumber)}',
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(
              left: x - half,
              width: half * 2,
              top: 0,
              bottom: 0,
              child: Center(
                child: reward
                    ? const PrayerFlags()
                    : WaypointMarker(state: stop.state),
              ),
            ),
            Positioned(
              left: labelRight ? x + half + gap : 0,
              right: labelRight ? 0 : width - x + half + gap,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: labelRight
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: WaypointLabel(
                  stop: stop,
                  unitNumber: unitNumber,
                  alignEnd: !labelRight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentRow extends StatelessWidget {
  const _CurrentRow({
    required this.stop,
    required this.cardWidth,
    required this.onStart,
  });

  final PathStop stop;
  final double cardWidth;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          width: cardWidth,
          top: PathLayout.cardMargin,
          bottom: PathLayout.cardMargin,
          child: CurrentLessonCard(stop: stop, onStart: onStart),
        ),
        // Danu, the trek guide, waving (animated) from beside the card.
        const Positioned(
          right: 0,
          top: 0,
          child: ExcludeSemantics(
            child: DanuMascot(
              pose: DanuPose.wave,
              size: TrekSizes.danu,
              animated: true,
            ),
          ),
        ),
      ],
    );
  }
}

/// Danu beside the trail, facing it: on the right-hand side the artwork is
/// mirrored so Danu still points, bows and thinks towards the trail. Danu
/// stands at the bottom of the row; the top is headroom for the thought
/// cloud.
class _GuideRow extends StatelessWidget {
  const _GuideRow({required this.spot});

  final TrekGuideSpot spot;

  @override
  Widget build(BuildContext context) {
    final (:pose, :onLeft) = spot;
    return ExcludeSemantics(
      child: Align(
        alignment: onLeft ? Alignment.bottomLeft : Alignment.bottomRight,
        child: Transform.flip(
          flipX: !onLeft,
          child: DanuMascot(
            key: Key('trek-guide-${pose.name}'),
            pose: pose,
            size: TrekSizes.danu,
            animated: true,
          ),
        ),
      ),
    );
  }
}

/// Fade + 8px rise (motion.md list first load).
class _Entrance extends StatelessWidget {
  const _Entrance({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, LearnPathView.riseOffset * (1 - animation.value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
