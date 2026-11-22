/// REST API paths and settings (`/api/v1`, contract in `docs/api-contract.md`).
/// Values come from `--dart-define-from-file=env/dev.json`.
class ApiEndpoints {
  ApiEndpoints._();

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

  static String get baseUrl => _configuredBaseUrl.isEmpty && useMockApi
      ? mockBaseUrl
      : _configuredBaseUrl;

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // =========== Auth Endpoints ===========
  static const String userRegister = '/auth/register';
  static const String userLogin = '/auth/login';
  static const String googleLogin = '/auth/google';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // =========== Health Endpoint ===========
  static const String health = '/health';

  // =========== Profile Endpoints ===========
  static const String getProfile = '/me';
  static const String submitOnboarding = '/me/onboarding';

  // =========== Learn Path Endpoint ===========
  static const String getPath = '/path';

  // =========== Lesson Endpoints ===========
  static String getLessonById(String lessonId) => '/lessons/$lessonId';
  static String completeLesson(String lessonId) =>
      '/lessons/$lessonId/complete';

  // =========== Progress Endpoint ===========
  static const String syncProgress = '/progress/sync';

  // =========== Sign Endpoints ===========
  static const String getSigns = '/signs';
  static String getSignById(String signId) => '/signs/$signId';

  // =========== Leaderboard Endpoint ===========
  static const String getWeeklyLeaderboard = '/leaderboard/weekly';

  /// Paths sent without a token: `/health` and `/auth/*`, except
  /// `/auth/logout`, which needs the session it ends.
  static bool isPublic(String path) {
    final p = endpointPath(path);
    if (p == logout) return false;
    return p == health || p.startsWith('/auth/');
  }

  /// [path] relative to `/api/v1`, whether given relative or as a full URL.
  static String endpointPath(String path) {
    final p = Uri.parse(path).path;
    const prefix = '/api/v1';
    final i = p.indexOf('$prefix/');
    return i == -1 ? p : p.substring(i + prefix.length);
  }
}
