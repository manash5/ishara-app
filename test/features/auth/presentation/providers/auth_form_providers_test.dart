import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/auth/data/datasources/google_id_token_source.dart';
import 'package:ishara_app/features/auth/presentation/providers/auth_form_providers.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/profile/data/datasources/profile_local_data_source.dart';

import '../../auth_test_utils.dart';

void main() {
  /// A container where [provider] stays alive (the forms auto-dispose).
  ProviderContainer keep(
    AuthTestEnv env,
    ProviderListenable<Object?> provider,
  ) {
    final container = env.container();
    container.listen(provider, (_, _) {});
    return container;
  }

  group('LogInForm', () {
    test('logs in: tokens stored, profile cached, session signed in', () async {
      final env = AuthTestEnv();
      final c = keep(env, logInFormProvider);
      final pending = c
          .read(logInFormProvider.notifier)
          .logIn(email: ' learner@ishara.test ', password: 'password1');
      expect(c.read(logInFormProvider).pending, AuthSubmit.email);
      await pending;

      expect(c.read(logInFormProvider).busy, isFalse);
      expect(c.read(logInFormProvider).error, isNull);
      expect(c.read(sessionProvider).flags, (
        loggedIn: true,
        onboardingDone: true,
      ));
      expect(await env.tokens.read(), isNotNull);
      expect(ProfileLocalDataSource(env.hive).read(), isNotNull);
    });

    test(
      'wrong@ishara.test → "Wrong email or password." under password',
      () async {
        final env = AuthTestEnv();
        final c = keep(env, logInFormProvider);
        await c
            .read(logInFormProvider.notifier)
            .logIn(email: 'wrong@ishara.test', password: 'password1');
        final state = c.read(logInFormProvider);
        expect(state.errorFor(AuthField.password), wrongCredentialsMessage);
        expect(state.errorFor(AuthField.email), isNull);
        expect(await env.tokens.read(), isNull);
        expect(c.read(sessionProvider).loggedIn, isFalse);
      },
    );

    test('offline → the network message', () async {
      final env = AuthTestEnv()..simulation = MockApiSimulation.offline;
      final c = keep(env, logInFormProvider);
      await c
          .read(logInFormProvider.notifier)
          .logIn(email: 'a@ishara.test', password: 'password1');
      expect(c.read(logInFormProvider).error, contains('offline'));
    });

    test('Google signs in', () async {
      final env = AuthTestEnv();
      final c = keep(env, logInFormProvider);
      await c.read(logInFormProvider.notifier).google();
      expect(c.read(sessionProvider).loggedIn, isTrue);
    });

    test('Google token rejected → Google message', () async {
      final env = AuthTestEnv(
        google: const FakeGoogleIdTokenProvider(token: 'invalid'),
      );
      final c = keep(env, logInFormProvider);
      await c.read(logInFormProvider.notifier).google();
      expect(c.read(logInFormProvider).error, googleFailedMessage);
      expect(c.read(sessionProvider).loggedIn, isFalse);
    });

    test('Google picker cancelled → quiet no-op', () async {
      final env = AuthTestEnv(
        google: const FakeGoogleIdTokenProvider(cancel: true),
      );
      final c = keep(env, logInFormProvider);
      await c.read(logInFormProvider.notifier).google();
      final state = c.read(logInFormProvider);
      expect(state.error, isNull);
      expect(state.busy, isFalse);
      expect(c.read(sessionProvider).loggedIn, isFalse);
    });
  });

  group('SignUpForm', () {
    test('registers: signed in with onboarding to do', () async {
      final env = AuthTestEnv();
      final c = keep(env, signUpFormProvider);
      await c
          .read(signUpFormProvider.notifier)
          .register(
            displayName: 'New learner',
            email: 'new@ishara.test',
            password: 'password1',
          );
      expect(c.read(sessionProvider).flags, (
        loggedIn: true,
        onboardingDone: false,
      ));
    });

    test('taken@ishara.test → email error', () async {
      final env = AuthTestEnv();
      final c = keep(env, signUpFormProvider);
      await c
          .read(signUpFormProvider.notifier)
          .register(
            displayName: 'X',
            email: 'taken@ishara.test',
            password: 'password1',
          );
      expect(
        c.read(signUpFormProvider).errorFor(AuthField.email),
        emailTakenMessage,
      );
      expect(c.read(sessionProvider).loggedIn, isFalse);
    });

    test('short password → the server message under password', () async {
      final env = AuthTestEnv();
      final c = keep(env, signUpFormProvider);
      await c
          .read(signUpFormProvider.notifier)
          .register(
            displayName: 'X',
            email: 'x@ishara.test',
            password: 'short',
          );
      expect(
        c.read(signUpFormProvider).errorFor(AuthField.password),
        'Use at least 8 characters for your password.',
      );
    });
  });

  group('PasswordResetForm', () {
    test('step 1 sends the code and moves to step 2', () async {
      final env = AuthTestEnv();
      final c = keep(env, passwordResetFormProvider);
      await c
          .read(passwordResetFormProvider.notifier)
          .sendCode(' learner@ishara.test ');
      final state = c.read(passwordResetFormProvider);
      expect(state.codeSent, isTrue);
      expect(state.sentTo, 'learner@ishara.test');
    });

    test('step 1 with no email shows an error under email', () async {
      final env = AuthTestEnv();
      final c = keep(env, passwordResetFormProvider);
      await c.read(passwordResetFormProvider.notifier).sendCode('  ');
      final state = c.read(passwordResetFormProvider);
      expect(state.codeSent, isFalse);
      expect(state.form.errorFor(AuthField.email), isNotNull);
    });

    test('step 2 with a good code signs in', () async {
      final env = AuthTestEnv();
      final c = keep(env, passwordResetFormProvider);
      final form = c.read(passwordResetFormProvider.notifier);
      await form.sendCode('learner@ishara.test');
      await form.reset(code: '123456', newPassword: 'newpassword');
      expect(c.read(sessionProvider).loggedIn, isTrue);
      expect(await env.tokens.read(), isNotNull);
    });

    test('code 000000 → 422 message under the code', () async {
      final env = AuthTestEnv();
      final c = keep(env, passwordResetFormProvider);
      final form = c.read(passwordResetFormProvider.notifier);
      await form.sendCode('learner@ishara.test');
      await form.reset(code: '000000', newPassword: 'newpassword');
      final state = c.read(passwordResetFormProvider);
      expect(state.codeSent, isTrue);
      expect(
        state.form.errorFor(AuthField.code),
        'That code is invalid or has expired.',
      );
      expect(c.read(sessionProvider).loggedIn, isFalse);
    });

    test('a code that is not 6 digits never reaches the API', () async {
      final env = AuthTestEnv();
      final c = keep(env, passwordResetFormProvider);
      final form = c.read(passwordResetFormProvider.notifier);
      await form.sendCode('learner@ishara.test');
      await form.reset(code: '12', newPassword: 'newpassword');
      expect(
        c.read(passwordResetFormProvider).form.errorFor(AuthField.code),
        'Enter the 6-digit code from the email.',
      );
    });

    test('changeEmail goes back to step 1', () async {
      final env = AuthTestEnv();
      final c = keep(env, passwordResetFormProvider);
      final form = c.read(passwordResetFormProvider.notifier);
      await form.sendCode('learner@ishara.test');
      form.changeEmail();
      expect(c.read(passwordResetFormProvider).codeSent, isFalse);
    });
  });

  test('PasswordVisible toggles', () {
    final c = AuthTestEnv().container();
    final provider = passwordVisibleProvider(AuthPasswordField.logIn);
    c.listen(provider, (_, _) {});
    expect(c.read(provider), isFalse);
    c.read(provider.notifier).toggle();
    expect(c.read(provider), isTrue);
  });
}
