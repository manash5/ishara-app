import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../ishara_motion.dart';
import '../theme_extensions.dart';

/// One short confetti burst for Lesson complete / Streak (motion.md: playful
/// on results only, ≤ 1.5 s). Plays once on first build over
/// [IsharaMotion.confetti], then paints nothing. Never blocks input, and is
/// skipped entirely with reduced motion.
///
/// Place it on top of the screen in a `Stack` (it fills its parent).
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({super.key, this.pieces = 36, this.seed = 7});

  /// Number of confetti pieces.
  final int pieces;

  /// Fixed seed so the burst looks the same every time (and in tests).
  final int seed;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: IsharaMotion.confetti,
  );
  late final List<_Piece> _pieces = _Piece.scatter(widget.pieces, widget.seed);
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started && !IsharaMotion.reduced(context)) {
      _started = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) return const SizedBox.shrink();
    final c = context.colors;
    final palette = [
      c.funLime,
      c.funLavender,
      c.funMint,
      c.funGold,
      c.funPeach,
    ];
    return IgnorePointer(
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => _controller.isCompleted
              ? const SizedBox.shrink()
              : CustomPaint(
                  size: Size.infinite,
                  painter: _ConfettiPainter(
                    progress: _controller.value,
                    pieces: _pieces,
                    palette: palette,
                  ),
                ),
        ),
      ),
    );
  }
}

/// One confetti piece, in unit coordinates of the burst area.
@immutable
class _Piece {
  const _Piece({
    required this.x,
    required this.drift,
    required this.rise,
    required this.spin,
    required this.size,
    required this.colorIndex,
    required this.round,
  });

  /// Start x (0–1), sideways drift and initial upward kick (fractions of the
  /// area), turns over the burst, size in logical px.
  final double x, drift, rise, spin, size;
  final int colorIndex;
  final bool round;

  static List<_Piece> scatter(int count, int seed) {
    final r = math.Random(seed);
    return [
      for (var i = 0; i < count; i++)
        _Piece(
          x: 0.15 + r.nextDouble() * 0.7,
          drift: (r.nextDouble() - 0.5) * 0.6,
          rise: 0.15 + r.nextDouble() * 0.25,
          spin: (r.nextDouble() - 0.5) * 6,
          size: 6 + r.nextDouble() * 6,
          colorIndex: i,
          round: r.nextBool(),
        ),
    ];
  }
}

/// Paints the burst at [progress] (0–1): pieces pop up from the top third,
/// fall with gravity, spin and fade out over the last 30%.
class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.progress,
    required this.pieces,
    required this.palette,
  });

  final double progress;
  final List<_Piece> pieces;
  final List<Color> palette;

  static const double _origin = 0.3;
  static const double _gravity = 1.1;
  static const double _fadeFrom = 0.7;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress;
    final fade = t < _fadeFrom ? 1.0 : (1 - t) / (1 - _fadeFrom);
    final paint = Paint();
    for (final p in pieces) {
      final dx = (p.x + p.drift * t) * size.width;
      final dy = (_origin - p.rise * t * 2 + _gravity * t * t) * size.height;
      paint.color = palette[p.colorIndex % palette.length].withValues(
        alpha: fade.clamp(0, 1),
      );
      canvas
        ..save()
        ..translate(dx, dy)
        ..rotate(p.spin * t * math.pi);
      if (p.round) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.5,
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
