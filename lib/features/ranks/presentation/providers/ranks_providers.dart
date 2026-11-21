import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranks_providers.g.dart';

/// One leaderboard row. UI-only stand-in until the domain entity exists.
@immutable
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.name,
    required this.xp,
    this.isMe = false,
    this.avatarName,
  });

  final String name;
  final int xp;
  final bool isMe;

  /// Initials source when [name] is a label like "You" (Figma 12:1252: "ML").
  final String? avatarName;
}

/// This week's league (Figma "15 Ranks"). [entries] are sorted by XP, rank 1
/// first; the top [promotionCount] move up to [nextLeagueName].
@immutable
class WeeklyLeaderboard {
  const WeeklyLeaderboard({
    required this.leagueName,
    required this.nextLeagueName,
    required this.weekNumber,
    required this.learnerCount,
    required this.endsIn,
    required this.promotionCount,
    required this.xpToPromotion,
    required this.entries,
  });

  final String leagueName;
  final String nextLeagueName;
  final int weekNumber;
  final int learnerCount;
  final Duration endsIn;
  final int promotionCount;

  /// XP the learner still needs, as computed by the backend.
  final int xpToPromotion;
  final List<LeaderboardEntry> entries;
}

/// Fake weekly league for the UI-only phase (Figma copy).
const fakeWeeklyLeaderboard = WeeklyLeaderboard(
  leagueName: 'Bronze',
  nextLeagueName: 'Silver',
  weekNumber: 12,
  learnerCount: 30,
  endsIn: Duration(days: 3, hours: 14),
  promotionCount: 5,
  xpToPromotion: 60,
  entries: [
    LeaderboardEntry(name: 'Sujata R.', xp: 620),
    LeaderboardEntry(name: 'Bibek T.', xp: 585),
    LeaderboardEntry(name: 'Anisha K.', xp: 540),
    LeaderboardEntry(
      name: 'You',
      xp: 480,
      isMe: true,
      avatarName: 'Manash Lamichhane',
    ),
    LeaderboardEntry(name: 'Prakash G.', xp: 455),
    LeaderboardEntry(name: 'Rina M.', xp: 410),
    LeaderboardEntry(name: 'Suman B.', xp: 380),
    LeaderboardEntry(name: 'Nabin S.', xp: 345),
    LeaderboardEntry(name: 'Asmita P.', xp: 310),
    LeaderboardEntry(name: 'Kiran D.', xp: 270),
  ],
);

/// The learner's weekly league (fake; a repository replaces this later).
@riverpod
Future<WeeklyLeaderboard> weeklyLeaderboard(Ref ref) async =>
    fakeWeeklyLeaderboard;

/// "3d 14h", "5h 20m", "45m" — the countdown chip text.
String formatTimeLeft(Duration d) {
  final days = d.inDays;
  final hours = d.inHours % 24;
  final minutes = d.inMinutes % 60;
  if (days > 0) return '${days}d ${hours}h';
  if (hours > 0) return '${hours}h ${minutes}m';
  return '${minutes}m';
}
