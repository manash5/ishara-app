import '../../../../core/error/app_exception.dart';
import '../../../../core/services/storage/hive_service.dart';

/// Device preferences in the Hive `settings` box, one key each. Values are
/// plain strings / bools. Throws [CacheException].
class SettingsLocalDataSource {
  const SettingsLocalDataSource(this._hive);

  static const themeKey = 'settings.theme';
  static const cameraFeedbackKey = 'settings.cameraFeedback';

  /// `HH:mm`, 24 h.
  static const reminderKey = 'settings.reminder';

  final HiveService _hive;

  String? readTheme() => _read<String>(themeKey);

  bool? readCameraFeedback() => _read<bool>(cameraFeedbackKey);

  String? readReminder() => _read<String>(reminderKey);

  Future<void> write({
    required String theme,
    required bool cameraFeedback,
    required String reminder,
  }) async {
    try {
      await _hive.settings.putAll({
        themeKey: theme,
        cameraFeedbackKey: cameraFeedback,
        reminderKey: reminder,
      });
    } catch (_) {
      throw const CacheException();
    }
  }

  T? _read<T>(String key) {
    try {
      final value = _hive.settings.get(key);
      return value is T ? value : null;
    } catch (_) {
      throw const CacheException();
    }
  }
}
