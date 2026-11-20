import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'ishara_avatar.dart';

/// Figma `LeaderboardTile` (`variant` default | me).
///
/// `me` = accent/subtle fill and accent/text for rank, name and XP.
class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile({
    super.key,
    required this.rank,
    required this.name,
    required this.xp,
    this.isMe = false,
    this.photo,
  });

  final int rank;
  final String name;
  final int xp;
  final bool isMe;
  final ImageProvider? photo;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final fg = isMe ? c.accentText : c.textPrimary;
    final rankColor = isMe ? c.accentText : c.textSecondary;
    return Semantics(
      container: true,
      label: 'Rank $rank, ${isMe ? 'you, ' : ''}$name, $xp XP',
      excludeSemantics: true,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: IsharaSizes.compactTileHeight,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: IsharaSpacing.s4,
          vertical: IsharaSpacing.s3,
        ),
        decoration: BoxDecoration(
          color: isMe ? c.accentSubtle : null,
          borderRadius: IsharaRadius.brLg,
        ),
        child: Row(
          children: [
            SizedBox(
              width: IsharaSpacing.s6,
              child: Text(
                '$rank',
                textAlign: TextAlign.center,
                style: s.titleMedium.copyWith(color: rankColor),
              ),
            ),
            const SizedBox(width: IsharaSpacing.s3),
            IsharaAvatar(name: name, photo: photo),
            const SizedBox(width: IsharaSpacing.s3),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: s.titleMedium.copyWith(color: fg),
              ),
            ),
            const SizedBox(width: IsharaSpacing.s3),
            IsharaFilledIcon(
              IsharaFilledIconKind.zap,
              size: IsharaSizes.iconSm,
              color: c.accentDefault,
            ),
            const SizedBox(width: IsharaSpacing.s1),
            Text('$xp', style: s.titleMedium.copyWith(color: fg)),
          ],
        ),
      ),
    );
  }
}
