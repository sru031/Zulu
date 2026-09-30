import '../content/json_reader.dart';
import 'icon_ref.dart';

final _hexColor = RegExp(r'^#([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$');

/// Parses `#RRGGBB` (opaque) or `#AARRGGBB` into a 32-bit ARGB int.
int parseHexColor(JsonReader r) {
  final match = _hexColor.firstMatch(r.asString());
  if (match == null) r.fail('expected a color like #RRGGBB or #AARRGGBB');
  final hex = match[1]!;
  return int.parse(hex.length == 6 ? 'FF$hex' : hex, radix: 16);
}

/// One color scheme (light or dark), as ARGB ints so this file stays
/// Flutter-free.
class ThemePalette {
  const ThemePalette({
    required this.primary,
    required this.background,
    required this.surface,
    required this.text,
    required this.energy,
    required this.success,
  });

  factory ThemePalette.fromJson(JsonReader r) => ThemePalette(
        primary: parseHexColor(r.field('primary')),
        background: parseHexColor(r.field('background')),
        surface: parseHexColor(r.field('surface')),
        text: parseHexColor(r.field('text')),
        energy: parseHexColor(r.field('energy')),
        success: parseHexColor(r.field('success')),
      );

  final int primary;
  final int background;
  final int surface;
  final int text;
  final int energy;
  final int success;
}

/// Names and colors of the owner's world (`assets/theme/theme.json`).
class ThemeManifest {
  const ThemeManifest({
    required this.appName,
    required this.petSpecies,
    required this.petSpeciesPlural,
    required this.currency,
    required this.currencyPlural,
    required this.currencyIcon,
    required this.light,
    required this.dark,
    required this.moodIcons,
  });

  static const fileName = 'assets/theme/theme.json';

  final String appName;
  final String petSpecies;
  final String petSpeciesPlural;
  final String currency;
  final String currencyPlural;
  final IconRef currencyIcon;
  final ThemePalette light;
  final ThemePalette dark;

  /// Five icons, from lowest mood to highest.
  final List<IconRef> moodIcons;

  factory ThemeManifest.fromJson(JsonReader r) {
    final species = r.field('petSpecies');
    final currency = r.field('currency');
    final colors = r.field('colors');
    final moods = r.list('moodIcons');
    if (moods.length != 5) r.field('moodIcons').fail('needs exactly 5 icons, from lowest to highest mood');
    return ThemeManifest(
      appName: r.string('appName'),
      petSpecies: species.string('singular'),
      petSpeciesPlural: species.string('plural'),
      currency: currency.string('singular'),
      currencyPlural: currency.string('plural'),
      currencyIcon: IconRef(currency.string('icon')),
      light: ThemePalette.fromJson(colors.field('light')),
      dark: ThemePalette.fromJson(colors.field('dark')),
      moodIcons: [for (final m in moods) IconRef(m.asString())],
    );
  }
}
