import '../../../../core/error/result.dart';
import '../entities/app_preferences.dart';

/// Device-only preferences (theme, camera feedback, reminder).
abstract interface class SettingsRepository {
  /// The saved preferences, or the defaults when nothing is saved.
  Result<AppPreferences> load();

  Future<Result<void>> save(AppPreferences preferences);
}
