import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:ishara_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:ishara_app/features/settings/domain/entities/app_preferences.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_hive.dart';

class MockLocal extends Mock implements SettingsLocalDataSource {}

void main() {
  SettingsRepositoryImpl real() =>
      SettingsRepositoryImpl(SettingsLocalDataSource(TestHive.instance));

  test('nothing saved → the defaults', () {
    expect(real().load().valueOrNull, const AppPreferences());
  });

  test('save then load round-trips through the settings box', () async {
    const prefs = AppPreferences(
      theme: ThemePreference.dark,
      cameraFeedback: false,
      reminderHour: 7,
      reminderMinute: 5,
    );
    expect((await real().save(prefs)).isOk, isTrue);
    expect(TestHive.instance.settings.get('settings.reminder'), '07:05');
    expect(TestHive.instance.settings.get('settings.theme'), 'dark');
    expect(real().load().valueOrNull, prefs);
  });

  test('bad stored values fall back to the defaults', () async {
    await TestHive.instance.settings.putAll({
      'settings.theme': 'neon',
      'settings.cameraFeedback': 'yes',
      'settings.reminder': '25:99',
    });
    expect(real().load().valueOrNull, const AppPreferences());
  });

  test('cache errors become CacheFailure', () async {
    final local = MockLocal();
    when(() => local.readTheme()).thenThrow(const CacheException());
    when(
      () => local.write(
        theme: any(named: 'theme'),
        cameraFeedback: any(named: 'cameraFeedback'),
        reminder: any(named: 'reminder'),
      ),
    ).thenThrow(const CacheException());
    final repo = SettingsRepositoryImpl(local);

    expect((repo.load() as Err).failure, isA<CacheFailure>());
    final saved = await repo.save(const AppPreferences());
    expect((saved as Err).failure, isA<CacheFailure>());
  });
}
