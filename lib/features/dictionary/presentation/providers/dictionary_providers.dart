import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/async_value_x.dart';
import '../../data/repositories/sign_repository_impl.dart';
import '../../domain/usecases/watch_sign.dart';
import '../../domain/usecases/watch_signs.dart';
import 'dictionary_models.dart';

part 'dictionary_providers.g.dart';

/// All dictionary signs (`GET /signs`, every page): the cached list first,
/// then the fresh one. Search, filters and sort run locally over this list,
/// so they are instant and work the same offline.
@riverpod
Stream<List<DictionarySign>> dictionarySigns(Ref ref) => WatchSigns(
  ref.watch(signRepositoryProvider),
)().map((result) => result.getOrThrow());

/// The search box text.
@riverpod
class DictionaryQuery extends _$DictionaryQuery {
  @override
  String build() => '';

  void setQuery(String value) => state = value;
}

/// The selected filter chip; null = "All".
@riverpod
class DictionaryCategory extends _$DictionaryCategory {
  @override
  SignCategory? build() => null;

  void select(SignCategory? category) => state = category;
}

/// The "A–Z" section action: alphabetical instead of curated order.
@riverpod
class DictionarySortAlphabetical extends _$DictionarySortAlphabetical {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

/// [dictionarySigns] after search, category filter and sort.
@riverpod
AsyncValue<List<DictionarySign>> filteredDictionarySigns(Ref ref) {
  final query = ref.watch(dictionaryQueryProvider).trim().toLowerCase();
  final category = ref.watch(dictionaryCategoryProvider);
  final alphabetical = ref.watch(dictionarySortAlphabeticalProvider);
  // mapKeepingError: a failed load Riverpod is retrying (loading + error)
  // still renders as the error state.
  return ref.watch(dictionarySignsProvider).mapKeepingError((signs) {
    final result = [
      for (final s in signs)
        if ((category == null || s.category == category) &&
            (query.isEmpty || s.name.toLowerCase().contains(query)))
          s,
    ];
    if (alphabetical) {
      result.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    }
    return result;
  });
}

/// One sign's detail (`GET /signs/:id`): the cached list entry first, then
/// the fresh detail. Data null when there's no such sign.
@riverpod
Stream<SignDetail?> signDetail(Ref ref, String signId) =>
    WatchSign(ref.watch(signRepositoryProvider))(signId).map(
      (result) => switch (result) {
        Ok(:final value) => SignDetail.fromSign(value),
        Err(failure: NotFoundFailure()) => null,
        Err(:final failure) => throw failure,
      },
    );
