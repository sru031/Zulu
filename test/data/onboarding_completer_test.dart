import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/onboarding_completer.dart';
import 'package:zulu/data/repositories/goal_repository.dart';
import 'package:zulu/data/repositories/pet_repository.dart';
import 'package:zulu/data/repositories/profile_repository.dart';
import 'package:zulu/domain/onboarding/onboarding_outcome.dart';
import 'package:zulu/domain/pet/trait.dart';
import 'package:zulu/domain/text/template.dart';

import '../helpers/read_file.dart';

void main() {
  test('saves the pet, the profile and the planned goals', () async {
    final content = await loadContent(readFile);
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final clock = FakeClock(DateTime(2026, 9, 30, 10));
    final profiles = ProfileRepository(db, clock);
    await profiles.ensure();

    await OnboardingCompleter(
      db: db,
      profiles: profiles,
      pets: PetRepository(db),
      goals: GoalRepository(db, clock),
      clock: clock,
    ).complete(
      const OnboardingOutcome(
        petName: 'Mochi',
        pronouns: Pronouns.she,
        eggColor: 'mint',
        trait: Trait.calm,
        traitStats: {Trait.calm: 6},
        userName: 'Sam',
        wakeTime: '06:45',
        bedTime: '22:30',
      ),
      [content.goals.byId('get_out_of_bed')!, content.goals.byId('shower')!],
    );

    final pet = (await PetRepository(db).get())!;
    expect(pet.name, 'Mochi');
    expect(pet.eggColor, 'mint');
    expect(pet.hatchedAt.isAtSameMomentAs(clock.now()), isTrue);
    final profile = await profiles.get();
    expect(profile.userName, 'Sam');
    expect(profile.wakeTime, '06:45');
    expect(profile.bedTime, '22:30');
    expect(profile.onboardingDoneAt!.isAtSameMomentAs(clock.now()), isTrue);
    final goals = await GoalRepository(db, clock).active();
    expect(goals.map((g) => g.libraryId), ['get_out_of_bed', 'shower']);
    expect(goals.first.essential, isTrue);
  });
}
