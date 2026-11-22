import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef FakeHandler = FutureOr<ResponseBody> Function(RequestOptions options);

/// An [HttpClientAdapter] that records every request and answers with
/// [handler], so API tests never touch the network.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this.handler);

  FakeHandler handler;
  final requests = <RequestOptions>[];

  /// Requests whose path ends with [path].
  Iterable<RequestOptions> to(String path) =>
      requests.where((r) => r.uri.path.endsWith(path));

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

/// A JSON response in the API envelope.
ResponseBody envelope(Object? data, {int status = 200, String? message}) =>
    jsonBody({
      'status': status,
      'success': status < 400,
      'message': message ?? (status < 400 ? 'OK' : 'Error'),
      'data': data,
    }, status: status);

ResponseBody jsonBody(Object body, {int status = 200}) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

/// Token fields as `/auth/refresh` returns them.
Map<String, Object> tokensJson(String access, {String? refresh}) => {
  'accessToken': access,
  'refreshToken': refresh ?? 'refresh-$access',
  'expiresAt': '2030-01-01T00:00:00.000Z',
};
