import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import 'gallery_section.dart';
import 'widget_variant_sections.dart';

void _noop() {}
void _noopBool(bool _) {}
void _noopTab(IsharaTab _) {}

/// Fixed demo widths so placeholder art keeps its Figma proportions.
const double _phoneWidth = 412;
const double _videoLargeHeight = 272;
const double _videoLargeWidth = 364;
const double _videoTileWidth = 170;
const double _videoTileHeight = 148;
const double _cameraHeight = 560;
const double _heroHeight = 240;

// Long-lived so the demo text survives rebuilds (dev-only screen).
final _filledName = TextEditingController(text: 'Sita Sharma');
final _badEmail = TextEditingController(text: 'sita@');
final _password = TextEditingController(text: 'secret123');

/// One builder per shared widget (plus its added variants), in Figma
/// Components page order.
final List<WidgetBuilder> widgetSections = [
  _buttons,
  _googleSignIn,
  _textFields,
  textFieldSearch,
  _chips,
  chipFilters,
  _iconButtons,
  iconButtonCompact,
  _switches,
  _topAppBars,
  topAppBarNoTitle,
  _bottomBars,
  _statsBars,
  _lessonHeaders,
  _snackbars,
  _stepIndicators,
  stepIndicatorOnHero,
  _sectionHeaders,
  _pathNodes,
  _pathTooltips,
  _unitHeaders,
  _signVideoPlayers,
  _cameraFeeds,
  _handOverlays,
  _videoOptions,
  _answerOptions,
  _matchTiles,
  _feedbackSheets,
  _signListTiles,
  _leaderboardTiles,
  leaderboardAvatarName,
  _settingsTiles,
  settingsDestructiveAndGroup,
  _statCards,
  statCardTints,
  _selectionCards,
  _avatars,
  avatarOnHero,
  _mascots,
  danuWaving,
  _speechBubbles,
  _heroBackdrops,
  heroBackdropIntro,
  _contentPanels,
  _textLinks,
  _logos,
  logoOnHero,
];

Widget _gap([double h = IsharaSpacing.listGap]) => SizedBox(height: h);

/// Lays out [children] with a list gap between each.
List<Widget> _spaced(List<Widget> children) => [
  for (var i = 0; i < children.length; i++) ...[if (i > 0) _gap(), children[i]],
];

Widget _row(List<Widget> children) => Wrap(
  spacing: IsharaSpacing.s3,
  runSpacing: IsharaSpacing.s3,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: children,
);

/// Constrains a full-width phone component to the Figma frame width.
Widget _phone(Widget child) => Align(
  alignment: Alignment.centerLeft,
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: _phoneWidth),
    child: child,
  ),
);

Widget _darkOnly(Widget child) => Theme(data: AppTheme.dark, child: child);

Widget _buttons(BuildContext context) => GallerySection(
  title: 'IsharaButton',
  subtitle: 'variant × tone × icon × enabled',
  children: [
    for (final variant in IsharaButtonVariant.values) ...[
      GalleryCaption(variant.name),
      ..._spaced([
        for (final tone in IsharaButtonTone.values)
          IsharaButton(
            label: '${tone.name[0].toUpperCase()}${tone.name.substring(1)}',
            onPressed: _noop,
            variant: variant,
            tone: tone,
          ),
        IsharaButton(
          label: 'With icon',
          icon: IsharaIcons.camera,
          onPressed: _noop,
          variant: variant,
        ),
        IsharaButton(label: 'Disabled', onPressed: null, variant: variant),
        Align(
          alignment: Alignment.centerLeft,
          child: IsharaButton(
            label: 'Hug width',
            onPressed: _noop,
            variant: variant,
            expanded: false,
          ),
        ),
      ]),
    ],
  ],
);

Widget _googleSignIn(BuildContext context) => GallerySection(
  title: 'GoogleSignInButton',
  children: _spaced(const [
    GoogleSignInButton(onPressed: _noop),
    GoogleSignInButton(onPressed: null, label: 'Disabled'),
  ]),
);

Widget _textFields(BuildContext context) => GallerySection(
  title: 'IsharaTextField',
  subtitle: 'empty · filled · helper · error · password · disabled',
  children: _spaced([
    const IsharaTextField(
      label: 'Email',
      hint: 'you@example.com',
      prefixIcon: IsharaIcons.mail,
    ),
    IsharaTextField(label: 'Name', controller: _filledName),
    const IsharaTextField(
      label: 'Email',
      hint: 'you@example.com',
      helperText: 'We will send a reset link here',
    ),
    IsharaTextField(
      label: 'Email',
      controller: _badEmail,
      errorText: 'Enter a valid email address',
    ),
    IsharaTextField(
      label: 'Password',
      controller: _password,
      obscureText: true,
      suffixIcon: const Icon(IsharaIcons.eye),
    ),
    const IsharaTextField(
      label: 'Disabled',
      hint: 'Not editable',
      enabled: false,
    ),
  ]),
);

Widget _chips(BuildContext context) => GallerySection(
  title: 'IsharaChip',
  children: [
    _row([
      for (final tone in IsharaChipTone.values)
        IsharaChip(label: tone.name, tone: tone),
    ]),
    _gap(),
    _row([
      for (final tone in IsharaChipTone.values)
        IsharaChip(label: tone.name, tone: tone, icon: IsharaIcons.check),
    ]),
  ],
);

Widget _iconButtons(BuildContext context) => GallerySection(
  title: 'IsharaIconButton',
  children: [
    for (final variant in IsharaIconButtonVariant.values) ...[
      GalleryCaption(variant.name),
      _maybeOnCamera(
        variant == IsharaIconButtonVariant.onCamera,
        _row([
          IsharaIconButton(
            icon: IsharaIcons.close,
            tooltip: 'Enabled',
            onPressed: _noop,
            variant: variant,
          ),
          IsharaIconButton(
            icon: IsharaIcons.flipHorizontal,
            tooltip: 'Disabled',
            onPressed: null,
            variant: variant,
          ),
        ]),
      ),
    ],
  ],
);

/// `onCamera` icon buttons sit on the dark camera feed.
Widget _maybeOnCamera(bool onCamera, Widget child) {
  if (!onCamera) return child;
  return Builder(
    builder: (context) => _darkOnly(
      DecoratedBox(
        decoration: BoxDecoration(
          color: IsharaColors.dark.bgCanvas,
          borderRadius: IsharaRadius.brLg,
        ),
        child: Padding(
          padding: const EdgeInsets.all(IsharaSpacing.s3),
          child: child,
        ),
      ),
    ),
  );
}

Widget _switches(BuildContext context) => GallerySection(
  title: 'IsharaSwitch',
  children: [
    _row(const [
      IsharaSwitch(value: false, onChanged: _noopBool, semanticLabel: 'Off'),
      IsharaSwitch(value: true, onChanged: _noopBool, semanticLabel: 'On'),
      IsharaSwitch(
        value: false,
        onChanged: null,
        semanticLabel: 'Off, disabled',
      ),
      IsharaSwitch(value: true, onChanged: null, semanticLabel: 'On, disabled'),
    ]),
  ],
);

Widget _topAppBars(BuildContext context) => GallerySection(
  title: 'IsharaTopAppBar',
  children: _spaced([
    _phone(const IsharaTopAppBar(title: 'Settings', onLeading: _noop)),
    _phone(
      const IsharaTopAppBar(
        title: 'Thank you',
        leading: IsharaAppBarLeading.close,
        onLeading: _noop,
        action: IsharaAppBarAction(
          icon: IsharaIcons.search,
          tooltip: 'Search',
          onPressed: _noop,
        ),
      ),
    ),
  ]),
);

Widget _bottomBars(BuildContext context) => GallerySection(
  title: 'IsharaBottomBar',
  subtitle: 'active tab',
  children: _spaced([
    for (final tab in IsharaTab.values)
      _phone(
        IsharaBottomBar(
          current: tab,
          onTabSelected: _noopTab,
          onPractice: _noop,
        ),
      ),
  ]),
);

Widget _statsBars(BuildContext context) => GallerySection(
  title: 'StatsBar',
  children: _spaced([
    _phone(const StatsBar(streak: 12, xp: 340, hearts: 5, onCourse: _noop)),
    _phone(const StatsBar(streak: 0, xp: 0, hearts: 0, onCourse: _noop)),
  ]),
);

Widget _lessonHeaders(BuildContext context) => GallerySection(
  title: 'LessonProgressHeader',
  children: _spaced([
    for (final (p, h) in const [(0.0, 5), (0.4, 3), (1.0, 1), (0.6, 0)])
      _phone(LessonProgressHeader(progress: p, hearts: h, onClose: _noop)),
  ]),
);

Widget _snackbars(BuildContext context) => GallerySection(
  title: 'IsharaSnackbar',
  children: _spaced([
    _phone(const IsharaSnackbar(message: 'Saved for offline')),
    _phone(
      const IsharaSnackbar(
        message: "You're offline. Progress will sync later.",
        icon: IsharaIcons.wifiOff,
        actionLabel: 'Retry',
        onAction: _noop,
      ),
    ),
  ]),
);

Widget _stepIndicators(BuildContext context) => GallerySection(
  title: 'StepIndicator',
  children: _spaced([for (var i = 1; i <= 3; i++) StepIndicator(current: i)]),
);

Widget _sectionHeaders(BuildContext context) => GallerySection(
  title: 'SectionHeader',
  children: _spaced([
    _phone(const SectionHeader(title: 'Greetings')),
    _phone(
      const SectionHeader(
        title: 'Fingerspelling',
        actionLabel: 'See all',
        onAction: _noop,
      ),
    ),
  ]),
);

Widget _pathNodes(BuildContext context) => GallerySection(
  title: 'PathNode',
  children: [
    _row([
      for (final state in PathNodeState.values)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PathNode(state: state, label: state.name, onTap: _noop),
            _gap(IsharaSpacing.s1),
            Text(state.name, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
    ]),
  ],
);

Widget _pathTooltips(BuildContext context) => GallerySection(
  title: 'PathTooltip',
  children: [
    _row(const [PathTooltip(text: 'Start'), PathTooltip(text: 'Jump here?')]),
  ],
);

Widget _unitHeaders(BuildContext context) => GallerySection(
  title: 'UnitHeader',
  subtitle: 'colour',
  children: _spaced([
    for (final (i, color) in UnitColor.values.indexed)
      _phone(
        UnitHeader(
          unit: i + 1,
          title: 'Greetings & etiquette',
          learned: i * 3,
          total: 12,
          color: color,
          onGuide: _noop,
        ),
      ),
  ]),
);

Widget _signVideoPlayers(BuildContext context) => GallerySection(
  title: 'SignVideoPlayer',
  subtitle: 'size × slow-mo × mirror',
  children: [
    const GalleryCaption('large'),
    _row([
      for (final (slow, mirror) in const [(false, false), (true, true)])
        SizedBox(
          width: _videoLargeWidth,
          height: _videoLargeHeight,
          child: SignVideoPlayer(
            semanticLabel: 'Sign video',
            slowMotion: slow,
            mirrored: mirror,
            onReplay: _noop,
            onToggleSlowMotion: _noop,
            onToggleMirror: _noop,
          ),
        ),
    ]),
    const GalleryCaption('tile'),
    const SizedBox(
      width: _videoTileWidth,
      height: _videoTileHeight,
      child: SignVideoPlayer(
        semanticLabel: 'Sign video tile',
        size: SignVideoSize.tile,
        onReplay: _noop,
      ),
    ),
  ],
);

Widget _cameraFeeds(BuildContext context) => GallerySection(
  title: 'CameraFeed',
  subtitle: 'overlay (always dark theme)',
  children: [
    _darkOnly(
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final style in HandOverlayStyle.values)
              Padding(
                padding: const EdgeInsets.only(right: IsharaSpacing.s3),
                child: SizedBox(
                  width: _phoneWidth * 0.6,
                  height: _cameraHeight * 0.6,
                  child: CameraFeed(overlay: style),
                ),
              ),
          ],
        ),
      ),
    ),
  ],
);

Widget _handOverlays(BuildContext context) => GallerySection(
  title: 'HandLandmarkOverlay',
  subtitle: 'style · highlighted finger',
  children: [
    _darkOnly(
      DecoratedBox(
        decoration: BoxDecoration(
          color: IsharaColors.dark.bgCanvas,
          borderRadius: IsharaRadius.brLg,
        ),
        child: Padding(
          padding: const EdgeInsets.all(IsharaSpacing.s3),
          child: _row([
            for (final style in HandOverlayStyle.values)
              SizedBox(
                width: _videoTileWidth * 0.75,
                height: _videoTileWidth * 0.9,
                child: HandLandmarkOverlay(
                  style: style,
                  highlighted: style == HandOverlayStyle.hint
                      ? HandFinger.indexFinger.landmarks
                      : const {},
                ),
              ),
          ]),
        ),
      ),
    ),
  ],
);

Widget _videoOptions(BuildContext context) => GallerySection(
  title: 'VideoOption',
  subtitle: 'state',
  children: [
    _row([
      for (final state in AnswerState.values)
        SizedBox(
          width: _videoTileWidth,
          child: VideoOption(
            semanticLabel: state.name,
            onTap: _noop,
            state: state,
          ),
        ),
    ]),
  ],
);

Widget _answerOptions(BuildContext context) => GallerySection(
  title: 'AnswerOption',
  subtitle: 'state',
  children: _spaced([
    for (final state in AnswerState.values)
      _phone(AnswerOption(label: state.name, onTap: _noop, state: state)),
    _phone(const AnswerOption(label: 'disabled', onTap: null)),
  ]),
);

Widget _matchTiles(BuildContext context) => GallerySection(
  title: 'MatchTile',
  subtitle: 'state',
  children: [
    _row([
      for (final state in MatchTileState.values)
        SizedBox(
          width: _videoTileWidth,
          child: MatchTile(label: state.name, onTap: _noop, state: state),
        ),
    ]),
  ],
);

Widget _feedbackSheets(BuildContext context) => GallerySection(
  title: 'FeedbackSheet',
  subtitle: 'result',
  children: _spaced([
    for (final result in FeedbackResult.values)
      _phone(
        FeedbackSheet(
          result: result,
          message: 'Placeholder explanation text.',
          onContinue: _noop,
          secondaryLabel: result == FeedbackResult.almost
              ? 'Skip — I can’t use the camera now'
              : null,
          onSecondary: result == FeedbackResult.almost ? _noop : null,
        ),
      ),
  ]),
);

Widget _signListTiles(BuildContext context) => GallerySection(
  title: 'SignListTile',
  subtitle: 'status',
  children: _spaced([
    _phone(
      const SignListTile(title: 'Namaste', subtitle: 'Greetings', onTap: _noop),
    ),
    for (final tone in IsharaChipTone.values)
      _phone(
        SignListTile(
          title: 'Thank you',
          subtitle: 'Etiquette',
          onTap: _noop,
          statusLabel: tone.name,
          statusTone: tone,
        ),
      ),
  ]),
);

Widget _leaderboardTiles(BuildContext context) => GallerySection(
  title: 'LeaderboardTile',
  subtitle: 'rank 1–3 medals · default · me',
  children: _spaced([
    for (final rank in const [1, 2, 3, 4])
      _phone(
        LeaderboardTile(rank: rank, name: 'Learner $rank', xp: 900 - rank * 50),
      ),
    _phone(const LeaderboardTile(rank: 7, name: 'You', xp: 420, isMe: true)),
  ]),
);

Widget _settingsTiles(BuildContext context) => GallerySection(
  title: 'SettingsTile',
  subtitle: 'trailing',
  children: _spaced([
    _phone(
      const SettingsTile(
        icon: IsharaIcons.user,
        label: 'Account',
        onTap: _noop,
      ),
    ),
    _phone(
      const SettingsTile(
        icon: IsharaIcons.bell,
        label: 'Reminders',
        trailing: SettingsTrailing.toggle,
        switchValue: true,
        onSwitchChanged: _noopBool,
      ),
    ),
    _phone(
      const SettingsTile(
        icon: IsharaIcons.bell,
        label: 'Haptics',
        trailing: SettingsTrailing.toggle,
        onSwitchChanged: _noopBool,
      ),
    ),
    _phone(
      const SettingsTile(
        icon: IsharaIcons.target,
        label: 'Daily goal',
        trailing: SettingsTrailing.value,
        value: '10 min',
        onTap: _noop,
      ),
    ),
  ]),
);

Widget _statCards(BuildContext context) => GallerySection(
  title: 'StatCard',
  subtitle: 'icon kind',
  children: [
    _row([
      for (final kind in IsharaFilledIconKind.values)
        SizedBox(
          width: _videoTileWidth,
          child: StatCard(value: '12', caption: kind.name, kind: kind),
        ),
    ]),
  ],
);

Widget _selectionCards(BuildContext context) => GallerySection(
  title: 'SelectionCard',
  children: _spaced([
    for (final selected in const [false, true])
      _phone(
        SelectionCard(
          icon: IsharaIcons.hand,
          title: selected ? 'Selected' : 'Unselected',
          description: 'Right hand dominant',
          selected: selected,
          onTap: _noop,
        ),
      ),
    _phone(
      const SelectionCard(
        icon: IsharaIcons.hand,
        title: 'Disabled',
        description: 'Not available',
        selected: false,
        onTap: null,
      ),
    ),
  ]),
);

Widget _avatars(BuildContext context) => GallerySection(
  title: 'IsharaAvatar',
  subtitle: 'size (initials fallback)',
  children: [
    _row([
      for (final size in IsharaAvatarSize.values)
        IsharaAvatar(name: 'Sita Sharma', size: size),
    ]),
  ],
);

Widget _mascots(BuildContext context) => GallerySection(
  title: 'DanuMascot',
  subtitle: 'pose',
  children: [
    _row([
      for (final pose in DanuPose.values)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DanuMascot(pose: pose, size: IsharaSizes.mascot / 2),
            Text(pose.name, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
    ]),
  ],
);

Widget _speechBubbles(BuildContext context) => GallerySection(
  title: 'SpeechBubble',
  children: [_phone(const SpeechBubble(text: "Let's learn your first sign!"))],
);

Widget _heroBackdrops(BuildContext context) => GallerySection(
  title: 'HeroBackdrop',
  subtitle: 'layout',
  children: _spaced([
    for (final layout in HeroBackdropLayout.values)
      _phone(
        SizedBox(
          height: _heroHeight,
          child: HeroBackdrop(layout: layout),
        ),
      ),
  ]),
);

Widget _contentPanels(BuildContext context) => GallerySection(
  title: 'ContentPanel',
  children: [
    _phone(
      DecoratedBox(
        decoration: BoxDecoration(color: context.colors.bgCanvas),
        child: ContentPanel(
          children: [
            Text('Panel title', style: Theme.of(context).textTheme.titleLarge),
            const IsharaButton(label: 'Continue', onPressed: _noop),
          ],
        ),
      ),
    ),
  ],
);

Widget _textLinks(BuildContext context) => GallerySection(
  title: 'TextLinkCTA',
  children: [
    _row(const [
      TextLinkCTA(label: 'Forgot password?', onPressed: _noop),
      TextLinkCTA(label: 'Disabled', onPressed: null),
    ]),
  ],
);

Widget _logos(BuildContext context) => GallerySection(
  title: 'IsharaLogo',
  subtitle: 'variant',
  children: [
    _row([
      for (final variant in IsharaLogoVariant.values)
        IsharaLogo(variant: variant),
    ]),
  ],
);
