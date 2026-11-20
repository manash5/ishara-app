import 'package:material_ui/material_ui.dart';

import 'ishara_colors.dart';
import 'ishara_text_styles.dart';

/// Shorthand access to the Ishara theme extensions.
extension IsharaThemeX on BuildContext {
  /// Semantic colour tokens for the current brightness.
  IsharaColors get colors {
    final colors = Theme.of(this).extension<IsharaColors>();
    assert(colors != null, 'IsharaColors missing: use AppTheme.light/dark.');
    return colors!;
  }

  /// Figma text styles (including `stat` and `glyph`).
  IsharaTextStyles get textStyles {
    final styles = Theme.of(this).extension<IsharaTextStyles>();
    assert(
      styles != null,
      'IsharaTextStyles missing: use AppTheme.light/dark.',
    );
    return styles!;
  }
}
