import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_models.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/match_pairs_exercise_view.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_themed.dart';
import '../lesson_test_utils.dart';

void main() {
  final e = fakeExercise<MatchPairsExercise>();

  Widget view(
    MatchProgress match, {
    ValueChanged<int>? onWord,
    ValueChanged<int>? onVideo,
  }) => MatchPairsExerciseView(
    exercise: e,
    state: stateOn<MatchPairsExercise>(match: match),
    onTapWord: onWord ?? (_) {},
    onTapVideo: onVideo ?? (_) {},
  );

  MatchTileState word(WidgetTester tester, String label) =>
      tester.widget<MatchTile>(find.widgetWithText(MatchTile, label)).state;
  AnswerState video(WidgetTester tester, int row) =>
      tester.widget<VideoOption>(find.byType(VideoOption).at(row)).state;

  for (final mode in themeModes) {
    testWidgets('Figma 22 state: one matched, one selected (${mode.name})', (
      tester,
    ) async {
      await pumpExercise(
        tester,
        view(const MatchProgress(matched: {0}, word: 1, video: 1)),
        mode: mode,
      );
      expect(find.text('MATCH THE PAIRS'), findsOneWidget);
      expect(find.text('Tap a word, then its sign'), findsOneWidget);
      expect(word(tester, 'Hello'), MatchTileState.matched);
      expect(video(tester, 0), AnswerState.correct);
      // Matched videos are VideoOption(correct) at 45% opacity.
      final opacity = tester.widget<Opacity>(
        find.ancestor(
          of: find.byType(VideoOption).at(0),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity.opacity, IsharaSizes.matchedOpacity);
      expect(word(tester, 'Please'), MatchTileState.selected);
      expect(video(tester, 1), AnswerState.selected);
      expect(word(tester, 'Sorry'), MatchTileState.idle);
      // Word and video share a row height.
      expect(
        tester.getSize(find.byType(MatchTile).at(2)).height,
        tester.getSize(find.byType(VideoOption).at(2)).height,
      );
    });
  }

  testWidgets('taps report the word or video row', (tester) async {
    final words = <int>[];
    final videos = <int>[];
    await pumpExercise(
      tester,
      view(const MatchProgress(), onWord: words.add, onVideo: videos.add),
    );
    await tester.tap(find.text('Sorry'));
    await tester.tap(find.byType(VideoOption).at(1));
    expect(words, [2]);
    expect(videos, [1]);
  });

  testWidgets('matched video is not tappable', (tester) async {
    final videos = <int>[];
    await pumpExercise(
      tester,
      view(const MatchProgress(matched: {0}), onVideo: videos.add),
    );
    await tester.tap(find.byType(VideoOption).at(0), warnIfMissed: false);
    expect(videos, isEmpty);
  });

  testWidgets('a wrong pair turns both tiles danger', (tester) async {
    await pumpExercise(
      tester,
      view(const MatchProgress(wrongWord: 0, wrongVideo: 2)),
    );
    expect(word(tester, 'Hello'), MatchTileState.wrong);
    expect(video(tester, 2), AnswerState.wrong);
  });
}
