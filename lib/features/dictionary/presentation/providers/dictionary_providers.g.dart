// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All dictionary signs (fake; a repository replaces this later).

@ProviderFor(dictionarySigns)
final dictionarySignsProvider = DictionarySignsProvider._();

/// All dictionary signs (fake; a repository replaces this later).

final class DictionarySignsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DictionarySign>>,
          List<DictionarySign>,
          FutureOr<List<DictionarySign>>
        >
    with
        $FutureModifier<List<DictionarySign>>,
        $FutureProvider<List<DictionarySign>> {
  /// All dictionary signs (fake; a repository replaces this later).
  DictionarySignsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dictionarySignsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dictionarySignsHash();

  @$internal
  @override
  $FutureProviderElement<List<DictionarySign>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DictionarySign>> create(Ref ref) {
    return dictionarySigns(ref);
  }
}

String _$dictionarySignsHash() => r'f43487b451d3135c267556f0484aa63339284de2';

/// The search box text.

@ProviderFor(DictionaryQuery)
final dictionaryQueryProvider = DictionaryQueryProvider._();

/// The search box text.
final class DictionaryQueryProvider
    extends $NotifierProvider<DictionaryQuery, String> {
  /// The search box text.
  DictionaryQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dictionaryQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dictionaryQueryHash();

  @$internal
  @override
  DictionaryQuery create() => DictionaryQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$dictionaryQueryHash() => r'80fca73cf673d4bf1a021ad7367515d06e171236';

/// The search box text.

abstract class _$DictionaryQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The selected filter chip; null = "All".

@ProviderFor(DictionaryCategory)
final dictionaryCategoryProvider = DictionaryCategoryProvider._();

/// The selected filter chip; null = "All".
final class DictionaryCategoryProvider
    extends $NotifierProvider<DictionaryCategory, SignCategory?> {
  /// The selected filter chip; null = "All".
  DictionaryCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dictionaryCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dictionaryCategoryHash();

  @$internal
  @override
  DictionaryCategory create() => DictionaryCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignCategory? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignCategory?>(value),
    );
  }
}

String _$dictionaryCategoryHash() =>
    r'5fb837eb9150ff22fcce9d5e87bf35c0ea5908b8';

/// The selected filter chip; null = "All".

abstract class _$DictionaryCategory extends $Notifier<SignCategory?> {
  SignCategory? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SignCategory?, SignCategory?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SignCategory?, SignCategory?>,
              SignCategory?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The "A–Z" section action: alphabetical instead of curated order.

@ProviderFor(DictionarySortAlphabetical)
final dictionarySortAlphabeticalProvider =
    DictionarySortAlphabeticalProvider._();

/// The "A–Z" section action: alphabetical instead of curated order.
final class DictionarySortAlphabeticalProvider
    extends $NotifierProvider<DictionarySortAlphabetical, bool> {
  /// The "A–Z" section action: alphabetical instead of curated order.
  DictionarySortAlphabeticalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dictionarySortAlphabeticalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dictionarySortAlphabeticalHash();

  @$internal
  @override
  DictionarySortAlphabetical create() => DictionarySortAlphabetical();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$dictionarySortAlphabeticalHash() =>
    r'c4b9f108abbdbe58298e9c2f0b887d760571065e';

/// The "A–Z" section action: alphabetical instead of curated order.

abstract class _$DictionarySortAlphabetical extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// [dictionarySigns] after search, category filter and sort.

@ProviderFor(filteredDictionarySigns)
final filteredDictionarySignsProvider = FilteredDictionarySignsProvider._();

/// [dictionarySigns] after search, category filter and sort.

final class FilteredDictionarySignsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DictionarySign>>,
          AsyncValue<List<DictionarySign>>,
          AsyncValue<List<DictionarySign>>
        >
    with $Provider<AsyncValue<List<DictionarySign>>> {
  /// [dictionarySigns] after search, category filter and sort.
  FilteredDictionarySignsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredDictionarySignsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredDictionarySignsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<DictionarySign>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<DictionarySign>> create(Ref ref) {
    return filteredDictionarySigns(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<DictionarySign>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<DictionarySign>>>(
        value,
      ),
    );
  }
}

String _$filteredDictionarySignsHash() =>
    r'549fe8232828f3551c268d5438e2042db13a0840';

/// One sign's detail (data null when [signId] is unknown).

@ProviderFor(signDetail)
final signDetailProvider = SignDetailFamily._();

/// One sign's detail (data null when [signId] is unknown).

final class SignDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<SignDetail?>,
          AsyncValue<SignDetail?>,
          AsyncValue<SignDetail?>
        >
    with $Provider<AsyncValue<SignDetail?>> {
  /// One sign's detail (data null when [signId] is unknown).
  SignDetailProvider._({
    required SignDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'signDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$signDetailHash();

  @override
  String toString() {
    return r'signDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<SignDetail?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<SignDetail?> create(Ref ref) {
    final argument = this.argument as String;
    return signDetail(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SignDetail?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SignDetail?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SignDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$signDetailHash() => r'2c08fa6b9c56f0b1ad0f0c1d4a4f375c6f015798';

/// One sign's detail (data null when [signId] is unknown).

final class SignDetailFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<SignDetail?>, String> {
  SignDetailFamily._()
    : super(
        retry: null,
        name: r'signDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One sign's detail (data null when [signId] is unknown).

  SignDetailProvider call(String signId) =>
      SignDetailProvider._(argument: signId, from: this);

  @override
  String toString() => r'signDetailProvider';
}
