// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_path_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The roadmap (`GET /path`).

@ProviderFor(learnPath)
final learnPathProvider = LearnPathProvider._();

/// The roadmap (`GET /path`).

final class LearnPathProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PathUnit>>,
          List<PathUnit>,
          FutureOr<List<PathUnit>>
        >
    with $FutureModifier<List<PathUnit>>, $FutureProvider<List<PathUnit>> {
  /// The roadmap (`GET /path`).
  LearnPathProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnPathProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnPathHash();

  @$internal
  @override
  $FutureProviderElement<List<PathUnit>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PathUnit>> create(Ref ref) {
    return learnPath(ref);
  }
}

String _$learnPathHash() => r'7437e0025542ee39dc580ccefd12629a5ec5cc88';

/// Header stats from the learner's profile (`GET /me`).

@ProviderFor(learnStats)
final learnStatsProvider = LearnStatsProvider._();

/// Header stats from the learner's profile (`GET /me`).

final class LearnStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<LearnStats>,
          AsyncValue<LearnStats>,
          AsyncValue<LearnStats>
        >
    with $Provider<AsyncValue<LearnStats>> {
  /// Header stats from the learner's profile (`GET /me`).
  LearnStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnStatsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<LearnStats>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<LearnStats> create(Ref ref) {
    return learnStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<LearnStats> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<LearnStats>>(value),
    );
  }
}

String _$learnStatsHash() => r'6f873d7e8cbbcc21f7dbfa40a522286f2092ac39';

/// Fake connectivity for frame 12 (Learn – offline). Flip it from the debug
/// `/gallery` until real connectivity lands.

@ProviderFor(LearnOffline)
final learnOfflineProvider = LearnOfflineProvider._();

/// Fake connectivity for frame 12 (Learn – offline). Flip it from the debug
/// `/gallery` until real connectivity lands.
final class LearnOfflineProvider extends $NotifierProvider<LearnOffline, bool> {
  /// Fake connectivity for frame 12 (Learn – offline). Flip it from the debug
  /// `/gallery` until real connectivity lands.
  LearnOfflineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnOfflineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnOfflineHash();

  @$internal
  @override
  LearnOffline create() => LearnOffline();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$learnOfflineHash() => r'e9059865980a726c242afccb07129d4673d53109';

/// Fake connectivity for frame 12 (Learn – offline). Flip it from the debug
/// `/gallery` until real connectivity lands.

abstract class _$LearnOffline extends $Notifier<bool> {
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
