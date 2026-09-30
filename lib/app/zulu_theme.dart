import 'package:material_ui/material_ui.dart';

import '../theme_kit/theme_manifest.dart';

/// Zulu-specific colors that Material's ColorScheme has no slot for.
@immutable
class ZuluColors extends ThemeExtension<ZuluColors> {
  const ZuluColors({required this.energy, required this.success});

  final Color energy;
  final Color success;

  @override
  ZuluColors copyWith({Color? energy, Color? success}) =>
      ZuluColors(energy: energy ?? this.energy, success: success ?? this.success);

  @override
  ZuluColors lerp(ZuluColors? other, double t) {
    if (other == null) return this;
    return ZuluColors(
      energy: Color.lerp(energy, other.energy, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

ThemeData buildZuluTheme(ThemePalette palette, Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: Color(palette.primary), brightness: brightness).copyWith(
    primary: Color(palette.primary),
    surface: Color(palette.surface),
    onSurface: Color(palette.text),
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: Color(palette.background),
    extensions: [ZuluColors(energy: Color(palette.energy), success: Color(palette.success))],
  );
}

extension ZuluThemeX on BuildContext {
  ZuluColors get zuluColors => Theme.of(this).extension<ZuluColors>()!;
}
