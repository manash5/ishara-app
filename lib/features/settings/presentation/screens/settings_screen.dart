import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/providers/fake_session_provider.dart';
import '../providers/settings_provider.dart';

const IconData _themeIcon = IsharaIcons.moon;
const IconData _languageIcon = IsharaIcons.globe;
const IconData _privacyIcon = IsharaIcons.shieldCheck;
const IconData _logOutIcon = IsharaIcons.logOut;

/// Figma "17 Settings" (Light 12:1461 · Dark 60:6948): full-screen over the
/// bottom bar, grouped SettingsTiles, log out, and debug-only tools.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _comingSoon(BuildContext context) =>
      IsharaSnackbar.show(context, message: 'This setting is coming soon.');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final s = context.textStyles;
    final values = ref.watch(settingsProvider);
    final settings = ref.read(settingsProvider.notifier);
    final session = ref.read(fakeSessionProvider.notifier);

    return Scaffold(
      backgroundColor: c.bgCanvas,
      appBar: IsharaTopAppBar(
        title: 'Settings',
        onLeading: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            IsharaSpacing.screenMargin,
            IsharaSpacing.s2,
            IsharaSpacing.screenMargin,
            IsharaSpacing.s4,
          ),
          children: [
            SettingsGroup(
              title: 'Learning',
              tiles: [
                SettingsTile(
                  icon: IsharaIcons.target,
                  label: 'Daily goal',
                  trailing: SettingsTrailing.value,
                  value: '${values.dailyGoalMinutes} min',
                  onTap: () => _comingSoon(context),
                ),
                SettingsTile(
                  icon: IsharaIcons.hand,
                  label: 'Dominant hand',
                  trailing: SettingsTrailing.value,
                  value: values.dominantHand.label,
                  onTap: settings.toggleDominantHand,
                ),
                SettingsTile(
                  icon: IsharaIcons.camera,
                  label: 'Camera feedback',
                  trailing: SettingsTrailing.toggle,
                  switchValue: values.cameraFeedback,
                  onSwitchChanged: settings.setCameraFeedback,
                ),
              ],
            ),
            const SizedBox(height: IsharaSpacing.s6),
            SettingsGroup(
              title: 'App',
              tiles: [
                SettingsTile(
                  icon: _themeIcon,
                  label: 'Theme',
                  trailing: SettingsTrailing.value,
                  value: values.theme.label,
                  onTap: settings.cycleTheme,
                ),
                SettingsTile(
                  icon: IsharaIcons.bell,
                  label: 'Daily reminder',
                  trailing: SettingsTrailing.value,
                  value: values.reminder.format(context),
                  onTap: () => _comingSoon(context),
                ),
                SettingsTile(
                  icon: _languageIcon,
                  label: 'Language',
                  trailing: SettingsTrailing.value,
                  value: values.language,
                  onTap: () => _comingSoon(context),
                ),
              ],
            ),
            const SizedBox(height: IsharaSpacing.s6),
            SettingsGroup(
              title: 'Account',
              tiles: [
                SettingsTile(
                  icon: _privacyIcon,
                  label: 'Privacy & data',
                  onTap: () => _comingSoon(context),
                ),
                SettingsTile(
                  icon: _logOutIcon,
                  label: 'Log out',
                  destructive: true,
                  onTap: session.logOut,
                ),
              ],
            ),
            const SizedBox(height: IsharaSpacing.s6),
            Text(
              'Ishara v1.0 · Thesis prototype',
              textAlign: TextAlign.center,
              style: s.bodySmall.copyWith(color: c.textTertiary),
            ),
            // Debug-only tools, kept apart from the Figma content.
            if (kDebugMode) ...[
              const SizedBox(height: IsharaSpacing.s6),
              SettingsGroup(
                title: 'Debug',
                tiles: [
                  SettingsTile(
                    icon: IsharaIcons.rotateCcw,
                    label: 'Redo onboarding',
                    onTap: () => session.setOnboardingDone(false),
                  ),
                  SettingsTile(
                    icon: IsharaIcons.lightbulb,
                    label: 'Widget gallery',
                    onTap: () => const GalleryRoute().push<void>(context),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
