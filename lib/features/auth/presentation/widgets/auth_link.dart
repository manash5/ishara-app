import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';

/// Where an [AuthLink] sits, which decides its colours.
enum AuthLinkTone {
  /// On bg/canvas: optional text/secondary lead + accent/text action.
  canvas,

  /// On a HeroBackdrop: static/white label at reduced opacity
  /// (Figma "02 Welcome" "I already have an account").
  hero,
}

/// Opacity of secondary copy on the teal hero (Figma 54:4358, 54:4363).
const double authHeroMutedOpacity = IsharaSizes.heroCaptionOpacity;

/// Text-only link used across the auth screens: "Forgot password?",
/// "Already have an account? Log in", "New to Ishara? Create account",
/// "I already have an account".
///
/// Figma draws these as bare text (label/large); here they get a 48dp touch
/// target with the text centred in it.
// TODO(figma-gap): no shared text-link component for bg/canvas; see report.
class AuthLink extends StatelessWidget {
  const AuthLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.lead,
    this.tone = AuthLinkTone.canvas,
  });

  /// The tappable action (label/large).
  final String label;
  final VoidCallback onPressed;

  /// Optional lead-in copy before [label] (body/medium, text/secondary).
  final String? lead;
  final AuthLinkTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final actionStyle = switch (tone) {
      AuthLinkTone.canvas => s.labelLarge.copyWith(color: c.accentText),
      AuthLinkTone.hero => s.labelLarge.copyWith(
        color: c.staticWhite.withValues(alpha: authHeroMutedOpacity),
      ),
    };
    final text = Text.rich(
      TextSpan(
        children: [
          if (lead case final lead?) ...[
            TextSpan(
              text: lead,
              style: s.bodyMedium.copyWith(color: c.textSecondary),
            ),
            // Figma `link` row gap: 4.
            const WidgetSpan(child: SizedBox(width: IsharaSpacing.s1)),
          ],
          TextSpan(text: label, style: actionStyle),
        ],
      ),
      textAlign: TextAlign.center,
    );
    return Semantics(
      container: true,
      button: true,
      label: lead == null ? label : '$lead $label',
      onTap: onPressed,
      excludeSemantics: true,
      child: PressableScale(
        onPressed: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: IsharaSizes.minTouch,
            minWidth: IsharaSizes.minTouch,
          ),
          child: Align(widthFactor: 1, heightFactor: 1, child: text),
        ),
      ),
    );
  }
}
