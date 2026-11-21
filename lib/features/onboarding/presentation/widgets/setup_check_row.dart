import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/camera_setup_checks_provider.dart';

/// Figma checklist row (9:531): 20dp icon, body/large label and a status
/// [IsharaChip] (success when the check passes, accent when to adjust).
class SetupCheckRow extends StatelessWidget {
  const SetupCheckRow({super.key, required this.check});

  final CameraSetupCheck check;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MergeSemantics(
      child: Row(
        children: [
          Icon(check.icon, size: IsharaSizes.iconMd, color: c.textPrimary),
          const SizedBox(width: IsharaSpacing.s3),
          Expanded(
            child: Text(
              check.label,
              style: context.textStyles.bodyLarge.copyWith(
                color: c.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: IsharaSpacing.s3),
          Flexible(
            child: IsharaChip(
              label: check.status,
              tone: check.ok ? IsharaChipTone.success : IsharaChipTone.accent,
            ),
          ),
        ],
      ),
    );
  }
}
