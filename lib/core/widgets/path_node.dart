import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'src/lip_surface.dart';

/// Figma `PathNode` → `state`.
enum PathNodeState { completed, current, locked, review, checkpoint, chest }

/// Figma `PathNode` (roadmap kit — gamified, 3D lip): a 72dp node on the
/// Learn path. `current` adds a 96dp lime halo and pulses (1.0 → 1.06,
/// 1.2s loop) unless motion is reduced. Nodes press down into their 6dp lip.
class PathNode extends StatefulWidget {
  const PathNode({
    super.key,
    required this.state,
    required this.label,
    required this.onTap,
  });

  final PathNodeState state;

  /// What the node is, e.g. "Lesson 3: Greetings". The state is appended.
  final String label;
  final VoidCallback? onTap;

  static const String chestAsset = 'assets/roadmap/chest.svg';

  @override
  State<PathNode> createState() => _PathNodeState();
}

class _PathNodeState extends State<PathNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: IsharaMotion.pulsePeriod,
  );

  bool get _pulses => widget.state == PathNodeState.current;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(PathNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  void _syncPulse() {
    final run = _pulses && !IsharaMotion.reduced(context);
    if (run && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!run && _pulse.isAnimating) {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  static String stateLabel(PathNodeState s) => switch (s) {
    PathNodeState.completed => 'completed',
    PathNodeState.current => 'start here',
    PathNodeState.locked => 'locked',
    PathNodeState.review => 'review',
    PathNodeState.checkpoint => 'checkpoint, locked',
    PathNodeState.chest => 'reward chest',
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = widget.state;

    Widget node;
    if (s == PathNodeState.chest) {
      node = PressableScale(
        enabled: widget.onTap != null,
        onPressed: widget.onTap,
        child: SvgPicture.asset(
          PathNode.chestAsset,
          width: IsharaSizes.pathNode,
          height: IsharaSizes.pathNode,
          excludeFromSemantics: true,
        ),
      );
    } else {
      final (face, lip, icon, iconColor, iconSize) = switch (s) {
        PathNodeState.completed => (
          c.funGold,
          c.funGoldLip,
          IsharaIcons.check,
          c.staticWhite,
          IsharaSizes.pathNodeCheck,
        ),
        PathNodeState.current => (
          c.accentDefault,
          c.accentLip,
          null,
          c.textOnAccent,
          IsharaSizes.pathNodeStar,
        ),
        PathNodeState.locked => (
          c.borderDefault,
          c.borderStrong,
          IsharaIcons.lock,
          c.textTertiary,
          IsharaSizes.pathNodeIcon,
        ),
        PathNodeState.review => (
          c.funLavender,
          c.funLavenderLip,
          IsharaIcons.rotateCcw,
          c.staticWhite,
          IsharaSizes.pathNodeIcon,
        ),
        PathNodeState.checkpoint => (
          c.borderDefault,
          c.borderStrong,
          IsharaIcons.trophy,
          c.textTertiary,
          IsharaSizes.pathNodeIcon,
        ),
        PathNodeState.chest => throw StateError('handled above'),
      };
      final glyph = icon == null
          ? IsharaFilledIcon(
              IsharaFilledIconKind.star,
              size: iconSize,
              color: iconColor,
            )
          : Icon(icon, size: iconSize, color: iconColor);

      node = LipPressDetector(
        onTap: widget.onTap,
        builder: (context, pressed) => SizedBox.square(
          dimension: IsharaSizes.pathNode,
          child: LipSurface(
            key: const ValueKey('path-node-surface'),
            faceColor: face,
            lipColor: lip,
            lipHeight: IsharaSizes.lipNode,
            pressed: pressed,
            child: Center(child: glyph),
          ),
        ),
      );

      if (s == PathNodeState.current) {
        node = SizedBox.square(
          dimension: IsharaSizes.pathNodeHalo,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  key: const ValueKey('path-node-halo'),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: c.funLime,
                      width: IsharaSizes.pathNodeHaloStroke,
                    ),
                  ),
                ),
              ),
              node,
            ],
          ),
        );
      }
    }

    if (_pulses) {
      node = ScaleTransition(
        scale: Tween(
          begin: 1.0,
          end: IsharaMotion.pulseScale,
        ).animate(CurvedAnimation(parent: _pulse, curve: IsharaMotion.move)),
        child: node,
      );
    }

    return Semantics(
      container: true,
      button: widget.onTap != null,
      label: '${widget.label}, ${stateLabel(s)}',
      onTap: widget.onTap,
      excludeSemantics: true,
      child: node,
    );
  }
}
