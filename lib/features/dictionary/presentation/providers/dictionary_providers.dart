import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../data/repositories/sign_repository_impl.dart';
import '../../domain/usecases/sign_usecases.dart';
import 'dictionary_models.dart';

part 'dictionary_providers.g.dart';

/// All dictionary signs (`GET /signs`, every page). Search, filters and
/// sort run locally over this list.
@riverpod
Future<List<DictionarySign>> dictionarySigns(Ref ref) async =>
    (await GetSigns(ref.watch(signRepositoryProvider))()).getOrThrow();

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
  final source = ref.watch(dictionarySignsProvider);
  // Pass loading / error through untouched: Riverpod retries failed
  // providers, and the retrying state (loading + error) must still render
  // as the error state.
  if (!source.hasValue) return source;
  final result = [
    for (final s in source.requireValue)
      if ((category == null || s.category == category) &&
          (query.isEmpty || s.name.toLowerCase().contains(query)))
        s,
  ];
  if (alphabetical) {
    result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
  return AsyncData(result);
}

/// One sign's detail (`GET /signs/:id`); data null when there's no such
/// sign.
@riverpod
Future<SignDetail?> signDetail(Ref ref, String signId) async {
  final result = await GetSign(ref.watch(signRepositoryProvider))(signId);
  return switch (result) {
    Ok(:final value) => SignDetail.fromSign(value),
    Err(failure: NotFoundFailure()) => null,
    Err(:final failure) => throw failure,
  };
}
