// Generates Zulu's placeholder art: simple PNGs and small Lottie files.
// Every file keeps the name the manifests expect, so the owner's real art
// can replace these one file at a time.
//
// Run from the project root:  dart run tool/gen_placeholders.dart
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

const _theme = 'assets/theme';

void main() {
  _eggs();
  _pet();
  _items();
  _room();
  _icons();
  _effects();
  stdout.writeln('Placeholder art written to $_theme/');
}

img.Color _rgba(int hex, [int alpha = 255]) =>
    img.ColorRgba8((hex >> 16) & 0xFF, (hex >> 8) & 0xFF, hex & 0xFF, alpha);

img.Image _canvas(int width, int height) => img.Image(width: width, height: height, numChannels: 4);

void _save(img.Image image, String relative) {
  final file = File('$_theme/$relative')..parent.createSync(recursive: true);
  file.writeAsBytesSync(img.encodePng(image));
}

void _fillEllipse(img.Image image, {required int cx, required int cy, required int rx, required int ry, required img.Color color}) {
  for (var y = -ry; y <= ry; y++) {
    final half = (rx * math.sqrt(1 - (y * y) / (ry * ry))).round();
    img.drawLine(image, x1: cx - half, y1: cy + y, x2: cx + half, y2: cy + y, color: color);
  }
}

// ---- Eggs ----

const _eggColors = {
  'sunrise': 0xFFB38A,
  'sky': 0x8EC5FF,
  'mint': 0x9BE3C3,
  'lilac': 0xC7B3FF,
  'blush': 0xFFB3CF,
  'sand': 0xE8D5A8,
};

void _eggs() {
  for (final entry in _eggColors.entries) {
    final image = _canvas(256, 320);
    _fillEllipse(image, cx: 128, cy: 170, rx: 100, ry: 135, color: _rgba(entry.value));
    for (final (x, y, r) in [(90, 120, 16), (160, 150, 20), (110, 230, 14), (170, 240, 12)]) {
      img.fillCircle(image, x: x, y: y, radius: r, color: _rgba(0xFFFFFF, 140), antialias: true);
    }
    _save(image, 'pet/eggs/${entry.key}.png');
  }
}

// ---- Pet ----

const _stageRadius = {'baby': 110, 'toddler': 135, 'teen': 155, 'adult': 175};
const _poses = ['idle', 'happy', 'curious', 'sleepy', 'away', 'celebrate', 'hatch'];

void _pet() {
  for (final stage in _stageRadius.entries) {
    for (final pose in _poses) {
      _save(_petPose(stage.value, pose), 'pet/${stage.key}/$pose.png');
    }
  }
}

img.Image _petPose(int r, String pose) {
  final image = _canvas(512, 512);
  const cx = 256, cy = 300;
  final alpha = pose == 'away' ? 110 : 255;
  final body = _rgba(0xFFC48A, alpha);
  final ink = _rgba(0x3A2E2A, alpha);
  final beak = _rgba(0xF2A23A, alpha);

  if (pose == 'celebrate') {
    for (final side in [-1, 1]) {
      img.fillCircle(image, x: cx + side * (r + 10), y: cy - r ~/ 2, radius: r ~/ 4, color: body, antialias: true);
    }
  }
  img.fillCircle(image, x: cx, y: cy, radius: r, color: body, antialias: true);

  final eyeY = cy - r ~/ 5;
  final eyeDx = r ~/ 3;
  final eyeR = math.max(6, r ~/ 12);
  switch (pose) {
    case 'sleepy':
      for (final dx in [-eyeDx, eyeDx]) {
        img.drawLine(image, x1: cx + dx - eyeR, y1: eyeY, x2: cx + dx + eyeR, y2: eyeY, color: ink, thickness: 4);
      }
    case 'happy' || 'celebrate':
      for (final dx in [-eyeDx, eyeDx]) {
        img.drawLine(image, x1: cx + dx - eyeR, y1: eyeY + eyeR ~/ 2, x2: cx + dx, y2: eyeY - eyeR ~/ 2, color: ink, thickness: 4);
        img.drawLine(image, x1: cx + dx, y1: eyeY - eyeR ~/ 2, x2: cx + dx + eyeR, y2: eyeY + eyeR ~/ 2, color: ink, thickness: 4);
      }
    case 'curious':
      img.fillCircle(image, x: cx - eyeDx, y: eyeY, radius: eyeR, color: ink, antialias: true);
      img.fillCircle(image, x: cx + eyeDx, y: eyeY, radius: eyeR + 4, color: ink, antialias: true);
      img.drawString(image, '?', font: img.arial48, x: cx + r - 20, y: cy - r - 40, color: ink);
    default:
      for (final dx in [-eyeDx, eyeDx]) {
        img.fillCircle(image, x: cx + dx, y: eyeY, radius: eyeR, color: ink, antialias: true);
      }
  }
  img.fillPolygon(
    image,
    vertices: [img.Point(cx - 10, eyeY + eyeR + 8), img.Point(cx + 10, eyeY + eyeR + 8), img.Point(cx, eyeY + eyeR + 22)],
    color: beak,
  );

  if (pose == 'hatch') {
    final shellTop = cy + r ~/ 4;
    img.fillRect(image, x1: cx - r - 20, y1: shellTop, x2: cx + r + 20, y2: cy + r + 30, color: _rgba(0xFFF3E0), radius: 30);
    for (var x = cx - r - 20; x < cx + r + 20; x += 30) {
      img.drawLine(image, x1: x, y1: shellTop, x2: x + 15, y2: shellTop - 15, color: ink, thickness: 3);
      img.drawLine(image, x1: x + 15, y1: shellTop - 15, x2: x + 30, y2: shellTop, color: ink, thickness: 3);
    }
  }

  img.drawString(image, pose, font: img.arial24, x: 16, y: 16, color: _rgba(0x888888));
  return image;
}

// ---- Items ----

const _itemArt = <String, (int, String)>{
  'sun_hat': (0xF6C453, 'hat'),
  'flower_crown': (0xF49AC1, 'crown'),
  'round_glasses': (0x3A2E2A, 'glasses'),
  'star_glasses': (0xF6C453, 'glasses'),
  'cozy_scarf': (0xE85D5D, 'scarf'),
  'bow_tie': (0x6C8CFF, 'bow'),
  'rain_coat': (0xF6D55C, 'coat'),
  'sweater': (0x8FD3B6, 'coat'),
  'balloon': (0xFF7A7A, 'balloon'),
  'tea_cup': (0xFFFFFF, 'cup'),
  'potted_plant': (0x5BAE6A, 'plant'),
  'floor_lamp': (0xF6C453, 'lamp'),
  'star_poster': (0x6C8CFF, 'poster'),
  'wall_clock': (0xFFFFFF, 'clock'),
  'wind_chime': (0x9BD3E8, 'chime'),
};

void _items() {
  final ink = _rgba(0x3A2E2A);
  for (final entry in _itemArt.entries) {
    final (hex, shape) = entry.value;
    final c = _rgba(hex);
    final image = _canvas(256, 256);
    switch (shape) {
      case 'hat':
        img.fillPolygon(image, vertices: [img.Point(128, 40), img.Point(40, 190), img.Point(216, 190)], color: c);
        img.fillRect(image, x1: 20, y1: 180, x2: 236, y2: 205, color: c, radius: 10);
      case 'crown':
        for (var i = 0; i < 5; i++) {
          img.fillCircle(image, x: 48 + i * 40, y: 128, radius: 22, color: c, antialias: true);
        }
      case 'glasses':
        for (final x in [80, 176]) {
          img.drawCircle(image, x: x, y: 128, radius: 40, color: c, antialias: true);
          img.drawCircle(image, x: x, y: 128, radius: 38, color: c, antialias: true);
        }
        img.drawLine(image, x1: 120, y1: 128, x2: 136, y2: 128, color: c, thickness: 4);
      case 'scarf' || 'bow':
        img.fillRect(image, x1: 30, y1: 100, x2: 226, y2: 156, color: c, radius: 24);
      case 'coat':
        img.fillRect(image, x1: 50, y1: 40, x2: 206, y2: 230, color: c, radius: 40);
      case 'balloon':
        img.fillCircle(image, x: 128, y: 90, radius: 70, color: c, antialias: true);
        img.drawLine(image, x1: 128, y1: 160, x2: 128, y2: 250, color: ink, thickness: 3);
      case 'cup':
        img.fillRect(image, x1: 70, y1: 100, x2: 186, y2: 210, color: c, radius: 16);
        img.drawCircle(image, x: 196, y: 150, radius: 26, color: ink);
      case 'plant':
        img.fillRect(image, x1: 80, y1: 150, x2: 176, y2: 240, color: _rgba(0xC8744A), radius: 10);
        for (final (x, y) in [(128, 90), (90, 120), (166, 120)]) {
          img.fillCircle(image, x: x, y: y, radius: 40, color: c, antialias: true);
        }
      case 'lamp':
        img.drawLine(image, x1: 128, y1: 90, x2: 128, y2: 240, color: ink, thickness: 6);
        img.fillPolygon(image, vertices: [img.Point(70, 100), img.Point(186, 100), img.Point(156, 30), img.Point(100, 30)], color: c);
      case 'poster':
        img.fillRect(image, x1: 40, y1: 20, x2: 216, y2: 236, color: c, radius: 6);
        img.drawString(image, '*', font: img.arial48, x: 110, y: 100, color: _rgba(0xFFFFFF));
      case 'clock':
        img.fillCircle(image, x: 128, y: 128, radius: 100, color: c, antialias: true);
        img.drawCircle(image, x: 128, y: 128, radius: 100, color: ink, antialias: true);
        img.drawLine(image, x1: 128, y1: 128, x2: 128, y2: 60, color: ink, thickness: 5);
        img.drawLine(image, x1: 128, y1: 128, x2: 175, y2: 128, color: ink, thickness: 5);
      case 'chime':
        img.drawLine(image, x1: 50, y1: 40, x2: 206, y2: 40, color: ink, thickness: 6);
        for (var i = 0; i < 4; i++) {
          img.drawLine(image, x1: 70 + i * 38, y1: 40, x2: 70 + i * 38, y2: 140 + i * 20, color: c, thickness: 8);
        }
    }
    img.drawString(image, entry.key, font: img.arial14, x: 8, y: 238, color: ink);
    _save(image, 'items/${entry.key}.png');
  }
}

// ---- Room and icons ----

void _room() {
  final image = _canvas(1080, 1080);
  img.fill(image, color: _rgba(0xFBE9D7));
  img.fillRect(image, x1: 0, y1: 700, x2: 1080, y2: 1080, color: _rgba(0xE3C29B));
  img.fillRect(image, x1: 0, y1: 690, x2: 1080, y2: 710, color: _rgba(0xC99E72));
  img.fillRect(image, x1: 400, y1: 140, x2: 680, y2: 380, color: _rgba(0xBFE3F7), radius: 20);
  img.drawLine(image, x1: 540, y1: 140, x2: 540, y2: 380, color: _rgba(0xFFFFFF), thickness: 8);
  img.drawLine(image, x1: 400, y1: 260, x2: 680, y2: 260, color: _rgba(0xFFFFFF), thickness: 8);
  _save(image, 'rooms/home/background.png');
}

void _icons() {
  final coin = _canvas(128, 128);
  img.fillCircle(coin, x: 64, y: 64, radius: 58, color: _rgba(0xF6C453), antialias: true);
  img.fillCircle(coin, x: 64, y: 64, radius: 40, color: _rgba(0xF9D77E), antialias: true);
  _save(coin, 'icons/currency.png');
}

// ---- Lottie effects ----

Map<String, Object> _still(Object value) => {'a': 0, 'k': value};

/// Keyframes as (frame, value) pairs, eased in and out.
Map<String, Object> _keys(List<(int, List<num>)> frames) => {
      'a': 1,
      'k': [
        for (var i = 0; i < frames.length; i++)
          {
            't': frames[i].$1,
            's': frames[i].$2,
            if (i < frames.length - 1) ...{
              'i': {'x': [0.4], 'y': [1]},
              'o': {'x': [0.6], 'y': [0]},
            },
          },
      ],
    };

List<num> _rgb(int hex) => [((hex >> 16) & 0xFF) / 255, ((hex >> 8) & 0xFF) / 255, (hex & 0xFF) / 255, 1];

Map<String, Object> _dot({
  required int index,
  required int frames,
  required int color,
  required num size,
  required Map<String, Object> position,
  Map<String, Object>? scale,
  Map<String, Object>? opacity,
}) =>
    {
      'ddd': 0,
      'ind': index,
      'ty': 4,
      'nm': 'dot$index',
      'sr': 1,
      'ks': {
        'o': opacity ?? _still(100),
        'r': _still(0),
        'p': position,
        'a': _still([0, 0, 0]),
        's': scale ?? _still([100, 100, 100]),
      },
      'ao': 0,
      'shapes': [
        {
          'ty': 'gr',
          'nm': 'shape',
          'it': [
            {'ty': 'el', 'nm': 'ellipse', 'd': 1, 'p': _still([0, 0]), 's': _still([size, size])},
            {'ty': 'fl', 'nm': 'fill', 'c': _still(_rgb(color)), 'o': _still(100), 'r': 1},
            {
              'ty': 'tr',
              'p': _still([0, 0]),
              'a': _still([0, 0]),
              's': _still([100, 100]),
              'r': _still(0),
              'o': _still(100),
              'sk': _still(0),
              'sa': _still(0),
            },
          ],
        },
      ],
      'ip': 0,
      'op': frames,
      'st': 0,
      'bm': 0,
    };

void _lottie(String name, int frames, List<Map<String, Object>> layers) {
  final json = {
    'v': '5.7.4',
    'fr': 30,
    'ip': 0,
    'op': frames,
    'w': 200,
    'h': 200,
    'nm': name,
    'ddd': 0,
    'assets': <Object>[],
    'layers': layers,
  };
  File('$_theme/effects/$name.json')
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(jsonEncode(json));
}

/// Dots flying out from the center and fading: confetti, coins, milestones.
List<Map<String, Object>> _burst({
  required int count,
  required List<int> colors,
  required num distance,
  required int frames,
  num size = 18,
}) =>
    [
      for (var i = 0; i < count; i++)
        _dot(
          index: i + 1,
          frames: frames,
          color: colors[i % colors.length],
          size: size,
          position: _keys([
            (0, [100, 100, 0]),
            (frames, [100 + distance * math.cos(2 * math.pi * i / count), 100 + distance * math.sin(2 * math.pi * i / count), 0]),
          ]),
          opacity: _keys([(0, [100]), ((frames * 0.6).round(), [100]), (frames, [0])]),
          scale: _keys([(0, [40, 40, 100]), ((frames * 0.3).round(), [110, 110, 100]), (frames, [70, 70, 100])]),
        ),
    ];

void _effects() {
  const gold = 0xF6C453, green = 0x4CAF7A, blue = 0x6C8CFF, pink = 0xF49AC1, peach = 0xFFB38A;
  _lottie('goal_done', 24, [
    _dot(
      index: 1,
      frames: 24,
      color: green,
      size: 120,
      position: _still([100, 100, 0]),
      scale: _keys([(0, [0, 0, 100]), (10, [115, 115, 100]), (16, [100, 100, 100])]),
      opacity: _keys([(0, [100]), (16, [100]), (24, [0])]),
    ),
  ]);
  _lottie('coins_burst', 30, _burst(count: 6, colors: [gold], distance: 80, frames: 30));
  _lottie('energy_full', 30, [
    _dot(
      index: 1,
      frames: 30,
      color: gold,
      size: 140,
      position: _still([100, 100, 0]),
      scale: _keys([(0, [60, 60, 100]), (12, [125, 125, 100]), (30, [100, 100, 100])]),
      opacity: _keys([(0, [0]), (8, [80]), (30, [0])]),
    ),
  ]);
  _lottie('hatch_crack', 30, [
    _dot(
      index: 1,
      frames: 30,
      color: peach,
      size: 130,
      position: _keys([
        (0, [100, 100, 0]),
        (6, [92, 100, 0]),
        (12, [108, 100, 0]),
        (18, [94, 100, 0]),
        (24, [104, 100, 0]),
        (30, [100, 100, 0]),
      ]),
    ),
  ]);
  _lottie('plan_loading', 45, [
    for (var i = 0; i < 3; i++)
      _dot(
        index: i + 1,
        frames: 45,
        color: blue,
        size: 28,
        position: _still([60 + 40 * i, 100, 0]),
        scale: _keys([(0, [60, 60, 100]), (8 + i * 8, [130, 130, 100]), (24 + i * 8, [60, 60, 100]), (45, [60, 60, 100])]),
      ),
  ]);
  _lottie('adventure_depart', 30, [
    _dot(
      index: 1,
      frames: 30,
      color: peach,
      size: 90,
      position: _keys([(0, [100, 120, 0]), (30, [100, 10, 0])]),
      opacity: _keys([(0, [100]), (30, [0])]),
    ),
  ]);
  _lottie('adventure_return', 30, [
    _dot(
      index: 1,
      frames: 30,
      color: peach,
      size: 90,
      position: _keys([(0, [100, -40, 0]), (20, [100, 110, 0]), (30, [100, 100, 0])]),
      opacity: _keys([(0, [0]), (10, [100])]),
    ),
  ]);
  _lottie('milestone', 40, _burst(count: 8, colors: [gold, pink, blue, green], distance: 90, frames: 40, size: 22));
  _lottie('evolve', 40, [
    _dot(
      index: 1,
      frames: 40,
      color: gold,
      size: 120,
      position: _still([100, 100, 0]),
      scale: _keys([(0, [50, 50, 100]), (40, [160, 160, 100])]),
      opacity: _keys([(0, [90]), (40, [0])]),
    ),
    _dot(
      index: 2,
      frames: 40,
      color: peach,
      size: 90,
      position: _still([100, 100, 0]),
      scale: _keys([(0, [100, 100, 100]), (20, [120, 120, 100]), (40, [100, 100, 100])]),
    ),
  ]);
  _lottie('surprise_gift', 30, [
    _dot(
      index: 1,
      frames: 30,
      color: pink,
      size: 80,
      position: _keys([(0, [100, 120, 0]), (10, [100, 60, 0]), (20, [100, 110, 0]), (30, [100, 100, 0])]),
    ),
  ]);
}
