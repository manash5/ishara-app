import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'src/shake_on_wrong.dart';

/// Figma `MatchTile` → `state`. (`default` is a Dart keyword → [idle].)
enum MatchTileState { idle, selected, matched, wrong }

/// Figma `MatchTile` (flat): a 64dp tile in the match-pairs exercise.
/// matched = success at 45% opacity (and no longer tappable); wrong = danger
/// with one short shake.
class MatchTile extends StatelessWidget {
  const MatchTile({
    super.key,
    required this.label,
    required this.onTap,
    this.state = MatchTileState.idle,
  });

  final String label;
  final VoidCallback? onTap;
  final MatchTileState state;

  @override
  Widget build(BuildContext context) {
    final (fill, border, width, fg) = optionColors(
      context.colors,
      selected: state == MatchTileState.selected,
      success: state == MatchTileState.matched,
      danger: state == MatchTileState.wrong,
    );
    final matched = state == MatchTileState.matched;
    final tap = matched ? null : onTap;
    final duration = IsharaMotion.duration(context, IsharaMotion.fast);
    return Semantics(
      container: true,
      button: true,
      selected: state == MatchTileState.selected,
      enabled: tap != null,
      label: switch (state) {
        MatchTileState.matched => '$label, matched',
        MatchTileState.wrong => '$label, not a match',
        _ => label,
      },
      onTap: tap,
      excludeSemantics: true,
      child: ShakeOnWrong(
        wrong: state == MatchTileState.wrong,
        child: AnimatedOpacity(
          duration: duration,
          opacity: matched ? IsharaSizes.matchedOpacity : 1,
          child: PressableScale(
            enabled: tap != null,
            onPressed: tap,
            child: AnimatedContainer(
              key: const ValueKey('match-tile-box'),
              duration: duration,
              curve: IsharaMotion.move,
              constraints: const BoxConstraints(
                minHeight: IsharaSizes.compactTileHeight,
              ),
              padding: const EdgeInsets.all(IsharaSpacing.s2),
              decoration: BoxDecoration(
                color: fill,
                borderRadius: IsharaRadius.brLg,
                border: Border.all(color: border, width: width),
              ),
              // heightFactor 1: centre without growing past 64 when the
              // parent's height is loose (a Container alignment would fill it).
              child: Align(
                heightFactor: 1,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: context.textStyles.titleMedium.copyWith(color: fg),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
