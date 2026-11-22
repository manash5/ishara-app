import '../../../../core/error/result.dart';
import '../entities/sign.dart';
import '../repositories/sign_repository.dart';

/// The whole dictionary, cached first then refreshed. It's small, so the
/// Dictionary screen searches and filters it locally.
class WatchSigns {
  const WatchSigns(this._repository);

  final SignRepository _repository;

  Stream<Result<List<Sign>>> call() => _repository.watchSigns();
}
