import 'package:material_ui/material_ui.dart';

/// Hidden `v3/*` primitives from the Figma "Primitives" collection.
///
/// Private on purpose: widgets use the semantic [IsharaColors] tokens only.
abstract final class _P {
  static const teal975 = Color(0xFF0B1F21);
  static const teal960 = Color(0xFF0B2224);
  static const teal950 = Color(0xFF0F2A2D);
  static const teal925 = Color(0xFF0F2E31);
  static const teal900 = Color(0xFF163A3E);
  static const teal875 = Color(0xFF173D41);
  static const teal850 = Color(0xFF1C4448);
  static const teal825 = Color(0xFF1E474B);
  static const teal800 = Color(0xFF1F4D52);
  static const teal775 = Color(0xFF22504F);
  static const teal750 = Color(0xFF2B5A5E);
  static const teal700 = Color(0xFF3A6A6E);

  static const grey0 = Color(0xFFFFFFFF);
  static const grey25 = Color(0xFFF5F7F6);
  static const grey30 = Color(0xFFF1F7F4);
  static const grey50 = Color(0xFFEEF2F1);
  static const grey75 = Color(0xFFEAEFEE);
  static const grey80 = Color(0xFFE4EFED);
  static const grey100 = Color(0xFFE1E7E6);
  static const grey200 = Color(0xFFCBD5D4);
  static const grey250 = Color(0xFFC3CFCE);
  static const grey350 = Color(0xFFA8C1BE);
  static const grey400 = Color(0xFFA0AFB0);
  static const grey550 = Color(0xFF6E8C8A);
  static const grey600 = Color(0xFF5F7476);
  static const grey1000 = Color(0xFF000000);

  static const lime300 = Color(0xFFD3F56B);
  static const lime400 = Color(0xFFC6F04D);
  static const lime500 = Color(0xFFB2DC38);
  static const lime600 = Color(0xFF9CC427);
  static const lime700 = Color(0xFF8FB51F);

  static const green50 = Color(0xFFE3F7EA);
  static const green300 = Color(0xFF7FE0A6);
  static const green400 = Color(0xFF5ED38B);
  static const green500 = Color(0xFF4CC97E);
  static const green600 = Color(0xFF3DAE6A);
  static const green650 = Color(0xFF2FA35E);
  static const green800 = Color(0xFF237A47);
  static const green950 = Color(0xFF1A4A36);

  static const red50 = Color(0xFFFDE8E4);
  static const red300 = Color(0xFFFF9A88);
  static const red400 = Color(0xFFFF7A64);
  static const red500 = Color(0xFFF2654E);
  static const red600 = Color(0xFFD9503B);
  static const red650 = Color(0xFFCC4733);
  static const red800 = Color(0xFFB83A27);
  static const red950 = Color(0xFF4A2620);

  static const lavender50 = Color(0xFFEFE9FC);
  static const lavender400 = Color(0xFFC4ADF5);
  static const lavender500 = Color(0xFFB79CF0);
  static const lavender600 = Color(0xFF9479D4);
  static const lavender950 = Color(0xFF33305A);

  static const peach50 = Color(0xFFFFF0E6);
  static const peach400 = Color(0xFFFFD2B8);
  static const peach500 = Color(0xFFFFC7A6);
  static const peach600 = Color(0xFFE8A07A);
  static const peach950 = Color(0xFF4A3A33);

  static const amber400 = Color(0xFFFFBE45);
  static const amber500 = Color(0xFFFFB020);
  static const amber600 = Color(0xFFD98E00);

  static const mint50 = Color(0xFFE4F7EC);
  static const mint400 = Color(0xFF9DEABF);
  static const mint500 = Color(0xFF8BE3B0);
  static const mint600 = Color(0xFF5CC48A);
  static const mint950 = Color(0xFF1D4A3D);
}

/// Semantic colour tokens — Figma collection "Color" (modes Light / Dark).
///
/// Figma `group/name-x` → Dart `groupNameX`. Read via `context.colors`.
/// `*Lip` tokens are only for the gamified roadmap kit (PathNode, PathTooltip,
/// UnitHeader, StatsBar).
@immutable
class IsharaColors extends ThemeExtension<IsharaColors> {
  const IsharaColors({
    required this.bgCanvas,
    required this.bgSurface,
    required this.bgSurfaceMuted,
    required this.bgSurfaceRaised,
    required this.bgInverse,
    required this.bgCamera,
    required this.borderSubtle,
    required this.borderDefault,
    required this.borderStrong,
    required this.borderLip,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textInverse,
    required this.textOnAccent,
    required this.accentDefault,
    required this.accentPressed,
    required this.accentSubtle,
    required this.accentText,
    required this.accentLip,
    required this.successDefault,
    required this.successSubtle,
    required this.successText,
    required this.successLip,
    required this.dangerDefault,
    required this.dangerSubtle,
    required this.dangerText,
    required this.dangerLip,
    required this.overlayScrim,
    required this.staticWhite,
    required this.funLavender,
    required this.funLavenderLip,
    required this.funLavenderSubtle,
    required this.funGold,
    required this.funGoldLip,
    required this.funLime,
    required this.funLimeLip,
    required this.funPeach,
    required this.funPeachLip,
    required this.funPeachSubtle,
    required this.funMint,
    required this.funMintLip,
    required this.funMintSubtle,
    required this.funTealHero,
    required this.funTealHeroLip,
  });

  final Color bgCanvas;
  final Color bgSurface;
  final Color bgSurfaceMuted;
  final Color bgSurfaceRaised;
  final Color bgInverse;
  final Color bgCamera;
  final Color borderSubtle;
  final Color borderDefault;
  final Color borderStrong;
  final Color borderLip;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textInverse;
  final Color textOnAccent;
  final Color accentDefault;
  final Color accentPressed;
  final Color accentSubtle;
  final Color accentText;
  final Color accentLip;
  final Color successDefault;
  final Color successSubtle;
  final Color successText;
  final Color successLip;
  final Color dangerDefault;
  final Color dangerSubtle;
  final Color dangerText;
  final Color dangerLip;

  /// Opaque in Figma — apply the opacity at the use site (e.g. `withValues(alpha: .6)`).
  final Color overlayScrim;
  final Color staticWhite;
  final Color funLavender;
  final Color funLavenderLip;
  final Color funLavenderSubtle;
  final Color funGold;
  final Color funGoldLip;
  final Color funLime;
  final Color funLimeLip;
  final Color funPeach;
  final Color funPeachLip;
  final Color funPeachSubtle;
  final Color funMint;
  final Color funMintLip;
  final Color funMintSubtle;
  final Color funTealHero;
  final Color funTealHeroLip;

  static const light = IsharaColors(
    bgCanvas: _P.grey25,
    bgSurface: _P.grey0,
    bgSurfaceMuted: _P.grey50,
    bgSurfaceRaised: _P.grey0,
    bgInverse: _P.teal900,
    bgCamera: _P.teal975,
    borderSubtle: _P.grey75,
    borderDefault: _P.grey100,
    borderStrong: _P.grey250,
    borderLip: _P.grey200,
    textPrimary: _P.teal900,
    textSecondary: _P.grey600,
    textTertiary: _P.grey400,
    textInverse: _P.grey0,
    textOnAccent: _P.grey0,
    accentDefault: _P.teal800,
    accentPressed: _P.teal875,
    accentSubtle: _P.grey80,
    accentText: _P.teal800,
    accentLip: _P.teal925,
    successDefault: _P.green500,
    successSubtle: _P.green50,
    successText: _P.green800,
    successLip: _P.green650,
    dangerDefault: _P.red500,
    dangerSubtle: _P.red50,
    dangerText: _P.red800,
    dangerLip: _P.red650,
    overlayScrim: _P.teal975,
    staticWhite: _P.grey0,
    funLavender: _P.lavender500,
    funLavenderLip: _P.lavender600,
    funLavenderSubtle: _P.lavender50,
    funGold: _P.amber500,
    funGoldLip: _P.amber600,
    funLime: _P.lime400,
    funLimeLip: _P.lime600,
    funPeach: _P.peach500,
    funPeachLip: _P.peach600,
    funPeachSubtle: _P.peach50,
    funMint: _P.mint500,
    funMintLip: _P.mint600,
    funMintSubtle: _P.mint50,
    funTealHero: _P.teal800,
    funTealHeroLip: _P.teal925,
  );

  static const dark = IsharaColors(
    bgCanvas: _P.teal950,
    bgSurface: _P.teal900,
    bgSurfaceMuted: _P.teal825,
    bgSurfaceRaised: _P.teal775,
    bgInverse: _P.grey30,
    bgCamera: _P.grey1000,
    borderSubtle: _P.teal850,
    borderDefault: _P.teal750,
    borderStrong: _P.teal700,
    borderLip: _P.teal960,
    textPrimary: _P.grey30,
    textSecondary: _P.grey350,
    textTertiary: _P.grey550,
    textInverse: _P.teal900,
    textOnAccent: _P.teal900,
    accentDefault: _P.lime400,
    accentPressed: _P.lime500,
    accentSubtle: _P.teal775,
    accentText: _P.lime400,
    accentLip: _P.lime700,
    successDefault: _P.green400,
    successSubtle: _P.green950,
    successText: _P.green300,
    successLip: _P.green600,
    dangerDefault: _P.red400,
    dangerSubtle: _P.red950,
    dangerText: _P.red300,
    dangerLip: _P.red600,
    overlayScrim: _P.grey1000,
    staticWhite: _P.grey0,
    funLavender: _P.lavender400,
    funLavenderLip: _P.lavender600,
    funLavenderSubtle: _P.lavender950,
    funGold: _P.amber400,
    funGoldLip: _P.amber600,
    funLime: _P.lime300,
    funLimeLip: _P.lime600,
    funPeach: _P.peach400,
    funPeachLip: _P.peach600,
    funPeachSubtle: _P.peach950,
    funMint: _P.mint400,
    funMintLip: _P.mint600,
    funMintSubtle: _P.mint950,
    funTealHero: _P.teal800,
    funTealHeroLip: _P.teal925,
  );

  /// Every token by its Figma name — used by the dev gallery and tests.
  Map<String, Color> get byFigmaName => {
    'bg/canvas': bgCanvas,
    'bg/surface': bgSurface,
    'bg/surface-muted': bgSurfaceMuted,
    'bg/surface-raised': bgSurfaceRaised,
    'bg/inverse': bgInverse,
    'bg/camera': bgCamera,
    'border/subtle': borderSubtle,
    'border/default': borderDefault,
    'border/strong': borderStrong,
    'border/lip': borderLip,
    'text/primary': textPrimary,
    'text/secondary': textSecondary,
    'text/tertiary': textTertiary,
    'text/inverse': textInverse,
    'text/on-accent': textOnAccent,
    'accent/default': accentDefault,
    'accent/pressed': accentPressed,
    'accent/subtle': accentSubtle,
    'accent/text': accentText,
    'accent/lip': accentLip,
    'success/default': successDefault,
    'success/subtle': successSubtle,
    'success/text': successText,
    'success/lip': successLip,
    'danger/default': dangerDefault,
    'danger/subtle': dangerSubtle,
    'danger/text': dangerText,
    'danger/lip': dangerLip,
    'overlay/scrim': overlayScrim,
    'static/white': staticWhite,
    'fun/lavender': funLavender,
    'fun/lavender-lip': funLavenderLip,
    'fun/lavender-subtle': funLavenderSubtle,
    'fun/gold': funGold,
    'fun/gold-lip': funGoldLip,
    'fun/lime': funLime,
    'fun/lime-lip': funLimeLip,
    'fun/peach': funPeach,
    'fun/peach-lip': funPeachLip,
    'fun/peach-subtle': funPeachSubtle,
    'fun/mint': funMint,
    'fun/mint-lip': funMintLip,
    'fun/mint-subtle': funMintSubtle,
    'fun/teal-hero': funTealHero,
    'fun/teal-hero-lip': funTealHeroLip,
  };

  @override
  IsharaColors copyWith({
    Color? bgCanvas,
    Color? bgSurface,
    Color? bgSurfaceMuted,
    Color? bgSurfaceRaised,
    Color? bgInverse,
    Color? bgCamera,
    Color? borderSubtle,
    Color? borderDefault,
    Color? borderStrong,
    Color? borderLip,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textInverse,
    Color? textOnAccent,
    Color? accentDefault,
    Color? accentPressed,
    Color? accentSubtle,
    Color? accentText,
    Color? accentLip,
    Color? successDefault,
    Color? successSubtle,
    Color? successText,
    Color? successLip,
    Color? dangerDefault,
    Color? dangerSubtle,
    Color? dangerText,
    Color? dangerLip,
    Color? overlayScrim,
    Color? staticWhite,
    Color? funLavender,
    Color? funLavenderLip,
    Color? funLavenderSubtle,
    Color? funGold,
    Color? funGoldLip,
    Color? funLime,
    Color? funLimeLip,
    Color? funPeach,
    Color? funPeachLip,
    Color? funPeachSubtle,
    Color? funMint,
    Color? funMintLip,
    Color? funMintSubtle,
    Color? funTealHero,
    Color? funTealHeroLip,
  }) {
    return IsharaColors(
      bgCanvas: bgCanvas ?? this.bgCanvas,
      bgSurface: bgSurface ?? this.bgSurface,
      bgSurfaceMuted: bgSurfaceMuted ?? this.bgSurfaceMuted,
      bgSurfaceRaised: bgSurfaceRaised ?? this.bgSurfaceRaised,
      bgInverse: bgInverse ?? this.bgInverse,
      bgCamera: bgCamera ?? this.bgCamera,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderDefault: borderDefault ?? this.borderDefault,
      borderStrong: borderStrong ?? this.borderStrong,
      borderLip: borderLip ?? this.borderLip,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textInverse: textInverse ?? this.textInverse,
      textOnAccent: textOnAccent ?? this.textOnAccent,
      accentDefault: accentDefault ?? this.accentDefault,
      accentPressed: accentPressed ?? this.accentPressed,
      accentSubtle: accentSubtle ?? this.accentSubtle,
      accentText: accentText ?? this.accentText,
      accentLip: accentLip ?? this.accentLip,
      successDefault: successDefault ?? this.successDefault,
      successSubtle: successSubtle ?? this.successSubtle,
      successText: successText ?? this.successText,
      successLip: successLip ?? this.successLip,
      dangerDefault: dangerDefault ?? this.dangerDefault,
      dangerSubtle: dangerSubtle ?? this.dangerSubtle,
      dangerText: dangerText ?? this.dangerText,
      dangerLip: dangerLip ?? this.dangerLip,
      overlayScrim: overlayScrim ?? this.overlayScrim,
      staticWhite: staticWhite ?? this.staticWhite,
      funLavender: funLavender ?? this.funLavender,
      funLavenderLip: funLavenderLip ?? this.funLavenderLip,
      funLavenderSubtle: funLavenderSubtle ?? this.funLavenderSubtle,
      funGold: funGold ?? this.funGold,
      funGoldLip: funGoldLip ?? this.funGoldLip,
      funLime: funLime ?? this.funLime,
      funLimeLip: funLimeLip ?? this.funLimeLip,
      funPeach: funPeach ?? this.funPeach,
      funPeachLip: funPeachLip ?? this.funPeachLip,
      funPeachSubtle: funPeachSubtle ?? this.funPeachSubtle,
      funMint: funMint ?? this.funMint,
      funMintLip: funMintLip ?? this.funMintLip,
      funMintSubtle: funMintSubtle ?? this.funMintSubtle,
      funTealHero: funTealHero ?? this.funTealHero,
      funTealHeroLip: funTealHeroLip ?? this.funTealHeroLip,
    );
  }

  @override
  IsharaColors lerp(covariant ThemeExtension<IsharaColors>? other, double t) {
    if (other is! IsharaColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return IsharaColors(
      bgCanvas: l(bgCanvas, other.bgCanvas),
      bgSurface: l(bgSurface, other.bgSurface),
      bgSurfaceMuted: l(bgSurfaceMuted, other.bgSurfaceMuted),
      bgSurfaceRaised: l(bgSurfaceRaised, other.bgSurfaceRaised),
      bgInverse: l(bgInverse, other.bgInverse),
      bgCamera: l(bgCamera, other.bgCamera),
      borderSubtle: l(borderSubtle, other.borderSubtle),
      borderDefault: l(borderDefault, other.borderDefault),
      borderStrong: l(borderStrong, other.borderStrong),
      borderLip: l(borderLip, other.borderLip),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textTertiary: l(textTertiary, other.textTertiary),
      textInverse: l(textInverse, other.textInverse),
      textOnAccent: l(textOnAccent, other.textOnAccent),
      accentDefault: l(accentDefault, other.accentDefault),
      accentPressed: l(accentPressed, other.accentPressed),
      accentSubtle: l(accentSubtle, other.accentSubtle),
      accentText: l(accentText, other.accentText),
      accentLip: l(accentLip, other.accentLip),
      successDefault: l(successDefault, other.successDefault),
      successSubtle: l(successSubtle, other.successSubtle),
      successText: l(successText, other.successText),
      successLip: l(successLip, other.successLip),
      dangerDefault: l(dangerDefault, other.dangerDefault),
      dangerSubtle: l(dangerSubtle, other.dangerSubtle),
      dangerText: l(dangerText, other.dangerText),
      dangerLip: l(dangerLip, other.dangerLip),
      overlayScrim: l(overlayScrim, other.overlayScrim),
      staticWhite: l(staticWhite, other.staticWhite),
      funLavender: l(funLavender, other.funLavender),
      funLavenderLip: l(funLavenderLip, other.funLavenderLip),
      funLavenderSubtle: l(funLavenderSubtle, other.funLavenderSubtle),
      funGold: l(funGold, other.funGold),
      funGoldLip: l(funGoldLip, other.funGoldLip),
      funLime: l(funLime, other.funLime),
      funLimeLip: l(funLimeLip, other.funLimeLip),
      funPeach: l(funPeach, other.funPeach),
      funPeachLip: l(funPeachLip, other.funPeachLip),
      funPeachSubtle: l(funPeachSubtle, other.funPeachSubtle),
      funMint: l(funMint, other.funMint),
      funMintLip: l(funMintLip, other.funMintLip),
      funMintSubtle: l(funMintSubtle, other.funMintSubtle),
      funTealHero: l(funTealHero, other.funTealHero),
      funTealHeroLip: l(funTealHeroLip, other.funTealHeroLip),
    );
  }
}
