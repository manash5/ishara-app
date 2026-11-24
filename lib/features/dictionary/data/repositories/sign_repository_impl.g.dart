// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(signRepository)
final signRepositoryProvider = SignRepositoryProvider._();

final class SignRepositoryProvider
    extends $FunctionalProvider<SignRepository, SignRepository, SignRepository>
    with $Provider<SignRepository> {
  SignRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signRepositoryHash();

  @$internal
  @override
  $ProviderElement<SignRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SignRepository create(Ref ref) {
    return signRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignRepository>(value),
    );
  }
}

String _$signRepositoryHash() => r'01d39aea7f13ba06a78eca2881898b0bf8a94d84';
