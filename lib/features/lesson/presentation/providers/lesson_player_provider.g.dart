// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the lesson player (Figma 18–25) over the loaded lesson. The
/// screen builds it only once [lessonProvider] has data.
///
/// Rules (lessons-gamification.md): a wrong non-camera answer costs one
/// heart; camera mistakes never do; at 0 hearts the lesson stops (28).
/// "Can't use the camera now" swaps every remaining camera exercise for a
/// recognise exercise on the same sign, with no penalty.

@ProviderFor(LessonPlayer)
final lessonPlayerProvider = LessonPlayerFamily._();

/// Drives the lesson player (Figma 18–25) over the loaded lesson. The
/// screen builds it only once [lessonProvider] has data.
///
/// Rules (lessons-gamification.md): a wrong non-camera answer costs one
/// heart; camera mistakes never do; at 0 hearts the lesson stops (28).
/// "Can't use the camera now" swaps every remaining camera exercise for a
/// recognise exercise on the same sign, with no penalty.
final class LessonPlayerProvider
    extends $NotifierProvider<LessonPlayer, LessonPlayerState> {
  /// Drives the lesson player (Figma 18–25) over the loaded lesson. The
  /// screen builds it only once [lessonProvider] has data.
  ///
  /// Rules (lessons-gamification.md): a wrong non-camera answer costs one
  /// heart; camera mistakes never do; at 0 hearts the lesson stops (28).
  /// "Can't use the camera now" swaps every remaining camera exercise for a
  /// recognise exercise on the same sign, with no penalty.
  LessonPlayerProvider._({
    required LessonPlayerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lessonPlayerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lessonPlayerHash();

  @override
  String toString() {
    return r'lessonPlayerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LessonPlayer create() => LessonPlayer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LessonPlayerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LessonPlayerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LessonPlayerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lessonPlayerHash() => r'0f2f8f54a10f2da68aed165ad6ba5adacbd5065e';

/// Drives the lesson player (Figma 18–25) over the loaded lesson. The
/// screen builds it only once [lessonProvider] has data.
///
/// Rules (lessons-gamification.md): a wrong non-camera answer costs one
/// heart; camera mistakes never do; at 0 hearts the lesson stops (28).
/// "Can't use the camera now" swaps every remaining camera exercise for a
/// recognise exercise on the same sign, with no penalty.

final class LessonPlayerFamily extends $Family
    with
        $ClassFamilyOverride<
          LessonPlayer,
          LessonPlayerState,
          LessonPlayerState,
          LessonPlayerState,
          String
        > {
  LessonPlayerFamily._()
    : super(
        retry: null,
        name: r'lessonPlayerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Drives the lesson player (Figma 18–25) over the loaded lesson. The
  /// screen builds it only once [lessonProvider] has data.
  ///
  /// Rules (lessons-gamification.md): a wrong non-camera answer costs one
  /// heart; camera mistakes never do; at 0 hearts the lesson stops (28).
  /// "Can't use the camera now" swaps every remaining camera exercise for a
  /// recognise exercise on the same sign, with no penalty.

  LessonPlayerProvider call(String lessonId) =>
      LessonPlayerProvider._(argument: lessonId, from: this);

  @override
  String toString() => r'lessonPlayerProvider';
}

/// Drives the lesson player (Figma 18–25) over the loaded lesson. The
/// screen builds it only once [lessonProvider] has data.
///
/// Rules (lessons-gamification.md): a wrong non-camera answer costs one
/// heart; camera mistakes never do; at 0 hearts the lesson stops (28).
/// "Can't use the camera now" swaps every remaining camera exercise for a
/// recognise exercise on the same sign, with no penalty.

abstract class _$LessonPlayer extends $Notifier<LessonPlayerState> {
  late final _$args = ref.$arg as String;
  String get lessonId => _$args;

  LessonPlayerState build(String lessonId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LessonPlayerState, LessonPlayerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LessonPlayerState, LessonPlayerState>,
              LessonPlayerState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
