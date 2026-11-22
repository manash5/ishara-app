import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/widgets.dart';

/// The large sign video in an exercise (18, 19) with working slow-motion
/// and mirror toggles. The real video plugin is injected later.
class LessonSignVideo extends StatefulWidget {
  const LessonSignVideo({super.key, required this.semanticLabel});

  /// Never names the sign when the exercise asks what it means.
  final String semanticLabel;

  @override
  State<LessonSignVideo> createState() => _LessonSignVideoState();
}

class _LessonSignVideoState extends State<LessonSignVideo> {
  bool _slowMotion = false;
  bool _mirrored = false;

  @override
  Widget build(BuildContext context) {
    return SignVideoPlayer(
      semanticLabel: widget.semanticLabel,
      slowMotion: _slowMotion,
      mirrored: _mirrored,
      // Replay restarts the injected video; the placeholder has nothing to do.
      onReplay: () {},
      onToggleSlowMotion: () => setState(() => _slowMotion = !_slowMotion),
      onToggleMirror: () => setState(() => _mirrored = !_mirrored),
    );
  }
}
