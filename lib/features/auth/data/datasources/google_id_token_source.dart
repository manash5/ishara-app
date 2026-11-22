import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/google_auth_config.dart';
import '../../../../core/error/app_exception.dart';
import '../../domain/services/google_id_token_provider.dart';
import '../../../../core/config/api_config.dart';

part 'google_id_token_source.g.dart';

/// Google's account picker via `google_sign_in` 7, asking for an ID token
/// for the Web client ID ([GoogleAuthConfig.webClientId] as
/// `serverClientId`) so the API can verify it.
class GoogleSignInIdTokenProvider implements GoogleIdTokenProvider {
  GoogleSignInIdTokenProvider({
    GoogleSignIn? googleSignIn,
    this.serverClientId = GoogleAuthConfig.webClientId,
  }) : _google = googleSignIn ?? GoogleSignIn.instance;

  final GoogleSignIn _google;

  /// The Web client ID; empty means not configured.
  final String serverClientId;
  Future<void>? _initialized;

  @override
  Future<String> idToken() async {
    try {
      await (_initialized ??= _initialize());
      final account = await _google.authenticate();
      final token = account.authentication.idToken;
      if (token == null || token.isEmpty) throw const UnknownException();
      return token;
    } on GoogleSignInException catch (e) {
      throw switch (e.code) {
        GoogleSignInExceptionCode.canceled ||
        GoogleSignInExceptionCode.interrupted => const GoogleSignInCancelled(),
        _ => const UnknownException(),
      };
    }
  }

  /// `initialize` may run only once; a failed attempt is retried next time.
  Future<void> _initialize() async {
    try {
      await _google.initialize(
        serverClientId: serverClientId.isEmpty ? null : serverClientId,
      );
    } catch (_) {
      _initialized = null;
      rethrow;
    }
  }
}

/// Stands in for Google with the mock API (`USE_MOCK_API=true`) and in
/// tests. [token] `invalid` makes the mock API answer 401; [cancel] acts as
/// if the learner closed the picker.
class FakeGoogleIdTokenProvider implements GoogleIdTokenProvider {
  const FakeGoogleIdTokenProvider({
    this.token = 'mock-google-id-token',
    this.cancel = false,
  });

  final String token;
  final bool cancel;

  @override
  Future<String> idToken() async {
    if (cancel) throw const GoogleSignInCancelled();
    return token;
  }
}

/// The real Google picker, or the fake one with the mock API.
@Riverpod(keepAlive: true)
GoogleIdTokenProvider googleIdTokenSource(Ref ref) => ApiConfig.useMockApi
    ? const FakeGoogleIdTokenProvider()
    : GoogleSignInIdTokenProvider();
