// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'is_online.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the API is reachable now, updated as the network changes and
/// re-checked while offline. With the mock API it also re-checks whenever the
/// debug simulation changes, so the `/gallery` Offline toggle applies at once.
/// Invalidate it to re-check (app resume).
///
/// Widgets watch this provider; only it touches [ConnectivityService].

@ProviderFor(isOnline)
final isOnlineProvider = IsOnlineProvider._();

/// Whether the API is reachable now, updated as the network changes and
/// re-checked while offline. With the mock API it also re-checks whenever the
/// debug simulation changes, so the `/gallery` Offline toggle applies at once.
/// Invalidate it to re-check (app resume).
///
/// Widgets watch this provider; only it touches [ConnectivityService].

final class IsOnlineProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Whether the API is reachable now, updated as the network changes and
  /// re-checked while offline. With the mock API it also re-checks whenever the
  /// debug simulation changes, so the `/gallery` Offline toggle applies at once.
  /// Invalidate it to re-check (app resume).
  ///
  /// Widgets watch this provider; only it touches [ConnectivityService].
  IsOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOnlineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOnlineHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return isOnline(ref);
  }
}

String _$isOnlineHash() => r'732885c9fa1ad7a3d348461e165a5a019f361b8d';
