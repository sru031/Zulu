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
    final current = await future;
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
    final current = await future;
    final plan = current.plan;
    if (plan == null) return;
    await ref.read(onboardingCompleterProvider).complete(_outcome(current.answers), [for (final p in plan) p.goal]);
  }
}

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, OnboardingState>(OnboardingController.new);
