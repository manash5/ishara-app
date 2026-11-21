import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dictionary_models.dart';

part 'dictionary_providers.g.dart';

/// Fake dictionary for the UI-only phase. Names and categories only — no
/// sign descriptions (they must come from the verified NDFN dictionary).
const fakeDictionarySigns = <DictionarySign>[
  DictionarySign(
    id: 'namaste',
    name: 'Namaste',
    category: SignCategory.greetings,
    status: SignStatus.learned,
  ),
  DictionarySign(
    id: 'thank-you',
    name: 'Thank you',
    category: SignCategory.greetings,
    status: SignStatus.learned,
  ),
  DictionarySign(
    id: 'sorry',
    name: 'Sorry',
    category: SignCategory.etiquette,
    status: SignStatus.practising,
  ),
  DictionarySign(
    id: 'please',
    name: 'Please',
    category: SignCategory.etiquette,
    status: SignStatus.newSign,
  ),
  DictionarySign(
    id: 'good-morning',
    name: 'Good morning',
    category: SignCategory.greetings,
    status: SignStatus.newSign,
  ),
  DictionarySign(
    id: 'how-are-you',
    name: 'How are you?',
    category: SignCategory.questions,
    status: SignStatus.newSign,
  ),
  DictionarySign(
    id: 'ka',
    name: 'Ka',
    category: SignCategory.alphabet,
    status: SignStatus.newSign,
  ),
  DictionarySign(
    id: 'kha',
    name: 'Kha',
    category: SignCategory.alphabet,
    status: SignStatus.newSign,
  ),
  DictionarySign(
    id: 'ga',
    name: 'Ga',
    category: SignCategory.alphabet,
    status: SignStatus.newSign,
  ),
  DictionarySign(
    id: 'one',
    name: 'One',
    category: SignCategory.numbers,
    status: SignStatus.newSign,
  ),
  DictionarySign(
    id: 'two',
    name: 'Two',
    category: SignCategory.numbers,
    status: SignStatus.newSign,
  ),
  DictionarySign(
    id: 'three',
    name: 'Three',
    category: SignCategory.numbers,
    status: SignStatus.newSign,
  ),
];

/// All dictionary signs (fake; a repository replaces this later).
@riverpod
Future<List<DictionarySign>> dictionarySigns(Ref ref) async =>
    fakeDictionarySigns;

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

/// Etiquette tips are about Deaf culture, not how a sign is formed.
const _fakeEtiquetteTips = <String, String>{
  'namaste':
      'Keep eye contact — in Deaf culture, looking away while someone signs '
      'is like turning your back.',
};

/// One sign's detail (data null when [signId] is unknown).
@riverpod
AsyncValue<SignDetail?> signDetail(Ref ref, String signId) {
  final source = ref.watch(dictionarySignsProvider);
  if (!source.hasValue) {
    return source.hasError
        ? AsyncError(source.error!, source.stackTrace ?? StackTrace.empty)
        : const AsyncLoading();
  }
  for (final sign in source.requireValue) {
    if (sign.id == signId) {
      return AsyncData(
        SignDetail(sign: sign, etiquetteTip: _fakeEtiquetteTips[signId]),
      );
    }
  }
  return const AsyncData(null);
}
