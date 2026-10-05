import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/content/story_book.dart';
import 'package:zulu/domain/pet/pet_stage.dart';
import 'package:zulu/domain/text/template.dart';

import '../helpers/read_file.dart';

StoryBook parse(String json) => StoryBook.fromJson(JsonReader.decode('s.json', json));

void main() {
  final book = parse('{"stories":['
      '{"id":"a","place":"Pond","text":"A"},'
      '{"id":"b","place":"Hill","text":"B","stages":["teen","adult"]},'
      '{"id":"c","place":"Wood","text":"C"}]}');

  test('picks the same story for the same seed', () {
    expect(book.pick(seed: 7, stage: PetStage.baby).id, book.pick(seed: 7, stage: PetStage.baby).id);
  });

  test('only offers stories meant for the pet\'s stage', () {
    final babyIds = {for (var seed = 0; seed < 20; seed++) book.pick(seed: seed, stage: PetStage.baby).id};
    expect(babyIds, {'a', 'c'});
    final teenIds = {for (var seed = 0; seed < 20; seed++) book.pick(seed: seed, stage: PetStage.teen).id};
    expect(teenIds, {'a', 'b', 'c'});
  });

  test('looks up a story by id', () {
    expect(book.byId('b')?.place, 'Hill');
    expect(book.byId('zzz'), isNull);
  });

  test('rejects unknown stages and duplicate ids', () {
    expect(() => parse('{"stories":[{"id":"a","place":"P","text":"T","stages":["elder"]}]}'),
        throwsA(isA<ContentFormatException>().having((e) => e.path, 'path', r'$.stories[0].stages')));
    expect(() => parse('{"stories":[{"id":"a","place":"P","text":"T"},{"id":"a","place":"Q","text":"U"}]}'),
        throwsA(isA<ContentFormatException>().having((e) => e.path, 'path', r'$.stories[1].id')));
  });

  test('the shipped stories cover every stage and use only known placeholders', () async {
    final content = await loadContent(readFile);
    expect(content.stories.stories.length, greaterThanOrEqualTo(12));
    for (final stage in PetStage.values) {
      expect(content.stories.stories.where((s) => s.stages.isEmpty || s.stages.contains(stage)), isNotEmpty, reason: stage.name);
    }
    for (final s in content.stories.stories) {
      expect(unknownPlaceholders(s.text), isEmpty, reason: s.id);
      expect(RegExp('streak|in a row', caseSensitive: false).hasMatch(s.text), isFalse, reason: s.id);
    }
  });
}
