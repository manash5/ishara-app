import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/recognition/data/fake/recognition_fixtures.dart';
import 'package:ishara_app/features/recognition/data/recognition_providers.dart';
import 'package:ishara_app/features/recognition/domain/entities/hand_frame.dart';
import 'package:ishara_app/features/recognition/presentation/providers/camera_session_state.dart';
import 'package:ishara_app/features/recognition/presentation/providers/fingerspell_session.dart';
import 'package:ishara_app/features/recognition/presentation/providers/sign_it_session.dart';

import '../../../helpers/mock_api.dart';

void main() {
  const namaste = '91a1aaec-304d-5c72-8be7-3404cc351df2';

  ProviderContainer container(FakeCameraScenario scenario) {
    final c = ProviderContainer(overrides: mockApiOverrides());
    addTearDown(c.dispose);
    c.read(fakeCameraSettingsProvider.notifier).set(scenario);
    return c;
  }

  group('SignItSession', () {
    Future<SignItState> run(
      WidgetTester tester,
      FakeCameraScenario scenario, {
      Duration time = const Duration(seconds: 4),
    }) async {
      final c = container(scenario);
      final provider = signItSessionProvider(namaste);
      c.listen(provider, (_, _) {});
      // Load the template (real IO happens outside fake time).
      await tester.runAsync(() => c.read(signTemplateProvider(namaste).future));
      await tester.pump(time);
      return c.read(provider);
    }

    for (final (scenario, outcome) in const [
      (FakeCameraScenario.correct, RecognitionOutcome.correct),
      (FakeCameraScenario.almost, RecognitionOutcome.almost),
      (FakeCameraScenario.wrong, RecognitionOutcome.wrong),
    ]) {
      testWidgets('${scenario.name} → $outcome', (tester) async {
        final state = await run(tester, scenario);
        expect(state.outcome, outcome);
        expect(state.landmarks, hasLength(21));
        expect(state.unavailable, isFalse);
        if (outcome == RecognitionOutcome.almost) {
          expect(state.weakestFinger, Finger.indexFinger);
        }
      });
    }

    testWidgets('no hand: no outcome, "no hand" status', (tester) async {
      final state = await run(tester, FakeCameraScenario.noHand);
      expect(state.outcome, isNull);
      expect(state.hand, HandStatus.noHand);
      expect(state.landmarks, isNull);
    });

    testWidgets('detects the hand and the hold before scoring', (tester) async {
      final state = await run(
        tester,
        FakeCameraScenario.correct,
        time: const Duration(milliseconds: 600),
      );
      expect(state.outcome, isNull);
      expect(state.hand, isNot(HandStatus.noHand));
    });

    testWidgets('restart listens for a new attempt and scores it again', (
      tester,
    ) async {
      final c = container(FakeCameraScenario.almost);
      final provider = signItSessionProvider(namaste);
      c.listen(provider, (_, _) {});
      await tester.runAsync(() => c.read(signTemplateProvider(namaste).future));
      await tester.pump(const Duration(seconds: 4));
      expect(c.read(provider).outcome, RecognitionOutcome.almost);

      c.read(provider.notifier).restart();
      expect(c.read(provider).outcome, isNull);
      await tester.pump(const Duration(seconds: 4));
      expect(c.read(provider).outcome, RecognitionOutcome.almost);
    });

    testWidgets('a sign without templates is unavailable', (tester) async {
      final c = container(FakeCameraScenario.correct);
      final provider = signItSessionProvider('no-template');
      c.listen(provider, (_, _) {});
      await tester.runAsync(
        () => c.read(signTemplateProvider('no-template').future),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(c.read(provider).unavailable, isTrue);
    });
  });

  group('FingerspellSession', () {
    final word = FingerspellSession.keyFor(RecognitionFixtures.word);

    testWidgets('correct: advances क → म → ल, then correct', (tester) async {
      final c = container(FakeCameraScenario.correct);
      final provider = fingerspellSessionProvider(word);
      final indexes = <int>{};
      c.listen(provider, (_, next) => indexes.add(next.letterIndex));
      await tester.pump(const Duration(seconds: 5));
      expect(indexes, containsAll([0, 1, 2]));
      expect(c.read(provider).outcome, RecognitionOutcome.correct);
    });

    testWidgets('another letter held first → almost, naming it', (
      tester,
    ) async {
      final c = container(FakeCameraScenario.almost);
      final provider = fingerspellSessionProvider(word);
      c.listen(provider, (_, _) {});
      await tester.pump(const Duration(seconds: 3));
      final state = c.read(provider);
      expect(state.outcome, RecognitionOutcome.almost);
      expect(state.wrongLetter, isNot(RecognitionFixtures.word.first));
      expect(state.letterIndex, 0);
    });

    testWidgets('practice (no word) shows each accepted letter', (
      tester,
    ) async {
      final c = container(FakeCameraScenario.correct);
      final provider = fingerspellSessionProvider('');
      final accepted = <String>{};
      c.listen(provider, (_, next) {
        if (next.accepted case final a?) accepted.add(a);
      });
      await tester.pump(const Duration(seconds: 6));
      expect(accepted.length, greaterThanOrEqualTo(3));
      expect(c.read(provider).outcome, isNull);
    });
  });
}
