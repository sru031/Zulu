import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/domain/pet/pet_stage.dart';
import 'package:zulu/domain/rules/game_rules.dart';

Map<String, Object?> shipped() =>
    jsonDecode(File(GameRules.fileName).readAsStringSync()) as Map<String, Object?>;

GameRules parse(Map<String, Object?> json) => GameRules.fromJson(JsonReader('game_rules.json', json));

Matcher failsAt(String path) =>
    throwsA(isA<ContentFormatException>().having((e) => e.path, 'path', path));

void main() {
  test('the shipped rules match the spec', () {
    final rules = parse(shipped());
    expect(rules.dayStartHour, 4);
    expect(rules.energyPerCompletion, 5);
    expect(rules.energyTarget, 15);
    expect(rules.lowEnergyMaxEssentialGoals, 3);
    expect(rules.coinsPerCompletion, 3);
    expect(rules.maxPaidCompletionsPerGoalPerDay, 3);
    expect(rules.surpriseGift.chance, 0.08);
    expect(rules.surpriseGift.maxPerDay, 1);
    expect(rules.adventure.duration, const Duration(hours: 6));
    expect(rules.adventure.rewardCoins, 20);
    expect(rules.growthThresholds, {
      PetStage.baby: 0,
      PetStage.toddler: 5,
      PetStage.teen: 20,
      PetStage.adult: 60,
    });
    expect(rules.milestoneDays, [1, 3, 7, 14, 30, 50, 100, 200, 365]);
    expect(rules.milestoneCoins, 25);
    expect(rules.shopRotatingSlots, 6);
    expect(rules.traits.startingBonus, 6);
    expect(rules.reflectionPrompt.maxPerDay, 2);
    expect(rules.maxAppNotificationsPerDay, 3);
  });

  test('rejects a chance outside 0–1', () {
    final json = shipped();
    json['surpriseGift'] = {...json['surpriseGift']! as Map<String, Object?>, 'chance': 1.5};
    expect(() => parse(json), failsAt(r'$.surpriseGift.chance'));
  });

  test('rejects growth stages that are out of order', () {
    final json = shipped();
    json['growthStages'] = [
      {'stage': 'baby', 'adventures': 0},
      {'stage': 'toddler', 'adventures': 30},
      {'stage': 'teen', 'adventures': 20},
      {'stage': 'adult', 'adventures': 60},
    ];
    expect(() => parse(json), failsAt(r'$.growthStages'));
  });

  test('rejects a baby stage that needs adventures', () {
    final json = shipped();
    json['growthStages'] = [
      {'stage': 'baby', 'adventures': 1},
      {'stage': 'toddler', 'adventures': 5},
      {'stage': 'teen', 'adventures': 20},
      {'stage': 'adult', 'adventures': 60},
    ];
    expect(() => parse(json), failsAt(r'$.growthStages'));
  });

  test('rejects a zero energy target', () {
    final json = shipped()..['energyTarget'] = 0;
    expect(() => parse(json), failsAt(r'$.energyTarget'));
  });
}
