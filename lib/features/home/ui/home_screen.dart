import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../content/goal_library.dart';
import '../../../domain/text/template.dart';
import '../../../shared/widgets/effect_view.dart';
import '../../../theme_kit/effect_registry.dart';
import '../today_controller.dart';
import 'home_widgets.dart';

const _sectionTitles = {
  GoalSection.startOfDay: 'Start the day',
  GoalSection.anyTime: 'Any time',
  GoalSection.endOfDay: 'End the day',
};

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  var _celebrating = false;
  Timer? _celebration;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _celebration?.cancel();
    super.dispose();
  }

  /// Coming back to the app may cross into a new day or end an adventure.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) ref.invalidate(todayControllerProvider);
  }

  Future<void> _check(TodayGoal goal) async {
    final reward = await ref.read(todayControllerProvider.notifier).complete(goal.goal.id);
    if (!mounted) return;
    setState(() => _celebrating = true);
    _celebration?.cancel();
    _celebration = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _celebrating = false);
    });
    final parts = [
      if (reward.energyGained > 0) '+${reward.energyGained} energy',
      if (reward.coins > 0) '+${reward.coins} coins',
    ];
    final message = [
      if (parts.isNotEmpty) parts.join(' · ') else 'Nice one!',
      if (reward.surprise != null) 'Surprise! +${reward.surprise} coins',
    ].join('\n');
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(todayControllerProvider);
    final pet = ref.watch(petProvider).value;
    final kit = ref.watch(themeKitProvider);
    final vars = templateVars(
      userName: '',
      petName: pet?.name ?? 'your pet',
      pronouns: Pronouns.fromId(pet?.pronouns ?? 'they'),
      currency: kit.theme.currency,
      currencyPlural: kit.theme.currencyPlural,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(pet?.name ?? 'Home'),
        actions: [
          if (today.value case final s?)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                avatar: const Text('🪙'),
                label: Text('${s.coins}'),
                visualDensity: VisualDensity.compact,
              ),
            ),
        ],
      ),
      floatingActionButton: today.hasValue
          ? FloatingActionButton.extended(
              onPressed: () => showAddGoalSheet(
                context,
                ref,
                {for (final g in [...today.requireValue.goals, ...today.requireValue.skipped]) ?g.goal.libraryId},
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add goal'),
            )
          : null,
      body: switch (today) {
        AsyncData(:final value) => Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async => ref.invalidate(todayControllerProvider),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  children: [
                    RoomView(state: value, petName: pet?.name ?? 'Your pet'),
                    const SizedBox(height: 12),
                    EnergyCard(state: value, vars: vars),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilterChip(
                        label: const Text('Low-energy day'),
                        selected: value.lowEnergy,
                        onSelected: (on) => ref.read(todayControllerProvider.notifier).setLowEnergy(on),
                      ),
                    ),
                    if (value.goals.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('No goals for today. Add one whenever you like.', textAlign: TextAlign.center),
                      ),
                    for (final section in GoalSection.values)
                      if (value.goals.any((g) => g.section == section)) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
                          child: Text(_sectionTitles[section]!, style: Theme.of(context).textTheme.titleSmall),
                        ),
                        for (final g in value.goals.where((g) => g.section == section))
                          GoalTile(goal: g, onCheck: () => _check(g)),
                      ],
                    if (value.skipped.isNotEmpty)
                      ExpansionTile(
                        title: Text('Skipped today (${value.skipped.length})'),
                        children: [
                          for (final g in value.skipped) GoalTile(goal: g, skipped: true, onCheck: () {}),
                        ],
                      ),
                  ],
                ),
              ),
              if (_celebrating)
                const IgnorePointer(child: Center(child: EffectView(EffectName.goalDone, size: 180))),
            ],
          ),
        AsyncError(:final error) => Center(child: Text('Something went wrong: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
