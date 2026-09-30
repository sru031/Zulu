import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/app/providers.dart';
import 'package:zulu/app/zulu_theme.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

/// Pumps [child] inside a MaterialApp with Zulu's theme and the theme kit
/// provided, as the real app does.
Future<void> pumpInApp(
  WidgetTester tester,
  Widget child, {
  required ThemeKit kit,
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(ProviderScope(
    overrides: [themeKitProvider.overrideWithValue(kit), ...overrides],
    child: MaterialApp(theme: buildZuluTheme(kit.theme.light, Brightness.light), home: Scaffold(body: Center(child: child))),
  ));
}
