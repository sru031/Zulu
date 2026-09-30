import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/content/goal_library.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/content/onboarding_script.dart';
import 'package:zulu/domain/onboarding/plan_generator.dart';

import '../../helpers/read_file.dart';

final library = GoalLibrary.fromJson(JsonReader.decode('g.json', '''
{"areas":[{"id":"calm","label":"Calmer mind","icon":"x","trait":"calm"},{"id":"move","label":"Move more","icon":"x","trait":"confidence"}],
 "goals":[
  {"id":"bed","title":"Bed","icon":"x","area":"calm","section":"start_day","essential":true},
  {"id":"water","title":"Water","icon":"x","area":"calm","section":"any_time","essential":true},
  {"id":"breathe","title":"Breathe","icon":"x","area":"calm","section":"any_time","starter":true},
  {"id":"sit","title":"Sit","icon":"x","area":"calm","section":"any_time","starter":true},
  {"id":"walk","title":"Walk","icon":"x","area":"move","section":"any_time","starter":true},
  {"id":"dance","title":"Dance","icon":"x","area":"move","section":"any_time","starter":true},
  {"id":"stretch","title":"Stretch","icon":"x","area":"move","section":"any_time"}
 ]}'''));

final script = OnboardingScript.fromJson(JsonReader.decode('o.json', '''
{"sections":[],"foundationGoals":["bed","water"],"foundationReason":"a gentle start","focusQuestion":"areas",
 "steps":[
  {"id":"areas","type":"multi","prompt":"?","options":[{"id":"calm","label":"C"},{"id":"move","label":"M"}]},
  {"id":"mornings","type":"single","prompt":"?","options":[{"id":"hard","label":"H"},{"id":"easy","label":"E"}]}
 ],
 "planRules":[
  {"when":{"question":"mornings","equals":"hard"},"add":["stretch","bed"],"reason":"mornings are hard"}
 ]}'''));

List<(String, String)> ids(List<PlannedGoal> plan) => [for (final p in plan) (p.goal.id, p.reason)];

void main() {
  final generator = PlanGenerator(script: script, library: library);

  test('starts with the foundation goals', () {
    expect(ids(generator.generate({})), [('bed', 'a gentle start'), ('water', 'a gentle start')]);
  });

  test('matching rules add goals with their reason, without duplicates', () {
    expect(ids(generator.generate({'mornings': 'hard'})), [
      ('bed', 'a gentle start'),
      ('water', 'a gentle start'),
      ('stretch', 'mornings are hard'),
    ]);
  });

  test('fills with starters from each chosen area, one area at a time', () {
    expect(ids(generator.generate({'areas': ['move', 'calm']})), [
      ('bed', 'a gentle start'),
      ('water', 'a gentle start'),
      ('walk', 'you picked move more'),
      ('breathe', 'you picked calmer mind'),
      ('dance', 'you picked move more'),
      ('sit', 'you picked calmer mind'),
    ]);
  });

  test('never exceeds the goal limit', () {
    final small = PlanGenerator(script: script, library: library, maxGoals: 3);
    expect(small.generate({'areas': ['move', 'calm'], 'mornings': 'hard'}).map((p) => p.goal.id), ['bed', 'water', 'stretch']);
  });

  test('alternatives are same-area goals not already in the plan', () {
    final plan = generator.generate({'areas': ['move']});
    expect(generator.alternativesFor('walk', plan).map((g) => g.id), ['stretch']);
  });

  test('the shipped content produces a full, explained plan', () async {
    final content = await loadContent(readFile);
    final shipped = PlanGenerator(script: content.onboarding, library: content.goals);
    final plan = shipped.generate({
      'hard_lately': ['stress'],
      'sleep_hours': 'under_5',
      'focus_areas': ['move_more'],
      'move_blocker': ['no_time'],
    });
    expect(plan.map((p) => p.goal.id), [
      'get_out_of_bed',
      'drink_water',
      'three_breaths',
      'wind_down_10',
      'stretch_2min',
      'short_walk',
      'one_song_move',
    ]);
    expect(plan[3].reason, "you told me sleep's been short");
  });
}
