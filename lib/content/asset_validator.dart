import '../domain/pet/pet_stage.dart';
import '../domain/text/template.dart';
import '../theme_kit/effect_registry.dart';
import '../theme_kit/icon_ref.dart';
import '../theme_kit/item_catalog.dart';
import '../theme_kit/pet_manifest.dart';
import '../theme_kit/room_manifest.dart';
import '../theme_kit/theme_kit.dart';
import '../theme_kit/theme_manifest.dart';
import 'content_bundle.dart';
import 'goal_library.dart';

class ValidationIssue {
  const ValidationIssue.error(this.where, this.message) : isError = true;
  const ValidationIssue.warning(this.where, this.message) : isError = false;

  final bool isError;
  final String where;
  final String message;

  @override
  String toString() => '${isError ? 'ERROR  ' : 'warning'}  $where: $message';
}

/// Checks that every file the manifests refer to exists and that
/// references between files line up.
///
/// [exists] receives full asset paths (e.g. `assets/theme/pet/baby/idle.png`)
/// and must match letter case exactly, because Android asset lookups do.
/// [pngSize], if given, lets the validator warn about pet art that isn't
/// the canvas size.
class AssetValidator {
  AssetValidator({required this.exists, this.pngSize});

  final bool Function(String assetPath) exists;
  final ({int width, int height})? Function(String assetPath)? pngSize;

  List<ValidationIssue> validate({required ThemeKit theme, required ContentBundle content}) {
    final issues = <ValidationIssue>[];

    bool file(String where, String relative) {
      final full = ThemeKit.assetPath(relative);
      if (exists(full)) return true;
      issues.add(ValidationIssue.error(where, 'missing file $full'));
      return false;
    }

    void icon(String where, IconRef ref) {
      if (ref.isImage) file(where, ref.value);
    }

    icon('${ThemeManifest.fileName} currency.icon', theme.theme.currencyIcon);
    for (final (i, mood) in theme.theme.moodIcons.indexed) {
      icon('${ThemeManifest.fileName} moodIcons[$i]', mood);
    }

    for (final egg in theme.pet.eggs) {
      file('${PetManifest.fileName} egg "${egg.id}"', egg.image);
    }
    final canvas = theme.pet.canvasSize;
    for (final stage in PetStage.values) {
      final art = theme.pet.stages[stage];
      if (art == null) {
        issues.add(ValidationIssue.warning(PetManifest.fileName, 'no art for stage "${stage.name}" yet; baby art will be shown'));
        continue;
      }
      for (final pose in PetPose.values) {
        final spec = art.poses[pose];
        final where = '${PetManifest.fileName} ${stage.name}.${pose.name}';
        if (spec == null) {
          issues.add(ValidationIssue.warning(where, 'no art yet; the ${stage.name} idle pose will be shown'));
          continue;
        }
        if (!file(where, spec.path) || spec is! PngPose) continue;
        final size = pngSize?.call(ThemeKit.assetPath(spec.path));
        if (size != null && (size.width != canvas || size.height != canvas)) {
          issues.add(ValidationIssue.warning(
            where,
            'is ${size.width}×${size.height}; pet art should be ${canvas.round()}×${canvas.round()} so outfits line up',
          ));
        }
      }
    }

    final home = theme.rooms.home;
    for (final item in theme.items.items) {
      final where = '${ItemCatalog.fileName} "${item.id}"';
      file(where, item.image);
      if (item.kind == ItemKind.decor && !home.slots.containsKey(item.slot)) {
        issues.add(ValidationIssue.error(where, 'decor slot "${item.slot}" does not exist in room "${home.id}"'));
      }
    }
    for (final room in theme.rooms.rooms) {
      file('${RoomManifest.fileName} "${room.id}"', room.background);
    }

    for (final name in EffectName.values) {
      final path = theme.effects.fileFor(name);
      if (path == null) {
        issues.add(ValidationIssue.warning(EffectRegistry.fileName, 'no file for effect "${name.id}"; a built-in animation will be used'));
      } else {
        file('${EffectRegistry.fileName} ${name.id}', path);
      }
    }

    for (final goal in content.goals.goals) {
      final unknown = unknownPlaceholders(goal.title);
      if (unknown.isNotEmpty) {
        issues.add(ValidationIssue.error(
          '${GoalLibrary.fileName} "${goal.id}"',
          'unknown placeholders ${unknown.map((u) => '{$u}').join(', ')}',
        ));
      }
    }
    return issues;
  }
}
