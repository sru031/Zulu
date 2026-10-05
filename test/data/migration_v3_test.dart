import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/data/db/database.dart';

void main() {
  test('upgrades a version 2 database by adding the daily-loop tables', () async {
    final db = AppDatabase(NativeDatabase.memory(setup: (raw) {
      raw.execute('CREATE TABLE profiles (id INTEGER NOT NULL PRIMARY KEY)');
      raw.execute('CREATE TABLE pets (id INTEGER NOT NULL PRIMARY KEY)');
      raw.execute('CREATE TABLE onboarding_answers (question_id TEXT NOT NULL PRIMARY KEY)');
      raw.execute('CREATE TABLE goals (id INTEGER NOT NULL PRIMARY KEY)');
      raw.execute('PRAGMA user_version = 2');
    }));
    addTearDown(db.close);

    await db.into(db.completions).insert(
          CompletionsCompanion.insert(goalId: 1, appDay: '2026-10-05', completedAt: DateTime(2026, 10, 5, 9)),
        );
    await db.into(db.skips).insert(SkipsCompanion.insert(goalId: 1, appDay: '2026-10-05'));
    await db.into(db.days).insert(DaysCompanion.insert(appDay: '2026-10-05'));
    await db.into(db.walletLedger).insert(
          WalletLedgerCompanion.insert(amount: 3, reason: 'goal', createdAt: DateTime(2026, 10, 5, 9)),
        );
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.single, 3);
    final day = await db.select(db.days).getSingle();
    expect(day.lowEnergy, isFalse);
    expect(day.adventureClaimed, isFalse);
    expect(day.surpriseGiven, isFalse);
  });
}
