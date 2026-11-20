import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> calls;

  setUp(() {
    calls = [];
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          calls.add(call);
          return null;
        });
  });

  tearDown(() {
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  List<Object?> haptics() => [
    for (final c in calls)
      if (c.method == 'HapticFeedback.vibrate') c.arguments,
  ];

  test('correct → light impact haptic', () async {
    await IsharaFeedback.correct();
    expect(haptics(), ['HapticFeedbackType.lightImpact']);
  });

  test('wrong → medium impact haptic', () async {
    await IsharaFeedback.wrong();
    expect(haptics(), ['HapticFeedbackType.mediumImpact']);
  });

  test('sheet animation: standard/enter in, 75%/exit out', () {
    final style = IsharaFeedback.sheetAnimationStyle;
    expect(style.duration, IsharaMotion.standard);
    expect(style.curve, IsharaMotion.enter);
    expect(
      style.reverseDuration,
      IsharaMotion.exitDuration(IsharaMotion.standard),
    );
    expect(style.reverseCurve, IsharaMotion.exit);
  });
}
