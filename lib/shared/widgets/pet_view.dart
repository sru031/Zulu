import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../domain/pet/pet_stage.dart';
import '../../theme_kit/pet_manifest.dart';
import '../../theme_kit/theme_kit.dart';

/// Draws the pet in [pose] at [stage], using whatever format the theme's
/// art is in. Rive poses show the baby idle image until Plan 3 adds Rive.
class PetView extends ConsumerWidget {
  const PetView({super.key, required this.stage, required this.pose, this.size = 200, this.semanticLabel});

  final PetStage stage;
  final PetPose pose;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pet = ref.watch(themeKitProvider).pet;
    final spec = pet.pose(stage, pose);
    final babyIdle = pet.pose(PetStage.baby, PetPose.idle);
    final child = switch (spec) {
      PngPose(:final path) => _image(path),
      LottiePose(:final path, :final loop) => Lottie.asset(
          ThemeKit.assetPath(path),
          repeat: loop,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stack) => _fallback(babyIdle),
        ),
      RivePose() => _fallback(babyIdle),
    };
    return Semantics(
      label: semanticLabel,
      image: true,
      child: SizedBox.square(dimension: size, child: child),
    );
  }

  Widget _image(String path) => Image.asset(
        ThemeKit.assetPath(path),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stack) => const _Blob(),
      );

  Widget _fallback(PoseSpec babyIdle) => babyIdle is PngPose ? _image(babyIdle.path) : const _Blob();
}

/// Last-resort pet drawing when no art can be shown at all.
class _Blob extends StatelessWidget {
  const _Blob();

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle),
      );
}
