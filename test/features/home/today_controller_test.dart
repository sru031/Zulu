import 'dart:math';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/app/providers.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/content/goal_library.dart';
import 'package:zulu/core/app_day.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/day_repository.dart';
import 'package:zulu/data/repositories/goal_repository.dart';
import 'package:zulu/data/repositories/profile_repository.dart';
import 'package:zulu/domain/pet/pet_stage.dart';
import 'package:zulu/domain/rules/daily_rules.dart';
import 'package:zulu/features/home/today_controller.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../../helpers/read_file.dart';

class FixedRandom implements Random {
  FixedRandom(this.value, [this.whole = 0]);
  final double value;
  final int whole;
  @override
  double nextDouble() => value;
  @override
  int nextInt(int max) => whole;
  @override
  bool nextBool() => false;
}

void main() {
  late ContentBundle content;
  late ThemeKit kit;
  late AppDatabase db;
  late FakeClock clock;
  late ProviderContainer container;
  late List<Goal> goals;
  final today = AppDay(2026, 10, 5);

  setUpAll(() async {
    content = await loadContent(readFile);
    kit = await loadThemeKit(readFile);
  });

  ProviderContainer makeContainer(Random random) => ProviderContainer.test(overrides: [
        databaseProvider.overrideWithValue(db),
        contentProvider.overrideWithValue(content),
        themeKitProvider.overrideWithValue(kit),
        clockProvider.overrideWithValue(clock),
        randomProvider.overrideWithValue(random),
      ]);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    clock = FakeClock(DateTime(2026, 10, 5, 9));
    await ProfileRepository(db, clock).ensure();
    await GoalRepository(db, clock).addAll([
      const NewGoal(title: 'Get out of bed', icon: '🌅', area: 'steady_routine', section: GoalSection.startOfDay, essential: true),
      const NewGoal(title: 'Drink water', icon: '💧', area: 'eat_well', section: GoalSection.anyTime),
      const NewGoal(title: 'Wind down', icon: '🌙', area: 'rest_sleep', section: GoalSection.endOfDay),
    ]);
    goals = await GoalRepository(db, clock).active();
    container = makeContainer(FixedRandom(0.99));
  });

  tearDown(() => db.close());

  TodayController controller() => container.read(todayControllerProvider.notifier);
  Future<TodayState> state() => container.read(todayControllerProvider.future);
  Future<TodayState> reload() {
    container.invalidate(todayControllerProvider);
    return state();
  }

  test('starts the day charging, with every scheduled goal', () async {
    final s = await state();
    expect(s.day, today);
    expect(s.goals.map((g) => g.goal.title), ['Get out of bed', 'Drink water', 'Wind down']);
    expect(s.energy, 0);
    expect(s.target, 15);
    expect(s.adventure, AdventureState.charging);
    expect(s.coins, 0);
    expect(s.stage, PetStage.baby);
  });

  test('a check-off gives energy and coins', () async {
    final reward = await controller().complete(goals[0].id);
    expect(reward.energyGained, 5);
    expect(reward.coins, 3);
    expect(reward.surprise, isNull);
    final s = await state();
    expect(s.energy, 5);
    expect(s.coins, 3);
    expect(s.goals.first.doneCount, 1);
  });

  test('three check-offs fill the energy and the pet is ready', () async {
    for (final g in goals) {
      await controller().complete(g.id);
    }
    final s = await state();
    expect(s.energy, 15);
    expect(s.adventure, AdventureState.ready);
  });

  test('the fourth check-off of the same goal pays no coins', () async {
    final coins = [for (var i = 0; i < 4; i++) (await controller().complete(goals[1].id)).coins];
    expect(coins, [3, 3, 3, 0]);
    expect((await state()).coins, 9);
  });

  test('undo refunds the coins and the energy', () async {
    await controller().complete(goals[0].id);
    await controller().undo(goals[0].id);
    final s = await state();
    expect(s.energy, 0);
    expect(s.coins, 0);
    expect(s.goals.first.doneCount, 0);
  });

  test('skipping hides a goal for today without any penalty', () async {
    await controller().skip(goals[2].id);
    var s = await state();
    expect(s.goals.map((g) => g.goal.title), ['Get out of bed', 'Drink water']);
    expect(s.skipped.map((g) => g.goal.title), ['Wind down']);
    expect(s.target, 15);
    await controller().unskip(goals[2].id);
    s = await state();
    expect(s.skipped, isEmpty);
  });

  test('a low-energy day shows only essentials and needs less energy', () async {
    await controller().setLowEnergy(true);
    var s = await state();
    expect(s.lowEnergy, isTrue);
    expect(s.goals.map((g) => g.goal.title), ['Get out of bed']);
    expect(s.target, 5);
    await controller().complete(goals[0].id);
    s = await state();
    expect(s.adventure, AdventureState.ready);
  });

  test('a surprise gift comes at most once a day', () async {
    container.dispose();
    container = makeContainer(FixedRandom(0.0, 0));
    final first = await controller().complete(goals[0].id);
    final second = await controller().complete(goals[1].id);
    expect(first.surprise, 5);
    expect(second.surprise, isNull);
    expect((await state()).coins, 3 + 5 + 3);
  });

  test('an adventure leaves, returns after six hours with a story, and pays 20 coins', () async {
    for (final g in goals) {
      await controller().complete(g.id);
    }
    await controller().startAdventure();
    var s = await state();
    expect(s.adventure, AdventureState.away);
    expect(s.adventureEndsAt!.isAtSameMomentAs(DateTime(2026, 10, 5, 15)), isTrue);

    clock.advance(const Duration(hours: 6));
    s = await reload();
    expect(s.adventure, AdventureState.returned);
    expect(s.story, isNotNull);

    await controller().claimAdventure();
    s = await state();
    expect(s.adventure, AdventureState.done);
    expect(s.coins, 9 + 20);
    expect(s.totalAdventures, 1);
  });

  test('a past day that filled its energy still pays its adventure', () async {
    final days = DayRepository(db, clock);
    final yesterday = AppDay(2026, 10, 4);
    for (final g in goals) {
      await days.addCompletion(g.id, yesterday);
    }
    // Yesterday ended at 04:00, so its adventure set off then and is out until 10:00.
    var s = await state();
    expect(s.totalAdventures, 0);
    final away = await days.day(yesterday);
    expect(away.adventureStartedAt!.isAtSameMomentAs(DateTime(2026, 10, 5, 4)), isTrue);
    expect(away.adventureClaimed, isFalse);

    clock.set(DateTime(2026, 10, 5, 11));
    s = await reload();
    expect(s.totalAdventures, 1);
    expect(s.coins, 20);
    expect((await days.day(yesterday)).adventureClaimed, isTrue);
  });

  test('a past day that did not fill its energy pays nothing', () async {
    await DayRepository(db, clock).addCompletion(goals[0].id, AppDay(2026, 10, 4));
    final s = await state();
    expect(s.totalAdventures, 0);
    expect(s.coins, 0);
  });

  test('goals only show on their scheduled weekdays', () async {
    // 2026-10-05 is a Monday: bit 0. Schedule "Wind down" for Tuesday only.
    await (db.update(db.goals)..where((g) => g.id.equals(goals[2].id))).write(const GoalsCompanion(weekdaysMask: Value(2)));
    final s = await reload();
    expect(s.goals.map((g) => g.goal.title), ['Get out of bed', 'Drink water']);
  });

  test('five claimed adventures grow the pet into a toddler', () async {
    for (var d = 1; d <= 5; d++) {
      await db.into(db.days).insert(DaysCompanion.insert(appDay: AppDay(2026, 9, d).key, adventureClaimed: const Value(true)));
    }
    expect((await reload()).stage, PetStage.toddler);
  });

  test('adds goals from the library at the end of the list', () async {
    await controller().addGoals([content.goals.byId('shower')!]);
    expect((await state()).goals.last.goal.title, 'Take a shower');
  });
}
