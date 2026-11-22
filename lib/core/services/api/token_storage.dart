import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_storage.g.dart';

/// The session tokens the API issues (`/auth/login`, `/auth/refresh`…).
class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  /// Reads the token fields of an auth response's `data`.
  factory AuthTokens.fromJson(Object? json) {
    final map = json! as Map<String, dynamic>;
    return AuthTokens(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
      expiresAt: DateTime.parse(map['expiresAt'] as String),
    );
  }

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
}

enum SessionStatus { signedIn, signedOut }

/// Keeps the tokens in the Android Keystore (flutter_secure_storage) and
/// reports session changes. A cleared session (logout, failed refresh) emits
/// [SessionStatus.signedOut]; the router redirect does the navigation.
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const accessTokenKey = 'accessToken';
  static const refreshTokenKey = 'refreshToken';
  static const expiresAtKey = 'expiresAt';

  final FlutterSecureStorage _storage;
  final _changes = StreamController<SessionStatus>.broadcast();

  Stream<SessionStatus> get sessionChanges => _changes.stream;

  Future<AuthTokens?> read() async {
    final values = await _storage.readAll();
    final access = values[accessTokenKey];
    final refresh = values[refreshTokenKey];
    final expires = DateTime.tryParse(values[expiresAtKey] ?? '');
    if (access == null || refresh == null || expires == null) return null;
    return AuthTokens(
      accessToken: access,
      refreshToken: refresh,
      expiresAt: expires,
    );
  }

  Future<SessionStatus> currentStatus() async =>
      await read() == null ? SessionStatus.signedOut : SessionStatus.signedIn;

  Future<void> save(AuthTokens tokens) async {
    await _storage.write(key: accessTokenKey, value: tokens.accessToken);
    await _storage.write(key: refreshTokenKey, value: tokens.refreshToken);
    await _storage.write(
      key: expiresAtKey,
      value: tokens.expiresAt.toUtc().toIso8601String(),
    );
    _changes.add(SessionStatus.signedIn);
  }

  Future<void> clear() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
    await _storage.delete(key: expiresAtKey);
    _changes.add(SessionStatus.signedOut);
  }

  Future<void> dispose() => _changes.close();
}

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) {
  final storage = TokenStorage();
  ref.onDispose(storage.dispose);
  return storage;
}
