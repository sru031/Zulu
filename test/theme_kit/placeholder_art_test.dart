import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:lottie/lottie.dart';
import 'package:zulu/theme_kit/effect_registry.dart';
import 'package:zulu/theme_kit/pet_manifest.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../helpers/read_file.dart';

void main() {
  late ThemeKit kit;

  setUpAll(() async => kit = await loadThemeKit(readFile));

  test('every registered effect is a valid Lottie animation', () {
    for (final name in EffectName.values) {
      final path = kit.effects.fileFor(name);
      if (path == null) continue;
      final bytes = File(ThemeKit.assetPath(path)).readAsBytesSync();
      final composition = LottieComposition.parseJsonBytes(bytes);
      expect(composition.duration, greaterThan(Duration.zero), reason: name.id);
    }
  });

  test('every PNG pet pose decodes at the canvas size', () {
    for (final stage in kit.pet.stages.values) {
      for (final pose in stage.poses.values.whereType<PngPose>()) {
        final image = img.decodePng(File(ThemeKit.assetPath(pose.path)).readAsBytesSync());
        expect(image, isNotNull, reason: pose.path);
        expect(image!.width, kit.pet.canvasSize, reason: pose.path);
        expect(image.height, kit.pet.canvasSize, reason: pose.path);
      }
    }
  });

  test('every item and egg image decodes', () {
    final paths = [
      for (final item in kit.items.items) item.image,
      for (final egg in kit.pet.eggs) egg.image,
      kit.rooms.home.background,
    ];
    for (final path in paths) {
      expect(img.decodePng(File(ThemeKit.assetPath(path)).readAsBytesSync()), isNotNull, reason: path);
    }
  });
}
