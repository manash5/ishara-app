import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/out_of_hearts_sheet.dart';

/// Figma "28 Out of hearts" as a full-screen route (`/out-of-hearts`, e.g.
/// a deep link). In a lesson the same panel opens as a sheet over the
/// player instead (`showOutOfHeartsSheet`).
class OutOfHeartsScreen extends StatelessWidget {
  const OutOfHeartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgCanvas,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: OutOfHeartsPanel(
            onPractise: () => const PracticeRoute().go(context),
            onEndLesson: () => const LearnRoute().go(context),
          ),
        ),
      ),
    );
  }
}
