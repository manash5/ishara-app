// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Hard-coded profile matching the Figma frame; a repository-backed
/// provider replaces it when the data layer lands.

@ProviderFor(profileSummary)
final profileSummaryProvider = ProfileSummaryProvider._();

/// Hard-coded profile matching the Figma frame; a repository-backed
/// provider replaces it when the data layer lands.

final class ProfileSummaryProvider
    extends $FunctionalProvider<ProfileSummary, ProfileSummary, ProfileSummary>
    with $Provider<ProfileSummary> {
  /// Hard-coded profile matching the Figma frame; a repository-backed
  /// provider replaces it when the data layer lands.
  ProfileSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileSummaryHash();

  @$internal
  @override
  $ProviderElement<ProfileSummary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProfileSummary create(Ref ref) {
    return profileSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileSummary>(value),
    );
  }
}

String _$profileSummaryHash() => r'1e71388ebd56fa1eed927bf8d4d192490a5091b0';
