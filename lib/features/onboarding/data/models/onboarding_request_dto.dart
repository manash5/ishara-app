import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/onboarding_answers.dart';

part 'onboarding_request_dto.freezed.dart';
part 'onboarding_request_dto.g.dart';

/// `POST /me/onboarding` body (docs/api-contract.md → Profile).
@freezed
abstract class OnboardingRequestDto with _$OnboardingRequestDto {
  const factory OnboardingRequestDto({
    required int dailyGoalMinutes,
    required String dominantHand,
    required String timezone,
  }) = _OnboardingRequestDto;

  factory OnboardingRequestDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingRequestDtoFromJson(json);

  factory OnboardingRequestDto.fromEntity(OnboardingAnswers answers) =>
      OnboardingRequestDto(
        dailyGoalMinutes: answers.dailyGoalMinutes,
        dominantHand: answers.dominantHand.name,
        timezone: answers.timezone,
      );
}
