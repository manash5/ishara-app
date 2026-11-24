import 'dart:async';
import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/recognition_providers.dart';
import '../../domain/dtw_matcher.dart';
import '../../domain/entities/hand_frame.dart';
import '../../domain/landmark_normalizer.dart';
import '../../domain/sign_scorer.dart';
import '../../domain/sign_sequence_recorder.dart';
import 'camera_session_state.dart';

part 'sign_it_session.g.dart';

/// Where "Sign it" (Figma 23/24) stands.
@immutable
class SignItState {
  const SignItState({
    this.hand = HandStatus.noHand,
    this.landmarks,
    this.holdProgress = 0,
    this.outcome,
    this.weakestFinger,
    this.unavailable = false,
    this.stats = const RecognitionStats(),
  });

  final HandStatus hand;

  /// The live hand for the overlay (0–1), or null with no hand.
  final List<Offset>? landmarks;

  /// How far through the final 1 s hold the learner is (0–1).
  final double holdProgress;

  /// Set once the sign has been scored; the session then pauses until
  /// [SignItSession.restart].
  final RecognitionOutcome? outcome;

  /// The finger to fix when [outcome] is almost (Figma 24 danger joints).
  final Finger? weakestFinger;

  /// This sign has no reference templates yet: no practice feedback.
  final bool unavailable;
  final RecognitionStats stats;
}

/// Runs the greeting pipeline for one sign (recognition.md): detector →
/// normaliser (dominant hand from the profile) → recorder → DTW against the
/// sign's templates → scorer. The UI calls the result "practice feedback".
@riverpod
class SignItSession extends _$SignItSession {
  static const _normalizer = LandmarkNormalizer();
  static const _matcher = DtwMatcher();
  static const _scorer = SignScorer();

  final _recorder = SignSequenceRecorder();
  final _meter = StatsMeter();
  StreamSubscription<HandFrame?>? _frames;
  SignTemplate? _template;
  bool _leftHanded = false;

  @override
  SignItState build(String signId) {
    // Read once: a profile refresh mustn't restart the camera.
    _leftHanded =
        ref.read(userProfileProvider).value?.dominantHand == Hand.left;
    final template = ref.watch(signTemplateProvider(signId));
    _template = template.value;
    final detector = ref.watch(
      handLandmarkDetectorProvider(GreetingTarget(signId)),
    );
    _frames = detector.frames().listen(_onFrame);
    ref.onDispose(() => _frames?.cancel());
    return SignItState(
      unavailable: template.hasValue && template.value == null,
    );
  }

  void _onFrame(HandFrame? frame) {
    if (state.outcome != null) return;
    final watch = Stopwatch()..start();
    if (frame == null) {
      _recorder.reset();
      state = SignItState(unavailable: state.unavailable, stats: state.stats);
      return;
    }
    final Float64List features;
    try {
      features = _normalizer.normalize(
        frame.landmarks,
        leftHanded: _leftHanded,
      );
    } on ArgumentError {
      return; // A malformed detection: skip the frame.
    }
    final recording = _recorder.add(features, frame.timestamp);
    RecognitionOutcome? outcome;
    Finger? weakest;
    final template = _template;
    if (recording != null && template != null) {
      final match = _matcher.bestMatch(recording, template);
      outcome = _scorer.score(match.distance, template.thresholds);
      if (outcome != RecognitionOutcome.correct) {
        weakest = _scorer.weakestFinger(match.perLandmarkError);
      }
    }
    final hold = _recorder.holdProgress;
    state = SignItState(
      hand: hold > 0 ? HandStatus.holding : HandStatus.handDetected,
      landmarks: overlayPoints(frame),
      holdProgress: hold,
      outcome: outcome,
      weakestFinger: weakest,
      unavailable: state.unavailable,
      stats: _meter.record(frame.timestamp, watch.elapsed),
    );
  }

  /// Try again: listen for a fresh attempt.
  void restart() {
    _recorder.reset();
    state = SignItState(unavailable: state.unavailable, stats: state.stats);
  }
}
