import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../../../profile/data/datasources/profile_local_data_source.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../domain/entities/onboarding_answers.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_remote_data_source.dart';
import '../models/onboarding_request_dto.dart';

part 'onboarding_repository_impl.g.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._remote, this._profileCache);

  final OnboardingRemoteDataSource _remote;
  final ProfileLocalDataSource _profileCache;

  @override
  Future<Result<UserProfile>> complete(OnboardingAnswers answers) =>
      guard(() async {
        final dto = await _remote.complete(
          OnboardingRequestDto.fromEntity(answers),
        );
        await _profileCache.write(dto);
        return dto.toEntity();
      });
}

@Riverpod(keepAlive: true)
OnboardingRepository onboardingRepository(Ref ref) => OnboardingRepositoryImpl(
  OnboardingRemoteDataSource(ref.watch(apiClientProvider)),
  ProfileLocalDataSource(ref.watch(hiveServiceProvider)),
);
