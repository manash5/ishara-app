import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/features/auth/data/datasources/google_id_token_source.dart';
import 'package:ishara_app/features/auth/domain/services/google_id_token_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockAccount extends Mock implements GoogleSignInAccount {}

void main() {
  group('FakeGoogleIdTokenProvider', () {
    test('returns its token', () async {
      expect(await const FakeGoogleIdTokenProvider().idToken(), isNotEmpty);
    });

    test('cancel throws GoogleSignInCancelled', () {
      expect(
        const FakeGoogleIdTokenProvider(cancel: true).idToken(),
        throwsA(isA<GoogleSignInCancelled>()),
      );
    });
  });

  group('GoogleSignInIdTokenProvider', () {
    late MockGoogleSignIn google;
    late GoogleSignInIdTokenProvider provider;

    setUp(() {
      google = MockGoogleSignIn();
      provider = GoogleSignInIdTokenProvider(
        googleSignIn: google,
        serverClientId: 'web-client-id',
      );
      when(
        () => google.initialize(serverClientId: any(named: 'serverClientId')),
      ).thenAnswer((_) async {});
    });

    void signInWith(String? idToken) {
      final account = MockAccount();
      when(() => account.authentication)
          .thenReturn(GoogleSignInAuthentication(idToken: idToken));
      when(() => google.authenticate()).thenAnswer((_) async => account);
    }

    test(
      'initialises once with the Web client ID, returns the ID token',
      () async {
        signInWith('google-id-token');
        expect(await provider.idToken(), 'google-id-token');
        expect(await provider.idToken(), 'google-id-token');
        verify(() => google.initialize(serverClientId: 'web-client-id'))
            .called(1);
      },
    );

    test('a cancelled picker → GoogleSignInCancelled', () {
      when(() => google.authenticate()).thenThrow(
        const GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
      );
      expect(provider.idToken(), throwsA(isA<GoogleSignInCancelled>()));
    });

    test('other Google errors → UnknownException', () {
      when(() => google.authenticate()).thenThrow(
        const GoogleSignInException(
          code: GoogleSignInExceptionCode.clientConfigurationError,
        ),
      );
      expect(provider.idToken(), throwsA(isA<UnknownException>()));
    });

    test('no ID token → UnknownException', () {
      signInWith(null);
      expect(provider.idToken(), throwsA(isA<UnknownException>()));
    });
  });
}
