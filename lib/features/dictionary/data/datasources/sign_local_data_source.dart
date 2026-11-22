import '../../../../core/services/storage/hive_service.dart';
import '../models/sign_dto.dart';

/// The dictionary's text list, cached for offline use. Video URLs are
/// short-lived signed URLs, so they are never stored. Throws
/// `CacheException`.
class SignLocalDataSource {
  const SignLocalDataSource(this._hive);

  static const cacheKey = 'dictionary.signs';

  final HiveService _hive;

  /// The cached list, or null if there is none.
  CacheEntry<List<SignDto>>? readSigns() => _hive.readCache(
    cacheKey,
    (json) => [
      for (final s in json! as List)
        _withoutVideo(SignDto.fromJson((s as Map).cast<String, dynamic>())),
    ],
  );

  Future<void> writeSigns(List<SignDto> signs) => _hive.putCache(cacheKey, [
    for (final s in signs) _withoutVideo(s).toJson(),
  ]);

  Future<void> clear() => _hive.removeCache(cacheKey);

  static SignDto _withoutVideo(SignDto s) =>
      s.videoUrl == null ? s : s.copyWith(videoUrl: null);
}
