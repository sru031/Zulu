import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/app/app.dart';
import 'package:zulu/app/providers.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../helpers/read_file.dart';

void main() {
  late ContentBundle content;
  late ThemeKit kit;

  setUpAll(() async {
    content = await loadContent(readFile);
    kit = await loadThemeKit(readFile);
  });

  Future<void> pumpApp(WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        contentProvider.overrideWithValue(content),
        themeKitProvider.overrideWithValue(kit),
      ],
      child: const ZuluApp(),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('boots into Home with five tabs', (tester) async {
    await pumpApp(tester);
    expect(find.byType(NavigationBar), findsOneWidget);
    for (final label in ['Home', 'Shop', 'Bag', 'Journal', 'Me']) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    expect(find.textContaining('Welcome to Zulu'), findsOneWidget);
  });

  testWidgets('switches tabs', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Shop'));
    await tester.pumpAndSettle();
    expect(find.text('The shop opens soon.'), findsOneWidget);
    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    expect(find.text("Your pet's profile and settings will live here."), findsOneWidget);
  });
}
