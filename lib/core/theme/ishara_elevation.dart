import 'package:material_ui/material_ui.dart';

/// Shadows — Figma effect styles `elevation/1` and `elevation/2`.
///
/// Use sparingly: level1 for controls on media, level2 for sheets, dialogs and
/// the current path node. Prefer hairline `borderSubtle` borders over shadows.
abstract final class IsharaElevation {
  /// Shadow base colour (#1A140F) shared by both effect styles.
  static const Color shadowColor = Color(0xFF1A140F);

  static const List<BoxShadow> level1 = [
    BoxShadow(color: Color(0x0D1A140F), offset: Offset(0, 2), blurRadius: 8),
  ];

  static const List<BoxShadow> level2 = [
    BoxShadow(color: Color(0x1A1A140F), offset: Offset(0, 8), blurRadius: 24),
  ];
}
