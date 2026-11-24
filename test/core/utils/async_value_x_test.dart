import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/utils/async_value_x.dart';

void main() {
  test('maps data', () {
    expect(
      const AsyncData(2).mapKeepingError((v) => v * 2),
      const AsyncData(4),
    );
  });

  test('keeps a plain error', () {
    final e = const AsyncError<int>(
      'boom',
      StackTrace.empty,
    ).mapKeepingError((v) => '$v');
    expect(e.hasError, isTrue);
    expect(e.isLoading, isFalse);
  });

  testWidgets('a retrying provider (loading + last error) stays an error', (
    tester,
  ) async {
    final failing = FutureProvider<int>((ref) async => throw Exception('x'));
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final sub = c.listen(failing, (_, _) {});
    // Riverpod retries a failed provider: while it does, it reports loading
    // with the last error.
    for (
      var i = 0;
      i < 40 && !(sub.read().isLoading && sub.read().hasError);
      i++
    ) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(sub.read().isLoading, isTrue);
    expect(sub.read().hasError, isTrue);
    expect(
      sub.read().whenData((v) => '$v').hasError,
      isFalse,
      reason: 'whenData drops the error, which is why mapKeepingError exists',
    );
    final mapped = sub.read().mapKeepingError((v) => '$v');
    expect(mapped, isA<AsyncError<String>>());
    expect(mapped.error, isA<Exception>());
  });

  test('plain loading stays loading', () {
    expect(
      const AsyncLoading<int>().mapKeepingError((v) => '$v'),
      isA<AsyncLoading<String>>(),
    );
  });
}
