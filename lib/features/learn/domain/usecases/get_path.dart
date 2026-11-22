import '../../../../core/error/result.dart';
import '../entities/path_unit.dart';
import '../repositories/path_repository.dart';

/// Loads the roadmap.
class GetPath {
  const GetPath(this._repository);

  final PathRepository _repository;

  Future<Result<List<PathUnit>>> call() => _repository.getPath();
}
