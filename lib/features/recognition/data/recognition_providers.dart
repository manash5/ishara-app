import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/entities/hand_frame.dart';
import 'fake/fake_fingerspelling_classifier.dart';
import 'fake/scripted_hand_landmark_detector.dart';
import 'fake/synthetic_hands.dart';
import 'fingerspelling_classifier.dart';
import 'hand_landmark_detector.dart';
import 'sign_template_source.dart';

export 'fake/synthetic_hands.dart' show FakeCameraScenario;

part 'recognition_providers.g.dart';

/// What the fake camera plays (debug `/gallery` → Fake camera). Ignored once
/// the real camera lands.
@Riverpod(keepAlive: true)
class FakeCameraSettings extends _$FakeCameraSettings {
  @override
  FakeCameraScenario build() => FakeCameraScenario.correct;

  void set(FakeCameraScenario scenario) => state = scenario;
}

/// What a detector should show: a greeting, a word, or free practice.
sealed class CameraTarget {
  const CameraTarget();
}

final class GreetingTarget extends CameraTarget {
  const GreetingTarget(this.signId);
  final String signId;

  @override
  bool operator ==(Object other) =>
      other is GreetingTarget && other.signId == signId;

  @override
  int get hashCode => signId.hashCode;
}

final class WordTarget extends CameraTarget {
  const WordTarget(this.letters);
  final List<String> letters;

  @override
  bool operator ==(Object other) =>
      other is WordTarget && other.letters.join() == letters.join();

  @override
  int get hashCode => letters.join().hashCode;
}

final class PracticeTarget extends CameraTarget {
  const PracticeTarget();

  @override
  bool operator ==(Object other) => other is PracticeTarget;

  @override
  int get hashCode => 0;
}

/// The hand landmark detector for a camera exercise. For now a scripted fake
/// replaying the synthetic scenario chosen in `/gallery`; the MediaPipe
/// wrapper over `CameraFrameSource` replaces it here.
@riverpod
HandLandmarkDetector handLandmarkDetector(Ref ref, CameraTarget target) {
  final scenario = ref.watch(fakeCameraSettingsProvider);
  final hands = SyntheticHands();
  final List<HandFrame?> script = switch (target) {
    GreetingTarget(:final signId) => hands.greetingScenario(signId, scenario),
    WordTarget(:final letters) => hands.fingerspellScenario(letters, scenario),
    PracticeTarget() =>
      scenario == FakeCameraScenario.noHand
          ? hands.fingerspellScenario(const [], scenario)
          : hands.practiceScenario(),
  };
  final detector = ScriptedHandLandmarkDetector(script, fps: hands.fps);
  ref.onDispose(detector.dispose);
  return detector;
}

/// The fingerspelling classifier, loaded once (recognition.md). A fake
/// nearest-prototype classifier until the TFLite model lands.
@Riverpod(keepAlive: true)
FingerspellingClassifier fingerspellingClassifier(Ref ref) {
  final classifier = FakeFingerspellingClassifier();
  ref.onDispose(classifier.dispose);
  return classifier;
}

@Riverpod(keepAlive: true)
SignTemplateSource signTemplateSource(Ref ref) => SignTemplateSource();

/// A greeting's reference templates (null when the sign has none yet).
@Riverpod(keepAlive: true)
Future<SignTemplate?> signTemplate(Ref ref, String signId) =>
    ref.watch(signTemplateSourceProvider).load(signId);
