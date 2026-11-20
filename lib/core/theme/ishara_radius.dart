import 'package:material_ui/material_ui.dart';

/// Corner radii — Figma collection "Radius".
///
/// sm 8 · md 12 (inputs) · lg 16 (cards, buttons) · xl 20 (media) ·
/// sheet 28 (bottom sheets, dialogs) · full (pills).
abstract final class IsharaRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double sheet = 28;
  static const double full = 999;

  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brSheet = BorderRadius.all(Radius.circular(sheet));
  static const BorderRadius brFull = BorderRadius.all(Radius.circular(full));

  /// Top corners only — bottom sheets and `ContentPanel`.
  static const BorderRadius sheetTop = BorderRadius.vertical(
    top: Radius.circular(sheet),
  );
}
