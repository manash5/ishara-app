import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

enum DominantHand {
  left('Left'),
  right('Right');

  const DominantHand(this.label);
  final String label;
}

enum ThemePreference {
  system('System'),
  light('Light'),
  dark('Dark');

  const ThemePreference(this.label);
  final String label;
}

/// The values Figma "17 Settings" shows (UI-only phase).
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

  final int dailyGoalMinutes;
  final DominantHand dominantHand;

  /// Show on-device hand-landmark feedback while signing.
  final bool cameraFeedback;
  final ThemePreference theme;
  final TimeOfDay reminder;
  final String language;

  SettingsValues copyWith({
    DominantHand? dominantHand,
    bool? cameraFeedback,
    ThemePreference? theme,
  }) => SettingsValues(
    dailyGoalMinutes: dailyGoalMinutes,
    dominantHand: dominantHand ?? this.dominantHand,
    cameraFeedback: cameraFeedback ?? this.cameraFeedback,
    theme: theme ?? this.theme,
    reminder: reminder,
    language: language,
  );
}

/// In-memory settings with the Figma defaults; a repository-backed notifier
/// (Hive + `/me`) replaces it when the data layer lands.
@riverpod
class Settings extends _$Settings {
  @override
  SettingsValues build() => const SettingsValues(
    dailyGoalMinutes: 10,
    dominantHand: DominantHand.right,
    cameraFeedback: true,
    theme: ThemePreference.system,
    reminder: TimeOfDay(hour: 19, minute: 0),
    language: 'English',
  );

  void setCameraFeedback(bool value) =>
      state = state.copyWith(cameraFeedback: value);

  void toggleDominantHand() => state = state.copyWith(
    dominantHand: state.dominantHand == DominantHand.right
        ? DominantHand.left
        : DominantHand.right,
  );

  /// System → Light → Dark → System.
  void cycleTheme() => state = state.copyWith(
    theme: ThemePreference
        .values[(state.theme.index + 1) % ThemePreference.values.length],
  );
}
