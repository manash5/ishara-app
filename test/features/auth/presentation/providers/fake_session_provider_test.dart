import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/services/api/token_storage.dart';
import 'package:ishara_app/features/auth/presentation/providers/fake_session_provider.dart';

void main() {
  test('a cleared token session (failed refresh) logs the user out', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(fakeSessionProvider.notifier).logIn();
    expect(container.read(fakeSessionProvider).loggedIn, isTrue);

    await container.read(tokenStorageProvider).clear();
    await Future<void>.delayed(Duration.zero);

    expect(container.read(fakeSessionProvider), (
      loggedIn: false,
      onboardingDone: false,
    ));
  });

  test('a saved session leaves the state alone', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(fakeSessionProvider.notifier).signUp();

    await container
        .read(tokenStorageProvider)
        .save(
          AuthTokens(
            accessToken: 'a',
            refreshToken: 'r',
            expiresAt: DateTime.utc(2030),
          ),
        );
    await Future<void>.delayed(Duration.zero);

    expect(container.read(fakeSessionProvider).loggedIn, isTrue);
  });
}
