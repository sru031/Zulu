import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/domain/pet/pet_stage.dart';
import 'package:zulu/shared/widgets/pet_view.dart';
import 'package:zulu/theme_kit/pet_manifest.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../helpers/read_file.dart';
import '../helpers/test_app.dart';

void main() {
  late ThemeKit kit;

  setUpAll(() async => kit = await loadThemeKit(readFile));

  ThemeKit withTeenArt(Map<PetPose, PoseSpec> poses) => ThemeKit(
        theme: kit.theme,
        pet: PetManifest(
          canvasSize: kit.pet.canvasSize,
          eggs: kit.pet.eggs,
          stages: {...kit.pet.stages, PetStage.teen: StageArt(poses: poses, anchors: const {})},
        ),
        items: kit.items,
        rooms: kit.rooms,
        effects: kit.effects,
      );

  testWidgets('shows a PNG pose as an image', (tester) async {
    await pumpInApp(tester, const PetView(stage: PetStage.baby, pose: PetPose.happy), kit: kit);
    final image = tester.widget<Image>(find.byType(Image));
    expect((image.image as AssetImage).assetName, 'assets/theme/pet/baby/happy.png');
  });

  testWidgets('shows a Lottie pose as an animation', (tester) async {
    await pumpInApp(
      tester,
      const PetView(stage: PetStage.teen, pose: PetPose.idle),
      kit: withTeenArt({PetPose.idle: const LottiePose('effects/evolve.json')}),
    );
    expect(find.byType(LottieBuilder), findsOneWidget);
  });

  testWidgets('shows the baby idle image for Rive poses until Rive is supported', (tester) async {
    await pumpInApp(
      tester,
      const PetView(stage: PetStage.teen, pose: PetPose.idle),
      kit: withTeenArt({PetPose.idle: const RivePose('pet/teen/pet.riv')}),
    );
    final image = tester.widget<Image>(find.byType(Image));
    expect((image.image as AssetImage).assetName, 'assets/theme/pet/baby/idle.png');
  });
}
