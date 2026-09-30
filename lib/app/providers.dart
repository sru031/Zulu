import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../content/content_bundle.dart';
import '../core/clock.dart';
import '../data/db/database.dart';
import '../data/repositories/pet_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../theme_kit/theme_kit.dart';

/// Set by `bootstrap()` at startup and by tests.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider is set at startup'),
);

final contentProvider = Provider<ContentBundle>(
  (ref) => throw UnimplementedError('contentProvider is set at startup'),
);

final themeKitProvider = Provider<ThemeKit>(
  (ref) => throw UnimplementedError('themeKitProvider is set at startup'),
);

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(databaseProvider), ref.watch(clockProvider)),
);

final petRepositoryProvider = Provider<PetRepository>(
  (ref) => PetRepository(ref.watch(databaseProvider)),
);
