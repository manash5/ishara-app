import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `ContentPanel` (v4 minimal kit): the bg/surface panel with 28dp top
/// corners that sits over a [HeroBackdrop]. 24dp padding, 16dp gap.
class ContentPanel extends StatelessWidget {
  const ContentPanel({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(IsharaSpacing.screenMargin),
  });

  final List<Widget> children;

  /// Figma default 24; some screens use a smaller bottom (e.g. 55:3729 → 16).
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
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
