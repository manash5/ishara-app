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

  // Overlay opacity of the onCamera icon-button scrim.
  static const double cameraScrimOpacity = 0.4;
}
