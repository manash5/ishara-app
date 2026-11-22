// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Hard-coded summary matching the Figma frame; the server's lesson
/// completion response replaces it when the data layer lands.

@ProviderFor(lessonSummary)
final lessonSummaryProvider = LessonSummaryFamily._();

/// Hard-coded summary matching the Figma frame; the server's lesson
/// completion response replaces it when the data layer lands.

final class LessonSummaryProvider
    extends $FunctionalProvider<LessonSummary, LessonSummary, LessonSummary>
    with $Provider<LessonSummary> {
  /// Hard-coded summary matching the Figma frame; the server's lesson
  /// completion response replaces it when the data layer lands.
  LessonSummaryProvider._({
    required LessonSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lessonSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lessonSummaryHash();

  @override
  String toString() {
    return r'lessonSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<LessonSummary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LessonSummary create(Ref ref) {
    final argument = this.argument as String;
    return lessonSummary(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LessonSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LessonSummary>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LessonSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lessonSummaryHash() => r'7de597ccd9a1409beeb3a9666c1b61faa183bfde';

/// Hard-coded summary matching the Figma frame; the server's lesson
/// completion response replaces it when the data layer lands.

final class LessonSummaryFamily extends $Family
    with $FunctionalFamilyOverride<LessonSummary, String> {
  LessonSummaryFamily._()
    : super(
        retry: null,
        name: r'lessonSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Hard-coded summary matching the Figma frame; the server's lesson
  /// completion response replaces it when the data layer lands.

  LessonSummaryProvider call(String lessonId) =>
      LessonSummaryProvider._(argument: lessonId, from: this);

  @override
  String toString() => r'lessonSummaryProvider';
}
