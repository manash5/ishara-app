import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/dictionary_models.dart';

/// Figma "13 Dictionary" `filters` row (12:845): "All" plus one chip per
/// category; the selected chip is accent, the rest neutral.

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final SignCategory? selected;
  final ValueChanged<SignCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final options = <(String, SignCategory?)>[
      ('All', null),
      for (final c in SignCategory.values) (c.label, c),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: IsharaSpacing.inlineGap),
            IsharaChip.filter(
              label: options[i].$1,
              selected: options[i].$2 == selected,
              onTap: () => onSelected(options[i].$2),
            ),
          ],
        ],
      ),
    );
  }
}
