import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/services/api/api_response.dart';

void main() {
  test('parses an object payload without meta', () {
    final envelope = ApiEnvelope.fromJson({
      'status': 200,
      'success': true,
      'message': 'OK',
      'data': {'name': 'Namaste'},
    }, (data) => (data! as Map<String, dynamic>)['name'] as String);
    expect(envelope.status, 200);
    expect(envelope.success, isTrue);
    expect(envelope.message, 'OK');
    expect(envelope.data, 'Namaste');
    expect(envelope.requireData, 'Namaste');
    expect(envelope.meta, isNull);
  });

  test('parses a list payload with pagination meta', () {
    final envelope = ApiEnvelope.fromJson({
      'status': 200,
      'success': true,
      'message': 'OK',
      'data': [1, 2, 3],
      'meta': {'page': 1, 'limit': 3, 'total': 7, 'totalPages': 3},
    }, (data) => (data! as List).cast<int>());
    expect(envelope.data, [1, 2, 3]);
    final meta = envelope.meta!;
    expect((meta.page, meta.limit, meta.total, meta.totalPages), (1, 3, 7, 3));
    expect(meta.hasNextPage, isTrue);
  });

  test('an error envelope has no data', () {
    var parsed = false;
    final envelope = ApiEnvelope<String>.fromJson(
      {'status': 404, 'success': false, 'message': 'Sign not found'},
      (_) {
        parsed = true;
        return '';
      },
    );
    expect(envelope.success, isFalse);
    expect(envelope.message, 'Sign not found');
    expect(envelope.data, isNull);
    expect(parsed, isFalse);
    expect(() => envelope.requireData, throwsA(isA<UnknownException>()));
  });

  test('a body that is not an envelope throws UnknownException', () {
    expect(
      () => ApiEnvelope.fromJson('<html>', (d) => d),
      throwsA(isA<UnknownException>()),
    );
  });
}
