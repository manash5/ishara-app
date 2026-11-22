/// Monday-first day labels for week views (Profile 16 weekly XP chart,
/// Streak 27 week row). UI is English (CLAUDE.md).
abstract final class Weekdays {
  /// "M", "T", "W", "T", "F", "S", "S".
  static const List<String> initials = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  /// Full names for screen readers.
  static const List<String> names = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
}
