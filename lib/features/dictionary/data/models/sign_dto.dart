import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/sign.dart';

part 'sign_dto.freezed.dart';
part 'sign_dto.g.dart';

/// Sign JSON (docs/api-contract.md → Sign).
@freezed
abstract class SignDto with _$SignDto {
  const SignDto._();

  const factory SignDto({
    required String id,
    required String name,
    required String category,
    required String status,
    String? videoUrl,
    String? meaning,
    @Default([]) List<String> steps,
    String? etiquetteTip,
  }) = _SignDto;

  factory SignDto.fromJson(Map<String, dynamic> json) =>
      _$SignDtoFromJson(json);

  Sign toEntity() => Sign(
    id: id,
    name: name,
    category: SignCategory.values.byName(category),
    status: switch (status) {
      'learned' => SignStatus.learned,
      'practising' => SignStatus.practising,
      _ => SignStatus.newSign,
    },
    videoUrl: videoUrl,
    meaning: meaning,
    steps: steps,
    etiquetteTip: etiquetteTip,
  );
}
