import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/app/zulu_theme.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../helpers/read_file.dart';

void main() {
  late ThemeKit kit;

  setUpAll(() async => kit = await loadThemeKit(readFile));

  test('light theme uses the manifest colors', () {
    final theme = buildZuluTheme(kit.theme.light, Brightness.light);
    expect(theme.colorScheme.primary, const Color(0xFF6C8CFF));
    expect(theme.colorScheme.brightness, Brightness.light);
    expect(theme.scaffoldBackgroundColor, const Color(0xFFFFF8F0));
    expect(theme.extension<ZuluColors>()!.energy, const Color(0xFFFFC857));
  });

  test('dark theme is dark', () {
    final theme = buildZuluTheme(kit.theme.dark, Brightness.dark);
    expect(theme.colorScheme.brightness, Brightness.dark);
    expect(theme.colorScheme.primary, const Color(0xFF8FA6FF));
  });

  test('ZuluColors interpolates', () {
    const a = ZuluColors(energy: Color(0xFF000000), success: Color(0xFF000000));
    const b = ZuluColors(energy: Color(0xFFFFFFFF), success: Color(0xFFFFFFFF));
    expect(a.lerp(b, 1).energy, const Color(0xFFFFFFFF));
    expect(a.lerp(null, 0.5), same(a));
  });
}
