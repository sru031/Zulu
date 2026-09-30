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

@DriftDatabase(tables: [Profiles, Pets])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
