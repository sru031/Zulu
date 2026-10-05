import 'package:drift/drift.dart';

import '../../core/app_day.dart';
import '../../core/clock.dart';
import '../db/database.dart';

/// Check-offs, skips and per-day state (low-energy mode, adventure, gift).
class DayRepository {
  DayRepository(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  /// The day's row, created with defaults on first use.
  Future<Day> day(AppDay appDay) async {
    await _db.into(_db.days).insert(DaysCompanion.insert(appDay: appDay.key), mode: InsertMode.insertOrIgnore);
    return (_db.select(_db.days)..where((d) => d.appDay.equals(appDay.key))).getSingle();
  }

  Future<void> _updateDay(AppDay appDay, DaysCompanion changes) async {
    await day(appDay);
    await (_db.update(_db.days)..where((d) => d.appDay.equals(appDay.key))).write(changes);
  }

  /// Records a check-off and returns how many times [goalId] is now done
  /// on [appDay] (1 for the first).
  Future<int> addCompletion(int goalId, AppDay appDay) async {
    await _db.into(_db.completions).insert(CompletionsCompanion.insert(
          goalId: goalId,
          appDay: appDay.key,
          completedAt: _clock.now(),
        ));
    return (await completionCounts(appDay))[goalId]!;
  }

  /// Removes the latest check-off of [goalId] on [appDay]; false if none.
  Future<bool> removeLatestCompletion(int goalId, AppDay appDay) async {
    final latest = await (_db.select(_db.completions)
          ..where((c) => c.goalId.equals(goalId) & c.appDay.equals(appDay.key))
          ..orderBy([(c) => OrderingTerm.desc(c.id)])
          ..limit(1))
        .getSingleOrNull();
    if (latest == null) return false;
    await (_db.delete(_db.completions)..where((c) => c.id.equals(latest.id))).go();
    return true;
  }

  Future<Map<int, int>> completionCounts(AppDay appDay) async {
    final rows = await (_db.select(_db.completions)..where((c) => c.appDay.equals(appDay.key))).get();
    final counts = <int, int>{};
    for (final r in rows) {
      counts[r.goalId] = (counts[r.goalId] ?? 0) + 1;
    }
    return counts;
  }

  Future<void> skip(int goalId, AppDay appDay) async {
    await _db.into(_db.skips).insert(
          SkipsCompanion.insert(goalId: goalId, appDay: appDay.key),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<void> unskip(int goalId, AppDay appDay) async {
    await (_db.delete(_db.skips)..where((s) => s.goalId.equals(goalId) & s.appDay.equals(appDay.key))).go();
  }

  Future<Set<int>> skipped(AppDay appDay) async {
    final rows = await (_db.select(_db.skips)..where((s) => s.appDay.equals(appDay.key))).get();
    return {for (final r in rows) r.goalId};
  }

  Future<void> setLowEnergy(AppDay appDay, bool on) => _updateDay(appDay, DaysCompanion(lowEnergy: Value(on)));

  Future<void> startAdventure(AppDay appDay, {required DateTime start, required DateTime endsAt, required String storyId}) =>
      _updateDay(appDay, DaysCompanion(
        adventureStartedAt: Value(start),
        adventureEndsAt: Value(endsAt),
        storyId: Value(storyId),
      ));

  Future<void> claimAdventure(AppDay appDay) => _updateDay(appDay, const DaysCompanion(adventureClaimed: Value(true)));

  Future<void> markSurprise(AppDay appDay) => _updateDay(appDay, const DaysCompanion(surpriseGiven: Value(true)));

  Future<int> adventuresClaimed() async {
    final count = _db.days.appDay.count();
    final query = _db.selectOnly(_db.days)
      ..addColumns([count])
      ..where(_db.days.adventureClaimed.equals(true));
    return (await query.map((r) => r.read(count)).getSingle()) ?? 0;
  }

  /// Earlier days that have at least one check-off, oldest first.
  Future<List<AppDay>> activeDaysBefore(AppDay appDay) async {
    final query = _db.selectOnly(_db.completions, distinct: true)
      ..addColumns([_db.completions.appDay])
      ..where(_db.completions.appDay.isSmallerThanValue(appDay.key))
      ..orderBy([OrderingTerm.asc(_db.completions.appDay)]);
    return [for (final key in await query.map((r) => r.read(_db.completions.appDay)!).get()) AppDay.parse(key)];
  }

  /// Distinct days with any check-off. It only ever goes up.
  Future<int> daysShowedUp() async {
    final count = _db.completions.appDay.count(distinct: true);
    return (await (_db.selectOnly(_db.completions)..addColumns([count])).map((r) => r.read(count)).getSingle()) ?? 0;
  }
}
