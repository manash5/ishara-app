import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';

/// Figma 25 `letter/*` frame names.
enum LetterTileState { done, current, todo }

/// Figma 25 letter tile: 72×84, radius lg, a Devanagari glyph.
/// done = surface + border, success glyph; current = accent fill, on-accent
/// glyph; todo = surface + border, tertiary glyph.
class FingerspellLetterTile extends StatelessWidget {
  const FingerspellLetterTile({
    super.key,
    required this.letter,
    required this.state,
  });

  final String letter;
  final LetterTileState state;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (fill, border, fg) = switch (state) {
      LetterTileState.done => (c.bgSurface, c.borderDefault, c.successDefault),
      LetterTileState.current => (c.accentDefault, null, c.textOnAccent),
      LetterTileState.todo => (c.bgSurface, c.borderDefault, c.textTertiary),
    };
    final status = switch (state) {
      LetterTileState.done => 'done',
      LetterTileState.current => 'current',
      LetterTileState.todo => 'to do',
    };
    return Semantics(
      container: true,
      label: 'Letter $letter, $status',
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: IsharaMotion.duration(context, IsharaMotion.fast),
        curve: IsharaMotion.move,
        width: IsharaSizes.letterTileWidth,
        height: IsharaSizes.letterTileHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: IsharaRadius.brLg,
          border: border == null ? null : Border.all(color: border),
        ),
        child: Text(
          letter,
          textScaler: TextScaler.noScaling,
          style: context.textStyles.glyph.copyWith(
            fontSize: IsharaSizes.letterTileGlyph,
            height:
                IsharaSizes.letterTileGlyphLine / IsharaSizes.letterTileGlyph,
            color: fg,
          ),
        ),
      ),
    );
  }
}
