// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A lesson and its exercises (`GET /lessons/:id`): the cached lesson first,
/// then the fresh one. Invalidate to retry.

@ProviderFor(lesson)
final lessonProvider = LessonFamily._();

/// A lesson and its exercises (`GET /lessons/:id`): the cached lesson first,
/// then the fresh one. Invalidate to retry.

final class LessonProvider
    extends $FunctionalProvider<AsyncValue<Lesson>, Lesson, Stream<Lesson>>
    with $FutureModifier<Lesson>, $StreamProvider<Lesson> {
  /// A lesson and its exercises (`GET /lessons/:id`): the cached lesson first,
  /// then the fresh one. Invalidate to retry.
  LessonProvider._({
    required LessonFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lessonProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lessonHash();

  @override
  String toString() {
    return r'lessonProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Lesson> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Lesson> create(Ref ref) {
    final argument = this.argument as String;
    return lesson(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lessonHash() => r'033ad2e62d5972b668d7e4761cd09ef56c21636b';

/// A lesson and its exercises (`GET /lessons/:id`): the cached lesson first,
/// then the fresh one. Invalidate to retry.

final class LessonFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Lesson>, String> {
  LessonFamily._()
    : super(
        retry: null,
        name: r'lessonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A lesson and its exercises (`GET /lessons/:id`): the cached lesson first,
  /// then the fresh one. Invalidate to retry.

  LessonProvider call(String lessonId) =>
      LessonProvider._(argument: lessonId, from: this);

  @override
  String toString() => r'lessonProvider';
}

/// The learner's hearts when a lesson starts: from their stats (`GET /me`),
/// or full if the profile hasn't loaded.

@ProviderFor(startingHearts)
final startingHeartsProvider = StartingHeartsProvider._();

/// The learner's hearts when a lesson starts: from their stats (`GET /me`),
/// or full if the profile hasn't loaded.

final class StartingHeartsProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// The learner's hearts when a lesson starts: from their stats (`GET /me`),
  /// or full if the profile hasn't loaded.
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

String _$startingHeartsHash() => r'6e59eef18d0e1956c7ee6a247d79bb3da1620220';

/// Finished attempts by lesson id, so Lesson complete (26) can send the
/// same `clientEventId` however often it rebuilds.

@ProviderFor(LessonAttempts)
final lessonAttemptsProvider = LessonAttemptsProvider._();

/// Finished attempts by lesson id, so Lesson complete (26) can send the
/// same `clientEventId` however often it rebuilds.
final class LessonAttemptsProvider
    extends $NotifierProvider<LessonAttempts, Map<String, LessonAttempt>> {
  /// Finished attempts by lesson id, so Lesson complete (26) can send the
  /// same `clientEventId` however often it rebuilds.
  LessonAttemptsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonAttemptsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonAttemptsHash();

  @$internal
  @override
  LessonAttempts create() => LessonAttempts();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, LessonAttempt> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, LessonAttempt>>(value),
    );
  }
}

String _$lessonAttemptsHash() => r'b239c0b7732edafd139200811cc6d9dc65d473fe';

/// Finished attempts by lesson id, so Lesson complete (26) can send the
/// same `clientEventId` however often it rebuilds.

abstract class _$LessonAttempts extends $Notifier<Map<String, LessonAttempt>> {
  Map<String, LessonAttempt> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<Map<String, LessonAttempt>, Map<String, LessonAttempt>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, LessonAttempt>,
                Map<String, LessonAttempt>
              >,
              Map<String, LessonAttempt>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The last lesson the server recorded this session (hearts, XP, streak),
/// or null until one completes. The Streak screen (27) reads it.

@ProviderFor(LatestLessonResult)
final latestLessonResultProvider = LatestLessonResultProvider._();

/// The last lesson the server recorded this session (hearts, XP, streak),
/// or null until one completes. The Streak screen (27) reads it.
final class LatestLessonResultProvider
    extends $NotifierProvider<LatestLessonResult, LessonResult?> {
  /// The last lesson the server recorded this session (hearts, XP, streak),
  /// or null until one completes. The Streak screen (27) reads it.
  LatestLessonResultProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestLessonResultProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestLessonResultHash();

  @$internal
  @override
  LatestLessonResult create() => LatestLessonResult();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LessonResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LessonResult?>(value),
    );
  }
}

String _$latestLessonResultHash() =>
    r'a11ecada48eac974c2599ea695750540c678371a';

/// The last lesson the server recorded this session (hearts, XP, streak),
/// or null until one completes. The Streak screen (27) reads it.

abstract class _$LatestLessonResult extends $Notifier<LessonResult?> {
  LessonResult? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LessonResult?, LessonResult?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LessonResult?, LessonResult?>,
              LessonResult?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// What the server awarded for the finished lesson
/// (`POST /lessons/:id/complete`, idempotent on `clientEventId`). Offline or
/// on a server error, the attempt is queued for `POST /progress/sync` and
/// this fails; Try again resends the same `clientEventId`.

@ProviderFor(lessonResult)
final lessonResultProvider = LessonResultFamily._();

/// What the server awarded for the finished lesson
/// (`POST /lessons/:id/complete`, idempotent on `clientEventId`). Offline or
/// on a server error, the attempt is queued for `POST /progress/sync` and
/// this fails; Try again resends the same `clientEventId`.

final class LessonResultProvider
    extends
        $FunctionalProvider<
          AsyncValue<LessonResult>,
          LessonResult,
          FutureOr<LessonResult>
        >
    with $FutureModifier<LessonResult>, $FutureProvider<LessonResult> {
  /// What the server awarded for the finished lesson
  /// (`POST /lessons/:id/complete`, idempotent on `clientEventId`). Offline or
  /// on a server error, the attempt is queued for `POST /progress/sync` and
  /// this fails; Try again resends the same `clientEventId`.
  LessonResultProvider._({
    required LessonResultFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lessonResultProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lessonResultHash();

  @override
  String toString() {
    return r'lessonResultProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LessonResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LessonResult> create(Ref ref) {
    final argument = this.argument as String;
    return lessonResult(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonResultProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lessonResultHash() => r'8ed75acfd4d44d5714c48db0420e5a1cb232d1af';

/// What the server awarded for the finished lesson
/// (`POST /lessons/:id/complete`, idempotent on `clientEventId`). Offline or
/// on a server error, the attempt is queued for `POST /progress/sync` and
/// this fails; Try again resends the same `clientEventId`.

final class LessonResultFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LessonResult>, String> {
  LessonResultFamily._()
    : super(
        retry: null,
        name: r'lessonResultProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// What the server awarded for the finished lesson
  /// (`POST /lessons/:id/complete`, idempotent on `clientEventId`). Offline or
  /// on a server error, the attempt is queued for `POST /progress/sync` and
  /// this fails; Try again resends the same `clientEventId`.

  LessonResultProvider call(String lessonId) =>
      LessonResultProvider._(argument: lessonId, from: this);

  @override
  String toString() => r'lessonResultProvider';
}
