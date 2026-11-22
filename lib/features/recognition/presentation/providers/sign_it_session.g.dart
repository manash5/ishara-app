// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_it_session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs the greeting pipeline for one sign (recognition.md): detector →
/// normaliser (dominant hand from the profile) → recorder → DTW against the
/// sign's templates → scorer. The UI calls the result "practice feedback".

@ProviderFor(SignItSession)
final signItSessionProvider = SignItSessionFamily._();

/// Runs the greeting pipeline for one sign (recognition.md): detector →
/// normaliser (dominant hand from the profile) → recorder → DTW against the
/// sign's templates → scorer. The UI calls the result "practice feedback".
final class SignItSessionProvider
    extends $NotifierProvider<SignItSession, SignItState> {
  /// Runs the greeting pipeline for one sign (recognition.md): detector →
  /// normaliser (dominant hand from the profile) → recorder → DTW against the
  /// sign's templates → scorer. The UI calls the result "practice feedback".
  SignItSessionProvider._({
    required SignItSessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'signItSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$signItSessionHash();

  @override
  String toString() {
    return r'signItSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SignItSession create() => SignItSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignItState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignItState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SignItSessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$signItSessionHash() => r'caa7ec37e94c6d32ca7fface8d6f5a434fac0ec6';

/// Runs the greeting pipeline for one sign (recognition.md): detector →
/// normaliser (dominant hand from the profile) → recorder → DTW against the
/// sign's templates → scorer. The UI calls the result "practice feedback".

final class SignItSessionFamily extends $Family
    with
        $ClassFamilyOverride<
          SignItSession,
          SignItState,
          SignItState,
          SignItState,
          String
        > {
  SignItSessionFamily._()
    : super(
        retry: null,
        name: r'signItSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Runs the greeting pipeline for one sign (recognition.md): detector →
  /// normaliser (dominant hand from the profile) → recorder → DTW against the
  /// sign's templates → scorer. The UI calls the result "practice feedback".

  SignItSessionProvider call(String signId) =>
      SignItSessionProvider._(argument: signId, from: this);

  @override
  String toString() => r'signItSessionProvider';
}

/// Runs the greeting pipeline for one sign (recognition.md): detector →
/// normaliser (dominant hand from the profile) → recorder → DTW against the
/// sign's templates → scorer. The UI calls the result "practice feedback".

abstract class _$SignItSession extends $Notifier<SignItState> {
  late final _$args = ref.$arg as String;
  String get signId => _$args;

  SignItState build(String signId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SignItState, SignItState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SignItState, SignItState>,
              SignItState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
