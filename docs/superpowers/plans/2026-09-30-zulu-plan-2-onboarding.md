# Zulu Plan 2 — Onboarding Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A new user goes from "Hatch a new pet" through pet setup and the four-section quiz, with follow-up questions that change based on earlier answers, to a starter plan that explains each goal back to them. Accepting the plan saves the pet, the profile and the goals, then lands on Home. Closing the app midway resumes where the user left off.

**Architecture:**
- **Content:** the whole flow is data in `assets/content/onboarding.json`, parsed by `OnboardingScript`.
- **Pure-Dart domain logic:** `QuestionFlow` (which step is next and which are visible, progress, pruning answers), `PlanGenerator` (answers to goals with reasons) and `OnboardingOutcome` (answers to pet and profile values).
- **Controller:** a Riverpod `OnboardingController` saves each answer as it's given, and `OnboardingCompleter` writes everything in one transaction.
- **UI:** one widget per step type.
- **Routing:** go_router redirects anyone who hasn't finished onboarding to `/onboarding`.

**Tech Stack:** Flutter 3.47.5, `material_ui`, `flutter_riverpod` 3, `go_router` 18, `drift` 2.35, `lottie` 3, and the new `flutter_local_notifications` 22 (only to ask for notification permission).

**Spec:** `docs/superpowers/specs/2026-09-29-zulu-v1-design.md` (§6 onboarding, §10 `goals` and `onboarding_answers` tables, §4.2 pose fallbacks, §4.5 effects)

**Scope:**
- **In this plan:**
  - onboarding, including a simple Welcome step (restoring a backup comes in Plan 6)
  - the `PetView` widget for PNG and Lottie poses (Rive rendering comes in Plan 3; until then Rive poses show the baby idle PNG)
  - the `EffectView` Lottie widget with its fallback
  - asking for notification permission (scheduling comes in Plan 6)
- **Not in this plan:** Home's goal list, energy and check-off (Plan 3).

## Global Constraints

- **Flutter isn't on PATH.** `flutter` means `C:\src\flutter\bin\flutter.bat` and `dart` means `C:\src\flutter\bin\dart.bat`. Run from `C:\Users\sru50\StudioProjects\zulu`.
- **Android only.** There's no `ios/` folder, and no Windows Developer Mode is needed.
- **Code generation** is `dart run build_runner build --delete-conflicting-outputs --force-jit`.
- **UI imports** come from `package:material_ui/material_ui.dart`, never `package:flutter/material.dart`.
- **Pure-Dart layers:** `lib/core`, `lib/content`, `lib/theme_kit` and `lib/domain` never import Flutter.
- **Content writing:**
  - All writing is original, not Finch's.
  - Never use the words "streak" or "in a row".
  - No diagnosis, gender or age questions.
  - No weight or calorie goals.
  - The pet invites and never blames.
- **Commit messages** end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.

## Review Focus

1. **The user changes an earlier answer after follow-ups were answered.** For example, they untick "Move more". The follow-up answer must be dropped, including follow-ups that depend on it (Task 4, "prune drops answers of hidden steps, cascading").
2. **The app is killed mid-quiz.** Reopening must resume at the first unanswered visible step, not restart (Task 8, "resumes at the first unanswered step").
3. **The user skips their name.** Prompts that use `{userName}` must read "friend", not "{userName}" or empty (Task 6, "falls back when optional answers are missing").
4. **The user removes goals from the plan.** At least one goal must always remain (Task 8, "the plan keeps at least one goal").
5. **Someone edits `onboarding.json` badly.** A follow-up pointing at a later step, or a plan rule naming a goal that doesn't exist, must fail with a precise error (Task 2 and Task 3 tests).
6. **The existing Plan 1 database on the emulator** (schema version 1) must upgrade in place, without a reinstall (Task 1, "upgrades a version 1 database").

---

## File Structure

```
android/app/build.gradle.kts                               (desugaring for flutter_local_notifications)
assets/content/onboarding.json                             the whole flow + plan rules
lib/
  domain/onboarding/answers.dart                           typedef Answers
  domain/onboarding/question_flow.dart                     QuestionFlow, SectionProgress
  domain/onboarding/plan_generator.dart                    PlannedGoal, PlanGenerator
  domain/onboarding/onboarding_outcome.dart                OnboardingOutcome
  content/onboarding_script.dart                           StepType, SaveTo, Condition, StepOption, OnboardingStep, Section, PlanRule, OnboardingScript
  content/content_bundle.dart                              (+ onboarding)
  content/asset_validator.dart                             (+ onboarding cross-checks)
  data/db/database.dart                                    (+ OnboardingAnswers, Goals, schema v2)
  data/repositories/goal_repository.dart                   NewGoal, GoalRepository
  data/repositories/onboarding_repository.dart             OnboardingRepository
  data/onboarding_completer.dart                           OnboardingCompleter
  app/providers.dart                                       (+ repos, profileProvider, initialOnboardedProvider)
  app/bootstrap.dart, app/app.dart, app/router.dart        (+ onboarding gate)
  shared/widgets/pet_view.dart                             PetView
  shared/widgets/effect_view.dart                          EffectView
  shared/services/reminder_permission.dart                 ReminderPermission (+ plugin impl, provider)
  features/onboarding/onboarding_controller.dart           OnboardingState, OnboardingController
  features/onboarding/ui/onboarding_screen.dart            OnboardingScreen
  features/onboarding/ui/plan_view.dart                    PlanView (loading → plan)
  features/onboarding/ui/section_progress_bar.dart
  features/onboarding/ui/step_views.dart                   one widget per step type
  features/home/ui/home_screen.dart                        (message after hatching)
test/ (mirrors lib/), test/helpers/test_app.dart
```

---

### Task 1: Goals and onboarding-answer tables (schema v2)

**Files:**
- Create: `lib/domain/onboarding/answers.dart`, `lib/data/repositories/goal_repository.dart`, `lib/data/repositories/onboarding_repository.dart`
- Modify: `lib/data/db/database.dart` (regenerate `database.g.dart`), `lib/app/providers.dart`
- Test: `test/data/migration_test.dart`, `test/data/goal_repository_test.dart`, `test/data/onboarding_repository_test.dart`

**Interfaces:**
- Consumes: `AppDatabase`, `Profiles`, `Pets` (Plan 1); `GoalSection`, `GoalTemplate` (Plan 1); `Clock`, `FakeClock`
- Produces:
  - `typedef Answers = Map<String, Object>;` where each value is a `String` or a `List<String>`
  - tables `onboardingAnswers` (data class `OnboardingAnswer`) and `goals` (data class `Goal`); `schemaVersion == 2`
  - `NewGoal({title, icon, area, section, essential = false, libraryId})` and `NewGoal.fromTemplate(GoalTemplate)`
  - `GoalRepository(AppDatabase, Clock)` with `addAll(List<NewGoal>)`, `active()`, `watchActive()`
  - `OnboardingRepository(AppDatabase, Clock)` with `answers() → Future<Answers>`, `saveAnswer(String id, Object value)`, `removeAnswers(Iterable<String> ids)`
  - providers `goalRepositoryProvider` and `onboardingRepositoryProvider`

- [ ] **Step 1: Write the failing tests**

`test/data/migration_test.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/data/db/database.dart';

void main() {
  test('upgrades a version 1 database by adding the new tables', () async {
    final db = AppDatabase(NativeDatabase.memory(setup: (raw) {
      raw.execute('CREATE TABLE profiles (id INTEGER NOT NULL PRIMARY KEY)');
      raw.execute('CREATE TABLE pets (id INTEGER NOT NULL PRIMARY KEY)');
      raw.execute('PRAGMA user_version = 1');
    }));
    addTearDown(db.close);

    await db.into(db.onboardingAnswers).insert(OnboardingAnswersCompanion.insert(
          questionId: 'q',
          value: '"a"',
          answeredAt: DateTime(2026, 9, 30),
        ));
    expect(await db.select(db.onboardingAnswers).get(), hasLength(1));
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.single, 2);
  });

  test('a fresh database has every table', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    expect(await db.select(db.goals).get(), isEmpty);
    expect(await db.select(db.onboardingAnswers).get(), isEmpty);
    expect(await db.select(db.profiles).get(), isEmpty);
  });
}
```

`test/data/goal_repository_test.dart`:

```dart
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/goal_library.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/goal_repository.dart';

void main() {
  late AppDatabase db;
  late GoalRepository goals;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    goals = GoalRepository(db, FakeClock(DateTime(2026, 9, 30, 9)));
  });

  tearDown(() => db.close());

  const water = NewGoal(title: 'Drink water', icon: '💧', area: 'eat_well', section: GoalSection.anyTime, essential: true, libraryId: 'drink_water');
  const bed = NewGoal(title: 'Get out of bed', icon: '🌅', area: 'steady_routine', section: GoalSection.startOfDay);

  test('adds goals in order and keeps counting on later adds', () async {
    await goals.addAll([water, bed]);
    await goals.addAll([water]);
    final active = await goals.active();
    expect(active.map((g) => g.title), ['Drink water', 'Get out of bed', 'Drink water']);
    expect(active.map((g) => g.sortOrder), [0, 1, 2]);
    expect(active.first.section, 'any_time');
    expect(active.first.essential, isTrue);
    expect(active.first.libraryId, 'drink_water');
    expect(active.first.weekdaysMask, 127);
    expect(active.first.timesPerDay, 1);
    expect(active[1].libraryId, isNull);
  });

  test('archived goals are not active', () async {
    await goals.addAll([water, bed]);
    await (db.update(db.goals)..where((g) => g.title.equals('Drink water')))
        .write(GoalsCompanion(archivedAt: Value(DateTime(2026, 10, 1))));
    expect((await goals.active()).map((g) => g.title), ['Get out of bed']);
  });

  test('NewGoal.fromTemplate copies the library fields', () {
    const template = GoalTemplate(
      id: 'shower',
      title: 'Take a shower',
      icon: '🚿',
      area: 'feel_fresh',
      section: GoalSection.anyTime,
      essential: false,
      starter: true,
      tags: [],
    );
    final goal = NewGoal.fromTemplate(template);
    expect(goal.title, 'Take a shower');
    expect(goal.icon, '🚿');
    expect(goal.area, 'feel_fresh');
    expect(goal.section, GoalSection.anyTime);
    expect(goal.libraryId, 'shower');
  });
}
```

`test/data/onboarding_repository_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/onboarding_repository.dart';

void main() {
  late AppDatabase db;
  late OnboardingRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = OnboardingRepository(db, FakeClock(DateTime(2026, 9, 30, 9)));
  });

  tearDown(() => db.close());

  test('stores text and multi-choice answers and reads them back typed', () async {
    await repo.saveAnswer('pet_name', 'Mochi');
    await repo.saveAnswer('focus_areas', ['move_more', 'rest_sleep']);
    final answers = await repo.answers();
    expect(answers['pet_name'], 'Mochi');
    expect(answers['focus_areas'], isA<List<String>>());
    expect(answers['focus_areas'], ['move_more', 'rest_sleep']);
  });

  test('saving again replaces the answer', () async {
    await repo.saveAnswer('get_up', 'easy');
    await repo.saveAnswer('get_up', 'hard');
    expect((await repo.answers())['get_up'], 'hard');
  });

  test('removes only the named answers', () async {
    await repo.saveAnswer('a', 'x');
    await repo.saveAnswer('b', 'y');
    await repo.removeAnswers(['a']);
    await repo.removeAnswers([]);
    expect((await repo.answers()).keys, ['b']);
  });
}
```

- [ ] **Step 2: Run them to see them fail**

Run: `flutter test test/data`
Expected: FAIL. `onboardingAnswers`, `goals`, `GoalRepository` and `OnboardingRepository` aren't defined.

- [ ] **Step 3: Add the answers type — `lib/domain/onboarding/answers.dart`**

```dart
/// Onboarding answers by step id. Each value is a `String` (single choice,
/// text, time, or a marker for steps without a real answer) or a
/// `List<String>` (multi choice).
typedef Answers = Map<String, Object>;
```

- [ ] **Step 4: Add the tables and migration to `lib/data/db/database.dart`**

After the `Pets` class, add:

```dart
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
```

Replace the `@DriftDatabase` class with:

```dart
@DriftDatabase(tables: [Profiles, Pets, OnboardingAnswers, Goals])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(onboardingAnswers);
            await m.createTable(goals);
          }
        },
      );
}
```

Run: `dart run build_runner build --delete-conflicting-outputs --force-jit` → Expected: `Built with build_runner/jit`.

- [ ] **Step 5: Implement the repositories**

`lib/data/repositories/goal_repository.dart`:

```dart
import 'package:drift/drift.dart';

import '../../content/goal_library.dart';
import '../../core/clock.dart';
import '../db/database.dart';

/// A goal about to be created, from the library or typed by the user.
class NewGoal {
  const NewGoal({
    required this.title,
    required this.icon,
    required this.area,
    required this.section,
    this.essential = false,
    this.libraryId,
  });

  factory NewGoal.fromTemplate(GoalTemplate t) => NewGoal(
        title: t.title,
        icon: t.icon,
        area: t.area,
        section: t.section,
        essential: t.essential,
        libraryId: t.id,
      );

  final String title;
  final String icon;
  final String area;
  final GoalSection section;
  final bool essential;
  final String? libraryId;
}

class GoalRepository {
  GoalRepository(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  /// Adds [goals] after the existing ones, in the given order.
  Future<void> addAll(List<NewGoal> goals) async {
    await _db.transaction(() async {
      final maxOrder = _db.goals.sortOrder.max();
      final current = await (_db.selectOnly(_db.goals)..addColumns([maxOrder]))
          .map((row) => row.read(maxOrder))
          .getSingle();
      var order = (current ?? -1) + 1;
      final now = _clock.now();
      for (final g in goals) {
        await _db.into(_db.goals).insert(GoalsCompanion.insert(
              title: g.title,
              icon: g.icon,
              area: g.area,
              section: g.section.id,
              essential: Value(g.essential),
              sortOrder: order++,
              libraryId: Value(g.libraryId),
              createdAt: now,
            ));
      }
    });
  }

  SimpleSelectStatement<$GoalsTable, Goal> get _active => _db.select(_db.goals)
    ..where((g) => g.archivedAt.isNull())
    ..orderBy([(g) => OrderingTerm.asc(g.sortOrder)]);

  Future<List<Goal>> active() => _active.get();

  Stream<List<Goal>> watchActive() => _active.watch();
}
```

`lib/data/repositories/onboarding_repository.dart`:

```dart
import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../../domain/onboarding/answers.dart';
import '../db/database.dart';

/// Onboarding answers, saved one by one so the quiz can resume.
class OnboardingRepository {
  OnboardingRepository(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  Future<Answers> answers() async {
    final rows = await _db.select(_db.onboardingAnswers).get();
    return {for (final r in rows) r.questionId: _decode(r.value)};
  }

  /// [value] is a `String` or a `List<String>`.
  Future<void> saveAnswer(String questionId, Object value) async {
    assert(value is String || value is List<String>, 'answers are strings or string lists');
    await _db.into(_db.onboardingAnswers).insertOnConflictUpdate(OnboardingAnswersCompanion.insert(
          questionId: questionId,
          value: jsonEncode(value),
          answeredAt: _clock.now(),
        ));
  }

  Future<void> removeAnswers(Iterable<String> questionIds) async {
    final ids = questionIds.toList();
    if (ids.isEmpty) return;
    await (_db.delete(_db.onboardingAnswers)..where((a) => a.questionId.isIn(ids))).go();
  }

  static Object _decode(String json) {
    final value = jsonDecode(json);
    return value is List ? [for (final e in value) e as String] : value as String;
  }
}
```

In `lib/app/providers.dart`, add these imports and providers:

```dart
import '../data/repositories/goal_repository.dart';
import '../data/repositories/onboarding_repository.dart';

final goalRepositoryProvider = Provider<GoalRepository>(
  (ref) => GoalRepository(ref.watch(databaseProvider), ref.watch(clockProvider)),
);

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => OnboardingRepository(ref.watch(databaseProvider), ref.watch(clockProvider)),
);
```

- [ ] **Step 6: Run the tests to see them pass**

Run: `flutter test test/data` → Expected: `All tests passed!`

- [ ] **Step 7: Commit**

```
git add -A
git commit -m "feat(data): add goals and onboarding answers tables (schema v2)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 2: Onboarding script model

**Files:**
- Create: `lib/content/onboarding_script.dart`
- Test: `test/content/onboarding_script_test.dart`

**Interfaces:**
- Consumes: `JsonReader` (Plan 1); `Answers` (Task 1); `Trait`, `Pronouns`, `PetPose` (Plan 1)
- Produces:
  - `enum StepType { egg, hatch, text, single, multi, time, talk, talkChoice, permission }` with `id`, `hasOptions`, `tryParse`
  - `enum SaveTo { petEggColor, petName, petPronouns, petTrait, userName, wakeTime, bedTime }` with `id`, `tryParse`
  - `enum ConditionOp { equals, includes, includesAny }`
  - `Condition({question, op, values, negate})` with `matches(Answers)` and `Condition.fromJson`
  - `StepOption({id, label, icon, trait, nudge = 1})`
  - `OnboardingStep`:
    - fields: `id`, `type`, `prompt`, `petPose`, `section`, `options`, `showIf`, `minSelect`, `skippable`, `saveTo`, `placeholder`, `suggestions`, `defaultValue`, `preview`, `button`
    - `option(String id) → StepOption?`
  - `Section({id, label})`
  - `PlanRule({when, add, reason})`
  - `OnboardingScript`:
    - fields: `sections`, `steps`, `foundationGoals`, `foundationReason`, `focusQuestion`, `planRules`
    - `step(String id)`, `indexOf(String id)`, `texts` (list of `(String where, String text)`), `fileName`
    - `factory OnboardingScript.fromJson(JsonReader)`

- [ ] **Step 1: Write the failing test**

`test/content/onboarding_script_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/content/onboarding_script.dart';
import 'package:zulu/domain/pet/trait.dart';

Matcher failsAt(String path) =>
    throwsA(isA<ContentFormatException>().having((e) => e.path, 'path', path));

const _sections = '"sections":[{"id":"x","label":"X"}]';
const _tail = '"foundationGoals":["g"],"foundationReason":"why","focusQuestion":"areas","planRules":[]';
const _areas = '{"id":"areas","type":"multi","prompt":"Help?","section":"x",'
    '"options":[{"id":"a","label":"A"},{"id":"b","label":"B"}]}';

OnboardingScript parse(String steps, {String tail = _tail}) =>
    OnboardingScript.fromJson(JsonReader.decode('o.json', '{$_sections,"steps":[$steps],$tail}'));

void main() {
  test('parses steps, options, conditions and rules', () {
    final script = parse(
      '{"id":"hi","type":"talk","prompt":"Hello {userName}","button":"Okay"},'
      '{"id":"mood","type":"talk_choice","prompt":"Pick","options":[{"id":"p","label":"P","trait":"calm","nudge":2},{"id":"q","label":"Q"}]},'
      '$_areas,'
      '{"id":"follow","type":"single","prompt":"More?","section":"x","showIf":{"question":"areas","includes":"a"},'
      '"options":[{"id":"y","label":"Y"},{"id":"n","label":"N"}]}',
      tail: '"foundationGoals":["g"],"foundationReason":"why","focusQuestion":"areas",'
          '"planRules":[{"when":{"question":"follow","equals":"y"},"add":["g2"],"reason":"you said yes"}]',
    );
    expect(script.steps.map((s) => s.id), ['hi', 'mood', 'areas', 'follow']);
    expect(script.step('hi')!.button, 'Okay');
    expect(script.step('mood')!.type, StepType.talkChoice);
    expect(script.step('mood')!.option('p')!.trait, Trait.calm);
    expect(script.step('mood')!.option('p')!.nudge, 2);
    expect(script.step('mood')!.option('q')!.nudge, 1);
    expect(script.step('follow')!.showIf!.matches({'areas': ['a']}), isTrue);
    expect(script.planRules.single.add, ['g2']);
    expect(script.indexOf('areas'), 2);
    expect(script.texts.map((t) => t.$2), containsAll(['Hello {userName}', 'you said yes', 'why', 'A']));
  });

  test('conditions: equals, includes, includesAny, not, and missing answers', () {
    const eq = Condition(question: 'q', op: ConditionOp.equals, values: ['hard']);
    const inc = Condition(question: 'm', op: ConditionOp.includes, values: ['a']);
    const any = Condition(question: 'm', op: ConditionOp.includesAny, values: ['x', 'b']);
    const not = Condition(question: 'q', op: ConditionOp.equals, values: ['hard'], negate: true);
    final answers = {'q': 'hard', 'm': ['a', 'b']};
    expect(eq.matches(answers), isTrue);
    expect(eq.matches({'q': 'easy'}), isFalse);
    expect(inc.matches(answers), isTrue);
    expect(inc.matches({'m': ['b']}), isFalse);
    expect(any.matches(answers), isTrue);
    expect(any.matches({'m': ['c']}), isFalse);
    expect(not.matches(answers), isFalse);
    expect(eq.matches({}), isFalse);
    expect(not.matches({}), isTrue);
  });

  test('rejects a showIf that points at a later step', () {
    expect(
      () => parse('{"id":"follow","type":"talk","prompt":"?","showIf":{"question":"areas","includes":"a"}},$_areas'),
      failsAt(r'$.steps[0].showIf.question'),
    );
  });

  test('rejects a condition value that is not an option', () {
    expect(
      () => parse('$_areas,{"id":"f","type":"talk","prompt":"?","showIf":{"question":"areas","includes":"zzz"}}'),
      failsAt(r'$.steps[1].showIf'),
    );
  });

  test('rejects pronoun options other than she, he and they', () {
    expect(
      () => parse('{"id":"p","type":"single","prompt":"?","saveTo":"pet.pronouns",'
          '"options":[{"id":"she","label":"She"},{"id":"xe","label":"Xe"}]},$_areas'),
      failsAt(r'$.steps[0].options'),
    );
  });

  test('rejects a saveTo on the wrong step type', () {
    expect(
      () => parse('{"id":"n","type":"talk","prompt":"?","saveTo":"pet.name"},$_areas'),
      failsAt(r'$.steps[0].saveTo'),
    );
  });

  test('rejects a choice step with fewer than two options', () {
    expect(
      () => parse('{"id":"s","type":"single","prompt":"?","options":[{"id":"a","label":"A"}]},$_areas'),
      failsAt(r'$.steps[0].type'),
    );
  });

  test('rejects a malformed time default', () {
    expect(
      () => parse('{"id":"t","type":"time","prompt":"?","default":"7:30"},$_areas'),
      failsAt(r'$.steps[0].default'),
    );
  });

  test('rejects a focus question that is not a multi step', () {
    expect(
      () => parse('{"id":"areas","type":"talk","prompt":"?"}'),
      failsAt(r'$.focusQuestion'),
    );
  });
}
```

- [ ] **Step 2: Run it to see it fail**

Run: `flutter test test/content/onboarding_script_test.dart`
Expected: FAIL. `onboarding_script.dart` doesn't exist.

- [ ] **Step 3: Implement `lib/content/onboarding_script.dart`**

```dart
import '../domain/onboarding/answers.dart';
import '../domain/pet/trait.dart';
import '../domain/text/template.dart';
import '../theme_kit/pet_manifest.dart';
import 'json_reader.dart';

enum StepType {
  egg('egg'),
  hatch('hatch'),
  text('text'),
  single('single'),
  multi('multi'),
  time('time'),
  talk('talk'),
  talkChoice('talk_choice'),
  permission('permission');

  const StepType(this.id);

  final String id;

  bool get hasOptions => this == single || this == multi || this == talkChoice;

  static StepType? tryParse(String id) {
    for (final t in values) {
      if (t.id == id) return t;
    }
    return null;
  }
}

/// Where a step's answer goes when onboarding finishes. Other answers stay
/// only in the answers table.
enum SaveTo {
  petEggColor('pet.eggColor'),
  petName('pet.name'),
  petPronouns('pet.pronouns'),
  petTrait('pet.trait'),
  userName('profile.userName'),
  wakeTime('profile.wakeTime'),
  bedTime('profile.bedTime');

  const SaveTo(this.id);

  final String id;

  static SaveTo? tryParse(String id) {
    for (final s in values) {
      if (s.id == id) return s;
    }
    return null;
  }
}

enum ConditionOp { equals, includes, includesAny }

/// A test on an earlier answer, used by `showIf` and plan rules. A missing
/// answer never matches (so `not` of a missing answer does).
class Condition {
  const Condition({required this.question, required this.op, required this.values, this.negate = false});

  final String question;
  final ConditionOp op;
  final List<String> values;
  final bool negate;

  bool matches(Answers answers) {
    final v = answers[question];
    final hit = switch (op) {
      ConditionOp.equals => v is String && v == values.first,
      ConditionOp.includes => v is List<String> && v.contains(values.first),
      ConditionOp.includesAny => v is List<String> && values.any(v.contains),
    };
    return hit != negate;
  }

  factory Condition.fromJson(JsonReader r) {
    final question = r.string('question');
    final negate = r.boolean('not', orElse: false);
    if (r.has('equals')) {
      return Condition(question: question, op: ConditionOp.equals, values: [r.string('equals')], negate: negate);
    }
    if (r.has('includes')) {
      return Condition(question: question, op: ConditionOp.includes, values: [r.string('includes')], negate: negate);
    }
    if (r.has('includesAny')) {
      final values = r.strings('includesAny');
      if (values.isEmpty) r.field('includesAny').fail('needs at least one value');
      return Condition(question: question, op: ConditionOp.includesAny, values: values, negate: negate);
    }
    r.fail('needs one of equals, includes or includesAny');
  }
}

class StepOption {
  const StepOption({required this.id, required this.label, this.icon, this.trait, this.nudge = 1});

  final String id;
  final String label;

  /// An emoji.
  final String? icon;

  /// For talk-choice replies: the trait this reply nudges, by [nudge].
  final Trait? trait;
  final double nudge;
}

class OnboardingStep {
  const OnboardingStep({
    required this.id,
    required this.type,
    required this.prompt,
    this.petPose = PetPose.curious,
    this.section,
    this.options = const [],
    this.showIf,
    this.minSelect = 1,
    this.skippable = false,
    this.saveTo,
    this.placeholder,
    this.suggestions = const [],
    this.defaultValue,
    this.preview,
    this.button,
  });

  final String id;
  final StepType type;

  /// Said by the pet. May use template placeholders.
  final String prompt;
  final PetPose petPose;

  /// Quiz section id; steps with a section show the progress bar.
  final String? section;
  final List<StepOption> options;
  final Condition? showIf;
  final int minSelect;
  final bool skippable;
  final SaveTo? saveTo;
  final String? placeholder;

  /// Names offered by the shuffle button on text steps.
  final List<String> suggestions;

  /// Starting value for time steps (`HH:mm`).
  final String? defaultValue;

  /// Example notification shown on the permission step.
  final String? preview;

  /// Label of the main button, where the step has one.
  final String? button;

  StepOption? option(String id) {
    for (final o in options) {
      if (o.id == id) return o;
    }
    return null;
  }
}

class Section {
  const Section({required this.id, required this.label});

  final String id;
  final String label;
}

/// "If the answers match [when], add [add] to the plan, explaining [reason]."
class PlanRule {
  const PlanRule({required this.when, required this.add, required this.reason});

  final Condition when;
  final List<String> add;
  final String reason;
}

/// The whole onboarding flow (`assets/content/onboarding.json`).
class OnboardingScript {
  OnboardingScript({
    required this.sections,
    required this.steps,
    required this.foundationGoals,
    required this.foundationReason,
    required this.focusQuestion,
    required this.planRules,
  }) : _byId = {for (final s in steps) s.id: s};

  static const fileName = 'assets/content/onboarding.json';

  final List<Section> sections;
  final List<OnboardingStep> steps;

  /// Goal ids every plan starts with.
  final List<String> foundationGoals;
  final String foundationReason;

  /// The multi step whose answers are focus-area ids.
  final String focusQuestion;
  final List<PlanRule> planRules;
  final Map<String, OnboardingStep> _byId;

  OnboardingStep? step(String id) => _byId[id];

  int indexOf(String id) => steps.indexWhere((s) => s.id == id);

  /// Every string shown to the user, with where it lives, for checks.
  List<(String, String)> get texts => [
        for (final s in steps) ...[
          ('step "${s.id}" prompt', s.prompt),
          for (final o in s.options) ('step "${s.id}" option "${o.id}"', o.label),
          if (s.preview != null) ('step "${s.id}" preview', s.preview!),
          if (s.placeholder != null) ('step "${s.id}" placeholder', s.placeholder!),
          if (s.button != null) ('step "${s.id}" button', s.button!),
        ],
        ('foundationReason', foundationReason),
        for (final (i, r) in planRules.indexed) ('planRules[$i] reason', r.reason),
      ];

  factory OnboardingScript.fromJson(JsonReader r) {
    final sections = [for (final s in r.list('sections')) Section(id: s.string('id'), label: s.string('label'))];
    final sectionIds = {for (final s in sections) s.id};
    final steps = <OnboardingStep>[];
    final byId = <String, OnboardingStep>{};

    for (final s in r.list('steps')) {
      final id = s.string('id');
      if (byId.containsKey(id)) s.field('id').fail('duplicate step id "$id"');
      final type = StepType.tryParse(s.string('type')) ?? s.field('type').fail('unknown step type');
      final section = s.optString('section');
      if (section != null && !sectionIds.contains(section)) s.field('section').fail('unknown section "$section"');

      final options = <StepOption>[];
      final optionIds = <String>{};
      for (final o in s.optional('options')?.asList() ?? const <JsonReader>[]) {
        final optionId = o.string('id');
        if (!optionIds.add(optionId)) o.field('id').fail('duplicate option id "$optionId"');
        final traitName = o.optString('trait');
        final trait = traitName == null
            ? null
            : (Trait.values.asNameMap()[traitName] ?? o.field('trait').fail('unknown trait "$traitName"'));
        options.add(StepOption(
          id: optionId,
          label: o.string('label'),
          icon: o.optString('icon'),
          trait: trait,
          nudge: o.optNumber('nudge') ?? 1,
        ));
      }
      if (type.hasOptions && options.length < 2) s.field('type').fail('${type.id} steps need at least 2 options');

      final showIfJson = s.optional('showIf');
      final showIf = showIfJson == null ? null : _condition(showIfJson, byId);

      final saveToId = s.optString('saveTo');
      final saveTo = saveToId == null ? null : (SaveTo.tryParse(saveToId) ?? s.field('saveTo').fail('unknown target "$saveToId"'));
      if (saveTo != null) _checkSaveTo(s, saveTo, type, optionIds);

      final defaultValue = s.optString('default');
      if (type == StepType.time && defaultValue != null && !_timePattern.hasMatch(defaultValue)) {
        s.field('default').fail('expected HH:mm');
      }

      final poseName = s.optString('petPose');
      final pose = poseName == null
          ? PetPose.curious
          : (PetPose.values.asNameMap()[poseName] ?? s.field('petPose').fail('unknown pose "$poseName"'));

      final step = OnboardingStep(
        id: id,
        type: type,
        prompt: s.string('prompt'),
        petPose: pose,
        section: section,
        options: options,
        showIf: showIf,
        minSelect: s.optInt('minSelect') ?? 1,
        skippable: s.boolean('skippable', orElse: false),
        saveTo: saveTo,
        placeholder: s.optString('placeholder'),
        suggestions: s.optStrings('suggestions'),
        defaultValue: defaultValue,
        preview: s.optString('preview'),
        button: s.optString('button'),
      );
      steps.add(step);
      byId[id] = step;
    }

    final focus = r.string('focusQuestion');
    if (byId[focus]?.type != StepType.multi) r.field('focusQuestion').fail('must name a multi step');

    final rules = [
      for (final p in r.list('planRules'))
        PlanRule(when: _condition(p.field('when'), byId), add: p.strings('add'), reason: p.string('reason')),
    ];

    return OnboardingScript(
      sections: sections,
      steps: steps,
      foundationGoals: r.strings('foundationGoals'),
      foundationReason: r.string('foundationReason'),
      focusQuestion: focus,
      planRules: rules,
    );
  }
}

final _timePattern = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

/// Parses a condition whose question must be one of [known] (the steps
/// read so far), with values that are options of that step.
Condition _condition(JsonReader r, Map<String, OnboardingStep> known) {
  final c = Condition.fromJson(r);
  final target = known[c.question] ?? r.field('question').fail('must name an earlier step, got "${c.question}"');
  if (target.options.isNotEmpty) {
    for (final v in c.values) {
      if (target.option(v) == null) r.fail('"$v" is not an option of "${c.question}"');
    }
  }
  if (c.op != ConditionOp.equals && target.type != StepType.multi) {
    r.fail('includes and includesAny need a multi step');
  }
  if (c.op == ConditionOp.equals && target.type == StepType.multi) {
    r.fail('equals needs a single-answer step');
  }
  return c;
}

void _checkSaveTo(JsonReader s, SaveTo saveTo, StepType type, Set<String> optionIds) {
  final expected = switch (saveTo) {
    SaveTo.petEggColor => StepType.egg,
    SaveTo.petName || SaveTo.userName => StepType.text,
    SaveTo.petPronouns || SaveTo.petTrait => StepType.single,
    SaveTo.wakeTime || SaveTo.bedTime => StepType.time,
  };
  if (type != expected) s.field('saveTo').fail('${saveTo.id} needs a ${expected.id} step');
  final allowed = switch (saveTo) {
    SaveTo.petPronouns => {for (final p in Pronouns.values) p.name},
    SaveTo.petTrait => {for (final t in Trait.values) t.name},
    _ => null,
  };
  if (allowed != null && !optionIds.every(allowed.contains)) {
    s.field('options').fail('options must be ${allowed.join(', ')}');
  }
}
```

- [ ] **Step 4: Run it to see it pass**

Run: `flutter test test/content/onboarding_script_test.dart` → Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```
git add -A
git commit -m "feat(content): add data-driven onboarding script with checked conditions

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 3: Onboarding content and cross-checks

**Files:**
- Create: `assets/content/onboarding.json`
- Modify: `lib/content/content_bundle.dart`, `lib/content/asset_validator.dart`
- Test: `test/content/onboarding_content_test.dart`; modify `test/content/asset_validator_test.dart`

**Interfaces:**
- Consumes: `OnboardingScript` (Task 2); `GoalLibrary`, `AssetValidator`, `unknownPlaceholders` (Plan 1)
- Produces:
  - `ContentBundle({rules, goals, onboarding})`, which adds `OnboardingScript onboarding`
  - validator errors for:
    - unknown plan or foundation goals
    - fewer than 2 essential foundation goals
    - focus options that don't match the library's areas
    - unknown placeholders in onboarding text

- [ ] **Step 1: Write the content `assets/content/onboarding.json`**

```json
{
  "sections": [
    { "id": "about_you", "label": "About you" },
    { "id": "energy", "label": "Energy" },
    { "id": "life", "label": "How's life" },
    { "id": "support", "label": "Support" }
  ],
  "foundationGoals": ["get_out_of_bed", "drink_water"],
  "foundationReason": "a gentle start for any day",
  "focusQuestion": "focus_areas",
  "steps": [
    { "id": "welcome", "type": "talk", "petPose": "hatch", "prompt": "Hi there! Someone small is waiting to meet you.", "button": "Hatch a new pet" },
    { "id": "egg", "type": "egg", "prompt": "Pick an egg. Whoever's inside will be your companion.", "saveTo": "pet.eggColor", "button": "Hatch this egg" },
    { "id": "hatch", "type": "hatch", "petPose": "hatch", "prompt": "It's hatching!", "button": "Say hello" },
    { "id": "pet_name", "type": "text", "petPose": "happy", "prompt": "Hello! I'm brand new. What would you like to call me?", "placeholder": "Pet name", "saveTo": "pet.name",
      "suggestions": ["Pip", "Mochi", "Bean", "Sunny", "Juniper", "Biscuit", "Pebble", "Clover"] },
    { "id": "pet_pronouns", "type": "single", "prompt": "Which words should we use for {petName}?", "saveTo": "pet.pronouns",
      "options": [ { "id": "she", "label": "She / her" }, { "id": "he", "label": "He / him" }, { "id": "they", "label": "They / them" } ] },
    { "id": "pet_trait", "type": "single", "prompt": "What does {petName} care about most?", "saveTo": "pet.trait",
      "options": [
        { "id": "curiosity", "label": "Curiosity", "icon": "🔎" },
        { "id": "resilience", "label": "Resilience", "icon": "🌱" },
        { "id": "compassion", "label": "Compassion", "icon": "💗" },
        { "id": "logic", "label": "Logic", "icon": "🧩" },
        { "id": "confidence", "label": "Confidence", "icon": "⭐" },
        { "id": "calm", "label": "Calm", "icon": "🌊" }
      ] },
    { "id": "user_name", "type": "text", "petPose": "happy", "prompt": "Thanks for hatching me! What should I call you?", "placeholder": "Your name", "skippable": true, "saveTo": "profile.userName" },
    { "id": "self_care", "type": "talk_choice", "prompt": "Nice to meet you, {userName}! I'm a self-care pet. What does self-care mean to you?",
      "options": [
        { "id": "body_mind", "label": "Looking after my body, mind and people", "trait": "compassion" },
        { "id": "hard_days", "label": "Doing what I can, even on hard days", "trait": "resilience" }
      ] },
    { "id": "together", "type": "talk", "petPose": "celebrate", "prompt": "Then let's look after each other. When you care for yourself, you care for me too.", "button": "Let's do it" },
    { "id": "reminders", "type": "permission", "prompt": "Can I send you a little nudge now and then? Never more than a few a day.", "preview": "{petName}: Sip of water? I'll have one too." },
    { "id": "learn", "type": "talk", "petPose": "happy", "prompt": "Let's get to know each other, so I can suggest goals that fit your life.", "button": "Okay" },

    { "id": "wake_time", "type": "time", "section": "about_you", "prompt": "When do you usually wake up?", "default": "07:30", "saveTo": "profile.wakeTime" },
    { "id": "bed_time", "type": "time", "section": "about_you", "prompt": "And when do you usually go to bed?", "default": "23:00", "saveTo": "profile.bedTime" },
    { "id": "tried_apps", "type": "single", "section": "about_you", "prompt": "Have you tried a habit or self-care app before?",
      "options": [ { "id": "never", "label": "Never" }, { "id": "didnt_stick", "label": "Tried one, it didn't stick" }, { "id": "use_now", "label": "I use one now" } ] },

    { "id": "sleep_hours", "type": "single", "section": "energy", "prompt": "How much sleep do you usually get?",
      "options": [
        { "id": "under_5", "label": "Under 5 hours", "icon": "😴" },
        { "id": "five_seven", "label": "5–7 hours", "icon": "🛏️" },
        { "id": "seven_nine", "label": "7–9 hours", "icon": "🌙" },
        { "id": "nine_plus", "label": "More than 9 hours", "icon": "☀️" }
      ] },
    { "id": "get_up", "type": "single", "section": "energy", "prompt": "How easy is it to get up in the morning?",
      "options": [ { "id": "easy", "label": "Pretty easy", "icon": "🐬" }, { "id": "depends", "label": "Depends on the day", "icon": "🌤️" }, { "id": "hard", "label": "Hard most days", "icon": "🧸" } ] },
    { "id": "movement", "type": "single", "section": "energy", "prompt": "How much do you move in a normal day?",
      "options": [
        { "id": "a_lot", "label": "A lot", "icon": "🏃" },
        { "id": "some", "label": "Some", "icon": "🚶" },
        { "id": "want_more", "label": "Not much, and I'd like more", "icon": "🪑" },
        { "id": "limited", "label": "My body limits how much I move", "icon": "🌻" }
      ] },

    { "id": "overwhelm", "type": "single", "section": "life", "prompt": "How often does life feel like too much?",
      "options": [ { "id": "most_days", "label": "Most days", "icon": "😣" }, { "id": "some_days", "label": "Some days", "icon": "😕" }, { "id": "rarely", "label": "Rarely", "icon": "😌" } ] },
    { "id": "lean_on", "type": "single", "section": "life", "prompt": "Who can you lean on when things are hard?",
      "options": [
        { "id": "few", "label": "A few people", "icon": "🌳" },
        { "id": "one", "label": "One person", "icon": "🌿" },
        { "id": "just_me", "label": "Mostly just me", "icon": "🍃" },
        { "id": "prefer_not", "label": "Prefer not to say" }
      ] },
    { "id": "routine_feel", "type": "single", "section": "life", "prompt": "How do you feel about your routine right now?",
      "options": [ { "id": "good", "label": "Pretty good", "icon": "🙂" }, { "id": "small", "label": "I'd like small changes", "icon": "🌱" }, { "id": "big", "label": "I'd like a big change", "icon": "🚀" } ] },

    { "id": "hard_lately", "type": "multi", "section": "support", "prompt": "What's been hard lately? Pick any.",
      "options": [
        { "id": "focus", "label": "Staying focused" },
        { "id": "low_energy", "label": "Low energy" },
        { "id": "feeling_down", "label": "Feeling down" },
        { "id": "stress", "label": "Stress or worry" },
        { "id": "sleep", "label": "Sleep" },
        { "id": "lonely", "label": "Feeling lonely" },
        { "id": "basics", "label": "Keeping up with basics" },
        { "id": "kindness", "label": "Being kind to myself" },
        { "id": "nothing", "label": "Nothing in particular" },
        { "id": "prefer_not", "label": "Prefer not to say" }
      ] },
    { "id": "focus_areas", "type": "multi", "section": "support", "prompt": "What would you like help with?",
      "options": [
        { "id": "calmer_mind", "label": "A calmer mind", "icon": "🌿" },
        { "id": "rest_sleep", "label": "Rest and sleep", "icon": "🌙" },
        { "id": "move_more", "label": "Move more", "icon": "💫" },
        { "id": "eat_well", "label": "Eat well", "icon": "🥣" },
        { "id": "feel_fresh", "label": "Feel fresh", "icon": "🫧" },
        { "id": "focus", "label": "Focus and get things done", "icon": "🎯" },
        { "id": "kinder_to_myself", "label": "Be kinder to myself", "icon": "💛" },
        { "id": "notice_good", "label": "Notice the good", "icon": "🌸" },
        { "id": "connect", "label": "Connect with people", "icon": "💬" },
        { "id": "steady_routine", "label": "A steady routine", "icon": "🌤️" }
      ] },

    { "id": "calm_pileup", "type": "multi", "section": "support", "prompt": "What tends to pile up on you?", "showIf": { "question": "focus_areas", "includes": "calmer_mind" },
      "options": [
        { "id": "work_school", "label": "Work or school" }, { "id": "relationships", "label": "Relationships" }, { "id": "money", "label": "Money" },
        { "id": "health", "label": "Health" }, { "id": "too_much", "label": "Too much on my plate" }, { "id": "changes", "label": "Big changes" }, { "id": "not_sure", "label": "Not sure" }
      ] },
    { "id": "rest_blocker", "type": "multi", "section": "support", "prompt": "What gets in the way of rest?", "showIf": { "question": "focus_areas", "includes": "rest_sleep" },
      "options": [
        { "id": "screens", "label": "Screens" }, { "id": "racing_thoughts", "label": "Racing thoughts" }, { "id": "schedule", "label": "A changing schedule" },
        { "id": "noise", "label": "Noise or my surroundings" }, { "id": "not_sure", "label": "Not sure" }
      ] },
    { "id": "move_blocker", "type": "multi", "section": "support", "prompt": "What makes moving hard?", "showIf": { "question": "focus_areas", "includes": "move_more" },
      "options": [
        { "id": "no_time", "label": "No time" }, { "id": "low_energy", "label": "Low energy" }, { "id": "dont_enjoy", "label": "I don't enjoy it" },
        { "id": "pain", "label": "Pain or physical limits" }, { "id": "dont_know", "label": "I don't know where to start" }, { "id": "weather", "label": "The weather" }
      ] },
    { "id": "food_help", "type": "multi", "section": "support", "prompt": "What would help most with food?", "showIf": { "question": "focus_areas", "includes": "eat_well" },
      "options": [
        { "id": "regular_meals", "label": "Regular meals" }, { "id": "water", "label": "More water" }, { "id": "fruit_veg", "label": "More fruit and veg" },
        { "id": "cooking", "label": "Cooking more" }, { "id": "on_the_go", "label": "Fewer meals on the go" }
      ] },
    { "id": "fresh_keep", "type": "multi", "section": "support", "prompt": "Which would feel good to keep up?", "showIf": { "question": "focus_areas", "includes": "feel_fresh" },
      "options": [
        { "id": "teeth", "label": "Teeth" }, { "id": "showers", "label": "Showers" }, { "id": "skincare", "label": "Skincare" },
        { "id": "clothes", "label": "Clean clothes" }, { "id": "tidy", "label": "A tidy space" }
      ] },
    { "id": "focus_blocker", "type": "multi", "section": "support", "prompt": "What pulls your focus away?", "showIf": { "question": "focus_areas", "includes": "focus" },
      "options": [
        { "id": "phone", "label": "My phone" }, { "id": "too_many", "label": "Too many tasks" }, { "id": "hard_to_start", "label": "Starting is hard" },
        { "id": "tired", "label": "Tiredness" }, { "id": "noise", "label": "Noise" }
      ] },
    { "id": "kind_when", "type": "single", "section": "support", "prompt": "When something goes wrong, you usually…", "showIf": { "question": "focus_areas", "includes": "kinder_to_myself" },
      "options": [ { "id": "hard_on_myself", "label": "Am hard on myself" }, { "id": "shrug", "label": "Shrug it off" }, { "id": "depends", "label": "It depends" } ] },
    { "id": "good_when", "type": "single", "section": "support", "prompt": "When could you pause for a good moment?", "showIf": { "question": "focus_areas", "includes": "notice_good" },
      "options": [ { "id": "morning", "label": "Morning" }, { "id": "midday", "label": "Midday" }, { "id": "evening", "label": "Evening" }, { "id": "whenever", "label": "Whenever" } ] },
    { "id": "connect_doable", "type": "multi", "section": "support", "prompt": "What sounds doable this week?", "showIf": { "question": "focus_areas", "includes": "connect" },
      "options": [
        { "id": "message_friend", "label": "Message a friend" }, { "id": "call_family", "label": "Call family" }, { "id": "see_someone", "label": "See someone" },
        { "id": "join", "label": "Join something" }, { "id": "not_yet", "label": "Not yet" }
      ] },
    { "id": "routine_part", "type": "single", "section": "support", "prompt": "Which part of the day needs the most help?", "showIf": { "question": "focus_areas", "includes": "steady_routine" },
      "options": [ { "id": "morning", "label": "Morning" }, { "id": "afternoon", "label": "Afternoon" }, { "id": "evening", "label": "Evening" }, { "id": "bedtime", "label": "Bedtime" } ] }
  ],
  "planRules": [
    { "when": { "question": "hard_lately", "includes": "basics" }, "add": ["brush_teeth_am"], "reason": "you said the basics have been tough" },
    { "when": { "question": "hard_lately", "includes": "stress" }, "add": ["three_breaths"], "reason": "you mentioned stress and worry" },
    { "when": { "question": "hard_lately", "includes": "feeling_down" }, "add": ["kind_word"], "reason": "you've been feeling down" },
    { "when": { "question": "hard_lately", "includes": "lonely" }, "add": ["message_friend"], "reason": "you said you've felt lonely" },
    { "when": { "question": "hard_lately", "includes": "focus" }, "add": ["one_small_task"], "reason": "you said focus has been hard" },
    { "when": { "question": "hard_lately", "includes": "sleep" }, "add": ["wind_down_10"], "reason": "you said sleep has been hard" },
    { "when": { "question": "get_up", "equals": "hard" }, "add": ["daylight"], "reason": "you said mornings can be hard" },
    { "when": { "question": "sleep_hours", "equals": "under_5" }, "add": ["wind_down_10"], "reason": "you told me sleep's been short" },
    { "when": { "question": "movement", "equals": "limited" }, "add": ["move_your_way"], "reason": "moving should fit your body" },
    { "when": { "question": "movement", "equals": "want_more" }, "add": ["short_walk"], "reason": "you'd like to move more" },
    { "when": { "question": "overwhelm", "equals": "most_days" }, "add": ["quiet_minute"], "reason": "you said life often feels like too much" },
    { "when": { "question": "lean_on", "equals": "just_me" }, "add": ["say_hi"], "reason": "a little connection can go a long way" },
    { "when": { "question": "calm_pileup", "includes": "too_much" }, "add": ["top_three"], "reason": "you said there's a lot on your plate" },
    { "when": { "question": "rest_blocker", "includes": "screens" }, "add": ["phone_away_bed"], "reason": "you said screens get in the way of rest" },
    { "when": { "question": "rest_blocker", "includes": "racing_thoughts" }, "add": ["worry_note"], "reason": "you said racing thoughts keep you up" },
    { "when": { "question": "move_blocker", "includes": "no_time" }, "add": ["stretch_2min"], "reason": "you said time is tight" },
    { "when": { "question": "move_blocker", "includes": "pain" }, "add": ["move_your_way"], "reason": "you mentioned pain or physical limits" },
    { "when": { "question": "move_blocker", "includes": "low_energy" }, "add": ["one_song_move"], "reason": "you said energy is low" },
    { "when": { "question": "food_help", "includes": "regular_meals" }, "add": ["pause_for_meal"], "reason": "you'd like more regular meals" },
    { "when": { "question": "food_help", "includes": "fruit_veg" }, "add": ["fruit_or_veg"], "reason": "you'd like more fruit and veg" },
    { "when": { "question": "fresh_keep", "includes": "showers" }, "add": ["shower"], "reason": "you want to keep up with showers" },
    { "when": { "question": "fresh_keep", "includes": "skincare" }, "add": ["wash_face"], "reason": "you want to keep up with skincare" },
    { "when": { "question": "focus_blocker", "includes": "phone" }, "add": ["phone_away_focus"], "reason": "you said your phone pulls you away" },
    { "when": { "question": "focus_blocker", "includes": "hard_to_start" }, "add": ["start_messy"], "reason": "you said starting is the hard part" },
    { "when": { "question": "kind_when", "equals": "hard_on_myself" }, "add": ["let_it_go"], "reason": "you said you can be hard on yourself" },
    { "when": { "question": "good_when", "equals": "evening" }, "add": ["one_good_thing"], "reason": "evenings suit you for a good moment" },
    { "when": { "question": "connect_doable", "includes": "call_family" }, "add": ["call_someone"], "reason": "you'd like to call family" },
    { "when": { "question": "routine_part", "equals": "bedtime" }, "add": ["ready_for_tomorrow"], "reason": "you said bedtime needs the most help" }
  ]
}
```

- [ ] **Step 2: Write the failing tests**

`test/content/onboarding_content_test.dart`:

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/content/onboarding_script.dart';

import '../helpers/read_file.dart';

void main() {
  late ContentBundle content;

  setUpAll(() async => content = await loadContent(readFile));

  test('the flow starts with the welcome, the egg and hatching', () {
    expect(content.onboarding.steps.take(3).map((s) => s.type), [StepType.talk, StepType.egg, StepType.hatch]);
  });

  test('has the four quiz sections', () {
    expect(content.onboarding.sections.map((s) => s.label), ['About you', 'Energy', "How's life", 'Support']);
  });

  test('every focus area has exactly one follow-up question', () {
    final script = content.onboarding;
    for (final area in content.goals.areas) {
      final followUps = script.steps.where((s) => s.showIf?.question == script.focusQuestion && s.showIf!.values.contains(area.id));
      expect(followUps, hasLength(1), reason: area.id);
    }
  });

  test('every saveTo target is filled by exactly one step', () {
    for (final target in SaveTo.values) {
      expect(content.onboarding.steps.where((s) => s.saveTo == target), hasLength(1), reason: target.id);
    }
  });

  test('asks no diagnosis, gender or age questions', () {
    final banned = RegExp(r'gender|how old|\bage\b|diagnos|ptsd|bipolar|ocd|adhd|depression', caseSensitive: false);
    for (final (where, text) in content.onboarding.texts) {
      expect(banned.hasMatch(text), isFalse, reason: where);
    }
    expect(File('assets/content/onboarding.json').readAsStringSync().contains('streak'), isFalse);
  });
}
```

In `test/content/asset_validator_test.dart`, add these imports:

```dart
import 'dart:convert';

import 'package:zulu/content/json_reader.dart';
import 'package:zulu/content/onboarding_script.dart';
```

and add this test inside `main()`:

```dart
  test('flags a plan rule that names an unknown goal', () {
    final json = jsonDecode(File(OnboardingScript.fileName).readAsStringSync()) as Map<String, Object?>;
    (json['planRules']! as List<Object?>).add({
      'when': {'question': 'get_up', 'equals': 'hard'},
      'add': ['fly_to_the_moon'],
      'reason': 'why not',
    });
    final broken = ContentBundle(
      rules: content.rules,
      goals: content.goals,
      onboarding: OnboardingScript.fromJson(JsonReader('onboarding.json', json)),
    );
    final issues = AssetValidator(exists: files.contains).validate(theme: kit, content: broken);
    expect(issues.where((i) => i.isError).map((i) => i.message), contains(contains('fly_to_the_moon')));
  });
```

- [ ] **Step 3: Run them to see them fail**

Run: `flutter test test/content`
Expected: FAIL. `ContentBundle` has no `onboarding` yet.

- [ ] **Step 4: Add onboarding to `lib/content/content_bundle.dart`**

Replace the file with:

```dart
import '../domain/rules/game_rules.dart';
import 'goal_library.dart';
import 'json_reader.dart';
import 'onboarding_script.dart';

/// All bundled content, loaded once at startup.
class ContentBundle {
  const ContentBundle({required this.rules, required this.goals, required this.onboarding});

  final GameRules rules;
  final GoalLibrary goals;
  final OnboardingScript onboarding;
}

Future<ContentBundle> loadContent(ReadText read) async {
  Future<JsonReader> open(String path) async => JsonReader.decode(path, await read(path));
  return ContentBundle(
    rules: GameRules.fromJson(await open(GameRules.fileName)),
    goals: GoalLibrary.fromJson(await open(GoalLibrary.fileName)),
    onboarding: OnboardingScript.fromJson(await open(OnboardingScript.fileName)),
  );
}
```

- [ ] **Step 5: Add the cross-checks to `lib/content/asset_validator.dart`**

Add the import `import 'onboarding_script.dart';`. In `validate`, just before `return issues;`, add:

```dart
    final script = content.onboarding;
    final goalIds = [...script.foundationGoals, for (final rule in script.planRules) ...rule.add];
    for (final id in goalIds) {
      if (content.goals.byId(id) == null) {
        issues.add(ValidationIssue.error(OnboardingScript.fileName, 'unknown goal "$id"'));
      }
    }
    final essentialFoundation = script.foundationGoals.where((id) => content.goals.byId(id)?.essential ?? false).length;
    if (essentialFoundation < 2) {
      issues.add(const ValidationIssue.error(
        OnboardingScript.fileName,
        'foundationGoals need at least 2 essential goals, for low-energy days',
      ));
    }
    final focusIds = {for (final o in script.step(script.focusQuestion)!.options) o.id};
    final areaIds = {for (final a in content.goals.areas) a.id};
    if (focusIds.length != areaIds.length || !focusIds.containsAll(areaIds)) {
      issues.add(ValidationIssue.error(
        OnboardingScript.fileName,
        'the options of "${script.focusQuestion}" must match the goal library areas exactly',
      ));
    }
    for (final (where, text) in script.texts) {
      final unknown = unknownPlaceholders(text);
      if (unknown.isNotEmpty) {
        issues.add(ValidationIssue.error(
          '${OnboardingScript.fileName} $where',
          'unknown placeholders ${unknown.map((u) => '{$u}').join(', ')}',
        ));
      }
    }
```

- [ ] **Step 6: Run the tests and the CLI**

Run: `flutter test test/content` → Expected: `All tests passed!`
Run: `dart run tool/validate_assets.dart` → Expected: `Assets OK (0 warnings).`

- [ ] **Step 7: Commit**

```
git add -A
git commit -m "feat(content): write the onboarding flow and plan rules with cross-checks

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 4: QuestionFlow

**Files:**
- Create: `lib/domain/onboarding/question_flow.dart`
- Test: `test/domain/onboarding/question_flow_test.dart`

**Interfaces:**
- Consumes: `OnboardingScript`, `OnboardingStep`, `StepType` (Task 2); `Answers` (Task 1)
- Produces:
  - `class SectionProgress { int sectionIndex; int sectionCount; String label; double withinSection; }`
  - `class QuestionFlow(OnboardingScript script)`:
    - `bool isVisible(OnboardingStep, Answers)`
    - `List<OnboardingStep> visibleSteps(Answers)`
    - `OnboardingStep? next(String currentId, Answers)`, `OnboardingStep? previous(String currentId, Answers)`
    - `SectionProgress? progress(String stepId, Answers)`
    - `Answers prune(Answers)`
    - `OnboardingStep? resumeAt(Answers)`: the first visible step without an answer, or null when all are answered

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/content/onboarding_script.dart';
import 'package:zulu/domain/onboarding/question_flow.dart';

final script = OnboardingScript.fromJson(JsonReader.decode('o.json', '''
{
  "sections": [{"id":"x","label":"Energy"},{"id":"y","label":"Life"}],
  "foundationGoals": [], "foundationReason": "r", "focusQuestion": "q2", "planRules": [],
  "steps": [
    {"id":"intro","type":"talk","prompt":"Hi"},
    {"id":"q1","type":"single","section":"x","prompt":"1","options":[{"id":"a","label":"A"},{"id":"b","label":"B"}]},
    {"id":"q2","type":"multi","section":"x","prompt":"2","options":[{"id":"p","label":"P"},{"id":"q","label":"Q"}]},
    {"id":"f1","type":"single","section":"x","prompt":"3","showIf":{"question":"q2","includes":"p"},"options":[{"id":"z","label":"Z"},{"id":"w","label":"W"}]},
    {"id":"f2","type":"talk","section":"x","prompt":"4","showIf":{"question":"f1","equals":"z"}},
    {"id":"q3","type":"single","section":"y","prompt":"5","options":[{"id":"a","label":"A"},{"id":"b","label":"B"}]}
  ]
}
'''));

final flow = QuestionFlow(script);

void main() {
  test('follow-ups stay hidden until their answer is chosen', () {
    expect(flow.visibleSteps({}).map((s) => s.id), ['intro', 'q1', 'q2', 'q3']);
    expect(flow.visibleSteps({'q2': ['p']}).map((s) => s.id), ['intro', 'q1', 'q2', 'f1', 'q3']);
    expect(flow.visibleSteps({'q2': ['p'], 'f1': 'z'}).map((s) => s.id), ['intro', 'q1', 'q2', 'f1', 'f2', 'q3']);
  });

  test('next skips hidden steps and ends with null', () {
    expect(flow.next('q2', {'q2': ['q']})!.id, 'q3');
    expect(flow.next('q2', {'q2': ['p']})!.id, 'f1');
    expect(flow.next('q3', {}), isNull);
  });

  test('previous skips hidden steps and stops at the start', () {
    expect(flow.previous('q3', {'q2': ['q']})!.id, 'q2');
    expect(flow.previous('q3', {'q2': ['p'], 'f1': 'w'})!.id, 'f1');
    expect(flow.previous('intro', {}), isNull);
  });

  test('progress counts visible steps within the section', () {
    final plain = flow.progress('q2', {'q2': ['q']})!;
    expect(plain.sectionIndex, 0);
    expect(plain.sectionCount, 2);
    expect(plain.label, 'Energy');
    expect(plain.withinSection, 0.5);
    expect(flow.progress('q2', {'q2': ['p']})!.withinSection, closeTo(1 / 3, 1e-9));
    expect(flow.progress('q3', {})!.sectionIndex, 1);
    expect(flow.progress('q3', {})!.withinSection, 0);
    expect(flow.progress('intro', {}), isNull);
  });

  test('prune drops answers of hidden steps, cascading', () {
    final answers = {'q1': 'a', 'q2': ['q'], 'f1': 'z', 'f2': 'ok'};
    expect(flow.prune(answers), {'q1': 'a', 'q2': ['q']});
  });

  test('prune drops answers for steps that no longer exist', () {
    expect(flow.prune({'q1': 'b', 'removed_step': 'x'}), {'q1': 'b'});
  });

  test('resumeAt finds the first visible step without an answer', () {
    expect(flow.resumeAt({})!.id, 'intro');
    expect(flow.resumeAt({'intro': 'ok', 'q1': 'a', 'q2': ['p']})!.id, 'f1');
    expect(flow.resumeAt({'intro': 'ok', 'q1': 'a', 'q2': ['q'], 'q3': 'b'}), isNull);
  });
}
```

- [ ] **Step 2: Run it to see it fail**

Run: `flutter test test/domain/onboarding/question_flow_test.dart` → Expected: FAIL (`question_flow.dart` doesn't exist).

- [ ] **Step 3: Implement `lib/domain/onboarding/question_flow.dart`**

```dart
import '../../content/onboarding_script.dart';
import 'answers.dart';

/// Where a quiz step sits: which section, and how much of that section is
/// already behind the user (0 = just started).
class SectionProgress {
  const SectionProgress({
    required this.sectionIndex,
    required this.sectionCount,
    required this.label,
    required this.withinSection,
  });

  final int sectionIndex;
  final int sectionCount;
  final String label;
  final double withinSection;
}

/// Walks the onboarding script: which steps are visible for the current
/// answers, what comes next, and which answers no longer apply.
class QuestionFlow {
  const QuestionFlow(this.script);

  final OnboardingScript script;

  bool isVisible(OnboardingStep step, Answers answers) => step.showIf?.matches(answers) ?? true;

  List<OnboardingStep> visibleSteps(Answers answers) => [
        for (final s in script.steps)
          if (isVisible(s, answers)) s,
      ];

  OnboardingStep? next(String currentId, Answers answers) {
    for (var i = script.indexOf(currentId) + 1; i < script.steps.length; i++) {
      if (isVisible(script.steps[i], answers)) return script.steps[i];
    }
    return null;
  }

  OnboardingStep? previous(String currentId, Answers answers) {
    for (var i = script.indexOf(currentId) - 1; i >= 0; i--) {
      if (isVisible(script.steps[i], answers)) return script.steps[i];
    }
    return null;
  }

  SectionProgress? progress(String stepId, Answers answers) {
    final step = script.step(stepId);
    final section = step?.section;
    if (step == null || section == null) return null;
    final inSection = [
      for (final s in visibleSteps(answers))
        if (s.section == section) s.id,
    ];
    final index = script.sections.indexWhere((s) => s.id == section);
    return SectionProgress(
      sectionIndex: index,
      sectionCount: script.sections.length,
      label: script.sections[index].label,
      withinSection: inSection.indexOf(stepId) / inSection.length,
    );
  }

  /// Removes answers whose step is hidden or gone. Repeats because hiding
  /// one step can hide steps that depend on it.
  Answers prune(Answers answers) {
    var current = Map<String, Object>.of(answers);
    while (true) {
      final kept = {
        for (final e in current.entries)
          if (script.step(e.key) case final step? when isVisible(step, current)) e.key: e.value,
      };
      if (kept.length == current.length) return kept;
      current = kept;
    }
  }

  OnboardingStep? resumeAt(Answers answers) {
    for (final s in visibleSteps(answers)) {
      if (!answers.containsKey(s.id)) return s;
    }
    return null;
  }
}
```

- [ ] **Step 4: Run it to see it pass**

Run: `flutter test test/domain/onboarding/question_flow_test.dart` → Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```
git add -A
git commit -m "feat(domain): add onboarding question flow with branching and pruning

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 5: PlanGenerator

**Files:**
- Create: `lib/domain/onboarding/plan_generator.dart`
- Test: `test/domain/onboarding/plan_generator_test.dart`

**Interfaces:**
- Consumes: `OnboardingScript` (Task 2); `GoalLibrary`, `GoalTemplate` (Plan 1); `Answers`
- Produces:
  - `class PlannedGoal { GoalTemplate goal; String reason; }`
  - `class PlanGenerator({required OnboardingScript script, required GoalLibrary library, int maxGoals = 7})`:
    - `List<PlannedGoal> generate(Answers)`
    - `List<GoalTemplate> alternativesFor(String goalId, List<PlannedGoal> plan)`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/content/goal_library.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/content/onboarding_script.dart';
import 'package:zulu/domain/onboarding/plan_generator.dart';

import '../../helpers/read_file.dart';

final library = GoalLibrary.fromJson(JsonReader.decode('g.json', '''
{"areas":[{"id":"calm","label":"Calmer mind","icon":"x","trait":"calm"},{"id":"move","label":"Move more","icon":"x","trait":"confidence"}],
 "goals":[
  {"id":"bed","title":"Bed","icon":"x","area":"calm","section":"start_day","essential":true},
  {"id":"water","title":"Water","icon":"x","area":"calm","section":"any_time","essential":true},
  {"id":"breathe","title":"Breathe","icon":"x","area":"calm","section":"any_time","starter":true},
  {"id":"sit","title":"Sit","icon":"x","area":"calm","section":"any_time","starter":true},
  {"id":"walk","title":"Walk","icon":"x","area":"move","section":"any_time","starter":true},
  {"id":"dance","title":"Dance","icon":"x","area":"move","section":"any_time","starter":true},
  {"id":"stretch","title":"Stretch","icon":"x","area":"move","section":"any_time"}
 ]}'''));

final script = OnboardingScript.fromJson(JsonReader.decode('o.json', '''
{"sections":[],"foundationGoals":["bed","water"],"foundationReason":"a gentle start","focusQuestion":"areas",
 "steps":[
  {"id":"areas","type":"multi","prompt":"?","options":[{"id":"calm","label":"C"},{"id":"move","label":"M"}]},
  {"id":"mornings","type":"single","prompt":"?","options":[{"id":"hard","label":"H"},{"id":"easy","label":"E"}]}
 ],
 "planRules":[
  {"when":{"question":"mornings","equals":"hard"},"add":["stretch","bed"],"reason":"mornings are hard"}
 ]}'''));

List<(String, String)> ids(List<PlannedGoal> plan) => [for (final p in plan) (p.goal.id, p.reason)];

void main() {
  final generator = PlanGenerator(script: script, library: library);

  test('starts with the foundation goals', () {
    expect(ids(generator.generate({})), [('bed', 'a gentle start'), ('water', 'a gentle start')]);
  });

  test('matching rules add goals with their reason, without duplicates', () {
    expect(ids(generator.generate({'mornings': 'hard'})), [
      ('bed', 'a gentle start'),
      ('water', 'a gentle start'),
      ('stretch', 'mornings are hard'),
    ]);
  });

  test('fills with starters from each chosen area, one area at a time', () {
    expect(ids(generator.generate({'areas': ['move', 'calm']})), [
      ('bed', 'a gentle start'),
      ('water', 'a gentle start'),
      ('walk', 'you picked move more'),
      ('breathe', 'you picked calmer mind'),
      ('dance', 'you picked move more'),
      ('sit', 'you picked calmer mind'),
    ]);
  });

  test('never exceeds the goal limit', () {
    final small = PlanGenerator(script: script, library: library, maxGoals: 3);
    expect(small.generate({'areas': ['move', 'calm'], 'mornings': 'hard'}).map((p) => p.goal.id), ['bed', 'water', 'stretch']);
  });

  test('alternatives are same-area goals not already in the plan', () {
    final plan = generator.generate({'areas': ['move']});
    expect(generator.alternativesFor('walk', plan).map((g) => g.id), ['stretch']);
  });

  test('the shipped content produces a full, explained plan', () async {
    final content = await loadContent(readFile);
    final shipped = PlanGenerator(script: content.onboarding, library: content.goals);
    final plan = shipped.generate({
      'hard_lately': ['stress'],
      'sleep_hours': 'under_5',
      'focus_areas': ['move_more'],
      'move_blocker': ['no_time'],
    });
    expect(plan.map((p) => p.goal.id), [
      'get_out_of_bed',
      'drink_water',
      'three_breaths',
      'wind_down_10',
      'stretch_2min',
      'short_walk',
      'one_song_move',
    ]);
    expect(plan[3].reason, "you told me sleep's been short");
  });
}
```

- [ ] **Step 2: Run it to see it fail**

Run: `flutter test test/domain/onboarding/plan_generator_test.dart` → Expected: FAIL (`plan_generator.dart` doesn't exist).

- [ ] **Step 3: Implement `lib/domain/onboarding/plan_generator.dart`**

```dart
import '../../content/goal_library.dart';
import '../../content/onboarding_script.dart';
import 'answers.dart';

class PlannedGoal {
  const PlannedGoal(this.goal, this.reason);

  final GoalTemplate goal;

  /// Why this goal is in the plan, mirroring the user's own answer.
  final String reason;
}

/// Turns onboarding answers into a starter plan (spec §6.4):
/// 1. the foundation goals, then
/// 2. goals from matching plan rules, then
/// 3. starter goals from each chosen focus area, one area at a time,
/// with no duplicates, up to [maxGoals].
class PlanGenerator {
  const PlanGenerator({required this.script, required this.library, this.maxGoals = 7});

  final OnboardingScript script;
  final GoalLibrary library;
  final int maxGoals;

  List<PlannedGoal> generate(Answers answers) {
    final plan = <PlannedGoal>[];
    final used = <String>{};

    void add(String id, String reason) {
      if (plan.length >= maxGoals || used.contains(id)) return;
      final goal = library.byId(id);
      if (goal == null) return;
      used.add(id);
      plan.add(PlannedGoal(goal, reason));
    }

    for (final id in script.foundationGoals) {
      add(id, script.foundationReason);
    }
    for (final rule in script.planRules) {
      if (!rule.when.matches(answers)) continue;
      for (final id in rule.add) {
        add(id, rule.reason);
      }
    }

    final chosen = answers[script.focusQuestion];
    final areas = chosen is List<String> ? chosen : const <String>[];
    final starters = [for (final a in areas) library.startersIn(a)];
    for (var round = 0; plan.length < maxGoals; round++) {
      var any = false;
      for (final (i, list) in starters.indexed) {
        if (round >= list.length) continue;
        any = true;
        add(list[round].id, 'you picked ${library.area(areas[i])!.label.toLowerCase()}');
      }
      if (!any) break;
    }
    return plan;
  }

  List<GoalTemplate> alternativesFor(String goalId, List<PlannedGoal> plan) {
    final goal = library.byId(goalId);
    if (goal == null) return const [];
    final inPlan = {for (final p in plan) p.goal.id};
    return [
      for (final g in library.inArea(goal.area))
        if (!inPlan.contains(g.id)) g,
    ];
  }
}
```

- [ ] **Step 4: Run it to see it pass**

Run: `flutter test test/domain/onboarding/plan_generator_test.dart` → Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```
git add -A
git commit -m "feat(domain): generate explained starter plans from onboarding answers

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 6: Onboarding outcome and completion

**Files:**
- Create: `lib/domain/onboarding/onboarding_outcome.dart`, `lib/data/onboarding_completer.dart`
- Modify: `lib/app/providers.dart`
- Test: `test/domain/onboarding/onboarding_outcome_test.dart`, `test/data/onboarding_completer_test.dart`

**Interfaces:**
- Consumes: `OnboardingScript`, `SaveTo`, `StepType` (Task 2); `ProfileRepository`, `PetRepository`, `GoalRepository`, `NewGoal` (Plan 1 and Task 1); `Pronouns`, `Trait`
- Produces:
  - `class OnboardingOutcome`:
    - fields: `petName`, `pronouns`, `eggColor`, `trait`, `traitStats`, `userName`, `wakeTime`, `bedTime`
    - `factory OnboardingOutcome.from({required OnboardingScript script, required Answers answers, required double startingBonus, required String fallbackEgg})`
  - `class OnboardingCompleter({required AppDatabase db, required ProfileRepository profiles, required PetRepository pets, required GoalRepository goals, required Clock clock})` with `Future<void> complete(OnboardingOutcome, List<GoalTemplate> plan)`
  - `onboardingCompleterProvider`

- [ ] **Step 1: Write the failing tests**

`test/domain/onboarding/onboarding_outcome_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/domain/onboarding/onboarding_outcome.dart';
import 'package:zulu/domain/pet/trait.dart';
import 'package:zulu/domain/text/template.dart';

import '../../helpers/read_file.dart';

void main() {
  late ContentBundle content;

  setUpAll(() async => content = await loadContent(readFile));

  OnboardingOutcome outcome(Map<String, Object> answers) => OnboardingOutcome.from(
        script: content.onboarding,
        answers: answers,
        startingBonus: 6,
        fallbackEgg: 'sunrise',
      );

  test('reads the pet and profile from the saved answers', () {
    final o = outcome({
      'egg': 'mint',
      'pet_name': '  Mochi ',
      'pet_pronouns': 'she',
      'pet_trait': 'calm',
      'user_name': 'Sam',
      'self_care': 'hard_days',
      'wake_time': '06:45',
      'bed_time': '22:30',
    });
    expect(o.eggColor, 'mint');
    expect(o.petName, 'Mochi');
    expect(o.pronouns, Pronouns.she);
    expect(o.trait, Trait.calm);
    expect(o.traitStats, {Trait.calm: 6.0, Trait.resilience: 1.0});
    expect(o.userName, 'Sam');
    expect(o.wakeTime, '06:45');
    expect(o.bedTime, '22:30');
  });

  test('falls back when optional answers are missing', () {
    final o = outcome({'user_name': ''});
    expect(o.petName, 'Pip');
    expect(o.pronouns, Pronouns.they);
    expect(o.eggColor, 'sunrise');
    expect(o.trait, Trait.curiosity);
    expect(o.userName, '');
    expect(o.wakeTime, '07:30');
    expect(o.bedTime, '23:00');
    final vars = templateVars(userName: o.userName, petName: o.petName, pronouns: o.pronouns, currency: 'coin', currencyPlural: 'coins');
    expect(fillTemplate('Nice to meet you, {userName}!', vars), 'Nice to meet you, friend!');
  });

  test('a nudge toward the chosen trait adds to its starting bonus', () {
    final o = outcome({'pet_trait': 'compassion', 'self_care': 'body_mind'});
    expect(o.traitStats, {Trait.compassion: 7.0});
  });
}
```

`test/data/onboarding_completer_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/onboarding_completer.dart';
import 'package:zulu/data/repositories/goal_repository.dart';
import 'package:zulu/data/repositories/pet_repository.dart';
import 'package:zulu/data/repositories/profile_repository.dart';
import 'package:zulu/domain/onboarding/onboarding_outcome.dart';
import 'package:zulu/domain/pet/trait.dart';
import 'package:zulu/domain/text/template.dart';

import '../helpers/read_file.dart';

void main() {
  test('saves the pet, the profile and the planned goals', () async {
    final content = await loadContent(readFile);
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final clock = FakeClock(DateTime(2026, 9, 30, 10));
    final profiles = ProfileRepository(db, clock);
    await profiles.ensure();

    await OnboardingCompleter(
      db: db,
      profiles: profiles,
      pets: PetRepository(db),
      goals: GoalRepository(db, clock),
      clock: clock,
    ).complete(
      const OnboardingOutcome(
        petName: 'Mochi',
        pronouns: Pronouns.she,
        eggColor: 'mint',
        trait: Trait.calm,
        traitStats: {Trait.calm: 6},
        userName: 'Sam',
        wakeTime: '06:45',
        bedTime: '22:30',
      ),
      [content.goals.byId('get_out_of_bed')!, content.goals.byId('shower')!],
    );

    final pet = (await PetRepository(db).get())!;
    expect(pet.name, 'Mochi');
    expect(pet.eggColor, 'mint');
    expect(pet.hatchedAt.isAtSameMomentAs(clock.now()), isTrue);
    final profile = await profiles.get();
    expect(profile.userName, 'Sam');
    expect(profile.wakeTime, '06:45');
    expect(profile.bedTime, '22:30');
    expect(profile.onboardingDoneAt!.isAtSameMomentAs(clock.now()), isTrue);
    final goals = await GoalRepository(db, clock).active();
    expect(goals.map((g) => g.libraryId), ['get_out_of_bed', 'shower']);
    expect(goals.first.essential, isTrue);
  });
}
```

- [ ] **Step 2: Run them to see them fail**

Run: `flutter test test/domain/onboarding/onboarding_outcome_test.dart test/data/onboarding_completer_test.dart` → Expected: FAIL (files don't exist).

- [ ] **Step 3: Implement `lib/domain/onboarding/onboarding_outcome.dart`**

```dart
import '../../content/onboarding_script.dart';
import '../pet/trait.dart';
import '../text/template.dart';
import 'answers.dart';

/// What onboarding decided: the pet and the profile basics, read from the
/// answers with sensible fallbacks for anything skipped.
class OnboardingOutcome {
  const OnboardingOutcome({
    required this.petName,
    required this.pronouns,
    required this.eggColor,
    required this.trait,
    required this.traitStats,
    required this.userName,
    required this.wakeTime,
    required this.bedTime,
  });

  final String petName;
  final Pronouns pronouns;
  final String eggColor;
  final Trait trait;
  final Map<Trait, double> traitStats;
  final String userName;
  final String wakeTime;
  final String bedTime;

  factory OnboardingOutcome.from({
    required OnboardingScript script,
    required Answers answers,
    required double startingBonus,
    required String fallbackEgg,
  }) {
    OnboardingStep? stepFor(SaveTo target) {
      for (final s in script.steps) {
        if (s.saveTo == target) return s;
      }
      return null;
    }

    String? saved(SaveTo target) {
      final step = stepFor(target);
      final value = step == null ? null : answers[step.id];
      return value is String && value.trim().isNotEmpty ? value.trim() : null;
    }

    final trait = Trait.values.asNameMap()[saved(SaveTo.petTrait)] ?? Trait.curiosity;
    final stats = <Trait, double>{trait: startingBonus};
    for (final s in script.steps) {
      if (s.type != StepType.talkChoice) continue;
      final value = answers[s.id];
      final option = value is String ? s.option(value) : null;
      final nudged = option?.trait;
      if (option != null && nudged != null) stats[nudged] = (stats[nudged] ?? 0) + option.nudge;
    }

    return OnboardingOutcome(
      petName: saved(SaveTo.petName) ?? stepFor(SaveTo.petName)?.suggestions.firstOrNull ?? 'Pip',
      pronouns: Pronouns.fromId(saved(SaveTo.petPronouns) ?? 'they'),
      eggColor: saved(SaveTo.petEggColor) ?? fallbackEgg,
      trait: trait,
      traitStats: stats,
      userName: saved(SaveTo.userName) ?? '',
      wakeTime: saved(SaveTo.wakeTime) ?? stepFor(SaveTo.wakeTime)?.defaultValue ?? '07:30',
      bedTime: saved(SaveTo.bedTime) ?? stepFor(SaveTo.bedTime)?.defaultValue ?? '23:00',
    );
  }
}
```

- [ ] **Step 4: Implement `lib/data/onboarding_completer.dart`**

```dart
import 'package:drift/drift.dart';

import '../content/goal_library.dart';
import '../core/clock.dart';
import '../domain/onboarding/onboarding_outcome.dart';
import 'db/database.dart';
import 'repositories/goal_repository.dart';
import 'repositories/pet_repository.dart';
import 'repositories/profile_repository.dart';

/// Writes the result of onboarding in one transaction: the pet, the profile
/// basics (marking onboarding done) and the accepted plan's goals.
class OnboardingCompleter {
  OnboardingCompleter({
    required AppDatabase db,
    required ProfileRepository profiles,
    required PetRepository pets,
    required GoalRepository goals,
    required Clock clock,
  })  : _db = db,
        _profiles = profiles,
        _pets = pets,
        _goals = goals,
        _clock = clock;

  final AppDatabase _db;
  final ProfileRepository _profiles;
  final PetRepository _pets;
  final GoalRepository _goals;
  final Clock _clock;

  Future<void> complete(OnboardingOutcome outcome, List<GoalTemplate> plan) async {
    final now = _clock.now();
    await _db.transaction(() async {
      await _pets.save(
        name: outcome.petName,
        pronouns: outcome.pronouns,
        eggColor: outcome.eggColor,
        trait: outcome.trait,
        traitStats: outcome.traitStats,
        hatchedAt: now,
      );
      await _goals.addAll([for (final g in plan) NewGoal.fromTemplate(g)]);
      await _profiles.update(ProfilesCompanion(
        userName: Value(outcome.userName),
        wakeTime: Value(outcome.wakeTime),
        bedTime: Value(outcome.bedTime),
        onboardingDoneAt: Value(now),
      ));
    });
  }
}
```

In `lib/app/providers.dart`, add the import `import '../data/onboarding_completer.dart';` and this provider:

```dart
final onboardingCompleterProvider = Provider<OnboardingCompleter>(
  (ref) => OnboardingCompleter(
    db: ref.watch(databaseProvider),
    profiles: ref.watch(profileRepositoryProvider),
    pets: ref.watch(petRepositoryProvider),
    goals: ref.watch(goalRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);
```

- [ ] **Step 5: Run the tests to see them pass**

Run: `flutter test test/domain/onboarding/onboarding_outcome_test.dart test/data/onboarding_completer_test.dart` → Expected: `All tests passed!`

- [ ] **Step 6: Commit**

```
git add -A
git commit -m "feat(onboarding): derive the pet and profile from answers and save them atomically

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 7: PetView, EffectView and reminder permission

**Files:**
- Modify: `pubspec.yaml` (add `flutter_local_notifications`), `android/app/build.gradle.kts`
- Create: `lib/shared/widgets/pet_view.dart`, `lib/shared/widgets/effect_view.dart`, `lib/shared/services/reminder_permission.dart`, `test/helpers/test_app.dart`
- Test: `test/shared/pet_view_test.dart`, `test/shared/effect_view_test.dart`

**Interfaces:**
- Consumes: `themeKitProvider`, `ThemeKit`, `PetManifest`, `EffectRegistry`, `PetStage`, `PetPose`
- Produces:
  - `PetView({required PetStage stage, required PetPose pose, double size = 200, String? semanticLabel})`
  - `EffectView(EffectName effect, {double size = 160, bool repeat = false})`, which shows its fallback under `Key('effect-fallback')`
  - `abstract interface class ReminderPermission { Future<bool> request(); }`, `LocalNotificationsPermission`, `reminderPermissionProvider`
  - test helper `Future<void> pumpInApp(WidgetTester, Widget, {required ThemeKit kit, List<Override> overrides = const []})`

- [ ] **Step 1: Add the notification plugin and Android desugaring**

Run: `flutter pub add flutter_local_notifications` → Expected: `Changed … dependencies!`

In `android/app/build.gradle.kts`, change the `compileOptions` block to:

```kotlin
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
```

and add at the end of the file:

```kotlin
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

- [ ] **Step 2: Write the test helper and the failing tests**

`test/helpers/test_app.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/app/providers.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

/// Pumps [child] inside a MaterialApp with the theme kit provided.
Future<void> pumpInApp(
  WidgetTester tester,
  Widget child, {
  required ThemeKit kit,
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(ProviderScope(
    overrides: [themeKitProvider.overrideWithValue(kit), ...overrides],
    child: MaterialApp(home: Scaffold(body: Center(child: child))),
  ));
}
```

`test/shared/pet_view_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/domain/pet/pet_stage.dart';
import 'package:zulu/shared/widgets/pet_view.dart';
import 'package:zulu/theme_kit/pet_manifest.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../helpers/read_file.dart';
import '../helpers/test_app.dart';

void main() {
  late ThemeKit kit;

  setUpAll(() async => kit = await loadThemeKit(readFile));

  ThemeKit withTeenArt(Map<PetPose, PoseSpec> poses) => ThemeKit(
        theme: kit.theme,
        pet: PetManifest(
          canvasSize: kit.pet.canvasSize,
          eggs: kit.pet.eggs,
          stages: {...kit.pet.stages, PetStage.teen: StageArt(poses: poses, anchors: const {})},
        ),
        items: kit.items,
        rooms: kit.rooms,
        effects: kit.effects,
      );

  testWidgets('shows a PNG pose as an image', (tester) async {
    await pumpInApp(tester, const PetView(stage: PetStage.baby, pose: PetPose.happy), kit: kit);
    final image = tester.widget<Image>(find.byType(Image));
    expect((image.image as AssetImage).assetName, 'assets/theme/pet/baby/happy.png');
  });

  testWidgets('shows a Lottie pose as an animation', (tester) async {
    await pumpInApp(
      tester,
      const PetView(stage: PetStage.teen, pose: PetPose.idle),
      kit: withTeenArt({PetPose.idle: const LottiePose('effects/evolve.json')}),
    );
    expect(find.byType(LottieBuilder), findsOneWidget);
  });

  testWidgets('shows the baby idle image for Rive poses until Rive is supported', (tester) async {
    await pumpInApp(
      tester,
      const PetView(stage: PetStage.teen, pose: PetPose.idle),
      kit: withTeenArt({PetPose.idle: const RivePose('pet/teen/pet.riv')}),
    );
    final image = tester.widget<Image>(find.byType(Image));
    expect((image.image as AssetImage).assetName, 'assets/theme/pet/baby/idle.png');
  });
}
```

`test/shared/effect_view_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/shared/widgets/effect_view.dart';
import 'package:zulu/theme_kit/effect_registry.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../helpers/read_file.dart';
import '../helpers/test_app.dart';

void main() {
  late ThemeKit kit;

  setUpAll(() async => kit = await loadThemeKit(readFile));

  const fallback = Key('effect-fallback');

  testWidgets('plays the registered Lottie file', (tester) async {
    await pumpInApp(tester, const EffectView(EffectName.goalDone), kit: kit);
    expect(find.byType(LottieBuilder), findsOneWidget);
    expect(find.byKey(fallback), findsNothing);
  });

  testWidgets('uses the built-in animation when no file is registered', (tester) async {
    final noEffects = ThemeKit(
      theme: kit.theme,
      pet: kit.pet,
      items: kit.items,
      rooms: kit.rooms,
      effects: const EffectRegistry({}),
    );
    await pumpInApp(tester, const EffectView(EffectName.goalDone), kit: noEffects);
    expect(find.byKey(fallback), findsOneWidget);
    expect(find.byType(LottieBuilder), findsNothing);
  });

  testWidgets('uses the calm fallback when the system asks to reduce motion', (tester) async {
    await pumpInApp(
      tester,
      const MediaQuery(data: MediaQueryData(disableAnimations: true), child: EffectView(EffectName.goalDone)),
      kit: kit,
    );
    expect(find.byKey(fallback), findsOneWidget);
  });
}
```

- [ ] **Step 3: Run them to see them fail**

Run: `flutter test test/shared` → Expected: FAIL (`pet_view.dart` and `effect_view.dart` don't exist).

- [ ] **Step 4: Implement the widgets and the permission service**

`lib/shared/widgets/pet_view.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../domain/pet/pet_stage.dart';
import '../../theme_kit/pet_manifest.dart';
import '../../theme_kit/theme_kit.dart';

/// Draws the pet in [pose] at [stage], using whatever format the theme's
/// art is in. Rive poses show the baby idle image until Plan 3 adds Rive.
class PetView extends ConsumerWidget {
  const PetView({super.key, required this.stage, required this.pose, this.size = 200, this.semanticLabel});

  final PetStage stage;
  final PetPose pose;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pet = ref.watch(themeKitProvider).pet;
    final spec = pet.pose(stage, pose);
    final babyIdle = pet.pose(PetStage.baby, PetPose.idle);
    final child = switch (spec) {
      PngPose(:final path) => _image(path),
      LottiePose(:final path, :final loop) => Lottie.asset(
          ThemeKit.assetPath(path),
          repeat: loop,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stack) => _fallback(babyIdle),
        ),
      RivePose() => _fallback(babyIdle),
    };
    return Semantics(
      label: semanticLabel,
      image: true,
      child: SizedBox.square(dimension: size, child: child),
    );
  }

  Widget _image(String path) => Image.asset(
        ThemeKit.assetPath(path),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stack) => const _Blob(),
      );

  Widget _fallback(PoseSpec babyIdle) => babyIdle is PngPose ? _image(babyIdle.path) : const _Blob();
}

/// Last-resort pet drawing when no art can be shown at all.
class _Blob extends StatelessWidget {
  const _Blob();

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle),
      );
}
```

`lib/shared/widgets/effect_view.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../app/zulu_theme.dart';
import '../../theme_kit/effect_registry.dart';
import '../../theme_kit/theme_kit.dart';

/// Plays a celebration effect from the theme. With no file, or when the
/// system asks to reduce motion, shows a simple fade instead (spec §4.5).
class EffectView extends ConsumerWidget {
  const EffectView(this.effect, {super.key, this.size = 160, this.repeat = false});

  final EffectName effect;
  final double size;
  final bool repeat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(themeKitProvider).effects.fileFor(effect);
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final Widget child = path == null || reduceMotion
        ? const _FadeFallback(key: Key('effect-fallback'))
        : Lottie.asset(
            ThemeKit.assetPath(path),
            repeat: repeat,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stack) => const _FadeFallback(key: Key('effect-fallback')),
          );
    return ExcludeSemantics(child: SizedBox.square(dimension: size, child: child));
  }
}

class _FadeFallback extends StatelessWidget {
  const _FadeFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, t, _) => Opacity(
        opacity: 1 - t * 0.6,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.3 + 0.2 * t,
            heightFactor: 0.3 + 0.2 * t,
            child: DecoratedBox(
              decoration: BoxDecoration(color: context.zuluColors.energy, shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
  }
}
```

`lib/shared/services/reminder_permission.dart`:

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Asks the operating system for permission to show reminders.
abstract interface class ReminderPermission {
  /// True if reminders may be shown.
  Future<bool> request();
}

class LocalNotificationsPermission implements ReminderPermission {
  final _plugin = FlutterLocalNotificationsPlugin();

  @override
  Future<bool> request() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? false;
  }
}

final reminderPermissionProvider = Provider<ReminderPermission>((ref) => LocalNotificationsPermission());
```

- [ ] **Step 5: Run the tests and check the Android build**

Run: `flutter test test/shared` → Expected: `All tests passed!`
Run: `flutter build apk --debug` → Expected: `√ Built build\app\outputs\flutter-apk\app-debug.apk` (this proves desugaring is set up).

- [ ] **Step 6: Commit**

```
git add -A
git commit -m "feat(ui): add PetView, EffectView and reminder permission service

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 8: OnboardingController

**Files:**
- Create: `lib/features/onboarding/onboarding_controller.dart`
- Test: `test/features/onboarding/onboarding_controller_test.dart`

**Interfaces:**
- Consumes:
  - providers: `contentProvider`, `themeKitProvider`, `onboardingRepositoryProvider`, `onboardingCompleterProvider`
  - `QuestionFlow` (Task 4), `PlanGenerator` and `PlannedGoal` (Task 5), `OnboardingOutcome` (Task 6), `templateVars`
- Produces:
  - `class OnboardingState { Answers answers; OnboardingStep? step; List<PlannedGoal>? plan; bool get onPlan; }`
  - `class OnboardingController extends AsyncNotifier<OnboardingState>`:
    - `Future<void> answer(Object value)`
    - `void back()`, `bool get canGoBack`
    - `SectionProgress? get progress`
    - `Map<String, String> get vars`
    - `void removeFromPlan(String goalId)`, `void swapInPlan(String goalId, GoalTemplate replacement)`
    - `List<GoalTemplate> alternativesFor(String goalId)`
    - `Future<void> acceptPlan()`
  - `onboardingControllerProvider`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/app/providers.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/content/onboarding_script.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/profile_repository.dart';
import 'package:zulu/features/onboarding/onboarding_controller.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../../helpers/read_file.dart';

void main() {
  late ContentBundle content;
  late ThemeKit kit;
  late AppDatabase db;
  late ProviderContainer container;

  setUpAll(() async {
    content = await loadContent(readFile);
    kit = await loadThemeKit(readFile);
  });

  ProviderContainer makeContainer() => ProviderContainer.test(overrides: [
        databaseProvider.overrideWithValue(db),
        contentProvider.overrideWithValue(content),
        themeKitProvider.overrideWithValue(kit),
        clockProvider.overrideWithValue(FakeClock(DateTime(2026, 9, 30, 10))),
      ]);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await ProfileRepository(db, FakeClock(DateTime(2026, 9, 30))).ensure();
    container = makeContainer();
  });

  tearDown(() => db.close());

  OnboardingController controller() => container.read(onboardingControllerProvider.notifier);
  Future<OnboardingState> state() => container.read(onboardingControllerProvider.future);

  /// Answers every step until the plan, using [choices] where given and a
  /// sensible default otherwise.
  Future<void> answerAll(Map<String, Object> choices) async {
    for (var s = await state(); !s.onPlan; s = await state()) {
      final step = s.step!;
      final Object value = choices[step.id] ??
          switch (step.type) {
            StepType.multi => [step.options.first.id],
            StepType.single || StepType.talkChoice => step.options.first.id,
            StepType.egg => 'mint',
            StepType.text => 'Mochi',
            StepType.time => step.defaultValue!,
            _ => 'ok',
          };
      await controller().answer(value);
    }
  }

  test('starts at the welcome step', () async {
    expect((await state()).step!.id, 'welcome');
  });

  test('saves each answer and moves on', () async {
    await controller().answer('ok');
    expect((await state()).step!.id, 'egg');
    await controller().answer('mint');
    expect((await state()).answers['egg'], 'mint');
    expect((await state()).step!.id, 'hatch');
  });

  test('resumes at the first unanswered step', () async {
    await controller().answer('ok');
    await controller().answer('mint');
    container.dispose();
    container = makeContainer();
    expect((await state()).step!.id, 'hatch');
  });

  test('back returns to the previous visible step, keeping answers', () async {
    await controller().answer('ok');
    await controller().answer('mint');
    expect(controller().canGoBack, isTrue);
    controller().back();
    expect((await state()).step!.id, 'egg');
    expect((await state()).answers['egg'], 'mint');
  });

  test('changing an answer drops follow-ups that no longer apply', () async {
    await answerAll({'focus_areas': ['move_more'], 'move_blocker': ['no_time']});
    expect((await state()).answers.containsKey('move_blocker'), isTrue);
    controller().back();
    controller().back();
    expect((await state()).step!.id, 'focus_areas');
    await controller().answer(['rest_sleep']);
    final s = await state();
    expect(s.answers.containsKey('move_blocker'), isFalse);
    expect(s.step!.id, 'rest_blocker');
  });

  test('reaches an explained plan after the last question', () async {
    await answerAll({'hard_lately': ['stress'], 'focus_areas': ['move_more'], 'move_blocker': ['no_time']});
    final s = await state();
    expect(s.onPlan, isTrue);
    expect(s.plan!.map((p) => p.goal.id), containsAllInOrder(['get_out_of_bed', 'drink_water', 'three_breaths']));
    expect(s.plan!.length, lessThanOrEqualTo(7));
  });

  test('the plan keeps at least one goal', () async {
    await answerAll({});
    for (final p in [...(await state()).plan!]) {
      controller().removeFromPlan(p.goal.id);
    }
    expect((await state()).plan, hasLength(1));
  });

  test('swapping replaces a goal in place and keeps its reason', () async {
    await answerAll({'focus_areas': ['move_more']});
    final before = (await state()).plan!;
    final target = before.last;
    final replacement = controller().alternativesFor(target.goal.id).first;
    controller().swapInPlan(target.goal.id, replacement);
    final after = (await state()).plan!;
    expect(after.last.goal.id, replacement.id);
    expect(after.last.reason, target.reason);
    expect(after.length, before.length);
  });

  test('accepting the plan saves the pet, the profile and the goals', () async {
    await answerAll({'pet_name': 'Mochi', 'user_name': 'Sam', 'focus_areas': ['connect']});
    await controller().acceptPlan();
    final pet = await db.select(db.pets).getSingle();
    expect(pet.name, 'Mochi');
    final profile = await db.select(db.profiles).getSingle();
    expect(profile.userName, 'Sam');
    expect(profile.onboardingDoneAt, isNotNull);
    expect(await db.select(db.goals).get(), hasLength((await state()).plan!.length));
  });

  test('template vars use the answers so far', () async {
    await answerAll({'pet_name': 'Mochi', 'user_name': ''});
    expect(controller().vars['petName'], 'Mochi');
    expect(controller().vars['userName'], 'friend');
  });
}
```

- [ ] **Step 2: Run it to see it fail**

Run: `flutter test test/features/onboarding/onboarding_controller_test.dart` → Expected: FAIL (`onboarding_controller.dart` doesn't exist).

- [ ] **Step 3: Implement `lib/features/onboarding/onboarding_controller.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../content/goal_library.dart';
import '../../content/onboarding_script.dart';
import '../../domain/onboarding/answers.dart';
import '../../domain/onboarding/onboarding_outcome.dart';
import '../../domain/onboarding/plan_generator.dart';
import '../../domain/onboarding/question_flow.dart';
import '../../domain/text/template.dart';

class OnboardingState {
  const OnboardingState({required this.answers, this.step, this.plan});

  final Answers answers;

  /// The step on screen, or null once every question is answered.
  final OnboardingStep? step;

  /// The starter plan, once [step] is null.
  final List<PlannedGoal>? plan;

  bool get onPlan => step == null;
}

class OnboardingController extends AsyncNotifier<OnboardingState> {
  QuestionFlow get _flow => QuestionFlow(ref.read(contentProvider).onboarding);

  PlanGenerator get _generator {
    final content = ref.read(contentProvider);
    return PlanGenerator(script: content.onboarding, library: content.goals);
  }

  @override
  Future<OnboardingState> build() async {
    final answers = _flow.prune(await ref.read(onboardingRepositoryProvider).answers());
    return _stateAt(answers, _flow.resumeAt(answers));
  }

  OnboardingState _stateAt(Answers answers, OnboardingStep? step) =>
      OnboardingState(answers: answers, step: step, plan: step == null ? _generator.generate(answers) : null);

  /// Saves [value] for the current step, drops answers that no longer
  /// apply, and moves to the next visible step (or the plan).
  Future<void> answer(Object value) async {
    final current = state.requireValue;
    final step = current.step;
    if (step == null) return;
    final repo = ref.read(onboardingRepositoryProvider);
    await repo.saveAnswer(step.id, value);
    final answers = {...current.answers, step.id: value};
    final pruned = _flow.prune(answers);
    await repo.removeAnswers(answers.keys.where((k) => !pruned.containsKey(k)));
    state = AsyncData(_stateAt(pruned, _flow.next(step.id, pruned)));
  }

  bool get canGoBack {
    final current = state.value;
    if (current == null) return false;
    final step = current.step;
    return step == null || _flow.previous(step.id, current.answers) != null;
  }

  void back() {
    final current = state.requireValue;
    final step = current.step;
    final previous = step == null ? _flow.visibleSteps(current.answers).lastOrNull : _flow.previous(step.id, current.answers);
    if (previous != null) state = AsyncData(OnboardingState(answers: current.answers, step: previous));
  }

  SectionProgress? get progress {
    final current = state.value;
    final step = current?.step;
    return current == null || step == null ? null : _flow.progress(step.id, current.answers);
  }

  OnboardingOutcome _outcome(Answers answers) => OnboardingOutcome.from(
        script: ref.read(contentProvider).onboarding,
        answers: answers,
        startingBonus: ref.read(contentProvider).rules.traits.startingBonus,
        fallbackEgg: ref.read(themeKitProvider).pet.eggs.first.id,
      );

  /// Template variables for the pet's lines, from the answers so far.
  Map<String, String> get vars {
    final outcome = _outcome(state.value?.answers ?? const {});
    final theme = ref.read(themeKitProvider).theme;
    return templateVars(
      userName: outcome.userName,
      petName: outcome.petName,
      pronouns: outcome.pronouns,
      currency: theme.currency,
      currencyPlural: theme.currencyPlural,
    );
  }

  void removeFromPlan(String goalId) {
    final current = state.requireValue;
    final plan = current.plan;
    if (plan == null || plan.length <= 1) return;
    state = AsyncData(OnboardingState(
      answers: current.answers,
      plan: [for (final p in plan) if (p.goal.id != goalId) p],
    ));
  }

  void swapInPlan(String goalId, GoalTemplate replacement) {
    final current = state.requireValue;
    final plan = current.plan;
    if (plan == null) return;
    state = AsyncData(OnboardingState(
      answers: current.answers,
      plan: [for (final p in plan) p.goal.id == goalId ? PlannedGoal(replacement, p.reason) : p],
    ));
  }

  List<GoalTemplate> alternativesFor(String goalId) =>
      _generator.alternativesFor(goalId, state.value?.plan ?? const []);

  Future<void> acceptPlan() async {
    final current = state.requireValue;
    final plan = current.plan;
    if (plan == null) return;
    await ref.read(onboardingCompleterProvider).complete(_outcome(current.answers), [for (final p in plan) p.goal]);
  }
}

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, OnboardingState>(OnboardingController.new);
```

- [ ] **Step 4: Run it to see it pass**

Run: `flutter test test/features/onboarding/onboarding_controller_test.dart` → Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```
git add -A
git commit -m "feat(onboarding): add controller that saves, branches, resumes and completes

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 9: Step views

**Files:**
- Create: `lib/features/onboarding/ui/step_views.dart`, `lib/features/onboarding/ui/section_progress_bar.dart`
- Test: `test/features/onboarding/step_views_test.dart`

**Interfaces:**
- Consumes: `OnboardingStep`, `StepType` (Task 2); `SectionProgress` (Task 4); `PetView`, `EffectView`, `reminderPermissionProvider` (Task 7); `themeKitProvider`; `fillTemplate`
- Produces:
  - `StepView({required OnboardingStep step, required Map<String, String> vars, Object? initial, required ValueChanged<Object> onAnswer})`, which dispatches on `step.type`
  - `SectionProgressBar(SectionProgress progress)`
  - timing constants: `autoAdvanceDelay = Duration(milliseconds: 250)`, `hatchDelay = Duration(milliseconds: 1500)`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/content/onboarding_script.dart';
import 'package:zulu/features/onboarding/ui/step_views.dart';
import 'package:zulu/shared/services/reminder_permission.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../../helpers/read_file.dart';
import '../../helpers/test_app.dart';

class FakePermission implements ReminderPermission {
  int calls = 0;

  @override
  Future<bool> request() async {
    calls++;
    return true;
  }
}

OnboardingStep step(String json) =>
    OnboardingScript.fromJson(JsonReader.decode('o.json', '{"sections":[],"steps":[$json,'
            '{"id":"areas","type":"multi","prompt":"?","options":[{"id":"a","label":"A"},{"id":"b","label":"B"}]}],'
            '"foundationGoals":[],"foundationReason":"r","focusQuestion":"areas","planRules":[]}'))
        .steps
        .first;

void main() {
  late ThemeKit kit;
  final answers = <Object>[];

  setUpAll(() async => kit = await loadThemeKit(readFile));
  setUp(answers.clear);

  Future<void> show(WidgetTester tester, OnboardingStep s, {Object? initial, FakePermission? permission}) => pumpInApp(
        tester,
        StepView(step: s, vars: const {'petName': 'Pip', 'userName': 'Sam'}, initial: initial, onAnswer: answers.add),
        kit: kit,
        overrides: [if (permission != null) reminderPermissionProvider.overrideWithValue(permission)],
      );

  testWidgets('talk shows the filled prompt and continues', (tester) async {
    await show(tester, step('{"id":"t","type":"talk","prompt":"Hi {userName}!","button":"Okay"}'));
    expect(find.text('Hi Sam!'), findsOneWidget);
    await tester.tap(find.text('Okay'));
    expect(answers, ['ok']);
  });

  testWidgets('single choice highlights and auto-advances', (tester) async {
    await show(tester, step('{"id":"s","type":"single","prompt":"Pick","options":[{"id":"a","label":"Apple","icon":"🍎"},{"id":"b","label":"Berry"}]}'));
    await tester.tap(find.text('Berry'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(answers, isEmpty);
    await tester.pump(autoAdvanceDelay);
    expect(answers, ['b']);
  });

  testWidgets('multi choice needs a pick before Next', (tester) async {
    await show(tester, step('{"id":"m","type":"multi","prompt":"Pick","options":[{"id":"a","label":"Apple"},{"id":"b","label":"Berry"}]}'));
    await tester.tap(find.text('Next'));
    expect(answers, isEmpty);
    await tester.tap(find.text('Apple'));
    await tester.tap(find.text('Berry'));
    await tester.tap(find.text('Apple'));
    await tester.pump();
    await tester.tap(find.text('Next'));
    expect(answers, [['b']]);
  });

  testWidgets('multi choice starts from an earlier answer', (tester) async {
    await show(tester, step('{"id":"m","type":"multi","prompt":"Pick","options":[{"id":"a","label":"Apple"},{"id":"b","label":"Berry"}]}'), initial: ['a']);
    await tester.tap(find.text('Next'));
    expect(answers, [['a']]);
  });

  testWidgets('text needs a value unless skippable, and shuffles suggestions', (tester) async {
    await show(tester, step('{"id":"n","type":"text","prompt":"Name?","placeholder":"Pet name","suggestions":["Pip","Bean"]}'));
    await tester.tap(find.byTooltip('Suggest a name'));
    await tester.pump();
    expect(find.widgetWithText(TextField, 'Pip'), findsOneWidget);
    await tester.tap(find.byTooltip('Suggest a name'));
    await tester.pump();
    await tester.tap(find.text('Next'));
    expect(answers, ['Bean']);
  });

  testWidgets('a skippable text step can be skipped', (tester) async {
    await show(tester, step('{"id":"u","type":"text","prompt":"You?","skippable":true}'));
    await tester.tap(find.text('Skip'));
    expect(answers, ['']);
  });

  testWidgets('time continues with the default', (tester) async {
    await show(tester, step('{"id":"w","type":"time","prompt":"Wake?","default":"07:30"}'));
    expect(find.text('7:30 AM'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    expect(answers, ['07:30']);
  });

  testWidgets('egg picks one of the theme eggs', (tester) async {
    await show(tester, step('{"id":"e","type":"egg","prompt":"Pick an egg","button":"Hatch this egg"}'));
    await tester.tap(find.bySemanticsLabel('mint egg'));
    await tester.pump();
    await tester.tap(find.text('Hatch this egg'));
    expect(answers, ['mint']);
  });

  testWidgets('hatch shows the button after the hatching effect', (tester) async {
    await show(tester, step('{"id":"h","type":"hatch","prompt":"Hatching!","button":"Say hello"}'));
    expect(find.text('Say hello'), findsNothing);
    await tester.pump(hatchDelay);
    await tester.pump();
    await tester.tap(find.text('Say hello'));
    expect(answers, ['ok']);
  });

  testWidgets('permission asks the system, or can wait', (tester) async {
    final permission = FakePermission();
    await show(tester, step('{"id":"r","type":"permission","prompt":"Nudges?","preview":"{petName}: water?"}'), permission: permission);
    expect(find.text('Pip: water?'), findsOneWidget);
    await tester.tap(find.text('Turn on reminders'));
    await tester.pumpAndSettle();
    expect(permission.calls, 1);
    expect(answers, ['granted']);
  });

  testWidgets('permission "Maybe later" skips the system prompt', (tester) async {
    final permission = FakePermission();
    await show(tester, step('{"id":"r","type":"permission","prompt":"Nudges?"}'), permission: permission);
    await tester.tap(find.text('Maybe later'));
    expect(permission.calls, 0);
    expect(answers, ['later']);
  });
}
```

- [ ] **Step 2: Run it to see it fail**

Run: `flutter test test/features/onboarding/step_views_test.dart` → Expected: FAIL (`step_views.dart` doesn't exist).

- [ ] **Step 3: Implement `lib/features/onboarding/ui/section_progress_bar.dart`**

```dart
import 'package:material_ui/material_ui.dart';

import '../../../domain/onboarding/question_flow.dart';

/// One segment per quiz section: finished sections are full, the current
/// one fills as the user goes, and the section name sits underneath.
class SectionProgressBar extends StatelessWidget {
  const SectionProgressBar(this.progress, {super.key});

  final SectionProgress progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            for (var i = 0; i < progress.sectionCount; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    value: i < progress.sectionIndex
                        ? 1
                        : i == progress.sectionIndex
                            ? progress.withinSection
                            : 0,
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(progress.label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
```

- [ ] **Step 4: Implement `lib/features/onboarding/ui/step_views.dart`**

```dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../content/onboarding_script.dart';
import '../../../domain/pet/pet_stage.dart';
import '../../../domain/text/template.dart';
import '../../../shared/services/reminder_permission.dart';
import '../../../shared/widgets/effect_view.dart';
import '../../../shared/widgets/pet_view.dart';
import '../../../theme_kit/effect_registry.dart';
import '../../../theme_kit/pet_manifest.dart';
import '../../../theme_kit/theme_kit.dart';

/// How long a single-choice highlight shows before moving on.
const autoAdvanceDelay = Duration(milliseconds: 250);

/// How long the hatching effect plays before the pet appears.
const hatchDelay = Duration(milliseconds: 1500);

/// Shows one onboarding step. Every step ends by calling [onAnswer] with
/// a `String` or a `List<String>`.
class StepView extends StatelessWidget {
  const StepView({super.key, required this.step, required this.vars, this.initial, required this.onAnswer});

  final OnboardingStep step;
  final Map<String, String> vars;
  final Object? initial;
  final ValueChanged<Object> onAnswer;

  @override
  Widget build(BuildContext context) {
    final prompt = fillTemplate(step.prompt, vars);
    return switch (step.type) {
      StepType.talk => _TalkStep(step: step, prompt: prompt, vars: vars, onAnswer: onAnswer),
      StepType.single || StepType.talkChoice => _SingleStep(step: step, prompt: prompt, vars: vars, initial: initial, onAnswer: onAnswer),
      StepType.multi => _MultiStep(step: step, prompt: prompt, vars: vars, initial: initial, onAnswer: onAnswer),
      StepType.text => _TextStep(step: step, prompt: prompt, initial: initial, onAnswer: onAnswer),
      StepType.time => _TimeStep(step: step, prompt: prompt, initial: initial, onAnswer: onAnswer),
      StepType.egg => _EggStep(step: step, prompt: prompt, initial: initial, onAnswer: onAnswer),
      StepType.hatch => _HatchStep(step: step, prompt: prompt, onAnswer: onAnswer),
      StepType.permission => _PermissionStep(step: step, prompt: prompt, vars: vars, onAnswer: onAnswer),
    };
  }
}

/// The pet with its line in a speech bubble.
class _PetSays extends StatelessWidget {
  const _PetSays({required this.pose, required this.text, this.petSize = 140});

  final PetPose pose;
  final String text;
  final double petSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(text, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
        const SizedBox(height: 12),
        PetView(stage: PetStage.baby, pose: pose, size: petSize, semanticLabel: 'Your pet'),
      ],
    );
  }
}

/// Scrollable content with a pinned action area at the bottom.
class _StepLayout extends StatelessWidget {
  const _StepLayout({required this.children, this.actions = const []});

  final List<Widget> children;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 20), children: children),
        ),
        if (actions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: actions),
          ),
      ],
    );
  }
}

class _TalkStep extends StatelessWidget {
  const _TalkStep({required this.step, required this.prompt, required this.vars, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Map<String, String> vars;
  final ValueChanged<Object> onAnswer;

  @override
  Widget build(BuildContext context) => _StepLayout(
        children: [const SizedBox(height: 40), _PetSays(pose: step.petPose, text: prompt, petSize: 180)],
        actions: [FilledButton(onPressed: () => onAnswer('ok'), child: Text(fillTemplate(step.button ?? 'Continue', vars)))],
      );
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.option, required this.selected, required this.onTap, this.multi = false});

  final StepOption option;
  final bool selected;
  final VoidCallback onTap;
  final bool multi;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? scheme.primaryContainer : scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: selected ? scheme.primary : scheme.outlineVariant, width: selected ? 2 : 1),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 56),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    if (option.icon != null) ...[
                      ExcludeSemantics(child: Text(option.icon!, style: const TextStyle(fontSize: 24))),
                      const SizedBox(width: 12),
                    ],
                    Expanded(child: Text(option.label, style: Theme.of(context).textTheme.bodyLarge)),
                    if (multi) Icon(selected ? Icons.check_circle : Icons.add_circle_outline, color: scheme.primary),
                    if (!multi && selected) Icon(Icons.check_circle, color: scheme.primary),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SingleStep extends StatefulWidget {
  const _SingleStep({required this.step, required this.prompt, required this.vars, this.initial, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Map<String, String> vars;
  final Object? initial;
  final ValueChanged<Object> onAnswer;

  @override
  State<_SingleStep> createState() => _SingleStepState();
}

class _SingleStepState extends State<_SingleStep> {
  late String? _selected = widget.initial is String ? widget.initial! as String : null;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _pick(String id) {
    setState(() => _selected = id);
    _timer?.cancel();
    _timer = Timer(autoAdvanceDelay, () => widget.onAnswer(id));
  }

  @override
  Widget build(BuildContext context) => _StepLayout(
        children: [
          _PetSays(pose: widget.step.petPose, text: widget.prompt),
          const SizedBox(height: 20),
          for (final o in widget.step.options)
            _OptionCard(option: o.withLabel(fillTemplate(o.label, widget.vars)), selected: _selected == o.id, onTap: () => _pick(o.id)),
        ],
      );
}

class _MultiStep extends StatefulWidget {
  const _MultiStep({required this.step, required this.prompt, required this.vars, this.initial, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Map<String, String> vars;
  final Object? initial;
  final ValueChanged<Object> onAnswer;

  @override
  State<_MultiStep> createState() => _MultiStepState();
}

class _MultiStepState extends State<_MultiStep> {
  late final Set<String> _selected = {...?(widget.initial is List<String> ? widget.initial! as List<String> : null)};

  @override
  Widget build(BuildContext context) {
    final enough = _selected.length >= widget.step.minSelect;
    return _StepLayout(
      children: [
        _PetSays(pose: widget.step.petPose, text: widget.prompt),
        const SizedBox(height: 20),
        for (final o in widget.step.options)
          _OptionCard(
            option: o.withLabel(fillTemplate(o.label, widget.vars)),
            multi: true,
            selected: _selected.contains(o.id),
            onTap: () => setState(() => _selected.contains(o.id) ? _selected.remove(o.id) : _selected.add(o.id)),
          ),
      ],
      actions: [
        FilledButton(
          onPressed: enough
              ? () => widget.onAnswer([for (final o in widget.step.options) if (_selected.contains(o.id)) o.id])
              : null,
          child: const Text('Next'),
        ),
      ],
    );
  }
}

class _TextStep extends StatefulWidget {
  const _TextStep({required this.step, required this.prompt, this.initial, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Object? initial;
  final ValueChanged<Object> onAnswer;

  @override
  State<_TextStep> createState() => _TextStepState();
}

class _TextStepState extends State<_TextStep> {
  late final _controller = TextEditingController(text: widget.initial is String ? widget.initial! as String : '');
  var _suggestion = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _shuffle() {
    final suggestions = widget.step.suggestions;
    setState(() {
      _controller.text = suggestions[_suggestion % suggestions.length];
      _suggestion++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final value = _controller.text.trim();
    return _StepLayout(
      children: [
        _PetSays(pose: widget.step.petPose, text: widget.prompt),
        const SizedBox(height: 20),
        TextField(
          controller: _controller,
          maxLength: 24,
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) {
            if (value.isNotEmpty) widget.onAnswer(value);
          },
          decoration: InputDecoration(
            labelText: widget.step.placeholder,
            border: const OutlineInputBorder(),
            suffixIcon: widget.step.suggestions.isEmpty
                ? null
                : IconButton(tooltip: 'Suggest a name', icon: const Icon(Icons.casino_outlined), onPressed: _shuffle),
          ),
        ),
      ],
      actions: [
        FilledButton(onPressed: value.isEmpty ? null : () => widget.onAnswer(value), child: const Text('Next')),
        if (widget.step.skippable) TextButton(onPressed: () => widget.onAnswer(''), child: const Text('Skip')),
      ],
    );
  }
}

class _TimeStep extends StatefulWidget {
  const _TimeStep({required this.step, required this.prompt, this.initial, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Object? initial;
  final ValueChanged<Object> onAnswer;

  @override
  State<_TimeStep> createState() => _TimeStepState();
}

class _TimeStepState extends State<_TimeStep> {
  late TimeOfDay _time = _parse(widget.initial is String ? widget.initial! as String : widget.step.defaultValue ?? '07:30');

  static TimeOfDay _parse(String hhmm) {
    final parts = hhmm.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String get _value => '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';

  Future<void> _change() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  @override
  Widget build(BuildContext context) => _StepLayout(
        children: [
          _PetSays(pose: widget.step.petPose, text: widget.prompt),
          const SizedBox(height: 28),
          Center(child: Text(_time.format(context), style: Theme.of(context).textTheme.displaySmall)),
          Center(child: TextButton(onPressed: _change, child: const Text('Change time'))),
        ],
        actions: [FilledButton(onPressed: () => widget.onAnswer(_value), child: const Text('Continue'))],
      );
}

class _EggStep extends ConsumerStatefulWidget {
  const _EggStep({required this.step, required this.prompt, this.initial, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Object? initial;
  final ValueChanged<Object> onAnswer;

  @override
  ConsumerState<_EggStep> createState() => _EggStepState();
}

class _EggStepState extends ConsumerState<_EggStep> {
  late String? _selected = widget.initial is String ? widget.initial! as String : null;

  @override
  Widget build(BuildContext context) {
    final eggs = ref.watch(themeKitProvider).pet.eggs;
    final scheme = Theme.of(context).colorScheme;
    return _StepLayout(
      children: [
        Text(widget.prompt, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final egg in eggs)
              Semantics(
                label: '${egg.id} egg',
                selected: _selected == egg.id,
                button: true,
                child: GestureDetector(
                  onTap: () => setState(() => _selected = egg.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _selected == egg.id ? scheme.primary : Colors.transparent, width: 3),
                    ),
                    child: ExcludeSemantics(child: Image.asset(ThemeKit.assetPath(egg.image), width: 80, height: 100)),
                  ),
                ),
              ),
          ],
        ),
      ],
      actions: [
        FilledButton(
          onPressed: _selected == null ? null : () => widget.onAnswer(_selected!),
          child: Text(widget.step.button ?? 'Hatch this egg'),
        ),
      ],
    );
  }
}

class _HatchStep extends StatefulWidget {
  const _HatchStep({required this.step, required this.prompt, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final ValueChanged<Object> onAnswer;

  @override
  State<_HatchStep> createState() => _HatchStepState();
}

class _HatchStepState extends State<_HatchStep> {
  var _hatched = false;
  late final Timer _timer = Timer(hatchDelay, () => setState(() => _hatched = true));

  @override
  void initState() {
    super.initState();
    _timer;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _StepLayout(
        children: [
          const SizedBox(height: 40),
          Text(widget.prompt, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: Center(
              child: _hatched
                  ? const PetView(stage: PetStage.baby, pose: PetPose.happy, size: 200, semanticLabel: 'Your new pet')
                  : const EffectView(EffectName.hatchCrack, size: 200, repeat: true),
            ),
          ),
        ],
        actions: [
          if (_hatched) FilledButton(onPressed: () => widget.onAnswer('ok'), child: Text(widget.step.button ?? 'Continue')),
        ],
      );
}

class _PermissionStep extends ConsumerStatefulWidget {
  const _PermissionStep({required this.step, required this.prompt, required this.vars, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Map<String, String> vars;
  final ValueChanged<Object> onAnswer;

  @override
  ConsumerState<_PermissionStep> createState() => _PermissionStepState();
}

class _PermissionStepState extends ConsumerState<_PermissionStep> {
  var _asking = false;

  Future<void> _turnOn() async {
    setState(() => _asking = true);
    final ReminderPermission permission = ref.read(reminderPermissionProvider);
    final granted = await permission.request();
    if (mounted) widget.onAnswer(granted ? 'granted' : 'declined');
  }

  @override
  Widget build(BuildContext context) {
    final preview = widget.step.preview;
    return _StepLayout(
      children: [
        _PetSays(pose: widget.step.petPose, text: widget.prompt),
        if (preview != null) ...[
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: Text(fillTemplate(preview, widget.vars)),
            ),
          ),
        ],
      ],
      actions: [
        FilledButton(onPressed: _asking ? null : _turnOn, child: const Text('Turn on reminders')),
        TextButton(onPressed: _asking ? null : () => widget.onAnswer('later'), child: const Text('Maybe later')),
      ],
    );
  }
}
```

Add this method to `StepOption` in `lib/content/onboarding_script.dart`, so option labels can be template-filled:

```dart
  StepOption withLabel(String label) => StepOption(id: id, label: label, icon: icon, trait: trait, nudge: nudge);
```

- [ ] **Step 5: Run it to see it pass**

Run: `flutter test test/features/onboarding/step_views_test.dart` → Expected: `All tests passed!`

- [ ] **Step 6: Commit**

```
git add -A
git commit -m "feat(onboarding): add a view for every step type

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 10: Onboarding screen, plan view and routing

**Files:**
- Create: `lib/features/onboarding/ui/onboarding_screen.dart`, `lib/features/onboarding/ui/plan_view.dart`
- Modify:
  - `lib/app/providers.dart`: add `profileProvider` and `initialOnboardedProvider`
  - `lib/app/bootstrap.dart`, `lib/app/router.dart`, `lib/app/app.dart`
  - `lib/features/home/ui/home_screen.dart`
  - `test/app/app_shell_test.dart`
- Test: `test/features/onboarding/onboarding_flow_test.dart`

**Interfaces:**
- Consumes: `onboardingControllerProvider` (Task 8), `StepView`, `SectionProgressBar` and the timing constants (Task 9), `EffectView` (Task 7)
- Produces:
  - `profileProvider` (a `StreamProvider<Profile>`)
  - `initialOnboardedProvider` (a `Provider<bool>`, overridden by bootstrap)
  - `GoRouter buildRouter(ValueListenable<bool> onboarded)`, with the `/onboarding` route and redirects
  - `planLoadingDelay = Duration(milliseconds: 1800)`

- [ ] **Step 1: Write the failing flow test**

`test/features/onboarding/onboarding_flow_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/app/app.dart';
import 'package:zulu/app/providers.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/profile_repository.dart';
import 'package:zulu/features/onboarding/ui/plan_view.dart';
import 'package:zulu/features/onboarding/ui/step_views.dart';
import 'package:zulu/shared/services/reminder_permission.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../../helpers/read_file.dart';

class DeniedPermission implements ReminderPermission {
  @override
  Future<bool> request() async => false;
}

void main() {
  late ContentBundle content;
  late ThemeKit kit;

  setUpAll(() async {
    content = await loadContent(readFile);
    kit = await loadThemeKit(readFile);
  });

  testWidgets('a new user goes from hatching to their plan to Home', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() => ProfileRepository(db, FakeClock(DateTime(2026, 9, 30))).ensure());

    await tester.pumpWidget(ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        contentProvider.overrideWithValue(content),
        themeKitProvider.overrideWithValue(kit),
        clockProvider.overrideWithValue(FakeClock(DateTime(2026, 9, 30, 10))),
        initialOnboardedProvider.overrideWithValue(false),
        reminderPermissionProvider.overrideWithValue(DeniedPermission()),
      ],
      child: const ZuluApp(),
    ));

    Future<void> settle() => tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50))).then((_) => tester.pump());
    Future<void> tapText(String text) async {
      await tester.ensureVisible(find.text(text).first);
      await tester.tap(find.text(text).first);
      await settle();
    }

    Future<void> choose(String label) async {
      await tapText(label);
      await tester.pump(autoAdvanceDelay);
      await settle();
    }

    await settle();
    await tapText('Hatch a new pet');
    await tester.tap(find.bySemanticsLabel('mint egg'));
    await tester.pump();
    await tapText('Hatch this egg');
    await tester.pump(hatchDelay);
    await settle();
    await tapText('Say hello');
    await tester.enterText(find.byType(TextField), 'Mochi');
    await tester.pump();
    await tapText('Next');
    await choose('She / her');
    await choose('Calm');
    await tester.enterText(find.byType(TextField), 'Sam');
    await tester.pump();
    await tapText('Next');
    expect(find.textContaining('Nice to meet you, Sam!'), findsOneWidget);
    await choose('Doing what I can, even on hard days');
    await tapText("Let's do it");
    await tapText('Maybe later');
    await tapText('Okay');
    expect(find.text('About you'), findsOneWidget);
    await tapText('Continue');
    await tapText('Continue');
    await choose('Never');
    await choose('Under 5 hours');
    await choose('Pretty easy');
    await choose('Some');
    await choose('Rarely');
    await choose('A few people');
    await choose('Pretty good');
    await tapText('Stress or worry');
    await tapText('Next');
    await tapText('Move more');
    await tapText('Next');
    await tapText('No time');
    await tapText('Next');

    expect(find.textContaining('making your plan'), findsOneWidget);
    await tester.pump(planLoadingDelay);
    await settle();
    expect(find.text("Sam's starter plan"), findsOneWidget);
    expect(find.text('Wind down for 10 minutes before bed'), findsOneWidget);
    expect(find.text("Because you told me sleep's been short"), findsOneWidget);

    await tapText("Let's do it");
    await settle();
    await settle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.textContaining('Mochi'), findsWidgets);

    final goals = await tester.runAsync(() => db.select(db.goals).get());
    expect(goals!.map((g) => g.libraryId), [
      'get_out_of_bed',
      'drink_water',
      'three_breaths',
      'wind_down_10',
      'stretch_2min',
      'short_walk',
      'one_song_move',
    ]);

    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(db.close);
  });
}
```

In `test/app/app_shell_test.dart`, add `initialOnboardedProvider.overrideWithValue(true),` to the overrides list in `pumpApp`, and add `import 'package:zulu/app/providers.dart';` if it's missing.

- [ ] **Step 2: Run it to see it fail**

Run: `flutter test test/features/onboarding/onboarding_flow_test.dart` → Expected: FAIL (`plan_view.dart` and `initialOnboardedProvider` don't exist).

- [ ] **Step 3: Add the providers — `lib/app/providers.dart`**

```dart
/// The profile, kept up to date.
final profileProvider = StreamProvider<Profile>((ref) => ref.watch(profileRepositoryProvider).watch());

/// Whether onboarding was finished when the app started. Set by bootstrap.
final initialOnboardedProvider = Provider<bool>((ref) => false);
```

(`Profile` comes from `../data/db/database.dart`, which is already imported.)

- [ ] **Step 4: Set it in `lib/app/bootstrap.dart`**

Replace `await ProfileRepository(db, const SystemClock()).ensure();` with:

```dart
  final profile = await ProfileRepository(db, const SystemClock()).ensure();
```

and add this to the returned overrides list:

```dart
    initialOnboardedProvider.overrideWithValue(profile.onboardingDoneAt != null),
```

- [ ] **Step 5: Route through onboarding — `lib/app/router.dart`**

Replace the file with:

```dart
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../features/bag/ui/bag_screen.dart';
import '../features/home/ui/home_screen.dart';
import '../features/journal/ui/journal_screen.dart';
import '../features/me/ui/me_screen.dart';
import '../features/onboarding/ui/onboarding_screen.dart';
import '../features/shop/ui/shop_screen.dart';
import 'zulu_shell.dart';

/// Everyone who hasn't finished onboarding goes to `/onboarding`; everyone
/// who has is kept out of it.
GoRouter buildRouter(ValueListenable<bool> onboarded) => GoRouter(
      initialLocation: onboarded.value ? '/home' : '/onboarding',
      refreshListenable: onboarded,
      redirect: (context, state) {
        final inOnboarding = state.matchedLocation == '/onboarding';
        if (!onboarded.value && !inOnboarding) return '/onboarding';
        if (onboarded.value && inOnboarding) return '/home';
        return null;
      },
      routes: [
        GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => ZuluShell(shell: shell),
          branches: [
            StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/shop', builder: (context, state) => const ShopScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/bag', builder: (context, state) => const BagScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/journal', builder: (context, state) => const JournalScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/me', builder: (context, state) => const MeScreen())]),
          ],
        ),
      ],
    );
```

In `lib/app/app.dart`, replace the state class with:

```dart
class _ZuluAppState extends ConsumerState<ZuluApp> {
  late final ValueNotifier<bool> _onboarded = ValueNotifier(ref.read(initialOnboardedProvider));
  late final GoRouter _router = buildRouter(_onboarded);

  @override
  void dispose() {
    _router.dispose();
    _onboarded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(profileProvider, (previous, next) {
      final done = next.value?.onboardingDoneAt != null;
      if (next.hasValue && done != _onboarded.value) _onboarded.value = done;
    });
    final theme = ref.watch(themeKitProvider).theme;
    return MaterialApp.router(
      title: theme.appName,
      debugShowCheckedModeBanner: false,
      theme: buildZuluTheme(theme.light, Brightness.light),
      darkTheme: buildZuluTheme(theme.dark, Brightness.dark),
      routerConfig: _router,
    );
  }
}
```

- [ ] **Step 6: Implement the screens**

`lib/features/onboarding/ui/plan_view.dart`:

```dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/onboarding/plan_generator.dart';
import '../../../domain/text/template.dart';
import '../../../shared/widgets/effect_view.dart';
import '../../../shared/widgets/pet_view.dart';
import '../../../domain/pet/pet_stage.dart';
import '../../../theme_kit/effect_registry.dart';
import '../../../theme_kit/pet_manifest.dart';
import '../onboarding_controller.dart';

/// How long "making your plan" shows before the plan appears.
const planLoadingDelay = Duration(milliseconds: 1800);

/// A short "making your plan" moment, then the starter plan.
class PlanView extends ConsumerStatefulWidget {
  const PlanView({super.key, required this.plan});

  final List<PlannedGoal> plan;

  @override
  ConsumerState<PlanView> createState() => _PlanViewState();
}

class _PlanViewState extends ConsumerState<PlanView> {
  var _ready = false;
  var _saving = false;
  late final Timer _timer = Timer(planLoadingDelay, () => setState(() => _ready = true));

  @override
  void initState() {
    super.initState();
    _timer;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(onboardingControllerProvider.notifier);
    final vars = controller.vars;
    if (!_ready) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const EffectView(EffectName.planLoading, size: 120, repeat: true),
            const SizedBox(height: 16),
            Text(fillTemplate('{petName} is making your plan…', vars), style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      );
    }
    final userName = vars['userName']!;
    final title = userName == 'friend' ? 'Your starter plan' : "$userName's starter plan";
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Center(child: PetView(stage: PetStage.baby, pose: PetPose.celebrate, size: 120)),
              Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                fillTemplate('Small steps to try with {petName}. You can change them any time.', vars),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              for (final p in widget.plan)
                Card(
                  child: ListTile(
                    leading: Text(p.goal.icon, style: const TextStyle(fontSize: 28)),
                    title: Text(p.goal.title),
                    subtitle: Text('Because ${p.reason}'),
                    trailing: PopupMenuButton<String>(
                      tooltip: 'Change ${p.goal.title}',
                      onSelected: (action) => action == 'remove'
                          ? controller.removeFromPlan(p.goal.id)
                          : _swap(context, controller, p),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'swap', child: Text('Swap for something similar')),
                        if (widget.plan.length > 1) const PopupMenuItem(value: 'remove', child: Text('Remove')),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving
                  ? null
                  : () async {
                      setState(() => _saving = true);
                      await controller.acceptPlan();
                    },
              child: const Text("Let's do it"),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _swap(BuildContext context, OnboardingController controller, PlannedGoal p) async {
    final options = controller.alternativesFor(p.goal.id);
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            if (options.isEmpty) const ListTile(title: Text('Nothing similar left to swap in.')),
            for (final g in options)
              ListTile(
                leading: Text(g.icon, style: const TextStyle(fontSize: 24)),
                title: Text(g.title),
                onTap: () => Navigator.pop(context, g.id),
              ),
          ],
        ),
      ),
    );
    if (picked != null) controller.swapInPlan(p.goal.id, options.firstWhere((g) => g.id == picked));
  }
}
```

`lib/features/onboarding/ui/onboarding_screen.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../onboarding_controller.dart';
import 'plan_view.dart';
import 'section_progress_bar.dart';
import 'step_views.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: switch (async) {
          AsyncData(:final value) => Column(
              children: [
                SizedBox(
                  height: 72,
                  child: Row(
                    children: [
                      if (controller.canGoBack)
                        IconButton(tooltip: 'Back', icon: const Icon(Icons.arrow_back), onPressed: controller.back)
                      else
                        const SizedBox(width: 48),
                      Expanded(
                        child: switch (controller.progress) {
                          final progress? => SectionProgressBar(progress),
                          null => const SizedBox.shrink(),
                        },
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: value.onPlan
                      ? PlanView(plan: value.plan!)
                      : StepView(
                          key: ValueKey(value.step!.id),
                          step: value.step!,
                          vars: controller.vars,
                          initial: value.answers[value.step!.id],
                          onAnswer: controller.answer,
                        ),
                ),
              ],
            ),
          AsyncError(:final error) => Center(child: Text('Something went wrong: $error')),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}
```

In `lib/features/home/ui/home_screen.dart`, replace the widget's `build` so it greets the hatched pet:

```dart
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kit = ref.watch(themeKitProvider);
    final pet = ref.watch(petProvider).value;
    return PlaceholderScreen(
      title: 'Home',
      message: pet == null
          ? 'Welcome to ${kit.theme.appName}.'
          : 'Welcome to ${kit.theme.appName}. ${pet.name} is settling in. Your goals arrive here soon.',
      child: const PetView(stage: PetStage.baby, pose: PetPose.idle, size: 200, semanticLabel: 'Your pet'),
    );
  }
```

In that file, replace the imports with:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../domain/pet/pet_stage.dart';
import '../../../shared/widgets/pet_view.dart';
import '../../../shared/widgets/placeholder_screen.dart';
import '../../../theme_kit/pet_manifest.dart';
```

and add this to `lib/app/providers.dart`:

```dart
/// The hatched pet, or null before hatching.
final petProvider = StreamProvider<Pet?>((ref) => ref.watch(petRepositoryProvider).watch());
```

- [ ] **Step 7: Run the flow test, the app tests and the whole suite**

Run: `flutter test test/features/onboarding/onboarding_flow_test.dart` → Expected: `All tests passed!`
Run: `flutter test` → Expected: `All tests passed!`
Run: `flutter analyze` → Expected: `No issues found!`

- [ ] **Step 8: Commit**

```
git add -A
git commit -m "feat(onboarding): route new users through onboarding to their starter plan

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 11: On-device check

**Files:** none (verification only)

- [ ] **Step 1: Full verification**

Run: `flutter analyze` → Expected: `No issues found!`
Run: `flutter test` → Expected: `All tests passed!`
Run: `dart run tool/validate_assets.dart` → Expected: `Assets OK (0 warnings).`

- [ ] **Step 2: Upgrade in place on the emulator**

Run: `flutter build apk --debug`, then install with `adb install -r build\app\outputs\flutter-apk\app-debug.apk` over the Plan 1 app (keeping its version 1 database), then launch with `adb shell monkey -p com.zuluapp.zulu -c android.intent.category.LAUNCHER 1`.
Expected: the app opens on the Welcome step ("Hi there! Someone small is waiting to meet you."). It doesn't crash, which proves the version 1 → 2 migration ran.

- [ ] **Step 3: Walk through on the device**

Using `adb shell input tap` and `adb exec-out screencap -p`, take screenshots of:
- the egg picker
- a quiz question showing the four-segment progress bar
- the starter plan with "Because …" reasons
- Home after "Let's do it"

Then force-stop (`adb shell am force-stop com.zuluapp.zulu`) and relaunch. Expected: Home, not onboarding.
