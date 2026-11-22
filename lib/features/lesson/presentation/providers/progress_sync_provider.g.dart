// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Flushes the queue of lessons finished offline (`POST /progress/sync`)
/// whenever the app comes online, and retries a failed flush with
/// exponential back-off ([FlushProgressQueue.retryDelay]). Call [flush] on
/// app resume. Keep it alive by listening to it from the app root.

@ProviderFor(ProgressSync)
final progressSyncProvider = ProgressSyncProvider._();

/// Flushes the queue of lessons finished offline (`POST /progress/sync`)
/// whenever the app comes online, and retries a failed flush with
/// exponential back-off ([FlushProgressQueue.retryDelay]). Call [flush] on
/// app resume. Keep it alive by listening to it from the app root.
final class ProgressSyncProvider
    extends $NotifierProvider<ProgressSync, ProgressSyncState> {
  /// Flushes the queue of lessons finished offline (`POST /progress/sync`)
  /// whenever the app comes online, and retries a failed flush with
  /// exponential back-off ([FlushProgressQueue.retryDelay]). Call [flush] on
  /// app resume. Keep it alive by listening to it from the app root.
  ProgressSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressSyncHash();

  @$internal
  @override
  ProgressSync create() => ProgressSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgressSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgressSyncState>(value),
    );
  }
}

String _$progressSyncHash() => r'5fc69eb2128f4d6d20ee87268f0084e0339a4183';

/// Flushes the queue of lessons finished offline (`POST /progress/sync`)
/// whenever the app comes online, and retries a failed flush with
/// exponential back-off ([FlushProgressQueue.retryDelay]). Call [flush] on
/// app resume. Keep it alive by listening to it from the app root.

abstract class _$ProgressSync extends $Notifier<ProgressSyncState> {
  ProgressSyncState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProgressSyncState, ProgressSyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProgressSyncState, ProgressSyncState>,
              ProgressSyncState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
