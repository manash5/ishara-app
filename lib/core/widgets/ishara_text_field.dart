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

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // The visible label is announced through the field's Semantics below.
        ExcludeSemantics(
          child: Text(
            label,
            style: s.labelMedium.copyWith(color: c.textPrimary),
          ),
        ),
        const SizedBox(height: IsharaSpacing.stackGap),
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
            style: s.bodyLarge.copyWith(color: c.textPrimary),
            cursorColor: c.accentDefault,
            decoration: InputDecoration(
              hintText: hint,
              helperText: helperText,
              errorText: errorText,
              helperMaxLines: 2,
              errorMaxLines: 2,
              constraints: const BoxConstraints(
                minHeight: IsharaSizes.controlHeight,
              ),
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(prefixIcon, size: IsharaSizes.iconMd),
              prefixIconConstraints: const BoxConstraints(
                minWidth: IsharaSizes.minTouch,
                minHeight: IsharaSizes.minTouch,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
