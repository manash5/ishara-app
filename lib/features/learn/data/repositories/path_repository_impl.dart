import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/services/api/api_client.dart';
import '../../domain/entities/path_unit.dart';
import '../../domain/repositories/path_repository.dart';
import '../datasources/path_remote_data_source.dart';

part 'path_repository_impl.g.dart';

class PathRepositoryImpl implements PathRepository {
  const PathRepositoryImpl(this._remote);

  final PathRemoteDataSource _remote;

  @override
  Future<Result<List<PathUnit>>> getPath() =>
      guard(() async => (await _remote.fetchPath()).toEntity());
}

@Riverpod(keepAlive: true)
PathRepository pathRepository(Ref ref) =>
    PathRepositoryImpl(PathRemoteDataSource(ref.watch(apiClientProvider)));
