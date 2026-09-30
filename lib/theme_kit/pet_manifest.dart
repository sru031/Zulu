import '../content/json_reader.dart';
import '../domain/pet/pet_stage.dart';
import 'placement.dart';

enum PetPose { idle, happy, curious, sleepy, away, celebrate, hatch }

/// Where outfit items attach to the pet.
enum OutfitSlot { head, face, neck, body, held }

/// How one pose is drawn. [path] is relative to `assets/theme/`.
sealed class PoseSpec {
  const PoseSpec(this.path);

  final String path;
}

final class PngPose extends PoseSpec {
  const PngPose(super.path);
}

final class RivePose extends PoseSpec {
  const RivePose(super.path, {this.artboard, this.stateMachine, this.trigger});

  final String? artboard;
  final String? stateMachine;

  /// State-machine trigger fired when this pose is shown.
  final String? trigger;
}

final class LottiePose extends PoseSpec {
  const LottiePose(super.path, {this.loop = true});

  final bool loop;
}

class EggOption {
  const EggOption({required this.id, required this.image});

  final String id;
  final String image;
}

class StageArt {
  const StageArt({required this.poses, required this.anchors});

  final Map<PetPose, PoseSpec> poses;
  final Map<OutfitSlot, Placement> anchors;
}

/// The pet's art (`assets/theme/pet/pet.json`). Any stage or pose may be
/// missing except the baby idle pose, which every fallback ends at.
class PetManifest {
  const PetManifest({required this.canvasSize, required this.eggs, required this.stages});

  static const fileName = 'assets/theme/pet/pet.json';

  /// Pet art is square; anchors are in pixels on this canvas.
  final double canvasSize;
  final List<EggOption> eggs;
  final Map<PetStage, StageArt> stages;

  /// The art for [pose] at [stage], falling back to that stage's idle pose,
  /// then to the baby idle pose.
  PoseSpec pose(PetStage stage, PetPose pose) =>
      stages[stage]?.poses[pose] ??
      stages[stage]?.poses[PetPose.idle] ??
      stages[PetStage.baby]!.poses[PetPose.idle]!;

  /// Where outfits sit at [stage]. Stages without anchors reuse the baby's.
  Map<OutfitSlot, Placement> anchors(PetStage stage) {
    final own = stages[stage]?.anchors;
    return (own == null || own.isEmpty) ? stages[PetStage.baby]!.anchors : own;
  }

  factory PetManifest.fromJson(JsonReader r) {
    final stages = <PetStage, StageArt>{};
    for (final entry in r.map('stages').entries) {
      final stage = PetStage.values.asNameMap()[entry.key] ??
          entry.value.fail('unknown stage "${entry.key}" (expected baby, toddler, teen or adult)');
      final poses = <PetPose, PoseSpec>{};
      for (final p in entry.value.map('poses').entries) {
        final pose = PetPose.values.asNameMap()[p.key] ?? p.value.fail('unknown pose "${p.key}"');
        poses[pose] = _poseSpec(p.value);
      }
      final anchors = <OutfitSlot, Placement>{};
      final anchorsJson = entry.value.optional('anchors');
      if (anchorsJson != null) {
        for (final a in anchorsJson.asMap().entries) {
          final slot = OutfitSlot.values.asNameMap()[a.key] ?? a.value.fail('unknown outfit slot "${a.key}"');
          anchors[slot] = Placement.fromJson(a.value);
        }
      }
      stages[stage] = StageArt(poses: poses, anchors: anchors);
    }
    if (stages[PetStage.baby]?.poses[PetPose.idle] == null) {
      r.field('stages').fail('the baby stage must have an idle pose');
    }
    return PetManifest(
      canvasSize: r.number('canvas'),
      eggs: [for (final e in r.list('eggs')) EggOption(id: e.string('id'), image: e.string('image'))],
      stages: stages,
    );
  }
}

PoseSpec _poseSpec(JsonReader r) => switch (r.string('type')) {
      'png' => PngPose(r.string('path')),
      'rive' => RivePose(
          r.string('path'),
          artboard: r.optString('artboard'),
          stateMachine: r.optString('stateMachine'),
          trigger: r.optString('trigger'),
        ),
      'lottie' => LottiePose(r.string('path'), loop: r.boolean('loop', orElse: true)),
      final other => r.field('type').fail('unknown pose type "$other" (expected png, rive or lottie)'),
    };
