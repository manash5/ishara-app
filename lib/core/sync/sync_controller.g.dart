// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(syncQueue)
final syncQueueProvider = SyncQueueProvider._();

final class SyncQueueProvider
    extends $FunctionalProvider<SyncQueue, SyncQueue, SyncQueue>
    with $Provider<SyncQueue> {
  SyncQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncQueueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncQueueHash();

  @$internal
  @override
  $ProviderElement<SyncQueue> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncQueue create(Ref ref) {
    return syncQueue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncQueue value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncQueue>(value),
    );
  }
}

String _$syncQueueHash() => r'7cc87b74d4d06cd4b0289e9774f8c920a1d48c42';

@ProviderFor(syncService)
final syncServiceProvider = SyncServiceProvider._();

final class SyncServiceProvider
    extends $FunctionalProvider<SyncService, SyncService, SyncService>
    with $Provider<SyncService> {
  SyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncServiceHash();

  @$internal
  @override
  $ProviderElement<SyncService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncService create(Ref ref) {
    return syncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncService>(value),
    );
  }
}

String _$syncServiceHash() => r'57f693b354073d11664676bd3d4fdac2f0164f63';

/// How many changes are waiting to sync.

@ProviderFor(syncPendingCount)
final syncPendingCountProvider = SyncPendingCountProvider._();

/// How many changes are waiting to sync.

final class SyncPendingCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// How many changes are waiting to sync.
  SyncPendingCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncPendingCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncPendingCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return syncPendingCount(ref);
  }
}

String _$syncPendingCountHash() => r'6e7e2a765d19130fc225b086b68399e482bed612';

/// Flushes the offline queue whenever the app comes online, retries a failed
/// flush with back-off ([SyncService.retryDelay]), and on app resume
/// ([flush], called from `lib/app.dart`). Keep it alive from the app root.

@ProviderFor(SyncController)
final syncControllerProvider = SyncControllerProvider._();

/// Flushes the offline queue whenever the app comes online, retries a failed
/// flush with back-off ([SyncService.retryDelay]), and on app resume
/// ([flush], called from `lib/app.dart`). Keep it alive from the app root.
final class SyncControllerProvider
    extends $NotifierProvider<SyncController, SyncState> {
  /// Flushes the offline queue whenever the app comes online, retries a failed
  /// flush with back-off ([SyncService.retryDelay]), and on app resume
  /// ([flush], called from `lib/app.dart`). Keep it alive from the app root.
  SyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncControllerHash();

  @$internal
  @override
  SyncController create() => SyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncState>(value),
    );
  }
}

String _$syncControllerHash() => r'e4cfeb0906937edb81ea64c7a3ba52d776086117';

/// Flushes the offline queue whenever the app comes online, retries a failed
/// flush with back-off ([SyncService.retryDelay]), and on app resume
/// ([flush], called from `lib/app.dart`). Keep it alive from the app root.

abstract class _$SyncController extends $Notifier<SyncState> {
  SyncState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncState, SyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncState, SyncState>,
              SyncState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
