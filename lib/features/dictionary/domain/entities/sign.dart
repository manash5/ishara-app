import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign.freezed.dart';

/// Dictionary groupings shown as filter chips (Figma "13 Dictionary").
enum SignCategory {
  greetings('Greetings'),
  alphabet('Alphabet'),
  numbers('Numbers'),
  etiquette('Etiquette'),
  questions('Questions');

  const SignCategory(this.label);
  final String label;
}

/// The learner's progress on a sign (Figma `SignListTile` status chip).
enum SignStatus {
  learned('Learned'),
  practising('Practising'),
  newSign('New');

  const SignStatus(this.label);
  final String label;
}

/// One NSL sign (`GET /signs`, `GET /signs/:id`). Owned by **dictionary**;
/// also used by lesson (signs learned, exercise sign ids).
///
/// [meaning] and [steps] stay empty until the text is verified against the
/// NDFN NSL dictionary (CLAUDE.md content rule). [videoUrl] is a short-lived
/// signed URL — never cache it.
@freezed
abstract class Sign with _$Sign {
  const factory Sign({
    required String id,
    required String name,
    required SignCategory category,
    required SignStatus status,
    String? videoUrl,
    String? meaning,
    @Default([]) List<String> steps,

    /// About Deaf culture, not how the sign is formed.
    String? etiquetteTip,
  }) = _Sign;
}
