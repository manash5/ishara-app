import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `SpeechBubble`: Danu's prompt bubble on the roadmap — bg/surface,
/// 2px border/default with a 4px bottom lip, and a tail on the left.
class SpeechBubble extends StatelessWidget {
  const SpeechBubble({super.key, required this.text});

  final String text;

  /// The tail overlaps the bubble's left border by this much (Figma gap −2).
  static const double _overlap = IsharaSizes.selectedBorder;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    const border = IsharaSizes.selectedBorder;
    final innerRadius = BorderRadius.circular(IsharaRadius.lg - border);
    return Semantics(
      container: true,
      label: text,
      excludeSemantics: true,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: IsharaSizes.bubbleTailWidth - _overlap,
            ),
            // Outer box = border colour; non-uniform widths (2 / 4 bottom lip)
            // with rounded corners are drawn as two nested boxes.
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.borderDefault,
                borderRadius: IsharaRadius.brLg,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  border,
                  border,
                  border,
                  IsharaSizes.bubbleLip,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.bgSurface,
                    borderRadius: innerRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      IsharaSpacing.cardPadding - border,
                    ),
                    child: Text(
                      text,
                      style: s.bodyLarge.copyWith(color: c.textPrimary),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: CustomPaint(
                size: const Size(
                  IsharaSizes.bubbleTailWidth,
                  IsharaSizes.bubbleTailHeight,
                ),
                painter: _TailPainter(
                  fill: c.bgSurface,
                  stroke: c.borderDefault,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TailPainter extends CustomPainter {
  const _TailPainter({required this.fill, required this.stroke});

  final Color fill;
  final Color stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final tip = Offset(0, size.height / 2);
    final top = Offset(size.width, 0);
    final bottom = Offset(size.width, size.height);
    final body = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..close();
    canvas.drawPath(body, Paint()..color = fill);
    final edges = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(bottom.dx, bottom.dy);
    canvas.drawPath(
      edges,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = IsharaSizes.selectedBorder
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_TailPainter old) =>
      old.fill != fill || old.stroke != stroke;
}
