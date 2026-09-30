import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/goal_library.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/goal_repository.dart';

void main() {
  late AppDatabase db;
  late GoalRepository goals;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    goals = GoalRepository(db, FakeClock(DateTime(2026, 9, 30, 9)));
  });

  tearDown(() => db.close());

  const water = NewGoal(title: 'Drink water', icon: '💧', area: 'eat_well', section: GoalSection.anyTime, essential: true, libraryId: 'drink_water');
  const bed = NewGoal(title: 'Get out of bed', icon: '🌅', area: 'steady_routine', section: GoalSection.startOfDay);

  test('adds goals in order and keeps counting on later adds', () async {
    await goals.addAll([water, bed]);
    await goals.addAll([water]);
    final active = await goals.active();
    expect(active.map((g) => g.title), ['Drink water', 'Get out of bed', 'Drink water']);
    expect(active.map((g) => g.sortOrder), [0, 1, 2]);
    expect(active.first.section, 'any_time');
    expect(active.first.essential, isTrue);
    expect(active.first.libraryId, 'drink_water');
    expect(active.first.weekdaysMask, 127);
    expect(active.first.timesPerDay, 1);
    expect(active[1].libraryId, isNull);
  });

  test('archived goals are not active', () async {
    await goals.addAll([water, bed]);
    await (db.update(db.goals)..where((g) => g.title.equals('Drink water')))
        .write(GoalsCompanion(archivedAt: Value(DateTime(2026, 10, 1))));
    expect((await goals.active()).map((g) => g.title), ['Get out of bed']);
  });

  test('NewGoal.fromTemplate copies the library fields', () {
    const template = GoalTemplate(
      id: 'shower',
      title: 'Take a shower',
      icon: '🚿',
      area: 'feel_fresh',
      section: GoalSection.anyTime,
      essential: false,
      starter: true,
      tags: [],
    );
    final goal = NewGoal.fromTemplate(template);
    expect(goal.title, 'Take a shower');
    expect(goal.icon, '🚿');
    expect(goal.area, 'feel_fresh');
    expect(goal.section, GoalSection.anyTime);
    expect(goal.libraryId, 'shower');
  });
}
