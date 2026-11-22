import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/services/connectivity/connectivity_service.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_hero.dart';
import '../widgets/weekly_xp_chart.dart';

/// "1240" → "1,240".
String groupThousands(int n) =>
    n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

/// Figma "16 Profile" (Light 12:1337 · Dark 60:6904): tab root in the
/// bottom-bar shell — hero identity header, stats grid and this week's XP.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final summary = ref.watch(profileSummaryProvider);
    final p = summary.value;
    if (p == null) {
      return Scaffold(
        backgroundColor: c.bgSurface,
        body: LoadStateView(
          error: summary.error,
          errorTitle: 'Couldn’t load your profile',
          onRetry: () => ref.invalidate(userProfileProvider),
          loadingLabel: 'Loading your profile',
        ),
      );
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // White status bar icons over the teal hero in both themes.
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: c.bgSurface,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            // ContentPanel already pads 24 and is shifted up by the sheet radius.
            bottom:
                IsharaSizes.bottomBarContentPadding -
                IsharaSpacing.screenMargin -
                IsharaRadius.sheet,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHero(
                name: p.name,
                joined: p.joined,
                onSettings: () => const SettingsRoute().push<void>(context),
              ),
              Transform.translate(
                offset: const Offset(0, -IsharaRadius.sheet),
                child: ContentPanel(
                  children: [
                    const SectionHeader(title: 'Your stats'),
                    if (ref.watch(isOnlineProvider).value == false)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: IsharaSpacing.s3,
                          ),
                          child: IsharaChip(
                            key: const Key('profile-offline-chip'),
                            label: offlineUpdatedLabel(
                              ref.watch(profileLastUpdatedProvider),
                            ),
                            icon: IsharaIcons.wifiOff,
                            tone: IsharaChipTone.neutral,
                          ),
                        ),
                      ),
                    _StatsGrid(profile: p),
                    Padding(
                      padding: const EdgeInsets.only(top: IsharaSpacing.s2),
                      child: SectionHeader(
                        title: 'This week',
                        actionLabel: 'Details',
                        onAction: () => IsharaSnackbar.show(
                          context,
                          message: 'Detailed stats are coming soon.',
                        ),
                      ),
                    ),
                    WeeklyXpChart(
                      weeklyXp: p.weeklyXp,
                      todayIndex: p.todayIndex,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.profile});

  final ProfileSummary profile;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // Figma fills: 12:1361 peach, 12:1375 mint, the others lavender.
    final cards = [
      StatCard(
        value: '${profile.streakDays}',
        caption: 'Day streak',
        tint: StatCardTint.peach,
      ),
      StatCard(
        value: groupThousands(profile.totalXp),
        caption: 'Total XP',
        kind: IsharaFilledIconKind.zap,
      ),
      StatCard(
        value: '${profile.signsLearned}',
        caption: 'Signs learned',
        icon: IsharaIcons.hand,
        iconColor: c.accentText,
        tint: StatCardTint.mint,
      ),
      StatCard(
        value: '${(profile.cameraAccuracy * 100).round()}%',
        caption: 'Camera accuracy',
        icon: IsharaIcons.target,
        iconColor: c.textPrimary,
      ),
    ];
    Widget row(Widget a, Widget b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: a),
          const SizedBox(width: IsharaSpacing.listGap),
          Expanded(child: b),
        ],
      ),
    );
    return Column(
      children: [
        row(cards[0], cards[1]),
        const SizedBox(height: IsharaSpacing.listGap),
        row(cards[2], cards[3]),
      ],
    );
  }
}
