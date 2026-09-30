import 'package:drift/drift.dart';

import '../content/goal_library.dart';
import '../core/clock.dart';
import '../domain/onboarding/onboarding_outcome.dart';
import 'db/database.dart';
import 'repositories/goal_repository.dart';
import 'repositories/pet_repository.dart';
import 'repositories/profile_repository.dart';

/// Writes the result of onboarding in one transaction: the pet, the profile
/// basics (marking onboarding done) and the accepted plan's goals.
class OnboardingCompleter {
  OnboardingCompleter({
    required AppDatabase db,
    required ProfileRepository profiles,
    required PetRepository pets,
    required GoalRepository goals,
    required Clock clock,
  })  : _db = db,
        _profiles = profiles,
        _pets = pets,
        _goals = goals,
        _clock = clock;

  final AppDatabase _db;
  final ProfileRepository _profiles;
  final PetRepository _pets;
  final GoalRepository _goals;
  final Clock _clock;

  Future<void> complete(OnboardingOutcome outcome, List<GoalTemplate> plan) async {
    final now = _clock.now();
    await _db.transaction(() async {
      await _pets.save(
        name: outcome.petName,
        pronouns: outcome.pronouns,
        eggColor: outcome.eggColor,
        trait: outcome.trait,
        traitStats: outcome.traitStats,
        hatchedAt: now,
      );
      await _goals.addAll([for (final g in plan) NewGoal.fromTemplate(g)]);
      await _profiles.update(ProfilesCompanion(
        userName: Value(outcome.userName),
        wakeTime: Value(outcome.wakeTime),
        bedTime: Value(outcome.bedTime),
        onboardingDoneAt: Value(now),
      ));
    });
  }
}
