import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';

/// Figma `framingGuide` (9:519): a dashed 2dp white rounded rectangle that
/// shows where to place the upper body on "09 Camera setup check".
///
/// Positioned on the same 412-wide artboard as the `CameraFeed` placeholder
/// art and scaled to the available width. Purely decorative.
class FramingGuide extends StatelessWidget {
  const FramingGuide({super.key});

  // Figma geometry on the 412×560 CameraFeed artboard.
  static const double _artboardWidth = 412;
  static const Rect _frame = Rect.fromLTWH(56, 96, 300, 400);

  @override
  Widget build(BuildContext context) {
    final color = context.colors.staticWhite;
    return ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final k = constraints.maxWidth / _artboardWidth;
          return Stack(
            children: [
              Positioned(
                left: _frame.left * k,
                top: _frame.top * k,
                width: _frame.width * k,
                height: _frame.height * k,
                child: CustomPaint(painter: DashedFramePainter(color: color)),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Paints a dashed rounded-rect outline (radius sheet, 2dp stroke).
@visibleForTesting
class DashedFramePainter extends CustomPainter {
  const DashedFramePainter({required this.color});

  final Color color;

  // TODO(ui): Figma `border-dashed` has no dash tokens; these match the frame.
  static const double dash = 8;
  static const double gap = 6;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = IsharaSizes.selectedBorder;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect,
          const Radius.circular(IsharaRadius.sheet),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dash), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(DashedFramePainter old) => old.color != color;
}
