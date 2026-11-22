import '../../../../core/error/result.dart';
import '../entities/app_preferences.dart';
import '../repositories/settings_repository.dart';

/// The saved device preferences (defaults if none).
class GetPreferences {
  const GetPreferences(this._repository);

  final SettingsRepository _repository;

  Result<AppPreferences> call() => _repository.load();
}
