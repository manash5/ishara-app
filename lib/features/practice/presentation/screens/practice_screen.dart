import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/router/screen_placeholder.dart';

/// Figma " Practice" — placeholder until the real screen is built.
///
/// No Figma frame: the bottom bar's centre camera action (free practice).
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '',
      name: 'Practice',
      leading: IsharaAppBarLeading.close,
      actions: [
        PlaceholderAction(
          'Done',
          () => Navigator.of(context).pop(),
          primary: true,
        ),
      ],
    );
  }
}
