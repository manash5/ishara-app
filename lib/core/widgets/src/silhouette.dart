import 'package:material_ui/material_ui.dart';

/// Internal: the placeholder "person" from Figma's SignVideoPlayer and
/// CameraFeed frames — a head circle over rounded shoulders — used until the
/// real video / camera preview is plugged in.
///
/// [head] and [body] are rects on an artboard of [artboardWidth]; the
/// painter scales them uniformly to the painted width.
class SilhouettePainter extends CustomPainter {
  const SilhouettePainter({
    required this.color,
    required this.head,
    required this.body,
    required this.artboardWidth,
  });

  final Color color;
  final Rect head;
  final Rect body;
  final double artboardWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / artboardWidth;
    final paint = Paint()..color = color;
    final h = Rect.fromLTWH(
      head.left * k,
      head.top * k,
      head.width * k,
      head.height * k,
    );
    final b = Rect.fromLTWH(
      body.left * k,
      body.top * k,
      body.width * k,
      body.height * k,
    );
    canvas
      ..drawOval(h, paint)
      ..drawRRect(
        RRect.fromRectAndCorners(
          b,
          topLeft: Radius.circular(b.height),
          topRight: Radius.circular(b.height),
        ),
        paint,
      );
  }

  @override
  bool shouldRepaint(SilhouettePainter old) =>
      old.color != color || old.head != head || old.body != body;
}
