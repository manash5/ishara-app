import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';

/// Figma `heading` (54:4364): headline/small title + body/medium subtitle.
class OnboardingHeading extends StatelessWidget {
  const OnboardingHeading({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: s.headlineSmall.copyWith(color: c.textPrimary),
          ),
        ),
        const SizedBox(height: IsharaSpacing.s2),
        Text(subtitle, style: s.bodyMedium.copyWith(color: c.textSecondary)),
      ],
    );
  }
}
