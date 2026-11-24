import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  test('pose artwork is transparent (no exported canvas background)', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final pose in DanuPose.values) {
      final svg = await rootBundle.loadString(pose.asset);
      expect(
        RegExp(r'<rect width="200" height="\d+" fill=').hasMatch(svg),
        isFalse,
        reason: pose.name,
      );
    }
  });

  test('all six pose SVGs are bundled', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final pose in DanuPose.values) {
      final svg = await rootBundle.loadString(pose.asset);
      expect(svg, startsWith('<svg'), reason: pose.name);
      expect(
        svg,
        isNot(contains('<filter')),
        reason: 'flutter_svg: ${pose.name}',
      );
    }
  });

  for (final mode in themeModes) {
    for (final pose in DanuPose.values) {
      testWidgets('${pose.name} (${mode.name})', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpThemed(tester, DanuMascot(pose: pose), mode: mode);
        await tester.pumpAndSettle();
        final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect((svg.bytesLoader as SvgAssetLoader).assetName, pose.asset);
        expect(
          tester.getSize(find.byType(DanuMascot)),
          const Size.square(IsharaSizes.mascot),
        );
        expect(
          find.bySemanticsLabel('Danu the Danphe, ${pose.description}'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        handle.dispose();
      });
    }
  }

  testWidgets('pose change cross-fades', (tester) async {
    await pumpThemed(tester, const DanuMascot());
    await pumpThemed(tester, const DanuMascot(pose: DanuPose.celebrate));
    await tester.pump(IsharaMotion.fast ~/ 2);
    expect(find.byType(SvgPicture), findsNWidgets(2));
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  Set<String> assetsShown(WidgetTester tester) => tester
      .widgetList<SvgPicture>(find.byType(SvgPicture))
      .map((p) => (p.bytesLoader as SvgAssetLoader).assetName)
      .toSet();

  testWidgets('animated wave draws the layered pose and keeps waving', (
    tester,
  ) async {
    await pumpThemed(
      tester,
      const DanuMascot(pose: DanuPose.wave, size: 130, animated: true),
    );
    expect(assetsShown(tester), DanuWaveLayers.all.toSet());

    double wingAngle() {
      final wing = find.ancestor(
        of: find.byWidgetPredicate(
          (w) =>
              w is SvgPicture &&
              (w.bytesLoader as SvgAssetLoader).assetName ==
                  DanuWaveLayers.wing,
        ),
        matching: find.byType(Transform),
      );
      return tester.widget<Transform>(wing.first).transform.storage[1];
    }

    final a = wingAngle();
    await tester.pump(DanuWaveMotion.period ~/ 4);
    final b = wingAngle();
    expect(a, isNot(closeTo(b, 1e-6)));
    expect(tester.takeException(), isNull);
    // Looping: unmount instead of settling.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('animated celebrate cheers: wings flap mirrored, Danu hops', (
    tester,
  ) async {
    await pumpThemed(
      tester,
      const DanuMascot(pose: DanuPose.celebrate, size: 130, animated: true),
    );
    expect(assetsShown(tester), DanuCelebrateLayers.all.toSet());

    Matrix4 transformAbove(String asset) {
      final layer = find.ancestor(
        of: find.byWidgetPredicate(
          (w) =>
              w is SvgPicture &&
              (w.bytesLoader as SvgAssetLoader).assetName == asset,
        ),
        matching: find.byType(Transform),
      );
      return tester.widget<Transform>(layer.first).transform;
    }

    // At a quarter cheer the wings are at full flap, in opposite directions.
    await tester.pump(DanuCelebrateMotion.period ~/ 4);
    final left = transformAbove(DanuCelebrateLayers.wingLeft).storage[1];
    final right = transformAbove(DanuCelebrateLayers.wingRight).storage[1];
    expect(left, isNot(closeTo(0, 1e-3)));
    expect(right, closeTo(-left, 1e-6));
    // Mid-hop the body (the back layer's outer transform) is lifted.
    final hop = find.ancestor(
      of: find.byWidgetPredicate(
        (w) =>
            w is SvgPicture &&
            (w.bytesLoader as SvgAssetLoader).assetName ==
                DanuCelebrateLayers.back,
      ),
      matching: find.byType(Transform),
    );
    expect(
      tester.widget<Transform>(hop.last).transform.getTranslation().y,
      lessThan(0),
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('reduced motion shows the still celebrate artwork', (
    tester,
  ) async {
    await pumpThemed(
      tester,
      const DanuMascot(pose: DanuPose.celebrate, animated: true),
      disableAnimations: true,
    );
    expect(assetsShown(tester), {DanuPose.celebrate.asset});
  });

  testWidgets('reduced motion shows the still wave artwork', (tester) async {
    await pumpThemed(
      tester,
      const DanuMascot(pose: DanuPose.wave, animated: true),
      disableAnimations: true,
    );
    expect(assetsShown(tester), {DanuPose.wave.asset});
  });

  testWidgets('animated sad sighs: head droops and a tear rolls down', (
    tester,
  ) async {
    await pumpThemed(
      tester,
      const DanuMascot(pose: DanuPose.sad, size: 130, animated: true),
    );
    expect(assetsShown(tester), DanuSadLayers.all.toSet());

    Finder above(String asset, Type type) => find.ancestor(
      of: find.byWidgetPredicate(
        (w) =>
            w is SvgPicture &&
            (w.bytesLoader as SvgAssetLoader).assetName == asset,
      ),
      matching: find.byType(type),
    );
    double tearOpacity() =>
        tester.widget<Opacity>(above(DanuSadLayers.tear, Opacity)).opacity;
    double tearY() => tester
        .widget<Transform>(above(DanuSadLayers.tear, Transform).first)
        .transform
        .getTranslation()
        .y;
    // The head's rotation is the outermost Transform above the head layer
    // inside the body's sigh transform.
    double headAngle() => tester
        .widget<Transform>(above(DanuSadLayers.head, Transform).first)
        .transform
        .storage[1];

    expect(tearOpacity(), closeTo(0, 1e-6));
    final restAngle = headAngle();
    // Mid-sigh: the head hangs lowest and the tear has rolled down.
    await tester.pump(DanuSadMotion.period ~/ 2);
    expect(headAngle(), greaterThan(restAngle));
    expect(tearOpacity(), greaterThan(0.5));
    expect(tearY(), greaterThan(0));
    expect(tester.hasRunningAnimations, isTrue);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('reduced motion shows the still sad artwork', (tester) async {
    await pumpThemed(
      tester,
      const DanuMascot(pose: DanuPose.sad, animated: true),
      disableAnimations: true,
    );
    expect(assetsShown(tester), {DanuPose.sad.asset});
  });

  Finder above(String asset, [Type type = Transform]) => find.ancestor(
    of: find.byWidgetPredicate(
      (w) =>
          w is SvgPicture &&
          (w.bytesLoader as SvgAssetLoader).assetName == asset,
    ),
    matching: find.byType(type),
  );

  testWidgets('animated point jabs twice with a hop, then rests', (
    tester,
  ) async {
    await pumpThemed(
      tester,
      const DanuMascot(pose: DanuPose.point, size: 130, animated: true),
    );
    expect(assetsShown(tester), DanuPointLayers.all.toSet());

    // Nearest first: wing lift, wing reach, body stretch, hop/lean.
    // wingX is how far the wing reaches beyond its rest length.
    double hopY() => tester
        .widget<Transform>(above(DanuPointLayers.wing).last)
        .transform
        .getTranslation()
        .y;
    double wingX() =>
        tester
            .widget<Transform>(above(DanuPointLayers.wing).at(1))
            .transform
            .storage[0] -
        1;
    double wingAngle() => tester
        .widget<Transform>(above(DanuPointLayers.wing).first)
        .transform
        .storage[1];

    expect(wingX(), closeTo(0, 1e-6));
    // Mid first jab: wing out, tip up, Danu in the air.
    await tester.pump(DanuPointMotion.period * 0.11);
    expect(wingX(), greaterThan(0));
    expect(wingAngle(), lessThan(0));
    expect(hopY(), lessThan(0));
    final first = wingX();
    // Between the jabs it pulls back in.
    await tester.pump(DanuPointMotion.period * 0.14);
    expect(wingX(), lessThan(first / 2));
    // Mid second jab: out again.
    await tester.pump(DanuPointMotion.period * 0.14);
    expect(wingX(), closeTo(first, first * 0.05));
    // Resting after the jabs.
    await tester.pump(DanuPointMotion.period * 0.3);
    expect(wingX(), closeTo(0, 1e-6));
    expect(tester.hasRunningAnimations, isTrue);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  test('point thrust: two full jabs, at rest in between and after', () {
    final (a0, a1) = DanuPointMotion.firstJab;
    final (b0, b1) = DanuPointMotion.secondJab;
    expect(DanuPointMotion.thrust(0), closeTo(0, 1e-9));
    expect(DanuPointMotion.thrust((a0 + a1) / 2), closeTo(1, 1e-9));
    expect(DanuPointMotion.thrust((a1 + b0) / 2), closeTo(0, 1e-9));
    expect(DanuPointMotion.thrust((b0 + b1) / 2), closeTo(1, 1e-9));
    expect(DanuPointMotion.thrust(0.8), closeTo(0, 1e-9));
  });

  testWidgets('animated namaste bows: body tips forward, eyes close', (
    tester,
  ) async {
    await pumpThemed(
      tester,
      const DanuMascot(pose: DanuPose.namaste, size: 130, animated: true),
    );
    expect(assetsShown(tester), DanuNamasteLayers.all.toSet());

    // The bow is the nearest Transform above the body layer.
    double bowAngle() => tester
        .widget<Transform>(above(DanuNamasteLayers.body).first)
        .transform
        .storage[1];
    double eyeScale() => tester
        .widget<Transform>(above(DanuNamasteLayers.eye).first)
        .transform
        .storage[5];

    expect(bowAngle(), closeTo(0, 1e-6));
    expect(eyeScale(), closeTo(1, 1e-6));
    // Holding the bow: tipped forward (clockwise, towards the beak).
    await tester.pump(
      DanuNamasteMotion.period *
          ((DanuNamasteMotion.downEnd + DanuNamasteMotion.holdEnd) / 2),
    );
    expect(
      bowAngle(),
      closeTo(math.sin(DanuNamasteMotion.bow * math.pi / 180), 1e-6),
    );
    expect(eyeScale(), lessThan(0.5));
    // Back upright at the end of the loop.
    await tester.pump(DanuNamasteMotion.period * (0.95 - 0.415));
    expect(bowAngle(), closeTo(0, 1e-6));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  test('namaste depth: down, hold, up, rest', () {
    expect(DanuNamasteMotion.depth(0), closeTo(0, 1e-9));
    expect(DanuNamasteMotion.depth(DanuNamasteMotion.downEnd), 1);
    expect(DanuNamasteMotion.depth(DanuNamasteMotion.holdEnd), 1);
    expect(DanuNamasteMotion.depth(DanuNamasteMotion.upEnd), closeTo(0, 1e-9));
    expect(DanuNamasteMotion.depth(0.95), closeTo(0, 1e-9));
  });

  for (final mode in themeModes) {
    testWidgets('animated think: dots rise, a cloud pops up (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const DanuMascot(pose: DanuPose.think, size: 130, animated: true),
        mode: mode,
      );
      expect(assetsShown(tester), DanuThinkLayers.all.toSet());

      double dotScale(String dot) =>
          tester.widget<Transform>(above(dot).first).transform.storage[0];
      final cloud = find.byKey(const Key('danu-thought-cloud'));
      double cloudScale() => tester
          .widget<Transform>(
            find.descendant(of: cloud, matching: find.byType(Transform)).first,
          )
          .transform
          .storage[0];

      // Nothing yet: the dots and cloud are still to come.
      expect(dotScale(DanuThinkLayers.dot1), closeTo(0, 1e-6));
      expect(cloudScale(), closeTo(0, 1e-6));
      // The dots pop in one by one, smallest first.
      await tester.pump(DanuThinkMotion.period * 0.2);
      expect(dotScale(DanuThinkLayers.dot1), greaterThan(0.9));
      expect(dotScale(DanuThinkLayers.dot3), closeTo(0, 1e-6));
      // Then the cloud, with a signing hand, sits above Danu (overflowing).
      await tester.pump(DanuThinkMotion.period * 0.4);
      expect(cloudScale(), closeTo(1, 1e-6));
      expect(
        find.descendant(of: cloud, matching: find.byIcon(IsharaIcons.hand)),
        findsOneWidget,
      );
      final danu = tester.getRect(find.byType(DanuMascot));
      final puff = tester.getRect(cloud);
      expect(puff.bottom, lessThan(danu.center.dy));
      expect(puff.top, lessThan(danu.top));
      // Finally it all drifts away before the next thought.
      await tester.pump(DanuThinkMotion.period * 0.38);
      expect(tester.widget<Opacity>(cloud).opacity, closeTo(0, 1e-6));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  for (final pose in [DanuPose.point, DanuPose.think, DanuPose.namaste]) {
    testWidgets('reduced motion shows the still ${pose.name} artwork', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        DanuMascot(pose: pose, animated: true),
        disableAnimations: true,
      );
      expect(assetsShown(tester), {pose.asset});
      expect(tester.hasRunningAnimations, isFalse);
    });
  }

  test('every layered pose bundles its layers', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final asset in [
      ...DanuWaveLayers.all,
      ...DanuCelebrateLayers.all,
      ...DanuSadLayers.all,
      ...DanuPointLayers.all,
      ...DanuNamasteLayers.all,
      ...DanuThinkLayers.all,
    ]) {
      expect((await rootBundle.loadString(asset)).contains('<svg'), isTrue);
    }
  });
}
