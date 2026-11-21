import 'package:flutter/foundation.dart';

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

/// One dictionary row. UI-only stand-in until the domain entity exists.
@immutable
class DictionarySign {
  const DictionarySign({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
  });

  final String id;
  final String name;
  final SignCategory category;
  final SignStatus status;
}

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

  final DictionarySign sign;
  final String? meaning;
  final List<String> steps;
  final String? etiquetteTip;
}
