import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `Avatar` → `size`.
enum IsharaAvatarSize {
  small(IsharaSizes.avatarSm),
  large(IsharaSizes.avatarLg);

  const IsharaAvatarSize(this.diameter);
  final double diameter;
}

/// Figma `Avatar`: accent/subtle circle with accent/text initials, or a photo.
///
/// Takes an [ImageProvider] rather than a URL so the widget never does I/O
/// itself; a photo that fails to load falls back to the initials.
class IsharaAvatar extends StatelessWidget {
  const IsharaAvatar({
    super.key,
    required this.name,
    this.photo,
    this.size = IsharaAvatarSize.small,
    this.onHero = false,
  });

  final String name;
  final ImageProvider? photo;
  final IsharaAvatarSize size;

  /// On a teal HeroBackdrop (Profile 12:1355): fun/lime fill, fun/teal-hero
  /// initials and a 2dp static/white ring.
  final bool onHero;

  /// "Manash Lama" → "ML", "sujata" → "S", "" → "?".
  static String initialsOf(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    final first = parts.first.characters.first;
    final last = parts.length > 1 ? parts.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final d = size.diameter;
    final initials = Center(
      child: Text(
        initialsOf(name),
        maxLines: 1,
        style: (size == IsharaAvatarSize.small ? s.labelMedium : s.stat)
            .copyWith(color: onHero ? c.funTealHero : c.accentText),
      ),
    );
    return Semantics(
      container: true,
      label: name,
      image: true,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: d,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: onHero ? c.funLime : c.accentSubtle,
            shape: BoxShape.circle,
            border: onHero
                ? Border.all(
                    color: c.staticWhite,
                    width: IsharaSizes.selectedBorder,
                  )
                : null,
          ),
          child: photo == null
              ? initials
              : ClipOval(
                  child: Image(
                    image: photo!,
                    width: d,
                    height: d,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => initials,
                  ),
                ),
        ),
      ),
    );
  }
}
