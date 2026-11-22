import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `HeroBackdrop` → `layout`.
enum HeroBackdropLayout {
  welcome,
  header,

  /// [header] without the lime circle and lime diamond on the right, so
  /// Danu can sit there on Lesson complete (26). Not a Figma variant: added
  /// on request.
  results,
}

/// Figma `HeroBackdrop` (v4 minimal kit): a fun/teal-hero block with playful
/// decorative shapes, drawn behind an optional [child].
///
/// Shape geometry is the Figma artwork, laid out on a 412-wide frame and
/// scaled to the available width. Purely decorative: excluded from semantics.
class HeroBackdrop extends StatelessWidget {
  const HeroBackdrop({
    super.key,
    this.layout = HeroBackdropLayout.header,
    this.child,
    this.intro,
    this.drift,
  });

  final HeroBackdropLayout layout;
  final Widget? child;

  /// Optional entrance (0 → 1), e.g. the Splash: each shape glides in from
  /// outside its Figma position, grows from
  /// [HeroBackdropPainter.introStartScale] and fades in (squares spin into
  /// place), staggered in paint order. Null = static artwork.
  final Animation<double>? intro;

  /// Optional ambient loop (a repeating 0 → 1): every shape floats on its own
  /// small orbit and gently breathes. Null = still. The caller owns both
  /// controllers and skips them under reduced motion.
  final Animation<double>? drift;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRect(
      child: CustomPaint(
        painter: HeroBackdropPainter(
          layout: layout,
          colors: c,
          intro: intro,
          drift: drift,
        ),
        child: child ?? const SizedBox.expand(),
      ),
    );
  }
}

enum _Kind { ellipse, roundedSquare }

enum _Hue { lime, lavender, mint }

/// One Figma shape: frame-space position (x, y) of its local origin, size,
/// corner radius and rotation in degrees (Figma: counter-clockwise).
class _Shape {
  const _Shape(
    this.kind,
    this.hue,
    this.x,
    this.y,
    this.size, {
    this.radius = 0,
    this.rotation = 0,
  });

  final _Kind kind;
  final _Hue hue;
  final double x, y, size, radius, rotation;
}

/// Figma frame width the artwork was drawn on.
const double _artboardWidth = 412;

const Map<HeroBackdropLayout, List<_Shape>> _shapes = {
  HeroBackdropLayout.welcome: [
    _Shape(_Kind.ellipse, _Hue.lime, -90, -230, 400),
    _Shape(_Kind.ellipse, _Hue.lavender, -80, 140, 460),
    _Shape(_Kind.ellipse, _Hue.mint, 300, 96, 130),
    _Shape(
      _Kind.roundedSquare,
      _Hue.lime,
      120,
      420,
      30,
      radius: 4,
      rotation: 45,
    ),
    _Shape(
      _Kind.roundedSquare,
      _Hue.lavender,
      322,
      36,
      34,
      radius: 6,
      rotation: 15,
    ),
  ],
  HeroBackdropLayout.header: [
    _Shape(_Kind.ellipse, _Hue.lavender, 284, -96, 220),
    _Shape(_Kind.ellipse, _Hue.lime, 350, 118, 120),
    _Shape(_Kind.ellipse, _Hue.mint, 246, 22, 56),
    _Shape(
      _Kind.roundedSquare,
      _Hue.lime,
      300,
      180,
      16,
      radius: 3,
      rotation: 45,
    ),
    _Shape(
      _Kind.roundedSquare,
      _Hue.lavender,
      226,
      108,
      18,
      radius: 4,
      rotation: 15,
    ),
  ],
  HeroBackdropLayout.results: [
    _Shape(_Kind.ellipse, _Hue.lavender, 284, -96, 220),
    _Shape(_Kind.ellipse, _Hue.mint, 246, 22, 56),
    _Shape(
      _Kind.roundedSquare,
      _Hue.lavender,
      226,
      108,
      18,
      radius: 4,
      rotation: 15,
    ),
  ],
};

@visibleForTesting
class HeroBackdropPainter extends CustomPainter {
  HeroBackdropPainter({
    required this.layout,
    required this.colors,
    this.intro,
    this.drift,
  }) : super(repaint: Listenable.merge([?intro, ?drift]));

  final HeroBackdropLayout layout;
  final IsharaColors colors;
  final Animation<double>? intro;
  final Animation<double>? drift;

  /// Intro choreography: shapes start at this scale, [introTravel] artboard
  /// px further out from the artboard centre, squares [introSpin] degrees
  /// round; each starts [introStagger] after the previous one and takes
  /// [introShapeSpan] of the whole intro.
  static const double introStartScale = 0.3;
  static const double introTravel = IsharaSpacing.s12 * 2;
  static const double introSpin = 90;
  static const double introStagger = 0.1;
  static const double introShapeSpan = 0.6;

  /// Ambient drift: orbit radius (artboard px), breathing amount and the
  /// squares' sway (degrees). Each shape is phase-shifted so they never move
  /// in step.
  static const double driftRadius = IsharaSpacing.s2;
  static const double driftBreath = 0.03;
  static const double driftSway = 6;

  /// Centre the intro pushes shapes away from (artboard px).
  static const Offset _introOrigin = Offset(_artboardWidth / 2, 300);

  /// Progress (0–1) of shape [index] at intro value [t].
  @visibleForTesting
  static double shapeProgress(double t, int index) {
    final start = index * introStagger;
    final local = ((t - start) / introShapeSpan).clamp(0.0, 1.0);
    return IsharaMotion.enter.transform(local);
  }

  Color _color(_Hue hue) => switch (hue) {
    _Hue.lime => colors.funLime,
    _Hue.lavender => colors.funLavender,
    _Hue.mint => colors.funMint,
  };

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = colors.funTealHero);
    final k = size.width / _artboardWidth;
    final t = intro?.value ?? 1;
    final d = drift?.value;
    for (final (i, s) in _shapes[layout]!.indexed) {
      final p = intro == null ? 1.0 : shapeProgress(t, i);
      if (p <= 0) continue;
      final paint = Paint()..color = _color(s.hue).withValues(alpha: p);
      final half = s.size / 2;
      final rot0 = s.rotation * math.pi / 180;
      // Figma rotates around the local origin; find the shape's centre.
      var cx = s.x + half * math.cos(rot0) + half * math.sin(rot0);
      var cy = s.y - half * math.sin(rot0) + half * math.cos(rot0);

      // Intro: glide in from further out along the line from the centre.
      final away = Offset(cx, cy) - _introOrigin;
      final dir = away.distance == 0 ? Offset.zero : away / away.distance;
      cx += dir.dx * introTravel * (1 - p);
      cy += dir.dy * introTravel * (1 - p);
      var theta = rot0;
      var scale = introStartScale + (1 - introStartScale) * p;
      if (s.kind == _Kind.roundedSquare) {
        theta += introSpin * math.pi / 180 * (1 - p);
      }

      // Ambient: a small, phase-shifted orbit plus breathing.
      if (d != null) {
        final a = 2 * math.pi * (d + i * 0.23);
        cx += math.sin(a) * driftRadius;
        cy += math.cos(a * 1.0 + i) * driftRadius;
        scale *= 1 + driftBreath * math.sin(a + i * 0.7);
        if (s.kind == _Kind.roundedSquare) {
          theta += driftSway * math.pi / 180 * math.sin(a);
        }
      }

      canvas.save();
      canvas.translate(cx * k, cy * k);
      canvas.rotate(-theta);
      canvas.scale(scale);
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: s.size * k,
        height: s.size * k,
      );
      switch (s.kind) {
        case _Kind.ellipse:
          canvas.drawOval(rect, paint);
        case _Kind.roundedSquare:
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(s.radius * k)),
            paint,
          );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(HeroBackdropPainter old) =>
      old.layout != layout ||
      old.colors != colors ||
      old.intro != intro ||
      old.drift != drift;

  @override
  bool? hitTest(Offset position) => false;
}
