/// REST API settings from `--dart-define-from-file=env/dev.json` (see
/// `env/example.json`). Paths live in `ApiEndpoints`.
abstract final class ApiConfig {
  /// Serve `assets/mock_api/` fixtures instead of calling a server.
  static const bool useMockApi = bool.fromEnvironment(
    'USE_MOCK_API',
    defaultValue: true,
  );

  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  /// Host the mock adapter pretends to be when no base URL is configured.
  static const String mockBaseUrl = 'https://mock.ishara.local/api/v1';

  /// `API_BASE_URL`, or [mockBaseUrl] with the mock API and none set.
  static String get baseUrl => _configuredBaseUrl.isEmpty && useMockApi
      ? mockBaseUrl
      : _configuredBaseUrl;

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
