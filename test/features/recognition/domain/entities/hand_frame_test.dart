import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/recognition/domain/entities/hand_frame.dart';

void main() {
  test('Landmark: value equality, hash and a readable string', () {
    const a = Landmark(0.1, 0.2, 0.3);
    const b = Landmark(0.1, 0.2, 0.3);
    const c = Landmark(0.1, 0.2, 0.4);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(c));
    expect(a == Object(), isFalse);
    expect(a.toString(), 'Landmark(0.1, 0.2, 0.3)');
  });

  test('Finger: four landmarks each, base to tip, covering 1–20', () {
    expect(Finger.values.expand((f) => f.landmarks).toList(), [
      for (var i = 1; i <= 20; i++) i,
    ]);
    for (final f in Finger.values) {
      expect(f.landmarks, hasLength(4));
    }
  });
}
