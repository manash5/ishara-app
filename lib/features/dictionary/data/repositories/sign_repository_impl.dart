import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/services/api/api_client.dart';
import '../../domain/entities/sign.dart';
import '../../domain/repositories/sign_repository.dart';
import '../datasources/sign_remote_data_source.dart';

part 'sign_repository_impl.g.dart';

class SignRepositoryImpl implements SignRepository {
  const SignRepositoryImpl(this._remote);

  final SignRemoteDataSource _remote;

  @override
  Future<Result<List<Sign>>> getSigns() => guard(
    () async => [for (final s in await _remote.fetchAll()) s.toEntity()],
  );

  @override
  Future<Result<Sign>> getSign(String signId) =>
      guard(() async => (await _remote.fetchSign(signId)).toEntity());
}

@Riverpod(keepAlive: true)
SignRepository signRepository(Ref ref) =>
    SignRepositoryImpl(SignRemoteDataSource(ref.watch(apiClientProvider)));
