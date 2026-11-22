import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/settings/domain/entities/app_preferences.dart';
import 'package:ishara_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:ishara_app/features/settings/domain/usecases/get_preferences.dart';
import 'package:ishara_app/features/settings/domain/usecases/save_preferences.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository repo;
  setUpAll(() => registerFallbackValue(const AppPreferences()));
  setUp(() => repo = MockSettingsRepository());

  test('GetPreferences delegates', () {
    when(() => repo.load()).thenReturn(const Ok(AppPreferences()));
    expect(GetPreferences(repo)().valueOrNull, const AppPreferences());
  });

  test('SavePreferences saves a valid time', () async {
    when(() => repo.save(any())).thenAnswer((_) async => const Ok(null));
    expect((await SavePreferences(repo)(const AppPreferences())).isOk, isTrue);
  });

  test('SavePreferences rejects an impossible time', () async {
    final result = await SavePreferences(repo)(
      const AppPreferences(reminderHour: 24),
    );
    expect((result as Err).failure, isA<ValidationFailure>());
    verifyNever(() => repo.save(any()));
  });

  test('AppPreferences equality and copyWith', () {
    const a = AppPreferences();
    expect(a.copyWith(), a);
    expect(a.copyWith(theme: ThemePreference.dark), isNot(a));
    expect(a.copyWith().hashCode, a.hashCode);
  });
}
