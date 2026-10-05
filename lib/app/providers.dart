import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../content/content_bundle.dart';
import '../core/clock.dart';
import '../data/db/database.dart';
import '../data/onboarding_completer.dart';
import '../data/repositories/day_repository.dart';
import '../data/repositories/goal_repository.dart';
import '../data/repositories/onboarding_repository.dart';
import '../data/repositories/pet_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../data/repositories/wallet_repository.dart';
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

final goalRepositoryProvider = Provider<GoalRepository>(
  (ref) => GoalRepository(ref.watch(databaseProvider), ref.watch(clockProvider)),
);

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => OnboardingRepository(ref.watch(databaseProvider), ref.watch(clockProvider)),
);

final onboardingCompleterProvider = Provider<OnboardingCompleter>(
  (ref) => OnboardingCompleter(
    db: ref.watch(databaseProvider),
    profiles: ref.watch(profileRepositoryProvider),
    pets: ref.watch(petRepositoryProvider),
    goals: ref.watch(goalRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

/// The profile, kept up to date.
final profileProvider = StreamProvider<Profile>((ref) => ref.watch(profileRepositoryProvider).watch());

/// Whether onboarding was finished when the app started. Set by bootstrap.
final initialOnboardedProvider = Provider<bool>((ref) => false);

/// The hatched pet, or null before hatching.
final petProvider = StreamProvider<Pet?>((ref) => ref.watch(petRepositoryProvider).watch());

final dayRepositoryProvider = Provider<DayRepository>(
  (ref) => DayRepository(ref.watch(databaseProvider), ref.watch(clockProvider)),
);

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => WalletRepository(ref.watch(databaseProvider), ref.watch(clockProvider)),
);
