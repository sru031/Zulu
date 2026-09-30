import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/goal_library.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/domain/pet/trait.dart';

Matcher failsAt(String path) =>
    throwsA(isA<ContentFormatException>().having((e) => e.path, 'path', path));

GoalLibrary parse(String json) => GoalLibrary.fromJson(JsonReader.decode('g.json', json));

void main() {
  late GoalLibrary library;

  setUpAll(() {
    library = GoalLibrary.fromJson(
      JsonReader.decode(GoalLibrary.fileName, File(GoalLibrary.fileName).readAsStringSync()),
    );
  });

  test('has the ten focus areas from the spec, in order', () {
    expect(library.areas.map((a) => a.id), [
      'calmer_mind',
      'rest_sleep',
      'move_more',
      'eat_well',
      'feel_fresh',
      'focus',
      'kinder_to_myself',
      'notice_good',
      'connect',
      'steady_routine',
    ]);
    expect(library.area('connect')?.trait, Trait.compassion);
  });

  test('every area offers at least two starter goals', () {
    for (final area in library.areas) {
      expect(library.startersIn(area.id).length, greaterThanOrEqualTo(2), reason: area.id);
    }
  });

  test('has enough essential goals for low-energy days', () {
    expect(library.goals.where((g) => g.essential).length, greaterThanOrEqualTo(6));
  });

  test('includes the foundation goals as essential', () {
    expect(library.byId('get_out_of_bed')?.essential, isTrue);
    expect(library.byId('drink_water')?.essential, isTrue);
    expect(library.byId('get_out_of_bed')?.section, GoalSection.startOfDay);
  });

  test('contains no weight or calorie language', () {
    final banned = RegExp(r'weight|calorie|diet|\bkg\b|\blbs?\b|\bfat\b|skinny|burn', caseSensitive: false);
    for (final goal in library.goals) {
      expect(banned.hasMatch(goal.title), isFalse, reason: goal.title);
    }
  });

  test('rejects an unknown area', () {
    expect(
      () => parse('{"areas":[{"id":"a","label":"A","icon":"x","trait":"calm"}],'
          '"goals":[{"id":"g","title":"G","icon":"x","area":"b","section":"any_time"}]}'),
      failsAt(r'$.goals[0].area'),
    );
  });

  test('rejects duplicate goal ids', () {
    expect(
      () => parse('{"areas":[{"id":"a","label":"A","icon":"x","trait":"calm"}],'
          '"goals":[{"id":"g","title":"G","icon":"x","area":"a","section":"any_time"},'
          '{"id":"g","title":"H","icon":"x","area":"a","section":"any_time"}]}'),
      failsAt(r'$.goals[1].id'),
    );
  });

  test('rejects an unknown trait and an unknown section', () {
    expect(
      () => parse('{"areas":[{"id":"a","label":"A","icon":"x","trait":"bravery"}],"goals":[]}'),
      failsAt(r'$.areas[0].trait'),
    );
    expect(
      () => parse('{"areas":[{"id":"a","label":"A","icon":"x","trait":"calm"}],'
          '"goals":[{"id":"g","title":"G","icon":"x","area":"a","section":"noon"}]}'),
      failsAt(r'$.goals[0].section'),
    );
  });
}
