import '../../../../core/error/result.dart';
import '../entities/path_unit.dart';

abstract interface class PathRepository {
  /// The learner's roadmap, first unit first (`GET /path`), cache first:
  /// emits the cached path (if any), then the fresh one. A failed refresh
  /// emits an [Err] only when nothing was cached.
  Stream<Result<List<PathUnit>>> watchPath();
}
