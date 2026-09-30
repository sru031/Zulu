import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/app/app.dart';
import 'package:zulu/app/providers.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/profile_repository.dart';
import 'package:zulu/features/onboarding/ui/plan_view.dart';
import 'package:zulu/features/onboarding/ui/step_views.dart';
import 'package:zulu/shared/services/reminder_permission.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../../helpers/read_file.dart';

class DeniedPermission implements ReminderPermission {
  @override
  Future<bool> request() async => false;
}

void main() {
  late ContentBundle content;
  late ThemeKit kit;

  setUpAll(() async {
    content = await loadContent(readFile);
    kit = await loadThemeKit(readFile);
  });

  testWidgets('a new user goes from hatching to their plan to Home', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() => ProfileRepository(db, FakeClock(DateTime(2026, 9, 30))).ensure());

    await tester.pumpWidget(ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        contentProvider.overrideWithValue(content),
        themeKitProvider.overrideWithValue(kit),
        clockProvider.overrideWithValue(FakeClock(DateTime(2026, 9, 30, 10))),
        initialOnboardedProvider.overrideWithValue(false),
        reminderPermissionProvider.overrideWithValue(DeniedPermission()),
      ],
      child: const ZuluApp(),
    ));

    Future<void> settle() => tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50))).then((_) => tester.pump());
    Future<void> tapText(String text) async {
      if (find.text(text).evaluate().isEmpty) {
        await tester.scrollUntilVisible(find.text(text), 200, scrollable: find.byType(Scrollable).first);
      }
      await tester.ensureVisible(find.text(text).first);
      await tester.pump();
      await tester.tap(find.text(text).first);
      await settle();
    }

    Future<void> choose(String label) async {
      await tapText(label);
      await tester.pump(autoAdvanceDelay);
      await settle();
    }

    await settle();
    await tapText('Hatch a new pet');
    await tester.tap(find.bySemanticsLabel('mint egg'));
    await tester.pump();
    await tapText('Hatch this egg');
    await tester.pump(hatchDelay);
    await settle();
    await tapText('Say hello');
    await tester.enterText(find.byType(TextField), 'Mochi');
    await tester.pump();
    await tapText('Next');
    await choose('She / her');
    await choose('Calm');
    await tester.enterText(find.byType(TextField), 'Sam');
    await tester.pump();
    await tapText('Next');
    expect(find.textContaining('Nice to meet you, Sam!'), findsOneWidget);
    await choose('Doing what I can, even on hard days');
    await tapText("Let's do it");
    await tapText('Maybe later');
    await tapText('Okay');
    expect(find.text('About you'), findsOneWidget);
    await tapText('Continue');
    await tapText('Continue');
    await choose('Never');
    await choose('Under 5 hours');
    await choose('Pretty easy');
    await choose('Some');
    await choose('Rarely');
    await choose('A few people');
    await choose('Pretty good');
    await tapText('Stress or worry');
    await tapText('Next');
    await tapText('Move more');
    await tapText('Next');
    await tapText('No time');
    await tapText('Next');

    expect(find.textContaining('making your plan'), findsOneWidget);
    await tester.pump(planLoadingDelay);
    await settle();
    expect(find.text("Sam's starter plan"), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Wind down for 10 minutes before bed'), 200, scrollable: find.byType(Scrollable).first);
    expect(find.text('Wind down for 10 minutes before bed'), findsOneWidget);
    expect(find.text("Because you told me sleep's been short"), findsOneWidget);

    await tapText("Let's do it");
    await settle();
    await settle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.textContaining('Mochi'), findsWidgets);

    final goals = await tester.runAsync(() => db.select(db.goals).get());
    expect(goals!.map((g) => g.libraryId), [
      'get_out_of_bed',
      'drink_water',
      'three_breaths',
      'wind_down_10',
      'stretch_2min',
      'short_walk',
      'one_song_move',
    ]);

    // Unmount first, then let drift's stream-cleanup timers fire before closing.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
  });
}
