import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

const IconData _settingsIcon = IsharaIcons.settings;

const double _captionOpacity = IsharaSizes.heroCaptionOpacity;

const List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// "Nov 2026".
String monthYear(DateTime d) => '${_months[d.month - 1]} ${d.year}';

/// Figma "16 Profile" header: HeroBackdrop with the settings button and the
/// learner's identity (avatar, name, join date). Its bottom
/// [IsharaRadius.sheet] is covered by the overlapping ContentPanel.
class ProfileHero extends StatelessWidget {
  const ProfileHero({
    super.key,
    required this.name,
    required this.joined,
    required this.onSettings,
  });

  final String name;
  final DateTime joined;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return HeroBackdrop(
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: IsharaSpacing.s2,
                right: IsharaSpacing.s3,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: IsharaIconButton(
                  icon: _settingsIcon,
                  tooltip: 'Settings',
                  color: c.staticWhite,
                  onPressed: onSettings,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                IsharaSpacing.screenMargin,
                0,
                IsharaSpacing.screenMargin,
                IsharaSpacing.s10 + IsharaRadius.sheet,
              ),
              child: Column(
                children: [
                  IsharaAvatar(
                    name: name,
                    size: IsharaAvatarSize.large,
                    onHero: true,
                  ),
                  const SizedBox(height: IsharaSpacing.stackGap),
                  Semantics(
                    header: true,
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: s.titleLarge.copyWith(color: c.staticWhite),
                    ),
                  ),
                  const SizedBox(height: IsharaSpacing.stackGap),
                  Text(
                    'Learning NSL since ${monthYear(joined)}',
                    textAlign: TextAlign.center,
                    style: s.bodySmall.copyWith(
                      color: c.staticWhite.withValues(alpha: _captionOpacity),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
