import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `HeroBackdrop` → `layout`.
enum HeroBackdropLayout { welcome, header }

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
  });

  final HeroBackdropLayout layout;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRect(
      child: CustomPaint(
        painter: HeroBackdropPainter(layout: layout, colors: c),
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
};

@visibleForTesting
class HeroBackdropPainter extends CustomPainter {
  const HeroBackdropPainter({required this.layout, required this.colors});

  final HeroBackdropLayout layout;
  final IsharaColors colors;

  Color _color(_Hue hue) => switch (hue) {
    _Hue.lime => colors.funLime,
    _Hue.lavender => colors.funLavender,
    _Hue.mint => colors.funMint,
  };

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = colors.funTealHero);
    final k = size.width / _artboardWidth;
    for (final s in _shapes[layout]!) {
      final paint = Paint()..color = _color(s.hue);
      final theta = s.rotation * math.pi / 180;
      final half = s.size / 2;
      // Figma rotates around the local origin; find the shape's centre.
      final cx = s.x + half * math.cos(theta) + half * math.sin(theta);
      final cy = s.y - half * math.sin(theta) + half * math.cos(theta);
      canvas.save();
      canvas.translate(cx * k, cy * k);
      canvas.rotate(-theta);
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
      old.layout != layout || old.colors != colors;

  @override
  bool? hitTest(Offset position) => false;
}
