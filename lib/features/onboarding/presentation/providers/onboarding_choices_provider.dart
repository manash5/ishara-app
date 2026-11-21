import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_choices_provider.g.dart';

/// The hand a learner signs with (Figma "07 Dominant hand").
enum DominantHand { right, left }

/// What the learner picked during onboarding (UI-only phase).
///
/// [cameraAllowed] is null until "08 Camera permission" is answered; the
/// "Allow camera" answer is fake until the permission plugin lands.
typedef OnboardingChoicesState = ({
  String dailyGoalId,
  DominantHand hand,
  bool? cameraAllowed,
});

/// Stand-in for the onboarding answers until the `/me` repository lands.
/// Defaults match the Figma frames (Regular goal, right hand selected).
@Riverpod(keepAlive: true)
class OnboardingChoices extends _$OnboardingChoices {
  @override
  OnboardingChoicesState build() =>
      (dailyGoalId: 'regular', hand: DominantHand.right, cameraAllowed: null);

  void selectDailyGoal(String id) => state = (
    dailyGoalId: id,
    hand: state.hand,
    cameraAllowed: state.cameraAllowed,
  );

  void selectHand(DominantHand hand) => state = (
    dailyGoalId: state.dailyGoalId,
    hand: hand,
    cameraAllowed: state.cameraAllowed,
  );

  void setCameraAllowed(bool allowed) => state = (
    dailyGoalId: state.dailyGoalId,
    hand: state.hand,
    cameraAllowed: allowed,
  );
}
