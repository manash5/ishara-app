import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

/// An image provider that always fails — no network or asset I/O.
class _FailingImage extends ImageProvider<_FailingImage> {
  const _FailingImage();

  @override
  Future<_FailingImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(_FailingImage key, ImageDecoderCallback d) =>
      OneFrameImageStreamCompleter(Future.error(StateError('no photo')));
}

void main() {
  test('initialsOf', () {
    expect(IsharaAvatar.initialsOf('Manash Lama'), 'ML');
    expect(IsharaAvatar.initialsOf('  sujata  '), 'S');
    expect(IsharaAvatar.initialsOf('Ram Bahadur Thapa'), 'RT');
    expect(IsharaAvatar.initialsOf(''), '?');
  });

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    for (final (size, style) in [
      (IsharaAvatarSize.small, IsharaTextStyles.standard.labelMedium),
      (IsharaAvatarSize.large, IsharaTextStyles.standard.stat),
    ]) {
      testWidgets('${size.name} (${mode.name})', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpThemed(
          tester,
          IsharaAvatar(name: 'Manash Lama', size: size),
          mode: mode,
        );
        expect(
          tester.getSize(find.byType(IsharaAvatar)),
          Size.square(size.diameter),
        );
        final deco =
            tester
                    .widget<DecoratedBox>(
                      find.descendant(
                        of: find.byType(IsharaAvatar),
                        matching: find.byType(DecoratedBox),
                      ),
                    )
                    .decoration
                as BoxDecoration;
        expect(deco.color, c.accentSubtle);
        expect(deco.shape, BoxShape.circle);
        expect(textColor(tester, 'ML'), c.accentText);
        expect(
          renderedStyle(tester, find.text('ML'))?.fontSize,
          style.fontSize,
        );
        expect(find.bySemanticsLabel('Manash Lama'), findsOneWidget);
        handle.dispose();
      });
    }

    testWidgets('failing photo falls back to initials (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const IsharaAvatar(name: 'Sujata Rai', photo: _FailingImage()),
        mode: mode,
      );
      await tester.pumpAndSettle();
      expect(find.text('SR'), findsOneWidget);
    });
  }
}
