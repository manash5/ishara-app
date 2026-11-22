/// Google sign-in settings from `--dart-define` (see `env/example.json`).
abstract final class GoogleAuthConfig {
  /// OAuth Web client ID, used as `serverClientId` so Google returns an ID
  /// token the API can verify (`POST /auth/google`). Empty until configured.
  static const String webClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );

  static bool get isConfigured => webClientId.isNotEmpty;
}
