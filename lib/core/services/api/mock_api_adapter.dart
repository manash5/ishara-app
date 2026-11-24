import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'api_endpoints.dart';
import 'mock_api_settings.dart';

/// A request as the mock routes see it.
class MockRequest {
  const MockRequest({
    required this.method,
    required this.path,
    required this.params,
    required this.query,
    required this.body,
  });

  final String method;

  /// Path relative to `/api/v1`, e.g. `/signs/1234`.
  final String path;

  /// `:name` segments of the route pattern.
  final Map<String, String> params;
  final Map<String, dynamic> query;

  /// The JSON body, or an empty map.
  final Map<String, dynamic> body;
}

/// Which fixture to serve, and an optional edit of its decoded body.
class MockReply {
  const MockReply(this.fixture, [this.transform]);

  final String fixture;
  final FutureOr<void> Function(Map<String, dynamic> body)? transform;
}

typedef MockResolver = FutureOr<MockReply> Function(MockRequest request);

/// One mock endpoint: [method] + [path] pattern (`:id` matches a segment).
/// [fixtures] lists every file it can serve under `assets/mock_api/`;
/// [resolve] picks one per request (default: the first).
class MockRoute {
  const MockRoute(this.method, this.path, this.fixtures, [this.resolve]);

  final String method;
  final String path;
  final List<String> fixtures;
  final MockResolver? resolve;

  /// The `:name` params if [method] and [path] match, else null.
  Map<String, String>? match(String method, String path) {
    if (method != this.method) return null;
    final pattern = this.path.split('/');
    final actual = path.split('/');
    if (pattern.length != actual.length) return null;
    final params = <String, String>{};
    for (var i = 0; i < pattern.length; i++) {
      if (pattern[i].startsWith(':')) {
        if (actual[i].isEmpty) return null;
        params[pattern[i].substring(1)] = actual[i];
      } else if (pattern[i] != actual[i]) {
        return null;
      }
    }
    return params;
  }

  Future<MockReply> replyTo(MockRequest request) async =>
      await resolve?.call(request) ?? MockReply(fixtures.first);
}

/// Serves the API from the JSON fixtures in `assets/mock_api/`
/// (`USE_MOCK_API=true`), so the app runs end to end with no backend.
/// `docs/api-contract.md` documents every route and the reserved values
/// that return the error cases. [simulation] fakes offline / 401 / 404 / 500.
class MockApiAdapter implements HttpClientAdapter {
  MockApiAdapter({
    MockApiSimulation Function()? simulation,
    AssetBundle? bundle,
    this.latency = const Duration(milliseconds: 300),
    List<MockRoute>? routes,
    DateTime Function()? clock,
  }) : _simulation = simulation ?? (() => MockApiSimulation.none),
       _bundle = bundle ?? rootBundle,
       _clock = clock ?? DateTime.now {
    this.routes = routes ?? _defaultRoutes();
  }

  static const fixtureRoot = 'assets/mock_api/';

  /// Reserved values that return the error fixtures.
  static const wrongEmail = 'wrong@ishara.test';
  static const takenEmail = 'taken@ishara.test';
  static const invalidGoogleToken = 'invalid';
  static const expiredRefreshToken = 'expired';
  static const invalidResetCode = '000000';
  static const minPasswordLength = 8;

  /// How long a mock access token lives.
  static const sessionLength = Duration(hours: 1);

  /// Time left in the weekly league when the leaderboard is fetched.
  static const leagueTimeLeft = Duration(days: 3, hours: 14);

  /// Generic errors for simulations and unknown routes.
  static const errorFixtures = ['error_401', 'error_404', 'error_500'];

  final Duration latency;
  late final List<MockRoute> routes;
  final MockApiSimulation Function() _simulation;
  final AssetBundle _bundle;
  final DateTime Function() _clock;

  int _issued = 0;
  int _validFrom = 0;
  MockApiSimulation _last = MockApiSimulation.none;
  final _completedEvents = <String>{};

  /// Every fixture the routes can serve, plus the generic errors.
  Set<String> get fixtures => {
    for (final route in routes) ...route.fixtures,
    ...errorFixtures,
  };

  List<MockRoute> _defaultRoutes() => [
    // =========== Auth ===========
    MockRoute(
      'POST',
      ApiEndpoints.userRegister,
      ['auth/register_201', 'auth/register_409', 'auth/register_400'],
      (r) => switch (r.body) {
        {'email': takenEmail} => const MockReply('auth/register_409'),
        {'password': final String p} when p.length < minPasswordLength =>
          const MockReply('auth/register_400'),
        _ => const MockReply('auth/register_201'),
      },
    ),
    MockRoute(
      'POST',
      ApiEndpoints.userLogin,
      ['auth/login_200', 'auth/login_401'],
      (r) => MockReply(
        r.body['email'] == wrongEmail ? 'auth/login_401' : 'auth/login_200',
      ),
    ),
    MockRoute(
      'POST',
      ApiEndpoints.googleLogin,
      ['auth/google_200', 'auth/google_401'],
      (r) => MockReply(
        r.body['idToken'] == invalidGoogleToken
            ? 'auth/google_401'
            : 'auth/google_200',
      ),
    ),
    MockRoute(
      'POST',
      ApiEndpoints.refreshToken,
      ['auth/refresh_200', 'auth/refresh_401'],
      (r) => MockReply(
        r.body['refreshToken'] == expiredRefreshToken
            ? 'auth/refresh_401'
            : 'auth/refresh_200',
      ),
    ),
    const MockRoute('POST', ApiEndpoints.logout, ['auth/logout_200']),
    const MockRoute('POST', ApiEndpoints.forgotPassword, [
      'auth/forgot_password_200',
    ]),
    MockRoute(
      'POST',
      ApiEndpoints.resetPassword,
      ['auth/reset_password_200', 'auth/reset_password_422'],
      (r) => MockReply(
        r.body['code'] == invalidResetCode
            ? 'auth/reset_password_422'
            : 'auth/reset_password_200',
      ),
    ),

    // =========== Health ===========
    const MockRoute('GET', ApiEndpoints.health, ['health/get_200']),

    // =========== Profile ===========
    const MockRoute('GET', ApiEndpoints.getProfile, ['me/get_200']),
    MockRoute(
      'PUT',
      ApiEndpoints.getProfile,
      ['me/put_200'],
      (r) => MockReply('me/put_200', (body) {
        final data = body['data'] as Map<String, dynamic>;
        for (final key in const [
          'displayName',
          'dailyGoalMinutes',
          'dominantHand',
          'timezone',
        ]) {
          if (r.body.containsKey(key)) data[key] = r.body[key];
        }
      }),
    ),
    const MockRoute('DELETE', ApiEndpoints.getProfile, ['me/delete_200']),
    const MockRoute('POST', ApiEndpoints.submitOnboarding, [
      'me/onboarding_200',
    ]),

    // =========== Learn path ===========
    const MockRoute('GET', ApiEndpoints.getPath, ['path/get_200']),

    // =========== Lessons ===========
    MockRoute(
      'GET',
      ApiEndpoints.getLessonById(':id'),
      ['lessons/get_200'],
      (r) => MockReply('lessons/get_200', (body) {
        final data = body['data'] as Map<String, dynamic>;
        (data['lesson'] as Map<String, dynamic>)['id'] = r.params['id'];
      }),
    ),
    MockRoute(
      'POST',
      ApiEndpoints.completeLesson(':id'),
      ['lessons/complete_200', 'lessons/complete_replay_200'],
      (r) {
        final event = r.body['clientEventId'] as String?;
        final replay = event != null && !_completedEvents.add(event);
        return MockReply(
          replay ? 'lessons/complete_replay_200' : 'lessons/complete_200',
          (body) {
            final data = body['data'] as Map<String, dynamic>;
            data['lessonId'] = r.params['id'];
            if (event != null) data['clientEventId'] = event;
          },
        );
      },
    ),

    // =========== Progress ===========
    MockRoute(
      'POST',
      ApiEndpoints.syncProgress,
      ['progress/sync_200'],
      (r) => MockReply('progress/sync_200', (body) {
        final events = r.body['events'];
        if (events is! List) return;
        final data = body['data'] as Map<String, dynamic>;
        final first = (data['results'] as List).first as Map<String, dynamic>;
        final template = first['result'] as Map<String, dynamic>;
        data['results'] = [
          for (final e in events.cast<Map<String, dynamic>>())
            {
              'clientEventId': e['clientEventId'],
              'status': _completedEvents.add(e['clientEventId'] as String)
                  ? 'applied'
                  : 'duplicate',
              'message': null,
              'result': {
                ...template,
                'lessonId': e['lessonId'],
                'clientEventId': e['clientEventId'],
              },
            },
        ];
      }),
    ),

    // =========== Signs ===========
    MockRoute(
      'GET',
      ApiEndpoints.getSigns,
      const [
        'signs/list_page1',
        'signs/list_page2',
        'signs/list_category',
        'signs/list_search',
      ],
      (r) => MockReply(switch (r.query) {
        {'search': final Object s} when '$s'.isNotEmpty => 'signs/list_search',
        {'category': final Object c} when '$c'.isNotEmpty =>
          'signs/list_category',
        {'page': final Object p} when '$p' == '2' => 'signs/list_page2',
        _ => 'signs/list_page1',
      }),
    ),
    MockRoute('GET', ApiEndpoints.getSignById(':id'), const [
      'signs/get_200',
      'signs/get_404',
    ], (r) => _signDetail(r.params['id']!)),

    // =========== Leaderboard ===========
    MockRoute(
      'GET',
      ApiEndpoints.getWeeklyLeaderboard,
      const ['leaderboard/weekly_200'],
      (r) => MockReply('leaderboard/weekly_200', (body) {
        (body['data'] as Map<String, dynamic>)['endsAt'] = _clock()
            .toUtc()
            .add(leagueTimeLeft)
            .toIso8601String();
      }),
    ),
  ];

  /// Namaste has a full detail fixture; other known signs are built from
  /// their list entry; anything else is a 404.
  Future<MockReply> _signDetail(String id) async {
    final detail = await _load('signs/get_200');
    if ((detail['data'] as Map<String, dynamic>)['id'] == id) {
      return const MockReply('signs/get_200');
    }
    for (final page in const ['signs/list_page1', 'signs/list_page2']) {
      final list = (await _load(page))['data'] as List;
      for (final sign in list.cast<Map<String, dynamic>>()) {
        if (sign['id'] == id) {
          return MockReply('signs/get_200', (body) => body['data'] = sign);
        }
      }
    }
    return const MockReply('signs/get_404');
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);

    final simulation = _simulation();
    if (simulation != _last) {
      // Entering "401 once" invalidates every token issued so far.
      if (simulation == MockApiSimulation.unauthorized) {
        _validFrom = _issued + 1;
      }
      _last = simulation;
    }

    final path = ApiEndpoints.endpointPath(options.uri.path);
    final isAuth = path.startsWith('/auth/');
    final isProtected = !ApiEndpoints.isPublic(path);

    switch (simulation) {
      case MockApiSimulation.offline:
        throw DioException.connectionError(
          requestOptions: options,
          reason: 'Simulated offline',
        );
      case MockApiSimulation.sessionExpired
          when isProtected || path == ApiEndpoints.refreshToken:
        return _serve(const MockReply('error_401'));
      case MockApiSimulation.unauthorized
          when isProtected && _tokenNumber(options) < _validFrom:
        return _serve(const MockReply('error_401'));
      case MockApiSimulation.notFound when !isAuth:
        return _serve(const MockReply('error_404'));
      case MockApiSimulation.serverError when !isAuth:
        return _serve(const MockReply('error_500'));
      default:
        break;
    }

    final method = options.method.toUpperCase();
    for (final route in routes) {
      final params = route.match(method, path);
      if (params == null) continue;
      final request = MockRequest(
        method: method,
        path: path,
        params: params,
        query: options.uri.queryParameters,
        body: _body(options.data),
      );
      return _serve(await route.replyTo(request));
    }
    return _serve(const MockReply('error_404'));
  }

  Future<ResponseBody> _serve(MockReply reply) async {
    final body = await _load(reply.fixture);
    await reply.transform?.call(body);
    final data = body['data'];
    if (data is Map<String, dynamic> && data.containsKey('accessToken')) {
      body['data'] = _withFreshTokens(data);
    }
    return ResponseBody.fromString(
      jsonEncode(body),
      (body['status'] as num?)?.toInt() ?? 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  Future<Map<String, dynamic>> _load(String fixture) async {
    final raw = await _bundle.loadString(
      '$fixtureRoot$fixture.json',
      cache: false,
    );
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Map<String, dynamic> _withFreshTokens(Map<String, dynamic> session) {
    final n = ++_issued;
    return {
      ...session,
      'accessToken': 'mock-access-$n',
      'refreshToken': 'mock-refresh-$n',
      'expiresAt': _clock().toUtc().add(sessionLength).toIso8601String(),
    };
  }

  static Map<String, dynamic> _body(Object? data) {
    if (data is Map<String, dynamic>) return data;
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
      } on FormatException {
        // Not JSON: treat as no body.
      }
    }
    return const {};
  }

  /// The serial number of a mock access token; 0 when there is none.
  int _tokenNumber(RequestOptions options) {
    final header = options.headers['Authorization'];
    if (header is! String) return 0;
    return int.tryParse(header.split('mock-access-').last) ?? 0;
  }

  @override
  void close({bool force = false}) {}
}
