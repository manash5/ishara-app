import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/api/token_storage.dart';
import 'package:ishara_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ishara_app/features/auth/data/datasources/google_id_token_source.dart';
import 'package:ishara_app/features/auth/data/models/auth_session_dto.dart';
import 'package:ishara_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ishara_app/features/auth/domain/entities/auth_status.dart';
import 'package:ishara_app/features/auth/domain/repositories/google_id_token_provider.dart';
import 'package:ishara_app/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:ishara_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:ishara_app/features/profile/data/models/user_profile_dto.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

class MockAuthRemote extends Mock implements AuthRemoteDataSource {}

class MockProfileRemote extends Mock implements ProfileRemoteDataSource {}

class MockGoogle extends Mock implements GoogleIdTokenProvider {}

void main() {
  late MockAuthRemote remote;
  late MockProfileRemote profileRemote;
  late TokenStorage tokens;
  late ProfileLocalDataSource profileCache;
  late AuthRepositoryImpl repo;

  final session = AuthSessionDto.fromJson(
    fixtureData<Map<String, dynamic>>('auth/login_200'),
  );
  final profile = UserProfileDto.fromJson(
    fixtureData<Map<String, dynamic>>('me/get_200'),
  );

  AuthRepositoryImpl build({GoogleIdTokenProvider? google}) =>
      AuthRepositoryImpl(
        remote,
        tokens,
        TestHive.instance,
        profileCache,
        profileRemote,
        google ?? const FakeGoogleIdTokenProvider(),
      );

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    remote = MockAuthRemote();
    profileRemote = MockProfileRemote();
    tokens = TokenStorage();
    profileCache = ProfileLocalDataSource(TestHive.instance);
    repo = build();
  });

  group('log in', () {
    test('stores tokens, caches the user, reports signedIn', () async {
      when(
        () => remote.logIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => session);
      final statuses = <AuthStatus>[];
      final sub = repo.statusChanges.listen(statuses.add);
      addTearDown(sub.cancel);

      final result = await repo.logIn(email: 'a@b.c', password: 'pw');

      expect(result.valueOrNull?.user.id, session.user.id);
      expect((await tokens.read())?.accessToken, session.accessToken);
      expect(profileCache.read()?.value.id, session.user.id);
      await Future<void>.delayed(Duration.zero);
      expect(statuses, [AuthStatus.signedIn]);
    });

    test('a 401 is an Err and nothing is stored', () async {
      when(
        () => remote.logIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const UnauthorizedException());
      final result = await repo.logIn(email: 'a@b.c', password: 'pw');
      expect((result as Err).failure, isA<UnauthorizedFailure>());
      expect(await tokens.read(), isNull);
      expect(profileCache.read(), isNull);
    });

    test('a different learner starts from an empty cache', () async {
      await profileCache.write(profile.copyWith(id: 'someone-else'));
      await TestHive.instance.putCache('learn.path', {'units': []});
      when(
        () => remote.logIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => session);

      await repo.logIn(email: 'a@b.c', password: 'pw');

      expect(TestHive.instance.cache.containsKey('learn.path'), isFalse);
      expect(profileCache.read()?.value.id, session.user.id);
    });

    test('the same learner keeps the cache', () async {
      await profileCache.write(profile);
      await TestHive.instance.putCache('learn.path', {'units': []});
      when(
        () => remote.logIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => session);

      await repo.logIn(email: 'a@b.c', password: 'pw');
      expect(TestHive.instance.cache.containsKey('learn.path'), isTrue);
    });
  });

  test('register, reset password store the session too', () async {
    when(
      () => remote.register(
        email: any(named: 'email'),
        password: any(named: 'password'),
        displayName: any(named: 'displayName'),
      ),
    ).thenAnswer((_) async => session);
    when(
      () => remote.resetPassword(
        email: any(named: 'email'),
        code: any(named: 'code'),
        newPassword: any(named: 'newPassword'),
      ),
    ).thenAnswer((_) async => session);

    expect(
      (await repo.register(email: 'a', password: 'b', displayName: 'c')).isOk,
      isTrue,
    );
    await tokens.clear();
    expect(
      (await repo.resetPassword(
        email: 'a',
        code: '123456',
        newPassword: 'b',
      )).isOk,
      isTrue,
    );
    expect(await tokens.read(), isNotNull);
  });

  test('reset password 422 → ValidationFailure with the message', () async {
    when(
      () => remote.resetPassword(
        email: any(named: 'email'),
        code: any(named: 'code'),
        newPassword: any(named: 'newPassword'),
      ),
    ).thenThrow(
      const ValidationException('That code is invalid or has expired.'),
    );
    final result = await repo.resetPassword(
      email: 'a',
      code: '000000',
      newPassword: 'b',
    );
    expect(
      (result as Err).failure.message,
      'That code is invalid or has expired.',
    );
  });

  group('Google', () {
    test('sends the ID token', () async {
      when(() => remote.signInWithGoogle(any()))
          .thenAnswer((_) async => session);
      final result = await repo.signInWithGoogle();
      expect(result.valueOrNull, isNotNull);
      verify(() => remote.signInWithGoogle('mock-google-id-token')).called(1);
    });

    test('cancel → Ok(null), no API call', () async {
      final result = await build(
        google: const FakeGoogleIdTokenProvider(cancel: true),
      ).signInWithGoogle();
      expect(result, isA<Ok<Object?>>());
      expect(result.valueOrNull, isNull);
      verifyNever(() => remote.signInWithGoogle(any()));
    });

    test('a Google error → Err', () async {
      final google = MockGoogle();
      when(() => google.idToken()).thenThrow(const UnknownException());
      final result = await build(google: google).signInWithGoogle();
      expect((result as Err).failure, isA<UnknownFailure>());
    });
  });

  test('requestPasswordReset wraps errors', () async {
    when(() => remote.requestPasswordReset(any()))
        .thenThrow(const NetworkException());
    final result = await repo.requestPasswordReset('a@b.c');
    expect((result as Err).failure, isA<NetworkFailure>());
  });

  group('log out', () {
    setUp(() async {
      await tokens.save(
        AuthTokens(
          accessToken: 'a',
          refreshToken: 'r',
          expiresAt: DateTime.utc(2030),
        ),
      );
      await profileCache.write(profile);
      await TestHive.instance.settings.put('settings.theme', 'dark');
    });

    test('revokes the refresh token, clears tokens and Hive', () async {
      when(() => remote.logOut(any())).thenAnswer((_) async {});
      expect((await repo.logOut()).isOk, isTrue);
      verify(() => remote.logOut('r')).called(1);
      expect(await tokens.read(), isNull);
      expect(TestHive.instance.cache.isEmpty, isTrue);
      expect(TestHive.instance.settings.isEmpty, isTrue);
    });

    test('an API failure is ignored', () async {
      when(() => remote.logOut(any())).thenThrow(const NetworkException());
      final statuses = <AuthStatus>[];
      final sub = repo.statusChanges.listen(statuses.add);
      addTearDown(sub.cancel);

      expect((await repo.logOut()).isOk, isTrue);
      expect(await tokens.read(), isNull);
      await Future<void>.delayed(Duration.zero);
      expect(statuses, [AuthStatus.signedOut]);
    });
  });

  group('restoreSession', () {
    test('no tokens → null', () async {
      expect((await repo.restoreSession()).valueOrNull, isNull);
      verifyNever(() => profileRemote.fetchProfile());
    });

    test('tokens + cache → the cached profile, no fetch', () async {
      await tokens.save(
        AuthTokens(
          accessToken: 'a',
          refreshToken: 'r',
          expiresAt: DateTime(2030),
        ),
      );
      await profileCache.write(profile);
      expect((await repo.restoreSession()).valueOrNull?.id, profile.id);
      verifyNever(() => profileRemote.fetchProfile());
    });

    test('tokens, no cache → fetches and caches', () async {
      await tokens.save(
        AuthTokens(
          accessToken: 'a',
          refreshToken: 'r',
          expiresAt: DateTime(2030),
        ),
      );
      when(() => profileRemote.fetchProfile()).thenAnswer((_) async => profile);
      expect((await repo.restoreSession()).valueOrNull?.id, profile.id);
      expect(profileCache.read()?.value.id, profile.id);
    });

    test('fetch fails → Err', () async {
      await tokens.save(
        AuthTokens(
          accessToken: 'a',
          refreshToken: 'r',
          expiresAt: DateTime(2030),
        ),
      );
      when(() => profileRemote.fetchProfile())
          .thenThrow(const UnauthorizedException());
      final result = await repo.restoreSession();
      expect((result as Err).failure, isA<UnauthorizedFailure>());
    });
  });
}
