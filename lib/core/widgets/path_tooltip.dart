import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `PathTooltip` (roadmap kit): a bg/inverse label bubble with a
/// downward arrow, shown above the current [PathNode] (e.g. "Start").
class PathTooltip extends StatelessWidget {
  const PathTooltip({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      container: true,
      label: text,
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: IsharaSizes.tooltipPaddingX,
              vertical: IsharaSpacing.s2,
            ),
            decoration: BoxDecoration(
              color: c.bgInverse,
              borderRadius: IsharaRadius.brMd,
            ),
            child: Text(
              text,
              style: context.textStyles.labelMedium.copyWith(
                color: c.textInverse,
              ),
            ),
          ),
          CustomPaint(
            size: const Size(
              IsharaSizes.tooltipArrowWidth,
              IsharaSizes.tooltipArrowHeight,
            ),
            painter: _ArrowPainter(c.bgInverse),
          ),
        ],
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  const _ArrowPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2, size.height)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_ArrowPainter old) => old.color != color;
}
