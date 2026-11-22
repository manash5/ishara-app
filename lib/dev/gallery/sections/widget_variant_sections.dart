import 'package:material_ui/material_ui.dart';

import '../../../core/error/failure.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import 'gallery_section.dart';

/// Gallery sections for the variants added for screens 01–17 (filter chips,
/// on-hero styles, tints…), shown right after their base widget.

void _noop() {}

const double _phoneWidth = 412;

Widget _phone(Widget child) => Align(
  alignment: Alignment.centerLeft,
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: _phoneWidth),
    child: child,
  ),
);

/// Teal hero strip for on-hero variants.
Widget _onHero(BuildContext context, Widget child) => DecoratedBox(
  decoration: BoxDecoration(
    color: context.colors.funTealHero,
    borderRadius: IsharaRadius.brLg,
  ),
  child: Padding(
    padding: const EdgeInsets.all(IsharaSpacing.cardPadding),
    child: child,
  ),
);

Widget buttonTextToneCompact(BuildContext context) => GallerySection(
  title: 'IsharaButton · text tone + compact',
  subtitle: '48dp dialog actions; danger label (29 Quit lesson)',
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const IsharaButton(
          label: 'Quit',
          variant: IsharaButtonVariant.text,
          tone: IsharaButtonTone.danger,
          compact: true,
          expanded: false,
          onPressed: _noop,
        ),
        const SizedBox(width: IsharaSpacing.s2),
        const IsharaButton(
          label: 'Keep learning',
          variant: IsharaButtonVariant.text,
          compact: true,
          expanded: false,
          onPressed: _noop,
        ),
      ],
    ),
  ],
);

Widget textFieldSearch(BuildContext context) => GallerySection(
  title: 'IsharaTextField · search',
  subtitle: 'showLabel: false + compact clear button',
  children: [
    _phone(
      IsharaTextField(
        label: 'Search signs',
        showLabel: false,
        hint: 'Search signs',
        prefixIcon: IsharaIcons.search,
        suffixIcon: IsharaIconButton(
          icon: IsharaIcons.close,
          tooltip: 'Clear search',
          color: context.colors.textSecondary,
          compact: true,
          onPressed: _noop,
        ),
      ),
    ),
  ],
);

Widget chipFilters(BuildContext context) => GallerySection(
  title: 'IsharaChip.filter',
  subtitle: 'selected · unselected · 48dp target',
  children: [
    Wrap(
      spacing: IsharaSpacing.inlineGap,
      children: [
        IsharaChip.filter(label: 'All', selected: true, onTap: _noop),
        IsharaChip.filter(label: 'Greetings', selected: false, onTap: _noop),
        IsharaChip.filter(label: 'Alphabet', selected: false, onTap: _noop),
      ],
    ),
  ],
);

Widget iconButtonCompact(BuildContext context) => GallerySection(
  title: 'IsharaIconButton · compact',
  children: [
    IsharaIconButton(
      icon: IsharaIcons.eye,
      tooltip: 'Show password',
      color: context.colors.textSecondary,
      compact: true,
      onPressed: _noop,
    ),
  ],
);

Widget topAppBarNoTitle(BuildContext context) => GallerySection(
  title: 'IsharaTopAppBar · no title',
  children: [_phone(const IsharaTopAppBar(onLeading: _noop))],
);

Widget stepIndicatorOnHero(BuildContext context) => GallerySection(
  title: 'StepIndicator · onHero',
  children: [
    _onHero(
      context,
      Row(
        children: [
          for (var i = 1; i <= 3; i++) ...[
            StepIndicator(current: i, onHero: true),
            const SizedBox(width: IsharaSpacing.s6),
          ],
        ],
      ),
    ),
  ],
);

Widget leaderboardAvatarName(BuildContext context) => GallerySection(
  title: 'LeaderboardTile · avatarName',
  subtitle: '"You" with the learner\'s initials',
  children: [
    _phone(
      const LeaderboardTile(
        rank: 4,
        name: 'You',
        xp: 480,
        isMe: true,
        avatarName: 'Manash Lamichhane',
      ),
    ),
  ],
);

Widget settingsDestructiveAndGroup(BuildContext context) => GallerySection(
  title: 'SettingsGroup · SettingsTile destructive',
  children: [
    _phone(
      const SettingsGroup(
        title: 'Account',
        tiles: [
          SettingsTile(
            icon: IsharaIcons.shieldCheck,
            label: 'Privacy & data',
            onTap: _noop,
          ),
          SettingsTile(
            icon: IsharaIcons.logOut,
            label: 'Log out',
            destructive: true,
            onTap: _noop,
          ),
        ],
      ),
    ),
  ],
);

Widget statCardTints(BuildContext context) => GallerySection(
  title: 'StatCard · tint',
  children: [
    Wrap(
      spacing: IsharaSpacing.s3,
      runSpacing: IsharaSpacing.s3,
      children: [
        for (final tint in StatCardTint.values)
          SizedBox(
            width: 170,
            child: StatCard(value: '12', caption: tint.name, tint: tint),
          ),
      ],
    ),
  ],
);

Widget avatarOnHero(BuildContext context) => GallerySection(
  title: 'IsharaAvatar · onHero',
  children: [
    _onHero(
      context,
      const IsharaAvatar(
        name: 'Manash Lamichhane',
        size: IsharaAvatarSize.large,
        onHero: true,
      ),
    ),
  ],
);

Widget heroBackdropIntro(BuildContext context) => const GallerySection(
  title: 'HeroBackdrop · intro',
  subtitle: 'Splash entrance; tap replay',
  children: [_HeroIntroDemo()],
);

Widget logoOnHero(BuildContext context) => GallerySection(
  title: 'IsharaLogo · scale + onHero + intro',
  subtitle: 'Splash lockup; tap replay for the Danphe intro',
  children: [_onHero(context, const _LogoIntroDemo())],
);

class _LogoIntroDemo extends StatefulWidget {
  const _LogoIntroDemo();

  @override
  State<_LogoIntroDemo> createState() => _LogoIntroDemoState();
}

class _LogoIntroDemoState extends State<_LogoIntroDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: IsharaMotion.celebrate * 3,
    value: 1,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IsharaLogo(
          variant: IsharaLogoVariant.lockup,
          scale: 1.6,
          onHero: true,
          intro: _controller,
        ),
        const SizedBox(height: IsharaSpacing.s4),
        IsharaButton(
          label: 'Replay intro',
          icon: IsharaIcons.rotateCcw,
          expanded: false,
          onPressed: () => _controller.forward(from: 0),
        ),
      ],
    );
  }
}

class _HeroIntroDemo extends StatefulWidget {
  const _HeroIntroDemo();

  @override
  State<_HeroIntroDemo> createState() => _HeroIntroDemoState();
}

class _HeroIntroDemoState extends State<_HeroIntroDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: IsharaMotion.celebrate * 3,
    value: 1,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _phone(
          SizedBox(
            height: 320,
            child: HeroBackdrop(
              layout: HeroBackdropLayout.welcome,
              intro: _controller,
            ),
          ),
        ),
        const SizedBox(height: IsharaSpacing.s2),
        IsharaButton(
          label: 'Replay intro',
          icon: IsharaIcons.rotateCcw,
          variant: IsharaButtonVariant.outlined,
          expanded: false,
          onPressed: () => _controller.forward(from: 0),
        ),
      ],
    );
  }
}

Widget danuWaving(BuildContext context) => const GallerySection(
  title: 'DanuMascot · animated',
  subtitle: 'Waving loop (roadmap); still with reduced motion',
  children: [DanuMascot(pose: DanuPose.wave, size: 160, animated: true)],
);

// ── Shared widgets consolidated from features ───────────────────────────────

Widget sharedSignVideo(BuildContext context) => GallerySection(
  title: 'SignVideo',
  subtitle:
      'SignVideoPlayer that keeps its own slow-mo / mirror state '
      '(Dictionary 14, lesson 18–19); tap the controls',
  children: [_phone(const SignVideo(semanticLabel: 'Sign video: Namaste'))],
);

Widget sharedOutOfHearts(BuildContext context) => GallerySection(
  title: 'OutOfHeartsPanel',
  subtitle:
      '28 Out of hearts: sheet over the lesson, or the /out-of-hearts '
      'route',
  children: [
    _phone(const OutOfHeartsPanel(onPractise: _noop, onEndLesson: _noop)),
  ],
);

Widget sharedStateMessage(BuildContext context) => GallerySection(
  title: 'StateMessage',
  subtitle: 'empty / error state (Dictionary, Ranks); no Figma component yet',
  children: [
    _phone(
      const StateMessage(
        title: 'No signs yet',
        body: 'Signs you can learn will appear here.',
      ),
    ),
    _phone(
      const StateMessage(
        title: 'Couldn’t load signs',
        body: 'Check your connection and try again.',
        actionLabel: 'Try again',
        onAction: _noop,
      ),
    ),
  ],
);

Widget sharedListSkeleton(BuildContext context) => GallerySection(
  title: 'ListSkeleton',
  subtitle:
      'loading rows: SignListTile height (Dictionary), compact '
      'LeaderboardTile height (Ranks)',
  children: [
    _phone(
      const ListSkeleton(
        itemHeight: IsharaSizes.listTileHeight,
        semanticLabel: 'Loading signs',
        count: 3,
      ),
    ),
    const SizedBox(height: IsharaSpacing.s4),
    _phone(
      const ListSkeleton(
        itemHeight: IsharaSizes.compactTileHeight,
        semanticLabel: 'Loading leaderboard',
        count: 3,
        gap: IsharaSpacing.s1,
      ),
    ),
  ],
);

Widget sharedLoadStateView(BuildContext context) => GallerySection(
  title: 'LoadStateView',
  subtitle: 'whole-screen loading skeleton, and the error with Try again',
  children: [
    _phone(
      LoadStateView(
        error: null,
        errorTitle: 'Couldn’t load your path',
        onRetry: () {},
        loadingLabel: 'Loading your path',
      ),
    ),
    const SizedBox(height: IsharaSpacing.s4),
    _phone(
      LoadStateView(
        error: const NetworkFailure(),
        errorTitle: 'Couldn’t load your path',
        onRetry: () {},
        loadingLabel: 'Loading your path',
      ),
    ),
  ],
);

Widget sharedConfirmDialog(BuildContext context) => GallerySection(
  title: 'ConfirmDialog',
  subtitle:
      'asks before an irreversible action (29 quit lesson, delete account)',
  children: [
    ConfirmDialog(
      title: 'Delete your account?',
      body:
          'This permanently deletes your account, progress and streak from '
          'Ishara. You can’t undo this.',
      confirmLabel: 'Delete account',
      cancelLabel: 'Cancel',
      onConfirm: () {},
      onCancel: () {},
    ),
  ],
);

Widget sharedResultsDanu(BuildContext context) => GallerySection(
  title: 'ResultsScaffold · ResultsDanu',
  subtitle:
      'Lesson complete (26) / Streak (27): Danu pops in, then waves; '
      'ResultsScaffold is full-screen (see the lesson flow)',
  children: [
    _onHero(
      context,
      const Align(alignment: Alignment.centerLeft, child: ResultsDanu()),
    ),
  ],
);
