// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fingerspell_session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs the fingerspelling pipeline (recognition.md): detector → normaliser
/// (dominant hand from the profile) → classifier → temporal smoother.
///
/// [lettersKey] is the word's letters joined with `|` (a stable family key);
/// empty = free practice, where every accepted letter is just shown.

@ProviderFor(FingerspellSession)
final fingerspellSessionProvider = FingerspellSessionFamily._();

/// Runs the fingerspelling pipeline (recognition.md): detector → normaliser
/// (dominant hand from the profile) → classifier → temporal smoother.
///
/// [lettersKey] is the word's letters joined with `|` (a stable family key);
/// empty = free practice, where every accepted letter is just shown.
final class FingerspellSessionProvider
    extends $NotifierProvider<FingerspellSession, FingerspellState> {
  /// Runs the fingerspelling pipeline (recognition.md): detector → normaliser
  /// (dominant hand from the profile) → classifier → temporal smoother.
  ///
  /// [lettersKey] is the word's letters joined with `|` (a stable family key);
  /// empty = free practice, where every accepted letter is just shown.
  FingerspellSessionProvider._({
    required FingerspellSessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fingerspellSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fingerspellSessionHash();

  @override
  String toString() {
    return r'fingerspellSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FingerspellSession create() => FingerspellSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FingerspellState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FingerspellState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FingerspellSessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fingerspellSessionHash() =>
    r'77420469f8bd8be4e939a88d2cdaa89b7f4e329c';

/// Runs the fingerspelling pipeline (recognition.md): detector → normaliser
/// (dominant hand from the profile) → classifier → temporal smoother.
///
/// [lettersKey] is the word's letters joined with `|` (a stable family key);
/// empty = free practice, where every accepted letter is just shown.

final class FingerspellSessionFamily extends $Family
    with
        $ClassFamilyOverride<
          FingerspellSession,
          FingerspellState,
          FingerspellState,
          FingerspellState,
          String
        > {
  FingerspellSessionFamily._()
    : super(
        retry: null,
        name: r'fingerspellSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Runs the fingerspelling pipeline (recognition.md): detector → normaliser
  /// (dominant hand from the profile) → classifier → temporal smoother.
  ///
  /// [lettersKey] is the word's letters joined with `|` (a stable family key);
  /// empty = free practice, where every accepted letter is just shown.

  FingerspellSessionProvider call(String lettersKey) =>
      FingerspellSessionProvider._(argument: lettersKey, from: this);

  @override
  String toString() => r'fingerspellSessionProvider';
}

/// Runs the fingerspelling pipeline (recognition.md): detector → normaliser
/// (dominant hand from the profile) → classifier → temporal smoother.
///
/// [lettersKey] is the word's letters joined with `|` (a stable family key);
/// empty = free practice, where every accepted letter is just shown.

abstract class _$FingerspellSession extends $Notifier<FingerspellState> {
  late final _$args = ref.$arg as String;
  String get lettersKey => _$args;

  FingerspellState build(String lettersKey);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FingerspellState, FingerspellState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FingerspellState, FingerspellState>,
              FingerspellState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
