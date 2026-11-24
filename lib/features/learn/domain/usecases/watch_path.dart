import '../../../../core/error/result.dart';
import '../entities/path_unit.dart';
import '../repositories/path_repository.dart';

/// Watches the roadmap: the cached path first (works offline), then the
/// fresh one from the server.
class WatchPath {
  const WatchPath(this._repository);

  final PathRepository _repository;

  Stream<Result<List<PathUnit>>> call() => _repository.watchPath();
}
