import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `IsharaTextField`: label above a 56dp muted field.
///
/// Figma `state` is derived, not passed: empty / filled come from the text,
/// focused from focus (2px accent border), error from [errorText]
/// (2px danger border + danger helper text). Field colours, radius and
/// borders come from `AppTheme.inputDecorationTheme`.
class IsharaTextField extends StatelessWidget {
  const IsharaTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.helperText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofillHints,
    this.enabled = true,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.showLabel = true,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;

  /// Figma `leadingIcon` (20dp, text/secondary).
  final IconData? prefixIcon;

  /// Figma `trailingIcon` — usually an [IsharaIconButton] (e.g. show password).
  final Widget? suffixIcon;
  final String? errorText;
  final String? helperText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  /// False for label-less fields such as search (Dictionary 12:834); [label]
  /// is still announced by screen readers.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final inputTheme = Theme.of(context).inputDecorationTheme;
    final hasError = errorText != null;
    // Figma draws helper/error text flush with the label, 8 below the field;
    // InputDecorator would indent it by the content padding, so it is drawn
    // here and the error state is expressed through the borders.
    final subtext = errorText ?? helperText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // The visible label is announced through the field's Semantics below.
        if (showLabel) ...[
          ExcludeSemantics(
            child: Text(
              label,
              style: s.labelMedium.copyWith(color: c.textPrimary),
            ),
          ),
          const SizedBox(height: IsharaSpacing.stackGap),
        ],
        Semantics(
          label: label,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            autofillHints: autofillHints,
            enabled: enabled,
            inputFormatters: inputFormatters,
            textCapitalization: textCapitalization,
            style: s.bodyLarge.copyWith(color: c.textPrimary),
            cursorColor: c.accentDefault,
            decoration: InputDecoration(
              hintText: hint,
              enabledBorder: hasError ? inputTheme.errorBorder : null,
              focusedBorder: hasError ? inputTheme.focusedErrorBorder : null,
              constraints: const BoxConstraints(
                minHeight: IsharaSizes.controlHeight,
              ),
              // Figma: icon 16 from the edge, 12 before the text (M3 adds
              // 4 after a prefix icon, so the icon pads 8 itself).
              prefixIcon: prefixIcon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: IsharaSpacing.s4,
                        end: IsharaSpacing.s2,
                      ),
                      child: Icon(prefixIcon, size: IsharaSizes.iconMd),
                    ),
              prefixIconConstraints: const BoxConstraints(),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        if (subtext != null) ...[
          const SizedBox(height: IsharaSpacing.stackGap),
          Semantics(
            liveRegion: hasError,
            child: Text(
              subtext,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: s.bodySmall.copyWith(
                color: hasError ? c.dangerText : c.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
