import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/async_value_x.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../domain/entities/game_stats.dart';
import '../../domain/usecases/get_progress_stats.dart';

part 'progress_stats_provider.g.dart';

/// Streak, total XP and hearts for the StatsBar, from the learner's profile
/// (`GET /me`, cached offline). Retry with
/// `ref.invalidate(userProfileProvider)`.
@riverpod
AsyncValue<ProgressStats> progressStats(Ref ref) => ref
    .watch(userProfileProvider)
    .mapKeepingError(const GetProgressStats().call);
