import 'dart:io';

import 'package:zulu/content/asset_validator.dart';

/// Every file under [root], as forward-slash paths with their real letter
/// case (e.g. `assets/theme/pet/baby/idle.png`).
Set<String> listAssetFiles(String root) => {
      for (final entity in Directory(root).listSync(recursive: true))
        if (entity is File) entity.path.replaceAll(r'\', '/'),
    };

/// Width and height from a PNG header, or null if [path] isn't a PNG.
({int width, int height})? readPngSize(String path) {
  final file = File(path);
  if (!file.existsSync()) return null;
  final raf = file.openSync();
  try {
    final header = raf.readSync(24);
    if (header.length < 24 || header[1] != 0x50 || header[2] != 0x4E || header[3] != 0x47) return null;
    int bigEndian(int offset) =>
        (header[offset] << 24) | (header[offset + 1] << 16) | (header[offset + 2] << 8) | header[offset + 3];
    return (width: bigEndian(16), height: bigEndian(20));
  } finally {
    raf.closeSync();
  }
}

/// Flutter bundles only folders listed under `flutter: assets:` (folders
/// are not recursive), so every folder that holds files must be listed.
List<ValidationIssue> checkPubspecAssetDirs(String pubspec, Set<String> files) {
  final listed = {
    for (final m in RegExp(r'^\s*-\s*(assets/\S*/)\s*$', multiLine: true).allMatches(pubspec)) m[1]!,
  };
  final dirs = {for (final f in files) f.substring(0, f.lastIndexOf('/') + 1)}.toList()..sort();
  return [
    for (final dir in dirs)
      if (!listed.contains(dir))
        ValidationIssue.error('pubspec.yaml', 'folder $dir has files but is not listed under flutter → assets'),
  ];
}
