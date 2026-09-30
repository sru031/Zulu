import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/json_reader.dart';

void main() {
  test('reads typed fields', () {
    final r = JsonReader.decode('a.json', '{"name":"Pip","age":2,"ratio":0.5,"on":true,"tags":["x","y"]}');
    expect(r.string('name'), 'Pip');
    expect(r.integer('age'), 2);
    expect(r.number('ratio'), 0.5);
    expect(r.number('age'), 2.0);
    expect(r.boolean('on'), isTrue);
    expect(r.strings('tags'), ['x', 'y']);
  });

  test('optional fields return null or the fallback', () {
    final r = JsonReader.decode('a.json', '{"x":null}');
    expect(r.optString('x'), isNull);
    expect(r.optString('missing'), isNull);
    expect(r.boolean('missing', orElse: false), isFalse);
    expect(r.optStrings('missing'), isEmpty);
  });

  test('errors name the file and the exact path', () {
    final r = JsonReader.decode('goals.json', '{"goals":[{"id":"a"},{"id":7}]}');
    expect(
      () => r.list('goals')[1].string('id'),
      throwsA(isA<ContentFormatException>().having(
        (e) => e.toString(),
        'toString',
        r'goals.json → $.goals[1].id: expected a string',
      )),
    );
  });

  test('missing required fields are reported at their path', () {
    final r = JsonReader.decode('a.json', '{}');
    expect(
      () => r.string('name'),
      throwsA(isA<ContentFormatException>()
          .having((e) => e.path, 'path', r'$.name')
          .having((e) => e.message, 'message', 'is required')),
    );
  });

  test('invalid JSON is reported with the file name', () {
    expect(
      () => JsonReader.decode('broken.json', '{"a": 1,}'),
      throwsA(isA<ContentFormatException>().having((e) => e.file, 'file', 'broken.json')),
    );
  });

  test('fail() raises a custom message at the current path', () {
    final n = JsonReader.decode('a.json', '{"n":-1}').field('n');
    expect(
      () => n.fail('must be positive'),
      throwsA(isA<ContentFormatException>().having((e) => e.toString(), 'toString', r'a.json → $.n: must be positive')),
    );
  });
}
