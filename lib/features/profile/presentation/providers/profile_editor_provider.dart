import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../auth/presentation/providers/session_provider.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_update.dart';
import '../../domain/usecases/delete_account.dart';
import '../../domain/usecases/update_profile.dart';

part 'profile_editor_provider.g.dart';

/// Changes to the learner's account. `state` is true while a request runs.
/// The updated profile reaches `userProfileProvider` through the cache.
@Riverpod(keepAlive: true)
class ProfileEditor extends _$ProfileEditor {
  @override
  bool build() => false;

  /// `PUT /me`. Returns the failure to show, or null on success.
  Future<Failure?> update(ProfileUpdate update) => _run(
    () async =>
        (await UpdateProfile(ref.read(profileRepositoryProvider))(update))
            .fold((f) => f, (_) => null),
  );

  /// `DELETE /me`, then ends the session on this device. Returns the
  /// failure to show, or null on success.
  Future<Failure?> deleteAccount() => _run(() async {
    final result = await DeleteAccount(ref.read(profileRepositoryProvider))();
    if (result case Err(:final failure)) return failure;
    await ref.read(sessionProvider.notifier).endSession();
    return null;
  });

  Future<Failure?> _run(Future<Failure?> Function() body) async {
    state = true;
    try {
      return await body();
    } finally {
      if (ref.mounted) state = false;
    }
  }
}
