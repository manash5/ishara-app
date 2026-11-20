import 'package:material_ui/material_ui.dart';

/// Bundled font family names (see pubspec.yaml).
abstract final class IsharaFonts {
  static const String sans = 'PlusJakartaSans';
  static const String devanagari = 'AnekDevanagari';
}

/// Figma letter spacing is a % of font size; Flutter wants logical px.
double _tracking(double size, double percent) => size * percent / 100;

TextStyle _sans(
  double size,
  double lineHeight,
  FontWeight weight, {
  double trackingPercent = 0,
}) => TextStyle(
  fontFamily: IsharaFonts.sans,
  fontSize: size,
  height: lineHeight / size,
  fontWeight: weight,
  letterSpacing: _tracking(size, trackingPercent),
  leadingDistribution: TextLeadingDistribution.even,
);

/// Text styles — Figma local text styles. Colourless: colour comes from the
/// theme's [TextTheme] or the caller. Read via `context.textStyles`.
@immutable
class IsharaTextStyles extends ThemeExtension<IsharaTextStyles> {
  const IsharaTextStyles({
    required this.displaySmall,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.stat,
    required this.glyph,
  });

  /// display/small — 32/40 ExtraBold, −1.5%.
  final TextStyle displaySmall;

  /// headline/small — 26/32 Bold, −0.5%.
  final TextStyle headlineSmall;

  /// title/large — 20/28 Bold.
  final TextStyle titleLarge;

  /// title/medium — 17/24 SemiBold.
  final TextStyle titleMedium;

  /// body/large — 16/24 Regular.
  final TextStyle bodyLarge;

  /// body/medium — 15/22 Regular.
  final TextStyle bodyMedium;

  /// body/small — 13/18 Medium.
  final TextStyle bodySmall;

  /// label/large — 15/20 SemiBold, sentence case (buttons).
  final TextStyle labelLarge;

  /// label/medium — 13/16 SemiBold.
  final TextStyle labelMedium;

  /// label/small — 11/14 Bold, +4%. Figma sets this style to UPPER case,
  /// which a [TextStyle] cannot express: call `.toUpperCase()` on the string.
  final TextStyle labelSmall;

  /// custom/stat — 22/28 ExtraBold, −0.5% (XP, streak, hearts numbers).
  final TextStyle stat;

  /// custom/glyph — 88/96 Anek Devanagari SemiBold (Nepali letters).
  final TextStyle glyph;

  static final IsharaTextStyles standard = IsharaTextStyles(
    displaySmall: _sans(32, 40, FontWeight.w800, trackingPercent: -1.5),
    headlineSmall: _sans(26, 32, FontWeight.w700, trackingPercent: -0.5),
    titleLarge: _sans(20, 28, FontWeight.w700),
    titleMedium: _sans(17, 24, FontWeight.w600),
    bodyLarge: _sans(16, 24, FontWeight.w400),
    bodyMedium: _sans(15, 22, FontWeight.w400),
    bodySmall: _sans(13, 18, FontWeight.w500),
    labelLarge: _sans(15, 20, FontWeight.w600),
    labelMedium: _sans(13, 16, FontWeight.w600),
    labelSmall: _sans(11, 14, FontWeight.w700, trackingPercent: 4),
    stat: _sans(22, 28, FontWeight.w800, trackingPercent: -0.5),
    glyph: const TextStyle(
      fontFamily: IsharaFonts.devanagari,
      fontSize: 88,
      height: 96 / 88,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      // Variable font: pin the wght axis so SemiBold renders on every engine.
      fontVariations: [FontVariation.weight(600)],
      leadingDistribution: TextLeadingDistribution.even,
    ),
  );

  /// Figma name → style, for the dev gallery and tests.
  Map<String, TextStyle> get byFigmaName => {
    'display/small': displaySmall,
    'headline/small': headlineSmall,
    'title/large': titleLarge,
    'title/medium': titleMedium,
    'body/large': bodyLarge,
    'body/medium': bodyMedium,
    'body/small': bodySmall,
    'label/large': labelLarge,
    'label/medium': labelMedium,
    'label/small': labelSmall,
    'custom/stat': stat,
    'custom/glyph': glyph,
  };

  @override
  IsharaTextStyles copyWith({
    TextStyle? displaySmall,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    TextStyle? stat,
    TextStyle? glyph,
  }) {
    return IsharaTextStyles(
      displaySmall: displaySmall ?? this.displaySmall,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
      stat: stat ?? this.stat,
      glyph: glyph ?? this.glyph,
    );
  }

  @override
  IsharaTextStyles lerp(
    covariant ThemeExtension<IsharaTextStyles>? other,
    double t,
  ) {
    if (other is! IsharaTextStyles) return this;
    TextStyle l(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return IsharaTextStyles(
      displaySmall: l(displaySmall, other.displaySmall),
      headlineSmall: l(headlineSmall, other.headlineSmall),
      titleLarge: l(titleLarge, other.titleLarge),
      titleMedium: l(titleMedium, other.titleMedium),
      bodyLarge: l(bodyLarge, other.bodyLarge),
      bodyMedium: l(bodyMedium, other.bodyMedium),
      bodySmall: l(bodySmall, other.bodySmall),
      labelLarge: l(labelLarge, other.labelLarge),
      labelMedium: l(labelMedium, other.labelMedium),
      labelSmall: l(labelSmall, other.labelSmall),
      stat: l(stat, other.stat),
      glyph: l(glyph, other.glyph),
    );
  }
}
