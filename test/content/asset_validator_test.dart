import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/asset_validator.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/theme_kit/item_catalog.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../../tool/asset_files.dart';
import '../helpers/read_file.dart';

void main() {
  late ThemeKit kit;
  late ContentBundle content;
  late Set<String> files;

  setUpAll(() async {
    kit = await loadThemeKit(readFile);
    content = await loadContent(readFile);
  });

  setUp(() => files = listAssetFiles('assets'));

  List<ValidationIssue> validate({ThemeKit? theme, ({int width, int height})? Function(String)? pngSize}) =>
      AssetValidator(exists: files.contains, pngSize: pngSize).validate(theme: theme ?? kit, content: content);

  test('the shipped assets have no errors', () {
    expect(validate(pngSize: readPngSize).where((i) => i.isError), isEmpty);
  });

  test('every asset folder is listed in pubspec.yaml', () {
    expect(checkPubspecAssetDirs(File('pubspec.yaml').readAsStringSync(), files), isEmpty);
  });

  test('reports a missing file', () {
    files.remove('assets/theme/pet/baby/happy.png');
    expect(
      validate().where((i) => i.isError).map((i) => i.message),
      contains('missing file assets/theme/pet/baby/happy.png'),
    );
  });

  test('lists file names with their exact letter case', () {
    final dir = Directory.systemTemp.createTempSync('zulu_assets');
    addTearDown(() => dir.deleteSync(recursive: true));
    File('${dir.path}/pet/Idle.png')
      ..parent.createSync(recursive: true)
      ..writeAsBytesSync([0]);
    final listed = listAssetFiles(dir.path);
    expect(listed.any((f) => f.endsWith('/pet/Idle.png')), isTrue);
    expect(listed.any((f) => f.endsWith('/pet/idle.png')), isFalse);
  });

  test('warns when pet art is not the canvas size', () {
    final issues = validate(
      pngSize: (path) => path.endsWith('baby/idle.png') ? (width: 300, height: 300) : (width: 512, height: 512),
    );
    expect(issues.where((i) => !i.isError).map((i) => i.message), contains(contains('300×300')));
  });

  test('flags a decor item whose slot is not in the room', () {
    final broken = ThemeKit(
      theme: kit.theme,
      pet: kit.pet,
      items: ItemCatalog([
        const ShopItem(id: 'chandelier', name: 'Chandelier', kind: ItemKind.decor, slot: 'ceiling', price: 50, image: 'items/sun_hat.png', everyday: false),
      ]),
      rooms: kit.rooms,
      effects: kit.effects,
    );
    expect(validate(theme: broken).where((i) => i.isError).map((i) => i.message), contains(contains('"ceiling"')));
  });

  test('pubspec check flags an unlisted folder', () {
    final issues = checkPubspecAssetDirs(
      'flutter:\n  assets:\n    - assets/content/\n',
      {'assets/content/a.json', 'assets/theme/x.png'},
    );
    expect(issues.single.message, contains('assets/theme/'));
  });

  test('readPngSize reads the header of a real PNG', () {
    expect(readPngSize('assets/theme/pet/baby/idle.png'), (width: 512, height: 512));
    expect(readPngSize('assets/content/game_rules.json'), isNull);
  });
}
