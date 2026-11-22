// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_id_token_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The real Google picker, or the fake one with the mock API.

@ProviderFor(googleIdTokenSource)
final googleIdTokenSourceProvider = GoogleIdTokenSourceProvider._();

/// The real Google picker, or the fake one with the mock API.

final class GoogleIdTokenSourceProvider
    extends
        $FunctionalProvider<
          GoogleIdTokenProvider,
          GoogleIdTokenProvider,
          GoogleIdTokenProvider
        >
    with $Provider<GoogleIdTokenProvider> {
  /// The real Google picker, or the fake one with the mock API.
  GoogleIdTokenSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleIdTokenSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleIdTokenSourceHash();

  @$internal
  @override
  $ProviderElement<GoogleIdTokenProvider> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GoogleIdTokenProvider create(Ref ref) {
    return googleIdTokenSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleIdTokenProvider value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleIdTokenProvider>(value),
    );
  }
}

String _$googleIdTokenSourceHash() =>
    r'ed5cc64a0113fb1275be5d80ddcff8bc056d6c20';
