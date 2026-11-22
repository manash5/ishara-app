import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/utils/relative_time.dart';

void main() {
  final now = DateTime(2026, 11, 22, 12);
  String ago(Duration d) => formatUpdatedAgo(now.subtract(d), now: now);

  test('formatUpdatedAgo', () {
    expect(ago(const Duration(seconds: 20)), 'just now');
    expect(ago(const Duration(minutes: 5)), '5 min ago');
    expect(ago(const Duration(minutes: 59)), '59 min ago');
    expect(ago(const Duration(hours: 3)), '3 h ago');
    expect(ago(const Duration(days: 1, hours: 2)), '1 day ago');
    expect(ago(const Duration(days: 4)), '4 days ago');
  });

  test('offlineUpdatedLabel', () {
    expect(
      offlineUpdatedLabel(now.subtract(const Duration(hours: 3)), now: now),
      'Offline · updated 3 h ago',
    );
    expect(offlineUpdatedLabel(null), 'Offline');
  });
}
