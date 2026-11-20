import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `TextLinkCTA` (v4 minimal kit): white title/medium label with a 3px
/// fun/lime underline, used on [HeroBackdrop]s.
class TextLinkCTA extends StatelessWidget {
  const TextLinkCTA({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      container: true,
      button: true,
      enabled: onPressed != null,
      label: label,
      onTap: onPressed,
      excludeSemantics: true,
      child: PressableScale(
        enabled: onPressed != null,
        onPressed: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: IsharaSizes.minTouch),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: IsharaSpacing.s2),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: context.textStyles.titleMedium.copyWith(
                      color: c.staticWhite,
                    ),
                  ),
                  const SizedBox(height: IsharaSizes.ctaUnderlineGap),
                  Container(
                    height: IsharaSizes.underline,
                    decoration: BoxDecoration(
                      color: c.funLime,
                      borderRadius: IsharaRadius.brFull,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
