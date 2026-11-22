import '../../../../core/error/result.dart';
import '../entities/path_unit.dart';

abstract interface class PathRepository {
  /// The learner's roadmap, first unit first (`GET /path`).
  Future<Result<List<PathUnit>>> getPath();
}
