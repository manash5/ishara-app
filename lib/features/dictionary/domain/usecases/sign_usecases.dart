import '../../../../core/error/result.dart';
import '../entities/sign.dart';
import '../repositories/sign_repository.dart';

/// Loads the whole dictionary (it's small; search and filters run locally).
class GetSigns {
  const GetSigns(this._repository);

  final SignRepository _repository;

  Future<Result<List<Sign>>> call() => _repository.getSigns();
}

/// Loads one sign's details.
class GetSign {
  const GetSign(this._repository);

  final SignRepository _repository;

  Future<Result<Sign>> call(String signId) => _repository.getSign(signId);
}
