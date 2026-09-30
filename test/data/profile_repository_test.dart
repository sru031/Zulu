import 'dart:math';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/profile_repository.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = FakeClock(DateTime(2026, 9, 29, 9));
  });

  tearDown(() => db.close());

  test('ensure creates one profile with the spec defaults', () async {
    final profile = await ProfileRepository(db, clock, random: Random(1)).ensure();
    expect(profile.installId, hasLength(16));
    expect(profile.userName, '');
    expect(profile.wakeTime, '07:30');
    expect(profile.bedTime, '23:00');
    expect(profile.dayStartHour, 4);
    expect(profile.moodCheckInMode, 'daily');
    expect(profile.paused, isFalse);
    expect(profile.notifyMorning, isTrue);
    expect(profile.notifyAdventure, isTrue);
    expect(profile.notifyEvening, isFalse);
    expect(profile.onboardingDoneAt, isNull);
    expect(profile.createdAt.isAtSameMomentAs(clock.now()), isTrue);
  });

  test('ensure is idempotent', () async {
    final repo = ProfileRepository(db, clock);
    final first = await repo.ensure();
    final second = await repo.ensure();
    expect(second.installId, first.installId);
    expect(await db.select(db.profiles).get(), hasLength(1));
  });

  test('update changes only the given fields, and watch sees it', () async {
    final repo = ProfileRepository(db, clock);
    await repo.ensure();
    final names = expectLater(repo.watch().map((p) => p.userName), emitsInOrder(['', 'Sam']));
    await repo.update(const ProfilesCompanion(userName: Value('Sam')));
    await names;
    expect((await repo.get()).wakeTime, '07:30');
  });
}
