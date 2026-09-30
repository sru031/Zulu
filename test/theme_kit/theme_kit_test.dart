import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/domain/pet/pet_stage.dart';
import 'package:zulu/theme_kit/effect_registry.dart';
import 'package:zulu/theme_kit/item_catalog.dart';
import 'package:zulu/theme_kit/pet_manifest.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../helpers/read_file.dart';

void main() {
  test('loads the shipped manifests', () async {
    final kit = await loadThemeKit(readFile);
    expect(kit.theme.appName, 'Zulu');
    expect(kit.theme.light.primary, 0xFF6C8CFF);
    expect(kit.pet.eggs, hasLength(6));
    expect(kit.pet.stages.keys, containsAll(PetStage.values));
    expect(kit.pet.pose(PetStage.adult, PetPose.hatch).path, 'pet/adult/hatch.png');
    expect(kit.items.byId('cozy_scarf')?.kind, ItemKind.outfit);
    expect(kit.items.items.where((i) => i.everyday), hasLength(3));
    expect(kit.rooms.home.slots.keys, containsAll(['wall_left', 'wall_right', 'window', 'floor_left', 'floor_right']));
    expect(kit.effects.fileFor(EffectName.goalDone), 'effects/goal_done.json');
    expect(ThemeKit.assetPath('pet/baby/idle.png'), 'assets/theme/pet/baby/idle.png');
  });
}
