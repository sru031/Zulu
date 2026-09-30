import '../content/json_reader.dart';
import 'placement.dart';

class Room {
  const Room({
    required this.id,
    required this.background,
    required this.width,
    required this.height,
    required this.pet,
    required this.slots,
  });

  final String id;
  final String background;
  final double width;
  final double height;

  /// Where the pet stands, on the room canvas.
  final Placement pet;

  /// Named spots where decor items go.
  final Map<String, Placement> slots;
}

/// The pet's home (`assets/theme/rooms/rooms.json`). v1 uses the first room.
class RoomManifest {
  const RoomManifest(this.rooms);

  static const fileName = 'assets/theme/rooms/rooms.json';

  final List<Room> rooms;

  Room get home => rooms.first;

  factory RoomManifest.fromJson(JsonReader r) {
    final rooms = [
      for (final room in r.list('rooms'))
        Room(
          id: room.string('id'),
          background: room.string('background'),
          width: room.number('width'),
          height: room.number('height'),
          pet: Placement.fromJson(room.field('pet')),
          slots: {for (final s in room.map('slots').entries) s.key: Placement.fromJson(s.value)},
        ),
    ];
    if (rooms.isEmpty) r.field('rooms').fail('needs at least one room');
    return RoomManifest(rooms);
  }
}
