// Freezed puts @JsonSerializable on the factory.
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/profile_update.dart';

part 'profile_update_dto.freezed.dart';
part 'profile_update_dto.g.dart';

/// `PUT /me` body: only the fields that change (docs/api-contract.md).
@freezed
abstract class ProfileUpdateDto with _$ProfileUpdateDto {
  @JsonSerializable(includeIfNull: false)
  const factory ProfileUpdateDto({
    String? displayName,
    int? dailyGoalMinutes,
    String? dominantHand,
    String? timezone,
  }) = _ProfileUpdateDto;

  factory ProfileUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateDtoFromJson(json);

  factory ProfileUpdateDto.fromEntity(ProfileUpdate update) => ProfileUpdateDto(
    displayName: update.displayName?.trim(),
    dailyGoalMinutes: update.dailyGoalMinutes,
    dominantHand: update.dominantHand?.name,
    timezone: update.timezone,
  );
}
