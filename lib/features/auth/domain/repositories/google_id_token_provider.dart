/// Gets a Google ID token for `POST /auth/google` (requested with the Web
/// client ID as `serverClientId`).
abstract interface class GoogleIdTokenProvider {
  /// Shows Google's account picker and returns the ID token. Throws
  /// [GoogleSignInCancelled] when the learner closes the picker; any other
  /// error is an `AppException`.
  Future<String> idToken();
}

/// The learner closed Google's account picker: not an error, nothing to show.
class GoogleSignInCancelled implements Exception {
  const GoogleSignInCancelled();
}
