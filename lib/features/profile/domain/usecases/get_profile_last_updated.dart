import '../../../../core/error/result.dart';
import '../repositories/profile_repository.dart';

/// When the cached profile was fetched ("Offline · updated 3 h ago").
class GetProfileLastUpdated {
  const GetProfileLastUpdated(this._repository);

  final ProfileRepository _repository;

  Result<DateTime?> call() => _repository.lastUpdated();
}
