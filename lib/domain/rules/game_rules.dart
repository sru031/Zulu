import '../../content/json_reader.dart';
import '../pet/pet_stage.dart';

class SurpriseGiftRules {
  const SurpriseGiftRules({
    required this.chance,
    required this.minCoins,
    required this.maxCoins,
    required this.maxPerDay,
  });

  final double chance;
  final int minCoins;
  final int maxCoins;
  final int maxPerDay;
}

class AdventureRules {
  const AdventureRules({required this.duration, required this.rewardCoins, required this.maxPerDay});

  final Duration duration;
  final int rewardCoins;
  final int maxPerDay;
}

class TraitGainRules {
  const TraitGainRules({
    required this.startingBonus,
    required this.reflection,
    required this.calm,
    required this.goalArea,
  });

  final double startingBonus;
  final double reflection;
  final double calm;
  final double goalArea;
}

class ReflectionPromptRules {
  const ReflectionPromptRules({required this.chance, required this.maxPerDay});

  final double chance;
  final int maxPerDay;
}

/// Every tunable number in the daily loop (spec §7). Loaded from
/// [fileName] so balance can change without code changes.
class GameRules {
  const GameRules({
    required this.dayStartHour,
    required this.energyPerCompletion,
    required this.energyTarget,
    required this.lowEnergyMaxEssentialGoals,
    required this.coinsPerCompletion,
    required this.maxPaidCompletionsPerGoalPerDay,
    required this.surpriseGift,
    required this.adventure,
    required this.growthThresholds,
    required this.milestoneDays,
    required this.milestoneCoins,
    required this.shopRotatingSlots,
    required this.traits,
    required this.reflectionPrompt,
    required this.maxAppNotificationsPerDay,
  });

  static const fileName = 'assets/content/game_rules.json';

  final int dayStartHour;
  final int energyPerCompletion;
  final int energyTarget;
  final int lowEnergyMaxEssentialGoals;
  final int coinsPerCompletion;
  final int maxPaidCompletionsPerGoalPerDay;
  final SurpriseGiftRules surpriseGift;
  final AdventureRules adventure;

  /// Total adventures needed to reach each stage.
  final Map<PetStage, int> growthThresholds;
  final List<int> milestoneDays;
  final int milestoneCoins;
  final int shopRotatingSlots;
  final TraitGainRules traits;
  final ReflectionPromptRules reflectionPrompt;
  final int maxAppNotificationsPerDay;

  factory GameRules.fromJson(JsonReader r) {
    int positive(JsonReader parent, String key) {
      final v = parent.integer(key);
      if (v <= 0) parent.field(key).fail('must be greater than 0');
      return v;
    }

    double fraction(JsonReader parent, String key) {
      final v = parent.number(key);
      if (v < 0 || v > 1) parent.field(key).fail('must be between 0 and 1');
      return v;
    }

    final dayStartHour = r.integer('dayStartHour');
    if (dayStartHour < 0 || dayStartHour > 23) r.field('dayStartHour').fail('must be 0–23');

    final gift = r.field('surpriseGift');
    final minCoins = positive(gift, 'minCoins');
    final maxCoins = positive(gift, 'maxCoins');
    if (maxCoins < minCoins) gift.field('maxCoins').fail('must be at least minCoins');

    final growth = <PetStage, int>{};
    for (final s in r.list('growthStages')) {
      final stage = PetStage.values.asNameMap()[s.string('stage')] ??
          s.field('stage').fail('expected baby, toddler, teen or adult');
      if (growth.containsKey(stage)) s.field('stage').fail('listed twice');
      growth[stage] = s.integer('adventures');
    }
    final ordered = [
      for (final stage in PetStage.values)
        growth[stage] ?? r.field('growthStages').fail('missing stage "${stage.name}"'),
    ];
    if (ordered.first != 0) r.field('growthStages').fail('baby must need 0 adventures');
    for (var i = 1; i < ordered.length; i++) {
      if (ordered[i] <= ordered[i - 1]) {
        r.field('growthStages').fail('each stage must need more adventures than the one before');
      }
    }

    final milestones = [for (final m in r.list('milestoneDays')) m.asInt()];
    for (var i = 0; i < milestones.length; i++) {
      if (milestones[i] <= (i == 0 ? 0 : milestones[i - 1])) {
        r.field('milestoneDays').fail('must be positive and increasing');
      }
    }

    final adventure = r.field('adventure');
    final traits = r.field('traits');
    final reflection = r.field('reflectionPrompt');

    return GameRules(
      dayStartHour: dayStartHour,
      energyPerCompletion: positive(r, 'energyPerCompletion'),
      energyTarget: positive(r, 'energyTarget'),
      lowEnergyMaxEssentialGoals: positive(r, 'lowEnergyMaxEssentialGoals'),
      coinsPerCompletion: positive(r, 'coinsPerCompletion'),
      maxPaidCompletionsPerGoalPerDay: positive(r, 'maxPaidCompletionsPerGoalPerDay'),
      surpriseGift: SurpriseGiftRules(
        chance: fraction(gift, 'chance'),
        minCoins: minCoins,
        maxCoins: maxCoins,
        maxPerDay: positive(gift, 'maxPerDay'),
      ),
      adventure: AdventureRules(
        duration: Duration(minutes: positive(adventure, 'durationMinutes')),
        rewardCoins: positive(adventure, 'rewardCoins'),
        maxPerDay: positive(adventure, 'maxPerDay'),
      ),
      growthThresholds: growth,
      milestoneDays: milestones,
      milestoneCoins: positive(r, 'milestoneCoins'),
      shopRotatingSlots: positive(r.field('shop'), 'rotatingSlots'),
      traits: TraitGainRules(
        startingBonus: traits.number('startingBonus'),
        reflection: traits.number('reflection'),
        calm: traits.number('calm'),
        goalArea: traits.number('goalArea'),
      ),
      reflectionPrompt: ReflectionPromptRules(
        chance: fraction(reflection, 'chance'),
        maxPerDay: positive(reflection, 'maxPerDay'),
      ),
      maxAppNotificationsPerDay: positive(r.field('notifications'), 'maxAppInitiatedPerDay'),
    );
  }
}
