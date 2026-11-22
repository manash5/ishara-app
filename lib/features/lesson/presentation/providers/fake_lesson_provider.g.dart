// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fake_lesson_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Hard-coded lesson with one exercise of each type, using the Figma copy
/// (frames 18–25). A repository-backed provider replaces it later.
///
/// Sign descriptions and hints are Figma placeholders and are NOT verified
/// NSL — the "Thank you" description is the ASL sign (CLAUDE.md).

@ProviderFor(fakeLesson)
final fakeLessonProvider = FakeLessonFamily._();

/// Hard-coded lesson with one exercise of each type, using the Figma copy
/// (frames 18–25). A repository-backed provider replaces it later.
///
/// Sign descriptions and hints are Figma placeholders and are NOT verified
/// NSL — the "Thank you" description is the ASL sign (CLAUDE.md).

final class FakeLessonProvider
    extends $FunctionalProvider<Lesson, Lesson, Lesson>
    with $Provider<Lesson> {
  /// Hard-coded lesson with one exercise of each type, using the Figma copy
  /// (frames 18–25). A repository-backed provider replaces it later.
  ///
  /// Sign descriptions and hints are Figma placeholders and are NOT verified
  /// NSL — the "Thank you" description is the ASL sign (CLAUDE.md).
  FakeLessonProvider._({
    required FakeLessonFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fakeLessonProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fakeLessonHash();

  @override
  String toString() {
    return r'fakeLessonProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Lesson> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Lesson create(Ref ref) {
    final argument = this.argument as String;
    return fakeLesson(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Lesson value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Lesson>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FakeLessonProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fakeLessonHash() => r'7442bc7fbded2bcb321be629997e44c15cc45285';

/// Hard-coded lesson with one exercise of each type, using the Figma copy
/// (frames 18–25). A repository-backed provider replaces it later.
///
/// Sign descriptions and hints are Figma placeholders and are NOT verified
/// NSL — the "Thank you" description is the ASL sign (CLAUDE.md).

final class FakeLessonFamily extends $Family
    with $FunctionalFamilyOverride<Lesson, String> {
  FakeLessonFamily._()
    : super(
        retry: null,
        name: r'fakeLessonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Hard-coded lesson with one exercise of each type, using the Figma copy
  /// (frames 18–25). A repository-backed provider replaces it later.
  ///
  /// Sign descriptions and hints are Figma placeholders and are NOT verified
  /// NSL — the "Thank you" description is the ASL sign (CLAUDE.md).

  FakeLessonProvider call(String lessonId) =>
      FakeLessonProvider._(argument: lessonId, from: this);

  @override
  String toString() => r'fakeLessonProvider';
}

/// The learner's hearts when a lesson starts (fake until `/me` lands).

@ProviderFor(startingHearts)
final startingHeartsProvider = StartingHeartsProvider._();

/// The learner's hearts when a lesson starts (fake until `/me` lands).

final class StartingHeartsProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// The learner's hearts when a lesson starts (fake until `/me` lands).
  StartingHeartsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startingHeartsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startingHeartsHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return startingHearts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$startingHeartsHash() => r'c6d1cf07c9c41fc52f25316780a1f18bdf18b5ca';
