import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:ishara_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:ishara_app/features/profile/domain/entities/user_profile.dart';

import '../../../../helpers/mock_api.dart';

void main() {
  ProfileRepositoryImpl repo([MockApiSimulation? s]) => ProfileRepositoryImpl(
    ProfileRemoteDataSource(
      mockApiClient(simulation: s == null ? null : () => s),
    ),
  );

  test('maps /me to a UserProfile', () async {
    final profile = (await repo().getProfile()).getOrThrow();
    expect(profile.id, FixtureIds.user);
    expect(profile.displayName, 'Manash Lamichhane');
    expect(profile.dominantHand, Hand.right);
    expect(profile.stats.totalXp, 1240);
    expect(profile.stats.weekXp, [30, 55, 20, 70, 45, 4, 62]);
    expect(profile.stats.todayIndex, 6);
  });

  test('failures come back as Err, never thrown', () async {
    final offline = await repo(MockApiSimulation.offline).getProfile();
    expect((offline as Err).failure, isA<NetworkFailure>());
    final server = await repo(MockApiSimulation.serverError).getProfile();
    expect((server as Err).failure, isA<ServerFailure>());
  });
}
