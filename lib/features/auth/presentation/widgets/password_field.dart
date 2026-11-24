import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/auth_form_providers.dart';

/// [IsharaTextField] for passwords: lock leading icon and the Figma eye
/// trailing icon, which toggles visibility (state in [passwordVisibleProvider]).
class PasswordField extends ConsumerWidget {
  const PasswordField({
    super.key,
    required this.field,
    this.label = 'Password',
    this.hint,
    this.errorText,
    this.isNewPassword = false,
    this.controller,
    this.onSubmitted,
    this.enabled = true,
  });

  final AuthPasswordField field;
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  /// Autofill as a new password (sign up) rather than an existing one.
  final bool isNewPassword;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(passwordVisibleProvider(field));
    return IsharaTextField(
      label: label,
      controller: controller,
      onSubmitted: onSubmitted,
      enabled: enabled,
      hint: hint,
      errorText: errorText,
      prefixIcon: IsharaIcons.lock,
      obscureText: !visible,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      autofillHints: [
        isNewPassword ? AutofillHints.newPassword : AutofillHints.password,
      ],
      // Figma trailingIcon is 20dp (I7:167;3:54).
      suffixIcon: IsharaIconButton(
        compact: true,
        icon: visible ? IsharaIcons.eyeOff : IsharaIcons.eye,
        tooltip: visible ? 'Hide password' : 'Show password',
        color: context.colors.textSecondary,
        onPressed: () =>
            ref.read(passwordVisibleProvider(field).notifier).toggle(),
      ),
    );
  }
}
