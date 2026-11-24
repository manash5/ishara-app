import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/auth/data/models/auth_session_dto.dart';
import 'package:ishara_app/features/auth/domain/entities/auth_session.dart';
import 'package:ishara_app/features/auth/domain/entities/auth_status.dart';
import 'package:ishara_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ishara_app/features/auth/domain/usecases/clear_session.dart';
import 'package:ishara_app/features/auth/domain/usecases/log_in.dart';
import 'package:ishara_app/features/auth/domain/usecases/log_out.dart';
import 'package:ishara_app/features/auth/domain/usecases/register.dart';
import 'package:ishara_app/features/auth/domain/usecases/request_password_reset.dart';
import 'package:ishara_app/features/auth/domain/usecases/reset_password.dart';
import 'package:ishara_app/features/auth/domain/usecases/restore_session.dart';
import 'package:ishara_app/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:ishara_app/features/auth/domain/usecases/watch_auth_status.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_api.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;
  final session = AuthSessionDto.fromJson(
    fixtureData<Map<String, dynamic>>('auth/login_200'),
  ).toEntity();

  setUp(() => repo = MockAuthRepository());

  test('Register trims name and email, keeps the password', () async {
    when(
      () => repo.register(
        email: any(named: 'email'),
        password: any(named: 'password'),
        displayName: any(named: 'displayName'),
      ),
    ).thenAnswer((_) async => Ok(session));
    final result = await Register(repo)(
      displayName: ' Asha ',
      email: ' a@ishara.test ',
      password: ' pw ',
    );
    expect(result.valueOrNull, session);
    verify(
      () => repo.register(
        email: 'a@ishara.test',
        password: ' pw ',
        displayName: 'Asha',
      ),
    ).called(1);
  });

  test('LogIn trims the email and passes failures through', () async {
    when(
      () => repo.logIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Err(UnauthorizedFailure()));
    final result = await LogIn(repo)(email: ' a@b.c ', password: 'x');
    expect((result as Err).failure, isA<UnauthorizedFailure>());
    verify(() => repo.logIn(email: 'a@b.c', password: 'x')).called(1);
  });

  test('SignInWithGoogle passes a cancel (Ok(null)) through', () async {
    when(() => repo.signInWithGoogle())
        .thenAnswer((_) async => const Ok<AuthSession?>(null));
    expect((await SignInWithGoogle(repo)()).valueOrNull, isNull);
  });

  group('RequestPasswordReset', () {
    test('rejects an empty email without calling the API', () async {
      final result = await RequestPasswordReset(repo)('  ');
      expect((result as Err).failure, isA<ValidationFailure>());
      verifyNever(() => repo.requestPasswordReset(any()));
    });

    test('sends the trimmed email', () async {
      when(() => repo.requestPasswordReset(any()))
          .thenAnswer((_) async => const Ok(null));
      expect((await RequestPasswordReset(repo)(' a@b.c ')).isOk, isTrue);
      verify(() => repo.requestPasswordReset('a@b.c')).called(1);
    });
  });

  group('ResetPassword', () {
    for (final bad in ['', '12345', '1234567', 'abcdef']) {
      test('rejects code "$bad"', () async {
        final result = await ResetPassword(repo)(
          email: 'a@b.c',
          code: bad,
          newPassword: 'password1',
        );
        expect(
          (result as Err).failure.message,
          'Enter the 6-digit code from the email.',
        );
      });
    }

    test('sends a 6-digit code', () async {
      when(
        () => repo.resetPassword(
          email: any(named: 'email'),
          code: any(named: 'code'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async => Ok(session));
      final result = await ResetPassword(repo)(
        email: ' a@b.c ',
        code: ' 123456 ',
        newPassword: 'password1',
      );
      expect(result.isOk, isTrue);
      verify(
        () => repo.resetPassword(
          email: 'a@b.c',
          code: '123456',
          newPassword: 'password1',
        ),
      ).called(1);
    });
  });

  test(
    'LogOut, ClearSession, RestoreSession and WatchAuthStatus delegate',
    () async {
      when(() => repo.logOut()).thenAnswer((_) async => const Ok(null));
      when(() => repo.clearSession()).thenAnswer((_) async => const Ok(null));
      when(() => repo.restoreSession())
          .thenAnswer((_) async => Ok(session.user));
      when(() => repo.statusChanges)
          .thenAnswer((_) => Stream.value(AuthStatus.signedOut));

      expect((await LogOut(repo)()).isOk, isTrue);
      expect((await ClearSession(repo)()).isOk, isTrue);
      expect((await RestoreSession(repo)()).valueOrNull, session.user);
      expect(await WatchAuthStatus(repo)().first, AuthStatus.signedOut);
    },
  );
}
