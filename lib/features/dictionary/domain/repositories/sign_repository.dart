import '../../../../core/error/result.dart';
import '../entities/sign.dart';

abstract interface class SignRepository {
  /// Every sign in the dictionary, curated order (`GET /signs`, all pages).
  /// Cache-first: emits the cached list (if any), then the fresh one. If
  /// the refresh fails it emits the failure only when nothing was cached.
  Stream<Result<List<Sign>>> watchSigns();

  /// Signs whose name contains [query] (case-insensitive), optionally only
  /// in [category] (`GET /signs?search&category`). Offline, it filters the
  /// cached list instead.
  Future<Result<List<Sign>>> searchSigns({
    String query = '',
    SignCategory? category,
  });

  /// One sign with its details (`GET /signs/:id`). Emits the cached list
  /// entry first (if any), then the fresh detail. A sign the server doesn't
  /// know is a `NotFoundFailure`, even after a cached entry.
  Stream<Result<Sign>> watchSign(String signId);
}
