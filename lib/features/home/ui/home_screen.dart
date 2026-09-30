import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../domain/pet/pet_stage.dart';
import '../../../shared/widgets/placeholder_screen.dart';
import '../../../theme_kit/pet_manifest.dart';
import '../../../theme_kit/theme_kit.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kit = ref.watch(themeKitProvider);
    final pose = kit.pet.pose(PetStage.baby, PetPose.idle);
    return PlaceholderScreen(
      title: 'Home',
      message: 'Welcome to ${kit.theme.appName}. Your pet is waiting to hatch.',
      child: pose is PngPose
          ? Image.asset(ThemeKit.assetPath(pose.path), width: 200, height: 200, semanticLabel: 'Your pet')
          : null,
    );
  }
}
