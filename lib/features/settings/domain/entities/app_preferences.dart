/// Light / dark / follow the system.
enum ThemePreference {
  system('System'),
  light('Light'),
  dark('Dark');

  const ThemePreference(this.label);
  final String label;
}

/// Preferences kept on this device only (never sent to the API).
class AppPreferences {
  const AppPreferences({
    this.theme = ThemePreference.system,
    this.cameraFeedback = true,
    this.reminderHour = 19,
    this.reminderMinute = 0,
  });

  final ThemePreference theme;

  /// Show on-device hand-landmark feedback while signing.
  final bool cameraFeedback;

  /// Daily reminder time, local (24 h clock).
  final int reminderHour;
  final int reminderMinute;

  AppPreferences copyWith({
    ThemePreference? theme,
    bool? cameraFeedback,
    int? reminderHour,
    int? reminderMinute,
  }) => AppPreferences(
    theme: theme ?? this.theme,
    cameraFeedback: cameraFeedback ?? this.cameraFeedback,
    reminderHour: reminderHour ?? this.reminderHour,
    reminderMinute: reminderMinute ?? this.reminderMinute,
  );

  @override
  bool operator ==(Object other) =>
      other is AppPreferences &&
      other.theme == theme &&
      other.cameraFeedback == cameraFeedback &&
      other.reminderHour == reminderHour &&
      other.reminderMinute == reminderMinute;

  @override
  int get hashCode =>
      Object.hash(theme, cameraFeedback, reminderHour, reminderMinute);
}
