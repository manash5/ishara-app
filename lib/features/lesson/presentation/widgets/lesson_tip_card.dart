import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';

/// Figma 18 `tip`: bg/surface card with a hairline border/subtle, a 20dp
/// accent lightbulb and body/small text.
class LessonTipCard extends StatelessWidget {
  const LessonTipCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(IsharaSpacing.cardPadding),
      decoration: BoxDecoration(
        color: c.bgSurface,
        borderRadius: IsharaRadius.brLg,
        border: Border.all(color: c.borderSubtle),
      ),
      child: Row(
        children: [
          Icon(
            IsharaIcons.lightbulb,
            size: IsharaSizes.tipIcon,
            // Figma: teal in Light, lime in Dark.
            color: c.accentText,
          ),
          const SizedBox(width: IsharaSpacing.s3),
          Expanded(
            child: Text(
              text,
              style: context.textStyles.bodySmall.copyWith(
                color: c.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
