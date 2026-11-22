import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/services/api/mock_api_adapter.dart';
import 'package:ishara_app/features/auth/data/datasources/auth_remote_data_source.dart';

import '../../../../helpers/mock_api.dart';

void main() {
  late AuthRemoteDataSource remote;
  setUp(() => remote = AuthRemoteDataSource(mockApiClient()));

  test('log in returns a session with fresh tokens', () async {
    final s = await remote.logIn(email: 'a@ishara.test', password: 'pw');
    expect(s.accessToken, startsWith('mock-access-'));
    expect(s.user.id, FixtureIds.user);
  });

  test('log in with wrong@ishara.test → 401', () {
    expect(
      remote.logIn(email: MockApiAdapter.wrongEmail, password: 'pw'),
      throwsA(isA<UnauthorizedException>()),
    );
  });

  test('register: taken email → 409, short password → 400', () async {
    await expectLater(
      remote.register(
        email: MockApiAdapter.takenEmail,
        password: 'password1',
        displayName: 'X',
      ),
      throwsA(isA<ConflictException>()),
    );
    await expectLater(
      remote.register(
        email: 'x@ishara.test',
        password: 'short',
        displayName: 'X',
      ),
      throwsA(
        isA<ValidationException>().having(
          (e) => e.message,
          'message',
          'Use at least 8 characters for your password.',
        ),
      ),
    );
  });

  test('register creates an account with onboarding to do', () async {
    final s = await remote.register(
      email: 'x@ishara.test',
      password: 'password1',
      displayName: 'X',
    );
    expect(s.user.onboardingDone, isFalse);
  });

  test('Google: token "invalid" → 401, else a session', () async {
    await expectLater(
      remote.signInWithGoogle(MockApiAdapter.invalidGoogleToken),
      throwsA(isA<UnauthorizedException>()),
    );
    expect((await remote.signInWithGoogle('token')).user.id, isNotEmpty);
  });

  test('forgot password always succeeds', () async {
    await remote.requestPasswordReset('anyone@ishara.test');
  });

  test('reset password: 000000 → 422 with the server message', () async {
    await expectLater(
      remote.resetPassword(
        email: 'a@ishara.test',
        code: MockApiAdapter.invalidResetCode,
        newPassword: 'password1',
      ),
      throwsA(
        isA<ValidationException>().having(
          (e) => e.message,
          'message',
          'That code is invalid or has expired.',
        ),
      ),
    );
    final s = await remote.resetPassword(
      email: 'a@ishara.test',
      code: '123456',
      newPassword: 'password1',
    );
    expect(s.accessToken, isNotEmpty);
  });

  test('log out succeeds', () async {
    await remote.logOut('mock-refresh');
  });
}
