import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_summary_provider.g.dart';

/// A sign learned in the lesson (Figma 26 "Signs you learned").
typedef LearnedSign = ({String id, String name, String category});

/// What Figma "26 Lesson complete" shows (UI-only phase).
@immutable
class LessonSummary {
  const LessonSummary({
    required this.xp,
    required this.accuracy,
    required this.time,
    required this.newSigns,
    required this.signs,
  });

  /// XP earned (lesson reward + perfect bonus, awarded by the server).
  final int xp;

  /// 0–1 share of answers right first time.
  final double accuracy;
  final Duration time;

  /// Headline count ("You learned 5 new greetings.").
  final int newSigns;
  final List<LearnedSign> signs;
}

/// Hard-coded summary matching the Figma frame; the server's lesson
/// completion response replaces it when the data layer lands.
@riverpod
LessonSummary lessonSummary(Ref ref, String lessonId) => const LessonSummary(
  xp: 15,
  accuracy: 0.92,
  time: Duration(minutes: 4, seconds: 12),
  newSigns: 5,
  signs: [
    (id: 'namaste', name: 'Namaste', category: 'Greetings'),
    (id: 'thank-you', name: 'Thank you', category: 'Greetings'),
  ],
);
