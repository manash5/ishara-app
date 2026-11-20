import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'ishara_chip.dart';

/// Figma `SignListTile`: 72dp muted tile with a lavender thumbnail, title,
/// subtitle, optional status chip (Figma `showStatus`) and a chevron.
///
/// Takes plain strings — core widgets don't import feature entities.
class SignListTile extends StatelessWidget {
  const SignListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.statusLabel,
    this.statusTone = IsharaChipTone.success,
    this.thumbnailIcon = IsharaIcons.hand,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  /// e.g. "Learned". Hidden when null.
  final String? statusLabel;
  final IsharaChipTone statusTone;
  final IconData thumbnailIcon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Semantics(
      container: true,
      button: onTap != null,
      label: [title, subtitle, ?statusLabel].join(', '),
      onTap: onTap,
      excludeSemantics: true,
      child: PressableScale(
        enabled: onTap != null,
        child: Material(
          color: c.bgSurfaceMuted,
          borderRadius: IsharaRadius.brLg,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: IsharaSizes.listTileHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: IsharaSpacing.s3,
                  vertical: IsharaSpacing.s3,
                ),
                child: Row(
                  children: [
                    Container(
                      width: IsharaSizes.signThumb,
                      height: IsharaSizes.signThumb,
                      decoration: BoxDecoration(
                        color: c.funLavenderSubtle,
                        borderRadius: IsharaRadius.brMd,
                      ),
                      child: Icon(
                        thumbnailIcon,
                        size: IsharaSizes.signThumbIcon,
                        color: c.textSecondary,
                      ),
                    ),
                    const SizedBox(width: IsharaSpacing.s3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: s.titleMedium.copyWith(color: c.textPrimary),
                          ),
                          const SizedBox(height: IsharaSizes.titleGap),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: s.bodySmall.copyWith(color: c.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (statusLabel != null) ...[
                      const SizedBox(width: IsharaSpacing.s3),
                      IsharaChip(label: statusLabel!, tone: statusTone),
                    ],
                    const SizedBox(width: IsharaSpacing.s3),
                    Icon(
                      IsharaIcons.chevronRight,
                      size: IsharaSizes.iconMd,
                      color: c.textTertiary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
