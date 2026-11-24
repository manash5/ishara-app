import 'package:material_ui/material_ui.dart';

import '../error/failure.dart';
import '../theme/theme.dart';
import 'list_skeleton.dart';
import 'state_message.dart';

/// A whole screen's loading or error state while its data loads (composed
/// from [ListSkeleton] and [StateMessage]). With an [error] it shows
/// [errorTitle], the failure's user-safe message and a Try again button;
/// otherwise a skeleton labelled [loadingLabel].
class LoadStateView extends StatelessWidget {
  const LoadStateView({
    super.key,
    required this.error,
    required this.errorTitle,
    required this.onRetry,
    required this.loadingLabel,
    this.itemHeight = IsharaSizes.listTileHeight,
  });

  /// The `AsyncValue` error, or null while loading.
  final Object? error;
  final String errorTitle;
  final VoidCallback onRetry;
  final String loadingLabel;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(IsharaSpacing.screenMargin),
        child: error != null
            ? Center(
                child: StateMessage(
                  title: errorTitle,
                  body: failureMessage(error),
                  actionLabel: 'Try again',
                  onAction: onRetry,
                ),
              )
            : ListSkeleton(itemHeight: itemHeight, semanticLabel: loadingLabel),
      ),
    );
  }
}
