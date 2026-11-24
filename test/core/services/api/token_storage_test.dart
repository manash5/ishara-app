import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/services/api/token_storage.dart';

void main() {
  late TokenStorage storage;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    storage = TokenStorage();
  });
  tearDown(() => storage.dispose());

  final tokens = AuthTokens(
    accessToken: 'access-1',
    refreshToken: 'refresh-1',
    expiresAt: DateTime.utc(2030, 1, 1, 12),
  );

  test('starts empty and signed out', () async {
    expect(await storage.read(), isNull);
    expect(await storage.currentStatus(), SessionStatus.signedOut);
  });

  test('save, read and clear round-trip', () async {
    await storage.save(tokens);
    final read = (await storage.read())!;
    expect(read.accessToken, 'access-1');
    expect(read.refreshToken, 'refresh-1');
    expect(read.expiresAt, DateTime.utc(2030, 1, 1, 12));
    expect(await storage.currentStatus(), SessionStatus.signedIn);

    await storage.clear();
    expect(await storage.read(), isNull);
  });

  test('emits signedIn on save and signedOut on clear', () async {
    final events = <SessionStatus>[];
    final sub = storage.sessionChanges.listen(events.add);
    await storage.save(tokens);
    await storage.clear();
    await Future<void>.delayed(Duration.zero);
    expect(events, [SessionStatus.signedIn, SessionStatus.signedOut]);
    await sub.cancel();
  });

  test('a partly written session reads as none', () async {
    FlutterSecureStorage.setMockInitialValues({
      TokenStorage.accessTokenKey: 'access-only',
    });
    expect(await TokenStorage().read(), isNull);
  });

  test('parses tokens from an auth response', () {
    final parsed = AuthTokens.fromJson({
      'accessToken': 'a',
      'refreshToken': 'r',
      'expiresAt': '2030-01-01T00:00:00.000Z',
      'user': {'id': 'ignored'},
    });
    expect(parsed.accessToken, 'a');
    expect(parsed.expiresAt, DateTime.utc(2030));
  });
}
