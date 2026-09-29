# Zulu Plan 1 — Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A Zulu app that boots on the Android emulator into a themed five-tab shell. It loads and validates its content and art manifests, opens its on-device database, and ships generated placeholder art that the owner can replace file by file.

**Architecture:** Pure-Dart layers (`lib/core`, `lib/content`, `lib/theme_kit`, `lib/domain`) hold time, content parsing, the art manifests and the game-rule config. They never import Flutter, so the command-line asset validator can reuse them. `lib/data` wraps a Drift SQLite database. `lib/app` wires everything through Riverpod providers and a go_router shell.

**Tech Stack:**
- Flutter 3.47.5 / Dart 3.13.4
- `material_ui`, `flutter_riverpod` 3, `go_router` 18
- `drift` 2.35 + `drift_flutter`
- `lottie` 3
- dev: `drift_dev`, `build_runner`, `image` 4

**Spec:** `docs/superpowers/specs/2026-09-29-zulu-v1-design.md`

**Scope of this plan:**
- **Spec sections covered:**
  - §2 stack
  - §3 architecture
  - §4 theme and art system, except the PetView and Effect widgets and the art gallery (Plan 3)
  - §5 content system for `game_rules.json` and `goal_library.json`
  - §10 `profile` and `pet` tables
  - §12 no network
  - §13 startup and content errors
- **Later plans:**
  - Plan 2: onboarding
  - Plan 3: daily loop and pet
  - Plan 4: shop and bag
  - Plan 5: calm corner, mood, reflections, journal, daily questions, first-week intros
  - Plan 6: notifications, settings, pause, backup, release

## Global Constraints

- **Flutter isn't on PATH.** In every command, `flutter` means `C:\src\flutter\bin\flutter.bat` and `dart` means `C:\src\flutter\bin\dart.bat`. Run commands from `C:\Users\sru50\StudioProjects\zulu`.
- **Windows Developer Mode must be on** (Settings → System → For developers). Flutter needs symlinks to build plugins.
- **UI imports** come from `package:material_ui/material_ui.dart`, never `package:flutter/material.dart`. `package:flutter/foundation.dart`, `package:flutter/services.dart` and `package:flutter/widgets.dart` are fine.
- **Pure-Dart layers:** files under `lib/core/`, `lib/content/`, `lib/theme_kit/` and `lib/domain/` must not import `package:flutter/...`, `package:material_ui/...` or any Flutter-only package.
- **applicationId** is `com.zuluapp.zulu`. The app label is `Zulu`.
- **Manifest paths:** asset paths inside manifests are relative to `assets/theme/`. Full asset paths are `ThemeKit.assetPath(relative)`.
- **Content writing:**
  - All writing is original, not Finch's.
  - Never use the words "streak" or "in a row".
  - No weight or calorie goals.
  - Never blame or guilt the user.
- **No network or tracking:** no network calls, analytics or ad SDKs.
- **Commit messages** end with the line `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.

## Review Focus

These are the likeliest ways a real person hits a problem that no feature test covers. Each has a test in the task that owns it.

1. **Letter case in file names.** The owner saves `Idle.png` instead of `idle.png`. It works on Windows but is missing on Android. The validator must compare case-sensitively (Task 9, "lists file names with their exact letter case").
2. **A new art folder isn't listed in `pubspec.yaml`,** so the files silently aren't bundled. The validator must flag it (Task 9, "pubspec check flags an unlisted folder").
3. **A hand-edited JSON has a trailing comma or a wrong type.** The error must name the file and the exact field (Task 4, "errors name the file and the exact path"; Task 5, "rejects a chance outside 0–1").
4. **Using the app after midnight, before the 04:00 day start.** It must count for the previous day, across month and year ends (Task 2, "rolls back across month and year boundaries").
5. **Replacement pet art at the wrong size,** so outfits won't line up. The validator must warn (Task 9, "warns when pet art is not the canvas size").
6. **Relaunching the app.** It must not create a second profile or change the install id (Task 10, "ensure is idempotent").

---

## File Structure

```
pubspec.yaml, analysis_options.yaml, build.yaml, README.md
android/app/src/main/AndroidManifest.xml    (label → Zulu)
lib/
  main.dart                               entry: error handlers → bootstrap → runApp
  app/
    app.dart                              ZuluApp (MaterialApp.router)
    bootstrap.dart                        loads content/theme, validates (debug), opens DB → overrides
    error_handling.dart                   installErrorHandlers, logError, StartupErrorApp
    providers.dart                        core Riverpod providers
    router.dart                           GoRouter with 5-branch shell
    zulu_shell.dart                       bottom NavigationBar scaffold
    zulu_theme.dart                       ThemeData from ThemePalette + ZuluColors extension
  core/
    app_day.dart                          AppDay value type
    clock.dart                            Clock, SystemClock, FakeClock
  content/
    asset_validator.dart                  ValidationIssue, AssetValidator
    content_bundle.dart                   ContentBundle, loadContent
    goal_library.dart                     GoalSection, FocusArea, GoalTemplate, GoalLibrary
    json_reader.dart                      ContentFormatException, JsonReader, ReadText
  domain/
    pet/pet_stage.dart                    PetStage enum
    pet/trait.dart                        Trait enum
    rules/game_rules.dart                 GameRules + nested rule classes
    text/template.dart                    Pronouns, fillTemplate, templateVars, unknownPlaceholders
  theme_kit/
    effect_registry.dart                  EffectName, EffectRegistry
    icon_ref.dart                         IconRef
    item_catalog.dart                     ItemKind, ShopItem, ItemCatalog
    pet_manifest.dart                     PetPose, OutfitSlot, PoseSpec (+3 kinds), EggOption, StageArt, PetManifest
    placement.dart                        Placement
    room_manifest.dart                    Room, RoomManifest
    theme_kit.dart                        ThemeKit, loadThemeKit
    theme_manifest.dart                   ThemePalette, ThemeManifest, parseHexColor
  data/
    db/database.dart (+ database.g.dart)  Profiles, Pets tables, AppDatabase
    db/open_database.dart                 openZuluDatabase()
    repositories/pet_repository.dart      PetRepository, encode/decodeTraitStats
    repositories/profile_repository.dart  ProfileRepository
  features/{home,shop,bag,journal,me}/ui/*_screen.dart   placeholder tab screens
  shared/widgets/placeholder_screen.dart
assets/
  content/game_rules.json, goal_library.json
  theme/theme.json, icons/currency.png
  theme/pet/pet.json, pet/eggs/*.png, pet/{baby,toddler,teen,adult}/*.png
  theme/items/items.json, items/*.png
  theme/rooms/rooms.json, rooms/home/background.png
  theme/effects/effects.json, effects/*.json
tool/
  asset_files.dart                        listAssetFiles, readPngSize, checkPubspecAssetDirs
  gen_placeholders.dart                   writes placeholder PNGs + Lottie files
  validate_assets.dart                    CLI: prints issues, exit 1 on errors
test/  (mirrors lib/; helpers/read_file.dart)
```

---

### Task 1: Project scaffold

**Files:**
- Create (via `flutter create`): `pubspec.yaml`, `lib/main.dart`, `android/`, `ios/`, `.gitignore`, `.metadata`, `analysis_options.yaml`
- Modify: `pubspec.yaml`, `analysis_options.yaml`, `lib/main.dart`, `android/app/src/main/AndroidManifest.xml`
- Create: `build.yaml`, `test/app_smoke_test.dart`

**Interfaces:**
- Produces: package name `zulu` (imports are `package:zulu/...`)

- [ ] **Step 1: Confirm Developer Mode is on**

Run: `reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense`
Expected: `AllowDevelopmentWithoutDevLicense    REG_DWORD    0x1`. If it's `0x0` or missing, stop and ask the owner to turn on Developer Mode. Don't change it yourself.

- [ ] **Step 2: Create the Flutter project in the existing repo**

Run: `flutter create --org com.zuluapp --project-name zulu --platforms android,ios --empty .`
Expected: "All done!" and `lib/main.dart` created. The existing `docs/` folder is untouched.

- [ ] **Step 3: Add dependencies**

Run:
```
flutter pub add material_ui flutter_riverpod go_router drift drift_flutter path_provider path lottie
flutter pub add dev:drift_dev dev:build_runner dev:image
```
Expected: both finish with "Changed N dependencies!" and no errors.

- [ ] **Step 4: Set the description and version, and declare asset folders**

In `pubspec.yaml`, set `description: "Zulu, a gentle self-care pet."` and `version: 0.1.0+1`. Replace the `flutter:` section with:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/content/
    - assets/theme/
    - assets/theme/icons/
    - assets/theme/pet/
    - assets/theme/pet/eggs/
    - assets/theme/pet/baby/
    - assets/theme/pet/toddler/
    - assets/theme/pet/teen/
    - assets/theme/pet/adult/
    - assets/theme/items/
    - assets/theme/rooms/
    - assets/theme/rooms/home/
    - assets/theme/effects/
```

Create those folders now so the build doesn't complain, each with a `.gitkeep`:
Run (PowerShell): `'content','theme/icons','theme/pet/eggs','theme/pet/baby','theme/pet/toddler','theme/pet/teen','theme/pet/adult','theme/items','theme/rooms/home','theme/effects' | ForEach-Object { New-Item -ItemType Directory -Force "assets/$_" | Out-Null; New-Item -ItemType File -Force "assets/$_/.gitkeep" | Out-Null }`

- [ ] **Step 5: Stricter analysis and drift options**

Replace `analysis_options.yaml` with:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - build/**
  language:
    strict-casts: true
    strict-raw-types: true

linter:
  rules:
    - always_declare_return_types
    - avoid_dynamic_calls
    - prefer_final_locals
    - prefer_single_quotes
    - unawaited_futures
```

Create `build.yaml`:

```yaml
targets:
  $default:
    builders:
      drift_dev:
        options:
          store_date_time_values_as_text: true
```

- [ ] **Step 6: Label the Android app "Zulu"**

In `android/app/src/main/AndroidManifest.xml`, change `android:label="zulu"` to `android:label="Zulu"`.

- [ ] **Step 7: Write the smoke test**

Create `test/app_smoke_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/main.dart';

void main() {
  testWidgets('the placeholder app shows its name', (tester) async {
    await tester.pumpWidget(const ZuluPlaceholderApp());
    expect(find.text('Zulu'), findsOneWidget);
  });
}
```

- [ ] **Step 8: Run it to see it fail**

Run: `flutter test test/app_smoke_test.dart`
Expected: FAIL. Compilation error: `ZuluPlaceholderApp` isn't defined.

- [ ] **Step 9: Replace `lib/main.dart`**

```dart
import 'package:material_ui/material_ui.dart';

void main() => runApp(const ZuluPlaceholderApp());

/// Temporary app used until the real shell lands in Task 12.
class ZuluPlaceholderApp extends StatelessWidget {
  const ZuluPlaceholderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Zulu'))),
    );
  }
}
```

- [ ] **Step 10: Run the test and the analyzer**

Run: `flutter test test/app_smoke_test.dart` → Expected: `All tests passed!`
Run: `flutter analyze` → Expected: `No issues found!`

- [ ] **Step 11: Commit**

```
git add -A
git commit -m "chore: scaffold Zulu Flutter project

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 2: Clock and AppDay

**Files:**
- Create: `lib/core/clock.dart`, `lib/core/app_day.dart`
- Test: `test/core/clock_test.dart`, `test/core/app_day_test.dart`

**Interfaces:**
- Produces:
  - `abstract interface class Clock { DateTime now(); }`
  - `SystemClock()`
  - `FakeClock(DateTime)` with `set(DateTime)` and `advance(Duration)`
  - `AppDay(int year, int month, int day)`, which throws `FormatException` for impossible dates
  - `AppDay.of(DateTime, {int dayStartHour = 4})`
  - `AppDay.parse(String)`
  - members: `key`, `weekday`, `addDays(int)`, `daysUntil(AppDay)`, `startsAt({int dayStartHour = 4})`, `endsAt({int dayStartHour = 4})`, `isBefore`, `isAfter`, `compareTo`

- [ ] **Step 1: Write the failing tests**

`test/core/clock_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/core/clock.dart';

void main() {
  test('FakeClock returns the time it was given and can move', () {
    final clock = FakeClock(DateTime(2026, 9, 29, 9));
    expect(clock.now(), DateTime(2026, 9, 29, 9));
    clock.advance(const Duration(hours: 2));
    expect(clock.now(), DateTime(2026, 9, 29, 11));
    clock.set(DateTime(2027));
    expect(clock.now(), DateTime(2027));
  });

  test('SystemClock is close to DateTime.now()', () {
    final difference = const SystemClock().now().difference(DateTime.now()).abs();
    expect(difference, lessThan(const Duration(seconds: 1)));
  });
}
```

`test/core/app_day_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/core/app_day.dart';

void main() {
  group('AppDay.of', () {
    test('a moment before the day-start hour belongs to the previous day', () {
      expect(AppDay.of(DateTime(2026, 9, 29, 3, 59)), AppDay(2026, 9, 28));
    });

    test('the day-start hour itself begins the new day', () {
      expect(AppDay.of(DateTime(2026, 9, 29, 4)), AppDay(2026, 9, 29));
    });

    test('respects a custom day-start hour', () {
      expect(AppDay.of(DateTime(2026, 9, 29, 0, 30), dayStartHour: 0), AppDay(2026, 9, 29));
      expect(AppDay.of(DateTime(2026, 9, 29, 5, 59), dayStartHour: 6), AppDay(2026, 9, 28));
    });

    test('rolls back across month and year boundaries', () {
      expect(AppDay.of(DateTime(2026, 1, 1, 2)), AppDay(2025, 12, 31));
      expect(AppDay.of(DateTime(2026, 3, 1, 1)), AppDay(2026, 2, 28));
    });

    test('rejects an out-of-range day-start hour', () {
      expect(() => AppDay.of(DateTime(2026), dayStartHour: 24), throwsArgumentError);
    });
  });

  group('keys', () {
    test('formats with zero padding and parses back', () {
      final day = AppDay(2026, 3, 7);
      expect(day.key, '2026-03-07');
      expect(AppDay.parse('2026-03-07'), day);
    });

    test('rejects malformed and impossible dates', () {
      expect(() => AppDay.parse('2026-3-7'), throwsFormatException);
      expect(() => AppDay.parse('hello'), throwsFormatException);
      expect(() => AppDay.parse('2026-02-30'), throwsFormatException);
    });
  });

  group('arithmetic', () {
    test('addDays crosses month ends', () {
      expect(AppDay(2026, 9, 30).addDays(1), AppDay(2026, 10, 1));
      expect(AppDay(2026, 3, 1).addDays(-1), AppDay(2026, 2, 28));
    });

    test('daysUntil counts whole days in both directions', () {
      expect(AppDay(2026, 9, 1).daysUntil(AppDay(2026, 10, 1)), 30);
      expect(AppDay(2026, 10, 1).daysUntil(AppDay(2026, 9, 1)), -30);
    });

    test('weekday is ISO (Monday = 1)', () {
      expect(AppDay(2026, 9, 29).weekday, DateTime.tuesday);
    });

    test('ends when the next day starts', () {
      final day = AppDay(2026, 9, 29);
      expect(day.startsAt(), DateTime(2026, 9, 29, 4));
      expect(day.endsAt(), DateTime(2026, 9, 30, 4));
    });

    test('orders chronologically', () {
      final days = [AppDay(2026, 10, 1), AppDay(2025, 12, 31), AppDay(2026, 9, 29)]..sort();
      expect(days.map((d) => d.key), ['2025-12-31', '2026-09-29', '2026-10-01']);
      expect(AppDay(2026, 1, 1).isBefore(AppDay(2026, 1, 2)), isTrue);
      expect(AppDay(2026, 1, 2).isAfter(AppDay(2026, 1, 1)), isTrue);
    });
  });
}
```

- [ ] **Step 2: Run them to see them fail**

Run: `flutter test test/core`
Expected: FAIL. `package:zulu/core/clock.dart` and `app_day.dart` don't exist yet.

- [ ] **Step 3: Implement `lib/core/clock.dart`**

```dart
/// Source of the current time. Inject this instead of calling
/// `DateTime.now()` so rules can be tested deterministically.
abstract interface class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

/// A clock that returns a fixed time you can move by hand. For tests and
/// debug tools.
class FakeClock implements Clock {
  FakeClock(this._now);

  DateTime _now;

  @override
  DateTime now() => _now;

  void set(DateTime value) => _now = value;

  void advance(Duration by) => _now = _now.add(by);
}
```

- [ ] **Step 4: Implement `lib/core/app_day.dart`**

```dart
/// A day in the user's life. Days start at `dayStartHour` local time
/// (04:00 by default) instead of midnight, so a goal ticked off at 1 a.m.
/// still counts for the evening before.
class AppDay implements Comparable<AppDay> {
  AppDay(this.year, this.month, this.day) {
    final check = DateTime.utc(year, month, day);
    if (check.year != year || check.month != month || check.day != day) {
      throw FormatException('Not a real date: $year-$month-$day');
    }
  }

  /// The app day that [moment] falls in.
  factory AppDay.of(DateTime moment, {int dayStartHour = 4}) {
    if (dayStartHour < 0 || dayStartHour > 23) {
      throw ArgumentError.value(dayStartHour, 'dayStartHour', 'must be 0–23');
    }
    final local = moment.toLocal();
    // Calendar arithmetic rather than Duration arithmetic, so a daylight
    // saving change can't shift the result by an hour.
    final date = local.hour < dayStartHour
        ? DateTime.utc(local.year, local.month, local.day - 1)
        : DateTime.utc(local.year, local.month, local.day);
    return AppDay(date.year, date.month, date.day);
  }

  /// Parses a `YYYY-MM-DD` key produced by [key].
  factory AppDay.parse(String key) {
    final match = _keyPattern.firstMatch(key);
    if (match == null) throw FormatException('Invalid AppDay key: $key');
    return AppDay(int.parse(match[1]!), int.parse(match[2]!), int.parse(match[3]!));
  }

  static final _keyPattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

  final int year;
  final int month;
  final int day;

  /// Storage form, e.g. `2026-09-29`. Sorts correctly as a string.
  String get key => '${_pad(year, 4)}-${_pad(month, 2)}-${_pad(day, 2)}';

  /// 1 = Monday … 7 = Sunday.
  int get weekday => DateTime.utc(year, month, day).weekday;

  AppDay addDays(int days) {
    final d = DateTime.utc(year, month, day + days);
    return AppDay(d.year, d.month, d.day);
  }

  /// Whole days from this day to [other]; negative if [other] is earlier.
  int daysUntil(AppDay other) => DateTime.utc(other.year, other.month, other.day)
      .difference(DateTime.utc(year, month, day))
      .inDays;

  /// The local moment this app day begins.
  DateTime startsAt({int dayStartHour = 4}) => DateTime(year, month, day, dayStartHour);

  /// The local moment this app day ends: when the next one starts.
  DateTime endsAt({int dayStartHour = 4}) => addDays(1).startsAt(dayStartHour: dayStartHour);

  bool isBefore(AppDay other) => compareTo(other) < 0;

  bool isAfter(AppDay other) => compareTo(other) > 0;

  @override
  int compareTo(AppDay other) => key.compareTo(other.key);

  @override
  bool operator ==(Object other) => other is AppDay && other.key == key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => key;

  static String _pad(int value, int width) => value.toString().padLeft(width, '0');
}
```

- [ ] **Step 5: Run the tests to see them pass**

Run: `flutter test test/core`
Expected: `All tests passed!`

- [ ] **Step 6: Commit**

```
git add lib/core test/core
git commit -m "feat(core): add Clock and AppDay with a 4 a.m. day boundary

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 3: Templates and pronouns

**Files:**
- Create: `lib/domain/text/template.dart`
- Test: `test/domain/text/template_test.dart`

**Interfaces:**
- Produces:
  - `enum Pronouns { she, he, they }` with `subject`, `object`, `possessive`, and `static Pronouns fromId(String)` (unknown ids become `they`)
  - `String fillTemplate(String template, Map<String, String> vars)`
  - `Map<String, String> templateVars({required String userName, required String petName, required Pronouns pronouns, required String currency, required String currencyPlural})`
  - `const Set<String> templateVarNames`
  - `Set<String> unknownPlaceholders(String template)`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/domain/text/template.dart';

void main() {
  Map<String, String> vars({String userName = 'Sam', Pronouns pronouns = Pronouns.she}) => templateVars(
        userName: userName,
        petName: 'Pip',
        pronouns: pronouns,
        currency: 'coin',
        currencyPlural: 'coins',
      );

  test('fills standard placeholders', () {
    expect(fillTemplate('{petName} saved 3 {currencyPlural} for {userName}.', vars()), 'Pip saved 3 coins for Sam.');
  });

  test('uses the pet pronouns', () {
    expect(fillTemplate('{They} said {they} loves {their} hat. Tell {them}!', vars()), 'She said she loves her hat. Tell her!');
    expect(fillTemplate('{They} brought {their} map', vars(pronouns: Pronouns.they)), 'They brought their map');
  });

  test('an empty user name reads as "friend"', () {
    expect(fillTemplate('Hi {userName}!', vars(userName: '')), 'Hi friend!');
    expect(fillTemplate('Hi {userName}!', vars(userName: '   ')), 'Hi friend!');
  });

  test('leaves unknown placeholders visible', () {
    expect(fillTemplate('Hi {nmae}', vars()), 'Hi {nmae}');
  });

  test('reports unknown placeholder names', () {
    expect(unknownPlaceholders('{petName} {nmae} {They}'), {'nmae'});
    expect(unknownPlaceholders('no placeholders'), isEmpty);
  });

  test('Pronouns.fromId falls back to they', () {
    expect(Pronouns.fromId('he'), Pronouns.he);
    expect(Pronouns.fromId('xyz'), Pronouns.they);
  });
}
```

- [ ] **Step 2: Run it to see it fail**

Run: `flutter test test/domain/text/template_test.dart`
Expected: FAIL. `template.dart` doesn't exist.

- [ ] **Step 3: Implement `lib/domain/text/template.dart`**

```dart
/// The pet's pronouns, chosen during onboarding.
enum Pronouns {
  she('she', 'her', 'her'),
  he('he', 'him', 'his'),
  they('they', 'them', 'their');

  const Pronouns(this.subject, this.object, this.possessive);

  final String subject;
  final String object;
  final String possessive;

  static Pronouns fromId(String id) => Pronouns.values.asNameMap()[id] ?? Pronouns.they;
}

final _placeholder = RegExp(r'\{([a-zA-Z][a-zA-Z0-9]*)\}');

/// Every placeholder that content strings may use.
const templateVarNames = {
  'userName',
  'petName',
  'they',
  'They',
  'them',
  'their',
  'currency',
  'currencyPlural',
};

/// Replaces `{name}` placeholders with [vars]. Unknown placeholders are left
/// as-is so a typo shows up on screen instead of silently disappearing.
String fillTemplate(String template, Map<String, String> vars) =>
    template.replaceAllMapped(_placeholder, (m) => vars[m[1]!] ?? m[0]!);

/// The standard variables for [fillTemplate].
Map<String, String> templateVars({
  required String userName,
  required String petName,
  required Pronouns pronouns,
  required String currency,
  required String currencyPlural,
}) {
  final name = userName.trim();
  return {
    'userName': name.isEmpty ? 'friend' : name,
    'petName': petName,
    'they': pronouns.subject,
    'They': pronouns.subject[0].toUpperCase() + pronouns.subject.substring(1),
    'them': pronouns.object,
    'their': pronouns.possessive,
    'currency': currency,
    'currencyPlural': currencyPlural,
  };
}

/// Placeholder names in [template] that aren't in [templateVarNames].
Set<String> unknownPlaceholders(String template) => {
      for (final m in _placeholder.allMatches(template))
        if (!templateVarNames.contains(m[1])) m[1]!,
    };
```

- [ ] **Step 4: Run it to see it pass**

Run: `flutter test test/domain/text/template_test.dart`
Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```
git add lib/domain/text test/domain/text
git commit -m "feat(domain): add content templates and pet pronouns

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 4: Path-aware JSON reader

**Files:**
- Create: `lib/content/json_reader.dart`
- Test: `test/content/json_reader_test.dart`

**Interfaces:**
- Produces:
  - `class ContentFormatException implements Exception { final String file, path, message; }`, whose `toString()` is `'$file → $path: $message'`
  - `typedef ReadText = Future<String> Function(String assetPath);`
  - `class JsonReader`:
    - construction: `JsonReader(String file, Object? value, [String path = r'$'])`, `JsonReader.decode(String file, String source)`
    - properties: `file`, `path`, `value`
    - errors: `Never fail(String message)`
    - navigation: `has(key)`, `field(key)`, `optional(key)`
    - conversion: `asString()`, `asInt()`, `asDouble()`, `asBool()`, `asList()`, `asStringList()`, `asMap()`
    - shortcuts: `string(key)`, `optString(key)`, `integer(key)`, `optInt(key)`, `number(key)`, `optNumber(key)`, `boolean(key, {bool? orElse})`, `list(key)`, `strings(key)`, `optStrings(key)`, `map(key)`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/json_reader.dart';

void main() {
  test('reads typed fields', () {
    final r = JsonReader.decode('a.json', '{"name":"Pip","age":2,"ratio":0.5,"on":true,"tags":["x","y"]}');
    expect(r.string('name'), 'Pip');
    expect(r.integer('age'), 2);
    expect(r.number('ratio'), 0.5);
    expect(r.number('age'), 2.0);
    expect(r.boolean('on'), isTrue);
    expect(r.strings('tags'), ['x', 'y']);
  });

  test('optional fields return null or the fallback', () {
    final r = JsonReader.decode('a.json', '{"x":null}');
    expect(r.optString('x'), isNull);
    expect(r.optString('missing'), isNull);
    expect(r.boolean('missing', orElse: false), isFalse);
    expect(r.optStrings('missing'), isEmpty);
  });

  test('errors name the file and the exact path', () {
    final r = JsonReader.decode('goals.json', '{"goals":[{"id":"a"},{"id":7}]}');
    expect(
      () => r.list('goals')[1].string('id'),
      throwsA(isA<ContentFormatException>().having(
        (e) => e.toString(),
        'toString',
        r'goals.json → $.goals[1].id: expected a string',
      )),
    );
  });

  test('missing required fields are reported at their path', () {
    final r = JsonReader.decode('a.json', '{}');
    expect(
      () => r.string('name'),
      throwsA(isA<ContentFormatException>()
          .having((e) => e.path, 'path', r'$.name')
          .having((e) => e.message, 'message', 'is required')),
    );
  });

  test('invalid JSON is reported with the file name', () {
    expect(
      () => JsonReader.decode('broken.json', '{"a": 1,}'),
      throwsA(isA<ContentFormatException>().having((e) => e.file, 'file', 'broken.json')),
    );
  });

  test('fail() raises a custom message at the current path', () {
    final n = JsonReader.decode('a.json', '{"n":-1}').field('n');
    expect(
      () => n.fail('must be positive'),
      throwsA(isA<ContentFormatException>().having((e) => e.toString(), 'toString', r'a.json → $.n: must be positive')),
    );
  });
}
```

- [ ] **Step 2: Run it to see it fail**

Run: `flutter test test/content/json_reader_test.dart`
Expected: FAIL. `json_reader.dart` doesn't exist.

- [ ] **Step 3: Implement `lib/content/json_reader.dart`**

```dart
import 'dart:convert';

/// Reads the text of a bundled file, e.g. `rootBundle.loadString` in the app
/// or `File(path).readAsString` in tools and tests.
typedef ReadText = Future<String> Function(String assetPath);

/// Thrown when a content or theme JSON file doesn't match its schema.
class ContentFormatException implements Exception {
  ContentFormatException(this.file, this.path, this.message);

  final String file;
  final String path;
  final String message;

  @override
  String toString() => '$file → $path: $message';
}

/// Typed access to decoded JSON where every error names the file and the
/// exact field, e.g. `goal_library.json → $.goals[3].area: expected a string`.
class JsonReader {
  JsonReader(this.file, this.value, [this.path = r'$']);

  factory JsonReader.decode(String file, String source) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (e) {
      throw ContentFormatException(file, r'$', 'invalid JSON (${e.message})');
    }
    return JsonReader(file, decoded);
  }

  final String file;
  final String path;
  final Object? value;

  Never fail(String message) => throw ContentFormatException(file, path, message);

  Map<String, Object?> _asMap() {
    final v = value;
    if (v is Map<String, Object?>) return v;
    fail('expected an object');
  }

  JsonReader _child(String key) => JsonReader(file, _asMap()[key], '$path.$key');

  bool has(String key) => _asMap()[key] != null;

  JsonReader field(String key) {
    final child = _child(key);
    if (child.value == null) child.fail('is required');
    return child;
  }

  JsonReader? optional(String key) => has(key) ? _child(key) : null;

  String asString() {
    final v = value;
    if (v is String) return v;
    fail('expected a string');
  }

  int asInt() {
    final v = value;
    if (v is int) return v;
    fail('expected a whole number');
  }

  double asDouble() {
    final v = value;
    if (v is num) return v.toDouble();
    fail('expected a number');
  }

  bool asBool() {
    final v = value;
    if (v is bool) return v;
    fail('expected true or false');
  }

  List<JsonReader> asList() {
    final v = value;
    if (v is! List<Object?>) fail('expected a list');
    return [for (var i = 0; i < v.length; i++) JsonReader(file, v[i], '$path[$i]')];
  }

  List<String> asStringList() => [for (final r in asList()) r.asString()];

  Map<String, JsonReader> asMap() => {for (final key in _asMap().keys) key: _child(key)};

  String string(String key) => field(key).asString();

  String? optString(String key) => optional(key)?.asString();

  int integer(String key) => field(key).asInt();

  int? optInt(String key) => optional(key)?.asInt();

  double number(String key) => field(key).asDouble();

  double? optNumber(String key) => optional(key)?.asDouble();

  bool boolean(String key, {bool? orElse}) {
    final r = optional(key);
    if (r != null) return r.asBool();
    if (orElse != null) return orElse;
    return field(key).asBool();
  }

  List<JsonReader> list(String key) => field(key).asList();

  List<String> strings(String key) => field(key).asStringList();

  List<String> optStrings(String key) => optional(key)?.asStringList() ?? const [];

  Map<String, JsonReader> map(String key) => field(key).asMap();
}
```

- [ ] **Step 4: Run it to see it pass**

Run: `flutter test test/content/json_reader_test.dart`
Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```
git add lib/content/json_reader.dart test/content/json_reader_test.dart
git commit -m "feat(content): add path-aware JSON reader with precise errors

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 5: Pet stage, traits and game rules

**Files:**
- Create: `lib/domain/pet/pet_stage.dart`, `lib/domain/pet/trait.dart`, `lib/domain/rules/game_rules.dart`, `assets/content/game_rules.json`
- Test: `test/domain/rules/game_rules_test.dart`

**Interfaces:**
- Consumes: `JsonReader`, `ContentFormatException` (Task 4)
- Produces:
  - `enum PetStage { baby, toddler, teen, adult }`
  - `enum Trait { curiosity, resilience, compassion, logic, confidence, calm }`
  - `class GameRules`:
    - `static const fileName = 'assets/content/game_rules.json'`
    - `factory GameRules.fromJson(JsonReader)`
    - `int` fields: `dayStartHour`, `energyPerCompletion`, `energyTarget`, `lowEnergyMaxEssentialGoals`, `coinsPerCompletion`, `maxPaidCompletionsPerGoalPerDay`, `milestoneCoins`, `shopRotatingSlots`, `maxAppNotificationsPerDay`
    - other fields: `SurpriseGiftRules surpriseGift`, `AdventureRules adventure`, `Map<PetStage, int> growthThresholds`, `List<int> milestoneDays`, `TraitGainRules traits`, `ReflectionPromptRules reflectionPrompt`
  - `SurpriseGiftRules { double chance; int minCoins, maxCoins, maxPerDay }`
  - `AdventureRules { Duration duration; int rewardCoins, maxPerDay }`
  - `TraitGainRules { double startingBonus, reflection, calm, goalArea }`
  - `ReflectionPromptRules { double chance; int maxPerDay }`

- [ ] **Step 1: Write the rules file `assets/content/game_rules.json`**

```json
{
  "dayStartHour": 4,
  "energyPerCompletion": 5,
  "energyTarget": 15,
  "lowEnergyMaxEssentialGoals": 3,
  "coinsPerCompletion": 3,
  "maxPaidCompletionsPerGoalPerDay": 3,
  "surpriseGift": { "chance": 0.08, "minCoins": 5, "maxCoins": 15, "maxPerDay": 1 },
  "adventure": { "durationMinutes": 360, "rewardCoins": 20, "maxPerDay": 1 },
  "growthStages": [
    { "stage": "baby", "adventures": 0 },
    { "stage": "toddler", "adventures": 5 },
    { "stage": "teen", "adventures": 20 },
    { "stage": "adult", "adventures": 60 }
  ],
  "milestoneDays": [1, 3, 7, 14, 30, 50, 100, 200, 365],
  "milestoneCoins": 25,
  "shop": { "rotatingSlots": 6 },
  "traits": { "startingBonus": 6, "reflection": 0.5, "calm": 0.5, "goalArea": 0.2 },
  "reflectionPrompt": { "chance": 0.33, "maxPerDay": 2 },
  "notifications": { "maxAppInitiatedPerDay": 3 }
}
```

- [ ] **Step 2: Write the failing test**

`test/domain/rules/game_rules_test.dart`:

```dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/domain/pet/pet_stage.dart';
import 'package:zulu/domain/rules/game_rules.dart';

Map<String, Object?> shipped() =>
    jsonDecode(File(GameRules.fileName).readAsStringSync()) as Map<String, Object?>;

GameRules parse(Map<String, Object?> json) => GameRules.fromJson(JsonReader('game_rules.json', json));

Matcher failsAt(String path) =>
    throwsA(isA<ContentFormatException>().having((e) => e.path, 'path', path));

void main() {
  test('the shipped rules match the spec', () {
    final rules = parse(shipped());
    expect(rules.dayStartHour, 4);
    expect(rules.energyPerCompletion, 5);
    expect(rules.energyTarget, 15);
    expect(rules.lowEnergyMaxEssentialGoals, 3);
    expect(rules.coinsPerCompletion, 3);
    expect(rules.maxPaidCompletionsPerGoalPerDay, 3);
    expect(rules.surpriseGift.chance, 0.08);
    expect(rules.surpriseGift.maxPerDay, 1);
    expect(rules.adventure.duration, const Duration(hours: 6));
    expect(rules.adventure.rewardCoins, 20);
    expect(rules.growthThresholds, {
      PetStage.baby: 0,
      PetStage.toddler: 5,
      PetStage.teen: 20,
      PetStage.adult: 60,
    });
    expect(rules.milestoneDays, [1, 3, 7, 14, 30, 50, 100, 200, 365]);
    expect(rules.milestoneCoins, 25);
    expect(rules.shopRotatingSlots, 6);
    expect(rules.traits.startingBonus, 6);
    expect(rules.reflectionPrompt.maxPerDay, 2);
    expect(rules.maxAppNotificationsPerDay, 3);
  });

  test('rejects a chance outside 0–1', () {
    final json = shipped();
    json['surpriseGift'] = {...json['surpriseGift']! as Map<String, Object?>, 'chance': 1.5};
    expect(() => parse(json), failsAt(r'$.surpriseGift.chance'));
  });

  test('rejects growth stages that are out of order', () {
    final json = shipped();
    json['growthStages'] = [
      {'stage': 'baby', 'adventures': 0},
      {'stage': 'toddler', 'adventures': 30},
      {'stage': 'teen', 'adventures': 20},
      {'stage': 'adult', 'adventures': 60},
    ];
    expect(() => parse(json), failsAt(r'$.growthStages'));
  });

  test('rejects a baby stage that needs adventures', () {
    final json = shipped();
    json['growthStages'] = [
      {'stage': 'baby', 'adventures': 1},
      {'stage': 'toddler', 'adventures': 5},
      {'stage': 'teen', 'adventures': 20},
      {'stage': 'adult', 'adventures': 60},
    ];
    expect(() => parse(json), failsAt(r'$.growthStages'));
  });

  test('rejects a zero energy target', () {
    final json = shipped()..['energyTarget'] = 0;
    expect(() => parse(json), failsAt(r'$.energyTarget'));
  });
}
```

- [ ] **Step 3: Run it to see it fail**

Run: `flutter test test/domain/rules/game_rules_test.dart`
Expected: FAIL. `pet_stage.dart` and `game_rules.dart` don't exist.

- [ ] **Step 4: Implement the enums**

`lib/domain/pet/pet_stage.dart`:

```dart
/// How grown-up the pet is. Stages come from total adventures, which never
/// go down.
enum PetStage { baby, toddler, teen, adult }
```

`lib/domain/pet/trait.dart`:

```dart
/// Personality traits. They only flavor the pet's stories and dialogue.
enum Trait { curiosity, resilience, compassion, logic, confidence, calm }
```

- [ ] **Step 5: Implement `lib/domain/rules/game_rules.dart`**

```dart
import '../../content/json_reader.dart';
import '../pet/pet_stage.dart';

class SurpriseGiftRules {
  const SurpriseGiftRules({
    required this.chance,
    required this.minCoins,
    required this.maxCoins,
    required this.maxPerDay,
  });

  final double chance;
  final int minCoins;
  final int maxCoins;
  final int maxPerDay;
}

class AdventureRules {
  const AdventureRules({required this.duration, required this.rewardCoins, required this.maxPerDay});

  final Duration duration;
  final int rewardCoins;
  final int maxPerDay;
}

class TraitGainRules {
  const TraitGainRules({
    required this.startingBonus,
    required this.reflection,
    required this.calm,
    required this.goalArea,
  });

  final double startingBonus;
  final double reflection;
  final double calm;
  final double goalArea;
}

class ReflectionPromptRules {
  const ReflectionPromptRules({required this.chance, required this.maxPerDay});

  final double chance;
  final int maxPerDay;
}

/// Every tunable number in the daily loop (spec §7). Loaded from
/// [fileName] so balance can change without code changes.
class GameRules {
  const GameRules({
    required this.dayStartHour,
    required this.energyPerCompletion,
    required this.energyTarget,
    required this.lowEnergyMaxEssentialGoals,
    required this.coinsPerCompletion,
    required this.maxPaidCompletionsPerGoalPerDay,
    required this.surpriseGift,
    required this.adventure,
    required this.growthThresholds,
    required this.milestoneDays,
    required this.milestoneCoins,
    required this.shopRotatingSlots,
    required this.traits,
    required this.reflectionPrompt,
    required this.maxAppNotificationsPerDay,
  });

  static const fileName = 'assets/content/game_rules.json';

  final int dayStartHour;
  final int energyPerCompletion;
  final int energyTarget;
  final int lowEnergyMaxEssentialGoals;
  final int coinsPerCompletion;
  final int maxPaidCompletionsPerGoalPerDay;
  final SurpriseGiftRules surpriseGift;
  final AdventureRules adventure;

  /// Total adventures needed to reach each stage.
  final Map<PetStage, int> growthThresholds;
  final List<int> milestoneDays;
  final int milestoneCoins;
  final int shopRotatingSlots;
  final TraitGainRules traits;
  final ReflectionPromptRules reflectionPrompt;
  final int maxAppNotificationsPerDay;

  factory GameRules.fromJson(JsonReader r) {
    int positive(JsonReader parent, String key) {
      final v = parent.integer(key);
      if (v <= 0) parent.field(key).fail('must be greater than 0');
      return v;
    }

    double fraction(JsonReader parent, String key) {
      final v = parent.number(key);
      if (v < 0 || v > 1) parent.field(key).fail('must be between 0 and 1');
      return v;
    }

    final dayStartHour = r.integer('dayStartHour');
    if (dayStartHour < 0 || dayStartHour > 23) r.field('dayStartHour').fail('must be 0–23');

    final gift = r.field('surpriseGift');
    final minCoins = positive(gift, 'minCoins');
    final maxCoins = positive(gift, 'maxCoins');
    if (maxCoins < minCoins) gift.field('maxCoins').fail('must be at least minCoins');

    final growth = <PetStage, int>{};
    for (final s in r.list('growthStages')) {
      final stage = PetStage.values.asNameMap()[s.string('stage')] ??
          s.field('stage').fail('expected baby, toddler, teen or adult');
      if (growth.containsKey(stage)) s.field('stage').fail('listed twice');
      growth[stage] = s.integer('adventures');
    }
    final ordered = [
      for (final stage in PetStage.values)
        growth[stage] ?? r.field('growthStages').fail('missing stage "${stage.name}"'),
    ];
    if (ordered.first != 0) r.field('growthStages').fail('baby must need 0 adventures');
    for (var i = 1; i < ordered.length; i++) {
      if (ordered[i] <= ordered[i - 1]) {
        r.field('growthStages').fail('each stage must need more adventures than the one before');
      }
    }

    final milestones = [for (final m in r.list('milestoneDays')) m.asInt()];
    for (var i = 0; i < milestones.length; i++) {
      if (milestones[i] <= (i == 0 ? 0 : milestones[i - 1])) {
        r.field('milestoneDays').fail('must be positive and increasing');
      }
    }

    final adventure = r.field('adventure');
    final traits = r.field('traits');
    final reflection = r.field('reflectionPrompt');

    return GameRules(
      dayStartHour: dayStartHour,
      energyPerCompletion: positive(r, 'energyPerCompletion'),
      energyTarget: positive(r, 'energyTarget'),
      lowEnergyMaxEssentialGoals: positive(r, 'lowEnergyMaxEssentialGoals'),
      coinsPerCompletion: positive(r, 'coinsPerCompletion'),
      maxPaidCompletionsPerGoalPerDay: positive(r, 'maxPaidCompletionsPerGoalPerDay'),
      surpriseGift: SurpriseGiftRules(
        chance: fraction(gift, 'chance'),
        minCoins: minCoins,
        maxCoins: maxCoins,
        maxPerDay: positive(gift, 'maxPerDay'),
      ),
      adventure: AdventureRules(
        duration: Duration(minutes: positive(adventure, 'durationMinutes')),
        rewardCoins: positive(adventure, 'rewardCoins'),
        maxPerDay: positive(adventure, 'maxPerDay'),
      ),
      growthThresholds: growth,
      milestoneDays: milestones,
      milestoneCoins: positive(r, 'milestoneCoins'),
      shopRotatingSlots: positive(r.field('shop'), 'rotatingSlots'),
      traits: TraitGainRules(
        startingBonus: traits.number('startingBonus'),
        reflection: traits.number('reflection'),
        calm: traits.number('calm'),
        goalArea: traits.number('goalArea'),
      ),
      reflectionPrompt: ReflectionPromptRules(
        chance: fraction(reflection, 'chance'),
        maxPerDay: positive(reflection, 'maxPerDay'),
      ),
      maxAppNotificationsPerDay: positive(r.field('notifications'), 'maxAppInitiatedPerDay'),
    );
  }
}
```

- [ ] **Step 6: Run it to see it pass**

Run: `flutter test test/domain/rules/game_rules_test.dart`
Expected: `All tests passed!`

- [ ] **Step 7: Commit**

```
git add lib/domain/pet lib/domain/rules assets/content/game_rules.json test/domain/rules
git commit -m "feat(domain): add pet stages, traits and tunable game rules

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 6: Goal library and content bundle

**Files:**
- Create: `lib/content/goal_library.dart`, `lib/content/content_bundle.dart`, `assets/content/goal_library.json`, `test/helpers/read_file.dart`
- Test: `test/content/goal_library_test.dart`, `test/content/content_bundle_test.dart`

**Interfaces:**
- Consumes: `JsonReader`, `ReadText` (Task 4); `Trait` (Task 5); `GameRules` (Task 5)
- Produces:
  - `enum GoalSection { startOfDay('start_day'), anyTime('any_time'), endOfDay('end_day') }` with `id` and `static GoalSection? tryParse(String)`
  - `class FocusArea { String id, label, icon; Trait trait; }`
  - `class GoalTemplate { String id, title, icon, area; GoalSection section; bool essential, starter; List<String> tags; }`
  - `class GoalLibrary`:
    - `static const fileName`
    - `List<FocusArea> areas`, `List<GoalTemplate> goals`
    - `byId(String) → GoalTemplate?`, `area(String) → FocusArea?`
    - `inArea(String) → List<GoalTemplate>`, `startersIn(String) → List<GoalTemplate>`
    - `factory GoalLibrary.fromJson(JsonReader)`
  - `class ContentBundle { GameRules rules; GoalLibrary goals; }`
  - `Future<ContentBundle> loadContent(ReadText read)`
  - test helper: `Future<String> readFile(String path)`

- [ ] **Step 1: Write the goal library `assets/content/goal_library.json`**

```json
{
  "areas": [
    { "id": "calmer_mind", "label": "Calmer mind", "icon": "🌿", "trait": "calm" },
    { "id": "rest_sleep", "label": "Rest and sleep", "icon": "🌙", "trait": "calm" },
    { "id": "move_more", "label": "Move more", "icon": "💫", "trait": "confidence" },
    { "id": "eat_well", "label": "Eat well", "icon": "🥣", "trait": "resilience" },
    { "id": "feel_fresh", "label": "Feel fresh", "icon": "🫧", "trait": "confidence" },
    { "id": "focus", "label": "Focus and get things done", "icon": "🎯", "trait": "logic" },
    { "id": "kinder_to_myself", "label": "Be kinder to myself", "icon": "💛", "trait": "compassion" },
    { "id": "notice_good", "label": "Notice the good", "icon": "🌸", "trait": "curiosity" },
    { "id": "connect", "label": "Connect with people", "icon": "💬", "trait": "compassion" },
    { "id": "steady_routine", "label": "A steady routine", "icon": "🌤️", "trait": "resilience" }
  ],
  "goals": [
    { "id": "three_breaths", "title": "Take 3 slow breaths", "icon": "🌬️", "area": "calmer_mind", "section": "any_time", "essential": true, "starter": true },
    { "id": "name_feeling", "title": "Name how you feel", "icon": "🏷️", "area": "calmer_mind", "section": "any_time", "starter": true },
    { "id": "quiet_minute", "title": "Sit quietly for 1 minute", "icon": "🪷", "area": "calmer_mind", "section": "any_time", "starter": true },
    { "id": "worry_note", "title": "Write down one worry", "icon": "📝", "area": "calmer_mind", "section": "any_time" },
    { "id": "fresh_air", "title": "Get some fresh air", "icon": "🍃", "area": "calmer_mind", "section": "any_time" },
    { "id": "calm_corner", "title": "Visit the calm corner", "icon": "🫧", "area": "calmer_mind", "section": "any_time" },

    { "id": "wind_down_10", "title": "Wind down for 10 minutes before bed", "icon": "🌙", "area": "rest_sleep", "section": "end_day", "starter": true },
    { "id": "phone_away_bed", "title": "Put the phone away before sleep", "icon": "📵", "area": "rest_sleep", "section": "end_day", "starter": true },
    { "id": "rest_break", "title": "Take a short rest", "icon": "😌", "area": "rest_sleep", "section": "any_time", "essential": true },
    { "id": "usual_bedtime", "title": "Head to bed at your usual time", "icon": "🛏️", "area": "rest_sleep", "section": "end_day" },
    { "id": "daylight", "title": "Let some daylight in", "icon": "☀️", "area": "rest_sleep", "section": "start_day" },
    { "id": "caffeine_early", "title": "Keep caffeine to the morning", "icon": "☕", "area": "rest_sleep", "section": "any_time" },

    { "id": "stretch_2min", "title": "Gentle stretch for 2 minutes", "icon": "🧘", "area": "move_more", "section": "any_time", "essential": true, "starter": true },
    { "id": "short_walk", "title": "Take a short walk", "icon": "🚶", "area": "move_more", "section": "any_time", "starter": true, "tags": ["walking"] },
    { "id": "one_song_move", "title": "Move to one song", "icon": "🎵", "area": "move_more", "section": "any_time", "starter": true },
    { "id": "change_position", "title": "Change position and move a little", "icon": "🔄", "area": "move_more", "section": "any_time" },
    { "id": "move_your_way", "title": "Move in a way that feels good", "icon": "💫", "area": "move_more", "section": "any_time" },
    { "id": "shoulder_rolls", "title": "Roll your shoulders", "icon": "🙆", "area": "move_more", "section": "any_time" },

    { "id": "drink_water", "title": "Drink a glass of water", "icon": "💧", "area": "eat_well", "section": "any_time", "essential": true, "starter": true },
    { "id": "morning_bite", "title": "Eat something in the morning", "icon": "🥣", "area": "eat_well", "section": "start_day", "starter": true },
    { "id": "pause_for_meal", "title": "Pause for a meal", "icon": "🍽️", "area": "eat_well", "section": "any_time", "starter": true },
    { "id": "fruit_or_veg", "title": "Add a fruit or veggie to a meal", "icon": "🍎", "area": "eat_well", "section": "any_time" },
    { "id": "cook_simple", "title": "Make yourself something simple", "icon": "🍳", "area": "eat_well", "section": "any_time" },
    { "id": "water_nearby", "title": "Keep water nearby", "icon": "🫗", "area": "eat_well", "section": "start_day" },

    { "id": "brush_teeth_am", "title": "Brush your teeth", "icon": "🪥", "area": "feel_fresh", "section": "start_day", "essential": true, "starter": true },
    { "id": "wash_face", "title": "Wash your face", "icon": "🧼", "area": "feel_fresh", "section": "start_day", "starter": true },
    { "id": "shower", "title": "Take a shower", "icon": "🚿", "area": "feel_fresh", "section": "any_time", "starter": true },
    { "id": "brush_teeth_pm", "title": "Brush your teeth before bed", "icon": "🦷", "area": "feel_fresh", "section": "end_day" },
    { "id": "fresh_clothes", "title": "Put on fresh clothes", "icon": "👕", "area": "feel_fresh", "section": "start_day" },
    { "id": "tidy_one_thing", "title": "Tidy one small thing", "icon": "🧺", "area": "feel_fresh", "section": "any_time" },

    { "id": "one_small_task", "title": "Do one small task", "icon": "✅", "area": "focus", "section": "any_time", "essential": true, "starter": true },
    { "id": "top_three", "title": "Pick today's top 3", "icon": "🗒️", "area": "focus", "section": "start_day", "starter": true },
    { "id": "focus_10", "title": "Focus for 10 minutes", "icon": "⏱️", "area": "focus", "section": "any_time", "starter": true },
    { "id": "phone_away_focus", "title": "Phone away while you focus", "icon": "📱", "area": "focus", "section": "any_time" },
    { "id": "tiny_todo", "title": "Clear one tiny to-do", "icon": "📥", "area": "focus", "section": "any_time" },
    { "id": "start_messy", "title": "Start something, even messily", "icon": "🚀", "area": "focus", "section": "any_time" },

    { "id": "kind_word", "title": "Say something kind to yourself", "icon": "💛", "area": "kinder_to_myself", "section": "any_time", "starter": true },
    { "id": "did_well", "title": "Notice one thing you did well", "icon": "🏅", "area": "kinder_to_myself", "section": "end_day", "starter": true },
    { "id": "happy_thing", "title": "Do one thing that makes you happy", "icon": "😊", "area": "kinder_to_myself", "section": "any_time", "starter": true },
    { "id": "guilt_free_break", "title": "Take a break without guilt", "icon": "🛋️", "area": "kinder_to_myself", "section": "any_time" },
    { "id": "let_it_go", "title": "Let one mistake go", "icon": "🕊️", "area": "kinder_to_myself", "section": "any_time" },
    { "id": "just_be", "title": "Just be today", "icon": "🌱", "area": "kinder_to_myself", "section": "any_time", "essential": true, "tags": ["survival"] },

    { "id": "one_good_thing", "title": "Write one good thing", "icon": "🙏", "area": "notice_good", "section": "end_day", "starter": true },
    { "id": "something_beautiful", "title": "Notice something beautiful", "icon": "🌸", "area": "notice_good", "section": "any_time", "starter": true },
    { "id": "slow_moment", "title": "Enjoy one moment slowly", "icon": "🍵", "area": "notice_good", "section": "any_time", "starter": true },
    { "id": "nice_photo", "title": "Take a photo of something nice", "icon": "📷", "area": "notice_good", "section": "any_time" },
    { "id": "thank_someone", "title": "Thank someone", "icon": "💌", "area": "notice_good", "section": "any_time" },
    { "id": "favorite_song", "title": "Listen to a song you love", "icon": "🎧", "area": "notice_good", "section": "any_time" },

    { "id": "message_friend", "title": "Message a friend", "icon": "💬", "area": "connect", "section": "any_time", "starter": true },
    { "id": "call_someone", "title": "Call someone you care about", "icon": "📞", "area": "connect", "section": "any_time", "starter": true },
    { "id": "say_hi", "title": "Say hi to someone", "icon": "👋", "area": "connect", "section": "any_time", "starter": true },
    { "id": "share_snack", "title": "Share a meal or snack with someone", "icon": "🥪", "area": "connect", "section": "any_time" },
    { "id": "reply_message", "title": "Reply to a message you've been meaning to", "icon": "📨", "area": "connect", "section": "any_time" },
    { "id": "plan_time", "title": "Plan time with someone", "icon": "📅", "area": "connect", "section": "any_time" },

    { "id": "get_out_of_bed", "title": "Get out of bed", "icon": "🌅", "area": "steady_routine", "section": "start_day", "essential": true, "starter": true, "tags": ["survival"] },
    { "id": "make_bed", "title": "Make your bed", "icon": "🛏", "area": "steady_routine", "section": "start_day", "starter": true },
    { "id": "ready_for_tomorrow", "title": "Get ready for tomorrow", "icon": "🎒", "area": "steady_routine", "section": "end_day", "starter": true },
    { "id": "start_your_way", "title": "Start the day your way", "icon": "🌤️", "area": "steady_routine", "section": "start_day" },
    { "id": "usual_wake", "title": "Wake up around your usual time", "icon": "⏰", "area": "steady_routine", "section": "start_day" },
    { "id": "take_meds", "title": "Take your medication", "icon": "💊", "area": "steady_routine", "section": "start_day", "tags": ["medication"] }
  ]
}
```

- [ ] **Step 2: Create the test helper `test/helpers/read_file.dart`**

```dart
import 'dart:io';

/// Reads a project file the way `rootBundle.loadString` reads an asset.
Future<String> readFile(String path) => File(path).readAsString();
```

- [ ] **Step 3: Write the failing tests**

`test/content/goal_library_test.dart`:

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/goal_library.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/domain/pet/trait.dart';

Matcher failsAt(String path) =>
    throwsA(isA<ContentFormatException>().having((e) => e.path, 'path', path));

GoalLibrary parse(String json) => GoalLibrary.fromJson(JsonReader.decode('g.json', json));

void main() {
  late GoalLibrary library;

  setUpAll(() {
    library = GoalLibrary.fromJson(
      JsonReader.decode(GoalLibrary.fileName, File(GoalLibrary.fileName).readAsStringSync()),
    );
  });

  test('has the ten focus areas from the spec, in order', () {
    expect(library.areas.map((a) => a.id), [
      'calmer_mind',
      'rest_sleep',
      'move_more',
      'eat_well',
      'feel_fresh',
      'focus',
      'kinder_to_myself',
      'notice_good',
      'connect',
      'steady_routine',
    ]);
    expect(library.area('connect')?.trait, Trait.compassion);
  });

  test('every area offers at least two starter goals', () {
    for (final area in library.areas) {
      expect(library.startersIn(area.id).length, greaterThanOrEqualTo(2), reason: area.id);
    }
  });

  test('has enough essential goals for low-energy days', () {
    expect(library.goals.where((g) => g.essential).length, greaterThanOrEqualTo(6));
  });

  test('includes the foundation goals as essential', () {
    expect(library.byId('get_out_of_bed')?.essential, isTrue);
    expect(library.byId('drink_water')?.essential, isTrue);
    expect(library.byId('get_out_of_bed')?.section, GoalSection.startOfDay);
  });

  test('contains no weight or calorie language', () {
    final banned = RegExp(r'weight|calorie|diet|\bkg\b|\blbs?\b|\bfat\b|skinny|burn', caseSensitive: false);
    for (final goal in library.goals) {
      expect(banned.hasMatch(goal.title), isFalse, reason: goal.title);
    }
  });

  test('rejects an unknown area', () {
    expect(
      () => parse('{"areas":[{"id":"a","label":"A","icon":"x","trait":"calm"}],'
          '"goals":[{"id":"g","title":"G","icon":"x","area":"b","section":"any_time"}]}'),
      failsAt(r'$.goals[0].area'),
    );
  });

  test('rejects duplicate goal ids', () {
    expect(
      () => parse('{"areas":[{"id":"a","label":"A","icon":"x","trait":"calm"}],'
          '"goals":[{"id":"g","title":"G","icon":"x","area":"a","section":"any_time"},'
          '{"id":"g","title":"H","icon":"x","area":"a","section":"any_time"}]}'),
      failsAt(r'$.goals[1].id'),
    );
  });

  test('rejects an unknown trait and an unknown section', () {
    expect(
      () => parse('{"areas":[{"id":"a","label":"A","icon":"x","trait":"bravery"}],"goals":[]}'),
      failsAt(r'$.areas[0].trait'),
    );
    expect(
      () => parse('{"areas":[{"id":"a","label":"A","icon":"x","trait":"calm"}],'
          '"goals":[{"id":"g","title":"G","icon":"x","area":"a","section":"noon"}]}'),
      failsAt(r'$.goals[0].section'),
    );
  });
}
```

`test/content/content_bundle_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/content_bundle.dart';

import '../helpers/read_file.dart';

void main() {
  test('loads the shipped content', () async {
    final content = await loadContent(readFile);
    expect(content.rules.energyTarget, 15);
    expect(content.goals.goals, isNotEmpty);
  });
}
```

- [ ] **Step 4: Run them to see them fail**

Run: `flutter test test/content`
Expected: FAIL. `goal_library.dart` and `content_bundle.dart` don't exist.

- [ ] **Step 5: Implement `lib/content/goal_library.dart`**

```dart
import '../domain/pet/trait.dart';
import 'json_reader.dart';

/// Where a goal sits in the day's list.
enum GoalSection {
  startOfDay('start_day'),
  anyTime('any_time'),
  endOfDay('end_day');

  const GoalSection(this.id);

  final String id;

  static GoalSection? tryParse(String id) {
    for (final s in values) {
      if (s.id == id) return s;
    }
    return null;
  }
}

class FocusArea {
  const FocusArea({required this.id, required this.label, required this.icon, required this.trait});

  final String id;
  final String label;
  final String icon;

  /// The trait that grows when the user completes goals in this area.
  final Trait trait;
}

/// A curated goal the user can add. User goals copy these fields, so later
/// edits to the library never change someone's existing goals.
class GoalTemplate {
  const GoalTemplate({
    required this.id,
    required this.title,
    required this.icon,
    required this.area,
    required this.section,
    required this.essential,
    required this.starter,
    required this.tags,
  });

  final String id;
  final String title;

  /// An emoji.
  final String icon;
  final String area;
  final GoalSection section;

  /// Shown on low-energy days.
  final bool essential;

  /// Offered first when building a starter plan for this area.
  final bool starter;
  final List<String> tags;
}

class GoalLibrary {
  GoalLibrary({required this.areas, required this.goals})
      : _goalsById = {for (final g in goals) g.id: g},
        _areasById = {for (final a in areas) a.id: a};

  static const fileName = 'assets/content/goal_library.json';

  final List<FocusArea> areas;
  final List<GoalTemplate> goals;
  final Map<String, GoalTemplate> _goalsById;
  final Map<String, FocusArea> _areasById;

  GoalTemplate? byId(String id) => _goalsById[id];

  FocusArea? area(String id) => _areasById[id];

  List<GoalTemplate> inArea(String areaId) => [for (final g in goals) if (g.area == areaId) g];

  List<GoalTemplate> startersIn(String areaId) =>
      [for (final g in goals) if (g.area == areaId && g.starter) g];

  factory GoalLibrary.fromJson(JsonReader r) {
    final areas = <FocusArea>[];
    final areaIds = <String>{};
    for (final a in r.list('areas')) {
      final id = a.string('id');
      if (!areaIds.add(id)) a.field('id').fail('duplicate area id "$id"');
      final traitField = a.field('trait');
      final trait = Trait.values.asNameMap()[traitField.asString()] ??
          traitField.fail('unknown trait "${traitField.asString()}"');
      areas.add(FocusArea(id: id, label: a.string('label'), icon: a.string('icon'), trait: trait));
    }

    final goals = <GoalTemplate>[];
    final goalIds = <String>{};
    for (final g in r.list('goals')) {
      final id = g.string('id');
      if (!goalIds.add(id)) g.field('id').fail('duplicate goal id "$id"');
      final area = g.string('area');
      if (!areaIds.contains(area)) g.field('area').fail('unknown area "$area"');
      final section = GoalSection.tryParse(g.string('section')) ??
          g.field('section').fail('expected start_day, any_time or end_day');
      goals.add(GoalTemplate(
        id: id,
        title: g.string('title'),
        icon: g.string('icon'),
        area: area,
        section: section,
        essential: g.boolean('essential', orElse: false),
        starter: g.boolean('starter', orElse: false),
        tags: g.optStrings('tags'),
      ));
    }
    return GoalLibrary(areas: areas, goals: goals);
  }
}
```

- [ ] **Step 6: Implement `lib/content/content_bundle.dart`**

```dart
import '../domain/rules/game_rules.dart';
import 'goal_library.dart';
import 'json_reader.dart';

/// All bundled content, loaded once at startup. Later plans add onboarding,
/// dialogue, stories and the rest.
class ContentBundle {
  const ContentBundle({required this.rules, required this.goals});

  final GameRules rules;
  final GoalLibrary goals;
}

Future<ContentBundle> loadContent(ReadText read) async {
  Future<JsonReader> open(String path) async => JsonReader.decode(path, await read(path));
  return ContentBundle(
    rules: GameRules.fromJson(await open(GameRules.fileName)),
    goals: GoalLibrary.fromJson(await open(GoalLibrary.fileName)),
  );
}
```

- [ ] **Step 7: Run them to see them pass**

Run: `flutter test test/content`
Expected: `All tests passed!`

- [ ] **Step 8: Commit**

```
git add lib/content assets/content/goal_library.json test/content test/helpers
git commit -m "feat(content): add curated goal library and content bundle loader

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 7: Theme kit manifests

**Files:**
- Create:
  - `lib/theme_kit/icon_ref.dart`, `placement.dart`, `theme_manifest.dart`, `pet_manifest.dart`, `item_catalog.dart`, `room_manifest.dart`, `effect_registry.dart`, `theme_kit.dart`
  - `assets/theme/theme.json`, `assets/theme/pet/pet.json`, `assets/theme/items/items.json`, `assets/theme/rooms/rooms.json`, `assets/theme/effects/effects.json`
- Test: `test/theme_kit/theme_manifest_test.dart`, `test/theme_kit/pet_manifest_test.dart`, `test/theme_kit/theme_kit_test.dart`

**Interfaces:**
- Consumes: `JsonReader`, `ReadText` (Task 4); `PetStage` (Task 5)
- Produces:
  - `IconRef(String value)` with `bool isImage`
  - `Placement({required double x, required double y, double scale = 1})` and `Placement.fromJson`
  - `ThemePalette` with int ARGB fields `primary`, `background`, `surface`, `text`, `energy`, `success`
  - `int parseHexColor(JsonReader)`
  - `ThemeManifest`: `appName`, `petSpecies`, `petSpeciesPlural`, `currency`, `currencyPlural`, `IconRef currencyIcon`, `ThemePalette light, dark`, `List<IconRef> moodIcons`, `fileName`
  - `enum PetPose { idle, happy, curious, sleepy, away, celebrate, hatch }`
  - `enum OutfitSlot { head, face, neck, body, held }`
  - `sealed class PoseSpec { String path; }`, with subclasses `PngPose`, `RivePose` (`artboard`, `stateMachine`, `trigger`) and `LottiePose` (`loop`)
  - `EggOption { id, image }`
  - `StageArt { Map<PetPose, PoseSpec> poses; Map<OutfitSlot, Placement> anchors; }`
  - `PetManifest`: `canvasSize`, `eggs`, `stages`, `pose(PetStage, PetPose) → PoseSpec`, `anchors(PetStage) → Map<OutfitSlot, Placement>`, `fileName`
  - `enum ItemKind { outfit, decor }`
  - `ShopItem { id, name, kind, slot, price, image, everyday }`
  - `ItemCatalog(List<ShopItem>)` with `items`, `byId`, `fileName`
  - `Room { id, background, width, height, Placement pet, Map<String, Placement> slots }`
  - `RoomManifest(List<Room>)` with `home`, `fileName`
  - `enum EffectName { goalDone('goal_done'), coinsBurst, energyFull, hatchCrack, planLoading, adventureDepart, adventureReturn, milestone, evolve, surpriseGift }` with `id`
  - `EffectRegistry(Map<EffectName, String>)` with `fileFor(EffectName) → String?`, `fileName`
  - `ThemeKit`: `theme`, `pet`, `items`, `rooms`, `effects`, `static String assetPath(String relative)`
  - `Future<ThemeKit> loadThemeKit(ReadText read)`

- [ ] **Step 1: Write the manifests**

`assets/theme/theme.json`:

```json
{
  "appName": "Zulu",
  "petSpecies": { "singular": "critter", "plural": "critters" },
  "currency": { "singular": "coin", "plural": "coins", "icon": "icons/currency.png" },
  "colors": {
    "light": { "primary": "#6C8CFF", "background": "#FFF8F0", "surface": "#FFFFFF", "text": "#2B2B2B", "energy": "#FFC857", "success": "#4CAF7A" },
    "dark": { "primary": "#8FA6FF", "background": "#1C1B22", "surface": "#26252D", "text": "#F2F0EA", "energy": "#FFD37A", "success": "#6CCB96" }
  },
  "moodIcons": ["😞", "🙁", "😐", "🙂", "😄"]
}
```

`assets/theme/pet/pet.json`:

```json
{
  "canvas": 512,
  "eggs": [
    { "id": "sunrise", "image": "pet/eggs/sunrise.png" },
    { "id": "sky", "image": "pet/eggs/sky.png" },
    { "id": "mint", "image": "pet/eggs/mint.png" },
    { "id": "lilac", "image": "pet/eggs/lilac.png" },
    { "id": "blush", "image": "pet/eggs/blush.png" },
    { "id": "sand", "image": "pet/eggs/sand.png" }
  ],
  "stages": {
    "baby": {
      "poses": {
        "idle": { "type": "png", "path": "pet/baby/idle.png" },
        "happy": { "type": "png", "path": "pet/baby/happy.png" },
        "curious": { "type": "png", "path": "pet/baby/curious.png" },
        "sleepy": { "type": "png", "path": "pet/baby/sleepy.png" },
        "away": { "type": "png", "path": "pet/baby/away.png" },
        "celebrate": { "type": "png", "path": "pet/baby/celebrate.png" },
        "hatch": { "type": "png", "path": "pet/baby/hatch.png" }
      },
      "anchors": {
        "head": { "x": 256, "y": 200, "scale": 1.0 },
        "face": { "x": 256, "y": 278, "scale": 1.0 },
        "neck": { "x": 256, "y": 345, "scale": 1.0 },
        "body": { "x": 256, "y": 360, "scale": 1.0 },
        "held": { "x": 400, "y": 330, "scale": 0.9 }
      }
    },
    "toddler": {
      "poses": {
        "idle": { "type": "png", "path": "pet/toddler/idle.png" },
        "happy": { "type": "png", "path": "pet/toddler/happy.png" },
        "curious": { "type": "png", "path": "pet/toddler/curious.png" },
        "sleepy": { "type": "png", "path": "pet/toddler/sleepy.png" },
        "away": { "type": "png", "path": "pet/toddler/away.png" },
        "celebrate": { "type": "png", "path": "pet/toddler/celebrate.png" },
        "hatch": { "type": "png", "path": "pet/toddler/hatch.png" }
      },
      "anchors": {
        "head": { "x": 256, "y": 175, "scale": 1.15 },
        "face": { "x": 256, "y": 273, "scale": 1.15 },
        "neck": { "x": 256, "y": 355, "scale": 1.15 },
        "body": { "x": 256, "y": 375, "scale": 1.2 },
        "held": { "x": 400, "y": 330, "scale": 1.0 }
      }
    },
    "teen": {
      "poses": {
        "idle": { "type": "png", "path": "pet/teen/idle.png" },
        "happy": { "type": "png", "path": "pet/teen/happy.png" },
        "curious": { "type": "png", "path": "pet/teen/curious.png" },
        "sleepy": { "type": "png", "path": "pet/teen/sleepy.png" },
        "away": { "type": "png", "path": "pet/teen/away.png" },
        "celebrate": { "type": "png", "path": "pet/teen/celebrate.png" },
        "hatch": { "type": "png", "path": "pet/teen/hatch.png" }
      },
      "anchors": {
        "head": { "x": 256, "y": 155, "scale": 1.3 },
        "face": { "x": 256, "y": 269, "scale": 1.3 },
        "neck": { "x": 256, "y": 362, "scale": 1.3 },
        "body": { "x": 256, "y": 390, "scale": 1.35 },
        "held": { "x": 400, "y": 330, "scale": 1.1 }
      }
    },
    "adult": {
      "poses": {
        "idle": { "type": "png", "path": "pet/adult/idle.png" },
        "happy": { "type": "png", "path": "pet/adult/happy.png" },
        "curious": { "type": "png", "path": "pet/adult/curious.png" },
        "sleepy": { "type": "png", "path": "pet/adult/sleepy.png" },
        "away": { "type": "png", "path": "pet/adult/away.png" },
        "celebrate": { "type": "png", "path": "pet/adult/celebrate.png" },
        "hatch": { "type": "png", "path": "pet/adult/hatch.png" }
      },
      "anchors": {
        "head": { "x": 256, "y": 135, "scale": 1.45 },
        "face": { "x": 256, "y": 265, "scale": 1.45 },
        "neck": { "x": 256, "y": 370, "scale": 1.45 },
        "body": { "x": 256, "y": 400, "scale": 1.5 },
        "held": { "x": 400, "y": 330, "scale": 1.2 }
      }
    }
  }
}
```

`assets/theme/items/items.json`:

```json
{
  "items": [
    { "id": "sun_hat", "name": "Sun hat", "kind": "outfit", "slot": "head", "price": 120, "image": "items/sun_hat.png" },
    { "id": "flower_crown", "name": "Flower crown", "kind": "outfit", "slot": "head", "price": 90, "image": "items/flower_crown.png" },
    { "id": "round_glasses", "name": "Round glasses", "kind": "outfit", "slot": "face", "price": 40, "image": "items/round_glasses.png", "everyday": true },
    { "id": "star_glasses", "name": "Star glasses", "kind": "outfit", "slot": "face", "price": 150, "image": "items/star_glasses.png" },
    { "id": "cozy_scarf", "name": "Cozy scarf", "kind": "outfit", "slot": "neck", "price": 50, "image": "items/cozy_scarf.png", "everyday": true },
    { "id": "bow_tie", "name": "Bow tie", "kind": "outfit", "slot": "neck", "price": 70, "image": "items/bow_tie.png" },
    { "id": "rain_coat", "name": "Rain coat", "kind": "outfit", "slot": "body", "price": 220, "image": "items/rain_coat.png" },
    { "id": "sweater", "name": "Sweater", "kind": "outfit", "slot": "body", "price": 180, "image": "items/sweater.png" },
    { "id": "balloon", "name": "Balloon", "kind": "outfit", "slot": "held", "price": 60, "image": "items/balloon.png" },
    { "id": "tea_cup", "name": "Tea cup", "kind": "outfit", "slot": "held", "price": 30, "image": "items/tea_cup.png" },
    { "id": "potted_plant", "name": "Potted plant", "kind": "decor", "slot": "floor_left", "price": 60, "image": "items/potted_plant.png", "everyday": true },
    { "id": "floor_lamp", "name": "Floor lamp", "kind": "decor", "slot": "floor_right", "price": 140, "image": "items/floor_lamp.png" },
    { "id": "star_poster", "name": "Star poster", "kind": "decor", "slot": "wall_left", "price": 80, "image": "items/star_poster.png" },
    { "id": "wall_clock", "name": "Wall clock", "kind": "decor", "slot": "wall_right", "price": 100, "image": "items/wall_clock.png" },
    { "id": "wind_chime", "name": "Wind chime", "kind": "decor", "slot": "window", "price": 300, "image": "items/wind_chime.png" }
  ]
}
```

`assets/theme/rooms/rooms.json`:

```json
{
  "rooms": [
    {
      "id": "home",
      "background": "rooms/home/background.png",
      "width": 1080,
      "height": 1080,
      "pet": { "x": 540, "y": 720, "scale": 1.2 },
      "slots": {
        "wall_left": { "x": 220, "y": 330 },
        "wall_right": { "x": 860, "y": 330 },
        "window": { "x": 540, "y": 260 },
        "floor_left": { "x": 190, "y": 820 },
        "floor_right": { "x": 890, "y": 820 }
      }
    }
  ]
}
```

`assets/theme/effects/effects.json`:

```json
{
  "effects": {
    "goal_done": "effects/goal_done.json",
    "coins_burst": "effects/coins_burst.json",
    "energy_full": "effects/energy_full.json",
    "hatch_crack": "effects/hatch_crack.json",
    "plan_loading": "effects/plan_loading.json",
    "adventure_depart": "effects/adventure_depart.json",
    "adventure_return": "effects/adventure_return.json",
    "milestone": "effects/milestone.json",
    "evolve": "effects/evolve.json",
    "surprise_gift": "effects/surprise_gift.json"
  }
}
```

- [ ] **Step 2: Write the failing tests**

`test/theme_kit/theme_manifest_test.dart`:

```dart
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
```

`test/theme_kit/pet_manifest_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/domain/pet/pet_stage.dart';
import 'package:zulu/theme_kit/pet_manifest.dart';

Matcher failsAt(String path) =>
    throwsA(isA<ContentFormatException>().having((e) => e.path, 'path', path));

PetManifest parse(String stagesJson) => PetManifest.fromJson(JsonReader.decode(
      'pet.json',
      '{"canvas":512,"eggs":[{"id":"e","image":"pet/eggs/e.png"}],"stages":$stagesJson}',
    ));

void main() {
  final manifest = parse('{'
      '"baby":{"poses":{"idle":{"type":"png","path":"b/idle.png"},"happy":{"type":"lottie","path":"b/happy.json","loop":false}},'
      '"anchors":{"head":{"x":1,"y":2}}},'
      '"teen":{"poses":{"idle":{"type":"rive","path":"t/pet.riv","stateMachine":"Main","trigger":"idle"}}}'
      '}');

  test('returns the exact pose when it exists', () {
    final happy = manifest.pose(PetStage.baby, PetPose.happy);
    expect(happy, isA<LottiePose>().having((p) => p.loop, 'loop', isFalse));
    expect(happy.path, 'b/happy.json');
  });

  test('falls back to the same stage idle pose', () {
    final pose = manifest.pose(PetStage.teen, PetPose.sleepy);
    expect(pose, isA<RivePose>().having((p) => p.stateMachine, 'stateMachine', 'Main'));
  });

  test('falls back to the baby idle pose for a stage with no art', () {
    expect(manifest.pose(PetStage.adult, PetPose.happy).path, 'b/idle.png');
  });

  test('stages without anchors reuse the baby anchors', () {
    expect(manifest.anchors(PetStage.teen)[OutfitSlot.head]?.x, 1);
    expect(manifest.anchors(PetStage.teen)[OutfitSlot.head]?.scale, 1);
  });

  test('requires a baby idle pose', () {
    expect(() => parse('{"baby":{"poses":{"happy":{"type":"png","path":"x.png"}}}}'), failsAt(r'$.stages'));
  });

  test('rejects unknown pose types, poses and stages at their path', () {
    expect(
      () => parse('{"baby":{"poses":{"idle":{"type":"gif","path":"x.gif"}}}}'),
      failsAt(r'$.stages.baby.poses.idle.type'),
    );
    expect(
      () => parse('{"baby":{"poses":{"idle":{"type":"png","path":"x.png"},"dance":{"type":"png","path":"y.png"}}}}'),
      failsAt(r'$.stages.baby.poses.dance'),
    );
    expect(
      () => parse('{"baby":{"poses":{"idle":{"type":"png","path":"x.png"}}},"elder":{"poses":{}}}'),
      failsAt(r'$.stages.elder'),
    );
  });
}
```

`test/theme_kit/theme_kit_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/domain/pet/pet_stage.dart';
import 'package:zulu/theme_kit/effect_registry.dart';
import 'package:zulu/theme_kit/item_catalog.dart';
import 'package:zulu/theme_kit/pet_manifest.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../helpers/read_file.dart';

void main() {
  test('loads the shipped manifests', () async {
    final kit = await loadThemeKit(readFile);
    expect(kit.theme.appName, 'Zulu');
    expect(kit.theme.light.primary, 0xFF6C8CFF);
    expect(kit.pet.eggs, hasLength(6));
    expect(kit.pet.stages.keys, containsAll(PetStage.values));
    expect(kit.pet.pose(PetStage.adult, PetPose.hatch).path, 'pet/adult/hatch.png');
    expect(kit.items.byId('cozy_scarf')?.kind, ItemKind.outfit);
    expect(kit.items.items.where((i) => i.everyday), hasLength(3));
    expect(kit.rooms.home.slots.keys, containsAll(['wall_left', 'wall_right', 'window', 'floor_left', 'floor_right']));
    expect(kit.effects.fileFor(EffectName.goalDone), 'effects/goal_done.json');
    expect(ThemeKit.assetPath('pet/baby/idle.png'), 'assets/theme/pet/baby/idle.png');
  });
}
```

- [ ] **Step 3: Run them to see them fail**

Run: `flutter test test/theme_kit`
Expected: FAIL. The `theme_kit` files don't exist.

- [ ] **Step 4: Implement the small value types**

`lib/theme_kit/icon_ref.dart`:

```dart
/// An icon that is either an emoji/text glyph or an image path relative to
/// `assets/theme/`.
class IconRef {
  const IconRef(this.value);

  final String value;

  static final _imagePattern = RegExp(r'\.(png|webp|jpe?g)$', caseSensitive: false);

  bool get isImage => _imagePattern.hasMatch(value);
}
```

`lib/theme_kit/placement.dart`:

```dart
import '../content/json_reader.dart';

/// A point (and size multiplier) on an art canvas, in canvas pixels.
class Placement {
  const Placement({required this.x, required this.y, this.scale = 1});

  factory Placement.fromJson(JsonReader r) =>
      Placement(x: r.number('x'), y: r.number('y'), scale: r.optNumber('scale') ?? 1);

  final double x;
  final double y;
  final double scale;
}
```

- [ ] **Step 5: Implement `lib/theme_kit/theme_manifest.dart`**

```dart
import '../content/json_reader.dart';
import 'icon_ref.dart';

final _hexColor = RegExp(r'^#([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$');

/// Parses `#RRGGBB` (opaque) or `#AARRGGBB` into a 32-bit ARGB int.
int parseHexColor(JsonReader r) {
  final match = _hexColor.firstMatch(r.asString());
  if (match == null) r.fail('expected a color like #RRGGBB or #AARRGGBB');
  final hex = match[1]!;
  return int.parse(hex.length == 6 ? 'FF$hex' : hex, radix: 16);
}

/// One color scheme (light or dark), as ARGB ints so this file stays
/// Flutter-free.
class ThemePalette {
  const ThemePalette({
    required this.primary,
    required this.background,
    required this.surface,
    required this.text,
    required this.energy,
    required this.success,
  });

  factory ThemePalette.fromJson(JsonReader r) => ThemePalette(
        primary: parseHexColor(r.field('primary')),
        background: parseHexColor(r.field('background')),
        surface: parseHexColor(r.field('surface')),
        text: parseHexColor(r.field('text')),
        energy: parseHexColor(r.field('energy')),
        success: parseHexColor(r.field('success')),
      );

  final int primary;
  final int background;
  final int surface;
  final int text;
  final int energy;
  final int success;
}

/// Names and colors of the owner's world (`assets/theme/theme.json`).
class ThemeManifest {
  const ThemeManifest({
    required this.appName,
    required this.petSpecies,
    required this.petSpeciesPlural,
    required this.currency,
    required this.currencyPlural,
    required this.currencyIcon,
    required this.light,
    required this.dark,
    required this.moodIcons,
  });

  static const fileName = 'assets/theme/theme.json';

  final String appName;
  final String petSpecies;
  final String petSpeciesPlural;
  final String currency;
  final String currencyPlural;
  final IconRef currencyIcon;
  final ThemePalette light;
  final ThemePalette dark;

  /// Five icons, from lowest mood to highest.
  final List<IconRef> moodIcons;

  factory ThemeManifest.fromJson(JsonReader r) {
    final species = r.field('petSpecies');
    final currency = r.field('currency');
    final colors = r.field('colors');
    final moods = r.list('moodIcons');
    if (moods.length != 5) r.field('moodIcons').fail('needs exactly 5 icons, from lowest to highest mood');
    return ThemeManifest(
      appName: r.string('appName'),
      petSpecies: species.string('singular'),
      petSpeciesPlural: species.string('plural'),
      currency: currency.string('singular'),
      currencyPlural: currency.string('plural'),
      currencyIcon: IconRef(currency.string('icon')),
      light: ThemePalette.fromJson(colors.field('light')),
      dark: ThemePalette.fromJson(colors.field('dark')),
      moodIcons: [for (final m in moods) IconRef(m.asString())],
    );
  }
}
```

- [ ] **Step 6: Implement `lib/theme_kit/pet_manifest.dart`**

```dart
import '../content/json_reader.dart';
import '../domain/pet/pet_stage.dart';
import 'placement.dart';

enum PetPose { idle, happy, curious, sleepy, away, celebrate, hatch }

/// Where outfit items attach to the pet.
enum OutfitSlot { head, face, neck, body, held }

/// How one pose is drawn. [path] is relative to `assets/theme/`.
sealed class PoseSpec {
  const PoseSpec(this.path);

  final String path;
}

final class PngPose extends PoseSpec {
  const PngPose(super.path);
}

final class RivePose extends PoseSpec {
  const RivePose(super.path, {this.artboard, this.stateMachine, this.trigger});

  final String? artboard;
  final String? stateMachine;

  /// State-machine trigger fired when this pose is shown.
  final String? trigger;
}

final class LottiePose extends PoseSpec {
  const LottiePose(super.path, {this.loop = true});

  final bool loop;
}

class EggOption {
  const EggOption({required this.id, required this.image});

  final String id;
  final String image;
}

class StageArt {
  const StageArt({required this.poses, required this.anchors});

  final Map<PetPose, PoseSpec> poses;
  final Map<OutfitSlot, Placement> anchors;
}

/// The pet's art (`assets/theme/pet/pet.json`). Any stage or pose may be
/// missing except the baby idle pose, which every fallback ends at.
class PetManifest {
  const PetManifest({required this.canvasSize, required this.eggs, required this.stages});

  static const fileName = 'assets/theme/pet/pet.json';

  /// Pet art is square; anchors are in pixels on this canvas.
  final double canvasSize;
  final List<EggOption> eggs;
  final Map<PetStage, StageArt> stages;

  /// The art for [pose] at [stage], falling back to that stage's idle pose,
  /// then to the baby idle pose.
  PoseSpec pose(PetStage stage, PetPose pose) =>
      stages[stage]?.poses[pose] ??
      stages[stage]?.poses[PetPose.idle] ??
      stages[PetStage.baby]!.poses[PetPose.idle]!;

  /// Where outfits sit at [stage]. Stages without anchors reuse the baby's.
  Map<OutfitSlot, Placement> anchors(PetStage stage) {
    final own = stages[stage]?.anchors;
    return (own == null || own.isEmpty) ? stages[PetStage.baby]!.anchors : own;
  }

  factory PetManifest.fromJson(JsonReader r) {
    final stages = <PetStage, StageArt>{};
    for (final entry in r.map('stages').entries) {
      final stage = PetStage.values.asNameMap()[entry.key] ??
          entry.value.fail('unknown stage "${entry.key}" (expected baby, toddler, teen or adult)');
      final poses = <PetPose, PoseSpec>{};
      for (final p in entry.value.map('poses').entries) {
        final pose = PetPose.values.asNameMap()[p.key] ?? p.value.fail('unknown pose "${p.key}"');
        poses[pose] = _poseSpec(p.value);
      }
      final anchors = <OutfitSlot, Placement>{};
      final anchorsJson = entry.value.optional('anchors');
      if (anchorsJson != null) {
        for (final a in anchorsJson.asMap().entries) {
          final slot = OutfitSlot.values.asNameMap()[a.key] ?? a.value.fail('unknown outfit slot "${a.key}"');
          anchors[slot] = Placement.fromJson(a.value);
        }
      }
      stages[stage] = StageArt(poses: poses, anchors: anchors);
    }
    if (stages[PetStage.baby]?.poses[PetPose.idle] == null) {
      r.field('stages').fail('the baby stage must have an idle pose');
    }
    return PetManifest(
      canvasSize: r.number('canvas'),
      eggs: [for (final e in r.list('eggs')) EggOption(id: e.string('id'), image: e.string('image'))],
      stages: stages,
    );
  }
}

PoseSpec _poseSpec(JsonReader r) => switch (r.string('type')) {
      'png' => PngPose(r.string('path')),
      'rive' => RivePose(
          r.string('path'),
          artboard: r.optString('artboard'),
          stateMachine: r.optString('stateMachine'),
          trigger: r.optString('trigger'),
        ),
      'lottie' => LottiePose(r.string('path'), loop: r.boolean('loop', orElse: true)),
      final other => r.field('type').fail('unknown pose type "$other" (expected png, rive or lottie)'),
    };
```

- [ ] **Step 7: Implement items, rooms and effects**

`lib/theme_kit/item_catalog.dart`:

```dart
import '../content/json_reader.dart';
import 'pet_manifest.dart';

enum ItemKind { outfit, decor }

class ShopItem {
  const ShopItem({
    required this.id,
    required this.name,
    required this.kind,
    required this.slot,
    required this.price,
    required this.image,
    required this.everyday,
  });

  final String id;
  final String name;
  final ItemKind kind;

  /// An [OutfitSlot] name for outfits, a room slot id for decor.
  final String slot;
  final int price;
  final String image;

  /// Always for sale, as opposed to rotating daily.
  final bool everyday;
}

/// Everything that can be bought (`assets/theme/items/items.json`).
class ItemCatalog {
  ItemCatalog(this.items) : _byId = {for (final i in items) i.id: i};

  static const fileName = 'assets/theme/items/items.json';

  final List<ShopItem> items;
  final Map<String, ShopItem> _byId;

  ShopItem? byId(String id) => _byId[id];

  factory ItemCatalog.fromJson(JsonReader r) {
    final items = <ShopItem>[];
    final ids = <String>{};
    for (final i in r.list('items')) {
      final id = i.string('id');
      if (!ids.add(id)) i.field('id').fail('duplicate item id "$id"');
      final kind = ItemKind.values.asNameMap()[i.string('kind')] ?? i.field('kind').fail('expected outfit or decor');
      final slot = i.string('slot');
      if (kind == ItemKind.outfit && !OutfitSlot.values.asNameMap().containsKey(slot)) {
        i.field('slot').fail('outfit slot must be one of ${OutfitSlot.values.map((s) => s.name).join(', ')}');
      }
      final price = i.integer('price');
      if (price <= 0) i.field('price').fail('must be greater than 0');
      items.add(ShopItem(
        id: id,
        name: i.string('name'),
        kind: kind,
        slot: slot,
        price: price,
        image: i.string('image'),
        everyday: i.boolean('everyday', orElse: false),
      ));
    }
    return ItemCatalog(items);
  }
}
```

`lib/theme_kit/room_manifest.dart`:

```dart
import '../content/json_reader.dart';
import 'placement.dart';

class Room {
  const Room({
    required this.id,
    required this.background,
    required this.width,
    required this.height,
    required this.pet,
    required this.slots,
  });

  final String id;
  final String background;
  final double width;
  final double height;

  /// Where the pet stands, on the room canvas.
  final Placement pet;

  /// Named spots where decor items go.
  final Map<String, Placement> slots;
}

/// The pet's home (`assets/theme/rooms/rooms.json`). v1 uses the first room.
class RoomManifest {
  const RoomManifest(this.rooms);

  static const fileName = 'assets/theme/rooms/rooms.json';

  final List<Room> rooms;

  Room get home => rooms.first;

  factory RoomManifest.fromJson(JsonReader r) {
    final rooms = [
      for (final room in r.list('rooms'))
        Room(
          id: room.string('id'),
          background: room.string('background'),
          width: room.number('width'),
          height: room.number('height'),
          pet: Placement.fromJson(room.field('pet')),
          slots: {for (final s in room.map('slots').entries) s.key: Placement.fromJson(s.value)},
        ),
    ];
    if (rooms.isEmpty) r.field('rooms').fail('needs at least one room');
    return RoomManifest(rooms);
  }
}
```

`lib/theme_kit/effect_registry.dart`:

```dart
import '../content/json_reader.dart';

/// Every moment that can play a celebration effect (spec §4.5).
enum EffectName {
  goalDone('goal_done'),
  coinsBurst('coins_burst'),
  energyFull('energy_full'),
  hatchCrack('hatch_crack'),
  planLoading('plan_loading'),
  adventureDepart('adventure_depart'),
  adventureReturn('adventure_return'),
  milestone('milestone'),
  evolve('evolve'),
  surpriseGift('surprise_gift');

  const EffectName(this.id);

  final String id;
}

/// Maps effects to Lottie files (`assets/theme/effects/effects.json`).
/// Effects without a file use a built-in animation.
class EffectRegistry {
  const EffectRegistry(this.files);

  static const fileName = 'assets/theme/effects/effects.json';

  final Map<EffectName, String> files;

  String? fileFor(EffectName name) => files[name];

  factory EffectRegistry.fromJson(JsonReader r) {
    final byId = {for (final n in EffectName.values) n.id: n};
    final files = <EffectName, String>{};
    for (final e in r.map('effects').entries) {
      final name = byId[e.key] ?? e.value.fail('unknown effect "${e.key}"');
      files[name] = e.value.asString();
    }
    return EffectRegistry(files);
  }
}
```

- [ ] **Step 8: Implement `lib/theme_kit/theme_kit.dart`**

```dart
import '../content/json_reader.dart';
import 'effect_registry.dart';
import 'item_catalog.dart';
import 'pet_manifest.dart';
import 'room_manifest.dart';
import 'theme_manifest.dart';

/// Everything visual and every in-world name, loaded from `assets/theme/`.
class ThemeKit {
  const ThemeKit({
    required this.theme,
    required this.pet,
    required this.items,
    required this.rooms,
    required this.effects,
  });

  static const root = 'assets/theme/';

  final ThemeManifest theme;
  final PetManifest pet;
  final ItemCatalog items;
  final RoomManifest rooms;
  final EffectRegistry effects;

  /// The full asset path for a path written relative to `assets/theme/`.
  static String assetPath(String relative) => '$root$relative';
}

Future<ThemeKit> loadThemeKit(ReadText read) async {
  Future<JsonReader> open(String path) async => JsonReader.decode(path, await read(path));
  return ThemeKit(
    theme: ThemeManifest.fromJson(await open(ThemeManifest.fileName)),
    pet: PetManifest.fromJson(await open(PetManifest.fileName)),
    items: ItemCatalog.fromJson(await open(ItemCatalog.fileName)),
    rooms: RoomManifest.fromJson(await open(RoomManifest.fileName)),
    effects: EffectRegistry.fromJson(await open(EffectRegistry.fileName)),
  );
}
```

- [ ] **Step 9: Run them to see them pass**

Run: `flutter test test/theme_kit`
Expected: `All tests passed!`

- [ ] **Step 10: Commit**

```
git add lib/theme_kit assets/theme test/theme_kit
git commit -m "feat(theme): add swappable art manifests with pose fallbacks

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 8: Placeholder art generator

**Files:**
- Create: `tool/gen_placeholders.dart`
- Generated and committed:
  - `assets/theme/pet/eggs/*.png` (6)
  - `assets/theme/pet/{baby,toddler,teen,adult}/*.png` (28)
  - `assets/theme/items/*.png` (15)
  - `assets/theme/rooms/home/background.png`
  - `assets/theme/icons/currency.png`
  - `assets/theme/effects/*.json` (10)
- Test: `test/theme_kit/placeholder_art_test.dart`

**Interfaces:**
- Consumes: `loadThemeKit`, `ThemeKit.assetPath`, `EffectName`, `PngPose` (Task 7)

- [ ] **Step 1: Write the failing test**

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:lottie/lottie.dart';
import 'package:zulu/theme_kit/effect_registry.dart';
import 'package:zulu/theme_kit/pet_manifest.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../helpers/read_file.dart';

void main() {
  late ThemeKit kit;

  setUpAll(() async => kit = await loadThemeKit(readFile));

  test('every registered effect is a valid Lottie animation', () {
    for (final name in EffectName.values) {
      final path = kit.effects.fileFor(name);
      if (path == null) continue;
      final bytes = File(ThemeKit.assetPath(path)).readAsBytesSync();
      final composition = LottieComposition.parseJsonBytes(bytes);
      expect(composition.duration, greaterThan(Duration.zero), reason: name.id);
    }
  });

  test('every PNG pet pose decodes at the canvas size', () {
    for (final stage in kit.pet.stages.values) {
      for (final pose in stage.poses.values.whereType<PngPose>()) {
        final image = img.decodePng(File(ThemeKit.assetPath(pose.path)).readAsBytesSync());
        expect(image, isNotNull, reason: pose.path);
        expect(image!.width, kit.pet.canvasSize, reason: pose.path);
        expect(image.height, kit.pet.canvasSize, reason: pose.path);
      }
    }
  });

  test('every item and egg image decodes', () {
    final paths = [
      for (final item in kit.items.items) item.image,
      for (final egg in kit.pet.eggs) egg.image,
      kit.rooms.home.background,
    ];
    for (final path in paths) {
      expect(img.decodePng(File(ThemeKit.assetPath(path)).readAsBytesSync()), isNotNull, reason: path);
    }
  });
}
```

- [ ] **Step 2: Run it to see it fail**

Run: `flutter test test/theme_kit/placeholder_art_test.dart`
Expected: FAIL with `PathNotFoundException` (for example `assets/theme/effects/goal_done.json`).

- [ ] **Step 3: Implement `tool/gen_placeholders.dart`**

```dart
// Generates Zulu's placeholder art: simple PNGs and small Lottie files.
// Every file keeps the name the manifests expect, so the owner's real art
// can replace these one file at a time.
//
// Run from the project root:  dart run tool/gen_placeholders.dart
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

const _theme = 'assets/theme';

void main() {
  _eggs();
  _pet();
  _items();
  _room();
  _icons();
  _effects();
  stdout.writeln('Placeholder art written to $_theme/');
}

img.Color _rgba(int hex, [int alpha = 255]) =>
    img.ColorRgba8((hex >> 16) & 0xFF, (hex >> 8) & 0xFF, hex & 0xFF, alpha);

img.Image _canvas(int width, int height) => img.Image(width: width, height: height, numChannels: 4);

void _save(img.Image image, String relative) {
  final file = File('$_theme/$relative')..parent.createSync(recursive: true);
  file.writeAsBytesSync(img.encodePng(image));
}

void _fillEllipse(img.Image image, {required int cx, required int cy, required int rx, required int ry, required img.Color color}) {
  for (var y = -ry; y <= ry; y++) {
    final half = (rx * math.sqrt(1 - (y * y) / (ry * ry))).round();
    img.drawLine(image, x1: cx - half, y1: cy + y, x2: cx + half, y2: cy + y, color: color);
  }
}

// ---- Eggs ----

const _eggColors = {
  'sunrise': 0xFFB38A,
  'sky': 0x8EC5FF,
  'mint': 0x9BE3C3,
  'lilac': 0xC7B3FF,
  'blush': 0xFFB3CF,
  'sand': 0xE8D5A8,
};

void _eggs() {
  for (final entry in _eggColors.entries) {
    final image = _canvas(256, 320);
    _fillEllipse(image, cx: 128, cy: 170, rx: 100, ry: 135, color: _rgba(entry.value));
    for (final (x, y, r) in [(90, 120, 16), (160, 150, 20), (110, 230, 14), (170, 240, 12)]) {
      img.fillCircle(image, x: x, y: y, radius: r, color: _rgba(0xFFFFFF, 140), antialias: true);
    }
    _save(image, 'pet/eggs/${entry.key}.png');
  }
}

// ---- Pet ----

const _stageRadius = {'baby': 110, 'toddler': 135, 'teen': 155, 'adult': 175};
const _poses = ['idle', 'happy', 'curious', 'sleepy', 'away', 'celebrate', 'hatch'];

void _pet() {
  for (final stage in _stageRadius.entries) {
    for (final pose in _poses) {
      _save(_petPose(stage.value, pose), 'pet/${stage.key}/$pose.png');
    }
  }
}

img.Image _petPose(int r, String pose) {
  final image = _canvas(512, 512);
  const cx = 256, cy = 300;
  final alpha = pose == 'away' ? 110 : 255;
  final body = _rgba(0xFFC48A, alpha);
  final ink = _rgba(0x3A2E2A, alpha);
  final beak = _rgba(0xF2A23A, alpha);

  if (pose == 'celebrate') {
    for (final side in [-1, 1]) {
      img.fillCircle(image, x: cx + side * (r + 10), y: cy - r ~/ 2, radius: r ~/ 4, color: body, antialias: true);
    }
  }
  img.fillCircle(image, x: cx, y: cy, radius: r, color: body, antialias: true);

  final eyeY = cy - r ~/ 5;
  final eyeDx = r ~/ 3;
  final eyeR = math.max(6, r ~/ 12);
  switch (pose) {
    case 'sleepy':
      for (final dx in [-eyeDx, eyeDx]) {
        img.drawLine(image, x1: cx + dx - eyeR, y1: eyeY, x2: cx + dx + eyeR, y2: eyeY, color: ink, thickness: 4);
      }
    case 'happy' || 'celebrate':
      for (final dx in [-eyeDx, eyeDx]) {
        img.drawLine(image, x1: cx + dx - eyeR, y1: eyeY + eyeR ~/ 2, x2: cx + dx, y2: eyeY - eyeR ~/ 2, color: ink, thickness: 4);
        img.drawLine(image, x1: cx + dx, y1: eyeY - eyeR ~/ 2, x2: cx + dx + eyeR, y2: eyeY + eyeR ~/ 2, color: ink, thickness: 4);
      }
    case 'curious':
      img.fillCircle(image, x: cx - eyeDx, y: eyeY, radius: eyeR, color: ink, antialias: true);
      img.fillCircle(image, x: cx + eyeDx, y: eyeY, radius: eyeR + 4, color: ink, antialias: true);
      img.drawString(image, '?', font: img.arial48, x: cx + r - 20, y: cy - r - 40, color: ink);
    default:
      for (final dx in [-eyeDx, eyeDx]) {
        img.fillCircle(image, x: cx + dx, y: eyeY, radius: eyeR, color: ink, antialias: true);
      }
  }
  img.fillPolygon(
    image,
    vertices: [img.Point(cx - 10, eyeY + eyeR + 8), img.Point(cx + 10, eyeY + eyeR + 8), img.Point(cx, eyeY + eyeR + 22)],
    color: beak,
  );

  if (pose == 'hatch') {
    final shellTop = cy + r ~/ 4;
    img.fillRect(image, x1: cx - r - 20, y1: shellTop, x2: cx + r + 20, y2: cy + r + 30, color: _rgba(0xFFF3E0), radius: 30);
    for (var x = cx - r - 20; x < cx + r + 20; x += 30) {
      img.drawLine(image, x1: x, y1: shellTop, x2: x + 15, y2: shellTop - 15, color: ink, thickness: 3);
      img.drawLine(image, x1: x + 15, y1: shellTop - 15, x2: x + 30, y2: shellTop, color: ink, thickness: 3);
    }
  }

  img.drawString(image, pose, font: img.arial24, x: 16, y: 16, color: _rgba(0x888888));
  return image;
}

// ---- Items ----

const _itemArt = <String, (int, String)>{
  'sun_hat': (0xF6C453, 'hat'),
  'flower_crown': (0xF49AC1, 'crown'),
  'round_glasses': (0x3A2E2A, 'glasses'),
  'star_glasses': (0xF6C453, 'glasses'),
  'cozy_scarf': (0xE85D5D, 'scarf'),
  'bow_tie': (0x6C8CFF, 'bow'),
  'rain_coat': (0xF6D55C, 'coat'),
  'sweater': (0x8FD3B6, 'coat'),
  'balloon': (0xFF7A7A, 'balloon'),
  'tea_cup': (0xFFFFFF, 'cup'),
  'potted_plant': (0x5BAE6A, 'plant'),
  'floor_lamp': (0xF6C453, 'lamp'),
  'star_poster': (0x6C8CFF, 'poster'),
  'wall_clock': (0xFFFFFF, 'clock'),
  'wind_chime': (0x9BD3E8, 'chime'),
};

void _items() {
  final ink = _rgba(0x3A2E2A);
  for (final entry in _itemArt.entries) {
    final (hex, shape) = entry.value;
    final c = _rgba(hex);
    final image = _canvas(256, 256);
    switch (shape) {
      case 'hat':
        img.fillPolygon(image, vertices: [img.Point(128, 40), img.Point(40, 190), img.Point(216, 190)], color: c);
        img.fillRect(image, x1: 20, y1: 180, x2: 236, y2: 205, color: c, radius: 10);
      case 'crown':
        for (var i = 0; i < 5; i++) {
          img.fillCircle(image, x: 48 + i * 40, y: 128, radius: 22, color: c, antialias: true);
        }
      case 'glasses':
        for (final x in [80, 176]) {
          img.drawCircle(image, x: x, y: 128, radius: 40, color: c, antialias: true);
          img.drawCircle(image, x: x, y: 128, radius: 38, color: c, antialias: true);
        }
        img.drawLine(image, x1: 120, y1: 128, x2: 136, y2: 128, color: c, thickness: 4);
      case 'scarf' || 'bow':
        img.fillRect(image, x1: 30, y1: 100, x2: 226, y2: 156, color: c, radius: 24);
      case 'coat':
        img.fillRect(image, x1: 50, y1: 40, x2: 206, y2: 230, color: c, radius: 40);
      case 'balloon':
        img.fillCircle(image, x: 128, y: 90, radius: 70, color: c, antialias: true);
        img.drawLine(image, x1: 128, y1: 160, x2: 128, y2: 250, color: ink, thickness: 3);
      case 'cup':
        img.fillRect(image, x1: 70, y1: 100, x2: 186, y2: 210, color: c, radius: 16);
        img.drawCircle(image, x: 196, y: 150, radius: 26, color: ink);
      case 'plant':
        img.fillRect(image, x1: 80, y1: 150, x2: 176, y2: 240, color: _rgba(0xC8744A), radius: 10);
        for (final (x, y) in [(128, 90), (90, 120), (166, 120)]) {
          img.fillCircle(image, x: x, y: y, radius: 40, color: c, antialias: true);
        }
      case 'lamp':
        img.drawLine(image, x1: 128, y1: 90, x2: 128, y2: 240, color: ink, thickness: 6);
        img.fillPolygon(image, vertices: [img.Point(70, 100), img.Point(186, 100), img.Point(156, 30), img.Point(100, 30)], color: c);
      case 'poster':
        img.fillRect(image, x1: 40, y1: 20, x2: 216, y2: 236, color: c, radius: 6);
        img.drawString(image, '*', font: img.arial48, x: 110, y: 100, color: _rgba(0xFFFFFF));
      case 'clock':
        img.fillCircle(image, x: 128, y: 128, radius: 100, color: c, antialias: true);
        img.drawCircle(image, x: 128, y: 128, radius: 100, color: ink, antialias: true);
        img.drawLine(image, x1: 128, y1: 128, x2: 128, y2: 60, color: ink, thickness: 5);
        img.drawLine(image, x1: 128, y1: 128, x2: 175, y2: 128, color: ink, thickness: 5);
      case 'chime':
        img.drawLine(image, x1: 50, y1: 40, x2: 206, y2: 40, color: ink, thickness: 6);
        for (var i = 0; i < 4; i++) {
          img.drawLine(image, x1: 70 + i * 38, y1: 40, x2: 70 + i * 38, y2: 140 + i * 20, color: c, thickness: 8);
        }
    }
    img.drawString(image, entry.key, font: img.arial14, x: 8, y: 238, color: ink);
    _save(image, 'items/${entry.key}.png');
  }
}

// ---- Room and icons ----

void _room() {
  final image = _canvas(1080, 1080);
  img.fill(image, color: _rgba(0xFBE9D7));
  img.fillRect(image, x1: 0, y1: 700, x2: 1080, y2: 1080, color: _rgba(0xE3C29B));
  img.fillRect(image, x1: 0, y1: 690, x2: 1080, y2: 710, color: _rgba(0xC99E72));
  img.fillRect(image, x1: 400, y1: 140, x2: 680, y2: 380, color: _rgba(0xBFE3F7), radius: 20);
  img.drawLine(image, x1: 540, y1: 140, x2: 540, y2: 380, color: _rgba(0xFFFFFF), thickness: 8);
  img.drawLine(image, x1: 400, y1: 260, x2: 680, y2: 260, color: _rgba(0xFFFFFF), thickness: 8);
  _save(image, 'rooms/home/background.png');
}

void _icons() {
  final coin = _canvas(128, 128);
  img.fillCircle(coin, x: 64, y: 64, radius: 58, color: _rgba(0xF6C453), antialias: true);
  img.fillCircle(coin, x: 64, y: 64, radius: 40, color: _rgba(0xF9D77E), antialias: true);
  _save(coin, 'icons/currency.png');
}

// ---- Lottie effects ----

Map<String, Object> _still(Object value) => {'a': 0, 'k': value};

/// Keyframes as (frame, value) pairs, eased in and out.
Map<String, Object> _keys(List<(int, List<num>)> frames) => {
      'a': 1,
      'k': [
        for (var i = 0; i < frames.length; i++)
          {
            't': frames[i].$1,
            's': frames[i].$2,
            if (i < frames.length - 1) ...{
              'i': {'x': [0.4], 'y': [1]},
              'o': {'x': [0.6], 'y': [0]},
            },
          },
      ],
    };

List<num> _rgb(int hex) => [((hex >> 16) & 0xFF) / 255, ((hex >> 8) & 0xFF) / 255, (hex & 0xFF) / 255, 1];

Map<String, Object> _dot({
  required int index,
  required int frames,
  required int color,
  required num size,
  required Map<String, Object> position,
  Map<String, Object>? scale,
  Map<String, Object>? opacity,
}) =>
    {
      'ddd': 0,
      'ind': index,
      'ty': 4,
      'nm': 'dot$index',
      'sr': 1,
      'ks': {
        'o': opacity ?? _still(100),
        'r': _still(0),
        'p': position,
        'a': _still([0, 0, 0]),
        's': scale ?? _still([100, 100, 100]),
      },
      'ao': 0,
      'shapes': [
        {
          'ty': 'gr',
          'nm': 'shape',
          'it': [
            {'ty': 'el', 'nm': 'ellipse', 'd': 1, 'p': _still([0, 0]), 's': _still([size, size])},
            {'ty': 'fl', 'nm': 'fill', 'c': _still(_rgb(color)), 'o': _still(100), 'r': 1},
            {
              'ty': 'tr',
              'p': _still([0, 0]),
              'a': _still([0, 0]),
              's': _still([100, 100]),
              'r': _still(0),
              'o': _still(100),
              'sk': _still(0),
              'sa': _still(0),
            },
          ],
        },
      ],
      'ip': 0,
      'op': frames,
      'st': 0,
      'bm': 0,
    };

void _lottie(String name, int frames, List<Map<String, Object>> layers) {
  final json = {
    'v': '5.7.4',
    'fr': 30,
    'ip': 0,
    'op': frames,
    'w': 200,
    'h': 200,
    'nm': name,
    'ddd': 0,
    'assets': <Object>[],
    'layers': layers,
  };
  File('$_theme/effects/$name.json')
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(jsonEncode(json));
}

/// Dots flying out from the center and fading: confetti, coins, milestones.
List<Map<String, Object>> _burst({
  required int count,
  required List<int> colors,
  required num distance,
  required int frames,
  num size = 18,
}) =>
    [
      for (var i = 0; i < count; i++)
        _dot(
          index: i + 1,
          frames: frames,
          color: colors[i % colors.length],
          size: size,
          position: _keys([
            (0, [100, 100, 0]),
            (frames, [100 + distance * math.cos(2 * math.pi * i / count), 100 + distance * math.sin(2 * math.pi * i / count), 0]),
          ]),
          opacity: _keys([(0, [100]), ((frames * 0.6).round(), [100]), (frames, [0])]),
          scale: _keys([(0, [40, 40, 100]), ((frames * 0.3).round(), [110, 110, 100]), (frames, [70, 70, 100])]),
        ),
    ];

void _effects() {
  const gold = 0xF6C453, green = 0x4CAF7A, blue = 0x6C8CFF, pink = 0xF49AC1, peach = 0xFFB38A;
  _lottie('goal_done', 24, [
    _dot(
      index: 1,
      frames: 24,
      color: green,
      size: 120,
      position: _still([100, 100, 0]),
      scale: _keys([(0, [0, 0, 100]), (10, [115, 115, 100]), (16, [100, 100, 100])]),
      opacity: _keys([(0, [100]), (16, [100]), (24, [0])]),
    ),
  ]);
  _lottie('coins_burst', 30, _burst(count: 6, colors: [gold], distance: 80, frames: 30));
  _lottie('energy_full', 30, [
    _dot(
      index: 1,
      frames: 30,
      color: gold,
      size: 140,
      position: _still([100, 100, 0]),
      scale: _keys([(0, [60, 60, 100]), (12, [125, 125, 100]), (30, [100, 100, 100])]),
      opacity: _keys([(0, [0]), (8, [80]), (30, [0])]),
    ),
  ]);
  _lottie('hatch_crack', 30, [
    _dot(
      index: 1,
      frames: 30,
      color: peach,
      size: 130,
      position: _keys([
        (0, [100, 100, 0]),
        (6, [92, 100, 0]),
        (12, [108, 100, 0]),
        (18, [94, 100, 0]),
        (24, [104, 100, 0]),
        (30, [100, 100, 0]),
      ]),
    ),
  ]);
  _lottie('plan_loading', 45, [
    for (var i = 0; i < 3; i++)
      _dot(
        index: i + 1,
        frames: 45,
        color: blue,
        size: 28,
        position: _still([60 + 40 * i, 100, 0]),
        scale: _keys([(0, [60, 60, 100]), (8 + i * 8, [130, 130, 100]), (24 + i * 8, [60, 60, 100]), (45, [60, 60, 100])]),
      ),
  ]);
  _lottie('adventure_depart', 30, [
    _dot(
      index: 1,
      frames: 30,
      color: peach,
      size: 90,
      position: _keys([(0, [100, 120, 0]), (30, [100, 10, 0])]),
      opacity: _keys([(0, [100]), (30, [0])]),
    ),
  ]);
  _lottie('adventure_return', 30, [
    _dot(
      index: 1,
      frames: 30,
      color: peach,
      size: 90,
      position: _keys([(0, [100, -40, 0]), (20, [100, 110, 0]), (30, [100, 100, 0])]),
      opacity: _keys([(0, [0]), (10, [100])]),
    ),
  ]);
  _lottie('milestone', 40, _burst(count: 8, colors: [gold, pink, blue, green], distance: 90, frames: 40, size: 22));
  _lottie('evolve', 40, [
    _dot(
      index: 1,
      frames: 40,
      color: gold,
      size: 120,
      position: _still([100, 100, 0]),
      scale: _keys([(0, [50, 50, 100]), (40, [160, 160, 100])]),
      opacity: _keys([(0, [90]), (40, [0])]),
    ),
    _dot(
      index: 2,
      frames: 40,
      color: peach,
      size: 90,
      position: _still([100, 100, 0]),
      scale: _keys([(0, [100, 100, 100]), (20, [120, 120, 100]), (40, [100, 100, 100])]),
    ),
  ]);
  _lottie('surprise_gift', 30, [
    _dot(
      index: 1,
      frames: 30,
      color: pink,
      size: 80,
      position: _keys([(0, [100, 120, 0]), (10, [100, 60, 0]), (20, [100, 110, 0]), (30, [100, 100, 0])]),
    ),
  ]);
}
```

- [ ] **Step 4: Generate the art and remove the now-unneeded `.gitkeep` files in art folders**

Run: `dart run tool/gen_placeholders.dart`
Expected: `Placeholder art written to assets/theme/`
Run (PowerShell): `Get-ChildItem assets/theme -Recurse -Filter .gitkeep | Remove-Item`

- [ ] **Step 5: Run the test to see it pass**

Run: `flutter test test/theme_kit/placeholder_art_test.dart`
Expected: `All tests passed!`

- [ ] **Step 6: Look at one pose and one item to sanity-check them**

Open `assets/theme/pet/baby/happy.png` and `assets/theme/items/sun_hat.png` in the image viewer (Read tool). Expected: an orange round critter with happy eyes, and a yellow hat.

- [ ] **Step 7: Commit**

```
git add tool/gen_placeholders.dart assets/theme test/theme_kit/placeholder_art_test.dart
git commit -m "feat(theme): generate placeholder pet, item, room and effect art

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 9: Asset validator and CLI

**Files:**
- Create: `lib/content/asset_validator.dart`, `tool/asset_files.dart`, `tool/validate_assets.dart`
- Test: `test/content/asset_validator_test.dart`

**Interfaces:**
- Consumes: `ThemeKit` and all manifests (Task 7); `ContentBundle` and `loadContent` (Task 6); `unknownPlaceholders` (Task 3)
- Produces:
  - `class ValidationIssue`: constructors `ValidationIssue.error(where, message)` and `ValidationIssue.warning(where, message)`; fields `bool isError`, `String where`, `String message`
  - `class AssetValidator`:
    - constructor `AssetValidator({required bool Function(String assetPath) exists, ({int width, int height})? Function(String assetPath)? pngSize})`
    - `List<ValidationIssue> validate({required ThemeKit theme, required ContentBundle content})`
  - `tool/asset_files.dart`:
    - `Set<String> listAssetFiles(String root)`
    - `({int width, int height})? readPngSize(String path)`
    - `List<ValidationIssue> checkPubspecAssetDirs(String pubspec, Set<String> files)`

- [ ] **Step 1: Write the failing test**

`test/content/asset_validator_test.dart`:

```dart
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
```

- [ ] **Step 2: Run it to see it fail**

Run: `flutter test test/content/asset_validator_test.dart`
Expected: FAIL. `asset_validator.dart` and `tool/asset_files.dart` don't exist.

- [ ] **Step 3: Implement `lib/content/asset_validator.dart`**

```dart
import '../domain/pet/pet_stage.dart';
import '../domain/text/template.dart';
import '../theme_kit/effect_registry.dart';
import '../theme_kit/icon_ref.dart';
import '../theme_kit/item_catalog.dart';
import '../theme_kit/pet_manifest.dart';
import '../theme_kit/room_manifest.dart';
import '../theme_kit/theme_kit.dart';
import '../theme_kit/theme_manifest.dart';
import 'content_bundle.dart';
import 'goal_library.dart';

class ValidationIssue {
  const ValidationIssue.error(this.where, this.message) : isError = true;
  const ValidationIssue.warning(this.where, this.message) : isError = false;

  final bool isError;
  final String where;
  final String message;

  @override
  String toString() => '${isError ? 'ERROR  ' : 'warning'}  $where: $message';
}

/// Checks that every file the manifests refer to exists and that
/// references between files line up.
///
/// [exists] receives full asset paths (e.g. `assets/theme/pet/baby/idle.png`)
/// and must match letter case exactly, because Android asset lookups do.
/// [pngSize], if given, lets the validator warn about pet art that isn't
/// the canvas size.
class AssetValidator {
  AssetValidator({required this.exists, this.pngSize});

  final bool Function(String assetPath) exists;
  final ({int width, int height})? Function(String assetPath)? pngSize;

  List<ValidationIssue> validate({required ThemeKit theme, required ContentBundle content}) {
    final issues = <ValidationIssue>[];

    bool file(String where, String relative) {
      final full = ThemeKit.assetPath(relative);
      if (exists(full)) return true;
      issues.add(ValidationIssue.error(where, 'missing file $full'));
      return false;
    }

    void icon(String where, IconRef ref) {
      if (ref.isImage) file(where, ref.value);
    }

    icon('${ThemeManifest.fileName} currency.icon', theme.theme.currencyIcon);
    for (final (i, mood) in theme.theme.moodIcons.indexed) {
      icon('${ThemeManifest.fileName} moodIcons[$i]', mood);
    }

    for (final egg in theme.pet.eggs) {
      file('${PetManifest.fileName} egg "${egg.id}"', egg.image);
    }
    final canvas = theme.pet.canvasSize;
    for (final stage in PetStage.values) {
      final art = theme.pet.stages[stage];
      if (art == null) {
        issues.add(ValidationIssue.warning(PetManifest.fileName, 'no art for stage "${stage.name}" yet; baby art will be shown'));
        continue;
      }
      for (final pose in PetPose.values) {
        final spec = art.poses[pose];
        final where = '${PetManifest.fileName} ${stage.name}.${pose.name}';
        if (spec == null) {
          issues.add(ValidationIssue.warning(where, 'no art yet; the ${stage.name} idle pose will be shown'));
          continue;
        }
        if (!file(where, spec.path) || spec is! PngPose) continue;
        final size = pngSize?.call(ThemeKit.assetPath(spec.path));
        if (size != null && (size.width != canvas || size.height != canvas)) {
          issues.add(ValidationIssue.warning(
            where,
            'is ${size.width}×${size.height}; pet art should be ${canvas.round()}×${canvas.round()} so outfits line up',
          ));
        }
      }
    }

    final home = theme.rooms.home;
    for (final item in theme.items.items) {
      final where = '${ItemCatalog.fileName} "${item.id}"';
      file(where, item.image);
      if (item.kind == ItemKind.decor && !home.slots.containsKey(item.slot)) {
        issues.add(ValidationIssue.error(where, 'decor slot "${item.slot}" does not exist in room "${home.id}"'));
      }
    }
    for (final room in theme.rooms.rooms) {
      file('${RoomManifest.fileName} "${room.id}"', room.background);
    }

    for (final name in EffectName.values) {
      final path = theme.effects.fileFor(name);
      if (path == null) {
        issues.add(ValidationIssue.warning(EffectRegistry.fileName, 'no file for effect "${name.id}"; a built-in animation will be used'));
      } else {
        file('${EffectRegistry.fileName} ${name.id}', path);
      }
    }

    for (final goal in content.goals.goals) {
      final unknown = unknownPlaceholders(goal.title);
      if (unknown.isNotEmpty) {
        issues.add(ValidationIssue.error(
          '${GoalLibrary.fileName} "${goal.id}"',
          'unknown placeholders ${unknown.map((u) => '{$u}').join(', ')}',
        ));
      }
    }
    return issues;
  }
}
```

- [ ] **Step 4: Implement `tool/asset_files.dart`**

```dart
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
```

- [ ] **Step 5: Implement `tool/validate_assets.dart`**

```dart
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
```

- [ ] **Step 6: Run the tests and the CLI**

Run: `flutter test test/content/asset_validator_test.dart` → Expected: `All tests passed!`
Run: `dart run tool/validate_assets.dart` → Expected: last line `Assets OK (0 warnings).`, exit code 0.

- [ ] **Step 7: Commit**

```
git add lib/content/asset_validator.dart tool/asset_files.dart tool/validate_assets.dart test/content/asset_validator_test.dart
git commit -m "feat(content): validate art and content references, case-sensitively

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 10: Database with profile and pet

**Files:**
- Create: `lib/data/db/database.dart`, `lib/data/db/open_database.dart`, `lib/data/repositories/profile_repository.dart`, `lib/data/repositories/pet_repository.dart`
- Generated: `lib/data/db/database.g.dart` (committed)
- Test: `test/data/profile_repository_test.dart`, `test/data/pet_repository_test.dart`

**Interfaces:**
- Consumes: `Clock`, `FakeClock` (Task 2); `Pronouns` (Task 3); `Trait` (Task 5)
- Produces:
  - `class AppDatabase extends _$AppDatabase`: constructor `AppDatabase(QueryExecutor e)`, `schemaVersion == 1`, tables `profiles` (data class `Profile`, companion `ProfilesCompanion`) and `pets` (data class `Pet`, companion `PetsCompanion`)
  - `QueryExecutor openZuluDatabase()`
  - `ProfileRepository(AppDatabase db, Clock clock, {Random? random})` with `Future<Profile> ensure()`, `Future<Profile> get()`, `Stream<Profile> watch()`, `Future<void> update(ProfilesCompanion changes)`
  - `PetRepository(AppDatabase db)` with:
    - `Future<Pet?> get()`, `Stream<Pet?> watch()`
    - `Future<void> save({required String name, required Pronouns pronouns, required String eggColor, required Trait trait, required Map<Trait, double> traitStats, required DateTime hatchedAt})`
    - `Future<void> rename(String name)`
  - `String encodeTraitStats(Map<Trait, double>)`
  - `Map<Trait, double> decodeTraitStats(String json)`

- [ ] **Step 1: Write the failing tests**

`test/data/profile_repository_test.dart`:

```dart
import 'dart:math';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/profile_repository.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = FakeClock(DateTime(2026, 9, 29, 9));
  });

  tearDown(() => db.close());

  test('ensure creates one profile with the spec defaults', () async {
    final profile = await ProfileRepository(db, clock, random: Random(1)).ensure();
    expect(profile.installId, hasLength(16));
    expect(profile.userName, '');
    expect(profile.wakeTime, '07:30');
    expect(profile.bedTime, '23:00');
    expect(profile.dayStartHour, 4);
    expect(profile.moodCheckInMode, 'daily');
    expect(profile.paused, isFalse);
    expect(profile.notifyMorning, isTrue);
    expect(profile.notifyAdventure, isTrue);
    expect(profile.notifyEvening, isFalse);
    expect(profile.onboardingDoneAt, isNull);
    expect(profile.createdAt.isAtSameMomentAs(clock.now()), isTrue);
  });

  test('ensure is idempotent', () async {
    final repo = ProfileRepository(db, clock);
    final first = await repo.ensure();
    final second = await repo.ensure();
    expect(second.installId, first.installId);
    expect(await db.select(db.profiles).get(), hasLength(1));
  });

  test('update changes only the given fields, and watch sees it', () async {
    final repo = ProfileRepository(db, clock);
    await repo.ensure();
    final names = expectLater(repo.watch().map((p) => p.userName), emitsInOrder(['', 'Sam']));
    await repo.update(const ProfilesCompanion(userName: Value('Sam')));
    await names;
    expect((await repo.get()).wakeTime, '07:30');
  });
}
```

`test/data/pet_repository_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/pet_repository.dart';
import 'package:zulu/domain/pet/trait.dart';
import 'package:zulu/domain/text/template.dart';

void main() {
  late AppDatabase db;
  late PetRepository pets;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    pets = PetRepository(db);
  });

  tearDown(() => db.close());

  Future<void> hatch({String name = 'Pip'}) => pets.save(
        name: name,
        pronouns: Pronouns.she,
        eggColor: 'mint',
        trait: Trait.curiosity,
        traitStats: {Trait.curiosity: 6, Trait.calm: 0.5},
        hatchedAt: DateTime(2026, 9, 29, 9),
      );

  test('there is no pet before hatching', () async {
    expect(await pets.get(), isNull);
  });

  test('save stores the hatched pet', () async {
    await hatch();
    final pet = (await pets.get())!;
    expect(pet.name, 'Pip');
    expect(Pronouns.fromId(pet.pronouns), Pronouns.she);
    expect(pet.eggColor, 'mint');
    expect(pet.trait, 'curiosity');
    expect(decodeTraitStats(pet.traitStats), {Trait.curiosity: 6.0, Trait.calm: 0.5});
  });

  test('saving again replaces the single pet row', () async {
    await hatch();
    await hatch(name: 'Mochi');
    expect(await db.select(db.pets).get(), hasLength(1));
    expect((await pets.get())!.name, 'Mochi');
  });

  test('rename changes only the name', () async {
    await hatch();
    await pets.rename('Bean');
    final pet = (await pets.get())!;
    expect(pet.name, 'Bean');
    expect(pet.eggColor, 'mint');
  });

  test('decodeTraitStats ignores unknown traits', () {
    expect(decodeTraitStats('{"calm":1,"bravery":3}'), {Trait.calm: 1.0});
  });
}
```

- [ ] **Step 2: Run them to see them fail**

Run: `flutter test test/data`
Expected: FAIL. `database.dart` doesn't exist.

- [ ] **Step 3: Implement `lib/data/db/database.dart`**

```dart
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
```

`lib/data/db/open_database.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// Opens `zulu.sqlite` in the app's documents folder.
QueryExecutor openZuluDatabase() => driftDatabase(name: 'zulu');
```

- [ ] **Step 4: Generate the drift code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: finishes with `Built with build_runner` and creates `lib/data/db/database.g.dart`.

- [ ] **Step 5: Implement the repositories**

`lib/data/repositories/profile_repository.dart`:

```dart
import 'dart:math';

import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../db/database.dart';

class ProfileRepository {
  ProfileRepository(this._db, this._clock, {Random? random}) : _random = random ?? Random.secure();

  final AppDatabase _db;
  final Clock _clock;
  final Random _random;

  SimpleSelectStatement<$ProfilesTable, Profile> get _row =>
      _db.select(_db.profiles)..where((p) => p.id.equals(1));

  /// Returns the profile, creating it with defaults on first launch.
  Future<Profile> ensure() async {
    final existing = await _row.getSingleOrNull();
    if (existing != null) return existing;
    await _db.into(_db.profiles).insert(
          ProfilesCompanion.insert(installId: _newInstallId(), createdAt: _clock.now()),
          mode: InsertMode.insertOrIgnore,
        );
    return _row.getSingle();
  }

  Future<Profile> get() => _row.getSingle();

  Stream<Profile> watch() => _row.watchSingle();

  Future<void> update(ProfilesCompanion changes) async {
    await (_db.update(_db.profiles)..where((p) => p.id.equals(1))).write(changes);
  }

  String _newInstallId() => List.generate(16, (_) => _random.nextInt(16).toRadixString(16)).join();
}
```

`lib/data/repositories/pet_repository.dart`:

```dart
import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/pet/trait.dart';
import '../../domain/text/template.dart';
import '../db/database.dart';

String encodeTraitStats(Map<Trait, double> stats) =>
    jsonEncode({for (final e in stats.entries) e.key.name: e.value});

/// Reads trait scores, skipping names that are no longer traits.
Map<Trait, double> decodeTraitStats(String json) {
  final raw = jsonDecode(json) as Map<String, Object?>;
  return {
    for (final e in raw.entries)
      if (Trait.values.asNameMap()[e.key] case final trait?) trait: (e.value! as num).toDouble(),
  };
}

class PetRepository {
  PetRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$PetsTable, Pet> get _row => _db.select(_db.pets)..where((p) => p.id.equals(1));

  Future<Pet?> get() => _row.getSingleOrNull();

  Stream<Pet?> watch() => _row.watchSingleOrNull();

  Future<void> save({
    required String name,
    required Pronouns pronouns,
    required String eggColor,
    required Trait trait,
    required Map<Trait, double> traitStats,
    required DateTime hatchedAt,
  }) async {
    await _db.into(_db.pets).insertOnConflictUpdate(PetsCompanion.insert(
          name: name,
          pronouns: pronouns.name,
          eggColor: eggColor,
          trait: trait.name,
          traitStats: Value(encodeTraitStats(traitStats)),
          hatchedAt: hatchedAt,
        ));
  }

  Future<void> rename(String name) async {
    await (_db.update(_db.pets)..where((p) => p.id.equals(1))).write(PetsCompanion(name: Value(name)));
  }
}
```

- [ ] **Step 6: Run the tests to see them pass**

Run: `flutter test test/data`
Expected: `All tests passed!`

- [ ] **Step 7: Commit**

```
git add lib/data test/data
git commit -m "feat(data): add drift database with profile and pet repositories

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 11: App theme

**Files:**
- Create: `lib/app/zulu_theme.dart`
- Test: `test/app/zulu_theme_test.dart`

**Interfaces:**
- Consumes: `ThemePalette` (Task 7)
- Produces:
  - `class ZuluColors extends ThemeExtension<ZuluColors> { Color energy, success; }`
  - `ThemeData buildZuluTheme(ThemePalette palette, Brightness brightness)`
  - `extension ZuluThemeX on BuildContext { ZuluColors get zuluColors; }`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/app/zulu_theme.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../helpers/read_file.dart';

void main() {
  late ThemeKit kit;

  setUpAll(() async => kit = await loadThemeKit(readFile));

  test('light theme uses the manifest colors', () {
    final theme = buildZuluTheme(kit.theme.light, Brightness.light);
    expect(theme.colorScheme.primary, const Color(0xFF6C8CFF));
    expect(theme.colorScheme.brightness, Brightness.light);
    expect(theme.scaffoldBackgroundColor, const Color(0xFFFFF8F0));
    expect(theme.extension<ZuluColors>()!.energy, const Color(0xFFFFC857));
  });

  test('dark theme is dark', () {
    final theme = buildZuluTheme(kit.theme.dark, Brightness.dark);
    expect(theme.colorScheme.brightness, Brightness.dark);
    expect(theme.colorScheme.primary, const Color(0xFF8FA6FF));
  });

  test('ZuluColors interpolates', () {
    const a = ZuluColors(energy: Color(0xFF000000), success: Color(0xFF000000));
    const b = ZuluColors(energy: Color(0xFFFFFFFF), success: Color(0xFFFFFFFF));
    expect(a.lerp(b, 1).energy, const Color(0xFFFFFFFF));
    expect(a.lerp(null, 0.5), same(a));
  });
}
```

- [ ] **Step 2: Run it to see it fail**

Run: `flutter test test/app/zulu_theme_test.dart`
Expected: FAIL. `zulu_theme.dart` doesn't exist.

- [ ] **Step 3: Implement `lib/app/zulu_theme.dart`**

```dart
import 'package:material_ui/material_ui.dart';

import '../theme_kit/theme_manifest.dart';

/// Zulu-specific colors that Material's ColorScheme has no slot for.
@immutable
class ZuluColors extends ThemeExtension<ZuluColors> {
  const ZuluColors({required this.energy, required this.success});

  final Color energy;
  final Color success;

  @override
  ZuluColors copyWith({Color? energy, Color? success}) =>
      ZuluColors(energy: energy ?? this.energy, success: success ?? this.success);

  @override
  ZuluColors lerp(ZuluColors? other, double t) {
    if (other == null) return this;
    return ZuluColors(
      energy: Color.lerp(energy, other.energy, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

ThemeData buildZuluTheme(ThemePalette palette, Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: Color(palette.primary), brightness: brightness).copyWith(
    primary: Color(palette.primary),
    surface: Color(palette.surface),
    onSurface: Color(palette.text),
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: Color(palette.background),
    extensions: [ZuluColors(energy: Color(palette.energy), success: Color(palette.success))],
  );
}

extension ZuluThemeX on BuildContext {
  ZuluColors get zuluColors => Theme.of(this).extension<ZuluColors>()!;
}
```

- [ ] **Step 4: Run it to see it pass**

Run: `flutter test test/app/zulu_theme_test.dart`
Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```
git add lib/app/zulu_theme.dart test/app/zulu_theme_test.dart
git commit -m "feat(app): build light and dark Material themes from the manifest

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 12: App shell, bootstrap and error handling

**Files:**
- Create:
  - `lib/app/providers.dart`, `lib/app/router.dart`, `lib/app/zulu_shell.dart`, `lib/app/app.dart`, `lib/app/bootstrap.dart`, `lib/app/error_handling.dart`
  - `lib/shared/widgets/placeholder_screen.dart`
  - `lib/features/home/ui/home_screen.dart`, `lib/features/shop/ui/shop_screen.dart`, `lib/features/bag/ui/bag_screen.dart`, `lib/features/journal/ui/journal_screen.dart`, `lib/features/me/ui/me_screen.dart`
- Modify: `lib/main.dart`
- Delete: `test/app_smoke_test.dart`
- Test: `test/app/app_shell_test.dart`, `test/app/error_handling_test.dart`

**Interfaces:**
- Consumes: everything above
- Produces:
  - providers: `databaseProvider`, `contentProvider`, `themeKitProvider` (throw unless overridden), `clockProvider` (defaults to `SystemClock`), `profileRepositoryProvider`, `petRepositoryProvider`
  - `GoRouter buildRouter()` with routes `/home`, `/shop`, `/bag`, `/journal`, `/me`
  - `ZuluShell({required StatefulNavigationShell shell})`
  - `ZuluApp()`
  - `Future<List<Override>> bootstrap()`
  - `void installErrorHandlers()`, `void logError(Object error, StackTrace? stack)`
  - `StartupErrorApp({required Object error})`
  - `PlaceholderScreen({required String title, required String message, Widget? child})`

- [ ] **Step 1: Write the failing tests**

`test/app/app_shell_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/app/app.dart';
import 'package:zulu/app/providers.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../helpers/read_file.dart';

void main() {
  late ContentBundle content;
  late ThemeKit kit;

  setUpAll(() async {
    content = await loadContent(readFile);
    kit = await loadThemeKit(readFile);
  });

  Future<void> pumpApp(WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        contentProvider.overrideWithValue(content),
        themeKitProvider.overrideWithValue(kit),
      ],
      child: const ZuluApp(),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('boots into Home with five tabs', (tester) async {
    await pumpApp(tester);
    expect(find.byType(NavigationBar), findsOneWidget);
    for (final label in ['Home', 'Shop', 'Bag', 'Journal', 'Me']) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    expect(find.textContaining('Welcome to Zulu'), findsOneWidget);
  });

  testWidgets('switches tabs', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Shop'));
    await tester.pumpAndSettle();
    expect(find.text('The shop opens soon.'), findsOneWidget);
    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    expect(find.text("Your pet's profile and settings will live here."), findsOneWidget);
  });
}
```

`test/app/error_handling_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/app/error_handling.dart';

void main() {
  testWidgets('the startup error screen is calm and shows details in debug', (tester) async {
    await tester.pumpWidget(StartupErrorApp(error: StateError('broken content')));
    expect(find.text("Zulu couldn't start"), findsOneWidget);
    expect(find.textContaining('close Zulu and open it again'), findsOneWidget);
    expect(find.textContaining('broken content'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run them to see them fail**

Run: `flutter test test/app`
Expected: FAIL. `app.dart`, `providers.dart` and `error_handling.dart` don't exist.

- [ ] **Step 3: Implement the providers — `lib/app/providers.dart`**

```dart
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
```

- [ ] **Step 4: Implement the screens**

`lib/shared/widgets/placeholder_screen.dart`:

```dart
import 'package:material_ui/material_ui.dart';

/// A simple titled screen for tabs whose features arrive in later plans.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title, required this.message, this.child});

  final String title;
  final String message;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (child != null) ...[child!, const SizedBox(height: 16)],
              Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
```

`lib/features/home/ui/home_screen.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../domain/pet/pet_stage.dart';
import '../../../shared/widgets/placeholder_screen.dart';
import '../../../theme_kit/pet_manifest.dart';
import '../../../theme_kit/theme_kit.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kit = ref.watch(themeKitProvider);
    final pose = kit.pet.pose(PetStage.baby, PetPose.idle);
    return PlaceholderScreen(
      title: 'Home',
      message: 'Welcome to ${kit.theme.appName}. Your pet is waiting to hatch.',
      child: pose is PngPose
          ? Image.asset(ThemeKit.assetPath(pose.path), width: 200, height: 200, semanticLabel: 'Your pet')
          : null,
    );
  }
}
```

`lib/features/shop/ui/shop_screen.dart`:

```dart
import 'package:material_ui/material_ui.dart';

import '../../../shared/widgets/placeholder_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Shop', message: 'The shop opens soon.');
}
```

`lib/features/bag/ui/bag_screen.dart`:

```dart
import 'package:material_ui/material_ui.dart';

import '../../../shared/widgets/placeholder_screen.dart';

class BagScreen extends StatelessWidget {
  const BagScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Bag', message: 'Outfits and decor you collect will live here.');
}
```

`lib/features/journal/ui/journal_screen.dart`:

```dart
import 'package:material_ui/material_ui.dart';

import '../../../shared/widgets/placeholder_screen.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Journal', message: 'Your days, moods and reflections will show up here.');
}
```

`lib/features/me/ui/me_screen.dart`:

```dart
import 'package:material_ui/material_ui.dart';

import '../../../shared/widgets/placeholder_screen.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Me', message: "Your pet's profile and settings will live here.");
}
```

- [ ] **Step 5: Implement routing — `lib/app/zulu_shell.dart` and `lib/app/router.dart`**

`lib/app/zulu_shell.dart`:

```dart
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// The bottom navigation around the five main tabs. The tab order never
/// changes (spec principle 7).
class ZuluShell extends StatelessWidget {
  const ZuluShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const _tabs = [
    (Icons.home_outlined, Icons.home, 'Home'),
    (Icons.storefront_outlined, Icons.storefront, 'Shop'),
    (Icons.backpack_outlined, Icons.backpack, 'Bag'),
    (Icons.menu_book_outlined, Icons.menu_book, 'Journal'),
    (Icons.person_outline, Icons.person, 'Me'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          for (final (icon, selectedIcon, label) in _tabs)
            NavigationDestination(icon: Icon(icon), selectedIcon: Icon(selectedIcon), label: label),
        ],
      ),
    );
  }
}
```

`lib/app/router.dart`:

```dart
import 'package:go_router/go_router.dart';

import '../features/bag/ui/bag_screen.dart';
import '../features/home/ui/home_screen.dart';
import '../features/journal/ui/journal_screen.dart';
import '../features/me/ui/me_screen.dart';
import '../features/shop/ui/shop_screen.dart';
import 'zulu_shell.dart';

GoRouter buildRouter() => GoRouter(
      initialLocation: '/home',
      routes: [
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

- [ ] **Step 6: Implement the app — `lib/app/app.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'providers.dart';
import 'router.dart';
import 'zulu_theme.dart';

class ZuluApp extends ConsumerStatefulWidget {
  const ZuluApp({super.key});

  @override
  ConsumerState<ZuluApp> createState() => _ZuluAppState();
}

class _ZuluAppState extends ConsumerState<ZuluApp> {
  late final GoRouter _router = buildRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeKitProvider).theme;
    return MaterialApp.router(
      title: theme.appName,
      debugShowCheckedModeBanner: false,
      theme: buildZuluTheme(theme.light, Brightness.light),
      darkTheme: buildZuluTheme(theme.dark, Brightness.dark),
      routerConfig: _router,
      builder: (context, child) => MaterialUiCompatibilityBridge(child: child ?? const SizedBox.shrink()),
    );
  }
}
```

- [ ] **Step 7: Implement error handling — `lib/app/error_handling.dart`**

```dart
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

void logError(Object error, StackTrace? stack) {
  debugPrint('Zulu error: $error');
  if (stack != null) debugPrint('$stack');
}

/// Sends uncaught errors to the log, and in release builds replaces
/// Flutter's red error box with a calm message.
void installErrorHandlers() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logError(details.exception, details.stack);
  };
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    logError(error, stack);
    return true;
  };
  if (kReleaseMode) {
    ErrorWidget.builder = (details) => const Material(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Something went wrong here. Please go back and try again.', textAlign: TextAlign.center),
            ),
          ),
        );
  }
}

/// Shown when the app can't start at all, e.g. unreadable bundled content.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Zulu couldn't start", style: TextStyle(fontSize: 22)),
                const SizedBox(height: 12),
                const Text('Please close Zulu and open it again.', textAlign: TextAlign.center),
                if (kDebugMode) ...[
                  const SizedBox(height: 24),
                  Text('$error', style: const TextStyle(fontSize: 12)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 8: Implement startup — `lib/app/bootstrap.dart` and `lib/main.dart`**

`lib/app/bootstrap.dart`:

```dart
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
```

Replace `lib/main.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'app/error_handling.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  installErrorHandlers();
  try {
    final overrides = await bootstrap();
    runApp(ProviderScope(overrides: overrides, child: const ZuluApp()));
  } catch (error, stack) {
    logError(error, stack);
    runApp(StartupErrorApp(error: error));
  }
}
```

Delete `test/app_smoke_test.dart`, since it tested the placeholder app that no longer exists.

- [ ] **Step 9: Run the app tests, the whole suite and the analyzer**

Run: `flutter test test/app` → Expected: `All tests passed!`
Run: `flutter test` → Expected: `All tests passed!`
Run: `flutter analyze` → Expected: `No issues found!`

- [ ] **Step 10: Commit**

```
git add -A
git commit -m "feat(app): boot into a themed five-tab shell with startup checks

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 13: README and on-device check

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Replace `README.md`**

````markdown
# Zulu

A gentle self-care pet app, built with Flutter. Android first; iOS later from the same code.

- Design spec: `docs/superpowers/specs/2026-09-29-zulu-v1-design.md`
- Build plans: `docs/superpowers/plans/`

## Setup (Windows)

1. Turn on **Developer Mode**: Settings → System → For developers. Flutter needs it to build plugins.
2. The Flutter SDK is at `C:\src\flutter`. Add `C:\src\flutter\bin` to your user PATH to use `flutter` and `dart` directly.
3. Start an Android emulator from Android Studio (Device Manager).

## Everyday commands

```bash
flutter run                                         # run on the emulator
flutter test                                        # all tests
flutter analyze                                     # lints
dart run tool/validate_assets.dart                  # check art + content references
dart run build_runner build --delete-conflicting-outputs   # after changing database tables
dart run tool/gen_placeholders.dart                 # regenerate placeholder art (overwrites!)
```

## Replacing the art

All art, colors and in-world names live in `assets/theme/`:

| File | What it controls |
|---|---|
| `theme.json` | App name, pet species name, currency name and icon, light and dark colors, the 5 mood icons |
| `pet/pet.json` | Egg images, and each growth stage's poses (`png`, `rive` or `lottie`) plus where outfits sit |
| `items/items.json` | Outfits and decor: name, slot, price, image |
| `rooms/rooms.json` | The home background and where decor goes |
| `effects/effects.json` | Lottie celebration effects |

To swap a picture, replace the file and keep its name. For example, replace `assets/theme/pet/baby/happy.png` with your own 512×512 PNG. To use a Rive or Lottie pose, change that pose's `type` and `path` in `pet/pet.json`. If you add a new folder, list it under `flutter: assets:` in `pubspec.yaml`.

Then run `dart run tool/validate_assets.dart`. It lists anything missing, misnamed (letter case matters on Android) or the wrong size.
````

- [ ] **Step 2: Full verification**

Run: `flutter analyze` → Expected: `No issues found!`
Run: `flutter test` → Expected: `All tests passed!`
Run: `dart run tool/validate_assets.dart` → Expected: `Assets OK (0 warnings).`

- [ ] **Step 3: Run on the emulator**

Run: `flutter devices` → Expected: an `emulator-5554` Android device in the list.
Run: `flutter run -d emulator-5554` (in the background) and wait for `Flutter run key commands`.
Take a screenshot: `& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" exec-out screencap -p > $env:TEMP\zulu_home.png`, then view it.
Expected: the Home tab titled "Home", the orange placeholder critter, "Welcome to Zulu. Your pet is waiting to hatch.", and a bottom bar with Home, Shop, Bag, Journal and Me. Tap Shop with `adb shell input tap <x> <y>` (coordinates from the screenshot), screenshot again, and expect "The shop opens soon." Then stop `flutter run` with `q`.

- [ ] **Step 4: Commit**

```
git add README.md
git commit -m "docs: add README with setup, commands and art replacement guide

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```
