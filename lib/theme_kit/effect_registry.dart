import '../content/json_reader.dart';

/// Every moment that can play a celebration effect (spec §4.5).
enum EffectName {
  goalDone('goal_done'),
  coinsBurst('coins_burst'),
  energyFull('energy_full'),
  hatchCrack('hatch_crack'),
  planLoading('plan_loading'),
  adventureDepart('adventure_depart'),
  adventureReturn('adventure_return'),
  milestone('milestone'),
  evolve('evolve'),
  surpriseGift('surprise_gift');

  const EffectName(this.id);

  final String id;
}

/// Maps effects to Lottie files (`assets/theme/effects/effects.json`).
/// Effects without a file use a built-in animation.
class EffectRegistry {
  const EffectRegistry(this.files);

  static const fileName = 'assets/theme/effects/effects.json';

  final Map<EffectName, String> files;

  String? fileFor(EffectName name) => files[name];

  factory EffectRegistry.fromJson(JsonReader r) {
    final byId = {for (final n in EffectName.values) n.id: n};
    final files = <EffectName, String>{};
    for (final e in r.map('effects').entries) {
      final name = byId[e.key] ?? e.value.fail('unknown effect "${e.key}"');
      files[name] = e.value.asString();
    }
    return EffectRegistry(files);
  }
}
