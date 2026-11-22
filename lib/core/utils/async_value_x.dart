import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueMap<T> on AsyncValue<T> {
  /// Like `whenData`, but a provider that failed and is being retried by
  /// Riverpod (loading, with the last error) stays an error, so screens show
  /// the error state instead of an endless skeleton.
  AsyncValue<R> mapKeepingError<R>(R Function(T value) map) {
    if (hasValue) return AsyncData(map(requireValue));
    if (hasError) return AsyncError(error!, stackTrace ?? StackTrace.empty);
    return AsyncLoading<R>();
  }
}
