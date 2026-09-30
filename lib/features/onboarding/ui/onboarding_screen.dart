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
