import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/theme/theme.dart';

part 'camera_setup_checks_provider.g.dart';

/// One row of the "09 Camera setup check" checklist.
@immutable
class CameraSetupCheck {
  const CameraSetupCheck({
    required this.icon,
    required this.label,
    required this.status,
    required this.ok,
  });

  final IconData icon;
  final String label;

  /// Short status shown in the chip, e.g. "Good" or "Move a bit closer".
  final String status;

  /// Passing checks show a success chip, ones to fix an accent chip.
  final bool ok;
}

/// Fake checklist (Figma 9:530) until the live camera + landmarker feed it.
@riverpod
List<CameraSetupCheck> cameraSetupChecks(Ref ref) => const [
  CameraSetupCheck(
    icon: IsharaIcons.sun,
    label: 'Lighting',
    status: 'Good',
    ok: true,
  ),
  CameraSetupCheck(
    icon: IsharaIcons.scan,
    label: 'Distance',
    status: 'Move a bit closer',
    ok: false,
  ),
  CameraSetupCheck(
    icon: IsharaIcons.hand,
    label: 'Hand visible',
    status: 'Detected',
    ok: true,
  ),
];
