import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Empty / no-results / error message for dictionary lists.
///
/// TODO(widgets): Figma has no empty/error state for frames 13–14; a shared
/// state-message component is requested (see report).
class DictionaryStateMessage extends StatelessWidget {
  const DictionaryStateMessage({
    super.key,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: IsharaSpacing.s8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: s.titleMedium.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: IsharaSpacing.stackGap),
            Text(
              body,
              textAlign: TextAlign.center,
              style: s.bodyMedium.copyWith(color: c.textSecondary),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: IsharaSpacing.s4),
              IsharaButton(
                label: actionLabel!,
                variant: IsharaButtonVariant.outlined,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading skeleton: muted blocks the shape of [SignListTile]s.
///
/// TODO(motion): motion.md asks for a subtle shimmer; no shared skeleton
/// widget exists yet (see report).
class SignListSkeleton extends StatelessWidget {
  const SignListSkeleton({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading signs',
      child: ExcludeSemantics(
        child: Column(
          children: [
            for (var i = 0; i < count; i++) ...[
              if (i > 0) const SizedBox(height: IsharaSpacing.s2),
              Container(
                height: IsharaSizes.listTileHeight,
                decoration: BoxDecoration(
                  color: context.colors.bgSurfaceMuted,
                  borderRadius: IsharaRadius.brLg,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
