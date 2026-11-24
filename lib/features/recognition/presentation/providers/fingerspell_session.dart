import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/fingerspelling_classifier.dart';
import '../../data/recognition_providers.dart';
import '../../domain/entities/hand_frame.dart';
import '../../domain/landmark_normalizer.dart';
import '../../domain/temporal_smoother.dart';
import 'camera_session_state.dart';

part 'fingerspell_session.g.dart';

/// Where fingerspelling (Figma 25, and Practice) stands.
@immutable
class FingerspellState {
  const FingerspellState({
    this.hand = HandStatus.noHand,
    this.landmarks,
    this.letterIndex = 0,
    this.candidate,
    this.holdProgress = 0,
    this.accepted,
    this.outcome,
    this.wrongLetter,
    this.stats = const RecognitionStats(),
  });

  final HandStatus hand;
  final List<Offset>? landmarks;

  /// The letter the learner is on (word mode).
  final int letterIndex;

  /// The steady letter being held (not yet accepted).
  final String? candidate;
  final double holdProgress;

  /// The last accepted letter (Practice shows it).
  final String? accepted;

  /// Word mode: correct once the whole word is spelled; almost when another
  /// letter was held. The session pauses on an outcome until
  /// [FingerspellSession.restart].
  final RecognitionOutcome? outcome;
  final String? wrongLetter;
  final RecognitionStats stats;
}

/// Runs the fingerspelling pipeline (recognition.md): detector → normaliser
/// (dominant hand from the profile) → classifier → temporal smoother.
///
/// [lettersKey] is the word's letters joined with `|` (a stable family key);
/// empty = free practice, where every accepted letter is just shown.
@riverpod
class FingerspellSession extends _$FingerspellSession {
  static const _normalizer = LandmarkNormalizer();

  final _smoother = TemporalSmoother();
  final _meter = StatsMeter();
  StreamSubscription<HandFrame?>? _frames;
  late FingerspellingClassifier _classifier;
  late List<String> _letters;
  bool _leftHanded = false;

  /// The family key for [letters].
  static String keyFor(List<String> letters) => letters.join('|');

  bool get _practice => _letters.isEmpty;

  @override
  FingerspellState build(String lettersKey) {
    _letters = lettersKey.isEmpty ? const [] : lettersKey.split('|');
    _leftHanded =
        ref.read(userProfileProvider).value?.dominantHand == Hand.left;
    _classifier = ref.watch(fingerspellingClassifierProvider);
    final detector = ref.watch(
      handLandmarkDetectorProvider(
        _practice ? const PracticeTarget() : WordTarget(_letters),
      ),
    );
    _frames = detector.frames().listen(_onFrame);
    ref.onDispose(() => _frames?.cancel());
    return const FingerspellState();
  }

  void _onFrame(HandFrame? frame) {
    if (state.outcome != null) return;
    final watch = Stopwatch()..start();
    if (frame == null) {
      _smoother.add(null, Duration.zero);
      state = FingerspellState(
        letterIndex: state.letterIndex,
        accepted: state.accepted,
        stats: state.stats,
      );
      return;
    }
    final LetterPrediction prediction;
    try {
      prediction = _classifier.classify(
        _normalizer.normalize(frame.landmarks, leftHanded: _leftHanded),
      );
    } on ArgumentError {
      return;
    }
    final accepted = _smoother.add(prediction, frame.timestamp);

    var index = state.letterIndex;
    RecognitionOutcome? outcome;
    String? wrong;
    if (accepted != null && !_practice) {
      if (accepted == _letters[index]) {
        index++;
        if (index == _letters.length) {
          outcome = RecognitionOutcome.correct;
          index = _letters.length - 1;
        }
      } else {
        outcome = RecognitionOutcome.almost;
        wrong = accepted;
      }
    }
    final candidate = _smoother.candidate;
    state = FingerspellState(
      hand: candidate != null ? HandStatus.holding : HandStatus.handDetected,
      landmarks: overlayPoints(frame),
      letterIndex: index,
      candidate: candidate,
      holdProgress: _smoother.holdProgress,
      accepted: accepted ?? state.accepted,
      outcome: outcome,
      wrongLetter: wrong,
      stats: _meter.record(frame.timestamp, watch.elapsed),
    );
  }

  /// Try again: keep the letters done so far and listen afresh.
  void restart() {
    _smoother.reset();
    state = FingerspellState(
      letterIndex: state.letterIndex,
      stats: state.stats,
    );
  }
}
