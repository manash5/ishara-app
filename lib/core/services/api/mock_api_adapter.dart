import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'api_endpoints.dart';
import 'mock_api_settings.dart';

/// One mock endpoint: [method] + [path] pattern (`:id` matches a segment)
/// served from `assets/mock_api/<fixture>`.
class MockRoute {
  const MockRoute(this.method, this.path, this.fixture, {this.session = false});

  final String method;
  final String path;
  final String fixture;

  /// Issues fresh tokens in the fixture's `data`, so login and refresh work.
  final bool session;

  bool matches(String method, String path) =>
      method == this.method && _pattern.hasMatch(path);

  RegExp get _pattern {
    final segments = path
        .split('/')
        .map((s) => s.startsWith(':') ? '[^/]+' : RegExp.escape(s));
    return RegExp('^${segments.join('/')}\$');
  }
}

/// Serves the API from JSON fixtures (`USE_MOCK_API=true`) so the app runs
/// end to end with no backend. [simulation] fakes offline / 401 / 404 / 500.
class MockApiAdapter implements HttpClientAdapter {
  MockApiAdapter({
    MockApiSimulation Function()? simulation,
    AssetBundle? bundle,
    this.latency = const Duration(milliseconds: 300),
    this.routes = defaultRoutes,
    DateTime Function()? clock,
  }) : _simulation = simulation ?? (() => MockApiSimulation.none),
       _bundle = bundle ?? rootBundle,
       _clock = clock ?? DateTime.now;

  static const fixtureRoot = 'assets/mock_api/';

  /// Core endpoints; each feature adds its own when its data layer lands.
  static const defaultRoutes = [
    MockRoute(
      'POST',
      ApiEndpoints.userRegister,
      'auth/session.json',
      session: true,
    ),
    MockRoute(
      'POST',
      ApiEndpoints.userLogin,
      'auth/session.json',
      session: true,
    ),
    MockRoute(
      'POST',
      ApiEndpoints.googleLogin,
      'auth/session.json',
      session: true,
    ),
    MockRoute(
      'POST',
      ApiEndpoints.refreshToken,
      'auth/refresh.json',
      session: true,
    ),
    MockRoute('POST', ApiEndpoints.logout, 'auth/ok.json'),
    MockRoute('POST', ApiEndpoints.forgotPassword, 'auth/ok.json'),
    MockRoute('POST', ApiEndpoints.resetPassword, 'auth/ok.json'),
    MockRoute('GET', ApiEndpoints.health, 'health.json'),
    MockRoute('GET', ApiEndpoints.getProfile, 'me/get.json'),
    MockRoute('POST', ApiEndpoints.submitOnboarding, 'me/onboarding.json'),
  ];

  /// How long a mock access token lives.
  static const sessionLength = Duration(hours: 1);

  final Duration latency;
  final List<MockRoute> routes;
  final MockApiSimulation Function() _simulation;
  final AssetBundle _bundle;
  final DateTime Function() _clock;

  int _issued = 0;
  int _validFrom = 0;
  MockApiSimulation _last = MockApiSimulation.none;

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
        return _error(401, 'Your session has ended.');
      case MockApiSimulation.unauthorized
          when isProtected && _tokenNumber(options) < _validFrom:
        return _error(401, 'Your session has ended.');
      case MockApiSimulation.notFound when !isAuth:
        return _error(404, 'Not found.');
      case MockApiSimulation.serverError when !isAuth:
        return _error(500, 'Something went wrong.');
      default:
        break;
    }

    final method = options.method.toUpperCase();
    final route = routes.where((r) => r.matches(method, path)).firstOrNull;
    if (route == null) return _error(404, 'No mock for $method $path.');

    final raw = await _bundle.loadString(
      '$fixtureRoot${route.fixture}',
      cache: false,
    );
    final body = jsonDecode(raw) as Map<String, dynamic>;
    if (route.session) _issueTokens(body);
    return _json(body, (body['status'] as num?)?.toInt() ?? 200);
  }

  void _issueTokens(Map<String, dynamic> body) {
    final data = Map<String, dynamic>.of(body['data'] as Map<String, dynamic>);
    final n = ++_issued;
    data['accessToken'] = 'mock-access-$n';
    data['refreshToken'] = 'mock-refresh-$n';
    data['expiresAt'] = _clock().toUtc().add(sessionLength).toIso8601String();
    body['data'] = data;
  }

  /// The serial number of a mock access token; 0 when there is none.
  int _tokenNumber(RequestOptions options) {
    final header = options.headers['Authorization'];
    if (header is! String) return 0;
    return int.tryParse(header.split('mock-access-').last) ?? 0;
  }

  ResponseBody _error(int status, String message) =>
      _json({'status': status, 'success': false, 'message': message}, status);

  ResponseBody _json(Map<String, dynamic> body, int status) =>
      ResponseBody.fromString(
        jsonEncode(body),
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

  @override
  void close({bool force = false}) {}
}
