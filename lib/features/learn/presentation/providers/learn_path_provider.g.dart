// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_path_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fake roadmap: units 1–2 follow Figma "10 Learn" (10:509); units 3–4 are
/// locked so the path scrolls. Unit titles only — no sign descriptions.

@ProviderFor(learnPath)
final learnPathProvider = LearnPathProvider._();

/// Fake roadmap: units 1–2 follow Figma "10 Learn" (10:509); units 3–4 are
/// locked so the path scrolls. Unit titles only — no sign descriptions.

final class LearnPathProvider
    extends $FunctionalProvider<List<PathUnit>, List<PathUnit>, List<PathUnit>>
    with $Provider<List<PathUnit>> {
  /// Fake roadmap: units 1–2 follow Figma "10 Learn" (10:509); units 3–4 are
  /// locked so the path scrolls. Unit titles only — no sign descriptions.
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
  $ProviderElement<List<PathUnit>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<PathUnit> create(Ref ref) {
    return learnPath(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PathUnit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PathUnit>>(value),
    );
  }
}

String _$learnPathHash() => r'fd5296e094832e8598a2c3b204635d1c716ba9a4';

/// Fake header stats (Figma: 12-day streak, 340 XP, 5 hearts).

@ProviderFor(learnStats)
final learnStatsProvider = LearnStatsProvider._();

/// Fake header stats (Figma: 12-day streak, 340 XP, 5 hearts).

final class LearnStatsProvider
    extends $FunctionalProvider<LearnStats, LearnStats, LearnStats>
    with $Provider<LearnStats> {
  /// Fake header stats (Figma: 12-day streak, 340 XP, 5 hearts).
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
  $ProviderElement<LearnStats> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LearnStats create(Ref ref) {
    return learnStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnStats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnStats>(value),
    );
  }
}

String _$learnStatsHash() => r'e119196f546c45e03bfdd1bf9b0614c5fdc9c49b';

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
