import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/async_value_x.dart';
import '../../../lesson/presentation/providers/lesson_providers.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../domain/entities/game_stats.dart';
import '../../domain/usecases/apply_lesson_result.dart';
import '../../domain/usecases/get_streak_stats.dart';

part 'streak_provider.g.dart';

/// What Figma "27 Streak" shows: the learner's profile (`GET /me`, cached
/// offline), brought up to date by the lesson just completed (its response
/// has the new streak before `/me` is refetched). Derived synchronously so an
/// error shows at once, even while Riverpod retries the profile; retry with
/// `ref.invalidate(userProfileProvider)`.
@riverpod
AsyncValue<StreakStats> streakSummary(Ref ref) {
  final latest = ref.watch(latestLessonResultProvider);
  return ref
      .watch(userProfileProvider)
      .mapKeepingError(
        (profile) =>
            const ApplyLessonResult()(const GetStreakStats()(profile), latest),
      );
}
