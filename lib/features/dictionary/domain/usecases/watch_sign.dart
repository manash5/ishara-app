import '../../../../core/error/result.dart';
import '../entities/sign.dart';
import '../repositories/sign_repository.dart';

/// One sign: its cached list entry first, then the fresh detail.
class WatchSign {
  const WatchSign(this._repository);

  final SignRepository _repository;

  Stream<Result<Sign>> call(String signId) => _repository.watchSign(signId);
}
