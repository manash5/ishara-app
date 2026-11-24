import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/providers/session_provider.dart';
import '../../../profile/domain/entities/profile_update.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/profile_editor_provider.dart';
import '../providers/settings_provider.dart';

const IconData _themeIcon = IsharaIcons.moon;
const IconData _languageIcon = IsharaIcons.globe;
const IconData _privacyIcon = IsharaIcons.shieldCheck;
const IconData _logOutIcon = IsharaIcons.logOut;
const IconData _deleteIcon = IsharaIcons.trash;

/// Figma "17 Settings" (Light 12:1461 · Dark 60:6948): full-screen over the
/// bottom bar, grouped SettingsTiles, log out, and debug-only tools.
///
/// Daily goal and dominant hand are saved to the profile (`PUT /me`); theme,
/// camera feedback and the reminder stay on the device. Log out ends the
/// session; the router redirect then shows Welcome. Delete account asks
/// first, then deletes the account on the server (`DELETE /me`) and ends the
/// session.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _comingSoon(BuildContext context) =>
      IsharaSnackbar.show(context, message: 'This setting is coming soon.');

  Future<void> _updateProfile(
    BuildContext context,
    WidgetRef ref,
    ProfileUpdate update,
  ) async {
    final failure = await ref
        .read(profileEditorProvider.notifier)
        .update(update);
    if (failure != null && context.mounted) {
      IsharaSnackbar.show(context, message: failure.message);
    }
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete your account?',
      body:
          'This permanently deletes your account, progress and streak from '
          'Ishara. You can’t undo this.',
      confirmLabel: 'Delete account',
      cancelLabel: 'Cancel',
    );
    if (!confirmed) return;
    final failure = await ref
        .read(profileEditorProvider.notifier)
        .deleteAccount();
    // On success the session ends and the redirect shows Welcome.
    if (failure != null && context.mounted) {
      IsharaSnackbar.show(context, message: failure.message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final s = context.textStyles;
    final values = ref.watch(settingsProvider);
    final prefs = ref.read(preferencesProvider.notifier);
    final session = ref.read(sessionProvider.notifier);
    final saving = ref.watch(profileEditorProvider);
    final hand = values.dominantHand;

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
                  value: switch (values.dailyGoalMinutes) {
                    final minutes? => '$minutes min',
                    null => '—',
                  },
                  onTap: saving || values.dailyGoalMinutes == null
                      ? null
                      : () => _updateProfile(
                          context,
                          ref,
                          ProfileUpdate(
                            dailyGoalMinutes: nextDailyGoal(
                              values.dailyGoalMinutes,
                            ),
                          ),
                        ),
                ),
                SettingsTile(
                  icon: IsharaIcons.hand,
                  label: 'Dominant hand',
                  trailing: SettingsTrailing.value,
                  value: hand?.label ?? '—',
                  onTap: saving || hand == null
                      ? null
                      : () => _updateProfile(
                          context,
                          ref,
                          ProfileUpdate(
                            dominantHand: hand == Hand.right
                                ? Hand.left
                                : Hand.right,
                          ),
                        ),
                ),
                SettingsTile(
                  icon: IsharaIcons.camera,
                  label: 'Camera feedback',
                  trailing: SettingsTrailing.toggle,
                  switchValue: values.cameraFeedback,
                  onSwitchChanged: prefs.setCameraFeedback,
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
                  onTap: prefs.cycleTheme,
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
                SettingsTile(
                  key: const Key('settings-delete-account'),
                  icon: _deleteIcon,
                  label: 'Delete account',
                  destructive: true,
                  onTap: saving ? null : () => _deleteAccount(context, ref),
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
                    onTap: () => session.debugOverride(onboardingDone: false),
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
