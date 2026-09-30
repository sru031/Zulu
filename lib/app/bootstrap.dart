import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/misc.dart';

import '../content/asset_validator.dart';
import '../content/content_bundle.dart';
import '../core/clock.dart';
import '../data/db/database.dart';
import '../data/db/open_database.dart';
import '../data/repositories/profile_repository.dart';
import '../theme_kit/theme_kit.dart';
import 'providers.dart';

/// Loads content and art, checks them in debug builds, opens the database
/// and returns the provider overrides the app runs with.
Future<List<Override>> bootstrap() async {
  Future<String> read(String path) => rootBundle.loadString(path);
  final content = await loadContent(read);
  final theme = await loadThemeKit(read);

  if (kDebugMode) {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final bundled = manifest.listAssets().toSet();
    final issues = AssetValidator(exists: bundled.contains).validate(theme: theme, content: content);
    for (final issue in issues) {
      debugPrint(issue.toString());
    }
    if (issues.any((i) => i.isError)) {
      throw StateError('Asset check failed. Run `dart run tool/validate_assets.dart` for details.');
    }
  }

  final db = AppDatabase(openZuluDatabase());
  await ProfileRepository(db, const SystemClock()).ensure();

  return [
    databaseProvider.overrideWithValue(db),
    contentProvider.overrideWithValue(content),
    themeKitProvider.overrideWithValue(theme),
  ];
}
