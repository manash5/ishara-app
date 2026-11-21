import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'ishara_button.dart';

/// Figma `FeedbackSheet` → `result`.
enum FeedbackResult { correct, incorrect, almost }

/// Figma `FeedbackSheet` (flat): the answer result sheet — tinted panel with
/// 28dp top corners, a result badge, title, message and a full-width button
/// (`almost` adds an optional secondary text button).
///
/// Use [FeedbackSheet.show]: it slides up in `standard`/`enter` and pairs the
/// result with a haptic (Deaf-first: visual + haptic, never sound).
class FeedbackSheet extends StatelessWidget {
  const FeedbackSheet({
    super.key,
    required this.result,
    required this.message,
    required this.onContinue,
    this.title,
    this.actionLabel,
    this.secondaryLabel,
    this.onSecondary,
  });

  final FeedbackResult result;

  /// Caller-supplied explanation (e.g. the correct answer). Don't invent NSL
  /// sign descriptions here (CLAUDE.md content rule).
  final String message;
  final VoidCallback? onContinue;

  /// Defaults: "Nicely done!", "Not quite", "Almost there" (Figma copy).
  final String? title;

  /// Defaults: "Continue", "Got it", "Try again" (Figma copy).
  final String? actionLabel;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  static String defaultTitle(FeedbackResult r) => switch (r) {
    FeedbackResult.correct => 'Nicely done!',
    FeedbackResult.incorrect => 'Not quite',
    FeedbackResult.almost => 'Almost there',
  };

  static String defaultAction(FeedbackResult r) => switch (r) {
    FeedbackResult.correct => 'Continue',
    FeedbackResult.incorrect => 'Got it',
    FeedbackResult.almost => 'Try again',
  };

  /// Shows the sheet (not dismissible by drag — the learner must continue)
  /// and fires the matching haptic.
  static Future<void> show(
    BuildContext context, {
    required FeedbackResult result,
    required String message,
    required VoidCallback onContinue,
    String? title,
    String? actionLabel,
    String? secondaryLabel,
    VoidCallback? onSecondary,
  }) {
    if (result == FeedbackResult.correct) {
      IsharaFeedback.correct();
    } else {
      IsharaFeedback.wrong();
    }
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      sheetAnimationStyle: IsharaFeedback.sheetAnimationStyle,
      builder: (_) => FeedbackSheet(
        result: result,
        message: message,
        title: title,
        actionLabel: actionLabel,
        secondaryLabel: secondaryLabel,
        onSecondary: onSecondary,
        onContinue: onContinue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final (panel, badge, fg, icon, tone) = switch (result) {
      FeedbackResult.correct => (
        c.successSubtle,
        c.successDefault,
        c.successText,
        IsharaIcons.check,
        IsharaButtonTone.success,
      ),
      FeedbackResult.incorrect => (
        c.dangerSubtle,
        c.dangerDefault,
        c.dangerText,
        IsharaIcons.close,
        IsharaButtonTone.danger,
      ),
      FeedbackResult.almost => (
        c.accentSubtle,
        c.accentDefault,
        c.accentText,
        IsharaIcons.lightbulb,
        IsharaButtonTone.accent,
      ),
    };
    final heading = title ?? defaultTitle(result);

    return Container(
      key: const ValueKey('feedback-sheet-panel'),
      width: double.infinity,
      decoration: BoxDecoration(
        color: panel,
        borderRadius: IsharaRadius.sheetTop,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            IsharaSpacing.screenMargin,
            IsharaSpacing.screenMargin,
            IsharaSpacing.screenMargin,
            IsharaSpacing.s4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                container: true,
                liveRegion: true,
                header: true,
                label: '$heading. $message',
                excludeSemantics: true,
                child: Row(
                  children: [
                    Container(
                      width: IsharaSizes.feedbackBadge,
                      height: IsharaSizes.feedbackBadge,
                      decoration: BoxDecoration(
                        color: badge,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: IsharaSizes.iconMd,
                        color: c.textOnAccent,
                      ),
                    ),
                    const SizedBox(width: IsharaSpacing.s3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            heading,
                            style: s.titleLarge.copyWith(color: fg),
                          ),
                          const SizedBox(height: IsharaSizes.titleGap),
                          Text(
                            message,
                            style: s.bodyMedium.copyWith(color: fg),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: IsharaSpacing.s4),
              IsharaButton(
                label: actionLabel ?? defaultAction(result),
                tone: tone,
                onPressed: onContinue,
              ),
              if (secondaryLabel != null && onSecondary != null)
                IsharaButton(
                  label: secondaryLabel!,
                  variant: IsharaButtonVariant.text,
                  onPressed: onSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
