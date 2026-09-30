import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../domain/pet/pet_stage.dart';
import '../../../shared/widgets/pet_view.dart';
import '../../../shared/widgets/placeholder_screen.dart';
import '../../../theme_kit/pet_manifest.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kit = ref.watch(themeKitProvider);
    final pet = ref.watch(petProvider).value;
    return PlaceholderScreen(
      title: 'Home',
      message: pet == null
          ? 'Welcome to ${kit.theme.appName}.'
          : 'Welcome to ${kit.theme.appName}. ${pet.name} is settling in. Your goals arrive here soon.',
      child: const PetView(stage: PetStage.baby, pose: PetPose.idle, size: 200, semanticLabel: 'Your pet'),
    );
  }
}
