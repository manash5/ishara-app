// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pathRepository)
final pathRepositoryProvider = PathRepositoryProvider._();

final class PathRepositoryProvider
    extends $FunctionalProvider<PathRepository, PathRepository, PathRepository>
    with $Provider<PathRepository> {
  PathRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pathRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pathRepositoryHash();

  @$internal
  @override
  $ProviderElement<PathRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PathRepository create(Ref ref) {
    return pathRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PathRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PathRepository>(value),
    );
  }
}

String _$pathRepositoryHash() => r'915e4eb099c33f33af4e03e96dffdac98080e306';
