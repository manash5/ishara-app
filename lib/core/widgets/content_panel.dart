import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `ContentPanel` (v4 minimal kit): the bg/surface panel with 28dp top
/// corners that sits over a [HeroBackdrop]. 24dp padding, 16dp gap.
class ContentPanel extends StatelessWidget {
  const ContentPanel({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(IsharaSpacing.screenMargin),
      decoration: BoxDecoration(
        color: context.colors.bgSurface,
        borderRadius: IsharaRadius.sheetTop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: IsharaSpacing.s4),
            children[i],
          ],
        ],
      ),
    );
  }
}
