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
