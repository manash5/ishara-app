import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Loading skeleton for a list: [count] muted, radius-lg blocks the height of
/// the real tiles ([itemHeight]), [gap] apart. Announced once as
/// [semanticLabel].
///
/// Shared by Dictionary (SignListTile rows) and Ranks (LeaderboardTile rows).
/// TODO(motion): motion.md asks for a subtle shimmer; not added yet.
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({
    super.key,
    required this.itemHeight,
    required this.semanticLabel,
    this.count = 6,
    this.gap = IsharaSpacing.s2,
  });

  final double itemHeight;
  final String semanticLabel;
  final int count;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Column(
          children: [
            for (var i = 0; i < count; i++) ...[
              if (i > 0) SizedBox(height: gap),
              Container(
                height: itemHeight,
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
