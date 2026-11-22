import '../../../../core/error/result.dart';
import '../entities/sign.dart';

abstract interface class SignRepository {
  /// Every sign in the dictionary, curated order (`GET /signs`, all pages).
  Future<Result<List<Sign>>> getSigns();

  /// One sign with its details (`GET /signs/:id`).
  Future<Result<Sign>> getSign(String signId);
}
