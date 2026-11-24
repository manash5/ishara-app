import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../../domain/entities/path_unit.dart';
import '../../domain/repositories/path_repository.dart';
import '../datasources/path_local_data_source.dart';
import '../datasources/path_remote_data_source.dart';
import '../models/path_dto.dart';

part 'path_repository_impl.g.dart';

class PathRepositoryImpl implements PathRepository {
  const PathRepositoryImpl(this._remote, this._local);

  final PathRemoteDataSource _remote;
  final PathLocalDataSource _local;

  @override
  Stream<Result<List<PathUnit>>> watchPath() async* {
    final cached = _readCached();
    if (cached != null) yield Ok(cached);

    final fresh = await guard(() async {
      final dto = await _remote.fetchPath();
      final units = dto.toEntity();
      await _save(dto);
      return units;
    });
    // A failed refresh keeps showing the cache; with no cache it's the error.
    if (fresh.isOk || cached == null) yield fresh;
  }

  /// The cached path, or null if there is none or it can't be read (an
  /// unreadable entry is dropped so the next fetch replaces it).
  List<PathUnit>? _readCached() {
    try {
      return _local.readPath()?.value.toEntity();
    } catch (_) {
      _local.clear().ignore();
      return null;
    }
  }

  /// A cache write failure never fails the fetch.
  Future<void> _save(PathDto dto) async {
    try {
      await _local.savePath(dto);
    } catch (_) {}
  }
}

@Riverpod(keepAlive: true)
PathRepository pathRepository(Ref ref) => PathRepositoryImpl(
  PathRemoteDataSource(ref.watch(apiClientProvider)),
  PathLocalDataSource(ref.watch(hiveServiceProvider)),
);
