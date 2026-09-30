// Checks every manifest, content file and art reference.
// Run from the project root:  dart run tool/validate_assets.dart
import 'dart:io';

import 'package:zulu/content/asset_validator.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import 'asset_files.dart';

Future<void> main() async {
  Future<String> read(String path) => File(path).readAsString();
  try {
    final theme = await loadThemeKit(read);
    final content = await loadContent(read);
    final files = listAssetFiles('assets');
    final issues = [
      ...AssetValidator(exists: files.contains, pngSize: readPngSize).validate(theme: theme, content: content),
      ...checkPubspecAssetDirs(File('pubspec.yaml').readAsStringSync(), files),
    ];
    for (final issue in issues) {
      stdout.writeln(issue);
    }
    final errors = issues.where((i) => i.isError).length;
    final warnings = issues.length - errors;
    stdout.writeln(errors == 0 ? 'Assets OK ($warnings warnings).' : '$errors error(s), $warnings warning(s).');
    exitCode = errors == 0 ? 0 : 1;
  } on ContentFormatException catch (e) {
    stderr.writeln('ERROR    $e');
    exitCode = 1;
  }
}
