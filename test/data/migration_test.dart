import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/data/db/database.dart';

void main() {
  test('upgrades a version 1 database by adding the new tables', () async {
    final db = AppDatabase(NativeDatabase.memory(setup: (raw) {
      raw.execute('CREATE TABLE profiles (id INTEGER NOT NULL PRIMARY KEY)');
      raw.execute('CREATE TABLE pets (id INTEGER NOT NULL PRIMARY KEY)');
      raw.execute('PRAGMA user_version = 1');
    }));
    addTearDown(db.close);

    await db.into(db.onboardingAnswers).insert(OnboardingAnswersCompanion.insert(
          questionId: 'q',
          value: '"a"',
          answeredAt: DateTime(2026, 9, 30),
        ));
    expect(await db.select(db.onboardingAnswers).get(), hasLength(1));
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.single, 2);
  });

  test('a fresh database has every table', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    expect(await db.select(db.goals).get(), isEmpty);
    expect(await db.select(db.onboardingAnswers).get(), isEmpty);
    expect(await db.select(db.profiles).get(), isEmpty);
  });
}
