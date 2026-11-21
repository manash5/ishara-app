import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'src/shake_on_wrong.dart';

/// Figma `AnswerOption` / `VideoOption` → `state`. (`default` is a Dart
/// keyword, so it is [idle].)
enum AnswerState { idle, selected, correct, wrong }

/// Figma `AnswerOption` (flat): a 60dp text answer. selected = lavender,
/// correct = success + check, wrong = danger + x and one short shake.
class AnswerOption extends StatelessWidget {
  const AnswerOption({
    super.key,
    required this.label,
    required this.onTap,
    this.state = AnswerState.idle,
  });

  final String label;
  final VoidCallback? onTap;
  final AnswerState state;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (fill, border, width, fg) = optionColors(
      c,
      selected: state == AnswerState.selected,
      success: state == AnswerState.correct,
      danger: state == AnswerState.wrong,
    );
    final icon = switch (state) {
      AnswerState.correct => (IsharaIcons.check, c.successDefault),
      AnswerState.wrong => (IsharaIcons.close, c.dangerDefault),
      _ => null,
    };
    final stateText = switch (state) {
      AnswerState.correct => ', correct',
      AnswerState.wrong => ', wrong',
      _ => '',
    };

    return Semantics(
      container: true,
      button: true,
      selected: state == AnswerState.selected,
      inMutuallyExclusiveGroup: true,
      enabled: onTap != null,
      label: '$label$stateText',
      onTap: onTap,
      excludeSemantics: true,
      child: ShakeOnWrong(
        wrong: state == AnswerState.wrong,
        child: PressableScale(
          enabled: onTap != null,
          onPressed: onTap,
          child: AnimatedContainer(
            key: const ValueKey('answer-option-box'),
            duration: IsharaMotion.duration(context, IsharaMotion.fast),
            curve: IsharaMotion.move,
            constraints: const BoxConstraints(
              minHeight: IsharaSizes.answerOptionHeight,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: IsharaSizes.answerPaddingX,
              vertical: IsharaSpacing.s3,
            ),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: IsharaRadius.brLg,
              border: Border.all(color: border, width: width),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: context.textStyles.bodyLarge.copyWith(color: fg),
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: IsharaSpacing.s3),
                  Icon(icon.$1, size: IsharaSizes.answerIcon, color: icon.$2),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
