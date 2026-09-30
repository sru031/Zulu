import '../content/json_reader.dart';

/// A point (and size multiplier) on an art canvas, in canvas pixels.
class Placement {
  const Placement({required this.x, required this.y, this.scale = 1});

  factory Placement.fromJson(JsonReader r) =>
      Placement(x: r.number('x'), y: r.number('y'), scale: r.optNumber('scale') ?? 1);

  final double x;
  final double y;
  final double scale;
}
