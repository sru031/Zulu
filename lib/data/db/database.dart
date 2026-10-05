import 'package:drift/drift.dart';

part 'database.g.dart';

/// The single profile row (id 1): the user's settings.
class Profiles extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get installId => text()();
  TextColumn get userName => text().withDefault(const Constant(''))();

  /// `HH:mm` local time.
  TextColumn get wakeTime => text().withDefault(const Constant('07:30'))();
  TextColumn get bedTime => text().withDefault(const Constant('23:00'))();
  IntColumn get dayStartHour => integer().withDefault(const Constant(4))();

  /// `daily`, `every_open` or `off`.
  TextColumn get moodCheckInMode => text().withDefault(const Constant('daily'))();
  BoolColumn get paused => boolean().withDefault(const Constant(false))();
  BoolColumn get reduceMotion => boolean().withDefault(const Constant(false))();
  BoolColumn get sound => boolean().withDefault(const Constant(true))();
  BoolColumn get haptics => boolean().withDefault(const Constant(true))();
  BoolColumn get notifyMorning => boolean().withDefault(const Constant(true))();
  BoolColumn get notifyAdventure => boolean().withDefault(const Constant(true))();
  BoolColumn get notifyEvening => boolean().withDefault(const Constant(false))();

  /// Id of the onboarding question to resume at, or null.
  TextColumn get onboardingStep => text().nullable()();
  DateTimeColumn get onboardingDoneAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// The single pet row (id 1), created when the egg hatches.
class Pets extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get name => text()();

  /// A `Pronouns` name: `she`, `he` or `they`.
  TextColumn get pronouns => text()();
  TextColumn get eggColor => text()();

  /// The `Trait` name chosen in onboarding.
  TextColumn get trait => text()();

  /// JSON map of trait name to score.
  TextColumn get traitStats => text().withDefault(const Constant('{}'))();
  DateTimeColumn get hatchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One row per answered onboarding step, so the quiz can resume.
class OnboardingAnswers extends Table {
  TextColumn get questionId => text()();

  /// JSON: a string or a list of strings.
  TextColumn get value => text()();
  DateTimeColumn get answeredAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {questionId};
}

/// The user's goals. Copied from library templates or typed by the user.
class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();

  /// An emoji.
  TextColumn get icon => text()();
  TextColumn get area => text()();

  /// A `GoalSection` id: `start_day`, `any_time` or `end_day`.
  TextColumn get section => text()();

  /// Bit 0 = Monday … bit 6 = Sunday; 127 = every day.
  IntColumn get weekdaysMask => integer().withDefault(const Constant(127))();
  IntColumn get timesPerDay => integer().withDefault(const Constant(1))();
  BoolColumn get essential => boolean().withDefault(const Constant(false))();

  /// `HH:mm`, or null for no reminder.
  TextColumn get reminderTime => text().nullable()();
  IntColumn get sortOrder => integer()();

  /// The `GoalTemplate` id this came from, if any.
  TextColumn get libraryId => text().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

/// One row per goal check-off. Undo deletes the latest row.
class Completions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer()();

  /// `AppDay.key` of the day it counts for.
  TextColumn get appDay => text()();
  DateTimeColumn get completedAt => dateTime()();
}

/// Goals the user chose to skip for one day. Skipping never costs anything.
class Skips extends Table {
  IntColumn get goalId => integer()();
  TextColumn get appDay => text()();

  @override
  Set<Column<Object>> get primaryKey => {goalId, appDay};
}

/// Per-day state: low-energy mode, the adventure and the surprise gift.
class Days extends Table {
  TextColumn get appDay => text()();
  BoolColumn get lowEnergy => boolean().withDefault(const Constant(false))();
  DateTimeColumn get adventureStartedAt => dateTime().nullable()();
  DateTimeColumn get adventureEndsAt => dateTime().nullable()();
  TextColumn get storyId => text().nullable()();
  BoolColumn get adventureClaimed => boolean().withDefault(const Constant(false))();
  BoolColumn get surpriseGiven => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {appDay};
}

/// Every coin earned or refunded. The balance is the sum.
class WalletLedger extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amount => integer()();

  /// `goal`, `goal_undo`, `surprise`, `adventure`, `milestone` or `purchase`.
  TextColumn get reason => text()();
  TextColumn get refId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}


@DriftDatabase(tables: [Profiles, Pets, OnboardingAnswers, Goals, Completions, Skips, Days, WalletLedger])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(onboardingAnswers);
            await m.createTable(goals);
          }
          if (from < 3) {
            await m.createTable(completions);
            await m.createTable(skips);
            await m.createTable(days);
            await m.createTable(walletLedger);
          }
        },
      );
}
