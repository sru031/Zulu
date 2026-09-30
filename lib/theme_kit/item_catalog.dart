import '../content/json_reader.dart';
import 'pet_manifest.dart';

enum ItemKind { outfit, decor }

class ShopItem {
  const ShopItem({
    required this.id,
    required this.name,
    required this.kind,
    required this.slot,
    required this.price,
    required this.image,
    required this.everyday,
  });

  final String id;
  final String name;
  final ItemKind kind;

  /// An [OutfitSlot] name for outfits, a room slot id for decor.
  final String slot;
  final int price;
  final String image;

  /// Always for sale, as opposed to rotating daily.
  final bool everyday;
}

/// Everything that can be bought (`assets/theme/items/items.json`).
class ItemCatalog {
  ItemCatalog(this.items) : _byId = {for (final i in items) i.id: i};

  static const fileName = 'assets/theme/items/items.json';

  final List<ShopItem> items;
  final Map<String, ShopItem> _byId;

  ShopItem? byId(String id) => _byId[id];

  factory ItemCatalog.fromJson(JsonReader r) {
    final items = <ShopItem>[];
    final ids = <String>{};
    for (final i in r.list('items')) {
      final id = i.string('id');
      if (!ids.add(id)) i.field('id').fail('duplicate item id "$id"');
      final kind = ItemKind.values.asNameMap()[i.string('kind')] ?? i.field('kind').fail('expected outfit or decor');
      final slot = i.string('slot');
      if (kind == ItemKind.outfit && !OutfitSlot.values.asNameMap().containsKey(slot)) {
        i.field('slot').fail('outfit slot must be one of ${OutfitSlot.values.map((s) => s.name).join(', ')}');
      }
      final price = i.integer('price');
      if (price <= 0) i.field('price').fail('must be greater than 0');
      items.add(ShopItem(
        id: id,
        name: i.string('name'),
        kind: kind,
        slot: slot,
        price: price,
        image: i.string('image'),
        everyday: i.boolean('everyday', orElse: false),
      ));
    }
    return ItemCatalog(items);
  }
}
