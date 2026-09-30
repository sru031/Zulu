import '../content/json_reader.dart';
import 'effect_registry.dart';
import 'item_catalog.dart';
import 'pet_manifest.dart';
import 'room_manifest.dart';
import 'theme_manifest.dart';

/// Everything visual and every in-world name, loaded from `assets/theme/`.
class ThemeKit {
  const ThemeKit({
    required this.theme,
    required this.pet,
    required this.items,
    required this.rooms,
    required this.effects,
  });

  static const root = 'assets/theme/';

  final ThemeManifest theme;
  final PetManifest pet;
  final ItemCatalog items;
  final RoomManifest rooms;
  final EffectRegistry effects;

  /// The full asset path for a path written relative to `assets/theme/`.
  static String assetPath(String relative) => '$root$relative';
}

Future<ThemeKit> loadThemeKit(ReadText read) async {
  Future<JsonReader> open(String path) async => JsonReader.decode(path, await read(path));
  return ThemeKit(
    theme: ThemeManifest.fromJson(await open(ThemeManifest.fileName)),
    pet: PetManifest.fromJson(await open(PetManifest.fileName)),
    items: ItemCatalog.fromJson(await open(ItemCatalog.fileName)),
    rooms: RoomManifest.fromJson(await open(RoomManifest.fileName)),
    effects: EffectRegistry.fromJson(await open(EffectRegistry.fileName)),
  );
}
