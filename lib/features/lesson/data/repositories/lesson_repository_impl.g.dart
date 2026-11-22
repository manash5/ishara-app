// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lessonRepository)
final lessonRepositoryProvider = LessonRepositoryProvider._();

final class LessonRepositoryProvider
    extends
        $FunctionalProvider<
          LessonRepository,
          LessonRepository,
          LessonRepository
        >
    with $Provider<LessonRepository> {
  LessonRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonRepositoryHash();

  @$internal
  @override
  $ProviderElement<LessonRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LessonRepository create(Ref ref) {
    return lessonRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LessonRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LessonRepository>(value),
    );
  }
}

String _$lessonRepositoryHash() => r'783659a5b9465aaacca638fbfb8656e8fa8c4b85';
