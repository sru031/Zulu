import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/domain/onboarding/onboarding_outcome.dart';
import 'package:zulu/domain/pet/trait.dart';
import 'package:zulu/domain/text/template.dart';

import '../../helpers/read_file.dart';

void main() {
  late ContentBundle content;

  setUpAll(() async => content = await loadContent(readFile));

  OnboardingOutcome outcome(Map<String, Object> answers) => OnboardingOutcome.from(
        script: content.onboarding,
        answers: answers,
        startingBonus: 6,
        fallbackEgg: 'sunrise',
      );

  test('reads the pet and profile from the saved answers', () {
    final o = outcome({
      'egg': 'mint',
      'pet_name': '  Mochi ',
      'pet_pronouns': 'she',
      'pet_trait': 'calm',
      'user_name': 'Sam',
      'self_care': 'hard_days',
      'wake_time': '06:45',
      'bed_time': '22:30',
    });
    expect(o.eggColor, 'mint');
    expect(o.petName, 'Mochi');
    expect(o.pronouns, Pronouns.she);
    expect(o.trait, Trait.calm);
    expect(o.traitStats, {Trait.calm: 6.0, Trait.resilience: 1.0});
    expect(o.userName, 'Sam');
    expect(o.wakeTime, '06:45');
    expect(o.bedTime, '22:30');
  });

  test('falls back when optional answers are missing', () {
    final o = outcome({'user_name': ''});
    expect(o.petName, 'Pip');
    expect(o.pronouns, Pronouns.they);
    expect(o.eggColor, 'sunrise');
    expect(o.trait, Trait.curiosity);
    expect(o.userName, '');
    expect(o.wakeTime, '07:30');
    expect(o.bedTime, '23:00');
    final vars = templateVars(userName: o.userName, petName: o.petName, pronouns: o.pronouns, currency: 'coin', currencyPlural: 'coins');
    expect(fillTemplate('Nice to meet you, {userName}!', vars), 'Nice to meet you, friend!');
  });

  test('a nudge toward the chosen trait adds to its starting bonus', () {
    final o = outcome({'pet_trait': 'compassion', 'self_care': 'body_mind'});
    expect(o.traitStats, {Trait.compassion: 7.0});
  });
}
