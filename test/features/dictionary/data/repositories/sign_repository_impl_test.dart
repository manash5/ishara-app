import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/dictionary/data/datasources/sign_remote_data_source.dart';
import 'package:ishara_app/features/dictionary/data/repositories/sign_repository_impl.dart';
import 'package:ishara_app/features/dictionary/domain/entities/sign.dart';

import '../../../../helpers/mock_api.dart';

void main() {
  SignRepositoryImpl repo([MockApiSimulation? s]) => SignRepositoryImpl(
    SignRemoteDataSource(mockApiClient(simulation: s == null ? null : () => s)),
  );

  test('fetches every page, in order', () async {
    final signs = (await repo().getSigns()).getOrThrow();
    expect(signs, hasLength(12));
    expect(signs.first.name, 'Namaste');
    expect(signs.last.name, 'Three');
    expect(signs[2].status, SignStatus.practising);
    expect(signs[3].status, SignStatus.newSign);
  });

  test('one sign with its etiquette tip; no invented NSL text', () async {
    final namaste = (await repo().getSign(FixtureIds.namaste)).getOrThrow();
    expect(namaste.category, SignCategory.greetings);
    expect(namaste.etiquetteTip, isNotNull);
    expect(namaste.meaning, isNull);
    expect(namaste.steps, isEmpty);
  });

  test('an unknown sign is a NotFoundFailure', () async {
    final result = await repo().getSign('00000000-0000-4000-8000-000000000000');
    expect((result as Err).failure, isA<NotFoundFailure>());
  });
}
