import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'answer_option.dart';
import 'sign_video_player.dart';
import 'src/shake_on_wrong.dart';

/// Figma `VideoOption` (flat): a [SignVideoPlayer] tile inside a 4dp-padded
/// option frame. States match [AnswerOption] (wrong also shakes once).
class VideoOption extends StatelessWidget {
  const VideoOption({
    super.key,
    required this.semanticLabel,
    required this.onTap,
    this.video,
    this.state = AnswerState.idle,
  });

  /// e.g. "Option 2". Don't name the sign — that would give the answer away.
  final String semanticLabel;
  final VoidCallback? onTap;
  final Widget? video;
  final AnswerState state;

  @override
  Widget build(BuildContext context) {
    final (fill, border, width, _) = optionColors(
      context.colors,
      selected: state == AnswerState.selected,
      success: state == AnswerState.correct,
      danger: state == AnswerState.wrong,
    );
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
      label: '$semanticLabel$stateText',
      onTap: onTap,
      excludeSemantics: true,
      child: ShakeOnWrong(
        wrong: state == AnswerState.wrong,
        child: PressableScale(
          enabled: onTap != null,
          onPressed: onTap,
          child: AnimatedContainer(
            key: const ValueKey('video-option-box'),
            duration: IsharaMotion.duration(context, IsharaMotion.fast),
            curve: IsharaMotion.move,
            padding: const EdgeInsets.all(IsharaSizes.videoOptionPadding),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: IsharaRadius.brLg,
              border: Border.all(color: border, width: width),
            ),
            child: SignVideoPlayer(
              semanticLabel: semanticLabel,
              video: video,
              size: SignVideoSize.tile,
              borderRadius: IsharaRadius.brMd,
            ),
          ),
        ),
      ),
    );
  }
}
