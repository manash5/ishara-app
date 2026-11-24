// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_sync_listener.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Reacts when lessons finished offline reach the server (core
/// `SyncController`): the newest one becomes the latest lesson result and
/// the profile is refetched, so XP, hearts and streak match the server.
/// Kept alive from the app root.

@ProviderFor(lessonSyncListener)
final lessonSyncListenerProvider = LessonSyncListenerProvider._();

/// Reacts when lessons finished offline reach the server (core
/// `SyncController`): the newest one becomes the latest lesson result and
/// the profile is refetched, so XP, hearts and streak match the server.
/// Kept alive from the app root.

final class LessonSyncListenerProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Reacts when lessons finished offline reach the server (core
  /// `SyncController`): the newest one becomes the latest lesson result and
  /// the profile is refetched, so XP, hearts and streak match the server.
  /// Kept alive from the app root.
  LessonSyncListenerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonSyncListenerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonSyncListenerHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return lessonSyncListener(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$lessonSyncListenerHash() =>
    r'683e0f8fdb32b8a78fdae2cf5b64386428ad006b';
