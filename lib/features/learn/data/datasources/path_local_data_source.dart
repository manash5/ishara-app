import '../../../../core/services/storage/hive_service.dart';
import '../models/path_dto.dart';

/// The last roadmap fetched, kept in Hive so Learn works offline.
/// Throws `CacheException`.
class PathLocalDataSource {
  const PathLocalDataSource(this._hive);

  static const cacheKey = 'learn.path';

  final HiveService _hive;

  /// The cached path, or null if none has been saved.
  CacheEntry<PathDto>? readPath() => _hive.readCache(
    cacheKey,
    (json) => PathDto.fromJson(json! as Map<String, dynamic>),
  );

  Future<void> savePath(PathDto path) =>
      _hive.putCache(cacheKey, path.toJson());

  Future<void> clear() => _hive.removeCache(cacheKey);
}
