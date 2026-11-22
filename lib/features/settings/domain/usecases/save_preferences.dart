import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../entities/app_preferences.dart';
import '../repositories/settings_repository.dart';

/// Saves the device preferences.
class SavePreferences {
  const SavePreferences(this._repository);

  final SettingsRepository _repository;

  Future<Result<void>> call(AppPreferences preferences) async {
    final validTime =
        preferences.reminderHour >= 0 &&
        preferences.reminderHour < 24 &&
        preferences.reminderMinute >= 0 &&
        preferences.reminderMinute < 60;
    if (!validTime) return const Err(ValidationFailure());
    return _repository.save(preferences);
  }
}
