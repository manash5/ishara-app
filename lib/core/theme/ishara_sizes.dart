/// Component dimensions read from the Figma Components page.
///
/// Spacing and radius come from [IsharaSpacing] / [IsharaRadius]; this file
/// holds the remaining fixed sizes so widgets carry no magic numbers.
abstract final class IsharaSizes {
  // Controls.
  static const double controlHeight = 56;
  static const double minTouch = 48;
  static const double appBarHeight = 64;
  static const double chipHeight = 24;
  static const double listTileHeight = 72;
  static const double compactTileHeight = 64;
  static const double settingsTileHeight = 56;

  // Off-scale paddings used by Figma components.
  static const double chipPaddingX = 10;
  static const double filterChipHeight = 32; // IsharaChip.filter (12:846)
  static const double filterChipPaddingX = 14;
  static const double snackbarPaddingY = 14;
  static const double titleGap = 2; // title → subtitle in tiles/cards
  static const double ctaUnderlineGap = 6;

  // Icons.
  static const double iconXs = 14;
  static const double iconSm = 16;
  static const double settingsIcon = 18;
  static const double iconMd = 20;
  static const double signThumbIcon = 22;
  static const double iconLg = 24;

  // Icon boxes, thumbnails, avatars.
  static const double iconBoxSm = 36;
  static const double iconBoxMd = 40;
  static const double signThumb = 48;
  static const double avatarSm = 40;
  static const double avatarLg = 72;
  static const double radio = 22;

  // Switch (M3 dimensions, as in Figma).
  static const double switchWidth = 52;
  static const double switchHeight = 32;

  // StepIndicator.
  static const double stepBarHeight = 8;
  static const double stepBarActive = 28;
  static const double stepBarInactive = 12;
  static const double stepGap = 6;

  // Strokes.
  static const double outline = 1.5;
  static const double selectedBorder = 2;
  static const double underline = 3;

  // SpeechBubble.
  static const double bubbleTailWidth = 14;
  static const double bubbleTailHeight = 22;
  static const double bubbleLip = 4;

  // Logo.
  static const double logoMark = 48;
  static const double logoLockupMark = 36;
  static const double logoLockupGap = 10;

  // Roadmap kit (gamified / 3D lip style).
  static const double lipCard = 4; // UnitHeader, guide button
  static const double lipBadge = 3; // StatsBar course badge
  static const double lipNode = 6; // PathNode
  static const double pathNode = 72;
  static const double pathNodeHalo = 96;
  static const double pathNodeHaloStroke = 6;
  static const double pathNodeIcon = 30;
  static const double pathNodeCheck = 34;
  static const double pathNodeStar = 32;
  static const double courseBadgeWidth = 48;
  static const double courseBadgeHeight = 36;
  static const double tooltipArrowWidth = 14;
  static const double tooltipArrowHeight = 8;
  static const double tooltipPaddingX = 14;
  static const double statsBarHeight = 56;
  static const double statsGap = 20;
  static const double statsIconGap = 6;
  static const double unitHeaderPaddingLeft = 18;
  static const double unitHeaderPaddingBottom = 20;
  static const double guidePaddingX = 10;
  static const double mascot = 200;

  // Bottom bar (ui.md + Figma AppNavigationBar).
  static const double bottomBarRadius = 24;
  static const double bottomBarPaddingTop = 12;
  static const double bottomBarPaddingBottom = 10;

  /// Figma draws the Android gesture handle inside the bar (14 gap + 4
  /// handle) above [bottomBarPaddingBottom]. The system paints the handle
  /// itself, so the bar only reserves its space.
  static const double bottomBarGestureArea = 18;

  /// Figma `AppNavigationBar` height (12 + 52 + 18 + 10).
  static const double bottomBarHeight = 92;
  static const double bottomBarTabHeight = 52;
  static const double practiceButton = 52;

  /// Bottom padding screens need so content clears the bottom bar.
  static const double bottomBarContentPadding = 112;

  // Lesson.
  static const double lessonHeaderHeight = 64;
  static const double progressBarHeight = 10;
  static const double answerOptionHeight = 60;
  static const double answerIcon = 22;
  static const double answerPaddingX = 20;
  static const double feedbackBadge = 40;

  /// Square hero badge: Camera permission (08) camera badge and the Ranks
  /// (15) league badge share 56dp with a 28dp icon.
  static const double heroBadge = 56;
  static const double heroBadgeIcon = 28;
  static const double tipIcon = 20; // Watch & learn tip card (18)
  static const double referencePipWidth = 93.5; // Sign it reference video (23)
  static const double letterTileWidth = 72; // Fingerspell letters (25)
  static const double letterTileHeight = 84;
  static const double letterTileGlyph = 44;
  static const double letterTileGlyphLine = 52;
  static const double dialogWidth = 312; // AlertDialog (29)
  static const double sheetHeart = 22; // Out of hearts sheet (28)
  static const double sheetHeartGap = 6;

  // Lesson results (26–27).
  static const double resultBadge = 64;
  static const double resultBadgeIcon = 32;
  static const double streakHero = 128;
  static const double streakDay = 32;
  static const double streakDayGap = 6;
  static const double resultMascot = 96;
  static const double resultMascotLarge = 112; // 26, straddling the panel

  /// 26 hero: space above the badge row, so it sits below the backdrop's
  /// lavender circle (it ends 124dp down, the status bar included).
  static const double resultHeroTop = 96;

  /// 26 hero: space under the subtitle (more teal before the panel).
  static const double resultHeroBottom = 64;

  /// How far Danu on 26 rises above the results panel (the rest overlaps
  /// the panel's top, beside "Your results"). A little more than
  /// [resultHeroBottom], so Danu sits just under the title.
  static const double resultMascotOverlap = 76;

  /// 27 hero: teal under "day streak" (less than 26, so Danu, level with
  /// the text, reaches the panel).
  static const double streakHeroBottom = 40;

  /// 27: how far Danu's box drops into the results panel.
  static const double streakMascotDip = 16;

  /// 27: Danu at the hero's right edge (a little bigger than on 26).
  static const double streakMascot = 128;
  static const double streakNumber = 56; // 27 hero count (56/64 ExtraBold)
  static const double streakNumberLine = 64;

  // Video & camera.
  static const double videoControl = 40;
  static const double videoControlIcon = 18;
  static const double videoTilePlay = 28;
  static const double videoTilePlayIcon = 12;
  static const double videoOptionPadding = 4;

  // Hand landmarks (Figma HandOverlay, drawn on a 200x240 frame).
  static const double landmarkBone = 4;
  static const double landmarkGhostBone = 5;
  static const double landmarkJointRadius = 5.5;
  static const double landmarkWristRadius = 7;
  static const double landmarkJointStroke = 3;

  // Overlay opacity of the onCamera icon-button scrim.
  static const double cameraScrimOpacity = 0.4;

  // Other opacities from Figma.
  static const double placeholderOpacity = 0.12; // CameraFeed silhouette
  static const double ghostOpacity = 0.6; // HandOverlay/Ghost
  static const double subtitleOpacity = 0.9; // UnitHeader subtitle
  static const double matchedOpacity = 0.45; // MatchTile matched
  static const double heroCaptionOpacity =
      0.7; // white captions on HeroBackdrop

  /// SettingsTile icon box corner (Figma 10; not on the radius scale).
  static const double iconBoxRadius = 10;
}
