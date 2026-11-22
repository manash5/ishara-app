import 'app_exception.dart';

/// What a repository reports when something goes wrong. [message] is safe to
/// show to users; raw exception text never is.
sealed class Failure {
  const Failure();

  String get message;

  factory Failure.fromException(AppException exception) => switch (exception) {
    NetworkException() => const NetworkFailure(),
    UnauthorizedException() => const UnauthorizedFailure(),
    NotFoundException() => const NotFoundFailure(),
    ConflictException() => const ConflictFailure(),
    ValidationException(:final message) => ValidationFailure(message),
    ServerException() => const ServerFailure(),
    CacheException() => const CacheFailure(),
    UnknownException() => const UnknownFailure(),
  };
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
  @override
  String get message => 'You’re offline. Check your connection and try again.';
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
  @override
  String get message => 'Your session has ended. Please log in again.';
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure();
  @override
  String get message => 'We couldn’t find that.';
}

final class ConflictFailure extends Failure {
  const ConflictFailure();
  @override
  String get message => 'That’s already been done.';
}

final class ValidationFailure extends Failure {
  const ValidationFailure([String? message]) : _message = message;
  final String? _message;
  @override
  String get message => (_message == null || _message.isEmpty)
      ? 'Please check and try again.'
      : _message;
}

final class ServerFailure extends Failure {
  const ServerFailure();
  @override
  String get message => 'Something went wrong on our side. Try again soon.';
}

final class CacheFailure extends Failure {
  const CacheFailure();
  @override
  String get message => 'We couldn’t load saved data.';
}

final class UnknownFailure extends Failure {
  const UnknownFailure();
  @override
  String get message => 'Something went wrong. Try again.';
}
