import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Shown instead of unverified sign text (CLAUDE.md content rule).
const signTextPendingVerification =
    'Description pending verification against the NDFN NSL dictionary.';

/// Shown instead of unverified step-by-step instructions.
const signStepsPendingVerification =
    'Step-by-step instructions pending verification against the NDFN NSL '
    'dictionary.';

// TODO(tokens): Figma's 24dp step-number circle has no IsharaSizes token.
const double _stepBadge = 24;

/// The large [SignVideoPlayer] with its own slow-mo / mirror toggle state.
class SignVideoSection extends StatefulWidget {
  const SignVideoSection({super.key, required this.signName});

  final String signName;

  @override
  State<SignVideoSection> createState() => _SignVideoSectionState();
}

class _SignVideoSectionState extends State<SignVideoSection> {
  bool _mirrored = false;
  bool _slowMotion = false;

  @override
  Widget build(BuildContext context) {
    return SignVideoPlayer(
      semanticLabel: 'Sign video: ${widget.signName}',
      mirrored: _mirrored,
      slowMotion: _slowMotion,
      // Replay restarts the injected video; the placeholder has nothing to do.
      onReplay: () {},
      onToggleSlowMotion: () => setState(() => _slowMotion = !_slowMotion),
      onToggleMirror: () => setState(() => _mirrored = !_mirrored),
    );
  }
}

/// Figma `meaning` (12:1162): headline + status chip, then the description.
class SignMeaningSection extends StatelessWidget {
  const SignMeaningSection({
    super.key,
    required this.name,
    required this.statusLabel,
    required this.statusTone,
    required this.meaning,
  });

  final String name;
  final String statusLabel;
  final IsharaChipTone statusTone;
  final String? meaning;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: IsharaSpacing.s2,
          runSpacing: IsharaSpacing.s1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Semantics(
              header: true,
              child: Text(
                name,
                style: s.headlineSmall.copyWith(color: c.textPrimary),
              ),
            ),
            IsharaChip(label: statusLabel, tone: statusTone),
          ],
        ),
        const SizedBox(height: IsharaSpacing.s2),
        Text(
          meaning ?? signTextPendingVerification,
          style: s.bodyMedium.copyWith(color: c.textSecondary),
        ),
      ],
    );
  }
}

/// Figma `howTo` (12:1170): "How to sign" + numbered steps.
class SignHowToSection extends StatelessWidget {
  const SignHowToSection({super.key, required this.steps});

  final List<String> steps;

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
            'How to sign',
            style: s.titleMedium.copyWith(color: c.textPrimary),
          ),
        ),
        const SizedBox(height: IsharaSpacing.s3),
        if (steps.isEmpty)
          Text(
            signStepsPendingVerification,
            style: s.bodyMedium.copyWith(color: c.textSecondary),
          ),
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0) const SizedBox(height: IsharaSpacing.s3),
          Semantics(
            label: 'Step ${i + 1}: ${steps[i]}',
            excludeSemantics: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: _stepBadge,
                  height: _stepBadge,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c.bgSurfaceMuted,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: s.labelMedium.copyWith(color: c.textSecondary),
                  ),
                ),
                const SizedBox(width: IsharaSpacing.s3),
                Expanded(
                  child: Text(
                    steps[i],
                    style: s.bodyMedium.copyWith(color: c.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Figma `etiquetteTip` (12:1184): accent/subtle card with a lightbulb.
class EtiquetteTipCard extends StatelessWidget {
  const EtiquetteTipCard({super.key, required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Semantics(
      container: true,
      label: 'Etiquette. $tip',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(IsharaSpacing.cardPadding),
        decoration: BoxDecoration(
          color: c.accentSubtle,
          borderRadius: IsharaRadius.brLg,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              IsharaIcons.lightbulb,
              size: IsharaSizes.iconMd,
              color: c.accentText,
            ),
            const SizedBox(width: IsharaSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Etiquette',
                    style: s.labelLarge.copyWith(color: c.accentText),
                  ),
                  const SizedBox(height: IsharaSizes.titleGap),
                  Text(tip, style: s.bodySmall.copyWith(color: c.accentText)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
