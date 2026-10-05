import 'dart:math';

import '../pet/pet_stage.dart';
import 'game_rules.dart';

/// Energy for the day (spec §7): completions fill it, the target says when
/// the pet is ready for an adventure.
class EnergyRules {
  const EnergyRules(this.rules);

  final GameRules rules;

  int energy({required int completions, required int target}) =>
      min(completions * rules.energyPerCompletion, target);

  /// On a low-energy day only essential goals show, so the target shrinks to
  /// what those few goals can fill. With no essentials the list stays full.
  int target({required bool lowEnergy, required int essentialToday}) {
    if (!lowEnergy || essentialToday == 0) return rules.energyTarget;
    final shown = min(rules.lowEnergyMaxEssentialGoals, essentialToday);
    return max(rules.energyPerCompletion, rules.energyPerCompletion * shown);
  }
}

/// Coins for check-offs and the rare surprise gift.
class RewardRules {
  const RewardRules(this.rules);

  final GameRules rules;

  /// Coins for the [nthCompletionToday] check-off of one goal (1-based).
  int coinsFor({required int nthCompletionToday}) =>
      nthCompletionToday <= rules.maxPaidCompletionsPerGoalPerDay ? rules.coinsPerCompletion : 0;

  /// Coins for a surprise gift, or null when there is none this time.
  int? surpriseGift(Random random, {required bool alreadyGiven}) {
    final gift = rules.surpriseGift;
    if (alreadyGiven || random.nextDouble() >= gift.chance) return null;
    return gift.minCoins + random.nextInt(gift.maxCoins - gift.minCoins + 1);
  }
}

enum AdventureState {
  /// Energy is still filling.
  charging,

  /// Energy is full; the pet can set off.
  ready,

  /// The pet is out exploring.
  away,

  /// The pet is back with a story to tell.
  returned,

  /// The story was heard and the reward collected.
  done,
}

class AdventureTimeline {
  const AdventureTimeline(this.rules);

  final GameRules rules;

  DateTime endsAt(DateTime start) => start.add(rules.adventure.duration);

  AdventureState state({
    required int energy,
    required int target,
    required DateTime? startedAt,
    required DateTime? endsAt,
    required bool claimed,
    required DateTime now,
  }) {
    if (claimed) return AdventureState.done;
    if (endsAt != null && !now.isBefore(endsAt)) return AdventureState.returned;
    if (startedAt != null) return AdventureState.away;
    return energy >= target ? AdventureState.ready : AdventureState.charging;
  }
}

/// The pet's stage comes from total adventures ever, so it only grows.
class GrowthRules {
  const GrowthRules(this.rules);

  final GameRules rules;

  PetStage stage(int totalAdventures) {
    var stage = PetStage.baby;
    for (final s in PetStage.values) {
      if (totalAdventures >= rules.growthThresholds[s]!) stage = s;
    }
    return stage;
  }
}
