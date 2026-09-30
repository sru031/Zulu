import 'dart:math';

import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../db/database.dart';

class ProfileRepository {
  ProfileRepository(this._db, this._clock, {Random? random}) : _random = random ?? Random.secure();

  final AppDatabase _db;
  final Clock _clock;
  final Random _random;

  SimpleSelectStatement<$ProfilesTable, Profile> get _row =>
      _db.select(_db.profiles)..where((p) => p.id.equals(1));

  /// Returns the profile, creating it with defaults on first launch.
  Future<Profile> ensure() async {
    final existing = await _row.getSingleOrNull();
    if (existing != null) return existing;
    await _db.into(_db.profiles).insert(
          ProfilesCompanion.insert(installId: _newInstallId(), createdAt: _clock.now()),
          mode: InsertMode.insertOrIgnore,
        );
    return _row.getSingle();
  }

  Future<Profile> get() => _row.getSingle();

  Stream<Profile> watch() => _row.watchSingle();

  Future<void> update(ProfilesCompanion changes) async {
    await (_db.update(_db.profiles)..where((p) => p.id.equals(1))).write(changes);
  }

  String _newInstallId() => List.generate(16, (_) => _random.nextInt(16).toRadixString(16)).join();
}
