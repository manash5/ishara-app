import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../../domain/entities/sign.dart';
import '../../domain/repositories/sign_repository.dart';
import '../datasources/sign_local_data_source.dart';
import '../datasources/sign_remote_data_source.dart';
import '../models/sign_dto.dart';

part 'sign_repository_impl.g.dart';

class SignRepositoryImpl implements SignRepository {
  const SignRepositoryImpl(this._remote, this._local);

  final SignRemoteDataSource _remote;
  final SignLocalDataSource _local;

  @override
  Stream<Result<List<Sign>>> watchSigns() async* {
    final cached = await _readCache();
    if (cached != null) yield Ok(_toEntities(cached));

    final fresh = await guard(_remote.fetchAll);
    switch (fresh) {
      case Ok(:final value):
        // A failed cache write must not hide fresh data.
        await guard(() => _local.writeSigns(value));
        yield Ok(_toEntities(value));
      case Err(:final failure):
        if (cached == null) yield Err(failure);
    }
  }

  @override
  Future<Result<List<Sign>>> searchSigns({
    String query = '',
    SignCategory? category,
  }) async {
    final search = query.trim();
    final remote = await guard(
      () => _remote.fetchAll(category: category?.name, search: search),
    );
    if (remote case Err(failure: NetworkFailure())) {
      final cached = await _readCache();
      if (cached != null) {
        final needle = search.toLowerCase();
        return Ok([
          for (final s in _toEntities(cached))
            if ((category == null || s.category == category) &&
                s.name.toLowerCase().contains(needle))
              s,
        ]);
      }
    }
    return switch (remote) {
      Ok(:final value) => Ok(_toEntities(value)),
      Err(:final failure) => Err(failure),
    };
  }

  @override
  Stream<Result<Sign>> watchSign(String signId) async* {
    final cached = (await _readCache())
        ?.where((s) => s.id == signId)
        .firstOrNull;
    if (cached != null) yield Ok(cached.toEntity());

    final fresh = await guard(() => _remote.fetchSign(signId));
    switch (fresh) {
      case Ok(:final value):
        yield Ok(value.toEntity());
      // The server no longer has it: say so even after a cached entry.
      case Err(failure: final NotFoundFailure failure):
        yield Err(failure);
      case Err(:final failure):
        if (cached == null) yield Err(failure);
    }
  }

  /// The cached list, or null when there is none or it can't be read.
  Future<List<SignDto>?> _readCache() async =>
      (await guard(() async => _local.readSigns()?.value)).valueOrNull;

  static List<Sign> _toEntities(List<SignDto> dtos) => [
    for (final s in dtos) s.toEntity(),
  ];
}

@Riverpod(keepAlive: true)
SignRepository signRepository(Ref ref) => SignRepositoryImpl(
  SignRemoteDataSource(ref.watch(apiClientProvider)),
  SignLocalDataSource(ref.watch(hiveServiceProvider)),
);
