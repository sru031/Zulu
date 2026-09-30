import 'package:drift/drift.dart';

import '../../content/goal_library.dart';
import '../../core/clock.dart';
import '../db/database.dart';

/// A goal about to be created, from the library or typed by the user.
class NewGoal {
  const NewGoal({
    required this.title,
    required this.icon,
    required this.area,
    required this.section,
    this.essential = false,
    this.libraryId,
  });

  factory NewGoal.fromTemplate(GoalTemplate t) => NewGoal(
        title: t.title,
        icon: t.icon,
        area: t.area,
        section: t.section,
        essential: t.essential,
        libraryId: t.id,
      );

  final String title;
  final String icon;
  final String area;
  final GoalSection section;
  final bool essential;
  final String? libraryId;
}

class GoalRepository {
  GoalRepository(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  /// Adds [goals] after the existing ones, in the given order.
  Future<void> addAll(List<NewGoal> goals) async {
    await _db.transaction(() async {
      final maxOrder = _db.goals.sortOrder.max();
      final current = await (_db.selectOnly(_db.goals)..addColumns([maxOrder]))
          .map((row) => row.read(maxOrder))
          .getSingle();
      var order = (current ?? -1) + 1;
      final now = _clock.now();
      for (final g in goals) {
        await _db.into(_db.goals).insert(GoalsCompanion.insert(
              title: g.title,
              icon: g.icon,
              area: g.area,
              section: g.section.id,
              essential: Value(g.essential),
              sortOrder: order++,
              libraryId: Value(g.libraryId),
              createdAt: now,
            ));
      }
    });
  }

  SimpleSelectStatement<$GoalsTable, Goal> get _active => _db.select(_db.goals)
    ..where((g) => g.archivedAt.isNull())
    ..orderBy([(g) => OrderingTerm.asc(g.sortOrder)]);

  Future<List<Goal>> active() => _active.get();

  Stream<List<Goal>> watchActive() => _active.watch();
}
