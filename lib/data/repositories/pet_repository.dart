import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/pet/trait.dart';
import '../../domain/text/template.dart';
import '../db/database.dart';

String encodeTraitStats(Map<Trait, double> stats) =>
    jsonEncode({for (final e in stats.entries) e.key.name: e.value});

/// Reads trait scores, skipping names that are no longer traits.
Map<Trait, double> decodeTraitStats(String json) {
  final raw = jsonDecode(json) as Map<String, Object?>;
  return {
    for (final e in raw.entries) ?Trait.values.asNameMap()[e.key]: (e.value! as num).toDouble(),
  };
}

class PetRepository {
  PetRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$PetsTable, Pet> get _row => _db.select(_db.pets)..where((p) => p.id.equals(1));

  Future<Pet?> get() => _row.getSingleOrNull();

  Stream<Pet?> watch() => _row.watchSingleOrNull();

  Future<void> save({
    required String name,
    required Pronouns pronouns,
    required String eggColor,
    required Trait trait,
    required Map<Trait, double> traitStats,
    required DateTime hatchedAt,
  }) async {
    // The id must be written explicitly: an INTEGER PRIMARY KEY is SQLite's
    // rowid, so leaving it out creates a new row instead of hitting the
    // conflict clause.
    await _db.into(_db.pets).insertOnConflictUpdate(PetsCompanion.insert(
          id: const Value(1),
          name: name,
          pronouns: pronouns.name,
          eggColor: eggColor,
          trait: trait.name,
          traitStats: Value(encodeTraitStats(traitStats)),
          hatchedAt: hatchedAt,
        ));
  }

  Future<void> rename(String name) async {
    await (_db.update(_db.pets)..where((p) => p.id.equals(1))).write(PetsCompanion(name: Value(name)));
  }
}
