import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../../domain/entities/app_preferences.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

part 'settings_repository_impl.g.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._local);

  final SettingsLocalDataSource _local;

  @override
  Result<AppPreferences> load() {
    try {
      const defaults = AppPreferences();
      final reminder = _parseTime(_local.readReminder());
      return Ok(
        AppPreferences(
          theme:
              ThemePreference.values.asNameMap()[_local.readTheme()] ??
              defaults.theme,
          cameraFeedback:
              _local.readCameraFeedback() ?? defaults.cameraFeedback,
          reminderHour: reminder?.$1 ?? defaults.reminderHour,
          reminderMinute: reminder?.$2 ?? defaults.reminderMinute,
        ),
      );
    } on AppException catch (e) {
      return Err(Failure.fromException(e));
    }
  }

  @override
  Future<Result<void>> save(AppPreferences preferences) => guard(
    () => _local.write(
      theme: preferences.theme.name,
      cameraFeedback: preferences.cameraFeedback,
      reminder: _formatTime(
        preferences.reminderHour,
        preferences.reminderMinute,
      ),
    ),
  );

  static String _formatTime(int hour, int minute) =>
      '${'$hour'.padLeft(2, '0')}:${'$minute'.padLeft(2, '0')}';

  static (int, int)? _parseTime(String? value) {
    final parts = value?.split(':');
    if (parts == null || parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return (hour, minute);
  }
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) => SettingsRepositoryImpl(
  SettingsLocalDataSource(ref.watch(hiveServiceProvider)),
);
