import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/app/app.dart';
import 'package:zulu/app/providers.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/content/goal_library.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/goal_repository.dart';
import 'package:zulu/data/repositories/pet_repository.dart';
import 'package:zulu/data/repositories/profile_repository.dart';
import 'package:zulu/domain/pet/trait.dart';
import 'package:zulu/domain/text/template.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../../helpers/read_file.dart';

class NoGiftRandom implements Random {
  @override
  double nextDouble() => 0.99;
  @override
  int nextInt(int max) => 0;
  @override
  bool nextBool() => false;
}

void main() {
  late ContentBundle content;
  late ThemeKit kit;

  setUpAll(() async {
    content = await loadContent(readFile);
    kit = await loadThemeKit(readFile);
  });

  testWidgets('checking off goals fills energy and sends the pet on an adventure', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    final clock = FakeClock(DateTime(2026, 10, 5, 9));
    await tester.runAsync(() async {
      final profiles = ProfileRepository(db, clock);
      await profiles.ensure();
      await profiles.update(ProfilesCompanion(onboardingDoneAt: Value(clock.now())));
      await PetRepository(db).save(
        name: 'Mochi',
        pronouns: Pronouns.she,
        eggColor: 'mint',
        trait: Trait.calm,
        traitStats: {Trait.calm: 6},
        hatchedAt: clock.now(),
      );
      await GoalRepository(db, clock).addAll([
        const NewGoal(title: 'Get out of bed', icon: '🌅', area: 'steady_routine', section: GoalSection.startOfDay, essential: true),
        const NewGoal(title: 'Drink water', icon: '💧', area: 'eat_well', section: GoalSection.anyTime),
        const NewGoal(title: 'Wind down', icon: '🌙', area: 'rest_sleep', section: GoalSection.endOfDay),
      ]);
    });

    await tester.pumpWidget(ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        contentProvider.overrideWithValue(content),
        themeKitProvider.overrideWithValue(kit),
        clockProvider.overrideWithValue(clock),
        randomProvider.overrideWithValue(NoGiftRandom()),
        initialOnboardedProvider.overrideWithValue(true),
      ],
      child: const ZuluApp(),
    ));

    Future<void> settle() async {
      for (var i = 0; i < 3; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    Future<void> tapTooltip(String tooltip) async {
      final finder = find.byTooltip(tooltip);
      if (finder.evaluate().isEmpty) {
        await tester.scrollUntilVisible(finder, 200, scrollable: find.byType(Scrollable).first);
      }
      await tester.ensureVisible(finder);
      await tester.pump();
      await tester.tap(finder);
      await settle();
    }

    Future<void> see(String text, {double delta = 200}) async {
      if (find.text(text).evaluate().isEmpty) {
        await tester.scrollUntilVisible(find.text(text), delta, scrollable: find.byType(Scrollable).first);
      }
      expect(find.text(text), findsOneWidget);
    }

    await settle();
    await see('Energy 0 / 15');
    await see('Start the day');

    await tapTooltip('Check off Get out of bed');
    expect(find.text('+5 energy · +3 coins'), findsOneWidget);
    await see('Energy 5 / 15', delta: -200);

    await tapTooltip('Check off Drink water');
    await tapTooltip('Check off Wind down');
    await see('Ready for an adventure!', delta: -200);

    await tester.tap(find.text('Start adventure'));
    await settle();
    expect(find.textContaining('Adventuring'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 5));
    await tester.runAsync(db.close);
  });
}
