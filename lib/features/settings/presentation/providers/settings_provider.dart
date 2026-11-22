import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/app_preferences.dart';
import '../../domain/usecases/get_preferences.dart';
import '../../domain/usecases/save_preferences.dart';

export '../../domain/entities/app_preferences.dart' show ThemePreference;

part 'settings_provider.g.dart';

extension HandLabel on Hand {
  String get label => switch (this) {
    Hand.left => 'Left',
    Hand.right => 'Right',
  };
}

/// Device-only preferences (theme, camera feedback, reminder), saved in the
/// Hive settings box on every change.
@Riverpod(keepAlive: true)
class Preferences extends _$Preferences {
  @override
  AppPreferences build() =>
      GetPreferences(ref.watch(settingsRepositoryProvider))().valueOrNull ??
      const AppPreferences();

  Future<void> setCameraFeedback(bool value) =>
      _save(state.copyWith(cameraFeedback: value));

  /// System → Light → Dark → System.
  Future<void> cycleTheme() => _save(
    state.copyWith(
      theme: ThemePreference
          .values[(state.theme.index + 1) % ThemePreference.values.length],
    ),
  );

  Future<void> setReminder(TimeOfDay time) => _save(
    state.copyWith(reminderHour: time.hour, reminderMinute: time.minute),
  );

  /// Shows the change at once; a failed save only loses it on restart.
  Future<void> _save(AppPreferences next) async {
    state = next;
    await SavePreferences(ref.read(settingsRepositoryProvider))(next);
  }
}

/// The app's theme mode from [Preferences] (for `MaterialApp.themeMode`).
@Riverpod(keepAlive: true)
ThemeMode themeMode(Ref ref) => switch (ref.watch(preferencesProvider).theme) {
  ThemePreference.system => ThemeMode.system,
  ThemePreference.light => ThemeMode.light,
  ThemePreference.dark => ThemeMode.dark,
};

/// The values Figma "17 Settings" shows.
@immutable
class SettingsValues {
  const SettingsValues({
    required this.dailyGoalMinutes,
    required this.dominantHand,
    required this.cameraFeedback,
    required this.theme,
    required this.reminder,
    required this.language,
  });

  /// From the profile (`/me`); null until it has loaded.
  final int? dailyGoalMinutes;
  final Hand? dominantHand;

  /// Show on-device hand-landmark feedback while signing.
  final bool cameraFeedback;
  final ThemePreference theme;
  final TimeOfDay reminder;
  final String language;
}

/// The daily goals Settings cycles through (minutes).
const dailyGoalChoices = [5, 10, 15, 20];

/// The goal after [current] in [dailyGoalChoices] (wrapping round).
int nextDailyGoal(int? current) {
  final i = dailyGoalChoices.indexOf(current ?? dailyGoalChoices.last);
  return dailyGoalChoices[(i + 1) % dailyGoalChoices.length];
}

/// Profile values (daily goal, hand) combined with the device preferences.
@riverpod
SettingsValues settings(Ref ref) {
  final prefs = ref.watch(preferencesProvider);
  final profile = ref.watch(userProfileProvider).value;
  return SettingsValues(
    dailyGoalMinutes: profile?.dailyGoalMinutes,
    dominantHand: profile?.dominantHand,
    cameraFeedback: prefs.cameraFeedback,
    theme: prefs.theme,
    reminder: TimeOfDay(hour: prefs.reminderHour, minute: prefs.reminderMinute),
    language: 'English',
  );
}
