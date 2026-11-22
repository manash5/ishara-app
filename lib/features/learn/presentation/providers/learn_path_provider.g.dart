// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_path_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The roadmap (`GET /path`): the cached path first (so Learn works
/// offline), then the fresh one. Errors only when nothing is cached; retry
/// with `ref.invalidate(learnPathProvider)`.

@ProviderFor(learnPath)
final learnPathProvider = LearnPathProvider._();

/// The roadmap (`GET /path`): the cached path first (so Learn works
/// offline), then the fresh one. Errors only when nothing is cached; retry
/// with `ref.invalidate(learnPathProvider)`.

final class LearnPathProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PathUnit>>,
          List<PathUnit>,
          Stream<List<PathUnit>>
        >
    with $FutureModifier<List<PathUnit>>, $StreamProvider<List<PathUnit>> {
  /// The roadmap (`GET /path`): the cached path first (so Learn works
  /// offline), then the fresh one. Errors only when nothing is cached; retry
  /// with `ref.invalidate(learnPathProvider)`.
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
  $StreamProviderElement<List<PathUnit>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PathUnit>> create(Ref ref) {
    return learnPath(ref);
  }
}

String _$learnPathHash() => r'24d78a8837433250a8b14b0574cbaedcbd8ba572';

/// Header stats on the Learn tab (Figma StatsBar 10:466), from the
/// learner's profile (`GET /me`).

@ProviderFor(learnStats)
final learnStatsProvider = LearnStatsProvider._();

/// Header stats on the Learn tab (Figma StatsBar 10:466), from the
/// learner's profile (`GET /me`).

final class LearnStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProgressStats>,
          AsyncValue<ProgressStats>,
          AsyncValue<ProgressStats>
        >
    with $Provider<AsyncValue<ProgressStats>> {
  /// Header stats on the Learn tab (Figma StatsBar 10:466), from the
  /// learner's profile (`GET /me`).
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
  $ProviderElement<AsyncValue<ProgressStats>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<ProgressStats> create(Ref ref) {
    return learnStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ProgressStats> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ProgressStats>>(value),
    );
  }
}

String _$learnStatsHash() => r'b914f255df8a54631840ea260d1401597a891676';

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
