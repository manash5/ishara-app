import 'package:flutter/foundation.dart';

import '../../domain/entities/sign.dart';

export '../../domain/entities/sign.dart';

/// One dictionary row: the domain [Sign].
typedef DictionarySign = Sign;

/// Everything Figma "14 Sign detail" shows for one sign.
///
/// [meaning] and [steps] stay empty until the text is verified against the
/// NDFN NSL dictionary (CLAUDE.md content rule) — the screen then shows a
/// clearly marked placeholder instead.
@immutable
class SignDetail {
  const SignDetail({
    required this.sign,
    this.meaning,
    this.steps = const [],
    this.etiquetteTip,
  });

  factory SignDetail.fromSign(Sign sign) => SignDetail(
    sign: sign,
    meaning: sign.meaning,
    steps: sign.steps,
    etiquetteTip: sign.etiquetteTip,
  );

  final Sign sign;
  final String? meaning;
  final List<String> steps;
  final String? etiquetteTip;
}
