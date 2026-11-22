import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/utils/weekdays.dart';

void main() {
  test('seven Monday-first initials and names that line up', () {
    expect(Weekdays.initials, ['M', 'T', 'W', 'T', 'F', 'S', 'S']);
    expect(Weekdays.names, hasLength(7));
    for (var i = 0; i < 7; i++) {
      expect(Weekdays.names[i][0], Weekdays.initials[i]);
    }
    expect(Weekdays.names.first, 'Monday');
  });
}
