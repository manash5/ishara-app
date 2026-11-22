import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/profile/domain/entities/user_profile.dart';
import 'package:ishara_app/features/settings/presentation/providers/settings_provider.dart';
import 'package:material_ui/material_ui.dart';

import '../../../auth/auth_test_utils.dart';

void main() {
  AuthTestEnv env() => AuthTestEnv(
    session: const SessionState(
      ready: true,
      loggedIn: true,
      onboardingDone: true,
    ),
  );

  test('preferences load from the settings box', () async {
    final e = env();
    await e.hive.settings.putAll({
      'settings.theme': 'dark',
      'settings.cameraFeedback': false,
      'settings.reminder': '08:30',
    });
    final container = e.container();
    final values = container.read(settingsProvider);
    expect(values.theme, ThemePreference.dark);
    expect(values.cameraFeedback, isFalse);
    expect(values.reminder, const TimeOfDay(hour: 8, minute: 30));
    expect(container.read(themeModeProvider), ThemeMode.dark);
  });

  test('profile values arrive once the profile loads', () async {
    final container = env().container();
    container.listen(settingsProvider, (_, _) {});
    expect(container.read(settingsProvider).dailyGoalMinutes, isNull);
    await settleAsync();
    expect(container.read(settingsProvider).dailyGoalMinutes, 10);
    expect(container.read(settingsProvider).dominantHand, Hand.right);
  });

  test('setReminder is saved', () async {
    final e = env();
    final container = e.container();
    await container
        .read(preferencesProvider.notifier)
        .setReminder(const TimeOfDay(hour: 6, minute: 0));
    expect(e.hive.settings.get('settings.reminder'), '06:00');
  });

  test('nextDailyGoal cycles 5 → 10 → 15 → 20 → 5', () {
    expect(nextDailyGoal(5), 10);
    expect(nextDailyGoal(20), 5);
    expect(nextDailyGoal(null), 5);
  });

  test('hand labels', () {
    expect(Hand.left.label, 'Left');
    expect(Hand.right.label, 'Right');
  });
}
