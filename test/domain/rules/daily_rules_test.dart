import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/domain/pet/pet_stage.dart';
import 'package:zulu/domain/rules/daily_rules.dart';
import 'package:zulu/domain/rules/game_rules.dart';

/// Always returns [value] from nextDouble and [whole] from nextInt.
class FixedRandom implements Random {
  FixedRandom(this.value, [this.whole = 0]);
  final double value;
  final int whole;
  @override
  double nextDouble() => value;
  @override
  int nextInt(int max) => whole;
  @override
  bool nextBool() => false;
}

void main() {
  final rules = GameRules.fromJson(
    JsonReader.decode('game_rules.json', File(GameRules.fileName).readAsStringSync()),
  );

  group('energy', () {
    final energy = EnergyRules(rules);

    test('each completion gives 5, capped at the target', () {
      expect(energy.energy(completions: 0, target: 15), 0);
      expect(energy.energy(completions: 2, target: 15), 10);
      expect(energy.energy(completions: 3, target: 15), 15);
      expect(energy.energy(completions: 9, target: 15), 15);
    });

    test('the target is 15 on a normal day', () {
      expect(energy.target(lowEnergy: false, essentialToday: 4), 15);
    });

    test('a low-energy day needs only its essentials, at most 3, at least 5 energy', () {
      expect(energy.target(lowEnergy: true, essentialToday: 1), 5);
      expect(energy.target(lowEnergy: true, essentialToday: 2), 10);
      expect(energy.target(lowEnergy: true, essentialToday: 7), 15);
    });

    test('a low-energy day with no essentials keeps the normal target', () {
      expect(energy.target(lowEnergy: true, essentialToday: 0), 15);
    });
  });

  group('rewards', () {
    final rewards = RewardRules(rules);

    test('the first three completions of a goal each pay 3 coins, then none', () {
      expect([for (var n = 1; n <= 5; n++) rewards.coinsFor(nthCompletionToday: n)], [3, 3, 3, 0, 0]);
    });

    test('a surprise gift comes with 8% chance, 5–15 coins, once a day', () {
      expect(rewards.surpriseGift(FixedRandom(0.079, 0), alreadyGiven: false), 5);
      expect(rewards.surpriseGift(FixedRandom(0.0, 10), alreadyGiven: false), 15);
      expect(rewards.surpriseGift(FixedRandom(0.08), alreadyGiven: false), isNull);
      expect(rewards.surpriseGift(FixedRandom(0.0), alreadyGiven: true), isNull);
    });
  });

  group('adventure', () {
    final adventure = AdventureTimeline(rules);
    final start = DateTime(2026, 10, 5, 10);

    AdventureState state({int energy = 0, DateTime? startedAt, DateTime? endsAt, bool claimed = false, DateTime? now}) =>
        adventure.state(energy: energy, target: 15, startedAt: startedAt, endsAt: endsAt, claimed: claimed, now: now ?? start);

    test('lasts six hours', () {
      expect(adventure.endsAt(start), DateTime(2026, 10, 5, 16));
    });

    test('moves from charging to ready to away to returned to done', () {
      expect(state(energy: 10), AdventureState.charging);
      expect(state(energy: 15), AdventureState.ready);
      expect(state(energy: 15, startedAt: start, endsAt: adventure.endsAt(start), now: DateTime(2026, 10, 5, 15, 59)), AdventureState.away);
      expect(state(energy: 15, startedAt: start, endsAt: adventure.endsAt(start), now: DateTime(2026, 10, 5, 16)), AdventureState.returned);
      expect(state(energy: 15, startedAt: start, endsAt: adventure.endsAt(start), claimed: true), AdventureState.done);
    });
  });

  group('growth', () {
    final growth = GrowthRules(rules);

    test('stages follow total adventures and never depend on recent days', () {
      expect(growth.stage(0), PetStage.baby);
      expect(growth.stage(4), PetStage.baby);
      expect(growth.stage(5), PetStage.toddler);
      expect(growth.stage(19), PetStage.toddler);
      expect(growth.stage(20), PetStage.teen);
      expect(growth.stage(60), PetStage.adult);
      expect(growth.stage(500), PetStage.adult);
    });
  });
}
