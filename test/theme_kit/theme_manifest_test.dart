import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/theme_kit/icon_ref.dart';
import 'package:zulu/theme_kit/theme_manifest.dart';

Matcher failsAt(String path) =>
    throwsA(isA<ContentFormatException>().having((e) => e.path, 'path', path));

void main() {
  test('parses #RRGGBB and #AARRGGBB colors', () {
    expect(parseHexColor(JsonReader('t.json', '#6C8CFF')), 0xFF6C8CFF);
    expect(parseHexColor(JsonReader('t.json', '#806C8CFF')), 0x806C8CFF);
  });

  test('rejects a malformed color at its path', () {
    final r = JsonReader.decode('t.json', '{"c":"blue"}');
    expect(() => parseHexColor(r.field('c')), failsAt(r'$.c'));
  });

  test('tells emoji icons from image icons', () {
    expect(const IconRef('🙂').isImage, isFalse);
    expect(const IconRef('icons/mood.PNG').isImage, isTrue);
  });

  test('requires exactly five mood icons', () {
    const json = '{"appName":"Z","petSpecies":{"singular":"a","plural":"b"},'
        '"currency":{"singular":"c","plural":"d","icon":"🪙"},'
        '"colors":{"light":{"primary":"#000000","background":"#000000","surface":"#000000","text":"#000000","energy":"#000000","success":"#000000"},'
        '"dark":{"primary":"#000000","background":"#000000","surface":"#000000","text":"#000000","energy":"#000000","success":"#000000"}},'
        '"moodIcons":["a","b"]}';
    expect(() => ThemeManifest.fromJson(JsonReader.decode('t.json', json)), failsAt(r'$.moodIcons'));
  });
}
