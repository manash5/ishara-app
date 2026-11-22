import 'app_exception.dart';
import 'failure.dart';

/// What repositories return: a value or a [Failure], never a thrown error.
sealed class Result<T> {
  const Result();

  R fold<R>(R Function(Failure failure) onErr, R Function(T value) onOk) =>
      switch (this) {
        Ok(:final value) => onOk(value),
        Err(:final failure) => onErr(failure),
      };

  bool get isOk => this is Ok<T>;

  T? get valueOrNull => switch (this) {
    Ok(:final value) => value,
    Err() => null,
  };

  /// The value, or throws the [Failure] (for async providers, whose
  /// `AsyncError` then carries it).
  T getOrThrow() => switch (this) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}

/// Runs [body] and turns any thrown error into an [Err]: an [AppException]
/// becomes its matching [Failure], anything else an [UnknownFailure].
Future<Result<T>> guard<T>(Future<T> Function() body) async {
  try {
    return Ok(await body());
  } on AppException catch (e) {
    return Err(Failure.fromException(e));
  } catch (_) {
    return const Err(UnknownFailure());
  }
}
