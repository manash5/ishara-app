import '../../../../core/widgets/widgets.dart';
import '../providers/lesson_models.dart';

/// The [AnswerState] of option [i] in recognise / pick the sign.
///
/// Answering: the pick is lavender. After a correct check the answer turns
/// success (20); after a wrong one the pick turns danger (and shakes) and the
/// right answer shows in success. Out of hearts (28) keeps the pick.
AnswerState optionState(LessonPlayerState s, int i, int answerIndex) {
  if (s.phase == LessonPhase.feedback) {
    if (i == answerIndex) return AnswerState.correct;
    if (s.feedback == FeedbackResult.incorrect && i == s.selected) {
      return AnswerState.wrong;
    }
    return AnswerState.idle;
  }
  return i == s.selected ? AnswerState.selected : AnswerState.idle;
}
