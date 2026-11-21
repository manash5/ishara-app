import 'package:material_ui/material_ui.dart';

import '../../../../core/router/screen_placeholder.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'learn_lesson_sheet.dart';
import 'learn_offline_view.dart';

/// Figma "10 Learn" — placeholder. Frame 11 is a modal sheet opened from here
/// and frame 12 is this screen's offline state (toggle below).
class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  bool _offline = false;

  void _setOffline(bool value) => setState(() => _offline = value);

  @override
  Widget build(BuildContext context) {
    if (_offline) return LearnOfflineView(onRetry: () => _setOffline(false));
    return ScreenPlaceholder(
      frame: '10',
      name: 'Learn',
      inShell: true,
      extras: [
        SettingsTile(
          icon: IsharaIcons.wifiOff,
          label: 'Show offline state (12)',
          trailing: SettingsTrailing.toggle,
          switchValue: _offline,
          onSwitchChanged: _setOffline,
        ),
      ],
      actions: [
        PlaceholderAction(
          'Open lesson (11)',
          () => showLearnLessonSheet(context),
          primary: true,
        ),
      ],
    );
  }
}
