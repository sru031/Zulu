import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../content/goal_library.dart';
import '../../content/story_book.dart';
import '../../core/app_day.dart';
import '../../data/db/database.dart';
import '../../data/repositories/goal_repository.dart';
import '../../domain/pet/pet_stage.dart';
import '../../domain/rules/daily_rules.dart';

/// A goal on today's list.
class TodayGoal {
  const TodayGoal(this.goal, this.doneCount);

  final Goal goal;
  final int doneCount;

  bool get done => doneCount > 0;

  GoalSection get section => GoalSection.tryParse(goal.section) ?? GoalSection.anyTime;
}

/// What a check-off earned, for the little celebration.
class CheckOffReward {
  const CheckOffReward({required this.energyGained, required this.coins, this.surprise});

  final int energyGained;
  final int coins;
  final int? surprise;
}

class TodayState {
  const TodayState({
    required this.day,
    required this.goals,
    required this.skipped,
    required this.lowEnergy,
    required this.energy,
    required this.target,
    required this.adventure,
    required this.adventureEndsAt,
    required this.story,
    required this.coins,
    required this.totalAdventures,
    required this.stage,
  });

  final AppDay day;

  /// Goals to show today, in list order.
  final List<TodayGoal> goals;
  final List<TodayGoal> skipped;
  final bool lowEnergy;
  final int energy;
  final int target;
  final AdventureState adventure;
  final DateTime? adventureEndsAt;

  /// Today's adventure story, once the pet has set off.
  final Story? story;
  final int coins;
  final int totalAdventures;
  final PetStage stage;
}

class TodayController extends AsyncNotifier<TodayState> {
  EnergyRules get _energy => EnergyRules(ref.read(contentProvider).rules);
  RewardRules get _rewards => RewardRules(ref.read(contentProvider).rules);
  AdventureTimeline get _timeline => AdventureTimeline(ref.read(contentProvider).rules);
  GrowthRules get _growth => GrowthRules(ref.read(contentProvider).rules);

  @override
  Future<TodayState> build() async {
    final today = await _today();
    await _catchUp(today);
    return _load(today);
  }

  Future<AppDay> _today() async {
    final profile = await ref.read(profileRepositoryProvider).ensure();
    return AppDay.of(ref.read(clockProvider).now(), dayStartHour: profile.dayStartHour);
  }

  bool _scheduledOn(Goal goal, AppDay day) => goal.weekdaysMask & (1 << (day.weekday - 1)) != 0;

  /// Earlier days whose energy filled (or whose adventure set off) still pay
  /// their adventure, so nothing is lost by not opening the app.
  Future<void> _catchUp(AppDay today) async {
    final days = ref.read(dayRepositoryProvider);
    final goals = await ref.read(goalRepositoryProvider).active();
    final now = ref.read(clockProvider).now();
    final profile = await ref.read(profileRepositoryProvider).ensure();
    for (final past in await days.activeDaysBefore(today)) {
      final row = await days.day(past);
      if (row.adventureClaimed) continue;
      var endsAt = row.adventureEndsAt;
      if (endsAt == null) {
        final completions = (await days.completionCounts(past)).values.fold(0, (a, b) => a + b);
        final essentials = goals.where((g) => g.essential && _scheduledOn(g, past)).length;
        final target = _energy.target(lowEnergy: row.lowEnergy, essentialToday: essentials);
        if (_energy.energy(completions: completions, target: target) < target) continue;
        final start = past.endsAt(dayStartHour: profile.dayStartHour);
        endsAt = _timeline.endsAt(start);
        await days.startAdventure(past, start: start, endsAt: endsAt, storyId: _storyFor(past, 0).id);
      }
      if (now.isBefore(endsAt)) continue;
      await days.claimAdventure(past);
      await ref.read(walletRepositoryProvider).add(ref.read(contentProvider).rules.adventure.rewardCoins, 'adventure', refId: past.key);
    }
  }

  Story _storyFor(AppDay day, int totalAdventures) => ref.read(contentProvider).stories.pick(
        seed: day.year * 10000 + day.month * 100 + day.day + totalAdventures,
        stage: _growth.stage(totalAdventures),
      );

  Future<TodayState> _load(AppDay today) async {
    final days = ref.read(dayRepositoryProvider);
    final row = await days.day(today);
    final counts = await days.completionCounts(today);
    final skippedIds = await days.skipped(today);
    final scheduled = [
      for (final g in await ref.read(goalRepositoryProvider).active())
        if (_scheduledOn(g, today)) TodayGoal(g, counts[g.id] ?? 0),
    ];
    final notSkipped = [for (final g in scheduled) if (!skippedIds.contains(g.goal.id)) g];
    final essentials = notSkipped.where((g) => g.goal.essential).length;
    final showEssentialsOnly = row.lowEnergy && essentials > 0;
    final target = _energy.target(lowEnergy: row.lowEnergy, essentialToday: essentials);
    final completions = counts.values.fold(0, (a, b) => a + b);
    final energy = _energy.energy(completions: completions, target: target);
    final totalAdventures = await days.adventuresClaimed();
    final storyId = row.storyId;
    return TodayState(
      day: today,
      goals: [for (final g in notSkipped) if (!showEssentialsOnly || g.goal.essential) g],
      skipped: [for (final g in scheduled) if (skippedIds.contains(g.goal.id)) g],
      lowEnergy: row.lowEnergy,
      energy: energy,
      target: target,
      adventure: _timeline.state(
        energy: energy,
        target: target,
        startedAt: row.adventureStartedAt,
        endsAt: row.adventureEndsAt,
        claimed: row.adventureClaimed,
        now: ref.read(clockProvider).now(),
      ),
      adventureEndsAt: row.adventureEndsAt,
      story: storyId == null ? null : ref.read(contentProvider).stories.byId(storyId),
      coins: await ref.read(walletRepositoryProvider).balance(),
      totalAdventures: totalAdventures,
      stage: _growth.stage(totalAdventures),
    );
  }

  Future<void> _refresh(AppDay day) async => state = AsyncData(await _load(day));

  Future<CheckOffReward> complete(int goalId) async {
    final current = await future;
    final days = ref.read(dayRepositoryProvider);
    final wallet = ref.read(walletRepositoryProvider);
    final nth = await days.addCompletion(goalId, current.day);
    final coins = _rewards.coinsFor(nthCompletionToday: nth);
    if (coins > 0) await wallet.add(coins, 'goal', refId: '$goalId');
    final row = await days.day(current.day);
    final gift = _rewards.surpriseGift(ref.read(randomProvider), alreadyGiven: row.surpriseGiven);
    if (gift != null) {
      await wallet.add(gift, 'surprise');
      await days.markSurprise(current.day);
    }
    await _refresh(current.day);
    return CheckOffReward(energyGained: state.requireValue.energy - current.energy, coins: coins, surprise: gift);
  }

  Future<void> undo(int goalId) async {
    final current = await future;
    final days = ref.read(dayRepositoryProvider);
    final before = (await days.completionCounts(current.day))[goalId] ?? 0;
    if (!await days.removeLatestCompletion(goalId, current.day)) return;
    final refund = _rewards.coinsFor(nthCompletionToday: before);
    if (refund > 0) await ref.read(walletRepositoryProvider).add(-refund, 'goal_undo', refId: '$goalId');
    await _refresh(current.day);
  }

  Future<void> skip(int goalId) async {
    final current = await future;
    await ref.read(dayRepositoryProvider).skip(goalId, current.day);
    await _refresh(current.day);
  }

  Future<void> unskip(int goalId) async {
    final current = await future;
    await ref.read(dayRepositoryProvider).unskip(goalId, current.day);
    await _refresh(current.day);
  }

  Future<void> setLowEnergy(bool on) async {
    final current = await future;
    await ref.read(dayRepositoryProvider).setLowEnergy(current.day, on);
    await _refresh(current.day);
  }

  Future<void> startAdventure() async {
    final current = await future;
    if (current.adventure != AdventureState.ready) return;
    final now = ref.read(clockProvider).now();
    await ref.read(dayRepositoryProvider).startAdventure(
          current.day,
          start: now,
          endsAt: _timeline.endsAt(now),
          storyId: _storyFor(current.day, current.totalAdventures).id,
        );
    await _refresh(current.day);
  }

  Future<void> claimAdventure() async {
    final current = await future;
    if (current.adventure != AdventureState.returned) return;
    await ref.read(dayRepositoryProvider).claimAdventure(current.day);
    await ref.read(walletRepositoryProvider).add(
          ref.read(contentProvider).rules.adventure.rewardCoins,
          'adventure',
          refId: current.day.key,
        );
    await _refresh(current.day);
  }

  Future<void> addGoals(List<GoalTemplate> templates) async {
    final current = await future;
    await ref.read(goalRepositoryProvider).addAll([for (final t in templates) NewGoal.fromTemplate(t)]);
    await _refresh(current.day);
  }
}

final todayControllerProvider = AsyncNotifierProvider<TodayController, TodayState>(TodayController.new);
