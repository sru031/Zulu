# Zulu Plan 3 — Daily Loop (compact plan)

> Owner asked for less paperwork: this plan lists tasks, interfaces and test cases; code is written test-first during execution (superpowers:executing-plans, inline).

**Goal:** Home becomes the daily loop.
- Goals are grouped by part of the day.
- Checking a goal off fills energy (+5, full at 15) and earns coins (+3, capped at 3 paid completions per goal per day), with a rare surprise gift.
- Undo and "skip today" never cost anything.
- A low-energy day shows only the essential goals and lowers the target.
- Full energy lets the pet start a 6-hour adventure. It comes back with a story and 20 coins.
- Total adventures grow the pet through its stages.

**Spec:** `docs/superpowers/specs/2026-09-29-zulu-v1-design.md` §7, §8 (Home, goal check-off, adventure return), §10 tables.

**Out of scope:**
- the calm corner, mood, journal and milestone celebrations (Plan 5)
- the shop and bag (Plan 4)
- notifications (Plan 6)
- Rive rendering (deferred until the owner has Rive art, since there's no `.riv` file to test against)

**Constraints:**
- All the Plan 1 and Plan 2 global constraints still apply.
- No `Co-Authored-By` lines in commits.
- No streak or "in a row" wording anywhere.

## Tasks

1. **Schema v3.** Tables `completions(id, goalId, appDay, completedAt)`, `skips(goalId, appDay, PK both)`, `days(appDay PK, lowEnergy, adventureStartedAt?, adventureEndsAt?, storyId?, adventureClaimed, surpriseGiven)`, `wallet_ledger(id, amount, reason, refId?, createdAt)`; migration `from < 3` creates them. Tests: a version 2 database upgrades; a fresh database has every table.
2. **Pure rules** (`lib/domain/rules/`).
   - **Energy:** `EnergyRules.energy(completions)` = min(completions × 5, target). `target(lowEnergy, essentialToday)` = 15 normally; on a low-energy day with essentials it's max(5, 5 × min(3, essentialToday)); with 0 essentials it stays 15.
   - **Coins:** `RewardRules.coinsFor(nthCompletionOfGoalToday)` gives 3 when n ≤ 3, otherwise 0.
   - **Surprise gift:** `surpriseGift(Random, alreadyGiven)` returns null if a gift was already given; otherwise, with probability 0.08, a value of 5–15.
   - **Adventure:** `AdventureRules.state(energy, target, startedAt, endsAt, claimed, now)` returns one of charging, ready, away, returned or done; `endsAt(start)` = start + 6h.
   - **Growth:** `GrowthRules.stage(totalAdventures)` gives baby below 5, toddler at 5, teen at 20, adult at 60.
   - **Tests:** each boundary, with literal values.
3. **Stories content.** `assets/content/stories.json` holds about 12 original short vignettes, each with a place, text using `{petName}`/`{they}`, and optional `stages`. `StoryBook.pick(seed, stage)` is deterministic. Wired into `ContentBundle` and the validator (unknown placeholders). Tests: parse, deterministic pick, stage filter.
4. **Repositories.**
   - **`DayRepository`:** completions, undo (removes the latest completion and refunds its coins through a negative ledger entry), skip and unskip, low-energy flag, start, claim, and totals (days showed up, adventures claimed).
   - **`WalletRepository`:** the balance is the sum of the ledger, plus `add(amount, reason, refId)`.
   - **Tests:** in-memory database, literal values.
5. **`TodayController`** (`AsyncNotifier`). It builds today's view:
   - goals scheduled today (by weekday mask, not archived), each with its done count and skipped flag, grouped by section
   - energy and target, the adventure state, coins, the pet's stage, and today's story once it's back
   - **Actions:**
     - `complete(goalId)` returns `CheckOffReward(energy, coins, surprise)`
     - `undo(goalId)`, `skip(goalId)`, `setLowEnergy(bool)`
     - `startAdventure()`, `claimAdventure()`
     - `addGoals(List<GoalTemplate>)`
   - **Catch-up on load:** an earlier day that reached full energy without starting an adventure gets one started at that day's end, so nothing is lost.
   - **Tests** (FakeClock, in-memory database):
     - 3 completions bring energy to 15 and the state to ready
     - undo refunds the coins
     - the 4th completion of the same goal pays 0 coins
     - skip hides the goal without penalty
     - low-energy mode shows only essentials, with the reduced target
     - start, +6h, returned, claim: +20 coins and adventure total 1
     - the rollover catch-up
     - after 5 claimed adventures the stage is toddler
6. **Home UI.**
   - **Room:** the background with `PetView` in a state-based pose (away / happy when ready / idle).
   - **Energy card:** "8 / 15", "Ready for an adventure!" with a Start button, "Adventuring · back in 5h 59m", or "{pet} is back!" with a Hear-the-story button that opens a dialog with the story and a claim for +20 coins.
   - **Low-energy chip** and a **coins chip**.
   - **Goal list** with section headers. Tapping a goal checks it off, plays the `goal_done` effect and shows a "+5 energy · +3 coins" snackbar. A menu offers Undo and Skip today; skipped goals sit in a collapsed "Skipped" list.
   - **Add goal:** a sheet with the library grouped by area.
   - **Widget test:** check off 3 goals → "Ready for an adventure!" → Start → "Adventuring".
7. **Device check** on the emulator, with screenshots.
