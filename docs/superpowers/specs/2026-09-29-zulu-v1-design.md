# Zulu v1 — Design Spec

- **Date:** 2026-09-29
- **Status:** Draft, awaiting owner review
- **Platforms:** Android first (built and tested on Windows). iOS later from the same code.

---

## 1. What Zulu is

Zulu is a self-care pet app. You hatch a pet. Small daily self-care goals give it energy. With full energy it goes on an adventure and comes back with a story. You earn coins to dress it up and decorate its home.

v1 runs entirely on the device: no accounts, no server, no payments. The first users are the owner and a private beta of friends and family.

### 1.1 Goals

1. One complete daily loop that works offline, from hatching to the first adventure.
2. Kinder than Finch: no streak pressure, no guilt, calm tools one tap from home, and no deliberately worse free experience.
3. Swappable art and theme. The owner's art, names and colors drop in by replacing files. No code changes.
4. Built to ship: a store-ready Android build, clear architecture, and automated tests.

### 1.2 Non-goals for v1

Accounts, cloud sync, friends and social features, subscriptions, paywalls, ads, home-screen widgets, seasonal events, analytics SDKs, and an iOS release build. The code stays iOS-compatible: no Android-only APIs without an iOS path. UI text is English only but kept in one place so it can be translated later.

### 1.3 Beta success criteria

Measured by talking to testers, since there are no analytics:

- Most testers finish onboarding in one sitting.
- At least half the testers still open the app after 2 weeks.
- Testers describe it as kind and low-pressure. Nobody reports feeling guilted.
- No crash, lag, overheating or battery complaints.

### 1.4 Design principles

These come from the Finch onboarding teardown and six Reddit threads of Finch user feedback.

1. **Tiny goals win.** Survival-level goals ("get out of bed") are first-class. Day one's first adventure takes about 3 goals.
2. **Nothing is ever lost or punished.** No streaks, no "days in a row", no decay. The pet is always happy to see you, even after a year away.
3. **Progress only goes up.** Days showed up, goals done and adventures are running totals that never reset.
4. **Calm tools are always visible.** Breathing, naming your emotion, grounding and crisis resources are one tap from home.
5. **The pet asks; the app never nags.** Every request, question and notification is in the pet's warm voice and invites rather than blames.
6. **Few taps.** Every celebration can be tapped past. Success means goals done, not time spent in the app.
7. **Stable and light.** A small app size, smooth performance, and no layout churn. Many loyal users are ADHD or autistic.
8. **Reviewed content.** No weight or calorie goals by default. Nothing that assumes a body can do something. Categories can be muted.

---

## 2. Stack

| Concern | Choice | Why |
|---|---|---|
| Framework | Flutter (latest stable), Dart 3 | One codebase for Android and iOS |
| State and dependency injection | `flutter_riverpod` | Testable, compile-safe, little boilerplate |
| Navigation | `go_router` | Declarative routes and onboarding redirect guards |
| Local database | `drift` + `sqlite3_flutter_libs` | Typed SQL, migrations, cheap history queries, easy future sync |
| Notifications | `flutter_local_notifications` + `timezone` + `flutter_timezone` | Scheduled local reminders |
| Animation | `rive`, `lottie`, plus Flutter's built-in animation | All three art formats (see §4) |
| Backup | `share_plus`, `file_picker`, `path_provider` | Export and import a JSON backup file |
| Dates and text | `intl` | Formatting; UI strings in one file |
| Tests | `flutter_test`, `integration_test` | Unit, widget and on-device tests |

Package versions are whatever `flutter pub add` resolves at project creation. They're pinned in `pubspec.lock`.

### 2.1 Alternatives considered

- **Storage.** Hive CE (simple key-value, but weak for "what did I do on March 3rd" history queries). Isar (fast, but the original maintainer stepped away and it's now a community fork). Drift wins on queries, migrations and long-term safety.
- **State management.** Bloc (more boilerplate for a solo developer) or Provider (older; Riverpod is its successor).
- **Content.** Hardcoded Dart or JSON files. JSON wins: the owner can edit questions, goals, dialogue and stories without touching code, and the same files can later come from a server.

---

## 3. Architecture

```
UI (features/*/ui)            widgets and screens, no business logic
   │ watches
Controllers (Riverpod)        per-feature state notifiers
   │ calls
Domain services (pure Dart)   game rules, onboarding engine, plan generator. No Flutter imports.
   │ uses
Repositories                  read and write through Drift; read content and theme assets
   │
Drift DB (SQLite)  +  assets/content/*.json  +  assets/theme/**
```

The rule: everything in `domain/` is plain Dart. The current time comes from an injected `Clock` and random numbers from an injected `Random`, so every rule can be unit-tested deterministically.

### 3.1 Folder layout

```
lib/
  main.dart                 bootstrap: DB, content, theme, notifications, ProviderScope
  app.dart                  MaterialApp.router, theme, routes
  core/                     Clock, AppDay, result types, logging, constants
  data/
    db/                     Drift database, tables, migrations
    repositories/           profile, pet, goals, completions, day log, wallet, inventory, mood, reflections, answers
    backup/                 JSON export and import
  content/                  models and loaders for assets/content/*.json + validator
  theme_kit/                ThemeManifest, PetManifest, ItemCatalog, EffectRegistry + validator
  domain/
    rules/                  GameRules config, EnergyService, RewardService, AdventureService, GrowthService, MilestoneService
    onboarding/             QuestionFlow (showIf, progress), PlanGenerator
    shop/                   ShopRotation
    text/                   Template (fills {userName}, {petName}, pronouns)
  features/
    onboarding/  home/  goals/  pet/  adventure/  shop/  bag/  mood/  reflections/
    calm/  journal/  daily_question/  feature_intros/  settings/  notifications/  debug_gallery/
  shared/widgets/           buttons, cards, sheets, the PetView and Effect widgets
assets/
  content/                  onboarding.json, goal_library.json, game_rules.json, dialogue.json, stories.json,
                            daily_questions.json, reflection_prompts.json, emotions.json, calm.json,
                            feature_intros.json, milestones.json
  theme/                    theme.json, pet/, items/, rooms/, effects/, icons/
tool/
  validate_assets.dart      checks every manifest and content reference; run before a build
test/  integration_test/
```

### 3.2 Units and their contracts

| Unit | Does | Depends on |
|---|---|---|
| `Clock` / `AppDay` | Current time. Maps a moment to an app day that starts at `dayStartHour` (default 04:00 local) | none |
| `ContentRepository` | Loads and validates all `assets/content` JSON into typed models once at startup | asset bundle |
| `ThemeKit` | Loads the theme, pet manifest, item catalog and effects; resolves a pose, item or effect to a renderable spec with fallbacks | asset bundle |
| `QuestionFlow` | Given the question list and answers so far: the next or previous visible question, plus section progress | content models |
| `PlanGenerator` | Onboarding answers in, up to 7 goals out, each with a reason string (deterministic) | content models |
| `EnergyService` | Energy from today's completions; the target, including bad-day mode | GameRules |
| `RewardService` | Coins for completions, capped per goal per day; seeded surprise gift; adventure and milestone rewards | GameRules, Random |
| `AdventureService` | State machine: charging, ready, away, returned, done. Start, auto-start at rollover, return, claim | Clock, GameRules |
| `GrowthService` | Pet stage from total adventures | GameRules |
| `MilestoneService` | Days showed up and milestones reached and not yet celebrated | repositories |
| `ShopRotation` | Today's 6 items, seeded by app day and install id | ItemCatalog |
| `NotificationPlanner` | Pure function from settings and state to a list of scheduled notifications. `NotificationService` applies the list to the OS | Clock, content |
| `BackupService` | Exports all tables to versioned JSON; imports in one transaction | DB |
| `PetView` widget | Renders the pet's current pose (PNG, Rive or Lottie) plus equipped item overlays | ThemeKit |
| `Effect` widget | Plays a named effect (a Lottie file, with a built-in Flutter fallback) | ThemeKit |

---

## 4. Theme and art system

Everything visual, and every in-world name, lives under `assets/theme/`. The owner replaces files. The app reads manifests.

### 4.1 `theme.json`

```json
{
  "appName": "Zulu",
  "petSpecies": { "singular": "critter", "plural": "critters" },
  "currency": { "singular": "coin", "plural": "coins", "icon": "icons/currency.png" },
  "colors": {
    "light": { "primary": "#6C8CFF", "background": "#FFF8F0", "surface": "#FFFFFF", "text": "#2B2B2B", "energy": "#FFC857", "success": "#4CAF7A" },
    "dark":  { "primary": "#8FA6FF", "background": "#1C1B22", "surface": "#26252D", "text": "#F2F0EA", "energy": "#FFD37A", "success": "#6CCB96" }
  },
  "moodIcons": ["icons/mood_1.png", "icons/mood_2.png", "icons/mood_3.png", "icons/mood_4.png", "icons/mood_5.png"]
}
```

### 4.2 Pet manifest: `pet/pet.json`

Poses: `idle`, `happy`, `curious`, `sleepy`, `away`, `celebrate`, `hatch`. Each growth stage (`baby`, `toddler`, `teen`, `adult`) has its own pose set. A pose can be any of the three formats:

```json
{ "type": "png",    "path": "pet/baby/idle.png" }
{ "type": "rive",   "path": "pet/baby/pet.riv", "artboard": "Pet", "stateMachine": "Main", "trigger": "happy" }
{ "type": "lottie", "path": "pet/baby/idle.json", "loop": true }
```

- Each stage defines outfit anchors (`head`, `face`, `neck`, `body`, `held`) as `{x, y, scale}` on a 512×512 pet canvas. Item overlays are PNGs positioned at these anchors.
- Egg colors are a list of `{ "id", "image" }`. Six placeholders ship.
- **Fallback chain for a missing pose:** the same stage's `idle`, then the `baby` stage's `idle`, then a built-in placeholder. The app never crashes on missing art.
- **Known limitation:** overlays are aligned to the idle pose. A Rive or Lottie pose that moves a lot may drift from its outfit. Proper Rive outfits (skins inside the `.riv` file) are Phase 2.

### 4.3 Items: `items/items.json`

`{ "id", "name", "kind": "outfit" | "decor", "slot", "price", "image", "everyday": bool }`

- Outfit slots are the pet anchors.
- Decor slots are the room's slots (§4.4).
- `everyday: true` items are always in the shop. The rest rotate daily.
- Prices are 30–300 coins.

### 4.4 Rooms: `rooms/rooms.json`

A room has a background image, a pet position, and named decor slots (`wall_left`, `wall_right`, `floor_left`, `floor_right`, `window`) with `{x, y, scale}`. v1 has one room.

### 4.5 Effects: `effects/effects.json`

This maps effect names to Lottie files. Lottie is used wherever a moment deserves a flourish:

| Effect | When |
|---|---|
| `goal_done` | Checking off a goal |
| `coins_burst` | Earning coins |
| `energy_full` | The energy bar fills |
| `hatch_crack` | The egg hatching in onboarding |
| `plan_loading` | "Making your plan…" |
| `adventure_depart` / `adventure_return` | The pet leaves and comes back |
| `milestone` | A days-showed-up milestone |
| `evolve` | The pet grows to its next stage |
| `surprise_gift` | A random bonus |

Every effect has a built-in Flutter fallback animation, used if the file is missing or reduce-motion is on. With reduce motion, effects become a simple fade.

### 4.6 Placeholder art and tools for the artist

- v1 ships placeholder art: simple generated PNG poses, items and room, plus small hand-made Lottie files. Every file keeps its final name, so replacing it is a file swap.
- `dart run tool/validate_assets.dart` lists every missing or broken reference in the manifests and content.
- In debug builds, **Me → Art gallery** shows every pose per stage, every item on the pet and in the room, and every effect on loop. The owner can check new art on the emulator instantly.

---

## 5. Content system

All text the user sees in the world lives in `assets/content/*.json`. It's original writing, not Finch's.

- **Templates:** strings can use `{userName}`, `{petName}`, `{they}`, `{them}`, `{their}` (from the chosen pronouns), `{currency}` and `{currencyPlural}`.
- **Tone rules for every line:** invite, don't instruct. Never mention missed days, neglect, sadness or "missing you". Never promise treatment or cure.

| File | Holds |
|---|---|
| `onboarding.json` | Sections, questions, plan rules, foundation goals |
| `goal_library.json` | ~60 curated goals: `id`, `title`, `icon`, `area`, `section`, `essential`, `tags` |
| `game_rules.json` | Every number in §7, so balance can be tuned without code |
| `dialogue.json` | Pet lines by context: greeting by time of day, goal done, energy full, welcome back after a break, low-energy day, pause, etc. |
| `stories.json` | Adventure vignettes (text plus a place name), weighted by stage and trait |
| `daily_questions.json` | "Get to know you" questions: `id`, `prompt`, `options`, optional trait nudges and goal suggestions |
| `reflection_prompts.json` | One-line reflection prompts by area |
| `emotions.json` | About 30 emotion words grouped by feeling family |
| `calm.json` | Breathing patterns, grounding steps, crisis resource text and link |
| `feature_intros.json` | The 7 first-week feature introductions |
| `milestones.json` | Days-showed-up milestones and their pet messages |

The asset validator also checks references across files. For example, a plan rule can only point to a real goal id, and a `showIf` can only point to a real question.

---

## 6. Onboarding

### 6.1 Flow (about 18–24 screens, depending on branches)

| # | Screen | Type | Stores |
|---|---|---|---|
| 1 | Welcome: "Hatch a new pet" / "Restore from backup" | intro | — |
| 2 | Choose your egg | egg picker | pet.eggColor |
| 3 | Hatching | effect `hatch_crack`, then the `hatch` pose | — |
| 4 | Name your pet (with a shuffle button) | text | pet.name |
| 5 | Your pet's pronouns (she / he / they) | single | pet.pronouns |
| 6 | Choose a trait (curiosity, resilience, compassion, logic, confidence, calm) | single | pet.trait (+6 to that trait) |
| 7 | "What's your name?" asked by the pet | text, skippable | profile.userName |
| 8 | "What is self-care?" Two reply bubbles, both valid | talk choice | small trait nudge |
| 9 | "When you take care of you, you take care of me" | talk | — |
| 10 | Reminders, asked in the pet's voice, with a preview notification | permission | OS permission |
| 11 | "Let's get to know each other" | talk | — |
| 12+ | Quiz: 4 sections with a segmented progress bar | questions (§6.2) | answers |
| — | "{petName} is making your plan…" | effect `plan_loading` | — |
| — | Your starter plan: up to 7 goals, each with a reason. Remove or swap, then "Let's do it" | plan | goals |
| — | Home with the day 1 intro card; the first check-off gets a celebration | home | — |

Deliberately left out: phone or email signup, paywall, streak pledge, home-screen widget, "how did you hear about us", gender, age, and diagnosis questions.

### 6.2 Quiz questions (v1 wording)

**Section 1: About you**

- **When do you usually wake up?** Time picker. Drives morning reminders.
- **And when do you usually go to bed?** Time picker. Drives the evening wind-down.
- **Have you tried a habit or self-care app before?**
  - never
  - tried one, it didn't stick
  - I use one now

**Section 2: Energy**

- **How much sleep do you usually get?** Under 5h / 5–7h / 7–9h / 9h+
- **How easy is it to get up in the morning?** Pretty easy / depends on the day / hard most days
- **How much do you move in a normal day?**
  - a lot
  - some
  - not much, and I'd like more
  - my body limits how much I move

**Section 3: How's life**

- **How often does life feel like too much?** Most days / some days / rarely
- **Who can you lean on when things are hard?** A few people / one person / mostly just me / prefer not to say
- **How do you feel about your routine right now?** Pretty good / want small changes / want a big change

**Section 4: Support**

- **What's been hard lately?** Multi-select:
  - staying focused
  - low energy
  - feeling down
  - stress or worry
  - sleep
  - feeling lonely
  - keeping up with basics
  - being kind to myself
  - nothing in particular
  - prefer not to say
- **What would you like help with?** Multi-select, at least 1. The 10 focus areas:
  - calmer mind
  - rest and sleep
  - move more
  - eat well
  - feel fresh
  - focus and get things done
  - be kinder to myself
  - notice the good
  - connect with people
  - a steady routine

**Follow-ups:** one per chosen area, each multi-select, shown only if that area was picked (`showIf`).

| Area | Follow-up question | Options |
|---|---|---|
| Calmer mind | What tends to pile up on you? | work or school, relationships, money, health, too much on my plate, big changes, not sure |
| Rest and sleep | What gets in the way of rest? | screens, racing thoughts, changing schedule, noise or environment, not sure |
| Move more | What makes moving hard? | no time, low energy, don't enjoy it, pain or physical limits, don't know where to start, weather |
| Eat well | What would help most with food? | regular meals, more water, more fruit and veg, cooking more, fewer meals on the go |
| Feel fresh | Which would feel good to keep up? | teeth, showers, skincare, clean clothes, tidy space |
| Focus | What pulls your focus away? | my phone, too many tasks, hard to start, tiredness, noise |
| Kinder to myself | When something goes wrong, you usually… | am hard on myself, shrug it off, it depends |
| Notice the good | When could you pause for a good moment? | morning, midday, evening, whenever |
| Connect | What sounds doable this week? | message a friend, call family, see someone, join something, not yet |
| Steady routine | Which part of the day needs the most help? | morning, afternoon, evening, bedtime |

**Screen behavior**

- Single-choice questions advance by themselves after 250 ms.
- Multi-choice questions show a Next button that enables once something is picked.
- There's always a Back button.
- Every answer is saved as it's given, so closing the app resumes where the user left off.
- Sensitive questions offer "prefer not to say".

### 6.3 Question schema

```json
{
  "id": "move_obstacle",
  "section": "support",
  "type": "single | multi | text | time | talk | talk_choice | egg | permission",
  "prompt": "What makes moving hard?",
  "petPose": "curious",
  "options": [{ "id": "no_time", "label": "No time", "icon": "icons/clock.png" }],
  "showIf": { "question": "focus_areas", "includes": "move_more" },
  "minSelect": 1,
  "skippable": false
}
```

- `showIf` supports `equals`, `includes`, `includesAny`, and `not`.
- A question hidden because of an answer change is removed from the stored answers.

### 6.4 Plan generator (deterministic)

1. Start with the `foundationGoals` from `onboarding.json`, in order: `get_out_of_bed` and `drink_water`. Their reason is "a gentle start for any day".
2. Apply the `planRules` in order. Each rule is `{ when, add: [goalIds], reason }`. The reason mirrors the answer back. Examples:
   - `get_up = hard` adds `get_out_of_bed` ("you said mornings can be hard").
   - `sleep = under_5` adds `wind_down_10` ("you told me sleep's been short").
   - `move_obstacle includes no_time` adds `stretch_2min` ("you said time is tight").
3. Fill from each chosen focus area's `starter` goals, taking one per area in turn until there are 7.
4. Remove duplicates, keeping the first reason. Keep at least 2 `essential` goals, since bad-day mode needs them.
5. The plan screen lists each goal with its reason. The user can remove a goal or swap it for another from the same area. At least 1 goal must remain.

---

## 7. Daily loop and game rules

All numbers live in `game_rules.json`.

| Rule | v1 value |
|---|---|
| App day starts at | 04:00 local time. Configurable in settings. |
| Energy per completion | +5 |
| Energy target | 15 on a normal day. On a low-energy day: 5 × min(3, today's essential goals), at least 5 |
| Coins per completion | +3. A goal pays out at most 3 times per day, even if its times-per-day is higher |
| Surprise gift | 8% chance per completion; 5–15 coins; at most 1 per day. Uses the injected Random |
| Adventure | Starts by tap once energy is full. Lasts 6 hours. At most 1 per app day. If energy is full but the adventure hasn't started by the end of the app day, it starts itself, so nothing is lost |
| Adventure return | A story plus 20 coins |
| Growth stages | By total adventures ever, which never resets: baby 0, toddler 5, teen 20, adult 60 |
| Day showed up | Any goal completion, mood check-in, reflection or calm corner use. Calm corner use means a breathing session of at least 30 seconds, a finished grounding exercise, or a saved emotion |
| Milestones | Days showed up: 1, 3, 7, 14, 30, 50, 100, 200, 365. Each gives a pet message and 25 coins |
| Streaks | None. The words "in a row" and "streak" never appear |

**Goals**

- Fields: title, icon, section ("Start the day" / "Any time" / "End the day"), schedule (every day or chosen weekdays), times per day (1–10), essential flag, optional reminder time.
- Undo works for the rest of the app day and reverses the reward.
- "Skip today" hides a goal for the day with no penalty. Skipped goals go into a collapsed "Skipped" list.
- Goals can be archived, not only deleted, so history stays intact.

**Low-energy day (bad-day mode).** A chip on Home. When on, it:
- shows only essential goals, with a "show everything" link
- lowers the energy target so those few goals fill it completely
- still counts the day fully

If no goals scheduled today are marked essential, the list stays full. The pet then offers to mark up to 3 goals as essential.

**Traits.** There are six, used only to flavor stories and dialogue. The chosen trait starts at 6. Activities add small amounts:
- a reflection gives compassion +0.5
- calm corner use gives calm +0.5
- a completed goal gives +0.2 to its area's trait

**Shop**
- 6 rotating items a day (seeded, so they're the same all day) plus the everyday basics.
- Everything is bought with earned coins. There are no premium-only items, and free users never get uglier colors.

**Economy check.** A typical day earns 7 goals × 3 + 20 (adventure) ≈ 40 coins, so a new item comes every 1–5 days.

---

## 8. Screens

**Bottom navigation:** Home · Shop · Bag · Journal · Me

### Home
- The room scene with the pet, whose pose follows its state (e.g. `away` while adventuring).
- The energy bar. It shows "8 / 15", or "Adventuring · back in 2h 10m" while away.
- A **Calm** button, always visible in the header.
- The "Low-energy day" chip.
- A daily-question card (dismissible).
- A first-week feature intro card.
- The goal list, grouped by section.
- A "+ Add goal" button.

### Goal check-off
- The `goal_done` and `coins_burst` effects play, with a small "+5 energy · +3 coins" toast.
- Sometimes (1 in 3 completions, at most 2 a day) the pet offers a one-line reflection prompt. One tap dismisses it.

### Other screens

| Screen | Contents |
|---|---|
| Goal editor (sheet) | Every goal field (§7). A "pick from library" option with suggestions, excluding muted categories |
| Adventure return | A story card with the pet, the place name and the reward, then a claim button |
| Mood check-in (sheet) | A 5-point scale using the theme's mood icons, optional emotion words, an optional note. Frequency setting: once a day (default), every open (at most every 3 hours), or off (then only reachable from Journal). No automatic pop-up if off |
| Journal | A month calendar with a dot on each showed-up day. Day detail shows goals done, mood, reflections and that day's adventure story. Totals: days showed up, goals done, adventures. A 30-day mood chart. Reflections list. Calm corner entry |
| Me | Pet profile (name, pronouns, stage, traits) and settings (§8.1) |
| Milestone / evolution overlays | A full-screen celebration you can tap past |
| Art gallery | Debug builds only (§4.6) |

### Calm corner
Opened from the header button on Home and from Journal.
- **Breathe.** Two patterns: "Easy", breathe in 4s and out 6s; and "Box", 4-4-4-4. Lengths of 1, 3 or 5 minutes. An animated circle driven by Flutter animation, timed exactly. Optional haptic cue.
- **Name your emotion.** Pick words from `emotions.json`. Saves as a mood entry.
- **Grounding 5-4-3-2-1.** Step-through cards.
- **Need help now?** Short text saying the app isn't an emergency service, the local emergency number reminder, and a link to findahelpline.com.

### First-week feature intros
One per day, presented by the pet as a Home card, skippable, never repeated:
- Day 1: goals
- Day 2: mood check-in
- Day 3: calm corner
- Day 4: shop
- Day 5: dressing up in the Bag
- Day 6: Journal
- Day 7: low-energy day

### 8.1 Settings
- Your name, wake-up time, bedtime, day start hour.
- Mood check-in frequency.
- Notifications: morning hello, goal reminders, adventure return, evening wind-down.
- **Pause mode:** stops all notifications; the pet shows "resting"; nothing changes while paused.
- Muted goal categories.
- Reduce motion (also follows the OS setting), sounds, haptics.
- Export backup / import backup.
- About and privacy: states this is a wellness app, not medical care.
- Reset app, with a typed confirmation.

---

## 9. Notifications

All notifications are local and scheduled on the device.

| Notification | When | Default |
|---|---|---|
| Morning hello | Wake time + 15 min | On |
| Goal reminder | The goal's own reminder time | Per goal |
| Adventure return | When the pet gets back | On |
| Evening wind-down | Bedtime − 30 min | Off |

- At most 3 app-initiated notifications a day (morning hello, adventure return, evening wind-down). Lower-priority ones are dropped first. Goal reminders the user set themselves are always delivered and don't count toward this cap.
- Pause mode cancels all of them.
- The wording comes from `dialogue.json` and follows the tone rules in §5.
- Timing is approximate (inexact alarms), so the app doesn't need Android's exact-alarm permission.
- Android 13+ asks for notification permission on onboarding screen 10. If the user says no, the app still works fully, and settings show a "turn on in system settings" button.
- The schedule is rebuilt after every relevant change and on app start, from the pure `NotificationPlanner`.

---

## 10. Data model (Drift)

| Table | Key columns |
|---|---|
| `profile` (1 row) | userName, wakeTime, bedTime, dayStartHour, moodCheckInMode, paused, reduceMotion, sound, haptics, notification flags, installId, onboardingStep, onboardingDoneAt, createdAt |
| `pet` (1 row) | name, pronouns, eggColor, trait, traitStats (JSON), hatchedAt |
| `equipped` | slot (primary key), itemId |
| `onboarding_answers` | questionId (primary key), value (JSON), answeredAt |
| `goals` | id, title, icon, area, section, weekdaysMask, timesPerDay, essential, reminderTime?, sortOrder, libraryId?, archivedAt?, createdAt |
| `completions` | id, goalId, appDay, completedAt |
| `skips` | goalId, appDay |
| `days` | appDay (primary key), lowEnergy, adventureState, adventureStartedAt, adventureEndsAt, storyId, surpriseGiven |
| `wallet_ledger` | id, amount (±), reason, refId?, createdAt. The balance is the sum |
| `inventory` | itemId (primary key), acquiredAt |
| `moods` | id, appDay, createdAt, score (1–5), emotions (JSON), note? |
| `reflections` | id, appDay, createdAt, promptId?, text |
| `daily_answers` | questionId (primary key), appDay, value (JSON) |
| `seen` | key (primary key), seenAt. Covers milestones, feature intros and one-off messages |

- `appDay` is stored as a `YYYY-MM-DD` string. Moments are stored as UTC.
- The schema is versioned from day one, and migrations are tested.

---

## 11. Backup and restore

- **Export:** every table goes into a single JSON file, `{ "app": "zulu", "schemaVersion": n, "exportedAt", "data": {…} }`, saved through the share sheet (Drive, email, Files).
- **Import:** from the Welcome screen or settings. The file is checked first (app name, schema version no newer than the app's). After a confirmation screen, all data is replaced in one database transaction, and the notification schedule is rebuilt.
- **Invalid files:** a clear error, and nothing changes.

---

## 12. Privacy, safety, accessibility, performance

**Privacy**
- All data stays on the device.
- No accounts, analytics, ads or trackers.
- The app makes no network calls except links the user taps.

**Safety**
- No diagnosis questions.
- A reviewed goal library with no weight or calorie goals.
- Crisis resources one tap from Home.
- A wellness-not-medical statement in About.
- The store listing targets ages 13+.

**Accessibility**
- Supports system text scaling.
- Semantic labels on every control.
- Touch targets of at least 48dp.
- Reduce motion.
- Contrast checked in both light and dark themes.
- The navigation layout doesn't change.

**Performance budget**
- Release APK (per-architecture split) under 40 MB, before the owner's final art.
- Cold start under 2 seconds on a mid-range phone.
- Home scrolls at 60 fps.
- Rive and Lottie animations pause when offscreen.
- No background work except scheduled notifications.

---

## 13. Error handling

| Failure | Behavior |
|---|---|
| Content or theme JSON invalid | Debug builds stop with the exact file, field and problem. Release builds fall back to built-in defaults for what failed and log it |
| Missing art file | The fallback chain in §4.2. Effects fall back to Flutter animations |
| Database migration fails | The database file is copied before every migration. On failure, a recovery screen offers "export what we can" and "start fresh" |
| Notification permission denied | The app works fully. Settings show the reminders are off, with a button to system settings |
| Invalid backup import | An error message, with no changes (the import runs in one transaction) |
| Clock or timezone change | App days come from local time; adventure end times are stored as UTC. A timezone change can't lose or duplicate an adventure |
| Unexpected exception | A global error handler logs it, shows a friendly "something went wrong" with a retry, and never shows a blank screen |

---

## 14. Testing

- **Unit tests (pure Dart, written first):**
  - AppDay boundaries (before and after 04:00, timezone change)
  - energy, including low-energy mode
  - rewards: per-goal cap, surprise gift with a seeded Random, undo reversal
  - the adventure state machine, including auto-start at rollover
  - growth thresholds and milestones
  - shop rotation stability
  - QuestionFlow: `showIf` operators, progress, pruning hidden answers
  - PlanGenerator: golden cases for several answer sets
  - template filling
  - NotificationPlanner: daily cap, pause mode
- **Repository tests:** Drift in-memory database, including backup round-trips and migration tests.
- **Widget tests:**
  - each question type's rendering and auto-advance
  - goal check-off and undo
  - the low-energy chip
  - the breathing timer (with a fake clock)
  - PetView fallbacks
- **Content and theme tests:** run the asset validator in CI and as a unit test, so a broken reference fails the build.
- **Integration test (emulator):** fresh install, onboarding, plan, complete 3 goals, energy full, start adventure, advance the fake clock, story returns, claim.

---

## 15. Build order

The implementation plan details each step.

1. **Foundation:** project, lints, folders, Clock/AppDay, Drift schema, content and theme loaders, validator, placeholder assets, theme colors.
2. **Onboarding:** engine (QuestionFlow, PlanGenerator), all screen types, resume, plan screen.
3. **Home and goals:** goal CRUD, check-off, undo, skip, energy bar, coins ledger, low-energy day.
4. **Pet:** PetView (PNG, Rive, Lottie), effects, adventures, stories, growth, milestones.
5. **Shop and Bag:** rotation, purchase, equip outfits, place decor.
6. **Mood, reflections, calm corner.**
7. **Journal, daily questions, first-week intros.**
8. **Notifications, settings, pause, backup and restore.**
9. **Polish:** accessibility pass, performance check, integration test, release build and signing setup.

---

## 16. Later phases (out of v1)

- **Phase 2:**
  - iOS build and TestFlight
  - cloud backup and accounts
  - friends with low-pressure encouragement and an "on a break" status
  - multi-day programs, like journeys (counted by total days, no deadline); a strong differentiator
  - home-screen widget
  - insights
  - Rive outfits
- **Phase 3:** a fair subscription, opt-in seasonal events, localization.

## 17. Placeholders the owner will replace

These are by design, not unresolved decisions: pet species name, currency name, colors, all art and effects, and `applicationId` (placeholder `com.zuluapp.zulu`, which must be final before the first Play Store upload).
