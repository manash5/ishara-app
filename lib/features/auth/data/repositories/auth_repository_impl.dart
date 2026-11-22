import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/api/token_storage.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../../../profile/data/datasources/profile_local_data_source.dart';
import '../../../profile/data/datasources/profile_remote_data_source.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_status.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/google_id_token_provider.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/google_id_token_source.dart';
import '../models/auth_session_dto.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._remote,
    this._tokens,
    this._hive,
    this._profileCache,
    this._profileRemote,
    this._google,
  );

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokens;
  final HiveService _hive;
  final ProfileLocalDataSource _profileCache;
  final ProfileRemoteDataSource _profileRemote;
  final GoogleIdTokenProvider _google;

  @override
  Future<Result<AuthSession>> register({
    required String email,
    required String password,
    required String displayName,
  }) => _signIn(
    () => _remote.register(
      email: email,
      password: password,
      displayName: displayName,
    ),
  );

  @override
  Future<Result<AuthSession>> logIn({
    required String email,
    required String password,
  }) => _signIn(() => _remote.logIn(email: email, password: password));

  @override
  Future<Result<AuthSession?>> signInWithGoogle() async {
    final String idToken;
    try {
      idToken = await _google.idToken();
    } on GoogleSignInCancelled {
      return const Ok(null);
    } on AppException catch (e) {
      return Err(Failure.fromException(e));
    } catch (_) {
      return const Err(UnknownFailure());
    }
    return _signIn(() => _remote.signInWithGoogle(idToken));
  }

  @override
  Future<Result<void>> requestPasswordReset(String email) =>
      guard(() => _remote.requestPasswordReset(email));

  @override
  Future<Result<AuthSession>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) => _signIn(
    () => _remote.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    ),
  );

  @override
  Future<Result<void>> logOut() async {
    try {
      if (await _tokens.read() case final stored?) {
        await _remote.logOut(stored.refreshToken);
      }
    } catch (_) {
      // Best effort: the device forgets the session either way.
    }
    return clearSession();
  }

  @override
  Future<Result<void>> clearSession() => guard(() async {
    // Cache first, so nothing reacting to signedOut reads the old learner.
    await _hive.clearAll();
    await _tokens.clear();
  });

  @override
  Future<Result<UserProfile?>> restoreSession() => guard(() async {
    if (await _tokens.read() == null) return null;
    try {
      if (_profileCache.read() case final cached?) {
        return cached.value.toEntity();
      }
    } on CacheException {
      // Unreadable cache: fetch the profile instead.
    }
    final dto = await _profileRemote.fetchProfile();
    await _profileCache.write(dto);
    return dto.toEntity();
  });

  @override
  Stream<AuthStatus> get statusChanges => _tokens.sessionChanges.map(
    (status) => switch (status) {
      SessionStatus.signedIn => AuthStatus.signedIn,
      SessionStatus.signedOut => AuthStatus.signedOut,
    },
  );

  /// Runs an auth call, then caches the user and stores the tokens. A
  /// different learner than the cached one starts from an empty cache.
  Future<Result<AuthSession>> _signIn(Future<AuthSessionDto> Function() call) =>
      guard(() async {
        final dto = await call();
        String? previousUser;
        try {
          previousUser = _profileCache.read()?.value.id;
        } on CacheException {
          previousUser = null;
        }
        if (previousUser != null && previousUser != dto.user.id) {
          await _hive.clearAll();
        }
        await _profileCache.write(dto.user);
        await _tokens.save(
          AuthTokens(
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken,
            expiresAt: dto.expiresAt,
          ),
        );
        return dto.toEntity();
      });
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  final hive = ref.watch(hiveServiceProvider);
  return AuthRepositoryImpl(
    AuthRemoteDataSource(api),
    ref.watch(tokenStorageProvider),
    hive,
    ProfileLocalDataSource(hive),
    ProfileRemoteDataSource(api),
    ref.watch(googleIdTokenSourceProvider),
  );
}
