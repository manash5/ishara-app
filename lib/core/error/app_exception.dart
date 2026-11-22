/// Typed errors thrown by data sources (`data/`). Repositories catch them and
/// return a [Failure] inside a `Result`, so widgets never see these.
sealed class AppException implements Exception {
  const AppException();
}

/// No connection, or the request timed out.
final class NetworkException extends AppException {
  const NetworkException();
}

/// 401: the session is missing or could not be refreshed.
final class UnauthorizedException extends AppException {
  const UnauthorizedException();
}

/// 404.
final class NotFoundException extends AppException {
  const NotFoundException();
}

/// 409: the request clashes with the server's state.
final class ConflictException extends AppException {
  const ConflictException();
}

/// 400 / 422: the server rejected the input. [message] comes from the API
/// envelope and is written for users.
final class ValidationException extends AppException {
  const ValidationException([this.message]);
  final String? message;
}

/// 5xx.
final class ServerException extends AppException {
  const ServerException([this.statusCode]);
  final int? statusCode;
}

/// The local cache (Hive) could not be read or written.
final class CacheException extends AppException {
  const CacheException();
}

/// Anything else (cancelled request, malformed response…).
final class UnknownException extends AppException {
  const UnknownException();
}
