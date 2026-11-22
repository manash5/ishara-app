import 'package:material_ui/material_ui.dart';

import 'sign_video_player.dart';

/// A large [SignVideoPlayer] that keeps its own slow-motion and mirror
/// state, so screens don't each re-implement the toggles (Dictionary sign
/// detail 14, lesson exercises 18–19).
///
/// The real video plugin is injected as [video] later.
class SignVideo extends StatefulWidget {
  const SignVideo({super.key, required this.semanticLabel, this.video});

  /// e.g. "Sign video: Namaste". In recognise exercises use a label that
  /// doesn't name the sign, so it doesn't give the answer away.
  final String semanticLabel;
  final Widget? video;

  @override
  State<SignVideo> createState() => _SignVideoState();
}

class _SignVideoState extends State<SignVideo> {
  bool _slowMotion = false;
  bool _mirrored = false;

  @override
  Widget build(BuildContext context) {
    return SignVideoPlayer(
      semanticLabel: widget.semanticLabel,
      video: widget.video,
      slowMotion: _slowMotion,
      mirrored: _mirrored,
      // Replay restarts the injected video; the placeholder has nothing to do.
      onReplay: () {},
      onToggleSlowMotion: () => setState(() => _slowMotion = !_slowMotion),
      onToggleMirror: () => setState(() => _mirrored = !_mirrored),
    );
  }
}
