import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/services/connectivity/connectivity_service.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/ranks_providers.dart';
import '../widgets/league_header.dart';
import '../widgets/leaderboard_parts.dart';

/// Figma "15 Ranks" (Light 12:1204 · Dark 60:6872): a tab root in the
/// bottom-bar shell. League hero header, then a content panel with the
/// promotion banner and the weekly XP leaderboard.
class RanksScreen extends ConsumerWidget {
  const RanksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(weeklyLeaderboardProvider);
    final data = board.hasValue ? board.value : null;

    final List<Widget> panel = switch (board) {
      AsyncValue(hasValue: true, value: final b?) =>
        b.entries.isEmpty
            ? const [
                StateMessage(
                  title: 'No one here yet',
                  body: 'Finish a lesson to join this week’s league.',
                ),
              ]
            : [
                if (ref.watch(isOnlineProvider).value == false)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: IsharaSpacing.s3),
                      child: IsharaChip(
                        key: const Key('ranks-offline-chip'),
                        label: offlineUpdatedLabel(
                          ref.watch(leaderboardLastUpdatedProvider),
                        ),
                        icon: IsharaIcons.wifiOff,
                        tone: IsharaChipTone.neutral,
                      ),
                    ),
                  ),
                LeagueBanner(
                  text:
                      'Top ${b.promotionCount} move up to ${b.nextLeagueName}. '
                      'You’re ${b.xpToPromotion} XP away.',
                ),
                _Leaderboard(board: b),
              ],
      AsyncValue(hasError: true) => [
        StateMessage(
          title: 'Couldn’t load the leaderboard',
          body: 'Check your connection and try again.',
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(weeklyLeaderboardProvider),
        ),
      ],
      _ => const [
        ListSkeleton(
          itemHeight: IsharaSizes.compactTileHeight,
          semanticLabel: 'Loading leaderboard',
          count: 7,
          gap: IsharaSpacing.s1,
        ),
      ],
    };

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.colors.bgSurface,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom:
                IsharaSizes.bottomBarContentPadding -
                IsharaSpacing.screenMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (data != null)
                LeagueHeader(
                  title: '${data.leagueName} league',
                  subtitle:
                      'Week ${data.weekNumber} · '
                      '${data.learnerCount} learners',
                  countdown:
                      'Ends in '
                      '${formatTimeLeft(data.endsAt.difference(DateTime.now()))}',
                )
              else
                const LeagueHeader(title: 'Ranks', badge: false),
              ContentPanel(children: panel),
            ],
          ),
        ),
      ),
    );
  }
}

/// Figma `list` (12:1222): 4dp-spaced [LeaderboardTile]s with the
/// promotion-zone line after the top [WeeklyLeaderboard.promotionCount].
class _Leaderboard extends StatelessWidget {
  const _Leaderboard({required this.board});

  final WeeklyLeaderboard board;

  @override
  Widget build(BuildContext context) {
    final entries = board.entries;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          if (i > 0) const SizedBox(height: IsharaSpacing.s1),
          if (i == board.promotionCount) ...[
            const PromotionZoneDivider(),
            const SizedBox(height: IsharaSpacing.s1),
          ],
          LeaderboardTile(
            rank: i + 1,
            // Figma labels the learner's own row "You".
            name: entries[i].isMe ? 'You' : entries[i].displayName,
            xp: entries[i].xp,
            isMe: entries[i].isMe,
            avatarName: entries[i].isMe ? entries[i].displayName : null,
          ),
        ],
      ],
    );
  }
}
