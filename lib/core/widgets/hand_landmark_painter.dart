import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `HandOverlay/*` → how the 21 MediaPipe hand landmarks are drawn.
enum HandOverlayStyle {
  /// Lime bones, white joints with a teal outline.
  live,

  /// Like [live], with [HandLandmarkPainter.highlighted] joints and their
  /// bones in danger to show which finger to fix.
  hint,

  /// Dotted white target pose at 60% (what to copy), no joints.
  ghost,
}

/// Fingers, for building [HandLandmarkPainter.highlighted] sets.
enum HandFinger {
  thumb({2, 3, 4}),
  indexFinger({6, 7, 8}),
  middle({10, 11, 12}),
  ring({14, 15, 16}),
  pinky({18, 19, 20});

  const HandFinger(this.landmarks);

  /// Landmark indices from the knuckle above the base to the tip.
  final Set<int> landmarks;
}

/// Paints MediaPipe hand landmarks over the camera feed or a sign video.
///
/// [landmarks] are 21 points normalised to 0–1 in the painted box, in
/// MediaPipe order (0 wrist, 1–4 thumb, 5–8 index, 9–12 middle, 13–16 ring,
/// 17–20 pinky). Privacy: landmarks only ever live in memory — this painter
/// draws them and keeps nothing; never log, save or upload them.
///
/// No tweening: landmarks update every frame (motion.md, camera overlay).
class HandLandmarkPainter extends CustomPainter {
  const HandLandmarkPainter({
    required this.landmarks,
    required this.colors,
    this.style = HandOverlayStyle.live,
    this.highlighted = const {},
    this.mirror = false,
  }) : assert(landmarks.length == 21, 'MediaPipe hands have 21 landmarks');

  final List<Offset> landmarks;
  final IsharaColors colors;
  final HandOverlayStyle style;

  /// Landmark indices drawn in danger for [HandOverlayStyle.hint].
  final Set<int> highlighted;

  /// Flip horizontally (front camera preview is mirrored).
  final bool mirror;

  /// MediaPipe `HAND_CONNECTIONS` — the same 21 bones as the Figma overlay.
  static const List<(int, int)> connections = [
    (0, 1), (1, 2), (2, 3), (3, 4), //
    (0, 5), (5, 6), (6, 7), (7, 8), //
    (5, 9), (9, 10), (10, 11), (11, 12), //
    (9, 13), (13, 14), (14, 15), (15, 16), //
    (13, 17), (0, 17), (17, 18), (18, 19), (19, 20),
  ];

  /// Figma artboard the overlay (and its stroke widths) was drawn on.
  static const Size artboard = Size(200, 240);

  /// The open-hand pose from the Figma overlay, normalised to [artboard].
  static const List<Offset> referencePose = [
    Offset(100 / 200, 225 / 240), // 0 wrist
    Offset(70.5 / 200, 205.5 / 240),
    Offset(48.5 / 200, 180.5 / 240),
    Offset(34.5 / 200, 155.5 / 240),
    Offset(24.5 / 200, 132.5 / 240), // 4 thumb tip
    Offset(72.5 / 200, 130.5 / 240),
    Offset(66.5 / 200, 95.5 / 240),
    Offset(62.5 / 200, 70.5 / 240),
    Offset(59.5 / 200, 47.5 / 240), // 8 index tip
    Offset(98.5 / 200, 124.5 / 240),
    Offset(98.5 / 200, 85.5 / 240),
    Offset(98.5 / 200, 58.5 / 240),
    Offset(98.5 / 200, 32.5 / 240), // 12 middle tip
    Offset(124.5 / 200, 130.5 / 240),
    Offset(130.5 / 200, 95.5 / 240),
    Offset(134.5 / 200, 70.5 / 240),
    Offset(137.5 / 200, 48.5 / 240), // 16 ring tip
    Offset(147.5 / 200, 142.5 / 240),
    Offset(158.5 / 200, 115.5 / 240),
    Offset(165.5 / 200, 96.5 / 240),
    Offset(171.5 / 200, 78.5 / 240), // 20 pinky tip
  ];

  /// Ghost dot pattern from Figma (dash 1, gap 9).
  static const double _dash = 1;
  static const double _gap = 9;

  bool _isHint(int i) =>
      style == HandOverlayStyle.hint && highlighted.contains(i);

  @override
  void paint(Canvas canvas, Size size) {
    final k = (size.width / artboard.width).clamp(
      0.0,
      size.height / artboard.height,
    );
    Offset at(int i) {
      final p = landmarks[i];
      return Offset(
        (mirror ? 1 - p.dx : p.dx) * size.width,
        p.dy * size.height,
      );
    }

    if (style == HandOverlayStyle.ghost) {
      final paint = Paint()
        ..color = colors.staticWhite.withValues(alpha: IsharaSizes.ghostOpacity)
        ..strokeWidth = IsharaSizes.landmarkGhostBone * k
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      for (final (a, b) in connections) {
        _dotted(canvas, at(a), at(b), paint, k);
      }
      return;
    }

    for (final (a, b) in connections) {
      canvas.drawLine(
        at(a),
        at(b),
        Paint()
          ..color = _isHint(b) ? colors.dangerDefault : colors.funLime
          ..strokeWidth = IsharaSizes.landmarkBone * k
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );
    }

    final fill = Paint()..color = colors.staticWhite;
    for (var i = 0; i < landmarks.length; i++) {
      final r =
          (i == 0
              ? IsharaSizes.landmarkWristRadius
              : IsharaSizes.landmarkJointRadius) *
          k;
      canvas
        ..drawCircle(at(i), r, fill)
        ..drawCircle(
          at(i),
          r,
          Paint()
            ..color = _isHint(i) ? colors.dangerDefault : colors.funTealHero
            ..strokeWidth = IsharaSizes.landmarkJointStroke * k
            ..style = PaintingStyle.stroke,
        );
    }
  }

  void _dotted(Canvas canvas, Offset a, Offset b, Paint paint, double k) {
    final length = (b - a).distance;
    if (length == 0) return;
    final dir = (b - a) / length;
    final step = (_dash + _gap) * k;
    for (var d = 0.0; d < length; d += step) {
      final end = (d + _dash * k).clamp(0.0, length);
      canvas.drawLine(a + dir * d, a + dir * end, paint);
    }
  }

  @override
  bool shouldRepaint(HandLandmarkPainter old) =>
      !identical(old.landmarks, landmarks) ||
      old.style != style ||
      old.mirror != mirror ||
      old.colors != colors ||
      !setEquals(old.highlighted, highlighted);
}

/// Convenience widget: a non-interactive, decorative landmark layer.
class HandLandmarkOverlay extends StatelessWidget {
  const HandLandmarkOverlay({
    super.key,
    this.landmarks = HandLandmarkPainter.referencePose,
    this.style = HandOverlayStyle.live,
    this.highlighted = const {},
    this.mirror = false,
  });

  final List<Offset> landmarks;
  final HandOverlayStyle style;
  final Set<int> highlighted;
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: CustomPaint(
          size: Size.infinite,
          painter: HandLandmarkPainter(
            landmarks: landmarks,
            colors: context.colors,
            style: style,
            highlighted: highlighted,
            mirror: mirror,
          ),
        ),
      ),
    );
  }
}
