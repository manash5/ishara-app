import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';

/// Figma exercise `prompt` (18–25): label/small eyebrow in accent text, a
/// title/large question and an optional body/medium line.
class ExercisePrompt extends StatelessWidget {
  const ExercisePrompt({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: s.labelSmall.copyWith(color: c.accentText),
        ),
        const SizedBox(height: IsharaSpacing.s1),
        Semantics(
          header: true,
          child: Text(
            title,
            style: s.titleLarge.copyWith(color: c.textPrimary),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: IsharaSpacing.s1),
          Text(subtitle!, style: s.bodyMedium.copyWith(color: c.textSecondary)),
        ],
      ],
    );
  }
}

/// Figma exercise `body`: 12 top, 24 sides, children [gap] apart, scrolling
/// when the text is scaled up.
class ExerciseBody extends StatelessWidget {
  const ExerciseBody({
    super.key,
    required this.children,
    this.gap = IsharaSpacing.s4,
  });

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        IsharaSpacing.screenMargin,
        IsharaSpacing.s3,
        IsharaSpacing.screenMargin,
        IsharaSpacing.s4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
        ],
      ),
    );
  }
}
