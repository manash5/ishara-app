// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_editor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Changes to the learner's account. `state` is true while a request runs.
/// The updated profile reaches `userProfileProvider` through the cache.

@ProviderFor(ProfileEditor)
final profileEditorProvider = ProfileEditorProvider._();

/// Changes to the learner's account. `state` is true while a request runs.
/// The updated profile reaches `userProfileProvider` through the cache.
final class ProfileEditorProvider
    extends $NotifierProvider<ProfileEditor, bool> {
  /// Changes to the learner's account. `state` is true while a request runs.
  /// The updated profile reaches `userProfileProvider` through the cache.
  ProfileEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileEditorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileEditorHash();

  @$internal
  @override
  ProfileEditor create() => ProfileEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$profileEditorHash() => r'c329253ca7a12a997900707f79efe374933662ec';

/// Changes to the learner's account. `state` is true while a request runs.
/// The updated profile reaches `userProfileProvider` through the cache.

abstract class _$ProfileEditor extends $Notifier<bool> {
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
