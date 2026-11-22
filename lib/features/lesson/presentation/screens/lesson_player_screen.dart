import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/lesson_models.dart';
import '../providers/lesson_player_provider.dart';
import '../providers/lesson_providers.dart';
import '../widgets/fingerspell_exercise_view.dart';
import '../widgets/match_pairs_exercise_view.dart';
import '../widgets/pick_sign_exercise_view.dart';
import '../widgets/recognise_exercise_view.dart';
import '../widgets/sign_it_exercise_view.dart';
import '../widgets/watch_exercise_view.dart';
import 'quit_lesson_dialog.dart';

/// Figma copy for the XP shown in a correct `FeedbackSheet` (20).
const String _xpCopy = '+3 XP';

/// Figma "18–25": one player; exercises are states, not routes
/// (lessons-gamification.md). Close and Android back ask before quitting
/// (29); 0 hearts opens Out of hearts (28); finishing goes to 26.
class LessonPlayerScreen extends ConsumerWidget {
  const LessonPlayerScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lesson = ref.watch(lessonProvider(lessonId));
    if (!lesson.hasValue) {
      return Scaffold(
        backgroundColor: context.colors.bgSurface,
        body: LoadStateView(
          error: lesson.error,
          errorTitle: 'Couldn’t load this lesson',
          onRetry: () => ref.invalidate(lessonProvider(lessonId)),
          loadingLabel: 'Loading the lesson',
        ),
      );
    }
    final provider = lessonPlayerProvider(lessonId);
    final state = ref.watch(provider);
    ref.listen(provider.select((s) => s.phase), (_, phase) {
      switch (phase) {
        case LessonPhase.outOfHearts:
          IsharaFeedback.wrong();
          showOutOfHeartsSheet(
            context,
            onPractise: () => const PracticeRoute().go(context),
            onEndLesson: () => const LearnRoute().go(context),
          );
        case LessonPhase.finished:
          LessonCompleteRoute(lessonId: lessonId).go(context);
        case LessonPhase.answering || LessonPhase.feedback:
          break;
      }
    });

    final camera = state.exercise.isCamera;
    final page = Builder(
      // Sheets are shown from this context so they pick up the camera
      // screens' dark theme.
      builder: (context) => _PlayerPage(
        state: state,
        controller: _PlayerController(
          context,
          ref.read(provider.notifier),
          state,
        ),
      ),
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) showQuitLessonDialog(context);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: camera || Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        // Camera screens always use the dark theme (ui.md).
        child: camera ? Theme(data: AppTheme.dark, child: page) : page,
      ),
    );
  }
}

/// Turns taps into notifier calls and shows the feedback sheet.
class _PlayerController {
  _PlayerController(this.context, this.player, this._state);

  final BuildContext context;
  final LessonPlayer player;
  final LessonPlayerState _state;

  void check() {
    final result = player.check();
    if (result != null) _feedback(result);
  }

  void tapMatch({int? word, int? video}) {
    switch (player.tapMatch(word: word, video: video)) {
      case MatchTap.matched:
        IsharaFeedback.correct();
      case MatchTap.wrong:
        IsharaFeedback.wrong();
      case MatchTap.selected:
        break;
    }
  }

  void cameraResult(CameraOutcome outcome) {
    final result = player.cameraResult(outcome);
    if (result != null) _feedback(result);
  }

  void skipCamera() => player.skipCamera();

  Future<void> close() => showQuitLessonDialog(context);

  /// Shows the `FeedbackSheet` (it adds the haptic), then moves on. Leaving
  /// the sheet any other way (e.g. Android back) also moves on.
  Future<void> _feedback(FeedbackResult result) async {
    final exercise = _state.exercise;
    var skip = false;
    final nav = Navigator.of(context);
    await FeedbackSheet.show(
      context,
      result: result,
      message: _message(exercise, result),
      onContinue: nav.pop,
      secondaryLabel: result == FeedbackResult.almost
          ? 'Skip — I can’t use the camera now'
          : null,
      onSecondary: result == FeedbackResult.almost
          ? () {
              skip = true;
              nav.pop();
            }
          : null,
    );
    if (!context.mounted) return;
    if (skip) {
      player.skipCamera();
    } else if (result == FeedbackResult.almost) {
      player.retry();
    } else {
      player.continueNext();
    }
  }

  String _message(Exercise e, FeedbackResult result) {
    final answer = switch (e) {
      final RecogniseExercise e => e.answer,
      final PickSignExercise e => e.meaning,
      final SignItExercise e => e.title,
      final FingerspellExercise e => e.word,
      WatchExercise() || MatchPairsExercise() => null,
    };
    return switch (result) {
      FeedbackResult.correct =>
        answer == null
            ? 'All pairs matched — $_xpCopy'
            : '“$answer” — $_xpCopy',
      FeedbackResult.incorrect => 'The answer is “$answer”.',
      FeedbackResult.almost => switch (e) {
        final SignItExercise e => e.almostHint,
        _ => 'Hold the handshape still for a moment.',
      },
    };
  }
}

class _PlayerPage extends StatelessWidget {
  const _PlayerPage({required this.state, required this.controller});

  final LessonPlayerState state;
  final _PlayerController controller;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final exercise = state.exercise;
    return Scaffold(
      backgroundColor: exercise.isCamera ? c.bgCamera : c.bgCanvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LessonProgressHeader(
              progress: state.progress,
              hearts: state.hearts,
              onClose: controller.close,
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: IsharaMotion.duration(context, IsharaMotion.standard),
                switchInCurve: IsharaMotion.enter,
                switchOutCurve: IsharaMotion.exit,
                child: KeyedSubtree(
                  key: ValueKey('${state.index}-${exercise.runtimeType}'),
                  child: _exercise(exercise),
                ),
              ),
            ),
            if (!exercise.isCamera)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: IsharaSpacing.screenMargin,
                  vertical: IsharaSpacing.s3,
                ),
                child: IsharaButton(
                  label: exercise is WatchExercise ? 'Continue' : 'Check',
                  onPressed:
                      state.phase == LessonPhase.answering && state.canCheck
                      ? controller.check
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _exercise(Exercise e) => switch (e) {
    final WatchExercise e => WatchExerciseView(exercise: e),
    final RecogniseExercise e => RecogniseExerciseView(
      exercise: e,
      state: state,
      onSelect: controller.player.select,
    ),
    final PickSignExercise e => PickSignExerciseView(
      exercise: e,
      state: state,
      onSelect: controller.player.select,
    ),
    final MatchPairsExercise e => MatchPairsExerciseView(
      exercise: e,
      state: state,
      onTapWord: (i) => controller.tapMatch(word: i),
      onTapVideo: (i) => controller.tapMatch(video: i),
    ),
    final SignItExercise e => SignItExerciseView(
      exercise: e,
      state: state,
      onSkip: controller.skipCamera,
      onResult: controller.cameraResult,
    ),
    final FingerspellExercise e => FingerspellExerciseView(
      exercise: e,
      state: state,
      onSkip: controller.skipCamera,
      onResult: controller.cameraResult,
    ),
  };
}
