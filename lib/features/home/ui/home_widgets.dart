import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../app/zulu_theme.dart';
import '../../../content/goal_library.dart';
import '../../../domain/rules/daily_rules.dart';
import '../../../domain/text/template.dart';
import '../../../shared/widgets/pet_view.dart';
import '../../../theme_kit/pet_manifest.dart';
import '../../../theme_kit/theme_kit.dart';
import '../today_controller.dart';

/// The pet's room with the pet in a pose that matches its day.
class RoomView extends ConsumerWidget {
  const RoomView({super.key, required this.state, required this.petName});

  final TodayState state;
  final String petName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(themeKitProvider).rooms.home;
    final pose = switch (state.adventure) {
      AdventureState.away => PetPose.away,
      AdventureState.ready || AdventureState.returned => PetPose.happy,
      _ when state.energy == 0 => PetPose.sleepy,
      _ => PetPose.idle,
    };
    return AspectRatio(
      aspectRatio: room.width / room.height * 1.6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(ThemeKit.assetPath(room.background), fit: BoxFit.cover, alignment: Alignment.bottomCenter),
            Align(
              alignment: const Alignment(0, 0.9),
              child: PetView(stage: state.stage, pose: pose, size: 170, semanticLabel: petName),
            ),
          ],
        ),
      ),
    );
  }
}

/// Energy, and what the pet can do with it.
class EnergyCard extends ConsumerWidget {
  const EnergyCard({super.key, required this.state, required this.vars});

  final TodayState state;
  final Map<String, String> vars;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(todayControllerProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    final Widget body = switch (state.adventure) {
      AdventureState.charging => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Energy ${state.energy} / ${state.target}', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: state.energy / state.target,
                color: context.zuluColors.energy,
              ),
            ),
            const SizedBox(height: 6),
            Text(fillTemplate('Each goal gives {petName} energy for an adventure.', vars), style: textTheme.bodySmall),
          ],
        ),
      AdventureState.ready => Row(
          children: [
            Expanded(child: Text('Ready for an adventure!', style: textTheme.titleMedium)),
            FilledButton(onPressed: controller.startAdventure, child: const Text('Start adventure')),
          ],
        ),
      AdventureState.away => Text(
          'Adventuring · back in ${_remaining(state.adventureEndsAt!, ref.read(clockProvider).now())}',
          style: textTheme.titleMedium,
        ),
      AdventureState.returned => Row(
          children: [
            Expanded(child: Text(fillTemplate('{petName} is back!', vars), style: textTheme.titleMedium)),
            FilledButton(onPressed: () => _hearStory(context, controller), child: const Text('Hear the story')),
          ],
        ),
      AdventureState.done => Text(
          fillTemplate('{petName} is resting after visiting ${state.story?.place ?? 'somewhere new'}.', vars),
          style: textTheme.titleMedium,
        ),
    };
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: body));
  }

  static String _remaining(DateTime endsAt, DateTime now) {
    final left = endsAt.difference(now);
    if (left.isNegative) return 'any moment';
    final hours = left.inHours;
    final minutes = left.inMinutes.remainder(60);
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }

  Future<void> _hearStory(BuildContext context, TodayController controller) async {
    final story = state.story;
    final reward = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(story?.place ?? 'An adventure'),
        content: Text(fillTemplate(story?.text ?? '{petName} had a lovely time.', vars)),
        actions: [FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Collect 20 coins'))],
      ),
    );
    if (reward ?? false) await controller.claimAdventure();
  }
}

/// One goal on today's list.
class GoalTile extends ConsumerWidget {
  const GoalTile({super.key, required this.goal, required this.onCheck, this.skipped = false});

  final TodayGoal goal;
  final VoidCallback onCheck;
  final bool skipped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(todayControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final title = goal.goal.title;
    return Card(
      child: ListTile(
        leading: Text(goal.goal.icon, style: const TextStyle(fontSize: 26)),
        title: Text(
          title,
          style: goal.done ? TextStyle(color: scheme.onSurfaceVariant) : null,
        ),
        subtitle: goal.doneCount > 1 ? Text('Done ${goal.doneCount} times today') : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!skipped)
              IconButton(
                tooltip: 'Check off $title',
                onPressed: onCheck,
                icon: Icon(goal.done ? Icons.check_circle : Icons.radio_button_unchecked, color: scheme.primary, size: 30),
              ),
            PopupMenuButton<String>(
              tooltip: 'More for $title',
              onSelected: (action) => switch (action) {
                'undo' => controller.undo(goal.goal.id),
                'skip' => controller.skip(goal.goal.id),
                _ => controller.unskip(goal.goal.id),
              },
              itemBuilder: (context) => [
                if (goal.done && !skipped) const PopupMenuItem(value: 'undo', child: Text('Undo')),
                if (!skipped) const PopupMenuItem(value: 'skip', child: Text('Skip today')),
                if (skipped) const PopupMenuItem(value: 'unskip', child: Text('Bring back')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Lets the user add goals from the curated library.
Future<void> showAddGoalSheet(BuildContext context, WidgetRef ref, Set<String> alreadyAdded) async {
  final library = ref.read(contentProvider).goals;
  final picked = await showModalBottomSheet<GoalTemplate>(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      builder: (context, scroll) => ListView(
        controller: scroll,
        children: [
          const ListTile(title: Text('Add a goal', style: TextStyle(fontSize: 20))),
          for (final area in library.areas)
            ExpansionTile(
              leading: Text(area.icon, style: const TextStyle(fontSize: 22)),
              title: Text(area.label),
              children: [
                for (final g in library.inArea(area.id))
                  if (!alreadyAdded.contains(g.id))
                    ListTile(
                      leading: Text(g.icon, style: const TextStyle(fontSize: 22)),
                      title: Text(g.title),
                      onTap: () => Navigator.pop(context, g),
                    ),
              ],
            ),
        ],
      ),
    ),
  );
  if (picked != null) await ref.read(todayControllerProvider.notifier).addGoals([picked]);
}
