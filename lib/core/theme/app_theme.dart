import 'package:material_ui/material_ui.dart';

import 'ishara_colors.dart';
import 'ishara_elevation.dart';
import 'ishara_motion.dart';
import 'ishara_radius.dart';
import 'ishara_spacing.dart';
import 'ishara_text_styles.dart';
import 'ishara_text_theme.dart';

/// Light and dark [ThemeData] built from the Figma tokens.
abstract final class AppTheme {
  static final ThemeData light = _build(
    Brightness.light,
    IsharaColors.light,
    inverseAccent: IsharaColors.dark.accentDefault,
  );

  static final ThemeData dark = _build(
    Brightness.dark,
    IsharaColors.dark,
    inverseAccent: IsharaColors.light.accentDefault,
  );

  /// Hairline border width for outlined controls (Figma: 1.5px border/default).
  static const double outlineWidth = 1.5;

  static ColorScheme colorScheme(
    Brightness brightness,
    IsharaColors c, {
    required Color inverseAccent,
  }) {
    return ColorScheme(
      brightness: brightness,
      primary: c.accentDefault,
      onPrimary: c.textOnAccent,
      primaryContainer: c.accentSubtle,
      onPrimaryContainer: c.accentText,
      secondary: c.funLavender,
      onSecondary: c.textOnAccent,
      secondaryContainer: c.funLavenderSubtle,
      onSecondaryContainer: c.textPrimary,
      tertiary: c.funGold,
      onTertiary: c.funTealHero,
      error: c.dangerDefault,
      onError: brightness == Brightness.light ? c.staticWhite : c.textOnAccent,
      errorContainer: c.dangerSubtle,
      onErrorContainer: c.dangerText,
      surface: c.bgSurface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceDim: c.bgCanvas,
      surfaceBright: c.bgSurfaceRaised,
      surfaceContainerLowest: c.bgSurface,
      surfaceContainerLow: c.bgCanvas,
      surfaceContainer: c.bgSurfaceMuted,
      surfaceContainerHigh: c.bgSurfaceRaised,
      surfaceContainerHighest: c.bgSurfaceRaised,
      outline: c.borderDefault,
      outlineVariant: c.borderSubtle,
      inverseSurface: c.bgInverse,
      onInverseSurface: c.textInverse,
      inversePrimary: inverseAccent,
      scrim: c.overlayScrim,
      shadow: IsharaElevation.shadowColor,
      surfaceTint: Colors.transparent,
    );
  }

  static ThemeData _build(
    Brightness brightness,
    IsharaColors c, {
    required Color inverseAccent,
  }) {
    final styles = IsharaTextStyles.standard;
    final scheme = colorScheme(brightness, c, inverseAccent: inverseAccent);
    final textTheme = buildIsharaTextTheme(
      styles,
      body: c.textPrimary,
      display: c.textPrimary,
    );

    const buttonShape = RoundedRectangleBorder(borderRadius: IsharaRadius.brLg);
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: IsharaSpacing.s6,
      vertical: IsharaSpacing.s3,
    );
    const minButtonSize = Size(IsharaSpacing.s12, IsharaSpacing.s12);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: IsharaFonts.sans,
      textTheme: textTheme,
      scaffoldBackgroundColor: c.bgCanvas,
      canvasColor: c.bgCanvas,
      dividerColor: c.borderSubtle,
      splashFactory: InkSparkle.splashFactory,
      extensions: [c, styles],
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.accentDefault,
          foregroundColor: c.textOnAccent,
          disabledBackgroundColor: c.bgSurfaceMuted,
          disabledForegroundColor: c.textTertiary,
          textStyle: styles.labelLarge,
          shape: buttonShape,
          padding: buttonPadding,
          minimumSize: minButtonSize,
          elevation: 0,
          animationDuration: IsharaMotion.instant,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.accentText,
          disabledForegroundColor: c.textTertiary,
          textStyle: styles.labelLarge,
          shape: buttonShape,
          padding: buttonPadding,
          minimumSize: minButtonSize,
          side: BorderSide(color: c.borderDefault, width: outlineWidth),
          animationDuration: IsharaMotion.instant,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.accentText,
          disabledForegroundColor: c.textTertiary,
          textStyle: styles.labelLarge,
          shape: buttonShape,
          padding: buttonPadding,
          minimumSize: minButtonSize,
          animationDuration: IsharaMotion.instant,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.bgSurface,
        contentPadding: const EdgeInsets.all(IsharaSpacing.s4),
        hintStyle: styles.bodyLarge.copyWith(color: c.textTertiary),
        labelStyle: styles.bodyMedium.copyWith(color: c.textSecondary),
        border: OutlineInputBorder(
          borderRadius: IsharaRadius.brMd,
          borderSide: BorderSide(color: c.borderDefault, width: outlineWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: IsharaRadius.brMd,
          borderSide: BorderSide(color: c.borderDefault, width: outlineWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: IsharaRadius.brMd,
          borderSide: BorderSide(color: c.accentDefault, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: IsharaRadius.brMd,
          borderSide: BorderSide(color: c.dangerDefault, width: outlineWidth),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: IsharaRadius.brMd,
          borderSide: BorderSide(color: c.dangerDefault, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: c.bgSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: IsharaRadius.brLg,
          side: BorderSide(color: c.borderSubtle),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.bgSurface,
        modalBackgroundColor: c.bgSurface,
        showDragHandle: true,
        dragHandleColor: c.borderStrong,
        shape: const RoundedRectangleBorder(
          borderRadius: IsharaRadius.sheetTop,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.bgSurface,
        shape: const RoundedRectangleBorder(borderRadius: IsharaRadius.brSheet),
        titleTextStyle: styles.titleLarge.copyWith(color: c.textPrimary),
        contentTextStyle: styles.bodyMedium.copyWith(color: c.textSecondary),
      ),
      dividerTheme: DividerThemeData(color: c.borderSubtle, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.bgInverse,
        contentTextStyle: styles.bodyMedium.copyWith(color: c.textInverse),
        shape: const RoundedRectangleBorder(borderRadius: IsharaRadius.brMd),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.bgCanvas,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: styles.titleLarge.copyWith(color: c.textPrimary),
      ),
    );
  }
}
