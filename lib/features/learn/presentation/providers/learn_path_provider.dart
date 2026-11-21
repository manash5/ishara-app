import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/widgets/widgets.dart';

part 'learn_path_provider.g.dart';

/// One stop on the roadmap. UI-only stand-in until the `/path` API lands.
@immutable
class PathStop {
  const PathStop({
    required this.state,
    required this.title,
    this.lessonId,
    this.signs = 3,
    this.minutes = 5,
  });

  final PathNodeState state;

  /// Shown to screen readers and in the lesson sheet, e.g. "Namaste".
  final String title;

  /// Lessons open the lesson sheet; chests and checkpoints have none.
  final String? lessonId;

  /// Fake lesson size shown on the current-lesson card.
  final int signs;
  final int minutes;
}

/// One stage of the climb: its banner and its stops, first lesson first.
@immutable
class PathUnit {
  const PathUnit({
    required this.number,
    required this.title,
    required this.color,
    required this.learned,
    required this.total,
    required this.stops,
  });

  final int number;
  final String title;
  final UnitColor color;
  final int learned;
  final int total;
  final List<PathStop> stops;
}

/// Header stats on the Learn tab (Figma StatsBar 10:466).
typedef LearnStats = ({int streak, int xp, int hearts});

/// Fake roadmap: units 1–2 follow Figma "10 Learn" (10:509); units 3–4 are
/// locked so the path scrolls. Unit titles only — no sign descriptions.
@riverpod
List<PathUnit> learnPath(Ref ref) => const [
  PathUnit(
    number: 1,
    title: 'Greetings & etiquette',
    color: UnitColor.teal,
    learned: 4,
    total: 12,
    stops: [
      PathStop(
        state: PathNodeState.completed,
        title: 'Hello',
        lessonId: 'greetings-1',
      ),
      PathStop(
        state: PathNodeState.completed,
        title: 'Namaste',
        lessonId: 'greetings-2',
      ),
      PathStop(state: PathNodeState.chest, title: 'Reward chest'),
      PathStop(
        state: PathNodeState.review,
        title: 'Review greetings',
        lessonId: 'greetings-review-1',
      ),
      PathStop(
        state: PathNodeState.current,
        title: 'Thank you',
        lessonId: 'greetings-3',
      ),
      PathStop(
        state: PathNodeState.locked,
        title: 'Sorry',
        lessonId: 'greetings-4',
      ),
      PathStop(
        state: PathNodeState.locked,
        title: 'Please',
        lessonId: 'greetings-5',
      ),
      PathStop(state: PathNodeState.checkpoint, title: 'Summit'),
    ],
  ),
  PathUnit(
    number: 2,
    title: 'Fingerspelling vowels',
    color: UnitColor.lavender,
    learned: 0,
    total: 10,
    stops: [
      PathStop(state: PathNodeState.locked, title: 'अ and आ', lessonId: 'v-1'),
      PathStop(state: PathNodeState.locked, title: 'इ and ई', lessonId: 'v-2'),
      PathStop(state: PathNodeState.locked, title: 'उ and ऊ', lessonId: 'v-3'),
      PathStop(state: PathNodeState.chest, title: 'Reward chest'),
      PathStop(state: PathNodeState.locked, title: 'ए and ऐ', lessonId: 'v-4'),
      PathStop(state: PathNodeState.locked, title: 'ओ and औ', lessonId: 'v-5'),
      PathStop(state: PathNodeState.checkpoint, title: 'Summit'),
    ],
  ),
  PathUnit(
    number: 3,
    title: 'Fingerspelling consonants',
    color: UnitColor.mint,
    learned: 0,
    total: 12,
    stops: [
      PathStop(state: PathNodeState.locked, title: 'क to ङ', lessonId: 'c-1'),
      PathStop(state: PathNodeState.locked, title: 'च to ञ', lessonId: 'c-2'),
      PathStop(state: PathNodeState.locked, title: 'ट to ण', lessonId: 'c-3'),
      PathStop(state: PathNodeState.chest, title: 'Reward chest'),
      PathStop(state: PathNodeState.locked, title: 'त to न', lessonId: 'c-4'),
      PathStop(state: PathNodeState.checkpoint, title: 'Summit'),
    ],
  ),
  PathUnit(
    number: 4,
    title: 'Numbers 1–10',
    color: UnitColor.lime,
    learned: 0,
    total: 10,
    stops: [
      PathStop(state: PathNodeState.locked, title: '1 to 3', lessonId: 'n-1'),
      PathStop(state: PathNodeState.locked, title: '4 to 6', lessonId: 'n-2'),
      PathStop(state: PathNodeState.locked, title: '7 to 10', lessonId: 'n-3'),
      PathStop(state: PathNodeState.checkpoint, title: 'Summit'),
    ],
  ),
];

/// Fake header stats (Figma: 12-day streak, 340 XP, 5 hearts).
@riverpod
LearnStats learnStats(Ref ref) => (streak: 12, xp: 340, hearts: 5);

/// Fake connectivity for frame 12 (Learn – offline). Flip it from the debug
/// `/gallery` until real connectivity lands.
@Riverpod(keepAlive: true)
class LearnOffline extends _$LearnOffline {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}
